local QBCore = exports['qb-core']:GetCoreObject()
local cam = nil
local charPed = nil
local showUi = false
local currentSequence = nil

-- Camera Animation System
local function setupCinematicCamera()
    cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
    local startPos = Config.CinematicSequences.intro[1].startPos
    local startRot = Config.CinematicSequences.intro[1].startRot
    
    SetCamCoord(cam, startPos.x, startPos.y, startPos.z)
    SetCamRot(cam, startRot.x, startRot.y, startRot.z, 2)
    SetCamActive(cam, true)
    RenderScriptCams(true, false, 1, true, true)
    
    return cam
end

local function startCinematicSequence()
    local sequence = Config.CinematicSequences.intro
    currentSequence = 1
    
    Citizen.CreateThread(function()
        for i, seq in ipairs(sequence) do
            local startTime = GetGameTimer()
            local endTime = startTime + seq.duration
            
            while GetGameTimer() < endTime do
                local progress = (GetGameTimer() - startTime) / seq.duration
                local easedProgress = easeInOutQuad(progress)
                
                local currentPos = vector3(
                    lerp(seq.startPos.x, seq.endPos.x, easedProgress),
                    lerp(seq.startPos.y, seq.endPos.y, easedProgress),
                    lerp(seq.startPos.z, seq.endPos.z, easedProgress)
                )
                
                local currentRot = vector3(
                    lerp(seq.startRot.x, seq.endRot.x, easedProgress),
                    lerp(seq.startRot.y, seq.endRot.y, easedProgress),
                    lerp(seq.startRot.z, seq.endRot.z, easedProgress)
                )
                
                SetCamCoord(cam, currentPos.x, currentPos.y, currentPos.z)
                SetCamRot(cam, currentRot.x, currentRot.y, currentRot.z, 2)
                
                Citizen.Wait(0)
            end
            
            currentSequence = i + 1
            TriggerEvent('r1mus:client:sequenceComplete', i)
        end
    end)
end

-- Character Preview System
local function createCharacterPreview(data)
    if charPed then
        DeletePed(charPed)
    end
    
    local model = data.model or `mp_m_freemode_01`
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(0)
    end
    
    charPed = CreatePed(2, model, Config.DefaultSpawn.x, Config.DefaultSpawn.y, Config.DefaultSpawn.z - 0.98, Config.DefaultSpawn.w, false, true)
    SetPedComponentVariation(charPed, 0, 0, 0, 2)
    FreezeEntityPosition(charPed, true)
    SetEntityInvincible(charPed, true)
    PlaceObjectOnGroundProperly(charPed)
    SetBlockingOfNonTemporaryEvents(charPed, true)
    
    -- Apply character customization if available
    if data.appearance then
        exports['qb-clothing']:loadPlayerClothing(data.appearance, charPed)
    end
end

-- UI Management
local function showCharacterUI(characters)
    if showUi then return end
    
    showUi = true
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = 'show',
        characters = characters,
        config = Config.UIStyle
    })
end

-- Event Handlers
RegisterNetEvent('r1mus:client:openCharacterSelection')
AddEventHandler('r1mus:client:openCharacterSelection', function(characters)
    DoScreenFadeOut(500)
    Wait(500)
    
    -- Set up initial scene
    exports['qb-weathersync']:setCustomWeather('EXTRASUNNY')
    SetTimecycleModifier('hud_def_blur')
    setupCinematicCamera()
    
    Wait(500)
    DoScreenFadeIn(1000)
    
    -- Start cinematic sequence
    startCinematicSequence()
    
    -- Show UI after initial camera movement
    Wait(2000)
    showCharacterUI(characters)
end)

-- NUI Callbacks
RegisterNUICallback('selectCharacter', function(data, cb)
    -- Handle character selection
    TriggerServerEvent('r1mus:server:selectCharacter', data.charid)
    cb('ok')
end)

RegisterNUICallback('createCharacter', function(data, cb)
    -- Handle character creation
    TriggerServerEvent('r1mus:server:createCharacter', data)
    cb('ok')
end)

RegisterNUICallback('deleteCharacter', function(data, cb)
    -- Handle character deletion with cinematic effect
    TriggerServerEvent('r1mus:server:deleteCharacter', data.charid)
    cb('ok')
end)

-- Utility Functions
function lerp(a, b, t)
    return a + (b - a) * t
end

function easeInOutQuad(t)
    return t < 0.5 and 2 * t * t or -1 + (4 - 2 * t) * t
end

-- Cleanup
AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then return end
    
    if cam then
        DestroyCam(cam, true)
        RenderScriptCams(false, false, 0, true, true)
    end
    
    if charPed then
        DeletePed(charPed)
    end
    
    SetTimecycleModifier('default')
end)

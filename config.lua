Config = {}

-- Camera Settings
Config.DefaultSpawn = vector4(-1037.66, -2737.44, 20.17, 327.68) -- LSIA Airport
Config.CameraStartPosition = vector3(-1044.77, -2746.07, 21.36)
Config.CameraEndPosition = vector3(230.72, -880.66, 30.49) -- City view from airport

-- UI Settings
Config.UIStyle = {
    primaryColor = '#3498db',
    secondaryColor = '#2ecc71',
    accentColor = '#e74c3c',
    glassEffect = true,
    particleEffects = true,
}

-- Spawn Locations
Config.SpawnLocations = {
    {
        name = 'Los Santos International',
        coords = vector4(-1037.66, -2737.44, 20.17, 327.68),
        preview = {
            startPos = vector3(-1044.77, -2746.07, 21.36),
            lookAt = vector3(-1037.66, -2737.44, 20.17),
            duration = 5000
        }
    },
    {
        name = 'Vinewood Hills',
        coords = vector4(-773.81, 351.61, 87.99, 179.65),
        preview = {
            startPos = vector3(-773.81, 341.61, 90.99),
            lookAt = vector3(-773.81, 351.61, 87.99),
            duration = 5000
        }
    }
}

-- Cinematic Settings
Config.CinematicSequences = {
    intro = {
        {
            duration = 10000,
            startPos = vector3(-1044.77, -2746.07, 350.36),
            endPos = vector3(-1044.77, -2746.07, 21.36),
            startRot = vector3(-20.0, 0.0, 150.0),
            endRot = vector3(0.0, 0.0, 150.0),
            easeType = 'inOutQuad'
        },
        {
            duration = 15000,
            startPos = vector3(-1044.77, -2746.07, 21.36),
            endPos = vector3(230.72, -880.66, 30.49),
            startRot = vector3(0.0, 0.0, 150.0),
            endRot = vector3(-20.0, 0.0, 220.0),
            easeType = 'inOutSine'
        }
    }
}

-- Appearance Settings
Config.DefaultCharacterSettings = {
    maxCharacters = 5,
    startingCash = 2500,
    startingBank = 5000,
    defaultApartment = 'alta_street'
}

-- Weather Settings
Config.WeatherStates = {
    'CLEAR',
    'EXTRASUNNY',
    'CLOUDS',
    'OVERCAST',
    'RAIN',
    'THUNDER'
}

-- Sound Settings
Config.Sounds = {
    background = {
        name = 'character_ambient',
        volume = 0.5,
        loop = true
    },
    buttonHover = {
        name = 'button_hover',
        volume = 0.2
    },
    characterSelect = {
        name = 'character_select',
        volume = 0.4
    }
}

local QBCore = exports['qb-core']:GetCoreObject()

-- Tabla de personajes en memoria (debería ser reemplazada por base de datos en producción)
local characters = {}

-- Cargar personajes del jugador
QBCore.Functions.CreateCallback('r1mus:server:getCharacters', function(source, cb)
    local src = source
    local steam = QBCore.Functions.GetIdentifier(src, 'steam')
    -- Aquí deberías consultar la base de datos real
    local result = MySQL.query.await('SELECT * FROM users WHERE steam = ?', {steam})
    cb(result or {})
end)

-- Crear personaje
RegisterNetEvent('r1mus:server:createCharacter', function(data)
    local src = source
    local steam = QBCore.Functions.GetIdentifier(src, 'steam')
    -- Guardar en base de datos
    MySQL.insert('INSERT INTO users (steam, firstname, lastname, backstory, lifestyle, cash, bank, appearance) VALUES (?, ?, ?, ?, ?, ?, ?, ?)', {
        steam,
        data.firstName,
        data.lastName,
        data.backstory or '',
        data.lifestyle or '',
        2500,
        5000,
        json.encode(data.appearance or {})
    })
    -- Opcional: recargar personajes y enviar al cliente
    TriggerClientEvent('r1mus:client:openCharacterSelection', src, {})
end)

-- Seleccionar personaje
RegisterNetEvent('r1mus:server:selectCharacter', function(charid)
    local src = source
    -- Aquí puedes cargar datos del personaje y setearlos en el jugador
    -- Por ejemplo, cargar posición, inventario, etc.
    -- Luego, enviar evento de spawn
    TriggerClientEvent('r1mus:client:spawnCharacter', src, {coords = {x = -1037.66, y = -2737.44, z = 20.17, w = 327.68}})
end)

-- Eliminar personaje
RegisterNetEvent('r1mus:server:deleteCharacter', function(charid)
    local src = source
    MySQL.update('DELETE FROM users WHERE id = ?', {charid})
    -- Opcional: recargar personajes y enviar al cliente
    TriggerClientEvent('r1mus:client:openCharacterSelection', src, {})
end)

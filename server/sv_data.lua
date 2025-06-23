-- Este archivo puede contener funciones auxiliares para la gestión de datos avanzados
-- Por ejemplo: outfits, propiedades, biografía visual, etc.

local QBCore = exports['qb-core']:GetCoreObject()

-- Ejemplo: Guardar outfit automáticamente
RegisterNetEvent('r1mus:server:saveOutfit', function(charid, outfitData)
    -- Guardar outfit en base de datos o archivo
    MySQL.update('UPDATE users SET outfits = ? WHERE id = ?', {json.encode(outfitData), charid})
end)

-- Ejemplo: Obtener propiedades del personaje
QBCore.Functions.CreateCallback('r1mus:server:getProperties', function(source, cb, charid)
    local result = MySQL.query.await('SELECT * FROM properties WHERE owner = ?', {charid})
    cb(result or {})
end)

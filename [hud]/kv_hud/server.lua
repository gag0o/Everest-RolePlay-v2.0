local Tunnel = module('vrp', 'lib/Tunnel')
local Proxy = module('vrp', 'lib/Proxy')
vRP = Proxy.getInterface('vRP')

local Config = module('kv_hud', 'config')

func = {}
Tunnel.bindInterface("kv_hud", func)


function func.getFomeSede()
    local source = source
    local playerID = vRP.getUserId(source)

    local getFomeSede = vRP.getUData(playerID, "fomeSede")
    local data = json.decode(getFomeSede)
    return data
end

function func.setFomeSede(fome, sede)
    local source = source
    local playerID = vRP.getUserId(source)

    local fomeSede = {}
    fomeSede.fome = fome
    fomeSede.sede = sede
    vRP.setUData(playerID, "fomeSede", json.encode(fomeSede))
end

RegisterServerEvent('kv_hud:getServerInfo')
AddEventHandler('kv_hud:getServerInfo', function()

    local source = source
    local playerID = vRP.getUserId(source)

    local getFomeSede = vRP.getUData(playerID, "fomeSede")
    local data = json.decode(getFomeSede)
    if data ~= nil then
        local info = {
            hunger = data.fome,
            thirst = data.sede,

        }

        TriggerClientEvent('kv_hud:setInfo', source, info)
    end
end)

AddEventHandler("vRP:playerSpawn", function(user_id, source, first_spawn)
    local getFomeSede = vRP.getUData(user_id, "fomeSede")
    if getFomeSede == nil then
        local fomeSede = {}
        fomeSede.fome = fome
        fomeSede.sede = sede
        vRP.setUData(user_id, "fomeSede", json.encode(fomeSede))
    end
end)

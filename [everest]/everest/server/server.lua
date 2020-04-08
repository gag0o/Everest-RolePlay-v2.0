local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
local Tools = module("vrp", "lib/Tools")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")
local idgens = Tools.newIDGenerator()

func = {}
Tunnel.bindInterface("everest", func)

function func.checkPermission(permisssion)
    local source = source
    local user_id = vRP.getUserId(source)
    return vRP.hasPermission(user_id, permisssion)
end

blips = {}
RegisterNetEvent("global:avisarPolicia")
AddEventHandler("global:avisarPolicia", function(msg, x, y, z, sound)
    local policia = vRP.getUsersByPermission("policia.permissao")
    for k, v in pairs(policia) do
        local player = vRP.getUserSource(parseInt(v))
        if player then
            async(function()
                local ids = idgens:gen()
                if sound == 1 then -- Ocorrencia grande
                    vRPclient.playSound(player, "Oneshot_Final",
                                        "MP_MISSION_COUNTDOWN_SOUNDSET")
                elseif sound == 2 then -- BLIP DE DROGA
                    vRPclient.playSound(player, "CONFIRM_BEEP",
                                        "HUD_MINI_GAME_SOUNDSET")
                end
                if x ~= nil then
                    blips[ids] = vRPclient.addRadiusBlip(player, x, y, z, 1,
                                                         150.0, 60)
                    SetTimeout(30000, function()
                        vRPclient.removeBlip(player, blips[ids])
                        idgens:free(ids)
                    end)
                end
                TriggerClientEvent('chatMessage', player, "911", {65, 130, 255},
                                   msg)

            end)
        end
    end
end)
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
local Tools = module("vrp", "lib/Tools")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")

func = {}
Tunnel.bindInterface("vrp_registradora", func)

local recompensa = 0

local roubando = {}


-----------------------------------------------------------------------------------------------------------------------------------------
-- TEMPO
-----------------------------------------------------------------------------------------------------------------------------------------
local timers = {}
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        for k, v in pairs(timers) do if v > 0 then timers[k] = v - 1 end end
    end
end)

function func.cancelRobbery()
	local source = source
    local user_id = vRP.getUserId(source)
    local identity_user = vRP.getUserIdentity(user_id)
	
    vRP.giveInventoryItem( user_id, "dinheirosujo", roubando[user_id].valorTotalRoubado)
    DISCORD_WEBHOOK = "https://discordapp.com/api/webhooks/676609249903640587/Pl8ZSwRrwIKpT6l12xhl9nwjs_MpUKpKBvOOdhFATcFvhFYaIkXxpou8AXEV5_X7vqa4"
    sendToDiscordCAIXA("[ROUBO EM CAIXA REGISTRADORA]", "[ID]:"..user_id.." "..identity_user.name.." "..identity_user.firstname.." \n [VALOR]:"..roubando[user_id].valorTotalRoubado, 16711680)
    roubando[user_id] = nil
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKROBBERY
-----------------------------------------------------------------------------------------------------------------------------------------
function func.checkRobbery(id, x, y, z, head)
    local source = source
    local user_id = vRP.getUserId(source)
    local identity_user = vRP.getUserIdentity(user_id)
    if user_id then
        local policia = vRP.getUsersByPermission("policia.permissao")
        if #policia > 0 then
            if timers[id] == 0 or not timers[id] then
                timers[id] = 3600
                TriggerClientEvent('iniciandoregistradora', source, head, x, y, z)
                vRPclient._playAnim(source, false, {
                    {"oddjobs@shop_robbery@rob_till", "loop"}
                }, true)
                local random = math.random(100)
                if random >= 80 then
                    vRPclient.setStandBY(source, parseInt(60))
                    TriggerEvent("global:avisarPolicia",
                                 "O roubo começou na ^1Caixa Registradora^0, dirija-se até o local e intercepte o assaltante.",
                                 x, y, z, 1)
                end

                func.VerificarValor() -- Peguei o valor por segundo do roubo

                roubando[user_id] = {
                    valorSegundo = recompensa,
                    tempoRestante = 15,
                    valorTotalRoubado = 0
                }

				async(function()
                    while roubando[user_id] ~= nil do
                        Citizen.Wait(1000)

						if roubando[user_id] ~= nil then
							if roubando[user_id].tempoRestante > 0 then

								roubando[user_id].valorTotalRoubado = roubando[user_id].valorTotalRoubado + recompensa
								roubando[user_id].tempoRestante = roubando[user_id].tempoRestante - 1

							else
								
                                vRP.giveInventoryItem( user_id, "dinheirosujo",roubando[user_id].valorTotalRoubado)
                                DISCORD_WEBHOOK = "https://discordapp.com/api/webhooks/667782629210456099/8uTBw0mKfsEfKIbp-Qt5XXJIWDwOwhMqgld2TXKVSC3qi86fAzrKXqafD56_pBmbqL0Y"
                                sendToDiscordCAIXA("[ROUBO EM CAIXA REGISTRADORA]", "[ID]:"..user_id.." "..identity_user.name.." "..identity_user.firstname.." \n [VALOR]:"..roubando[user_id].valorTotalRoubado, 16711680)
								roubando[user_id] = nil
								
							end
						end
                    end
                end)

                -- SetTimeout(10000,function()
                -- 	local valorTotal = math.random(1500, 4000)
                -- 	vRP.giveInventoryItem( user_id,"dinheirosujo", valorTotal)
                -- 	postarRouboDiscord(source, valorTotal)
                -- end)
            else
                TriggerClientEvent("Notify", source, "aviso",
                                   "A registradora está vazia, tente novamente mais tarde!")
            end
        else
            TriggerClientEvent("Notify", source, "aviso",
                               "Número insuficiente de policiais no momento para iniciar o roubo.")
        end
    end
end

function func.VerificarValor()
    local valorTotal = math.random(800, 1500)
    local valorFinal = valorTotal / 15
    recompensa = parseInt(valorFinal)
end

function sendToDiscordCAIXA(name, message, color)
    local connect = {
          {
              ["color"] = color,
              ["title"] = "".. name .."",
              ["description"] = message,
              ["footer"] = {["text"] = "Everest RolePlay"},
          }
      }
    PerformHttpRequest(DISCORD_WEBHOOK, function(err, text, headers) end, 'POST', json.encode({username = DISCORD_NAME, embeds = connect, avatar_url = DISCORD_IMAGE}), { ['Content-Type'] = 'application/json' })
end

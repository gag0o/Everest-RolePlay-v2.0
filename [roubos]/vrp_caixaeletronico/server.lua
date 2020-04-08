local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
local Tools = module("vrp", "lib/Tools")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")

local idgens = Tools.newIDGenerator()

func = {}
Tunnel.bindInterface("vrp_caixaeletronico", func)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local timers = 0
local recompensa = 0
local andamento = false
local dinheirosujo = {}
local valorTotal = 0

local caixasRoubados = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- LOCALIDADES
-----------------------------------------------------------------------------------------------------------------------------------------
local caixas = {
    [1] = {['seconds'] = 22, max = 18000, police = 2},
    [2] = {['seconds'] = 34, max = 18000, police = 2},
    [3] = {['seconds'] = 34, max = 18000, police = 2},
    [4] = {['seconds'] = 30, max = 18000, police = 2},
    [5] = {['seconds'] = 28, max = 18000, police = 2},
    [6] = {['seconds'] = 28, max = 18000, police = 2},
    [7] = {['seconds'] = 30, max = 18000, police = 2},
    [8] = {['seconds'] = 34, max = 18000, police = 2},
    [9] = {['seconds'] = 30, max = 18000, police = 2},

    [10] = {['seconds'] = 55, max = 18000, police = 2},
    [11] = {['seconds'] = 28, max = 18000, police = 2},
    [12] = {['seconds'] = 22, max = 18000, police = 2},
    [13] = {['seconds'] = 35, max = 18000, police = 2},

    [14] = {['seconds'] = 20, max = 18000, police = 5},
    [15] = {['seconds'] = 20, max = 18000, police = 5},
    [16] = {['seconds'] = 20, max = 18000, police = 5},
    [17] = {['seconds'] = 20, max = 18000, police = 5},
    [18] = {['seconds'] = 20, max = 18000, police = 5},
    [19] = {['seconds'] = 20, max = 18000, police = 5},
    [20] = {['seconds'] = 20, max = 18000, police = 5},

    [21] = {['seconds'] = 20, max = 18000, police = 2},
    [22] = {['seconds'] = 20, max = 18000, police = 2},
    [23] = {['seconds'] = 20, max = 18000, police = 2}

}
function func.VerificarValor(id)

    local valor = math.random(18000, caixas[id].max)
    
    valor = valor - 2000*caixasRoubados[id]

    local valorFinal = valor / caixas[id].seconds
    recompensa = parseInt(valorFinal)
end



-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKROBBERY
-----------------------------------------------------------------------------------------------------------------------------------------
function func.checkRobbery(id, x, y, z, head)
    local source = source
    local user_id = vRP.getUserId(source)
    local identity_user = vRP.getUserIdentity(user_id)
    local policia = vRP.getUsersByPermission("policia.permissao")
    if user_id then
        if #policia < caixas[id].police then
            TriggerClientEvent("Notify", source, "aviso",
                               "Número insuficiente de policiais no momento.",
                               8000)
        elseif (os.time() - timers) <= 600 then
            TriggerClientEvent("Notify", source, "aviso",
                                "Os caixas estão vazios, aguarde <b>" ..
                                    vRP.format(
                                       parseInt((600 - (os.time() - timers)))) ..
                                    " segundos</b> até que os civis depositem dinheiro.",
                                8000)
            --TriggerClientEvent("Notify", source, "aviso",
                              -- "Os caixas estão vazios, tente novamente mais tarde!",
                              -- 8000)
        else
            valorTotal = 0
            andamento = true
            timers = os.time()
            dinheirosujo = {}
            dinheirosujo[user_id] = caixas[id].seconds
            vRPclient.setStandBY(source, parseInt(700))

            if caixasRoubados[id] then
                caixasRoubados[id] = caixasRoubados[id] + 1
            else
                caixasRoubados[id] = 1
            end

            func.VerificarValor(id)
            ----print(caixasRoubados[id])

            TriggerEvent('vRP:isProcurado', user_id) -- Seta como procurado
            TriggerClientEvent('iniciandocaixaeletronico', source, x, y, z,
                               caixas[id].seconds, head)
            vRPclient._playAnim(source, false, {
                {"anim@heists@ornate_bank@grab_cash_heels", "grab"}
            }, true)

            TriggerEvent("global:avisarPolicia",
                         "O roubo começou no ^1Caixa Eletrônico^0, dirija-se até o local e intercepte os assaltantes.",
                         x, y, z, 1)

            SetTimeout(caixas[id].seconds * 1000, function()
                if andamento then
                    andamento = false
                    DISCORD_WEBHOOK = "https://discordapp.com/api/webhooks/676609249903640587/Pl8ZSwRrwIKpT6l12xhl9nwjs_MpUKpKBvOOdhFATcFvhFYaIkXxpou8AXEV5_X7vqa4"
                    sendToDiscordCAIXA("[ROUBO EM CAIXA ELETRONICO]", "[ID]:"..user_id.." "..identity_user.name.." "..identity_user.firstname.." \n [VALOR]:".. valorTotal, 16711680)
                    for l, w in pairs(policia) do
                        local player = vRP.getUserSource(parseInt(w))
                        if player then
                            async(function()
                                TriggerClientEvent('chatMessage', player, "911",
                                                   {65, 130, 255},
                                                   "O roubo terminou, os assaltantes estão correndo antes que vocês cheguem.")
                            end)
                        end
                    end
                end
            end)
        end
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CANCELROBBERY
-----------------------------------------------------------------------------------------------------------------------------------------
function func.cancelRobbery()
    local source = source
    local user_id = vRP.getUserId(source)
    local identity_user = vRP.getUserIdentity(user_id)

    if andamento then
        andamento = false
        local source = source
        DISCORD_WEBHOOK = "https://discordapp.com/api/webhooks/667782629210456099/8uTBw0mKfsEfKIbp-Qt5XXJIWDwOwhMqgld2TXKVSC3qi86fAzrKXqafD56_pBmbqL0Y"
                    sendToDiscordCAIXA("[ROUBO EM CAIXA ELETRONICO]","[ID]:"..user_id.."  "..identity_user.name.." "..identity_user.firstname.." \n [VALOR]:".. valorTotal, 16711680)
        local policia = vRP.getUsersByPermission("policia.permissao")
        for l, w in pairs(policia) do
            local player = vRP.getUserSource(parseInt(w))
            if player then
                async(function()
                    TriggerClientEvent('chatMessage', player, "911",
                                       {65, 130, 255},
                                       "O assaltante saiu correndo e deixou tudo para trás.")
                end)
            end
        end
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PAYMENTROBBERY
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        if andamento then
            for k, v in pairs(dinheirosujo) do
                if v > 0 then
                    dinheirosujo[k] = v - 1
                    vRP._giveInventoryItem(k, "dinheirosujo", recompensa)
                    valorTotal = valorTotal + recompensa

                    local random = math.random(0, 100)
                    if random >= 50 and random <= 51 then
                    end
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000*60*60*3)
        caixasRoubados = {}
    end
end)

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

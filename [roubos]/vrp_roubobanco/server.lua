------------------------------------------------------
----------https://github.com/DaviReisVieira-----------
------------EMAIL:VIEIRA08DAVI38@GMAIL.COM------------
---------------DISCORD: DAVI REIS #2602---------------
------------------------------------------------------
-- vRP TUNNEL/PROXY
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")

-- RESOURCE TUNNEL/PROXY
vRPrb = {}
Tunnel.bindInterface("vrp_roubobanco", vRPrb)
Proxy.addInterface("vrp_roubobanco", vRPrb)
RBclient = Tunnel.getInterface("vrp_roubobanco")

RegisterServerEvent('vrp_roubobanco:ChamadoPolicial')
AddEventHandler('vrp_roubobanco:ChamadoPolicial', function(message, coords)
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        local player = vRP.getUserSource(user_id)
        local identity_user = vRP.getUserIdentity(user_id)
        vRPclient._notify(player, "~r~A Polícia foi Alertada!")
        TriggerClientEvent('chatMessage', player, "190", {65, 130, 255},
                           "Assalto ao ^1Banco Central^0, a Polícia foi Alertada!")
                           DISCORD_WEBHOOK = "https://discordapp.com/api/webhooks/667782629210456099/8uTBw0mKfsEfKIbp-Qt5XXJIWDwOwhMqgld2TXKVSC3qi86fAzrKXqafD56_pBmbqL0Y"
                           sendToDiscordCAIXA("[ROUBO EM BANCO CENTRAL]","[ID]:"..user_id.."  "..identity_user.name.." "..identity_user.firstname , 16711680)

        TriggerEvent("global:avisarPolicia",
                     "O roubo começou no ^1Banco Central^0, dirija-se até o local e intercepte os assaltantes.",
                     nil, nil, nil, 1)

    end
end)

function vRPrb.copsonline()
    local cops = vRP.getUsersByPermission("policia.permissao")
    return #cops
end

function vRPrb.permissao()
    local source = source
    local user_id = vRP.getUserId(source)
    return vRP.hasPermission(user_id, "policia.permissao")
end

function vRPrb.getBox(bank)
    local money = Config.BankRobbery[bank].Money.Amount
    if money > 0 then
        if money >= Config.BankRobbery[bank].Money.StartMoney / 2 then
            Config.BankRobbery[bank].Money.Box = Config.Boxes.Full
        else
            Config.BankRobbery[bank].Money.Box = Config.Boxes.Half
        end
    else
        Config.BankRobbery[bank].Money.Box = Config.Boxes.Empty
    end
    box = Config.BankRobbery[bank].Money.Box
    return box
end

function vRPrb.getitem(item)
    local source = source
    local user_id = vRP.getUserId(source)
    if vRP.tryGetInventoryItem(user_id, item, 1, true) then
        return true
    else
        return false
    end
end

RegisterServerEvent('vrp_roubobanco:deleteDrill')
AddEventHandler('vrp_roubobanco:deleteDrill', function(coords)
    TriggerClientEvent('vrp_roubobanco:deleteDrillCl', -1, coords)
end)

function generateRandomMoney(src, bank)
    local xPlayer = vRP.getUserId(src)
    while true do
        local randommoney = math.random(5500, 10000)
        if Config.BankRobbery[bank].Money.Amount - randommoney >= 0 then
            Config.BankRobbery[bank].Money.Amount =
                Config.BankRobbery[bank].Money.Amount - randommoney
            vRP.giveInventoryItem( xPlayer, "dinheirosujo", randommoney, true)
            break
        end
        Wait(0)
    end
end

RegisterServerEvent('vrp_roubobanco:takeMoney')
AddEventHandler('vrp_roubobanco:takeMoney', function(bank)
    local src = source
    local xPlayer = vRP.getUserId(src)
    if Config.BankRobbery[bank].Money.Amount - 5500 >= 0 then
        generateRandomMoney(src, bank)
    else
        if Config.BankRobbery[bank].Money.Amount > 0 then
            vRP.giveInventoryItem( xPlayer, "dinheirosujo",
                                  Config.BankRobbery[bank].Money.Amount, true)

            Config.BankRobbery[bank].Money.Amount = 0
        end
    end
    TriggerClientEvent('vrp_roubobanco:updateMoney', -1, bank,
                       Config.BankRobbery[bank].Money.Amount)
end)

RegisterServerEvent('vrp_roubobanco:printFrozenDoors')
AddEventHandler('vrp_roubobanco:printFrozenDoors', function()
    for i = 1, #Config.BankRobbery do
        for j = 1, #Config.BankRobbery[i].Doors do
            local d = Config.BankRobbery[i].Doors[j]
        end
    end
end)

RegisterServerEvent('vrp_roubobanco:setDoorFreezeStatus')
AddEventHandler('vrp_roubobanco:setDoorFreezeStatus',
                function(bank, door, status)
    Config.BankRobbery[bank].Doors[door].Frozen = status
    TriggerClientEvent('vrp_roubobanco:setDoorFreezeStatusCl', -1, bank, door,
                       status)
end)

RegisterServerEvent('vrp_roubobanco:getDoorFreezeStatus')
AddEventHandler('vrp_roubobanco:getDoorFreezeStatus', function(bank, door)
    TriggerClientEvent('vrp_roubobanco:setDoorFreezeStatusCl', source, bank,
                       door, Config.BankRobbery[bank].Doors[door].Frozen)
end)

RegisterServerEvent('vrp_roubobanco:toggleSafe')
AddEventHandler('vrp_roubobanco:toggleSafe', function(bank, safe, toggle)
    Config.BankRobbery[bank].Safes[safe].Looted = toggle
    TriggerClientEvent('vrp_roubobanco:safeLooted', -1, bank, safe, toggle)
end)

RegisterServerEvent('vrp_roubobanco:lootSafe')
AddEventHandler('vrp_roubobanco:lootSafe', function(bank, safe)
    local src = source
    local xPlayer = vRP.getUserId(src)
    local randommoney = math.random(Config.SafeMinimum, Config.SafeMax)
    vRP.giveInventoryItem( xPlayer, "dinheirosujo", randommoney, false)
    vRPclient._notify(src, "Você encontrou ~g~ R$" .. randommoney .. "!")
    Config.BankRobbery[bank].Safes[safe].Looted = true
    TriggerClientEvent('vrp_roubobanco:safeLooted', -1, bank, safe, true)
end)

RegisterServerEvent('vrp_roubobanco:lootCarrinhos')
AddEventHandler('vrp_roubobanco:lootCarrinhos', function(bank, carrinho)
    local src = source
    local xPlayer = vRP.getUserId(src)
    local randommoney = math.random(Config.SafeMinimumCarrinho,
                                    Config.SafeMaxCarrinho)
    vRP.giveInventoryItem( xPlayer, "dinheirosujo", randommoney, false)
    vRPclient._notify(src, "Você encontrou ~g~ R$" .. randommoney .. "!")
    Config.BankRobbery[bank].Carrinhos[carrinho].Looted = true
    TriggerClientEvent('vrp_roubobanco:carrinhoLooted', -1, bank, carrinho, true)
end)

AddEventHandler('playerConnecting', function()
    local src = source
    for i = 1, #Config.BankRobbery do
        Wait(0)
        for j = 1, #Config.BankRobbery[i].Doors do
            Wait(0)
            TriggerClientEvent('vrp_roubobanco:setDoorFreezeStatusCl', src, i,
                               j, Config.BankRobbery[i].Doors[j].Frozen)
        end
    end
    for i = 1, #Config.BankRobbery do
        Wait(0)
        for j = 1, #Config.BankRobbery[i].Safes do
            Wait(0)
            TriggerClientEvent('vrp_roubobanco:setDoorFreezeStatusCl', src, i,
                               j, Config.BankRobbery[i].Safes[j].Looted)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        for i = 1, #Config.BankRobbery do
            Wait(0)
            for j = 1, #Config.BankRobbery[i].Doors do
                Wait(0)
                TriggerClientEvent('vrp_roubobanco:setDoorFreezeStatusCl', -1,
                                   i, j, Config.BankRobbery[i].Doors[j].Frozen)
            end
        end
        Wait(30000)
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

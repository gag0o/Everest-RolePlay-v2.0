local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRPgc = {}
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")

vRP._prepare("TchatGetMessageChannel",
             "SELECT * FROM phone_app_chat WHERE channel = @channel ORDER BY time DESC LIMIT 100")
vRP._prepare("Insert/TchatAddMessage",
             "INSERT INTO phone_app_chat (`channel`, `message`) VALUES(@channel, @message); SELECT LAST_INSERT_ID() AS id;")
vRP._prepare("Select/TchatAddMessage",
             "SELECT * from phone_app_chat WHERE `id` = @id;")

function TchatGetMessageChannel(channel, cb)
    cb(vRP.query("TchatGetMessageChannel", {channel = channel}))
end

function TchatAddMessage(channel, message)
    local Query2 = ''
    local Parameters = {['@channel'] = channel, ['@message'] = message}

    local rows, affected = vRP.query("Insert/TchatAddMessage",
                                     {channel = channel, message = message})

    local select = vRP.query("Select/TchatAddMessage", {id = rows[1].id})
    TriggerClientEvent('gcPhone:tchat_receive', -1, select[1])
end

RegisterServerEvent('gcPhone:tchat_channel')
AddEventHandler('gcPhone:tchat_channel', function(channel)
    local sourcePlayer = tonumber(source)
    TchatGetMessageChannel(channel, function(messages)
        TriggerClientEvent('gcPhone:tchat_channel', sourcePlayer, channel,
                           messages)
    end)
end)

RegisterServerEvent('gcPhone:tchat_addMessage')
AddEventHandler('gcPhone:tchat_addMessage', function(channel, message)
    TchatAddMessage(channel, message)
end)

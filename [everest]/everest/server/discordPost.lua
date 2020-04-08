local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
local Tools = module("vrp", "lib/Tools")

local vRP = Proxy.getInterface("vRP")

local timezone = -0
local Time = {}

function attHora()
    Time.hora = tonumber(os.date("%H", os.time() + timezone * 60 * 60))
    if Time.hora >= 0 and Time.hora <= 9 then Time.hora = "0" .. Time.hora end

    Time.min = tonumber(os.date("%M"))
    if Time.min >= 0 and Time.min <= 9 then Time.min = "0" .. Time.min end

    Time.seg = tonumber(os.date("%S"))
    if Time.seg >= 0 and Time.seg <= 9 then Time.seg = "0" .. Time.seg end

    Time.ano = tonumber(os.date("%Y"))
    Time.mes = tonumber(os.date("%m"))
    if Time.mes >= 0 and Time.mes <= 9 then Time.mes = "0" .. Time.mes end
    Time.dia = tonumber(os.date("%d"))
    if Time.dia >= 0 and Time.dia <= 9 then Time.dia = "0" .. Time.dia end
end

function SendWebhookMessage(webhook, title, message)
    if webhook ~= nil and webhook ~= "" then
        local connect = {
            {
                ["color"] = color,
                ["title"] = "**"..title.."**",
                ["description"] = message
                -- ["footer"] = {["text"] = "Everest-RolePlay"
            }
        }

        PerformHttpRequest(webhook, function(err, text, headers) end, 'POST',
                           json.encode({
            username = "Everest",
            embeds = connect,
            avatar_url = "https://cdn.discordapp.com/attachments/668188821166227497/676636494064255016/EVEREST.png"
        }), {['Content-Type'] = 'application/json'})
    end
end

RegisterServerEvent("everest:postarDiscord")
AddEventHandler("everest:postarDiscord", function(source, url, title, message)
    local user_id = vRP.getUserId(source)
    local identity = vRP.getUserIdentity(user_id)

    local dados = "\n[ID]: " .. user_id .. " " .. identity.name .. " " ..
                      identity.firstname .. "\n[DATA]: " .. Time.dia .. "/" ..
                      Time.mes .. " [HORA]: " .. Time.hora .. ":" .. Time.min ..
                      " \r```"

    SendWebhookMessage(url, title, "```\n" .. message .. dados)
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        attHora()
        local source = source
        local user_id = vRP.getUserId(source)
        local radios = {
            { ['permissao'] = "policia.permissao", ['radioid'] = 1 },
            { ['permissao'] = "paramedico.permissao", ['radioid'] = 3 },
            { ['permissao'] = "ballas.permissao", ['radioid'] = 4 },
            { ['permissao'] = "groove.permissao", ['radioid'] = 5 },
            { ['permissao'] = "vagos.permissao", ['radioid'] = 6 },
            { ['permissao'] = "mecanico.permissao", ['radioid'] = 7 },
            { ['permissao'] = "bennys.permissao", ['radioid'] = 8 },
            { ['permissao'] = "bahamas.permissao", ['radioid'] = 9 },
            { ['permissao'] = "mafia.permissao", ['radioid'] = 10 },
            { ['permissao'] = "mafia2.permissao", ['radioid'] = 11 },
            { ['permissao'] = "motoclub.permissao", ['radioid'] = 12 },
            { ['permissao'] = "motoclub2.permissao", ['radioid'] = 13 },
            { ['permissao'] = "moderador.permissao", ['radioid'] = 1000 },
        }
        if user_id then
            for k,v in pairs(radios) do
                --print(k,v)
                if vRP.hasPermission(user_id,v.permissao) then
                    exports["rp-radio"]:GivePlayerAccessToFrequency(v.radioid)
                end
            end
        end
    end
end)

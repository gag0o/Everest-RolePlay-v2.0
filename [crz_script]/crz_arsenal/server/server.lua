local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
local Tools = module("vrp","lib/Tools")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")

src = {}
Tunnel.bindInterface("crz_arsenal",src)

local DISCORD_WEBHOOK = "https://discordapp.com/api/webhooks/676698031063564289/8zZCPWAG9HjI6hRgtJAYgQz1GEhUVYOgc2R0f9N3-vvnqiVdv-eydjNee7pCFZYuPVXW"

function src.isPolice()
    local source = source
    local user_id = vRP.getUserId(source)
    return vRP.hasPermission(user_id, "policia.permissao")
end


function src.tryGetInventoryItem() 
	local source = source
	local user_id = vRP.getUserId(source)

	if vRP.tryGetInventoryItem(user_id, "radio", 1) then
		return true
	end

	return false
end

function src.webHook(nome) 
	local source = source
	TriggerEvent("everest:postarDiscord", source, DISCORD_WEBHOOK, "ARSENAL", "[EQUIPOU]: "..nome)
	return false
end

RegisterServerEvent('crz_arsenal:permissao')
AddEventHandler('crz_arsenal:permissao', function()
	local src = source
	local user_id = vRP.getUserId(src)
	if vRP.hasGroup(user_id,"Policia") then
		TriggerClientEvent('crz_arsenal:permissao', src)
	end
end)

RegisterServerEvent('crz_arsenal:colete')
AddEventHandler('crz_arsenal:colete', function()
	local src = source
	local user_id = vRP.getUserId(src)
	if vRP.hasGroup(user_id,"Policia") then
		local colete = 100
		vRPclient.setArmour(src,100)
		vRP.setUData(user_id,"vRP:colete", json.encode(colete))
	end
end)

local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")

emP = {}
Tunnel.bindInterface("emp_raceexplosive",emP)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNÇÕES
-----------------------------------------------------------------------------------------------------------------------------------------
local pay = {
	[1] = { ['min'] = 6000, ['max'] = 8500 },
	[2] = { ['min'] = 6000, ['max'] = 8500 },
	[3] = { ['min'] = 6000, ['max'] = 8500 },
	[4] = { ['min'] = 6000, ['max'] = 8000 },
	[5] = { ['min'] = 6800, ['max'] = 8300 },
	[6] = { ['min'] = 6000, ['max'] = 8500 },
	[7] = { ['min'] = 6100, ['max'] = 8600 },
	[8] = { ['min'] = 6800, ['max'] = 8300 },
	[9] = { ['min'] = 6200, ['max'] = 8800 },
	[10] = { ['min'] = 6300, ['max'] = 8300 }
}

function emP.paymentCheck(check,status)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local random = math.random(pay[check].min,pay[check].max)
		local policia = vRP.getUsersByPermission("policia.permissao")
		if parseInt(#policia) == 0 then
			vRP.giveInventoryItem( user_id,"dinheirosujo",parseInt(random*status))
		else
			vRP.giveInventoryItem( user_id,"dinheirosujo",parseInt((random*#policia)*status))
		end
	end
end

local racepoint = 1
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(180000)
		racepoint = math.random(#pay)
	end
end)

function emP.getRacepoint()
	return parseInt(racepoint)
end

function emP.startBombRace()
	local source = source
	local policia = vRP.getUsersByPermission("policia.permissao")
	TriggerEvent('eblips:add',{ name = "Corredor Ilegal", src = source, color = 46 })
	for l,w in pairs(policia) do
		local player = vRP.getUserSource(parseInt(w))
		if player then
			async(function()
				vRPclient.playSound(player,"Oneshot_Final","MP_MISSION_COUNTDOWN_SOUNDSET")
				TriggerClientEvent('chatMessage',player,"911",{64,64,255},"Encontramos um corredor ilegal na cidade, intercepte-o.")
			end)
			
		end
	end
end

function emP.setSearchTimer()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		vRP.searchTimer(user_id,parseInt(600))
	end
end

function emP.ticketCheck()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.tryGetInventoryItem(user_id,"ticketcorrida",1) then
			return true
		else
			TriggerClientEvent("Notify",source,"negado","Você precisa de <b>1x Race</b> para inciar esta corrida.",8000)
		end
	end
end

RegisterCommand('defuse',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"policia.permissao") then
		local nplayer = vRPclient.getNearestPlayer(source,5)
		if nplayer then
			TriggerClientEvent('emp_race:unbomb',nplayer)
			TriggerClientEvent("Notify",source,"sucesso","Você desarmou a <b>Bomba</b> com sucesso.")
		end
	end
end)

function emP.removeBombRace()
	local source = source
	TriggerEvent('eblips:remove',source)
end
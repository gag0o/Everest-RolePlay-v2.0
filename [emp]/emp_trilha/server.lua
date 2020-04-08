local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")

emP = {}
Tunnel.bindInterface("emp_trilha",emP)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNÇÕES
-----------------------------------------------------------------------------------------------------------------------------------------
local pay = {
	[1] = { ['min'] = 15, ['max'] = 25 }
}

function emP.paymentCheck(check)
	local source = source
	local user_id = vRP.getUserId(source)
	local random = math.random(pay[check].min,pay[check].max)
	if user_id then
		if vRP.giveMoney(user_id,random) then
			TriggerClientEvent("Notify",source,"sucesso","Recebeu <b>$"..random.." dólares</b>.")
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

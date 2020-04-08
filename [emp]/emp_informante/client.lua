local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
emP = Tunnel.getInterface("emp_informante")
-----------------------------------------------------------------------------------------------------------------------------------------
-- COMMAND
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("informante", function(source, args, raw)
	if emP.informantCheck() then
		-- SetNewWaypoint(-289.81,-1344.00)
    end
end)

RegisterCommand("ticket", function(source, args, raw)
	if emP.informantTicket() then
		-- SetNewWaypoint(-289.81,-1344.00)
    end
end)
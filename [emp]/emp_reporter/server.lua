local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")

RegisterCommand("cam", function(source, args, raw)
	local src = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasPermission(user_id,"weazelnews.permissao") then
			TriggerClientEvent("Cam:ToggleCam", src)
		else
			TriggerClientEvent("Notify",source,"negado","Apenas <b>Repórteres</b> tem acesso essa função.")
		end
	end
end)

RegisterCommand("bmic", function(source, args, raw)
    local src = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasPermission(user_id,"weazelnews.permissao") then
			TriggerClientEvent("Mic:ToggleBMic", src)
		else
			TriggerClientEvent("Notify",source,"negado","Apenas <b>Repórteres</b> tem acesso essa função.")
		end
	end    
end)

RegisterCommand("mic", function(source, args, raw)
    local src = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasPermission(user_id,"weazelnews.permissao") then
			TriggerClientEvent("Mic:ToggleMic", src)
		else
			TriggerClientEvent("Notify",source,"negado","Apenas <b>Repórteres</b> tem acesso essa função.")
		end
	end   
end)



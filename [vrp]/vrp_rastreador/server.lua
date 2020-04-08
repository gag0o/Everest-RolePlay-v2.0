local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")

ykP = {}
Tunnel.bindInterface("vrp_rastreador",ykP)

vRP._prepare("creative/set_rastreador","UPDATE vrp_vehicles SET rastreador = @rastreador WHERE user_id = @user_id AND vehicle = @vehicle")
vRP._prepare("creative/get_rastreador","SELECT * FROM vrp_vehicles WHERE user_id = @user_id AND vehicle = @vehicle")

RegisterServerEvent("netTravar")
AddEventHandler("netTravar", function(bcnetid, target)
	TriggerClientEvent('desativarRastreador', target, bcnetid)
end)

RegisterServerEvent("netDestravar")
AddEventHandler("netDestravar", function(bcnetid, target)
	TriggerClientEvent('destravarRastreador', target, bcnetid)
end)

RegisterServerEvent("netReativar")
AddEventHandler("netReativar", function(bcnetid, target)
	TriggerClientEvent('reativarRastreador', target, bcnetid)
end)

function ykP.checkItem(veh,vehNet,placa,vName)
	source = source
	local user_id = vRP.getUserId(source)
	local player = vRP.getUserSource(user_id)
	if vRP.tryGetInventoryItem(user_id,"rastreador",1) then
	vRP.execute("creative/set_rastreador",{ user_id = parseInt(user_id), vehicle = vName, rastreador = 1 })
		return true
	else
		TriggerClientEvent("Notify",player,"negado","Você não tem um rastreador para instalar.")
		return
	end
end

function ykP.checkRastreio(veh,vehNet,placa,vName)
	source = source
	local user_id = vRP.getUserId(source)
	local player = vRP.getUserSource(user_id)
	local status = vRP.query("creative/get_rastreador",{ user_id = parseInt(user_id), vehicle = vName })
	if status[1].rastreador ~= 0 then
		return true
	else
	return
	end
end
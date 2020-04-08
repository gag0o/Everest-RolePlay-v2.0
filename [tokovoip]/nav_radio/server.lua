local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
emP = {}
Tunnel.bindInterface("nav_radio",emP)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
function emP.checkPermission(perm,grupo)
	local source = source
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,perm) then
		TriggerClientEvent("Notify",source,"sucesso","Entrou no rádio da <b>"..grupo.."</b>.",8000)
		return true
	else
		TriggerClientEvent("Notify",source,"negado","Você não tem permissão.",8000)
		return false
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKRADIO
-----------------------------------------------------------------------------------------------------------------------------------------
function emP.checkRadio()
	local source = source
	local user_id = vRP.getUserId(source)
	if vRP.getInventoryItemAmount(user_id,"radio") >= 1 then
		return true
	else
		TriggerClientEvent("Notify",source,"importante","Você precisa comprar um <b>Rádio</b> em uma <b>Loja de Departamento</b>.",8000)
		return false
	end
end
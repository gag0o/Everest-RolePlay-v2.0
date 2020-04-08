
-- Creditos: @BADTRIP#0611
-----------------------------------------------------------------------------------------------------------------------------------------
-- importa os Utils do VRP
-----------------------------------------------------------------------------------------------------------------------------------------	
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

-----------------------------------------------------------------------------------------------------------------------------------------
-- importa os Tunneis e Proxys
-----------------------------------------------------------------------------------------------------------------------------------------	
IDDclient = Tunnel.getInterface("vrp_admin_ids")
vRPclient = Tunnel.getInterface("vRP")
vRPidd = {}
Tunnel.bindInterface("vrp_admin_ids",vRPidd)
Proxy.addInterface("vrp_admin_ids",vRPidd)
vRP = Proxy.getInterface("vRP")

-----------------------------------------------------------------------------------------------------------------------------------------
-- Retorna a permissao pro client
-----------------------------------------------------------------------------------------------------------------------------------------	
function vRPidd.getPermissao()
	local source = source
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"suporte.permissao") or vRP.hasPermission(user_id,"moderador.permissao") or vRP.hasPermission(user_id,"admin.permissao") then
		return true
	else
		return false
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- Retorna o ID pro Client
-----------------------------------------------------------------------------------------------------------------------------------------	
function vRPidd.getId(sourceplayer)
	local user_id = vRP.getUserId(sourceplayer)
	return user_id
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- Esconde os ids
-----------------------------------------------------------------------------------------------------------------------------------------	
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
emp = {}
Tunnel.bindInterface("entrega_motor",emp)
vRPclient = Tunnel.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNÇÕES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent('entrega_motor:start')
AddEventHandler('entrega_motor:start',function()
	local source = source
	TriggerClientEvent('entrega_motor:iniciar',source)
end)


local quantidade = {}
function emp.Quantidade()
	local source = source
	if quantidade[source] == nil then
		quantidade[source] = math.random(4,6)
	end
	return quantidade[source]
end

function emp.EntregarItens()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local policia = vRP.getUsersByPermission("policia.permissao")
		if vRP.tryGetInventoryItem(user_id,"motor",quantidade[source],true) then
		vRP.giveInventoryItem( user_id,"dinheirosujo",math.random(600,800)*quantidade[source])
		TriggerEvent("Notify","sucesso","Entregue com sucesso!")
		TriggerClientEvent("Notify",source,"sucesso","Entregue com sucesso!.")
		else
			TriggerClientEvent("Notify",source,"aviso","Você não tem items suficientes.")
			quantidade[source] = nil
		end
	end
end
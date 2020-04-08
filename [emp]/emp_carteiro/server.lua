local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")
func = {}
Tunnel.bindInterface("emp_carteiro",func)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNÇÕES
-----------------------------------------------------------------------------------------------------------------------------------------
function func.checkEncomendas()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.getInventoryWeight(user_id)+vRP.getItemWeight("encomenda")*3 <= vRP.getInventoryMaxWeight(user_id) then
			vRP.giveInventoryItem( user_id,"encomenda",3)
			return true
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local quantidade = {}
local quantia = 0

RegisterServerEvent('event:GetEncomenda')
AddEventHandler('event:GetEncomenda', function()
	quantia = math.random(1,3)
	TriggerClientEvent('event:SetEncomenda', source, quantia)
end)

function func.Quantidade()
	local source = source
	if quantidade[source] == nil then
		quantidade[source] = quantia
	end
end

function func.checkPayment()
	func.Quantidade()
	local source = source
	local user_id = vRP.getUserId(source)
	local pagamento = math.random(145,155)*quantidade[source]
	if user_id then
		if vRP.tryGetInventoryItem(user_id,"encomenda",quantidade[source]) then
			vRP.giveMoney(user_id,pagamento)
			quantidade[source] = nil
			TriggerClientEvent("Notify",source,"sucesso","Você recebeu <b>$"..pagamento.." dólares.</b>")
			TriggerClientEvent("vrp_sound:source",source,'coins',0.5)
			return true
		else
			TriggerClientEvent("Notify",source,"aviso","Você precisa de <b>"..quantidade[source].."x Encomendas</b>.")
		end
	end
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECK PERMISSIONS
-----------------------------------------------------------------------------------------------------------------------------------------
function func.checkPermission()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if not vRP.hasPermission(user_id,"ilegal.permissao") then
			return true
		else
			TriggerClientEvent("Notify",source,"negado","Você não tem permissão.")
			return false
		end						
	end
end
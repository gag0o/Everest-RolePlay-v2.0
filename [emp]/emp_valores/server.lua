local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")
emP = {}
Tunnel.bindInterface("emp_valores",emP)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNÇÕES
-----------------------------------------------------------------------------------------------------------------------------------------
function emP.checkMalotededinheiro()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.getInventoryWeight(user_id)+vRP.getItemWeight("malotededinheiro")*3 <= vRP.getInventoryMaxWeight(user_id) then
			if vRP.tryGetInventoryItem(user_id,"malote",3) then
				vRP.giveInventoryItem( user_id,"malotededinheiro",3)
				vRPclient._playAnim(source,false,{{"anim@heists@ornate_bank@grab_cash_heels","grab"}},true)	
				vRP._stopAnim(false)
				return true
			else
				TriggerClientEvent("Notify",source,"aviso","Você precisa de <b>3x Malote.</b>")
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local quantidade = {}
local quantia = 0

RegisterServerEvent('event:GetMalotededinheiro')
AddEventHandler('event:GetMalotededinheiro', function()
	quantia = math.random(1,3)
	TriggerClientEvent('event:SetMalotededinheiro', source, quantia)
end)

function emP.Quantidade()
	local source = source
	if quantidade[source] == nil then
		quantidade[source] = quantia
	end
end

function emP.checkPayment()
	emP.Quantidade()
	local source = source
	local user_id = vRP.getUserId(source)
	local pagamento = math.random(270,280)*quantidade[source]
	if user_id then
		if vRP.tryGetInventoryItem(user_id,"malotededinheiro",quantidade[source]) then
			vRP.giveMoney(user_id,pagamento)
			quantidade[source] = nil
			TriggerClientEvent("Notify",source,"sucesso","Você recebeu <b>$"..pagamento.." Dolares.</b>")
			TriggerClientEvent("vrp_sound:source",source,'coins',0.8)
			return true
		else
			TriggerClientEvent("Notify",source,"aviso","Você precisa de <b>"..quantidade[source].."x Malote de Dinheiro</b>.")
		end
	end
end


-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECK PERMISSIONS
-----------------------------------------------------------------------------------------------------------------------------------------
function emP.ilegal()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if not vRP.hasPermission(user_id,"ilegal.permissao") then
			return true
		else
			TriggerClientEvent("Notify",source,"negado","Você não conseguiu o emprego pois tem a <b>Ficha Suja !</b>")
			return false
		end						
	end
end
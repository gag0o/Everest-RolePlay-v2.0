local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")
emP = {}
Tunnel.bindInterface("emp_leiteiro",emP)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNÇÕES
-----------------------------------------------------------------------------------------------------------------------------------------
function emP.checkLeites()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.getInventoryWeight(user_id)+vRP.getItemWeight("garrafadeleite")*3 <= vRP.getInventoryMaxWeight(user_id) then
			if vRP.tryGetInventoryItem(user_id,"garrafavazia",3) then
				vRP.giveInventoryItem( user_id,"garrafadeleite",3)
				return true
			else
				TriggerClientEvent("Notify",source,"aviso","Você precisa de <b>3x Garrafas Vazias.</b>")
				vRP._stopAnim(false)
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local quantidade = {}
local quantia = 0

RegisterServerEvent('event:GetLeite')
AddEventHandler('event:GetLeite', function()
	quantia = math.random(7,9)
	TriggerClientEvent('event:SetLeite', source, quantia)
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
	local pagamento = math.random(65,75)*quantidade[source]
	if user_id then
		if vRP.tryGetInventoryItem(user_id,"garrafadeleite",quantidade[source]) then
			vRP.giveMoney(user_id,pagamento)
			quantidade[source] = nil
			TriggerClientEvent("Notify",source,"sucesso","Você recebeu <b>$"..pagamento.." dólares.</b>")
			TriggerClientEvent("vrp_sound:source",source,'coins',0.5)
			return true
		else
			TriggerClientEvent("Notify",source,"aviso","Você precisa de <b>"..quantidade[source].."x Garrafas de Leite</b>.")
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
			TriggerClientEvent("Notify",source,"negado","Você não tem permissão.")
			return false
		end						
	end
end
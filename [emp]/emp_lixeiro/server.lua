local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
emP = {}
Tunnel.bindInterface("emp_lixeiro",emP)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNÇÕES
-----------------------------------------------------------------------------------------------------------------------------------------
function emP.checkLixeiro()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.tryGetInventoryItem(user_id,"sacodelixo",1) then
			vRP.giveMoney(user_id,math.random(90,95))
			return true
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
function emP.checkPayment()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.getInventoryWeight(user_id)+vRP.getItemWeight("sacodelixo") <= vRP.getInventoryMaxWeight(user_id) then
			vRP.giveInventoryItem( user_id,"sacodelixo",1)
			return true
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
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
emP = {}
Tunnel.bindInterface("lenhador_coletar",emP)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNÇÕES
-----------------------------------------------------------------------------------------------------------------------------------------
function emP.Quantidade()
	return math.random(3, 3)
end

function emP.checkPayment()
	local qtd = emP.Quantidade()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.getInventoryWeight(user_id)+vRP.getItemWeight("tora")*qtd <= vRP.getInventoryMaxWeight(user_id) then
			vRP.giveInventoryItem( user_id,"tora",qtd)
			
			return qtd
		else
			return 0
		end
	end
end
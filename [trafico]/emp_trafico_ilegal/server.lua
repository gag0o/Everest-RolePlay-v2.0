local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
func = {}
Tunnel.bindInterface("emp_trafico_ilegal",func)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNÇÕES
-----------------------------------------------------------------------------------------------------------------------------------------
function func.checkPermission(perm)
	local source = source
	local user_id = vRP.getUserId(source)
	return vRP.hasPermission(user_id,perm)
end

local src = {
	[1] = { ['re'] = nil, ['reqtd'] = nil, ['item'] = "folhadecoca", ['itemqtd'] = 10 },
	[2] = { ['re'] = "folhadecoca", ['reqtd'] = 10, ['item'] = "pastadecoca", ['itemqtd'] = 10 },
	[3] = { ['re'] = "pastadecoca", ['reqtd'] = 10, ['item'] = "cocaina", ['itemqtd'] = 20 },

	[4] = { ['re'] = nil, ['reqtd'] = nil, ['item'] = "adubo", ['itemqtd'] = 10 },
	[5] = { ['re'] = "adubo", ['reqtd'] = 10, ['item'] = "fertilizante", ['itemqtd'] = 10 },
	[6] = { ['re'] = "fertilizante", ['reqtd'] = 10, ['item'] = "maconha", ['itemqtd'] = 20 },

	[7] = { ['re'] = nil, ['reqtd'] = nil, ['item'] = "metil", ['itemqtd'] = 10 },
	[8] = { ['re'] = "metil", ['reqtd'] = 10, ['item'] = "crystalmelamine", ['itemqtd'] = 10 },
	[9] = { ['re'] = "crystalmelamine", ['reqtd'] = 10, ['item'] = "metanfetamina", ['itemqtd'] = 20 },

	--[10] = { ['re'] = nil, ['reqtd'] = nil, ['item'] = "grao", ['itemqtd'] = 10 },
	[10] = { ['re'] = "graos", ['reqtd'] = 10, ['item'] = "bebidafermentada", ['itemqtd'] = 10 },
	[11] = { ['re'] = "bebidafermentada", ['reqtd'] = 10, ['item'] = "moonshine", ['itemqtd'] = 20 },

	

	
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNÇÕES CHECKPAYMENT
-----------------------------------------------------------------------------------------------------------------------------------------
function func.checkPayment(id)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if src[id].re ~= nil then
			if vRP.getInventoryWeight(user_id)+vRP.getItemWeight(src[id].item)*src[id].itemqtd <= vRP.getInventoryMaxWeight(user_id) then
				if vRP.tryGetInventoryItem(user_id,src[id].re,src[id].reqtd,false) then
					vRP.giveInventoryItem( user_id,src[id].item,src[id].itemqtd,false)
					return true
				end
			end
		else
			if vRP.getInventoryWeight(user_id)+vRP.getItemWeight(src[id].item)*src[id].itemqtd <= vRP.getInventoryMaxWeight(user_id) then
				vRP.giveInventoryItem( user_id,src[id].item,src[id].itemqtd,false)
				return true
			end
		end
	end
end
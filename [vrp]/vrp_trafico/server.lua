local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
func = {}
Tunnel.bindInterface("vrp_trafico",func)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNÇÕES
-----------------------------------------------------------------------------------------------------------------------------------------
function func.checkPermission(perm)
	local source = source
	local user_id = vRP.getUserId(source)
	return vRP.hasPermission(user_id,perm)
end

local src = {
	[1] = { ['re'] = nil, ['reqtd'] = nil, ['item'] = "adubo", ['itemqtd'] = 2 },
	[2] = { ['re'] = "adubo", ['reqtd'] = 2, ['item'] = "fertilizante", ['itemqtd'] = 2 },
	[3] = { ['re'] = "fertilizante", ['reqtd'] = 2, ['item'] = "maconha", ['itemqtd'] = 4 },

	[4] = { ['re'] = "mineriodeferro", ['reqtd'] = 40, ['item'] = "capsula", ['itemqtd'] = 40 },
	[5] = { ['re'] = "capsula", ['reqtd'] = 40, ['item'] = "polvora", ['itemqtd'] = 40 },

	[7] = { ['re'] = nil, ['reqtd'] = nil, ['item'] = "carbono", ['itemqtd'] = 40 },
	[8] = { ['re'] = "carbono", ['reqtd'] = 40, ['item'] = "ferro", ['itemqtd'] = 40 },
	[9] = { ['re'] = "ferro", ['reqtd'] = 40, ['item'] = "aco", ['itemqtd'] = 80 },
	
	[10] = { ['re'] = nil, ['reqtd'] = nil, ['item'] = "acucar", ['itemqtd'] = 2 },
	[11] = { ['re'] = "acucar", ['reqtd'] = 2, ['item'] = "xarope", ['itemqtd'] = 2 },
	[12] = { ['re'] = "xarope", ['reqtd'] = 2, ['item'] = "metanfetamina", ['itemqtd'] = 4 },
	
	[13] = { ['re'] = nil, ['reqtd'] = nil, ['item'] = "farinha", ['itemqtd'] = 2 },
	[14] = { ['re'] = "farinha", ['reqtd'] = 2, ['item'] = "po", ['itemqtd'] = 2 },
	[15] = { ['re'] = "po", ['reqtd'] = 2, ['item'] = "cocaina", ['itemqtd'] = 4 },
	
--	[16] = { ['re'] = nil, ['reqtd'] = nil, ['item'] = "carbono", ['itemqtd'] = 40 },
--	[17] = { ['re'] = "carbono", ['reqtd'] = 40, ['item'] = "ferro", ['itemqtd'] = 40 },
--	[18] = { ['re'] = "ferro", ['reqtd'] = 40, ['item'] = "aco", ['itemqtd'] = 40 },
	
	[16] = { ['re'] = "polvora", ['reqtd'] = 40, ['item'] = "wammo|WEAPON_PISTOL_MK2", ['itemqtd'] = 50 },
	[17] = { ['re'] = "polvora", ['reqtd'] = 40, ['item'] = "wammo|WEAPON_SAWNOFFSHOTGUN", ['itemqtd'] = 50 },
	[18] = { ['re'] = "polvora", ['reqtd'] = 40, ['item'] = "wammo|WEAPON_ASSAULTRIFLE", ['itemqtd'] = 50 },
	[19] = { ['re'] = "polvora", ['reqtd'] = 40, ['item'] = "wammo|WEAPON_MACHINEPISTOL", ['itemqtd'] = 50 },
	[20] = { ['re'] = "polvora", ['reqtd'] = 40, ['item'] = "wammo|WEAPON_GUSENBERG", ['itemqtd'] = 50 },
	[21] = { ['re'] = "polvora", ['reqtd'] = 40, ['item'] = "wammo|WEAPON_ASSAULTSMG", ['itemqtd'] = 50 },
	
	[22] = { ['re'] = nil, ['reqtd'] = nil, ['item'] = "carbono", ['itemqtd'] = 40 },
	[23] = { ['re'] = "carbono", ['reqtd'] = 40, ['item'] = "ferro", ['itemqtd'] = 40 },
	[24] = { ['re'] = "ferro", ['reqtd'] = 40, ['item'] = "aco", ['itemqtd'] = 40 },
	
	[25] = { ['re'] = "aco", ['reqtd'] = 3000, ['item'] = "wbody|WEAPON_PISTOL_MK2", ['itemqtd'] = 1 },
	[26] = { ['re'] = "aco", ['reqtd'] = 20000, ['item'] = "wbody|WEAPON_SAWNOFFSHOTGUN", ['itemqtd'] = 1 },
	[27] = { ['re'] = "aco", ['reqtd'] = 12000, ['item'] = "wbody|WEAPON_ASSAULTSMG", ['itemqtd'] = 1 },
	[28] = { ['re'] = "aco", ['reqtd'] = 21000, ['item'] = "wbody|WEAPON_ASSAULTRIFLE", ['itemqtd'] = 1 },
	[29] = { ['re'] = "aco", ['reqtd'] = 10000, ['item'] = "wbody|WEAPON_MACHINEPISTOL", ['itemqtd'] = 1 },
	[30] = { ['re'] = "aco", ['reqtd'] = 15000, ['item'] = "wbody|WEAPON_GUSENBERG", ['itemqtd'] = 1 },
}

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
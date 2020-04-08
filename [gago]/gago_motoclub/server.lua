-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONEXÃO
-----------------------------------------------------------------------------------------------------------------------------------------
src = {}
Tunnel.bindInterface("gago_motoclub",src)
vCLIENT = Tunnel.getInterface("gago_motoclub")
-----------------------------------------------------------------------------------------------------------------------------------------
-- ARMAS
-----------------------------------------------------------------------------------------------------------------------------------------
local armas = {
	["wbody|WEAPON_PISTOL_MK2"] = { ['price'] = 50 },
	["wbody|WEAPON_MICROSMG"] = { ['price'] = 125 },
	["wbody|WEAPON_ASSAULTSMG"] = { ['price'] = 125 },
	["wbody|WEAPON_GUSENBERG"] = { ['price'] = 125 },
	["wbody|WEAPON_SPECIALCARBINE"] = { ['price'] = 125 },
	["wbody|WEAPON_ASSAULTRIFLE"] = { ['price'] = 150 }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- ARMAS
-----------------------------------------------------------------------------------------------------------------------------------------
function src.armasList()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local itemlist = {}
		for k,v in pairs(armas) do
			table.insert(itemlist,{ index = k, name = vRP.itemNameList(k), price = parseInt(v.price) })
		end
		return itemlist
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SHOPBUY
-----------------------------------------------------------------------------------------------------------------------------------------
function src.shopBuy(index,price,amount)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.getInventoryWeight(user_id)+vRP.getItemWeight(index)*parseInt(amount) <= vRP.getInventoryMaxWeight(user_id) then
			if vRP.getPremium(user_id) then
				if vRP.tryGetInventoryItem(user_id,"pecasdearma",(price*amount)*1.0) then
					vRP.giveInventoryItem(user_id,index,parseInt(amount))
					TriggerClientEvent("Notify",source,"sucesso","Você <b>"..vRP.format(parseInt(amount)).."x "..vRP.itemNameList(index).."</b> trocou <b>x"..vRP.format(parseInt((price*amount)*1.0)).." peças de armas</b>.",8000)
				else
					TriggerClientEvent("Notify",source,"negado","Peças de arma insuficiente.",8000)
				end
			else
			    if vRP.tryGetInventoryItem(user_id,"pecasdearma",(price*amount)*1.0) then
					vRP.giveInventoryItem(user_id,index,parseInt(amount))
					TriggerClientEvent("Notify",source,"sucesso","Você <b>"..vRP.format(parseInt(amount)).."x "..vRP.itemNameList(index).."</b> trocou <b>x"..vRP.format(parseInt(price*amount)).." peças de armas</b>.",8000)
				else
					TriggerClientEvent("Notify",source,"negado","Peças de arma insuficiente.",8000)
				end
			end
		else
			TriggerClientEvent("Notify",source,"negado","<b>Mochila</b> cheia.",8000)
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKSEARCH
-----------------------------------------------------------------------------------------------------------------------------------------
function src.checkPermission()
  local source = source
  local user_id = vRP.getUserId(source)
  return vRP.hasPermission(user_id,"motoclub.permissao")
end
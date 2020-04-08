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
Tunnel.bindInterface("gago_mafia2",src)
vCLIENT = Tunnel.getInterface("gago_mafia2")
-----------------------------------------------------------------------------------------------------------------------------------------
-- C4
-----------------------------------------------------------------------------------------------------------------------------------------
local c4 = {
	["c4flare"] = { ['price'] = 200 },
	["lockpick"] = { ['price'] = 130},
	["masterpick"] = { ['price'] = 150},
	["algemas"] = { ['price'] = 120},
	["capuz"] = { ['price'] = 100}

}

-----------------------------------------------------------------------------------------------------------------------------------------
-- C4
-----------------------------------------------------------------------------------------------------------------------------------------
function src.c4List()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local itemlist = {}
		for k,v in pairs(c4) do
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
				if vRP.tryGetInventoryItem(user_id,"chavedeacesso",(price*amount)*0.95) then
					vRP.giveInventoryItem(user_id,index,parseInt(amount))
					TriggerClientEvent("Notify",source,"sucesso","Voçe <b>"..vRP.format(parseInt(amount)).."x "..vRP.itemNameList(index).."</b> Trocou <b>x"..vRP.format(parseInt((price*amount)*0.95)).."Polvora</b>.",8000)
				else
					TriggerClientEvent("Notify",source,"negado","Polvora Insuficiente",8000)
				end
			else
			    if vRP.tryGetInventoryItem(user_id,"chavedeacesso",(price*amount)*0.95) then
					vRP.giveInventoryItem(user_id,index,parseInt(amount))
					TriggerClientEvent("Notify",source,"sucesso","Voce <b>"..vRP.format(parseInt(amount)).."x "..vRP.itemNameList(index).."</b> Trocou <b>x"..vRP.format(parseInt(price*amount)).."Polvora</b>.",8000)
				else
					TriggerClientEvent("Notify",source,"negado","Chave de Acesso Insuficiente.",8000)
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
  return vRP.hasPermission(user_id,"mafia2.permissao") or vRP.hasPermission(user_id,"admin.permissao")
end
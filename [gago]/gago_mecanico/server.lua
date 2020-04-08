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
Tunnel.bindInterface("gago_mecanico",src)
vCLIENT = Tunnel.getInterface("gago_mecanico")
-----------------------------------------------------------------------------------------------------------------------------------------
-- MECANICO
-----------------------------------------------------------------------------------------------------------------------------------------
local mecanico = {
	["kitreparos"] = { ['price'] = 500 },
	["militec"] = { ['price'] = 500 },
	["ferramenta"] = { ['price'] = 50 }
}

-----------------------------------------------------------------------------------------------------------------------------------------
-- MECANICOLIST
-----------------------------------------------------------------------------------------------------------------------------------------
function src.mecanicoList()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local itemlist = {}
		for k,v in pairs(mecanico) do
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
				if vRP.tryFullPayment(user_id,parseInt(price*amount)*0.95) then
					vRP.giveInventoryItem(user_id,index,parseInt(amount))
					TriggerClientEvent("Notify",source,"sucesso","Comprou <b>"..vRP.format(parseInt(amount)).."x "..vRP.itemNameList(index).."</b> por <b>$"..vRP.format(parseInt((price*amount)*0.95)).." dólares</b>.",8000)
				else
					TriggerClientEvent("Notify",source,"negado","Dinheiro insuficiente.",8000)
				end
			else
				if vRP.tryFullPayment(user_id,parseInt(price*amount)) then
					vRP.giveInventoryItem(user_id,index,parseInt(amount))
					TriggerClientEvent("Notify",source,"sucesso","Comprou <b>"..vRP.format(parseInt(amount)).."x "..vRP.itemNameList(index).."</b> por <b>$"..vRP.format(parseInt(price*amount)).." dólares</b>.",8000)
					TriggerEvent("everest:postarDiscord", source, DISCORD_WEBHOOK,"DEPARTAMENTO","[ID]: " .. user_id .. "\n[Comprou]: " ..parseInt(amount) .. "x " ..vRP.itemNameList(index) .. "\n[VALOR] $ : " ..vRP.format(parseInt((price * amount) * 0.95)))
				else
					TriggerClientEvent("Notify",source,"negado","Dinheiro insuficiente.",8000)
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
  return vRP.hasPermission(user_id,"mecanico.permissao")
end
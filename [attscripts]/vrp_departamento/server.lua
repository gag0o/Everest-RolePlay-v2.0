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
Tunnel.bindInterface("vrp_departamento",src)
vCLIENT = Tunnel.getInterface("vrp_departamento")
-----------------------------------------------------------------------------------------------------------------------------------------
-- WEB-OKC
-----------------------------------------------------------------------------------------------------------------------------------------
local DISCORD_WEBHOOK =
    "https://discordapp.com/api/webhooks/677356002164867078/heKOjIyj77SM00pevmkXv6i8lX9JAuTyaSbBz0zypUTIt-VVu9h20l2_s6En1vZW3T9J"
-----------------------------------------------------------------------------------------------------------------------------------------
-- UTILIDADES
-----------------------------------------------------------------------------------------------------------------------------------------
local utilidades = {
	["celular"] = { ['price'] = 3000 },
	["garrafavazia"] = { ['price'] = 3 },
	["caixadepizza"] = { ['price'] = 100 },
	["racao"] = { ['price'] = 150 },
	["isca"] = { ['price'] = 50 },
	["militec"] = { ['price'] = 2500 },
	["kitreparos"] = { ['price'] = 5000 },
	["radio"] = { ['price'] = 3000 },
	["postit"] = { ['price'] = 250 },
	["semente"] = { ['price'] = 5 }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- VESTUARIO
-----------------------------------------------------------------------------------------------------------------------------------------
local vestuario = {
	["alianca"] = { ['price'] = 300 },
	["identidade"] = { ['price'] = 300 },
	["mochila"] = { ['price'] = 10000 },
	["roupas"] = { ['price'] = 5000 }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- BEBIDAS
-----------------------------------------------------------------------------------------------------------------------------------------
local bebidas = {
	["absinto"] = { ['price'] = 35 },
	["cerveja"] = { ['price'] = 10 },
	["conhaque"] = { ['price'] = 30 },
	["energetico"] = { ['price'] = 70 },
	["tequila"] = { ['price'] = 15 },
	["vodka"] = { ['price'] = 20 },
	["whisky"] = { ['price'] = 25 }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- UTILIDADESLIST
-----------------------------------------------------------------------------------------------------------------------------------------
function src.utilidadesList()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local itemlist = {}
		for k,v in pairs(utilidades) do
			table.insert(itemlist,{ index = k, name = vRP.itemNameList(k), price = parseInt(v.price) })
		end
		return itemlist
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- VESTUARIOLIST
-----------------------------------------------------------------------------------------------------------------------------------------
function src.vestuarioList()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local itemlist = {}
		for k,v in pairs(vestuario) do
			table.insert(itemlist,{ index = k, name = vRP.itemNameList(k), price = parseInt(v.price) })
		end
		return itemlist
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- BEBIDASLIST
-----------------------------------------------------------------------------------------------------------------------------------------
function src.bebidasList()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local itemlist = {}
		for k,v in pairs(bebidas) do
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
function src.checkSearch()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if not vRP.searchReturn(source,user_id) then
			return true
		end
		return false
	end
end
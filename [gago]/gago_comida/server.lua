-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONEXÃO
-----------------------------------------------------------------------------------------------------------------------------------------
src = {}
Tunnel.bindInterface("gago_comida", src)
vCLIENT = Tunnel.getInterface("gago_comida")
-----------------------------------------------------------------------------------------------------------------------------------------
-- UTILIDADES
-----------------------------------------------------------------------------------------------------------------------------------------
local utilidades = {
    ["xtudo"] = {['price'] = 100},
    ["pipoca"] = {['price'] = 70},
    ["donut"] = {['price'] = 90},
    ["hotdog"] = {['price'] = 80},
    ["sanduiche"] = {['price'] = 90},
    ["batatafrita"] = {['price'] = 70},
    ["taco"] = {['price'] = 100},
    ["chocolate"] = {['price'] = 70},
    ["macarrao"] = {['price'] = 100},
    ["churrasco"] = {['price'] = 100}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- BEBIDAS
-----------------------------------------------------------------------------------------------------------------------------------------
local bebidas = {
    ["agua"] = {['price'] = 90},
    ["fanta"] = {['price'] = 90},
    ["cocacola"] = {['price'] = 120},
    ["milkshake"] = {['price'] = 90},
    ["cafe"] = {['price'] = 80}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- UTILIDADESLIST
-----------------------------------------------------------------------------------------------------------------------------------------
function src.utilidadesList()
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        local itemlist = {}
        for k, v in pairs(utilidades) do
            table.insert(itemlist, {
                index = k,
                name = vRP.itemNameList(k),
                price = parseInt(v.price)
            })
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
        for k, v in pairs(bebidas) do
            table.insert(itemlist, {
                index = k,
                name = vRP.itemNameList(k),
                price = parseInt(v.price)
            })
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
					TriggerEvent("everest:postarDiscord", source, DISCORD_WEBHOOK,"COMIDA","[ID]: " .. user_id .. "\n[Comprou]: " ..parseInt(amount) .. "x " ..vRP.itemNameList(index) .. "\n[VALOR] $ : " ..vRP.format(parseInt((price * amount) * 0.95)))
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
        if not vRP.searchReturn(source, user_id) then return true end
        return false
    end
end

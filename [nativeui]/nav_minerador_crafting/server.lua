local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- ARRAY
-----------------------------------------------------------------------------------------------------------------------------------------
local valores = {
	["ferro"] = { venda = 110 },
	["bronze"] = { venda = 150 },
	["ouro"] = { venda = 200 },
	["rubi"] = { venda = 300 },
	["diamante"] = { venda = 400 }

}
-----------------------------------------------------------------------------------------------------------------------------------------
-- CRAFTING
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("minerador-crafting")
AddEventHandler("minerador-crafting",function(item)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.tryGetInventoryItem(user_id,item,3) then
			vRP.giveInventoryItem(user_id,item.."2",1)
			TriggerClientEvent("Notify",source,"sucesso","Forjou <b>3x "..vRP.getItemName(item).."</b> em <b>1x "..vRP.getItemName(item.."2").."</b>.")
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VENDER
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("minerador-vender")
AddEventHandler("minerador-vender",function(item)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.tryGetInventoryItem(user_id,item.."2",1) then
			TriggerClientEvent("Notify",source,"sucesso","Vendeu <b>1x "..vRP.getItemName(item.."2").."</b> por <b>$"..parseInt(valores[item].venda).."x dólares</b>.")
			vRP.giveMoney(user_id,valores[item].venda)
		end
	end
end)
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- ARRAY
-----------------------------------------------------------------------------------------------------------------------------------------
local valores = {
	{ item = "carnedecormorao", venda = 140 },
	{ item = "carnedecorvo", venda = 140 },
	{ item = "carnedeaguia", venda = 140 },
	{ item = "carnedecervo", venda = 180 },
	{ item = "carnedecoelho", venda = 190 },
	{ item = "carnedecoyote", venda = 200 },
	{ item = "carnedelobo", venda = 240 },
	{ item = "carnedepuma", venda = 240 },
	{ item = "carnedejavali", venda = 200 },
	{ item = "etiqueta", venda = 200 }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- VENDER
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("cacador-vender")
AddEventHandler("cacador-vender",function(item)
	local source = source
	local user_id = vRP.getUserId(source)
	local quantidade = 0
	local data = vRP.getUserDataTable(user_id)
	if data and data.inventory then
		for k,v in pairs(valores) do
			if item == v.item then
				for i,o in pairs(data.inventory) do
					if i == item then
						quantidade = o.amount
					end
				end
				if parseInt(quantidade) > 0 then
					if vRP.tryGetInventoryItem(user_id,v.item,quantidade) then
						vRP.giveMoney(user_id,parseInt(v.venda*quantidade))
						TriggerClientEvent("Notify",source,"sucesso","Vendeu <b>"..quantidade.."x "..vRP.getItemName(v.item).."</b> por <b>$"..vRP.format(parseInt(v.venda*quantidade)).." dólares</b>.")
					end
				else
					TriggerClientEvent("Notify",source,"negado","Não possui <b>"..vRP.getItemName(v.item).."s</b> em sua mochila.")
				end
			end
		end
	end
end)
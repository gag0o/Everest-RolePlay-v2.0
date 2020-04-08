-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
local Tools = module("vrp","lib/Tools")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")
local idgens = Tools.newIDGenerator()
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONEXÃO
-----------------------------------------------------------------------------------------------------------------------------------------
src = {}
Tunnel.bindInterface("vrp_robnpcs",src)
vCLIENT = Tunnel.getInterface("vrp_robnpcs")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local pedlist = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- PEDLIST
-----------------------------------------------------------------------------------------------------------------------------------------
function src.checkPedlist(npc)
	if pedlist[npc] then
		return true
	else
		return false
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PRESSEDPEDLIST
-----------------------------------------------------------------------------------------------------------------------------------------
function src.pressedPedlist(npc)
	pedlist[npc] = true
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ITEMLIST
-----------------------------------------------------------------------------------------------------------------------------------------
local itemlist = {
	[1] = { ['index'] = "carteiraroubada", ['qtd'] = 1, ['name'] = "Carteira" },
	[2] = { ['index'] = "tabletroubado", ['qtd'] = 1, ['name'] = "Tablet" },
	[3] = { ['index'] = "sapatosroubado", ['qtd'] = 1, ['name'] = "Sapatos" },
	[4] = { ['index'] = "perfumeroubado", ['qtd'] = 1, ['name'] = "Perfume" },
	[5] = { ['index'] = "maquiagemroubada", ['qtd'] = 1, ['name'] = "Maquiagem" },
	[6] = { ['index'] = "dinheirosujo", ['qtd'] = 50, ['name'] = "Dinheiro Sujo" },
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKPAYMENT
-----------------------------------------------------------------------------------------------------------------------------------------
function src.checkPayment()
	local source = source
	local user_id = vRP.getUserId(source)
	local x,y,z = vRPclient.getPosition(source)
	if user_id then
		local randlist = math.random(100)
		if randlist >= 40 and randlist <= 89 then
			local randitem = math.random(#itemlist)
			vRP.giveInventoryItem( user_id,itemlist[randitem].index,itemlist[randitem].qtd)
			TriggerClientEvent("Notify",source,"sucesso","Você recebeu "..itemlist[randitem].qtd.."x <b>"..itemlist[randitem].name.."</b>.")
		elseif randlist >= 80 then
			
			TriggerEvent("global:avisarPolicia",
			"Recebemos uma denuncia de roubo, verifique o ocorrido.",x, y, z, 1)
		end
		local randmoney = math.random(90,250)
		vRP.giveMoney(user_id,parseInt(randmoney))
		TriggerClientEvent("Notify",source,"sucesso","Recebeu <b>$"..parseInt(randmoney).."Dolares</b>.")
	end
end
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")

emP = {}
Tunnel.bindInterface("emp_informante", emP)

function emP.informantCheck()
	local source = source
	local user_id = vRP.getUserId(source)
	local policia = vRP.getUsersByPermission("policia.permissao")
	if user_id then
		  if vRP.tryGetInventoryItem(user_id,"contatoinformante",1) then
	        vRP.tryFullPayment(user_id,5000) 
			TriggerClientEvent("Notify",source,"sucesso","Você utilizou o seu <b>Contato do Informante e pagou 5.000 Dolares.</b>",8000)
			TriggerClientEvent("Notify",source,"sucesso","Você utilizou o seu <b>Contato do Informante</b> para saber a quantidade de Policiais em serviço.",8000)
			TriggerClientEvent("Notify",source,"importante","Policiais em serviço: "..#policia,8000)
			return true
		else
			TriggerClientEvent("Notify",source,"negado","Você não possui o Contato de um <b>informante</b> ou não tem dinheiro suficente, consiga ele vendendo drogas.",8000)
		end
	end
end

function emP.informantTicket()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		  if vRP.giveInventoryItem( user_id,"ticketcorrida",5) then
			TriggerClientEvent("Notify",source,"sucesso","Você recebeu <b>5 Ticket de Corrida.</b>",8000)
			return true
		else
			TriggerClientEvent("Notify",source,"negado","Você não possui o Contato para pega os ticket",8000)
		end
	end
end
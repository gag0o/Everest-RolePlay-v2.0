local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
func = {}
Tunnel.bindInterface("vrp_motoclub",func)

RegisterServerEvent("motoclub-comprar")
AddEventHandler("motoclub-comprar",function(item)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		for k,v in pairs(Config.valores) do
			if item == v.item then

				local tempo = 0
				local isArma = false
				if v.componentes then
					for k2,v2 in pairs(v.componentes) do -- VERIFICA SE TEM TODOS OS ITTENS
						if vRP.getInventoryItemAmount(user_id, v2.componente) >= v2.qtd then
							tempo = tempo+v2.qtd
						else
							TriggerClientEvent("Notify",source,"negado","Você não possui "..vRP.getItemName(v2.componente).." suficiente!")
							return false
						end
					end
					for k2,v2 in pairs(v.componentes) do -- SE TEM TODOS OS ITENS, TIRA ELES DO INVENTARIO
						vRP.tryGetInventoryItem(user_id, v2.componente, v2.qtd)
					end
					isArma = true
				else
					tempo = 2
					isArma = false
				end

				

				if vRP.getInventoryWeight(user_id)+vRP.getItemWeight(v.item)*v.qtd <= vRP.getInventoryMaxWeight(user_id) then						

						TriggerClientEvent("vrp_motoclub:fecharMenu", source)
						TriggerClientEvent("progress",source,tempo*200,"CRIANDO ARMAR")
						TriggerClientEvent("vrp_motoclub:animacao",source, true)
						Citizen.Wait(tempo*200)
						TriggerClientEvent("vrp_motoclub:animacao",source, false)

			
						if not isArma then
							if vRP.tryPayment(user_id,parseInt(v.compra)) then
								vRP.giveInventoryItem(user_id,v.item,parseInt(v.qtd))
								TriggerClientEvent("Notify",source,"sucesso","Comprou <b>"..parseInt(v.qtd).."x "..vRP.getItemName(v.item).."</b> por <b>$"..vRP.format(parseInt(v.compra)).." dólares</b>.")
							else
								TriggerClientEvent("Notify",source,"negado","Dinheiro insuficiente.")
							end
						else
							vRP.giveInventoryItem(user_id,v.item,parseInt(v.qtd))
							TriggerClientEvent("Notify",source,"sucesso","Você recebeu <b>"..parseInt(v.qtd).."x "..vRP.getItemName(v.item).."</b>")
						end
						
				else
					TriggerClientEvent("Notify",source,"negado","Espaço insuficiente.")
				end
			end
		end



		
	end
end)

function func.checkPermission()
	local source = source
	local user_id = vRP.getUserId(source)
    return vRP.hasPermission(user_id,"motoclub.permissao") or vRP.hasPermission(user_id,"motoclub2.permissao") 
end

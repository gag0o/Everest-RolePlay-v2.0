local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
emP = {}
Tunnel.bindInterface("emp_farm_guetos",emP)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PERMISSAO 
-----------------------------------------------------------------------------------------------------------------------------------------
function emP.checkPermission()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasPermission(user_id,"ballas.permissao") or vRP.hasPermission(user_id,"groove.permissao") or vRP.hasPermission(user_id,"vagos.permissao") or vRP.hasPermission(user_id,"mafia2.permissao")  then
			return true
		else
			TriggerClientEvent("Notify",source,"negado","Você não tem acesso.")
			return false
		end						
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECK PAGAMENTO 
-----------------------------------------------------------------------------------------------------------------------------------------
function emP.checkPayment()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasPermission(user_id,"ballas.permissao") then
			local itens = math.random(100)
			local quantidade = math.random(18,25)
			local pagamento = math.random(18,25)*quantidade
			if itens <= 100 then
				if vRP.getInventoryWeight(user_id)+vRP.getItemWeight("folhadecoca")*quantidade <= vRP.getInventoryMaxWeight(user_id) then
					quantidade = math.random(18,25)
					vRP.giveInventoryItem( user_id,"folhadecoca",quantidade)
					--vRP.giveInventoryItem( user_id,"dinheirosujo",pagamento)
					TriggerClientEvent("Notify",source,"sucesso","Você coletou <b>"..quantidade.."x Folha de Coca.</b>")
					--TriggerClientEvent("Notify",source,"sucesso","Você recebeu <b>$"..pagamento.." Dolares</b>.")
					TriggerClientEvent("vrp_sound:source",source,'coins',0.5)
				else
					TriggerClientEvent("Notify",source,"negado","<b>Mochila</b> cheia.",8000)
				end
			end	

		elseif vRP.hasPermission(user_id,"groove.permissao") then
			local itens = math.random(100)
			local quantidade = math.random(18,25)
			local pagamento = math.random(18,25)*quantidade
			if itens <= 100 then
				if vRP.getInventoryWeight(user_id)+vRP.getItemWeight("adubo")*quantidade <= vRP.getInventoryMaxWeight(user_id) then
					quantidade = math.random(18,25)
					vRP.giveInventoryItem( user_id,"adubo",quantidade)
					--vRP.giveInventoryItem( user_id,"dinheirosujo",pagamento)
					TriggerClientEvent("Notify",source,"sucesso","Você coletou <b>"..quantidade.."x Adubo.</b>")
					--TriggerClientEvent("Notify",source,"sucesso","Você recebeu <b>$"..pagamento.." Dolares</b>.")
					TriggerClientEvent("vrp_sound:source",source,'coins',0.5)
				else
					TriggerClientEvent("Notify",source,"negado","<b>Mochila</b> cheia.",8000)
				end
			end			

		elseif vRP.hasPermission(user_id,"vagos.permissao") then
			local itens = math.random(100)
			local quantidade = math.random(18,25)
			local pagamento = math.random(18,25)*quantidade
			if itens <= 100 then
				if vRP.getInventoryWeight(user_id)+vRP.getItemWeight("metil")*quantidade <= vRP.getInventoryMaxWeight(user_id) then
					quantidade = math.random(18,25)
					vRP.giveInventoryItem( user_id,"metil",quantidade)
					--vRP.giveInventoryItem( user_id,"dinheirosujo",pagamento)
					TriggerClientEvent("Notify",source,"sucesso","Você coletou <b>"..quantidade.."x Metil.</b>")
					--TriggerClientEvent("Notify",source,"sucesso","Você recebeu <b>$"..pagamento.." Dolares</b>.")
					TriggerClientEvent("vrp_sound:source",source,'coins',0.5)
				else
					TriggerClientEvent("Notify",source,"negado","<b>Mochila</b> cheia.",8000)
				end
			end	

		elseif vRP.hasPermission(user_id,"crips.permissao") then
			local itens = math.random(100)
			local quantidade = math.random(18,25)
			local pagamento = math.random(18,25)*quantidade
			if itens <= 100 then
				if vRP.getInventoryWeight(user_id)+vRP.getItemWeight("chavedeacesso")*quantidade <= vRP.getInventoryMaxWeight(user_id) then
					quantidade = math.random(18,25)
					vRP.giveInventoryItem( user_id,"chavedeacesso",quantidade)
					--vRP.giveInventoryItem( user_id,"dinheirosujo",pagamento)
					TriggerClientEvent("Notify",source,"sucesso","Você coletou <b>"..quantidade.."x Chave de Acesso.</b>")
					--TriggerClientEvent("Notify",source,"sucesso","Você recebeu <b>$"..pagamento.." Dolares</b>.")
					TriggerClientEvent("vrp_sound:source",source,'coins',0.5)
				else
					TriggerClientEvent("Notify",source,"negado","<b>Mochila</b> cheia.",8000)
				end
			end	

		elseif vRP.hasPermission(user_id,"vanilla.permissao") then
			local itens = math.random(100)
			local quantidade = math.random(18,25)
			local pagamento = math.random(18,25)*quantidade
			if itens <= 100 then
				if vRP.getInventoryWeight(user_id)+vRP.getItemWeight("chavedeacesso")*quantidade <= vRP.getInventoryMaxWeight(user_id) then
					quantidade = math.random(18,25)
					vRP.giveInventoryItem( user_id,"chavedeacesso",quantidade)
					--vRP.giveInventoryItem( user_id,"dinheirosujo",pagamento)
					TriggerClientEvent("Notify",source,"sucesso","Você coletou <b>"..quantidade.."x Chave de Acesso.</b>")
					--TriggerClientEvent("Notify",source,"sucesso","Você recebeu <b>$"..pagamento.." Dolares</b>.")
					TriggerClientEvent("vrp_sound:source",source,'coins',0.5)
				else
					TriggerClientEvent("Notify",source,"negado","<b>Mochila</b> cheia.",8000)
				end
			end	

		elseif vRP.hasPermission(user_id,"bloods.permissao") then
			local itens = math.random(100)
			local quantidade = math.random(18,25)
			local pagamento = math.random(18,25)*quantidade
			if itens <= 100 then
				if vRP.getInventoryWeight(user_id)+vRP.getItemWeight("chavedeacesso")*quantidade <= vRP.getInventoryMaxWeight(user_id) then
					quantidade = math.random(18,25)
					vRP.giveInventoryItem( user_id,"chavedeacesso",quantidade)
					--vRP.giveInventoryItem( user_id,"dinheirosujo",pagamento)
					TriggerClientEvent("Notify",source,"sucesso","Você coletou <b>"..quantidade.."x Chave de Acesso.</b>")
					--TriggerClientEvent("Notify",source,"sucesso","Você recebeu <b>$"..pagamento.." Dolares</b>.")
					TriggerClientEvent("vrp_sound:source",source,'coins',0.5)
				else
					TriggerClientEvent("Notify",source,"negado","<b>Mochila</b> cheia.",8000)
				end
			end	

		elseif vRP.hasPermission(user_id,"mafia2.permissao") then
			local itens = math.random(100)
			local quantidade = math.random(10,20)
			local pagamento = math.random(50,50)*quantidade
			if itens <= 25 then
				if vRP.getInventoryWeight(user_id)+vRP.getItemWeight("chavedeacesso")*quantidade <= vRP.getInventoryMaxWeight(user_id) then
					quantidade = math.random(10,20)
					vRP.giveInventoryItem( user_id,"chavedeacesso",quantidade)
					---vRP.giveInventoryItem( user_id,"dinheirosujo",pagamento)
					TriggerClientEvent("Notify",source,"sucesso","Você coletou <b>"..quantidade.."x Chave de Acesso.</b>")
					--TriggerClientEvent("Notify",source,"sucesso","Você recebeu <b>$"..pagamento.."Dinheiro Sujo</b>.")
					TriggerClientEvent("vrp_sound:source",source,'coins',0.5)
				else
					TriggerClientEvent("Notify",source,"negado","<b>Mochila</b> cheia.",8000)
				end
			end

			if itens > 26 and itens <= 100 then
				if vRP.getInventoryWeight(user_id)+vRP.getItemWeight("cartaoclonado")*quantidade <= vRP.getInventoryMaxWeight(user_id) then
					quantidade = math.random(5,10)
					vRP.giveInventoryItem( user_id,"cartaoclonado",quantidade)
					--vRP.giveInventoryItem( user_id,"dinheirosujo",pagamento)
					TriggerClientEvent("Notify",source,"sucesso","Você coletou <b>"..quantidade.."x Cartão clonado.</b>")
					--TriggerClientEvent("Notify",source,"sucesso","Você recebeu <b>$"..pagamento.." Dinheiro Sujo</b>.")
					TriggerClientEvent("vrp_sound:source",source,'coins',0.5)
				else
					TriggerClientEvent("Notify",source,"negado","<b>Mochila</b> cheia.",8000)
				end
			end	

		elseif vRP.hasPermission(user_id,"liberty.permissao") then
			local itens = math.random(100)
			local quantidade = math.random(18,25)
			local pagamento = math.random(1,5)*quantidade
			if itens <= 100 then
				if vRP.getInventoryWeight(user_id)+vRP.getItemWeight("yellowcard")*quantidade <= vRP.getInventoryMaxWeight(user_id) then
					quantidade = math.random(18,25)
					vRP.giveInventoryItem( user_id,"yellowcard",quantidade)
					vRP.giveInventoryItem( user_id,"dinheirosujo",pagamento)
					TriggerClientEvent("Notify",source,"sucesso","Você coletou <b>"..quantidade.."x  Yellow Card.</b>")
					TriggerClientEvent("Notify",source,"sucesso","Você recebeu <b>$"..pagamento.." Dolares</b>.")
					TriggerClientEvent("vrp_sound:source",source,'coins',0.5)
				else
					TriggerClientEvent("Notify",source,"negado","<b>Mochila</b> cheia.",8000)
				end
			end	

		elseif vRP.hasPermission(user_id,"bahamas.permissao") then
			local itens = math.random(100)
			local quantidade = math.random(18,25)
			local pagamento = math.random(18,25)*quantidade
			if itens <= 100 then
				if vRP.getInventoryWeight(user_id)+vRP.getItemWeight("graos")*quantidade <= vRP.getInventoryMaxWeight(user_id) then
					quantidade = math.random(18,25)
					vRP.giveInventoryItem( user_id,"graos",quantidade)
					TriggerClientEvent("Notify",source,"sucesso","Você coletou <b>"..quantidade.."x Grãos.</b>")
					TriggerClientEvent("vrp_sound:source",source,'coins',0.5)
				else
					TriggerClientEvent("Notify",source,"negado","<b>Mochila</b> cheia.",8000)
				end
			end


		end
		return true			
	end
end
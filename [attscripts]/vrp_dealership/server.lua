-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- WEB-EVEREST
-----------------------------------------------------------------------------------------------------------------------------------------
local DISCORD_WEBHOOK = "https://discordapp.com/api/webhooks/676627119790620675/k6O6lKiRWsKyscX47hvdaV97gkoXi72sB8Sle4OlFaODCTH4po796RhHniUYq9kSZwya"
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONEXÃO
-----------------------------------------------------------------------------------------------------------------------------------------
src = {}
Tunnel.bindInterface("vrp_dealership",src)
vCLIENT = Tunnel.getInterface("vrp_dealership")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local motos = {}
local carros = {}
local import = {}
local premiums = {}
vRP._prepare("creative/get_users","SELECT * FROM vrp_users WHERE id = @user_id")
-----------------------------------------------------------------------------------------------------------------------------------------
-- SYSTEM
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	for k,v in pairs(vRP.vehicleGlobal()) do
		local vehicle = vRP.query("creative/get_estoque",{ vehicle = k })
		if vehicle[1] and parseInt(vehicle[1].quantidade) > 0 then
			if v[4] == "carros" then
				table.insert(carros,{ k = k, nome = v[1], price = v[3], chest = parseInt(v[2]), stock = parseInt(vehicle[1].quantidade) })
			elseif v[4] == "motos" then
				table.insert(motos,{ k = k, nome = v[1], price = v[3], chest = parseInt(v[2]), stock = parseInt(vehicle[1].quantidade) })
			elseif v[4] == "import" then
				table.insert(import,{ k = k, nome = v[1], price = v[3], chest = parseInt(v[2]), stock = parseInt(vehicle[1].quantidade) })
			elseif v[4] == "premiums" then
				table.insert(premiums,{ k = k, nome = v[1], price = v[3], chest = parseInt(v[2]), stock = parseInt(vehicle[1].quantidade) })
			end
		end
		Citizen.Wait(10)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATEVEHICLES
-----------------------------------------------------------------------------------------------------------------------------------------
function src.updateVehicles(vname,vehtype)
	local vehicle = vRP.query("creative/get_estoque",{ vehicle = tostring(vname) })
	if vehicle[1] then
		if vehtype == "carros" then
			if parseInt(vehicle[1].quantidade) <= 0 then
				for k,v in pairs(carros) do
					if v.k == vname then
						table.remove(carros,k)
					end
				end
			else
				for k,v in pairs(carros) do
					if v.k == vname then
						table.remove(carros,k)
					end
				end
				table.insert(carros,{ k = vname, nome = vRP.vehicleName(vname), price = vRP.vehiclePrice(vname), chest = parseInt(vRP.vehicleChest(vname)), stock = parseInt(vehicle[1].quantidade) })
			end
		elseif vehtype == "motos" then
			if parseInt(vehicle[1].quantidade) <= 0 then
				for k,v in pairs(motos) do
					if v.k == vname then
						table.remove(motos,k)
					end
				end
			else
				for k,v in pairs(motos) do
					if v.k == vname then
						table.remove(motos,k)
					end
				end
				table.insert(motos,{ k = vname, nome = vRP.vehicleName(vname), price = vRP.vehiclePrice(vname), chest = parseInt(vRP.vehicleChest(vname)), stock = parseInt(vehicle[1].quantidade) })
			end
		elseif vehtype == "import" then
			if parseInt(vehicle[1].quantidade) <= 0 then
				for k,v in pairs(import) do
					if v.k == vname then
						table.remove(import,k)
					end
				end
			else
				for k,v in pairs(import) do
					if v.k == vname then
						table.remove(import,k)
					end
				end
				table.insert(import,{ k = vname, nome = vRP.vehicleName(vname), price = vRP.vehiclePrice(vname), chest = parseInt(vRP.vehicleChest(vname)), stock = parseInt(vehicle[1].quantidade) })
			end
		elseif vehtype == "premiums" then
			if parseInt(vehicle[1].quantidade) <= 0 then
				for k,v in pairs(premiums) do
					if v.k == vname then
						table.remove(premiums,k)
					end
				end
			else
				for k,v in pairs(premiums) do
					if v.k == vname then
						table.remove(premiums,k)
					end
				end
				table.insert(premiums,{ k = vname, nome = vRP.vehicleName(vname), price = vRP.vehiclePrice(vname), chest = parseInt(vRP.vehicleChest(vname)), stock = parseInt(vehicle[1].quantidade) })
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CARROS
-----------------------------------------------------------------------------------------------------------------------------------------
function src.Carros()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		return carros
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- MOTOS
-----------------------------------------------------------------------------------------------------------------------------------------
function src.Motos()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		return motos
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- IMPORT
-----------------------------------------------------------------------------------------------------------------------------------------
function src.Import()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		return import
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- IMPORT
-----------------------------------------------------------------------------------------------------------------------------------------
function src.Premiums()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		return premiums
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- VENDAS
-----------------------------------------------------------------------------------------------------------------------------------------
function src.Possuidos()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local veiculos = {}
		local vehicle = vRP.query("creative/get_vehicle",{ user_id = parseInt(user_id) })
		for k,v in pairs(vehicle) do
			table.insert(veiculos,{ k = v.vehicle, nome = vRP.vehicleName(v.vehicle), price = parseInt(vRP.vehiclePrice(v.vehicle)*0.5), chest = parseInt(vRP.vehicleChest(v.vehicle)) })
		end
		return veiculos
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- BUYDEALER
-----------------------------------------------------------------------------------------------------------------------------------------
function src.buyDealer(name)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local maxvehs = vRP.query("creative/con_maxvehs",{ user_id = parseInt(user_id) })
		local maxgars = vRP.query("creative/get_users",{ user_id = parseInt(user_id) })
		
		if vRP.hasPermission(user_id,"conce.permissao") then
			if parseInt(maxvehs[1].qtd) >= parseInt(maxgars[1].garagem) + 10 then
				TriggerClientEvent("Notify",source,"importante","Atingiu o número máximo de veículos em sua garagem.",8000)
				return
			end
		elseif vRP.hasPermission(user_id,"diamante.permissao") then
			if parseInt(maxvehs[1].qtd) >= parseInt(maxgars[1].garagem) + 10 then
				TriggerClientEvent("Notify",source,"importante","Atingiu o número máximo de veículos em sua garagem.",8000)
				return
			end
		elseif vRP.hasPermission(user_id,"platina.permissao") then
			if parseInt(maxvehs[1].qtd) >= parseInt(maxgars[1].garagem) + 8 then
				TriggerClientEvent("Notify",source,"importante","Atingiu o número máximo de veículos em sua garagem.",8000)
				return
			end
		elseif vRP.hasPermission(user_id,"ouro.permissao") then
			if parseInt(maxvehs[1].qtd) >= parseInt(maxgars[1].garagem) + 6 then
				TriggerClientEvent("Notify",source,"importante","Atingiu o número máximo de veículos em sua garagem.",8000)
				return
			end
		elseif vRP.hasPermission(user_id,"prata.permissao") then
			if parseInt(maxvehs[1].qtd) >= parseInt(maxgars[1].garagem) + 5 then
				TriggerClientEvent("Notify",source,"importante","Atingiu o número máximo de veículos em sua garagem.",8000)
				return
			end
		elseif vRP.hasPermission(user_id,"booster.permissao") then
			if parseInt(maxvehs[1].qtd) >= parseInt(maxgars[1].garagem) + 4 then
				TriggerClientEvent("Notify",source,"importante","Atingiu o número máximo de veículos em sua garagem.",8000)
				return
			end
		else
			if parseInt(maxvehs[1].qtd) >= parseInt(maxgars[1].garagem)  + 3 then
				TriggerClientEvent("Notify",source,"importante","Atingiu o número máximo de veículos em sua garagem.",8000)
				return
			end
		end

		if  not vRP.hasPermission(user_id,"admin.permissao") and not vRP.hasPermission(user_id,"platina.permissao") and not vRP.hasPermission(user_id,"conce.permissao") and not vRP.hasPermission(user_id,"ouro.permissao") and not vRP.hasPermission(user_id,"prata.permissao") and vRP.vehicleType(name) == "premiums" then
			TriggerClientEvent("Notify",source,"importante","<b>"..vRP.vehicleName(name).."</b> é um veículo de compra exclusiva dos <b>VIPS</b>.",8000)
			return
		end

		local vehicle = vRP.query("creative/get_vehicles",{ user_id = parseInt(user_id), vehicle = name })
		if vehicle[1] then
			TriggerClientEvent("Notify",source,"importante","Você já possui um <b>"..vRP.vehicleName(name).."</b> em sua garagem.",10000)
			return
		else
			local rows2 = vRP.query("creative/get_estoque",{ vehicle = name })
			if parseInt(rows2[1].quantidade) <= 0 then
				TriggerClientEvent("Notify",source,"aviso","Estoque de <b>"..vRP.vehicleName(name).."</b> indisponivel.",8000)
				return
			end
			if vRP.hasPermission(user_id,"conce.permissao") then
				if vRP.tryFullPayment(user_id,parseInt(vRP.vehiclePrice(name)*0.70)) then
					vRP.execute("creative/set_estoque",{ vehicle = name, quantidade = parseInt(rows2[1].quantidade) - 1 })
					vRP.execute("creative/add_vehicle",{ user_id = parseInt(user_id), vehicle = name })
					vRP.execute("creative/set_ipva",{ user_id = parseInt(user_id), vehicle = name, ipva = parseInt(os.time()) })
					TriggerClientEvent("Notify",source,"sucesso","Você comprou um <b>"..vRP.vehicleName(name).."</b> por <b>$"..vRP.format(parseInt(vRP.vehiclePrice(name)*0.70)).." dólares</b>.",10000)
					TriggerEvent("everest:postarDiscord", source, DISCORD_WEBHOOK, "LOGS CSS", "[COMPROU]:"  ..vRP.vehicleName(name).. " por "..vRP.format(parseInt(vRP.vehiclePrice(name)*0.70)).." dólares</b>.", 16711680)
					src.updateVehicles(name,vRP.vehicleType(name))
					if vRP.vehicleType(name) == "carros" then
						TriggerClientEvent('dealership:Update',source,'updateCarros')
					elseif vRP.vehicleType(name) == "motos" then
						TriggerClientEvent('dealership:Update',source,'updateMotos')
					elseif vRP.vehicleType(name) == "import" then
						TriggerClientEvent('dealership:Update',source,'updateImport')
					elseif vRP.vehicleType(name) == "premiums" then
						TriggerClientEvent('dealership:Update',source,'updatePremiums')
					end
				else
					TriggerClientEvent("Notify",source,"negado","Dinheiro insuficiente.",10000)
				end
			elseif vRP.hasPermission(user_id,"diamante.permissao") then
				if vRP.tryFullPayment(user_id,parseInt(vRP.vehiclePrice(name)*1.00)) then
					vRP.execute("creative/set_estoque",{ vehicle = name, quantidade = parseInt(rows2[1].quantidade) - 1 })
					vRP.execute("creative/add_vehicle",{ user_id = parseInt(user_id), vehicle = name })
					vRP.execute("creative/set_ipva",{ user_id = parseInt(user_id), vehicle = name, ipva = parseInt(os.time()) })
					TriggerClientEvent("Notify",source,"sucesso","Você comprou um <b>"..vRP.vehicleName(name).."</b> por <b>$"..vRP.format(parseInt(vRP.vehiclePrice(name)*1.00)).."Dolares</b>.",10000)
					TriggerEvent("everest:postarDiscord", source, DISCORD_WEBHOOK, "LOGS CSS", "[COMPROU]:"  ..vRP.vehicleName(name).. " por "..vRP.format(parseInt(vRP.vehiclePrice(name)*1.00)).." dólares</b>.", 16711680)
					src.updateVehicles(name,vRP.vehicleType(name))
					if vRP.vehicleType(name) == "carros" then
						TriggerClientEvent('dealership:Update',source,'updateCarros')
					elseif vRP.vehicleType(name) == "motos" then
						TriggerClientEvent('dealership:Update',source,'updateMotos')
					elseif vRP.vehicleType(name) == "import" then
						TriggerClientEvent('dealership:Update',source,'updateImport')
					elseif vRP.vehicleType(name) == "premiums" then
						TriggerClientEvent('dealership:Update',source,'updatePremiums')
					end
				else
					TriggerClientEvent("Notify",source,"negado","Dinheiro insuficiente.",10000)
				end
			elseif vRP.hasPermission(user_id,"platina.permissao") then
				if vRP.tryFullPayment(user_id,parseInt(vRP.vehiclePrice(name)*1.00)) then
					vRP.execute("creative/set_estoque",{ vehicle = name, quantidade = parseInt(rows2[1].quantidade) - 1 })
					vRP.execute("creative/add_vehicle",{ user_id = parseInt(user_id), vehicle = name })
					vRP.execute("creative/set_ipva",{ user_id = parseInt(user_id), vehicle = name, ipva = parseInt(os.time()) })
					TriggerClientEvent("Notify",source,"sucesso","Você comprou um <b>"..vRP.vehicleName(name).."</b> por <b>$"..vRP.format(parseInt(vRP.vehiclePrice(name)*1.00)).."Dolares</b>.",10000)
					TriggerEvent("everest:postarDiscord", source, DISCORD_WEBHOOK, "LOGS CSS", "[COMPROU]:"  ..vRP.vehicleName(name).. " por "..vRP.format(parseInt(vRP.vehiclePrice(name)*1.00)).." dólares</b>.", 16711680)
					src.updateVehicles(name,vRP.vehicleType(name))
					if vRP.vehicleType(name) == "carros" then
						TriggerClientEvent('dealership:Update',source,'updateCarros')
					elseif vRP.vehicleType(name) == "motos" then
						TriggerClientEvent('dealership:Update',source,'updateMotos')
					elseif vRP.vehicleType(name) == "import" then
						TriggerClientEvent('dealership:Update',source,'updateImport')
					elseif vRP.vehicleType(name) == "premiums" then
						TriggerClientEvent('dealership:Update',source,'updatePremiums')
					end
				else
					TriggerClientEvent("Notify",source,"negado","Dinheiro insuficiente.",10000)
				end
			elseif vRP.hasPermission(user_id,"ouro.permissao") then
				if vRP.tryFullPayment(user_id,parseInt(vRP.vehiclePrice(name)*1.00)) then
					vRP.execute("creative/set_estoque",{ vehicle = name, quantidade = parseInt(rows2[1].quantidade) - 1 })
					vRP.execute("creative/add_vehicle",{ user_id = parseInt(user_id), vehicle = name })
					vRP.execute("creative/set_ipva",{ user_id = parseInt(user_id), vehicle = name, ipva = parseInt(os.time()) })
					TriggerClientEvent("Notify",source,"sucesso","Você comprou um <b>"..vRP.vehicleName(name).."</b> por <b>$"..vRP.format(parseInt(vRP.vehiclePrice(name)*1.00)).." dólares</b>.",10000)
					TriggerEvent("everest:postarDiscord", source, DISCORD_WEBHOOK, "LOGS CSS", "[COMPROU]:"  ..vRP.vehicleName(name).. " por "..vRP.format(parseInt(vRP.vehiclePrice(name)*1.00)).." dólares</b>.", 16711680)
					src.updateVehicles(name,vRP.vehicleType(name))
					if vRP.vehicleType(name) == "carros" then
						TriggerClientEvent('dealership:Update',source,'updateCarros')
					elseif vRP.vehicleType(name) == "motos" then
						TriggerClientEvent('dealership:Update',source,'updateMotos')
					elseif vRP.vehicleType(name) == "import" then
						TriggerClientEvent('dealership:Update',source,'updateImport')
					elseif vRP.vehicleType(name) == "premiums" then
						TriggerClientEvent('dealership:Update',source,'updatePremiums')
					end
				else
					TriggerClientEvent("Notify",source,"negado","Dinheiro insuficiente.",10000)
				end
			elseif vRP.hasPermission(user_id,"prata.permissao") then
				if vRP.tryFullPayment(user_id,parseInt(vRP.vehiclePrice(name)*1.00)) then
					vRP.execute("creative/set_estoque",{ vehicle = name, quantidade = parseInt(rows2[1].quantidade) - 1 })
					vRP.execute("creative/add_vehicle",{ user_id = parseInt(user_id), vehicle = name })
					vRP.execute("creative/set_ipva",{ user_id = parseInt(user_id), vehicle = name, ipva = parseInt(os.time()) })
					TriggerClientEvent("Notify",source,"sucesso","Você comprou um <b>"..vRP.vehicleName(name).."</b> por <b>$"..vRP.format(parseInt(vRP.vehiclePrice(name)*1.00)).." dólares</b>.",10000)
					TriggerEvent("everest:postarDiscord", source, DISCORD_WEBHOOK, "LOGS CSS", "[COMPROU]:"  ..vRP.vehicleName(name).. " por "..vRP.format(parseInt(vRP.vehiclePrice(name)*1.00)).." dólares</b>.", 16711680)
					src.updateVehicles(name,vRP.vehicleType(name))
					if vRP.vehicleType(name) == "carros" then
						TriggerClientEvent('dealership:Update',source,'updateCarros')
					elseif vRP.vehicleType(name) == "motos" then
						TriggerClientEvent('dealership:Update',source,'updateMotos')
					elseif vRP.vehicleType(name) == "import" then
						TriggerClientEvent('dealership:Update',source,'updateImport')
					elseif vRP.vehicleType(name) == "premiums" then
						TriggerClientEvent('dealership:Update',source,'updatePremiums')
					end
				else
					TriggerClientEvent("Notify",source,"negado","Dinheiro insuficiente.",10000)
				end
			else
				if vRP.tryFullPayment(user_id,parseInt(vRP.vehiclePrice(name))) then
					vRP.execute("creative/set_estoque",{ vehicle = name, quantidade = parseInt(rows2[1].quantidade) - 1 })
					vRP.execute("creative/add_vehicle",{ user_id = parseInt(user_id), vehicle = name })
					vRP.execute("creative/set_ipva",{ user_id = parseInt(user_id), vehicle = name, ipva = parseInt(os.time()) })
					TriggerClientEvent("Notify",source,"sucesso","Você comprou um <b>"..vRP.vehicleName(name).."</b> por <b>$"..vRP.format(parseInt(vRP.vehiclePrice(name))).." dólares</b>.",10000)
					TriggerEvent("everest:postarDiscord", source, DISCORD_WEBHOOK, "LOGS CSS", "[COMPROU]:"  ..vRP.vehicleName(name).. " por "..vRP.format(parseInt(vRP.vehiclePrice(name)*1.00)).." dólares</b>.", 16711680)
					src.updateVehicles(name,vRP.vehicleType(name))
					if vRP.vehicleType(name) == "carros" then
						TriggerClientEvent('dealership:Update',source,'updateCarros')
					elseif vRP.vehicleType(name) == "motos" then
						TriggerClientEvent('dealership:Update',source,'updateMotos')
					elseif vRP.vehicleType(name) == "import" then
						TriggerClientEvent('dealership:Update',source,'updateImport')
					elseif vRP.vehicleType(name) == "premiums" then
						TriggerClientEvent('dealership:Update',source,'updatePremiums')
					end
				else
					TriggerClientEvent("Notify",source,"negado","Dinheiro insuficiente.",10000)
				end
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SELLDEALER
-----------------------------------------------------------------------------------------------------------------------------------------
function src.sellDealer(name)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local vehicle = vRP.query("creative/get_vehicles",{ user_id = parseInt(user_id), vehicle = name })
		local estoque = vRP.query("creative/get_estoque",{ vehicle = name })
		if vehicle[1] then

			local cows = vRP.getSData("custom:u"..parseInt(user_id).."veh_"..name)
			local rows = json.decode(cows) or {}
			if rows then
				vRP.execute("creative/rem_srv_data",{ dkey = "custom:u"..parseInt(user_id).."veh_"..name })
			end

			local cows2 = vRP.getSData("chest:u"..parseInt(user_id).."veh_"..name)
			local rows2 = json.decode(cows2) or {}
			if rows2 then
				vRP.execute("creative/rem_srv_data",{ dkey = "chest:u"..parseInt(user_id).."veh_"..name })
			end

			vRP.execute("creative/rem_vehicle",{ user_id = parseInt(user_id), vehicle = name })
			vRP.execute("creative/set_estoque",{ vehicle = name, quantidade = parseInt(estoque[1].quantidade+1) })
			local consulta = vRP.getUData(user_id,"vRP:paypal")
			local resultado = json.decode(consulta) or 0
			vRP.setUData(user_id,"vRP:paypal",json.encode(parseInt(resultado + parseInt(vRP.vehiclePrice(name)*0.5))))
			TriggerClientEvent("Notify",source,"sucesso","Você vendeu um <b>"..vRP.vehicleName(name).."</b> por <b>$"..vRP.format(parseInt(vRP.vehiclePrice(name)*0.5)).." Dolares</b>.",10000)
			TriggerEvent("everest:postarDiscord", source, DISCORD_WEBHOOK, "LOGS CSS", "[VENDEU:]"  ..vRP.vehicleName(name).. " por "..vRP.format(parseInt(vRP.vehiclePrice(name)*0.5)).." dólares</b>.", 16711680)
			src.updateVehicles(name,vRP.vehicleType(name))
			TriggerClientEvent('dealership:Update',source,'updatePossuidos')
		end
	end
end
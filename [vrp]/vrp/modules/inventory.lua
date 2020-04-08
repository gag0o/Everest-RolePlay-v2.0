-----------------------------------------------------------------------------------------------------------------------------------------
-- WEB-OKC
-----------------------------------------------------------------------------------------------------------------------------------------
local DISCORD_WEBHOOK = "https://discordapp.com/api/webhooks/686258781503357015/-7Cplc7rXyfZWwRrE0gvWck4MO7r2QRV6vAnirmJp2IjTs6DiihB_c46EmQ7lAlRN1nK"

local cfg = module("cfg/inventory")

vRP.items = {}
function vRP.defInventoryItem(idname,name,weight)
	if weight == nil then
		weight = 0
	end
	local item = { name = name, weight = weight }
	vRP.items[idname] = item
end

function vRP.computeItemName(item,args)
	if type(item.name) == "string" then
		return item.name
	else
		return item.name(args)
	end
end

function vRP.computeItemWeight(item,args)
	if type(item.weight) == "number" then
		return item.weight
	else
		return item.weight(args)
	end
end

function vRP.parseItem(idname)
	return splitString(idname,"|")
end

function vRP.getItemDefinition(idname)
	local args = vRP.parseItem(idname)
	local item = vRP.items[args[1]]
	if item then
		return vRP.computeItemName(item,args),vRP.computeItemWeight(item,args)
	end
	return nil,nil
end

function vRP.getItemName(idname)
	local args = vRP.parseItem(idname)
	local item = vRP.items[args[1]]
	if item then
		return vRP.computeItemName(item,args)
	end
	return args[1]
end

function vRP.getItemWeight(idname)
	local args = vRP.parseItem(idname)
	local item = vRP.items[args[1]]
	if item then
		return vRP.computeItemWeight(item,args)
	end
	return 0
end

function vRP.computeItemsWeight(items)
	local weight = 0
	for k,v in pairs(items) do
		local iweight = vRP.getItemWeight(k)
		weight = weight+iweight*v.amount
	end
	return weight
end

function vRP.giveInventoryItem(user_id,idname,amount)
	local amount = parseInt(amount)
	local data = vRP.getUserDataTable(user_id)
	if data and amount > 0 then
		local entry = data.inventory[idname]
		if entry then
			entry.amount = entry.amount + amount
		else
			data.inventory[idname] = { amount = amount }
		end
	end
end

function vRP.tryGetInventoryItem(user_id,idname,amount)
	local amount = parseInt(amount)
	local data = vRP.getUserDataTable(user_id)
	if data and amount > 0 then
		local entry = data.inventory[idname]
		if entry and entry.amount >= amount then
			entry.amount = entry.amount - amount

			if entry.amount <= 0 then
				data.inventory[idname] = nil
			end
			return true
		end
	end
	return false
end

function vRP.getInventoryItemAmount(user_id,idname)
	local data = vRP.getUserDataTable(user_id)
	if data and data.inventory then
		local entry = data.inventory[idname]
		if entry then
			return entry.amount
		end
	end
	return 0
end

function vRP.getInventory(user_id)
	local data = vRP.getUserDataTable(user_id)
	if data then
		return data.inventory
	end
end

function vRP.getInventoryWeight(user_id)
	local data = vRP.getUserDataTable(user_id)
	if data and data.inventory then
		return vRP.computeItemsWeight(data.inventory)
	end
	return 0
end

function vRP.getInventoryMaxWeight(user_id)
	return math.floor(vRP.expToLevel(vRP.getExp(user_id,"physical","strength")))*3
end

function vRP.clearInventory(user_id)
	local data = vRP.getUserDataTable(user_id)
	if data then
		data.inventory = {}
	end
end

AddEventHandler("vRP:playerJoin", function(user_id,source,name)
	local data = vRP.getUserDataTable(user_id)
	if not data.inventory then
		data.inventory = {}
	end
end)

local chests = {}
local function build_itemlist_menu(name,items,cb)
	local menu = { name = name }
	local kitems = {}

	local choose = function(player,choice)
		local idname = kitems[choice]
		if idname then
			cb(idname)
		end
	end

	for k,v in pairs(items) do 
		local name,weight = vRP.getItemDefinition(k)
		if name then
			kitems[name] = k
			menu[name] = { choose,"<text01>Quantidade:</text01> <text02>"..v.amount.."</text02><text01>Peso:</text01> <text02>"..string.format("%.2f",weight).."kg</text02>" }
		end
	end

	return menu
end

function vRP.openChest(source,name,max_weight,cb_close,cb_in,cb_out)
	local user_id = vRP.getUserId(source)
	if user_id then
		local data = vRP.getUserDataTable(user_id)
		if data.inventory then
			if not chests[name] then
				local close_count = 0
				local chest = { max_weight = max_weight }
				chests[name] = chest 
				local cdata = vRP.getSData("chest:"..name)
				chest.items = json.decode(cdata) or {}

				local menu = { name = "Baú" }
				local cb_take = function(idname)
					local citem = chest.items[idname]
					local amount = vRP.prompt(source,"Quantidade:","")
					amount = parseInt(amount)
					if amount >= 0 and amount <= citem.amount then
						local new_weight = vRP.getInventoryWeight(user_id)+vRP.getItemWeight(idname)*amount
						if new_weight <= vRP.getInventoryMaxWeight(user_id) then
							vRP.giveInventoryItem(user_id,idname,amount)
							PerformHttpRequest(webhooklink1, function(err, text, headers) end, 'POST', json.encode({username = botusername, content = "Jogador de ID: "..user_id.." pegou "..amount.."x "..vRP.getItemName(idname).." no baú "..name.."."}), { ['Content-Type'] = 'application/json' })
							TriggerEvent("everest:postarDiscord", source, DISCORD_WEBHOOK, "SAÍDA PORTA MALAS", "ID: "..user_id.."\nRETIROU: "..amount.."x "..vRP.getItemName(idname).."\nBAÚ: "..name, 16711680)
							citem.amount = citem.amount - amount

							if citem.amount <= 0 then
								chest.items[idname] = nil
							end

							if cb_out then
								cb_out(idname,amount)
							end
							vRP.closeMenu(source)
						else
							TriggerClientEvent("Notify",source,"negado","Mochila cheia.")
						end
					else
						TriggerClientEvent("Notify",source,"negado","Valor inválido.")
					end
				end

				local ch_take = function(player,choice)
					local weight = vRP.computeItemsWeight(chest.items)
					local submenu = build_itemlist_menu(string.format("%.2f",weight).." / "..max_weight.."kg",chest.items,cb_take)

					submenu.onclose = function()
						close_count = close_count - 1
						vRP.openMenu(player,menu)
					end
					close_count = close_count + 1
					vRP.openMenu(player,submenu)
				end

				local cb_put = function(idname)
					if string.match(idname,"dinheirosujo") then
						TriggerClientEvent("Notify",source,"importante","Não pode guardar <b>Dinheiro Sujo</b> em veículos.")
						return
					end

					local amount = vRP.prompt(source,"Quantidade:","")
					amount = parseInt(amount)
					local new_weight = vRP.computeItemsWeight(chest.items)+vRP.getItemWeight(idname)*amount
					if new_weight <= max_weight then
						if amount >= 0 and vRP.tryGetInventoryItem(user_id,idname,amount) then
							local citem = chest.items[idname]
							TriggerEvent("everest:postarDiscord", source, DISCORD_WEBHOOK, "ENTRADA PORTA MALAS", "ID: "..user_id.."\nCOLOCOU: "..amount.."x "..vRP.getItemName(idname).."\nBAÚ: "..name, 16711680)
							PerformHttpRequest(webhooklink1, function(err, text, headers) end, 'POST', json.encode({username = botusername, content = "Jogador de ID: "..user_id.." colocou "..amount.."x "..vRP.getItemName(idname).." no baú "..name.."."}), { ['Content-Type'] = 'application/json' })

							if citem ~= nil then
								citem.amount = citem.amount + amount
							else
								chest.items[idname] = { amount = amount }
							end

							if cb_in then
								cb_in(idname,amount)
							end
							vRP.closeMenu(source)
						end
					else
						TriggerClientEvent("Notify",source,"negado","Baú cheio.")
					end
				end

				local ch_put = function(player,choice)
					local weight = vRP.computeItemsWeight(data.inventory)
					local max_weight = vRP.getInventoryMaxWeight(user_id)
					local submenu = build_itemlist_menu(string.format("%.2f",weight).." / "..max_weight.."kg",data.inventory,cb_put)

					submenu.onclose = function()
						close_count = close_count - 1
						vRP.openMenu(player,menu)
					end
					close_count = close_count + 1
					vRP.openMenu(player,submenu)
				end

				menu["Retirar"] = { ch_take }
				menu["Colocar"] = { ch_put }

				menu.onclose = function()
					if close_count == 0 then
						vRP.setSData("chest:"..name,json.encode(chest.items))
						chests[name] = nil
						if cb_close then
							cb_close()
						end
					end
				end
				vRP.openMenu(source,menu)
			else
				TriggerClientEvent("Notify",source,"importante","Está sendo utilizado no momento.")
			end
		end
	end
end

function vRP.openChest2(source,name,max_weight, webBook,cb_close,cb_in,cb_out)
	local user_id = vRP.getUserId(source)
	if user_id then
		local data = vRP.getUserDataTable(user_id)
		if data.inventory then
			if not chests[name] then
				local close_count = 0
				local chest = { max_weight = max_weight }
				chests[name] = chest 
				local cdata = vRP.getSData("chest:"..name)
				chest.items = json.decode(cdata) or {}


				local menu = { name = "Baú" }
				local cb_take = function(idname)
					local citem = chest.items[idname]
					local amount = vRP.prompt(source,"Quantidade:","")
					amount = parseInt(amount)
					if amount > 0 and amount <= citem.amount then
						local new_weight = vRP.getInventoryWeight(user_id)+vRP.getItemWeight(idname)*amount
						if new_weight <= vRP.getInventoryMaxWeight(user_id) then
							vRP.giveInventoryItem(user_id,idname,amount)
							citem.amount = citem.amount - amount

							if webBook ~= "" then
								TriggerEvent("everest:postarDiscord", source, webBook, "SAÍDA BAÚ", "RETIROU: "..amount.."x "..vRP.getItemName(idname).."\nBAÚ: "..name)
							end
							if citem.amount <= 0 then
								chest.items[idname] = nil
							end

							if cb_out then
								cb_out(idname,amount)
							end
							vRP.closeMenu(source)
						else
							TriggerClientEvent("Notify",source,"negado","Mochila cheia.")
						end
					else
						TriggerClientEvent("Notify",source,"negado","Valor inválido.")
					end
				end

				local ch_take = function(player,choice)
					local weight = vRP.computeItemsWeight(chest.items)
					local submenu = build_itemlist_menu(string.format("%.2f",weight).." / "..max_weight.."kg",chest.items,cb_take)

					submenu.onclose = function()
						close_count = close_count - 1
						vRP.openMenu(player,menu)
					end
					close_count = close_count + 1
					vRP.openMenu(player,submenu)
				end

					
				local cb_put = function(idname)
					local amount = vRP.prompt(source,"Quantidade:","")
					amount = parseInt(amount)
					local new_weight = vRP.computeItemsWeight(chest.items)+vRP.getItemWeight(idname)*amount
					if new_weight <= max_weight then
						if amount > 0 and vRP.tryGetInventoryItem(user_id,idname,amount) then
							local citem = chest.items[idname]

							if webBook ~= "" then
								TriggerEvent("everest:postarDiscord", source, webBook, "ENTRADA BAÚ", "COLOCOU: "..amount.."x "..vRP.getItemName(idname).."\nBAÚ: "..name, 16711680)
							end
							if citem ~= nil then
								citem.amount = citem.amount + amount
							else
								chest.items[idname] = { amount = amount }
							end

							if cb_in then
								cb_in(idname,amount)
							end
							vRP.closeMenu(source)
						end
					else
						TriggerClientEvent("Notify",source,"negado","Baú cheio.")
					end
				end

				local ch_put = function(player,choice)
					local weight = vRP.computeItemsWeight(data.inventory)
					local submenu = build_itemlist_menu(string.format("%.2f",weight).." / "..max_weight.."kg",data.inventory,cb_put)

					submenu.onclose = function()
						close_count = close_count-1
						vRP.openMenu(player,menu)
					end

					close_count = close_count+1
					vRP.openMenu(player,submenu)
				end

				menu["Retirar"] = { ch_take }
				menu["Colocar"] = { ch_put }

				menu.onclose = function()
					if close_count == 0 then
						vRP.setSData("chest:"..name,json.encode(chest.items))
						chests[name] = nil
						if cb_close then
							cb_close()
						end
					end
				end
				vRP.openMenu(source,menu)
			else
				TriggerClientEvent("Notify",source,"importante","Está sendo utilizado no momento.")
			end
		end
	end
end

local function build_client_static_chests(source)
	local user_id = vRP.getUserId(source)
	if user_id then
		for k,v in pairs(cfg.static_chests) do
			local mtype,x,y,z = table.unpack(v)
			local schest = cfg.static_chest_types[mtype]

			if schest then
				local function schest_enter(source)
					local user_id = vRP.getUserId(source)
					if user_id and vRP.hasPermissions(user_id,schest.permissions or {}) then
						vRP.openChest2(source,"static:"..k,schest.weight or 0, schest.webBook)
					end
				end

				local function schest_leave(source)
					vRP.closeMenu(source)
				end

				vRP.setArea(source,"vRP:static_chest:"..k,x,y,z,1,1,schest_enter,schest_leave)
			end
		end
	end
end

AddEventHandler("vRP:playerSpawn",function(user_id,source,first_spawn)
	if first_spawn then
		build_client_static_chests(source)
	end
end)


local itemlist = {
	["greencard"] = { "greencard","Green Card","usar","Cartão utilizado para grandes saques." },
	["bluecard"] = { "bluecard","Blue Card","usar","Cartão utilizado para grandes saques." },
	["moonshine"] = { "moonshine","Moonshine","usar","Moonshine era originalmente uma gíria para espíritos destilados de alta prova que geralmente eram produzidos ilegalmente , sem autorização do governo." },
	["bebidafermentada"] = { "bebidafermentada","Bebida fermentada","usar","Bebida fermentada." },
	["graos"] = { "graos","Grãos","usar","Todos os tipos de grãos podem ser incluídos em saladas de folhas, legumes e vegetais ou sopas. Além de compor iogurtes, vitaminas, sucos e porções de frutas tornando a refeição ainda mais saudável. " },
	["yellowcard"] = { "yellowcard","Yellow Card","usar","Cartão utilizado para grandes saques." },
	["nightvision"] = { "nightvision","Night Vision","usar","Oculos usado para ter uma visualização melhor em noites escuras." },
	["postit"] = { "postit","Post-it","usar","Um tipo de bloco de notas composto por pequenas folhas de papel adesivo." },
	["colete"] = { "colete","Colete","usar","Utilizado para combates e que lhe protegeram de artefatos militares." },
	["notebook"] = { "notebook","Notebook","usar","Um computador portátil utilizado para modificação de veículos." },
	["goldbar"] = { "goldbar","Barra de Ouro","usar","Uma barra fundida com ouro. Utilizado como dinheiro, mercadorias e moedas." },
	["premium"] = { "premium","Premium","usar","Utilizando o mesmo você receberá os benefícios:<br><br><b>Recompensa Bancária:</b> $1.000 dólares<br><b>Vagas Extras na Garagem:</b> 10<br><b>Prioridade de Conexão:</b> Sim<br><b>Caixas Automáticas:</b> Sim<br><b>Desconto Concessionária:</b> 5%" },
	["boxflight1"] = { "boxflight1","Flight (1)","usar","Caixa que contém 100 de bonus para Pilotos." },
	["boxflight2"] = { "boxflight2","Flight (2)","usar","Caixa que contém 250 de bonus para Pilotos." },
	["boxflight3"] = { "boxflight3","Flight (3)","usar","Caixa que contém 500 de bonus para Pilotos." },
	["boxpatrol1"] = { "boxpatrol1","Patrol (1)","usar","Caixa que contém 100 de bonus para Policiais." },
	["boxpatrol2"] = { "boxpatrol2","Patrol (2)","usar","Caixa que contém 250 de bonus para Policiais." },
	["boxpatrol3"] = { "boxpatrol3","Patrol (3)","usar","Caixa que contém 500 de bonus para Policiais." },
	["boxmedic1"] = { "boxmedic1","Medic (1)","usar","Caixa que contém 100 de bonus para Médicos." },
	["boxmedic2"] = { "boxmedic2","Medic (2)","usar","Caixa que contém 250 de bonus para Médicos." },
	["boxmedic3"] = { "boxmedic3","Medic (3)","usar","Caixa que contém 500 de bonus para Médicos." },
	["boxhunter1"] = { "boxhunter1","Hunter (1)","usar","Caixa que contém 100 de bonus para Caçadores." },
	["boxhunter2"] = { "boxhunter2","Hunter (2)","usar","Caixa que contém 250 de bonus para Caçadores." },
	["boxhunter3"] = { "boxhunter3","Hunter (3)","usar","Caixa que contém 500 de bonus para Caçadores." },
	["boxassassin1"] = { "boxassassin1","Assassin (1)","usar","Caixa que contém 100 de bonus para Assassinos." },
	["boxassassin2"] = { "boxassassin2","Assassin (2)","usar","Caixa que contém 250 de bonus para Assassinos." },
	["boxassassin3"] = { "boxassassin3","Assassin (3)","usar","Caixa que contém 500 de bonus para Assassinos." },
	["boxsmuggler1"] = { "boxsmuggler1","Smuggler (1)","usar","Caixa que contém 100 de bonus para Contrabandista." },
	["boxsmuggler2"] = { "boxsmuggler2","Smuggler (2)","usar","Caixa que contém 250 de bonus para Contrabandista." },
	["boxsmuggler3"] = { "boxsmuggler3","Smuggler (3)","usar","Caixa que contém 500 de bonus para Contrabandista." },
	["boxdrivin1"] = { "boxdrivin1","Drivin (1)","usar","Caixa que contém 100 de bonus para Taxistas." },
	["boxdrivin2"] = { "boxdrivin2","Drivin (2)","usar","Caixa que contém 250 de bonus para Taxistas." },
	["boxdrivin3"] = { "boxdrivin3","Drivin (3)","usar","Caixa que contém 500 de bonus para Taxistas." },
	["boxtools1"] = { "boxtools1","Tools (1)","usar","Caixa que contém 100 de bonus para Mecânicos." },
	["boxtools2"] = { "boxtools2","Tools (2)","usar","Caixa que contém 250 de bonus para Mecânicos." },
	["boxtools3"] = { "boxtools3","Tools (3)","usar","Caixa que contém 500 de bonus para Mecânicos." },
	["boxtrasher1"] = { "boxtrasher1","Trasher (1)","usar","Caixa que contém 100 de bonus para Lixeiros." },
	["boxtrasher2"] = { "boxtrasher2","Trasher (2)","usar","Caixa que contém 250 de bonus para Lixeiros." },
	["boxtrasher3"] = { "boxtrasher3","Trasher (3)","usar","Caixa que contém 500 de bonus para Lixeiros." },
	["boxfisher1"] = { "boxfisher1","Fisher (1)","usar","Caixa que contém 100 de bonus para Pescadores." },
	["boxfisher2"] = { "boxfisher2","Fisher (2)","usar","Caixa que contém 250 de bonus para Pescadores." },
	["boxfisher3"] = { "boxfisher3","Fisher (3)","usar","Caixa que contém 500 de bonus para Pescadores." },
	["boxlumberjack1"] = { "boxlumberjack1","Lumberjack (1)","usar","Caixa que contém 100 de bonus para Lenhadores." },
	["boxlumberjack2"] = { "boxlumberjack2","Lumberjack (2)","usar","Caixa que contém 250 de bonus para Lenhadores." },
	["boxlumberjack3"] = { "boxlumberjack3","Lumberjack (3)","usar","Caixa que contém 500 de bonus para Lenhadores." },
	["boxfarmer1"] = { "boxfarmer1","Farmer (1)","usar","Caixa que contém 100 de bonus para Fazendeiros." },
	["boxfarmer2"] = { "boxfarmer2","Farmer (2)","usar","Caixa que contém 250 de bonus para Fazendeiros." },
	["boxfarmer3"] = { "boxfarmer3","Farmer (3)","usar","Caixa que contém 500 de bonus para Fazendeiros." },
	["boxjewels1"] = { "boxjewels1","Jewels (1)","usar","Caixa que contém 100 de bonus para Mineradores." },
	["boxjewels2"] = { "boxjewels2","Jewels (2)","usar","Caixa que contém 250 de bonus para Mineradores." },
	["boxjewels3"] = { "boxjewels3","Jewels (3)","usar","Caixa que contém 500 de bonus para Mineradores." },
	["boxdriver1"] = { "boxdriver1","Driver (1)","usar","Caixa que contém 100 de bonus para Motoristas." },
	["boxdriver2"] = { "boxdriver2","Driver (2)","usar","Caixa que contém 250 de bonus para Motoristas." },
	["boxdriver3"] = { "boxdriver3","Driver (3)","usar","Caixa que contém 500 de bonus para Motoristas." },
	["boxtrucker1"] = { "boxtrucker1","Trucker (1)","usar","Caixa que contém 100 de bonus para Caminhoneiros." },
	["boxtrucker2"] = { "boxtrucker2","Trucker (2)","usar","Caixa que contém 2500 de bonus para Caminhoneiros." },
	["boxtrucker3"] = { "boxtrucker3","Trucker (3)","usar","Caixa que contém 500 de bonus para Caminhoneiros." },
	["boxmailer1"] = { "boxmailer1","Mailer (1)","usar","Caixa que contém 100 de bonus para Carteiros." },
	["boxmailer2"] = { "boxmailer2","Mailer (2)","usar","Caixa que contém 250 de bonus para Carteiros." },
	["boxmailer3"] = { "boxmailer3","Mailer (3)","usar","Caixa que contém 500 de bonus para Carteiros." },
	["boxrunner1"] = { "boxrunner1","Runner (1)","usar","Caixa que contém 100 de bonus para Corredores." },
	["boxrunner2"] = { "boxrunner2","Runner (2)","usar","Caixa que contém 250 de bonus para Corredores." },
	["boxrunner3"] = { "boxrunner3","Runner (3)","usar","Caixa que contém 500 de bonus para Corredores." },
	["boxbreak1"] = { "boxbreak1","Break (1)","usar","Caixa que contém 100 de bonus para Traficante." },
	["boxbreak2"] = { "boxbreak2","Break (2)","usar","Caixa que contém 250 de bonus para Traficante." },
	["boxbreak3"] = { "boxbreak3","Break (3)","usar","Caixa que contém 500 de bonus para Traficante." },
	["morfina"] = { "morfina","Morfina","usar","Utilizado para retornar a consciência de uma pessoa." },
	["radio"] = { "radio","Rádio","usar","Utilizado para comunicações em grupo atravez de frequências." },
	["bronze"] = { "bronze","Min. Bronze","usar","Uma liga metalica feita de estanho e cobre." },
	["prata"] = { "prata","Min. Prata","usar","Elemento químico, metálico e utilizado para a fabricação de joias." },
	["ouro"] = { "ouro","Min. Ouro","usar","Minério precioso utilizado para a fabricação de joias." },
	["rubi"] = { "rubi","Min. Rubi","usar","Minério extremamente raro utilizado para lapidação." },
	["esmeralda"] = { "esmeralda","Min. Esmeralda","usar","Mninério raro utilizado para lapidação ." },
	["safira"] = { "safira","Min. Safira","usar","Mninério raro utilizado para lapidação." },
	["diamante"] = { "diamante","Min. Diamante","usar","Mninério raro utilizado para lapidação." },
	["topazio"] = { "topazio","Min. Topázio","usar","Mninério raro utilizado para lapidação." },
	["ametista"] = { "ametista","Min. Ametista","usar","Mninério raro utilizado para lapidação." },
	["bronze2"] = { "bronze2","Bronze","usar","Uma liga metalica feita de estanho e cobre.." },
	["prata2"] = { "prata2","Prata","usar","Barra utilizada para a fabricação de joias e objetos em geral." },
	["ouro2"] = { "ouro2","Ouro","usar","Pedra utilizada para a fabricação de joias e objetos." },
	["rubi2"] = { "rubi2","Rubi","usar","Pedra extremamente rara utilizada em joias de alto valor." },
	["esmeralda2"] = { "esmeralda2","Esmeralda","usar","Pedra extremamente rara utilizada em joias de alto valor." },
	["safira2"] = { "safira2","Safira","usar","Pedra rara utilizada em joias de alto valor." },
	["diamante2"] = { "diamante2","Diamante","usar","Pedra extremamente rara utilizada em joias de alto valor." },
	["topazio2"] = { "topazio2","Topázio","usar","Pedra utilizada em joias." },
	["ametista2"] = { "ametista2","Ametista","usar","Pedra utilizada em joias." },
	["identidade"] = { "identidade","Identidade","usar","Item que mostra sua informações basicas." },
	["caixadepizza"] = { "caixadepizza","Caixa de Pizza","usar","Caixa de Pizza usado para embalar a pizza." },
	["pizza"] = { "pizza","Pizza","usar","Pizza  é um prato saboroso de origem italiana , constituído por uma base geralmente redonda e achatada de massa fermentada à base de trigo, coberta com tomate, queijo e, muitas vezes, vários outros ingredientes ." },
	["cnh"] = { "cnh","Cnh","usar","A Carteira Nacional de Habilitação (CNH),atesta a aptidão de um cidadão para conduzir veículos automotores terrestres." },
	["carbono"] = { "carbono","Carbono","usar","Elemento químico com varias aplicações industriais." },
	["malotededinheiro"] = { "malotededinheiro","Malote de Dinheiro","usar","Malote de dinheiro usado para fazer transferencia de dinheiro" },
	["malote"] = { "malote","Malote","usar","Malote usado para fazer transferencia de dinheiro" },
	["ferro"] = { "ferro","Ferro","usar","Elemento químico com varias aplicações industriais." },
	["aco"] = { "aco","Aço","usar","Elemento químico com varias aplicações industriais." },
	["ferramenta"] = { "ferramenta","Ferramenta","usar","Instrumento de trabalho que pode ser entregue nas oficinas." },
	["encomenda"] = { "encomenda","Encomenda","usar","Uma caixa que contém encomendase cartas da cidade." },
	["sacodelixo"] = { "sacodelixo","Saco de Lixo","usar","Uma embalagem que contém resíduos das casas." },
	["garrafavazia"] = { "garrafavazia","Garrafa Vazia","usar","Recipiente vazio que pode ser usado para a coleta de leite." },
	["garrafadeleite"] = { "garrafadeleite","Garrafa de Leite","usar","Recipiente que contém leite fresco da fazenda." },
	["tora"] = { "tora","Tora de Madeira","usar","Material retirado das árvores que pode ser entregue em construções." },
	["alianca"] = { "alianca","Aliança","usar","Uma lembrança que utilizada para formalizar namoros, noivados e casamentos." },
	["bandagem"] = { "bandagem","Bandagem","usar","Uma faixa utilizada para tratamentos de feridas." },
	["cerveja"] = { "cerveja","Cerveja","usar","Bebida alcoólica obtida por meio da fermentação do malte de cevada, ou de outros cereais, e aromatizada com flores de lúpulo." },
	["tequila"] = { "tequila","Tequila","usar","Aguardente obtida pela destilação do fruto do agave; bebida alcoólica mexicana." },
	["vodka"] = { "vodka","Vodka","usar","Bebida alcoólica quase sem sabor e com um alto teor alcoólico." },
	["whisky"] = { "whisky","Whisky","usar","Bebida alcoólica destilada de grãos, muitas vezes incluindo malte, que foi envelhecida em barris." },
	["conhaque"] = { "conhaque","Conhaque","usar","Bebida alcoólica obtida pela destilação de vinhos brancos." },
	["absinto"] = { "absinto","Absinto","usar","Bebida destilada com alto teor alcoólico." },
	["dinheirosujo"] = { "dinheirosujo","Dinheiro Sujo","usar","Dinheiro pego por furtos e venda de produtos ilicitos." },
	["kitreparos"] = { "kitreparos","Kit de Reparos","usar","Ferramenta utilizada no reparo de veiculos." },
	["pneus"] = { "pneus","Pneus","usar","Um estepe que pode ser trocado caso o pneu fure." },
	["algemas"] = { "algemas","Algemas","usar","Instrumento de ferro utilizado para prender pessoas pelo pulso." },
	["cordas"] = { "cordas","Cordas","usar","Fios trançados com alta resistencia, utilizado para carregar e amarrar objetos e pessoas." },
	["capuz"] = { "capuz","Capuz","usar","Peça de tecido utilizado para tampar a visão de uma pessoa." },
	["lockpick"] = { "lockpick","Lockpick","usar","Ferramenta utilizada para a abertura de carros e portas." },
	["masterpick"] = { "masterpick","Masterpick","usar","Ferramenta utilizada para a abertura de carros e portas." },
	["militec"] = { "militec","Militec-1","usar","Um óleo que contem condicionador de metais que utilizado pode arrumar o motor do veiculos." },
	["carnedecormorao"] = { "carnedecormorao","Carne de Cormorão","usar","Carne cortada de um cormorão." },
	["carnedecorvo"] = { "carnedecorvo","Carne de Corvo","usar","Carne cortada de um corvo." },
	["carnedeaguia"] = { "carnedeaguia","Carne de Águia","usar","Carne cortada de uma águia." },
	["carnedecervo"] = { "carnedecervo","Carne de Cervo","usar","Carne cortada de um Cervo." },
	["carnedecoelho"] = { "carnedecoelho","Carne de Coelho","usar","Carne cortada de um coelho." },
	["carnedecoyote"] = { "carnedecoyote","Carne de Coyote","usar","Carne cortada de um Coyote." },
	["carnedelobo"] = { "carnedelobo","Carne de Lobo","usar","Carne cortada de um lobo." },
	["carnedepuma"] = { "carnedepuma","Carne de Puma","usar","Carne cortada de uma puma." },
	["carnedejavali"] = { "carnedejavali","Carne de Javali","usar","Carne cortada de um javali." },
	["isca"] = { "isca","Isca","usar","Chamariz feito para pescar peixes." },
	["ticketcorrida"] = { "ticketcorrida", "Race", "usar","Ticket de Corrida utilizado para iniciar uma corrida ilegal." },	
	["dourado"] = { "dourado","Dourado","usar","Pequeno peixe de agua doce." },
	["corvina"] = { "corvina","Corvina","usar","Pequeno peixe de agua doce." },
	["salmao"] = { "salmao","Salmão","usar","Pequeno peixe de agua salgada ." },
	["pacu"] = { "pacu","Pacu","usar","Pequeno peixe de agua doce." },
	["racao"] = { "racao","Ração","usar","Ração de Pet." },
	["pintado"] = { "pintado","Pintado","usar","Pequeno peixe de agua salgada." },
	["pirarucu"] = { "pirarucu","Pirarucu","usar","Pequeno peixe de agua doce." },
	["tilapia"] = { "tilapia","Tilápia","usar","Pequeno peixe de agua doce." },
	["tucunare"] = { "tucunare","Tucunaré","usar","Pequeno peixe de agua doce." },
	["lambari"] = { "lambari","Lambari","usar","Pequeno peixe de agua salgada." },
	["dorflex "] = { "dorflex ","Dorflex ","usar","O dorflex é um analgésico e relaxante muscular. O dorflex é indicado no alívio da dor associada a contraturas musculares, incluindo dor de cabeça tensional." },
	["energetico"] = { "energetico","Energético","usar","Bebida com base em cafeína que lhe dá energia força fisica." },
	["dipirona"] = { "dipirona","Dipirona","usar","A Dipirona Sódica é um analgésico e antitérmico utilizado em enfermidades que tenham dor e febre como sintomas. É comumente utilizada no tratamento de gripes e resfriados, nevralgias, dores de cabeça, reumatismo muscular, artrites e outras crises dolorosas." },
	["mochila"] = { "mochila","Mochila","usar","Um objeto que pode ser usado para guardar outros objetos." },
	["tarjapreta"] = { "tarjapreta","Tarja preta","usar","O Tarja preta é um medicamento de maior controle e pode apresentar muitos efeitos colaterais e reações adversas. Possuem ação sedativa ou com impacto no sistema nervoso central, também sendo do grupo dos psicotrópicos. VENDA SOB PRESCRIÇÃO MÉDICA - O ABUSO DESTE MEDICAMENTO PODE CAUSAR DEPENDÊNCIA. "},
	["adubo"] = { "adubo","Adubo","usar","Conjunto de resíduos que se mistura a terra para a fertilização organica." },
	["fertilizante"] = { "fertilizante","Fertilizante","usar","Substância sintética para a fertilização do solo." },
	["maconha"] = { "maconha","Maconha","usar","Droga de efeito entorpecente preparada com os ramos, folhas e flores." },
	["pastadecoca"] = { "pastadecoca","Pasta de Coca","usar","Produto extraído para ser utilizado como mistura." },
	["folhadecoca"] = { "folhadecoca","Folha de Coca","usar","Folha que misturada com reagentes se torna um intorpecente." },
	["cocaina"] = { "cocaina","Cocaína","usar","Intorpecente em forma de pó com efeitos alucinógenos." },
	["pastadecrack"] = { "pastadecrack","Pasta de Crack","usar","Produto extraído para ser utilizado como mistura." },
	["folhadecrack"] = { "folhadecrack","Folha de Crack","usar","Folha que misturada com reagentes se torna um intorpecente." },
	["crack"] = { "crack","Crack","usar","Intorpecente em forma de pedra com efeitos alucinógenos." },
	["metil"] = { "metil","Metil-1","usar","Substância sintética para ser utilizada como mistura." },
	["crystalmelamine"] = { "crystalmelamine","Crystal Melamine","usar","Conjunto de resíduos que se mistura com o metil." },
	["metanfetamina"] = { "metanfetamina","Metanfetamina","usar","Intorpecente em forma de Crystal com efeitos alucinógenos." },	
	["pendrivebootavel"] = { "pendrivebootavel","Pendrive Bootavel","usar","Objeto utilizado para o acesso as cameras de segurança e hackeamento." },
	["keylogs"] = { "keylogs","Key Logs","usar","Objeto utilizado para hackeamento." },
	["logsinvasao"] = { "logsinvasao","Logs de Invasão","usar","Objeto utilizado para acessar informações de outra pessoa." },
	["cartaoclonado"] = { "cartaoclonado","Cartão Clonado","usar","Objeto utilizado para clonagem." },
	["receitamedica"] = { "receitamedica","Receita Médica","usar","Receita medicada para comprar remédio." },
	["remedio"] = { "remedio","Remédio","usar","Uma faixa utilizada para tratamentos de feridas." },
	["serra"] = { "serra","Serra Elétrica","usar","Utilizado para serrar." },
	["furadeira"] = { "furadeira","Furadeira","usar","Utilizado para furar." },
	["rubberducky"] = { "rubberducky","Rubberducky","usar","Objeto utilizado para o acesso as cameras de segurança e hackeamento." },
	["rastreador"] = { "rastreador","Rastreador de Veículo","usar","Objeto utilizado para rastrear seu veículo." },
	["chavemestra"] = { "chavemestra","Chave Mestra","usar","Ferramenta utilizada para a abertura de portas." },
	["contratocargo"] = { "contratocargo","Contrato de Cargas","usar","Objeto utilizado para contratar carga especial." },
	["contatoinformante"] = { "contatoinformante","Contato do Informante","usar","Objeto utilizado para saber localização de serviços." },
	["capsuladebala"] = { "capsuladebala","Cápsula de Muniçôes","usar","Objeto utilizado para fabricação de munições." },
	["motor"] = { "motor","Pecas do Motor","usar","Objeto utilizado para fabricação de motor." },
	["polvora"] = { "polvora","Pólvora","usar","A pólvora queima produzindo uma onda de deflagração subsônica, ao contrário dos altos explosivos que geram uma onda de detonação supersônica." },
	["pecasdearma"] = { "pecasdearma","Peças de Armas","usar","Objeto utilizado para fabricação de armas." },
	["celular"] = { "celular","Celular","usar","Aparelho eletrônico utilizado para a troca de mensagens, ligações e acesso as redes sociais." },
	["placa"] = { "placa","Placa","usar","Objeto de descaracterização do veículo." },
	["rebite"] = { "rebite","Rebite","usar","Droga sintética que atua no sistema nervoso, estilumando-o a um ritmo de trabalho maior." },
	["orgao"] = { "orgao","Órgão","usar","Obtido pelo assassinato de pessoas." },
	["etiqueta"] = { "etiqueta","Etiqueta","usar","Obejto que foi subtraídos dos animais registrasdos." },
	["pendrive"] = { "pendrive","Pendrive","usar","Objeto utilizado para o acesso as cameras de segurança e hackeamento." },
	["relogioroubado"] = { "relogioroubado","Relógio Roubado","usar","Objeto roubado de uma pessoa ou de casas." },
	["pulseiraroubada"] = { "pulseiraroubada","Pulseira Roubada","usar","Objeto roubado de uma pessoa ou de casas." },
	["anelroubado"] = { "anelroubado","Anel Roubado","usar","Objeto roubado de uma pessoa ou de casas." },
	["roupas"] = { "roupas","Roupas","usar","Objeto usado para trocar de roupa." },
	["colarroubado"] = { "colarroubado","Colar Roubado","usar","Objeto roubado de uma pessoa ou de casas." },
	["brincoroubado"] = { "brincoroubado","Brinco Roubado","usar","Objeto roubado de uma pessoa ou de casas." },
	["carteiraroubada"] = { "carteiraroubada","Carteira Roubada","usar","Objeto roubado de uma pessoa ou de casas." },
	["banana"] = { "banana","Banana","usar","Uma deliciosa Banana." },
	["xtudo"] = { "xtudo","X-Tudo","usar","X-Tudo vem de tudo."},
	["taco"] = { "taco","Taco","usar","Um Delicioso Taco."},
	["chocolate"] = { "chocolate","Chocolate","usar","Chocolate Amargo"},
	["batatafrita"] = { "batatafrita","Batata Frita","usar","Batata Frita com Queijo"},
	["sanduiche"] = {"sanduiche","Sanduiche","usar","Sanduiche Natural de Otima qualidade"},
	["donut"] = { "donut","Donut","usar","Um rosquinha em formar de circulo."},
	["pipoca"] = { "pipoca","Pipoca","usar","Uma pipoca com manteiga"},
	["cafe"] = { "cafe","Café","usar","O café é uma bebida produzida a partir dos grãos torrados do fruto do cafeeiro."},
	["hotdog"] = { "hotdog","Hot Dog","usar"," cachorro-quente com maionese, ketchup, mostarda, molhos à base de tomate."},
	["macarrao"] = {"macarrao","Macarrão","usar","Macarrão ao queijo."},
	["chavedeacesso"] = {"chavedeacesso","Chave de Acesso","usar"," Acesso a loja de utilitarios"},
    ["churrasco"] = {"churrasco","Churrasco","usar","Um Churrasco delicioso."},
    ["agua"] = {"agua","Água","usar","Agua mineral."},
    ["fanta"] = {"fanta","Fanta","usar","Refrigerante de laranja."},
    ["cocacola"] = {"cocacola","Coca cola","usar","Refrigerante de Coca Cola."},
    ["milkshake"] = {"milkshake","Milkshake","usar","Milkskake  de moranjo com chocolate."},
	["carregadorroubado"] = { "carregadorroubado","Carregador Roubado","usar","Objeto roubado de uma pessoa ou de casas." },
	["tabletroubado"] = { "tabletroubado","Tablet Roubado","usar","Objeto roubado de uma pessoa ou de casas." },
	["sapatosroubado"] = { "sapatosroubado","Sapatos Roubado","usar","Vestimenta roubada de uma pessoa ou de casas." },
	["vibradorroubado"] = { "vibradorroubado","Vibrador Roubado","usar","Objeto roubado de uma pessoa ou de casas." },
	["perfumeroubado"] = { "perfumeroubado","Perfume Roubado","usar","Objeto roubado de uma pessoa ou de casas." },
	["maquiagemroubada"] = { "maquiagemroubada","Maquiagem Roubada","usar","Objeto roubado de uma pessoa ou de casas." },
	["wbody|WEAPON_DAGGER"] = { "adaga","Adaga","equipar","arma branca pontiaguda, de um punhal e dois gumes." },
	["wbody|WEAPON_BAT"] = { "beisebol","Taco de Beisebol","equipar","Um equipamento utilizado em jogos de Beisebol que pode ser utilizado como uma arma branca." },
	["wbody|WEAPON_BOTTLE"] = { "garrafa","Garrafa","equipar","Uma arma branca letal originada de uma garrafa quebrada." },
	["wbody|WEAPON_CROWBAR"] = { "cabra","Pé de Cabra","equipar","Uma ferramenta de metal que pode ser utilziada como arma." },
	["wbody|WEAPON_FLASHLIGHT"] = { "lanterna","Lanterna","equipar","Um aparelho de iluminação portátil." },
	["wbody|WEAPON_GOLFCLUB"] = { "golf","Taco de Golf","equipar","Um taco de metal utilizado nos jogos de golf que pode ser utilizado como arma." },
	["wbody|WEAPON_HAMMER"] = { "martelo","Martelo","equipar","Ferramenta com cabeça de ferro, que pode ser utilizada como arma." },
	["wbody|WEAPON_HATCHET"] = { "machado","Machado","equipar","Instrumento para o corte de madeiras que pode ser utilziado como arma branca." },
	["wbody|WEAPON_KNUCKLE"] = { "ingles","Soco-Inglês","equipar","Arma branca utilizada para aumentar a força e a contundência dos socos." },
	["wbody|WEAPON_KNIFE"] = { "faca","Faca","equipar","Instrumento com lâmina afiada que pode ser utilizada como arma branca." },
	["wbody|WEAPON_MACHETE"] = { "machete","Machete","equipar","Arma branca com lâminas estreitas com um grande comprimento." },
	["wbody|WEAPON_SWITCHBLADE"] = { "canivete","Canivete","equipar","Obejeto afiado que pode ser utilizado como arma branca." },
	["wbody|WEAPON_NIGHTSTICK"] = { "cassetete","Cassetete","equipar","Bastão utilizado pela policia em confrontos corpo a corpo." },
	["wbody|WEAPON_WRENCH"] = { "grifo","Chave de Grifo","equipar","Ferramenta para a utilização de consertos e apertos e pode ser utilizado como uma arma." },
	["wbody|WEAPON_BATTLEAXE"] = { "batalha","Machado de Batalha","equipar","Arma de curta distância projetado especificamente para o combate." },
	["wbody|WEAPON_POOLCUE"] = { "sinuca","Taco de Sinuca","equipar","Taco feito de madeira para jogos de sinuca, que pode ser utilizado como arma." },
	["wbody|WEAPON_STONE_HATCHET"] = { "pedra","Machado de Pedra","equipar","Instrumento de corte feito de pedra, que pode ser utilizado como arma." },
	["wbody|WEAPON_PISTOL"] = { "m1911","M1911","equipar","Pistola semiautomática fabricada em 1911 de calibre .45 que foi utilizada pelas Forças Armadas dos EUA." },
	["wbody|WEAPON_PISTOL_MK2"] = { "fiveseven","FN Five Seven","equipar","Pistola semiautomática fabricada em 2000 pela empresa FN Herstal, foi bastante na guerra do Afeganistão e na Guerra civil do Libano." },
	["wbody|WEAPON_COMBATPISTOL"] = { "glock","Glock 19","equipar","Pistola fabricada na Áustria que foi desenvolvida especialmente para as forças militares e Policias ." },
	["wbody|WEAPON_HEAVYPISTOL"] = { "taurus380","Taurus 380","equipar","Pistola fabricada na Áustria que foi desenvolvida especialmente para as forças militares e Policias ." },
	["wbody|WEAPON_APPISTOL"] = { "vp9","Koch VP9","equipar","Pistola automática fabricada na alemanha que foi produzida pela Fabricante Heckler & Koch (H&K)." },
	["wbody|WEAPON_STUNGUN"] = { "taser","Taser","equipar","Pistola com dois filetes de metal que disparado contra alguém solta uma carga eletrica, assim neutralizando o inimigo momentanimente." },
	["wbody|WEAPON_SNSPISTOL"] = { "hkp7m10","HK P7M10","equipar","Pistola semiautomática fabricada para a policia alemã e para as Forças Especiais do Exército Alemão." },
	["wbody|WEAPON_VINTAGEPISTOL"] = { "m1922","M1922","equipar","Pistola semiautomática fabricada em 1910 pela FN que foi utilizada na primeira guerra." },
	["wbody|WEAPON_REVOLVER"] = { "magnum44","Magnum 44","equipar","Revolver semiautomático com um grande poder de fogo." },
	["wbody|WEAPON_MUSKET"] = { "winchester22","Winchester 22","equipar","Rifle semiautomático fabrica pelo winchester, utilizado com maior frequência em caças de animais de médio e grande porte." },
	["wbody|WEAPON_FLARE"] = { "sinalizador","Sinalizador","equipar","Pistola que lança um sinal de luz e fumaça para pedidos de cargas aereas para os exercitos e para a localização e extração de soldados." },
	["wbody|GADGET_PARACHUTE"] = { "paraquedas","Paraquedas","equipar","Equipamento feito para praticar paraquedismo." },
	["wbody|WEAPON_FIREEXTINGUISHER"] = { "extintor","Extintor","equipar","Feito de pó quimíco utilizado para exitinguir e controlar um incêndio." },
	["wbody|WEAPON_MICROSMG"] = { "uzi","Uzi","equipar","Submetralhadora compacta com alta cadência de tiro, originalmente fabricada pela Israel Military Industries." },
	["wbody|WEAPON_SMG"] = { "mp5","MP5","equipar","Submetralhadora de calibre 9mm desenvolvida em 1960 e fabricada pela H&K." },
	["wbody|WEAPON_ASSAULTSMG"] = { "mtar21","MTAR-21","equipar","Fuzil de assalto de calibre 5,56 que foi desenhado originalmente para o Exército Israelence." },
	["wbody|WEAPON_COMBATPDW"] = { "sigsauer","Sig Sauer MPX","equipar","Submetralhadora operada a gás de calibre 9mm, projetada e fabricada pela SIG Sauer." },
	["wbody|WEAPON_PUMPSHOTGUN"] = { "remington","Remington 870","equipar","Espingarda Remington é de frabicação estadunidence pela empresa Remington Arms. É utilizada como tiros esportivos, caça, e defesa pessoal." },
	["wbody|WEAPON_PUMPSHOTGUN_MK2"] = { "remington970","Remington 970","equipar","Espingarda Remington é de frabicação estadunidence pela empresa Remington Arms. É utilizada como tiros esportivos, caça, e defesa pessoal." },
	["wbody|WEAPON_SAWNOFFSHOTGUN"] = { "mossberg590","Mossberg 590","equipar","Espingarda fabricada pela Mossberg & Sons de uso militar, policia e defesa pessoal." },
	["wbody|WEAPON_CARBINERIFLE"] = { "m4a1","M4A1","equipar","A ColtM4A1 de calibre 5,56 e fabricada especialmente para as Forcas Armadas dos EUA e para a policia norte-americana." },
	["wbody|WEAPON_CARBINERIFLE_MK2"] = { "m4a4","M4A4","equipar","A ColtM4A4 de calibre 5,56 e fabricada especialmente para as Forcas Armadas dos EUA e para a policia norte-americana." },
	["wbody|WEAPON_ASSAULTRIFLE"] = { "ak103","AK-103","equipar","Rifle de assalto derivado da AK-74M, com calibre 7,62. Utilziado nas forças especiais russas." },
	["wbody|WEAPON_GUSENBERG"] = { "thompson","Thompson","equipar","A Thompson representa uma família de submetralhadoras dos Estados Unidos da América. Sua utilização era comum tanto entre as forças policiais quanto entre os mafiosos e gângsteres." },
	["wbody|WEAPON_MACHINEPISTOL"] = { "tec9","Tec-9","equipar","Projetado pela INTRATC, a tec-9 é uma pistola semi-automática e automática." },
	["wbody|WEAPON_MINISMG"] = { "skorpionv61","Skorpion v61","equipar","A Skorpion foi desenvolvida para uso das forças de segurança, no entanto foi também adoptada pelas Forças Armadas Checoslovacas como arma de defesa imediata de graduados, condutores de veículos, guarnições de blindados e forças especiais. ." },
	["wbody|WEAPON_ASSAULTRIFLE_MK2"] = { "ak74","AK-74","equipar","AK-74 é um fuzil de assalto fabricado na década de 70 na União Soviética, era mais utilizadas pelas forças Especiais da Coreia do Norte e pelas Forças Especiais Russas." },
	["wbody|WEAPON_PISTOL50"] = { "deserteagle","Desert Eagle","equipar","A Desert Eagle é uma pistola semi-automática, de ação simples operada por gás que utiliza o calibre .50 ." },
	["wbody|WEAPON_SNSPISTOL_MK2"] = { "amt380","AMT 380","equipar","Pistola pequena semi-automática de .22 utilizada originalmente para defesa pessoal." },
	["wbody|WEAPON_SMG_MK2"] = { "m5k","M5K","equipar","Submetralhadora de calibre 9mm desenvolvida em 1960 e fabricada pela H&K.." },
	["wbody|WEAPON_BULLPUPRIFLE"] = { "qbz95","QBZ-95","equipar","O QBZ-95 é um fuzil de assalto, de estilo bullpup, desenvolvido e fabricado pela Norinco para as forças armadas da China de calibre 5,56." },
	["wbody|WEAPON_BULLPUPRIFLE_MK2"] = { "famasf1","Famas F1","equipar","FAMAS é um fuzil de assalto automático de origem francesa, desenvolvido e fabricado inicialmente pela MAS, utiliaza o calibre 5,56." },
	["wbody|WEAPON_SPECIALCARBINE"] = { "g36c","G36-C","equipar","A G36-c é um fuzil com coronha rebativel e de calibre 5,56 projetado nos anos 90 utilizado pelas Forças Francesas ." },
	["wbody|WEAPON_SPECIALCARBINE_MK2"] = { "g306b","G306-B","equipar","Fuzil com coronha rebativel e de calibre 5,56 projetado nos anos 2000 utilizado pelas Forças Francesas." },
	["wbody|WEAPON_STICKYBOMB"] = { "detonador","Detonador","equipar","Explosivo plástico de uso bélico." },
	["wammo|WEAPON_PISTOL"] = { "m-m1911","M. M1911","recarregar","Munição de calibre .45mm." },
	["wammo|WEAPON_PISTOL_MK2"] = { "m-fiveseven","M. FN Five Seven","recarregar","Munição de calibre 5,7x28mm." },
	["wammo|WEAPON_COMBATPISTOL"] = { "m-glock","M. Glock 19","recarregar","Munição de calibre 9x19mm." },
	["wammo|WEAPON_APPISTOL"] = { "m-vp9","M. Koch VP9","recarregar","Munição de calibre 9x19mm." },
	["wammo|WEAPON_STUNGUN"] = { "m-taser","M. Taser","recarregar","Filetes eletrizados." },
	["wammo|WEAPON_SNSPISTOL"] = { "m-hkp7m10","M. HK P7M10","recarregar","Munição de calibre .9mm." },
	["wammo|WEAPON_VINTAGEPISTOL"] = { "m-m1922","M. M1922","recarregar","Munição de calibre .45mm." },
	["wammo|WEAPON_REVOLVER"] = { "m-magnum44","M. Magnum 44","recarregar","Munição de calibre .44mm." },
	["wammo|WEAPON_MUSKET"] = { "m-winchester22","M. Winchester 22","recarregar","Munição de calibre .36mm." },
	["wammo|WEAPON_FLARE"] = { "m-sinalizador","M. Sinalizador","recarregar","Projetil térmico ao ser disparado solta fumaça vermelha e um raio de luz vermelha." },
	["wammo|GADGET_PARACHUTE"] = { "m-paraquedas","M. Paraquedas","recarregar","Paraquedas dobrado." },
	["wammo|WEAPON_FIREEXTINGUISHER"] = { "m-extintor","M. Extintor","recarregar","Pó quimíco." },
	["wammo|WEAPON_MICROSMG"] = { "m-uzi","M. Uzi","recarregar","Munição de calibre .9mm." },
	["wammo|WEAPON_SMG"] = { "m-mp5","M. MP5","recarregar","Munição de calibre .9mm." },
	["wammo|WEAPON_ASSAULTSMG"] = { "m-mtar21","M. MTAR-21","recarregar","Munição de calibre 5,56x45mm." },
	["wammo|WEAPON_COMBATPDW"] = { "m-sigsauer","M. Sig Sauer MPX","recarregar","Munição de calibre .9mm." },
	["wammo|WEAPON_HEAVYPISTOL"] = { "m-taurus380","M. Taurus 380","recarregar","Munição de calibre .9mm." },
	["wammo|WEAPON_PUMPSHOTGUN"] = { "m-remington","M. Remington 870","recarregar","Munição de calibre 12." },
	["wammo|WEAPON_PUMPSHOTGUN_MK2"] = { "m-remington970","M. Remington 970","recarregar","Munição de calibre 12." },
	["wammo|WEAPON_SAWNOFFSHOTGUN"] = { "m-mossberg590","M. Mossberg 590","recarregar","Munição de calibre 12." },
	["wammo|WEAPON_CARBINERIFLE"] = { "m-m4a1","M. M4A1","recarregar","Munição de calibre 5,56x45mm." },
	["wammo|WEAPON_CARBINERIFLE_MK2"] = { "m-m4a4","M. M4A4","recarregar","Munição de calibre 5,56x45mm." },
	["wammo|WEAPON_ASSAULTRIFLE"] = { "m-ak103","M. AK-103","recarregar","Munição de calibre 7,62x39mm." },
	["wammo|WEAPON_GUSENBERG"] = { "m-thompson","M. Thompson","recarregar","Munição de calibre .45mm." },
	["wammo|WEAPON_MACHINEPISTOL"] = { "m-tec9","M. Tec-9","recarregar","Munição de calibre .9mm." },
	["wammo|WEAPON_MINISMG"] = { "m-skorpionv61","M. Skorpion v61","recarregar","Munição de calibre .9mm." },
	["wammo|WEAPON_ASSAULTRIFLE_MK2"] = { "m-ak74","M. AK-74","recarregar","Munição de calibre 5,62x39mm." },
	["wammo|WEAPON_PISTOL50"] = { "m-deserteagle","M. Desert Eagle","recarregar","Munição de calibre .50mm." },
	["wammo|WEAPON_SNSPISTOL_MK2"] = { "m-amt380","M. AMT 380","recarregar","Munição de calibre 9mm." },
	["wammo|WEAPON_SMG_MK2"] = { "m-m5k","M. M5K","recarregar","Munição de calibre .9mm." },
	["wammo|WEAPON_BULLPUPRIFLE"] = { "m-qbz95","M. QBZ-95","recarregar","Munição de calibre 5,56x42mm." },
	["wammo|WEAPON_BULLPUPRIFLE_MK2"] = { "m-famasf1","M. Famas F1","recarregar","Munição de calibre 5,56x45mm." },
	["wammo|WEAPON_SPECIALCARBINE"] = { "m-g36c","M. G36-C","recarregar","Munição de calibre 5,56x45mm." },
	["wammo|WEAPON_SPECIALCARBINE_MK2"] = { "m-g306b","M. G306-B","recarregar","Munição de calibre 5,56x45mm." },
	["wammo|WEAPON_STICKYBOMB"] = { "c4","C4","recarregar","Explosivo plástico de uso bélico." },
	["wammo|WEAPON_PETROLCAN"] = { "combustivel","Combustível","recarregar","Gasolina inflámevel." },
	["wbody|WEAPON_PETROLCAN"] = { "gasolina","Galão de Gasolina","equipar","Galão que contém gasolina inflámevel." },
	["boxlove"] = { "boxlove","Box of Love","usar","?." },
	["c4flare"] = { "c4flare","C4 Flare","usar","Explosivo plástico de uso bélico." },
	["semente"] = { "semente", "Sementes", "usar","Sementes de Trigo utilizado para o plantio de trigo." },
	["trigo"] = { "trigo", "Trigo", "usar","Trigo utilizado para fazer algo." },
	--[Evento]--
	["balademorango"] = { "balademorango","Bala de Morango","usar","Doce entregue durante o evento." },
	["bengaladoce"] = { "bengaladoce","Bengala Doce","usar","Doce entregue durante o evento." },
	["biscoito"] = { "biscoito","Biscoito Doce","usar","Doce entregue durante o evento." },
	["chocolate"] = { "chocolate","Chocolate Amargo","usar","Doce entregue durante o evento." },
	["overcoin"] = { "overcoin","Over Coin","usar","Moeda entregue durante o evento" },
	["ceianatalina"] = { "ceianatalina","Ceia Natalina","usar","Prato saboroso feito no natal" },
	["cupcake"] = { "cupcake","Cupcake de Morango","usar","Doce entregue durante o evento." },
	["pirulito"] = { "pirulito","Pirulito Tutti-frutti","usar","Doce entregue durante o evento." },
	["carkey"] = { "carkey","Car Key","usar","Presente durante o evento, chave do veículo da Euro Import." },
	--[Itens]--
	["adrenalina"] = { "adrenalina","Adrenalina","usar","Adrenalina autoinjetável é utilizada no tratamento de pessoas com anafilaxia, uso elevado pode levar à morte." },
}

function vRP.itemNameList(item)
	if itemlist[item] ~= nil then
		return itemlist[item][2]
	end
end

function vRP.itemIndexList(item)
	if itemlist[item] ~= nil then
		return itemlist[item][1]
	end
end

function vRP.itemTypeList(item)
	if itemlist[item] ~= nil then
		return itemlist[item][3]
	end
end

function vRP.itemBodyList(item)
	if itemlist[item] ~= nil then
		return itemlist[item]
	end
end

function vRP.itemDescList(item)
	if itemlist[item] ~= nil then
		return itemlist[item][4]
	end
end



-----------------------------------------------------------------------------------------------------------------------------------------
-- VEHGLOBAL
-----------------------------------------------------------------------------------------------------------------------------------------
local vehglobal = {
	["blista"] = { "Blista",40,60000,"carros" },
	["lurcher"] = { "Lurcher",30,100000,"carros"},
	["tempra"] = { "Tempra",60,10000,"carros" },
	["vwstance"] = { "Stance Jetta",60,130000,"carros" },
	["brioso"] = { "Brioso",30,60000,"carros" },
	["dilettante"] = { "Dilettante",50,60000,"carros" },
	["issi2"] = { "Issi2",50,90000,"carros" },
	["panto"] = { "Panto",20,5000,"carros" },
	["prairie"] = { "Prairie",25,10000,"carros" },
	["rhapsody"] = { "Rhapsody",30,7000,"carros" },
	["cogcabrio"] = { "Cogcabrio",60,120000,"carros" },
	["exemplar"] = { "Exemplar",20,80000,"carros" },
	["f620"] = { "F620",30,55000,"carros" },
	["felon"] = { "Felon",50,70000,"carros" },
	["ingot"] = { "Ingot",60,160000,"carros" },
	["felon2"] = { "Felon2",40,80000,"carros" },
	["jackal"] = { "Jackal",30,60000,"carros" },
	["oracle"] = { "Oracle",50,60000,"carros" },
	["oracle2"] = { "Oracle2",60,80000,"carros" },
	["sentinel"] = { "Sentinel",40,50000,"carros" },
	["sentinel2"] = { "Sentinel2",50,60000,"carros" },
	["windsor"] = { "Windsor",20,150000,"carros" },
	["windsor2"] = { "Windsor2",40,170000,"carros" },
	["zion"] = { "Zion",40,50000,"carros" },
	["zion2"] = { "Zion2",50,60000,"carros" },
	["blade"] = { "Blade",40,100000,"carros" },
	["buccaneer"] = { "Buccaneer",50,120000,"carros" },
	["buccaneer2"] = { "Buccaneer2",60,240000,"work" },
	["primo"] = { "Primo",50,120000,"carros" },
	["primo2"] = { "Primo2",60,240000,"carros" },
	["chino"] = { "Chino",50,120000,"carros" },
	["chino2"] = { "Chino2",60,240000,"carros" },
	["coquette3"] = { "Coquette3",40,170000,"carros" },
	["dominator"] = { "Dominator",50,180000,"carros" },
	["dukes"] = { "Dukes",40,150000,"carros" },
	["faction"] = { "Faction",50,150000,"carros" },
	["faction2"] = { "Faction2",40,200000,"work" },
	["faction3"] = { "Faction3",60,350000,"carros" },
	["gauntlet"] = { "Gauntlet",40,145000,"carros" },
	["hermes"] = { "Hermes",70,280000,"carros" },
	["hotknife"] = { "Hotknife",30,180000,"carros" },
	["moonbeam"] = { "Moonbeam",80,180000,"carros" },
	["moonbeam2"] = { "Moonbeam2",70,220000,"carros" },
	["nightshade"] = { "Nightshade",30,270000,"carros" },
	["picador"] = { "Picador",90,150000,"carros" },
	["ratloader2"] = { "Ratloader2",70,180000,"carros" },
	["ruiner"] = { "Ruiner",50,150000,"carros" },
	["sabregt"] = { "Sabregt",60,240000,"carros" },
	["sabregt2"] = { "Sabregt2",60,150000,"work" },
	["slamvan"] = { "Slamvan",80,150000,"carros" },
	["slamvan2"] = { "Slamvan2",80,190000,"carros" },
	["slamvan3"] = { "Slamvan3",80,200000,"carros" },
	["stalion"] = { "Stalion",30,150000,"carros" },
	["tampa"] = { "Tampa",40,170000,"carros" },
	["vigero"] = { "Vigero",30,170000,"carros" },
	["virgo"] = { "Virgo",60,150000,"carros" },
	["virgo2"] = { "Virgo2",50,250000,"carros" },
	["virgo3"] = { "Virgo3",60,180000,"carros" },
	["voodoo"] = { "Voodoo",60,220000,"carros" },
	["yosemite"] = { "Yosemite",100,350000,"carros" },
	["bfinjection"] = { "Bfinjection",20,80000,"carros" },
	["bifta"] = { "Bifta",20,190000,"carros" },
	["bodhi2"] = { "Bodhi2",90,170000,"carros" },
	["brawler"] = { "Brawler",40,300000,"carros" },
	["trophytruck"] = { "Trophytruck",45,450000,"carros" },
	["dubsta3"] = { "Dubsta3",70,240000,"carros" },
	["mesa3"] = { "Mesa3",60,160000,"carros" },
	["rancherxl"] = { "Rancherxl",70,200000,"carros" },
	["rebel"] = { "Rebel",100,220000,"carros" },
	["rebel2"] = { "Rebel2",100,250000,"carros" },
	["riata"] = { "Riata",80,250000,"carros" },
	["dloader"] = { "Dloader",40,150000,"carros" },
	["sandking"] = { "Sandking",100,350000,"carros" },
	["sandking2"] = { "Sandking2",100,300000,"carros" },
	["baller"] = { "Baller",50,120000,"carros" },
	["baller2"] = { "Baller2",50,130000,"carros" },
	["baller3"] = { "Baller3",50,140000,"carros" },
	["baller4"] = { "Baller4",50,150000,"work" },
	["baller5"] = { "Baller5",50,600000,"carros" },
	["baller6"] = { "Baller6",50,610000,"carros" },
	["bjxl"] = { "Bjxl",50,100000,"carros" },
	["cavalcade"] = { "Cavalcade",60,110000,"carros" },
	["cavalcade2"] = { "Cavalcade2",60,130000,"carros" },
	["contender"] = { "Contender",70,240000,"carros" },
	["dubsta"] = { "Dubsta",80,150000,"carros" },
	["dubsta2"] = { "Dubsta2",80,180000,"carros" },
	["fq2"] = { "Fq2",50,100000,"carros" },
	["granger"] = { "Granger",100,280000,"carros" },
	["gresley"] = { "Gresley",50,150000,"carros" },
	["habanero"] = { "Habanero",50,100000,"carros" },
	["seminole"] = { "Seminole",60,110000,"carros" },
	["serrano"] = { "Serrano",50,150000,"carros" },
	["xls"] = { "Xls",50,150000,"carros" },
	["xls2"] = { "Xls2",50,650000,"carros" },
	["asea"] = { "Asea",30,50000,"carros" },
	["asterope"] = { "Asterope",30,60000,"carros" },
	["cog55"] = { "Cog55",50,200000,"carros" },
	["cog552"] = { "Cog552",50,350000,"carros" },
	["cognoscenti"] = { "Cognoscenti",50,250000,"carros" },
	["cognoscenti2"] = { "Cognoscenti2",50,350000,"carros" },
	["stanier"] = { "Stanier",60,60000,"carros" },
	["stratum"] = { "Stratum",70,70000,"carros" },
	["superd"] = { "Superd",50,200000,"work" },
	["surge"] = { "Surge",60,100000,"carros" },
	["tailgater"] = { "Tailgater",50,100000,"carros" },
	["warrener"] = { "Warrener",40,90000,"carros" },
	["washington"] = { "Washington",60,120000,"carros" },
	["alpha"] = { "Alpha",40,160000,"carros" },
	["banshee"] = { "Banshee",30,240000,"carros" },
	["bestiagts"] = { "Bestiagts",60,220000,"carros" },
	["blista2"] = { "Blista2",40,50000,"carros" },
	["blista3"] = { "Blista3",40,70000,"carros" },
	["buffalo"] = { "Buffalo",50,240000,"carros" },
	["buffalo2"] = { "Buffalo2",50,240000,"carros" },
	["carbonizzare"] = { "Carbonizzare",50,250000,"carros" },
	["comet2"] = { "Comet2",40,200000,"carros" },
	["comet3"] = { "Comet3",40,230000,"carros" },
	["coquette"] = { "Coquette",30,200000,"carros" },
	["elegy"] = { "Elegy",50,460000,"carros" },
	["elegy2"] = { "Elegy2",30,480000,"carros" },
	["feltzer2"] = { "Feltzer2",50,200000,"carros" },
	["furoregt"] = { "Furoregt",30,250000,"carros" },
	["fusilade"] = { "Fusilade",50,180000,"carros" },
	["futo"] = { "Futo",40,150000,"carros" },
	["jester"] = { "Jester",30,120000,"carros" },
	["khamelion"] = { "Khamelion",50,180000,"carros" },
	["kuruma"] = { "Kuruma",30,250000,"carros" },
	["massacro"] = { "Massacro",50,290000,"carros" },
	["ninef"] = { "Ninef",40,250000,"carros" },
	["ninef2"] = { "Ninef2",40,250000,"carros" },
	["omnis"] = { "Omnis",20,210000,"carros" },
	["pariah"] = { "Pariah",30,400000,"carros" },
	["penumbra"] = { "Penumbra",40,120000,"carros" },
	["raiden"] = { "Raiden",70,210000,"carros" },
	["rapidgt"] = { "Rapidgt",20,220000,"carros" },
	["rapidgt2"] = { "Rapidgt2",20,240000,"carros" },
	["ruston"] = { "Ruston",20,300000,"carros" },
	["schafter3"] = { "Schafter3",50,180000,"carros" },
	["schafter4"] = { "Schafter4",50,190000,"carros" },
	["schafter4"] = { "Schafter6",50,690000,"carros" },
	["schwarzer"] = { "Schwarzer",50,150000,"carros" },
	["sentinel3"] = { "Sentinel3",30,150000,"carros" },
	["seven70"] = { "Seven70",20,450000,"carros" },
	["specter"] = { "Specter",20,280000,"carros" },
	["specter2"] = { "Specter2",20,310000,"carros" },
	["streiter"] = { "Streiter",70,200000,"carros" },
	["sultan"] = { "Sultan",50,150000,"carros" },
	["surano"] = { "Surano",30,270000,"carros" },
	["tampa2"] = { "Tampa2",20,180000,"carros" },
	["tropos"] = { "Tropos",20,150000,"carros" },
	["verlierer2"] = { "Verlierer2",20,330000,"carros" },
	["btype"] = { "Btype",40,320000,"carros" },
	["btype2"] = { "Btype2",20,400000,"carros" },
	["btype3"] = { "Btype3",40,340000,"work" },
	["casco"] = { "Casco",50,310000,"carros" },
	["cheetah"] = { "Cheetah",20,370000,"carros" },
	["coquette2"] = { "Coquette2",40,250000,"carros" },
	["feltzer3"] = { "Feltzer3",50,200000,"carros" },
	["gt500"] = { "Gt500",40,250000,"carros" },
	["infernus2"] = { "Infernus2",20,250000,"carros" },
	["jb700"] = { "Jb700",30,200000,"carros" },
	["mamba"] = { "Mamba",50,240000,"carros" },
	["manana"] = { "Manana",70,120000,"carros" },
	["monroe"] = { "Monroe",20,240000,"carros" },
	["peyote"] = { "Peyote",70,150000,"carros" },
	["pigalle"] = { "Pigalle",60,250000,"carros" },
	["rapidgt3"] = { "Rapidgt3",40,190000,"carros" },
	["retinue"] = { "Retinue",40,150000,"carros" },
	["stinger"] = { "Stinger",60,200000,"carros" },
	["stingergt"] = { "Stingergt",20,230000,"carros" },
	["torero"] = { "Torero",30,160000,"carros" },
	["tornado"] = { "Tornado",70,140000,"carros" },
	["tornado2"] = { "Tornado2",60,160000,"carros" },
	["tornado5"] = { "Tornado5",60,250000,"carros" },
	["turismo2"] = { "Turismo2",30,250000,"carros" },
	["viseris"] = { "Viseris",20,210000,"carros" },
	["ztype"] = { "Ztype",20,400000,"carros" },
	["adder"] = { "Adder",20,500000,"carros" },
	["autarch"] = { "Autarch",20,610000,"carros" },
	["banshee2"] = { "Banshee2",20,300000,"carros" },
	["bullet"] = { "Bullet",20,350000,"carros" },
	["cheetah2"] = { "Cheetah2",20,210000,"carros" },
	["entityxf"] = { "Entityxf",20,400000,"carros" },
	["fmj"] = { "Fmj",20,450000,"carros" },
	["gp1"] = { "Gp1",20,430000,"carros" },
	["infernus"] = { "Infernus",20,410000,"carros" },
	["nero"] = { "Nero",30,390000,"carros" },
	["nero2"] = { "Nero2",20,420000,"carros" },
	["osiris"] = { "Osiris",20,400000,"carros" },
	["penetrator"] = { "Penetrator",20,420000,"carros" },
	["pfister811"] = { "Pfister811",20,460000,"carros" },
	["reaper"] = { "Reaper",20,500000,"carros" },
	["sc1"] = { "Sc1",20,430000,"carros" },
	["sultanrs"] = { "Sultan RS",30,400000,"carros" },
	["t20"] = { "T20",30,650000,"carros" },
	["tempesta"] = { "Tempesta",20,520000,"carros" },
	["turismor"] = { "Turismor",20,500000,"carros" },
	["tyrus"] = { "Tyrus",20,500000,"carros" },
	["vacca"] = { "Vacca",30,500000,"carros" },
	["visione"] = { "Visione",20,600000,"carros" },
	["voltic"] = { "Voltic",20,400000,"carros" },
	["zentorno"] = { "Zentorno",20,700000,"carros" },
	["sadler"] = { "Sadler",70,200000,"carros" },
	["bison"] = { "Bison",70,220000,"carros" },
	["bison2"] = { "Bison2",70,200000,"carros" },
	["bobcatxl"] = { "Bobcatxl",100,280000,"carros" },
	["burrito"] = { "Burrito",100,300000,"carros" },
	["burrito2"] = { "Burrito2",100,300000,"carros" },
	["burrito3"] = { "Burrito3",100,300000,"carros" },
	["gburrito"] = { "Burrito-MC",100,300000,"carros" },
	["burrito4"] = { "Burrito4",100,300000,"carros" },
	["minivan"] = { "Minivan",70,100000,"carros" },
	["minivan2"] = { "Minivan2",60,200000,"carros" },
	["paradise"] = { "Paradise",100,240000,"carros" },
	["pony"] = { "Pony",100,240000,"carros" },
	["pony2"] = { "Pony2",100,240000,"carros" },
	["rumpo"] = { "Rumpo",100,240000,"carros" },
	["rumpo2"] = { "Rumpo2",100,240000,"carros" },
	["rumpo3"] = { "Rumpo3",100,250000,"carros" },
	["speedo"] = { "Speedo",100,240000,"carros" },
	["surfer"] = { "Surfer",80,50000,"carros" },
	["youga"] = { "Youga",100,240000,"carros" },
	["youga2"] = { "Youga2",100,240000,"carros" },
	["huntley"] = { "Huntley",60,100000,"carros" },
	["landstalker"] = { "Landstalker",70,130000,"carros" },
	["mesa"] = { "Mesa",50,90000,"carros" },
	["patriot"] = { "Patriot",70,250000,"carros" },
	["radi"] = { "Radi",50,100000,"carros" },
	["rocoto"] = { "Rocoto",60,100000,"carros" },
	["tyrant"] = { "Tyrant",30,600000,"carros" },
	["entity2"] = { "Entity2",20,480000,"carros" },
	["cheburek"] = { "Cheburek",50,150000,"carros" },
	["hotring"] = { "Hotring",60,300000,"carros" },
	["jester3"] = { "Jester3",30,240000,"carros" },
	["flashgt"] = { "Flashgt",50,320000,"carros" },
	["ellie"] = { "Ellie",50,300000,"carros" },
	["michelli"] = { "Michelli",40,160000,"carros" },
	["fagaloa"] = { "Fagaloa",80,300000,"carros" },
	["dominator3"] = { "Dominator3",30,300000,"carros" },
	["issi3"] = { "Issi3",20,160000,"carros" },
	["taipan"] = { "Taipan",20,500000,"carros" },
	["gb200"] = { "Gb200",20,170000,"carros" },
	["stretch"] = { "Stretch",60,500000,"carros" },
	["guardian"] = { "Guardian",100,500000,"carros" },
	["kamacho"] = { "Kamacho",80,400000,"carros" },
	["neon"] = { "Neon",30,500000,"carros" },
	["cyclone"] = { "Cyclone",20,800000,"carros" },
	["italigtb"] = { "Italigtb",20,520000,"carros" },
	["italigtb2"] = { "Italigtb2",20,530000,"carros" },
	["vagner"] = { "Vagner",20,590000,"carros" },
	["xa21"] = { "Xa21",20,550000,"carros" },
	["tezeract"] = { "Tezeract",20,800000,"carros" },
	["prototipo"] = { "Prototipo",20,900000,"carros" },
	["patriot2"] = { "Patriot2",60,550000,"carros" },
	["speedo4"] = { "Speedo4",100,240000,"carros" },
	["stafford"] = { "Stafford",40,400000,"carros" },
	["swinger"] = { "Swinger",20,250000,"carros" },
	["brutus"] = { "Brutus",100,350000,"carros" },
	["clique"] = { "Clique",40,360000,"carros" },
	["deveste"] = { "Deveste",20,800000,"carros" },
	["deviant"] = { "Deviant",50,300000,"carros" },
	["impaler"] = { "Impaler",60,300000,"carros" },
	["imperator"] = { "Imperator",50,400000,"carros" },
	["italigto"] = { "Italigto",30,700000,"carros" },
	["schlagen"] = { "Schlagen",30,600000,"carros" },
	["toros"] = { "Toros",50,400000,"carros" },
	["tulip"] = { "Tulip",40,250000,"carros" },
	["vamos"] = { "Vamos",60,320000,"carros" },
	["akuma"] = { "Akuma",15,420000,"motos" },
	["avarus"] = { "Avarus",15,270000,"motos" },
	["bagger"] = { "Bagger",40,240000,"motos" },
	["bati"] = { "Bati",15,300000,"motos" },
	["bf400"] = { "Bf400",15,260000,"motos" },
	["carbonrs"] = { "Carbonrs",15,300000,"motos" },
	["chimera"] = { "Chimera",15,280000,"motos" },
	["cliffhanger"] = { "Cliffhanger",15,250000,"motos" },
	["daemon"] = { "Daemon",15,200000,"motos" },
	["daemon2"]  = { "Daemon2",15,200000,"motos" },
	["defiler"] = { "Defiler",15,380000,"motos" },
	["diablous"] = { "Diablous",15,350000,"motos" },
	["diablous2"] = { "Diablous2",15,380000,"motos" },
	["double"] = { "Double",25,300000,"motos" },
	["enduro"] = { "Enduro",15,160000,"motos" },
	["esskey"] = { "Esskey",15,260000,"motos" },
	["faggio"] = { "Faggio",30,4000,"motos" },
	["faggio2"] = { "Faggio2",30,5000,"motos" },
	["faggio3"] = { "Faggio3",30,5000,"motos" },
	["foxharley1"] = { "Fox Harly",15,1600000,"import" },
	["fcr"] = { "Fcr",15,320000,"motos" },
	["fcr2"] = { "Fcr2",15,320000,"motos" },
	["gargoyle"] = { "Gargoyle",15,280000,"motos" },
	["hakuchou"] = { "Hakuchou",15,310000,"motos" },
	["hakuchou2"] = { "Hakuchou2",15,450000,"motos" },
	["hexer"] = { "Hexer",15,180000,"motos" },
	["innovation"] = { "Innovation",15,210000,"motos" },
	["lectro"] = { "Lectro",15,310000,"motos" },
	["manchez"] = { "Manchez",15,290000,"motos" },
	["nemesis"] = { "Nemesis",15,280000,"motos" },
	["nightblade"] = { "Nightblade",15,340000,"motos" },
	["pcj"] = { "Pcj",15,60000,"motos" },
	["ruffian"] = { "Ruffian",15,280000,"motos" },
	["sanchez"] = { "Sanchez",15,150000,"motos" },
	["sanchez2"] = { "Sanchez2",15,150000,"motos" },
	["sanctus"] = { "Sanctus",15,350000,"motos" },
	["sovereign"] = { "Sovereign",30,260000,"motos" },
	["thrust"] = { "Thrust",15,300000,"motos" },
	["vader"] = { "Vader",15,280000,"motos" },
	["vindicator"] = { "Vindicator",15,250000,"motos" },
	["vortex"] = { "Vortex",15,300000,"motos" },
	["wolfsbane"] = { "Wolfsbane",15,230000,"motos" },
	["zombiea"] = { "Zombiea",15,230000,"motos" },
	["zombieb"] = { "Zombieb",15,235000,"motos" },
	["blazer"] = { "Blazer",20,190000,"motos" },
	["blazer4"] = { "Blazer4",20,270000,"motos" },
	["deathbike"] = { "Deathbike",15,350000,"motos" },
	["ratbike"] = { "Rat Bike",20,350000,"motos" },
	["shotaro"] = { "Shotaro",15,1000000,"motos" },
	-- [POLICIA] --
	["policiabmwr1200"] = { "BMW R1200",0,1000,"work" },
	["policiaschaftersid"] = { "Police Sid",0,1000,"work" },
	["policiacapricesid"] = { "Police Sid2",0,1000,"work" },
	["fbi2"] = { "Police Sid3",0,1000,"work" },
	["policiamustanggt"] = { "Ford Mustang GT",0,1000,"work" },
	["policiacharger2018"] = { "Dodge Charger 2018",0,1000,"work" },
	["policiavictoria"] = { "Crown Victoria",0,1000,"work" },
	["policiaexplorer"] = { "Ford Explorer",0,1000,"work" },
	["policiatahoe"] = { "Chevrolet Tahoe ",0,1000,"work" },
	["policiasilverado"] = { "Chevrolet Silverado",0,1000,"work" },
	["policiataurus"] = { "Ford Taurus",0,1000,"work" },
	["policeb"] = { "Police Motors",1000,"work" },
	["pbus"] = { "Ônibus",0,1000,"work" },
	["riot"] = { "Blindado",0,1000,"work" },
	["policiaheli"] = { "Helicóptero",0,1000,"work" },
	-- [PARAMEDICO] --
	["paramedicoambu"] = { "Ambulância",0,1000,"work" },
	["paramedicosilverado"] = { "Chevrolet Silverado",0,1000,"work" },
	["paramedicocharger2014"] = { "Dodge Charger 2014",0,1000,"work" },
	["paramedicoheli"] = { "Helicóptero",0,1000,"work" },
	["paramedicotahoe"] = { "Chevrolet Tahoe",0,1000,"work" },
	["paramedicobmwr1200"] = { "Bmw R1200",0,1000,"work" },
	-- [Motorista] --
	["coach"] = { "Coach",0,1000,"work" },
	["bus"] = { "Ônibus",0,1000,"work" },
	-- [MECANICO] --
	["flatbed"] = { "Reboque",0,1000,"work" },
	["towtruck2"] = { "Guincho",0,1000,"work" },
	["flatbed3"] = { "Reboque2",0,1000,"work" },
	-- [MINERACAO] --
	["ratloader"] = { "Caminhão",0,1000,"carros" },
	["rubble"] = { "Caminhão",0,1000,"carros" },
	-- [TAXI] --
	["taxi"] = { "Taxi",0,1000,"work" },
	-- [CARTEIRO] --
	["boxville2"] = { "Caminhão",0,1000,"carros" },
	-- [LIXEIRO] --
	["trash"] = { "Caminhão",0,1000,"carros" },
	-- [BICICLETARIO] --
	["scorcher"] = { "Bicicleta",0,1000,"work" },
	["tribike"] = { "Tribike",0,1000,"work" },
	["tribike2"] = { "Tribike2",0,1000,"work" },
	["tribike3"] = { "Tribike3",0,1000,"work" },
	["fixter"] = { "Fixter",0,1000,"work" },
	["cruiser"] = { "Cruiser",0,1000,"work" },
	["bmx"] = { "Bmx",0,1000,"work" },
	-- [EMBARCACOES] --
	["dinghy"] = { "Dinghy",0,1000,"work" },
	["jetmax"] = { "Jetmax",0,1000,"work" },
	["marquis"] = { "Marquis",0,1000,"work" },
	["seashark3"] = { "Seashark3",0,1000,"work" },
	["speeder"] = { "Speeder",0,1000,"work" },
	["speeder2"] = { "Speeder2",0,1000,"work" },
	["squalo"] = { "Squalo",0,1000,"work" },
	["suntrap"] = { "Suntrap",0,1000,"work" },
	["toro"] = { "Toro",0,1000,"work" },
	["toro2"] = { "Toro2",0,1000,"work" },
	["tropic"] = { "Tropic",0,1000,"work" },
	["tropic2"] = { "Tropic2",0,1000,"work" },
	-- [CAMINHONEIRO] --
	["phantom"] = { "Phantom",0,1000,"work" },
	["packer"] = { "Packer",0,1000,"work" },
	["supervolito"] = { "Supervolito",0,1000,"work" },
	["supervolito2"] = { "Supervolito2",0,1000,"work" },
	["cuban800"] = { "Cuban800",0,1000,"work" },
	["mammatus"] = { "Mammatus",0,1000,"work" },
	["vestra"] = { "Vestra",0,1000,"work" },
	["velum2"] = { "Velum2",0,1000,"work" },
	["buzzard2"] = { "Buzzard2",0,1000,"work" },
	["frogger"] = { "Frogger",0,1000,"work" },
	["maverick"] = { "Maverick",0,1000,"work" },
	["tanker2"] = { "Gas",0,1000,"work" },
	["armytanker"] = { "Diesel",0,1000,"work" },
	["tvtrailer"] = { "Show",0,1000,"work" },
	["trailerlogs"] = { "Woods",0,1000,"work" },
	["tr4"] = { "Cars",0,1000,"work" },
	-- [ENTREGADOR] --
	["enduro"] = { "Enduro",0,1000,"work" },
	-- [VALORES]
	["stockade"] = { "StockKade",0,1000,"carros" },
	-- [WEAZELNEWS] --
	["newsvan"] = { "Weazel Van 01",0,1000,"carros" },
	["newsvan2"] = { "Weazel Van 02",0,1000,"carros" },
	["newsheli2"] = { "Helicóptero",0,1000,"carros" },
	-- [IMPORTADOS] --
	--["nissangtr2"] = { "Nissan GTR EE",30,1200000,"import" },
	--["chevcorvette"] = { "Chevrolet Corvette",40,1500000,"import" },
	--["civictyper"] = { "Honda Civic Type R",50,850000,"import" },
	["ferrariitalia"] = { "Ferrari Italia 478",30,2200000,"import" },
	["hvrod"] = { "Harley Hvrod",30,750000,"import" },
	["bobber"] = { "Harley Bobber",30,850000,"import" },
	["bobbes2"] = { "Harley Bobbes2",30,950000,"import" },
	["fordmustang"] = { "Ford Mustang",40,1250000,"import" },
	["nissangtr"] = { "Nissan GTR",30,2000000,"import" },
	["nissangtrnismo"] = { "Nissan GTR Nismo",40,1850000,"import" },
	["teslaprior"] = { "Tesla Prior",50,1300000,"import" },
	["nissanskyliner34"] = { "Nissan Skyline R34",40,2500000,"import" },
	["audirs6"] = { "Audi RS6",60,950000,"import" },
	["bmwm3f80"] = { "BMW M3 F80",50,1100000,"import" },
	["bmwm4gts"] = { "BMW M4 GTS",50,1450000,"import" },
	["lancerevolutionx"] = { "Lancer Evolution X",50,1500000,"import" },
	["toyotasupra"] = { "Toyota Supra",40,1850000,"import" },
	["foxsupra"] = { "Toyota Fox Supra",40,2000000,"premiums" },
	["tonkat"] = { "Toyota Tonkat",100,1250000,"import" },
	["foxshelby"] = { "Ford Mustang Shelby",30,1600000,"import" },
	["foxsian"] = { "Lamborghini Sian",30,2000000,"premiums"},
	["nissan370z"] = { "Nissan 370z",30,1100000,"import" },
	["lamborghinihuracan"] = { "Lamborghini Huracan",40,2500000,"import" },
	["foxevo"] = { "Lamborghini Evo",40,2500000,"import" },
	["dodgechargersrt"] = { "Dodge Charger SRT",40,1750000,"import" },
	["mazdarx7"] = { "Mazda RX7",40,850000,"import" },
	["z1000"] = { "Kawasaki R1000",20,1700000,"premiums" },
	["raptor2017"] = { "Ford Raptor",100,1000000,"import" },
	["bmws"] = { "Bmw R1000",20,1700000,"premiums" },
	["911tbs"] = { "Porsche 911 TBS",50,1400000,"import" },
	["veneno"] = { "Lamborghini Veneno",40,1750000,"premiums" },
	--["bmwm3e36"] = { "BMW M3 E36",50,2950000,"premiums" },
	--["mercedesgt63"] = { "Mercedes GT63",50,2850000,"premiums" },
	--["ferrarif12"] = { "Ferrari F12",30,4700000,"premiums" },
	["i8"] = { "BMW I8",30,1600000,"premiums" },
	--["silvias15"] = { "Silvia S15",30,950000,"premiums" },
	["benson"] = { "Benson",300,800000,"carros" },
	["brickade"] = { "Brickade",400,1000000,"carros" },
	["paganihuayra"] = { "Pagani Huayra",30,2500000,"premiums" },
	["C7"] = { "Corvette",30,1500000,"premiums" },
	--["SVR14"] = { "Range Rover Sport",650000,50,650000,"premiums" },
	["2016RS7"] = { "Audi RS7",50,950000,"premiums" },
	["m6f13"] = { "Bmw M6",50,2000000,"premiums" },
	["trhawk"] = { "Jeep cherokee SRT",50,1350000,"premiums" },
	["BOSS429"] = { "Ford Mustang 1967",40,1300000,"premiums" },
	["z4bmw"] = { "Bmw Z4",40,2250000,"premiums" },
	["x6m"] = { "Bmw X6",70,2500000,"premiums" },
	["rmodmi8"] = { "Bmw I8",50,2000000,"premiums" },
	["r8v10abt"] = { "Audi R8",50,1500000,"premiums" },
	["W900"] = { "W900",80,500000,"premiums" },
	["lp700r"] = { "Lamborghini Aventador",40,5750000,"premiums" },
	["gt17"] = { "Ford GT",50,1500000,"premiums" },
	["panamera17turbo"] = { "Porsche Panamera",50,2000000,"premiums" },
	["19ftype"] = { "Jaguar F-type",50,1500000,"premiums" },
	["zx10r"] = { "Kawasaki ZXR10",20,2300000,"import" },
	["rc"] = { "Kawasaki RC200",20,750000,"import" },
	["mule3"] = { "Mule3",300,750000,"premiums" },
	["porsche992"] = { "Porsche 992",50,3250000,"premiums" },
	["mule"] = { "Mule",150,500000,"premiums" },
	["zl12017"] = { "Chevrolet Camaro",40,1300000,"premiums" },
	["16challenger"] = { "Dodge Challenger V8 Hemi",50,1750000,"premiums" },
	["camper"] = { "Motorhome",30,250000,"carros" },
	["raptor"] = { "Raptor",30,140000,"motos" },
	["schafter6"] = { "Shafter 6",30,840000,"carros" },
	["p1"] = { "2014 McLaren P1",30,2000000,"carros" },
	["senna"] =  { "Exclusive Senna",40,1500000,"carros"},
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- VEHICLEGLOBAL
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.vehicleGlobal()
	return vehglobal
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- VEHICLENAME
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.vehicleName(vname)
	if vehglobal[vname] then
		return vehglobal[vname][1]
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- VEHICLECHEST
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.vehicleChest(vname)
	if vehglobal[vname] then
		return vehglobal[vname][2]
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- VEHICLEPRICE
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.vehiclePrice(vname)
	if vehglobal[vname] then
		return vehglobal[vname][3]
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- VEHICLETYPE
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.vehicleType(vname)
	if vehglobal[vname] then
		return vehglobal[vname][4]
	end
end
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")
local Tools = module("vrp","lib/Tools")
emP = {}
Tunnel.bindInterface("vrp_policia",emP)


local idgens = Tools.newIDGenerator()

--ALTER TABLE `vrp_user_vehicles` ADD `preso` int(1) unsigned NOT NULL DEFAULT 0;

-----------------------------------------------------------------------------------------------------------------------------------------
-- PLACA
-----------------------------------------------------------------------------------------------------------------------------------------
local plateOne = {
	[1] = { "Dylan" },
	[2] = { "Adam" },
	[3] = { "Alan" },
	[4] = { "Alvin" },
	[5] = { "Andrew" },
	[6] = { "Antony" },
	[7] = { "Arnold" },
	[8] = { "Bernard" },
	[9] = { "Bryan" },
	[10] = { "Calvin" },
	[11] = { "Charlie" },
	[12] = { "David" },
	[13] = { "Edward" },
	[14] = { "Enrico" },
	[15] = { "Eric" },
	[16] = { "Tom" },
	[17] = { "Oliver" },
	[18] = { "Patrick" },
	[19] = { "Richard" },
	[20] = { "Robert" },
	[21] = { "Ashley" },
	[22] = { "Adele" },
	[23] = { "Agnella" },
	[24] = { "Darla" },
	[25] = { "Emily" },
	[26] = { "Emma" },
	[27] = { "Francine" },
	[28] = { "Karolyn" },
	[29] = { "Katelyn" },
	[30] = { "Katherine" },
	[31] = { "Katie" },
	[32] = { "Mary" },
	[33] = { "Melanie" },
	[34] = { "Micheline" },
	[35] = { "Natalie" },
	[36] = { "Sophie" },
	[37] = { "Stephanie" },
	[38] = { "Susan" },
	[39] = { "Valerie" },
	[40] = { "Wendy" }
}

local plateTwo = {
	[1] = { "Wright" },
	[2] = { "Smith" },
	[3] = { "Johnson" },
	[4] = { "Williams" },
	[5] = { "Jones" },
	[6] = { "Scott" },
	[7] = { "Hall" },
	[8] = { "Adams" },
	[9] = { "Carter" },
	[10] = { "Mitchell" },
	[11] = { "Parker" },
	[12] = { "Evans" },
	[13] = { "Edwards" },
	[14] = { "Collins" },
	[15] = { "Stewart" },
	[16] = { "Morris" },
	[17] = { "Reed" },
	[18] = { "Moore" },
	[19] = { "Cooper" },
	[20] = { "Taylor" },
	[21] = { "Jackson" },
	[22] = { "White" },
	[23] = { "Harris" },
	[24] = { "Thompson" },
	[25] = { "Martinez" },
	[26] = { "Torres" },
	[27] = { "Watson" },
	[28] = { "Sanders" },
	[29] = { "Bennett" },
	[30] = { "Lee" },
	[31] = { "Baker" },
	[32] = { "Barnes" },
	[33] = { "Ross" },
	[34] = { "Jenkins" },
	[35] = { "Perry" },
	[36] = { "Patterson" },
	[37] = { "Hughes" },
	[38] = { "Simmons" },
	[39] = { "Foster" },
	[40] = { "Gonzalez" }
}

RegisterCommand('placa',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"policia.permissao") then
		if args[1] then
			local user_id = vRP.getUserByRegistration(args[1])
			if user_id then
				local identity = vRP.getUserIdentity(user_id)
				if identity then
					vRPclient.playSound(source,"Event_Message_Purple","GTAO_FM_Events_Soundset")
					TriggerClientEvent('chatMessage',source,"Dispatch",{65,130,255},"^1Passaporte: ^0"..identity.user_id.."   ^2|   ^1Placa: ^0"..identity.registration.."   ^2|   ^1Proprietário: ^0"..identity.name.." "..identity.firstname.."   ^2|   ^1Telefone: ^0"..identity.phone)
				end
			else
				vRPclient.playSound(source,"Event_Message_Purple","GTAO_FM_Events_Soundset")
				TriggerClientEvent('chatMessage',source,"Dispatch",{65,130,255},"^1Passaporte: ^0"..vRP.format(parseInt(math.random(5000,9999))).."   ^2|   ^1Placa: ^0"..args[1].."   ^2|   ^1Proprietário: ^0"..plateOne[math.random(#plateOne)][1].." "..plateTwo[math.random(#plateTwo)][1].."   ^2|   ^1Telefone: ^0"..vRP.generatePhoneNumber())
			end
		else
			local vehicle,vnetid,placa,vname,lock,banned = vRPclient.vehList(source,7)
			local placa_user_id = vRP.getUserByRegistration(placa)
			if placa_user_id then
				local identity = vRP.getUserIdentity(placa_user_id)
				if identity then
					vRPclient.playSound(source,"Event_Message_Purple","GTAO_FM_Events_Soundset")
					TriggerClientEvent('chatMessage',source,"Dispatch",{65,130,255},"^1Passaporte: ^0"..identity.user_id.."   ^2|   ^1Placa: ^0"..identity.registration.."   ^2|   ^1Proprietário: ^0"..identity.name.." "..identity.firstname.."   ^2|   ^1Telefone: ^0"..identity.phone)
				end
			else
				vRPclient.playSound(source,"Event_Message_Purple","GTAO_FM_Events_Soundset")
				TriggerClientEvent('chatMessage',source,"Dispatch",{65,130,255},"^1Passaporte: ^0"..vRP.format(parseInt(math.random(5000,9999))).."   ^2|   ^1Placa: ^0"..placa.."   ^2|   ^1Proprietário: ^0"..plateOne[math.random(#plateOne)][1].." "..plateTwo[math.random(#plateTwo)][1].."   ^2|   ^1Telefone: ^0"..vRP.generatePhoneNumber())
			end
		end
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- PAYTOW
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('paytow',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local identitys = vRP.getUserIdentity(user_id)
	if vRP.hasPermission(user_id,"policia.permissao") then
		local nplayer = vRPclient.getNearestPlayer(source,2)
		if nplayer then
			local nuser_id = vRP.getUserId(nplayer)
			local mecanico = vRP.getUserIdentity(nuser_id)
			if nuser_id then
				vRP.giveMoney(nuser_id,500)
				vRPclient._playAnim(source,true,{{"mp_common","givetake1_a"}},false)
				TriggerClientEvent("Notify",source,"sucesso","Efetuou o pagamento pelo serviço do mecânico.")
				TriggerClientEvent("Notify",nplayer,"sucesso","Recebeu <b>$500 reais</b> pelo serviço de mecânico.")
				DISCORD_WEBHOOK = "https://discordapp.com/api/webhooks/662440366271889427/BWWnSMSnZd3QEWu_N8n1DtZ6dqC8j5VNSYQSuaj2dMsFFUhZyHLzvnEYvxk5AN23rtO4"
                TriggerEvent("everest:postarDiscord", source, DISCORD_WEBHOOK, "PAGAMENTO POR SERVIÇO", "POLICIAL: "..identitys.name.." "..identitys.firstname.."\n MECÂNICO: "..mecanico.name.." "..mecanico.firstname.."\n PASSAPORTE: "..nuser_id.."\n VALOR: $500", 16711680)
			end
		end
	end
end)

function emP.checkPermission(perm)
	local source = source
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,perm) then
		return true
	else
		return false
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TOOGLE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('toogle',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"policia.permissao") then
		DISCORD_WEBHOOK = "https://discordapp.com/api/webhooks/694063563441963109/IRe8EF-FIGOlX95QvC-l8aXrr-a6QQEd0OMRCXMCI_9s3hG0PfzfhuUCrSEUh8_cfVX5"
		TriggerEvent("everest:postarDiscord", source, DISCORD_WEBHOOK, "ELETRÔNICO POLICIA","SAIU DE SERVIÇO")
		TriggerEvent('eblips:remove',source)
		vRP.addUserGroup(user_id,"PaisanaPolicia")
		TriggerClientEvent("Notify",source,"sucesso","Você saiu de serviço.")
	elseif vRP.hasPermission(user_id,"paisanapolicia.permissao") then
		DISCORD_WEBHOOK = "https://discordapp.com/api/webhooks/694063563441963109/IRe8EF-FIGOlX95QvC-l8aXrr-a6QQEd0OMRCXMCI_9s3hG0PfzfhuUCrSEUh8_cfVX5"
		TriggerEvent("everest:postarDiscord", source, DISCORD_WEBHOOK, "ELETRÔNICO POLICIA","ENTROU EM SERVIÇO")
		TriggerEvent('eblips:add',{ name = "Policial", src = source, color =  68 })
		vRP.addUserGroup(user_id,"Policia")
		TriggerClientEvent("Notify",source,"sucesso","Você entrou em serviço.")
	elseif vRP.hasPermission(user_id,"paramedico.permissao") then
		DISCORD_WEBHOOK = "https://discordapp.com/api/webhooks/694051812910825523/xk0RUFkNSgtBCjXpsLGoPMZmf2Pa8hfbdVZzhtj90NKlMpRYslHVARn7qeP3QRr9hxrU"
		TriggerEvent("everest:postarDiscord", source, DISCORD_WEBHOOK, "ELETRÔNICO EMC","SAIU DE SERVIÇO")
		TriggerEvent('eblips:remove',source)
		vRP.addUserGroup(user_id,"PaisanaParamedico")
		TriggerClientEvent("Notify",source,"sucesso","Você saiu de serviço.")
	elseif vRP.hasPermission(user_id,"paisanaparamedico.permissao") then
		DISCORD_WEBHOOK = "https://discordapp.com/api/webhooks/694051812910825523/xk0RUFkNSgtBCjXpsLGoPMZmf2Pa8hfbdVZzhtj90NKlMpRYslHVARn7qeP3QRr9hxrU"
		TriggerEvent("everest:postarDiscord", source, DISCORD_WEBHOOK, "ELETRÔNICO EMC","ENTROU EM SERVIÇO")
		TriggerEvent('eblips:add',{ name = "Paramedico", src = source, color = 48 })
		vRP.addUserGroup(user_id,"Paramedico")
		TriggerClientEvent("Notify",source,"sucesso","Você entrou em serviço.")
	elseif vRP.hasPermission(user_id,"mecanico.permissao") then
		DISCORD_WEBHOOK = "https://discordapp.com/api/webhooks/676619687437664270/DsLy7zesfgIAVRKqTJupH4M56XarRqfC7fog1xbZOXh9P_kg8isUEi5uGHU07LPdZ0kW"
		TriggerEvent("everest:postarDiscord", source, DISCORD_WEBHOOK, "ELETRÔNICO MECANICO","ENTROU EM SERVIÇO")
		vRP.addUserGroup(user_id,"PaisanaMecanico")
		TriggerClientEvent("Notify",source,"sucesso","Você saiu de serviço.")
	elseif vRP.hasPermission(user_id,"paisanamecanico.permissao") then
	    DISCORD_WEBHOOK = "https://discordapp.com/api/webhooks/676619687437664270/DsLy7zesfgIAVRKqTJupH4M56XarRqfC7fog1xbZOXh9P_kg8isUEi5uGHU07LPdZ0kW"
	    TriggerEvent("everest:postarDiscord", source, DISCORD_WEBHOOK, "ELETRÔNICO MECANICO","SAIU DE SERVIÇO")
		vRP.addUserGroup(user_id,"Mecanico")
		TriggerClientEvent("Notify",source,"sucesso","Você entrou em serviço.")
	end

	TriggerClientEvent("global:loadJob", source)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REANIMAR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('reanimar',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"polpar.permissao") then
		TriggerClientEvent('reanimar',source)
	end
end)

RegisterServerEvent("reanimar:pagamento")
AddEventHandler("reanimar:pagamento",function()
	local user_id = vRP.getUserId(source)
	if user_id then
		pagamento = math.random(0,0)
		vRP.giveMoney(user_id,pagamento)
		TriggerClientEvent("Notify",source,"sucesso","Parabéns você acabou de salvar um everestino.")
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DETIDO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('detido',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"policia.permissao") then
		local vehicle,vnetid,placa,vname,lock,banned = vRPclient.vehList(source,7)
		local placa_user = vRP.getUserByRegistration(placa)
		local motivo = vRP.prompt(source,"Motivo:","")
		if placa_user then
			if vname then
				local rows = vRP.query("creative/get_vehicles",{ user_id = placa_user, vehicle = vname })
				if #rows > 0 then
					if rows[1].detido == 1 then
						TriggerClientEvent("Notify",source,"importante","Este veículo já se encontra detido.")
					else
						vRP.execute("creative/set_detido",{ user_id = placa_user, vehicle = vname, detido = 1, time = parseInt(os.time()) })
						TriggerClientEvent("Notify",source,"sucesso","Veículo detido com sucesso.")
						DISCORD_WEBHOOK = "https://discordapp.com/api/webhooks/659930699595251712/ypfYq4QxLhw-NqF4wxBVw5cd4DqEEna35WV8UQhZ-Dw4EKayRgYSadZyQshmaAsq1Akz"
						local identitys = vRP.getUserIdentity(user_id)
						local infrator = vRP.getUserIdentity(placa_user)
						TriggerEvent("everest:postarDiscord", source, DISCORD_WEBHOOK, "VEÍCULO DETIDO", 
						"POLICIAL: "..identitys.name.." "..identitys.firstname.."\nVEÍCULO: "..vname.."\n PLACA: "..placa.."\n PROPRIETÁRIO: "..infrator.name.." "..infrator.firstname.."\n MOTIVO: "..motivo, 16711680)	
					end
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ID
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('id',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	-- if vRP.hasPermission(user_id,"polpar.permissao") or vRP.hasPermission(user_id,"admin.permissao") or vRP.hasPermission(user_id,"policia.permissao") then
	if args[1] then
		if vRP.hasPermission(user_id,"polpar.permissao") or vRP.hasPermission(user_id,"admin.permissao") or vRP.hasPermission(user_id,"policia.permissao") or vRP.hasPermission(user_id,"moderador.permissao") then
			local nplayer = vRP.getUserSource(parseInt(args[1]))
			if nplayer == nil then
				TriggerClientEvent("Notify",source,"aviso","Passaporte <b>"..vRP.format(args[1]).."</b> indisponível no momento.")
				return
			end

			local nuser_id = vRP.getUserId(nplayer)

			local ok = true
			if vRPclient.getHealth(nplayer) > 100 and not (vRP.hasPermission(user_id,"admin.permissao") or vRP.hasPermission(user_id,"moderador.permissao")) then
				TriggerClientEvent("Notify",source,"importante","Foi solicitado o RG, aguarde o mesmo te mostrar!")
				ok = vRP.request(nplayer,"Entregar registro de identidade?",15)
			end
			if ok then
				if nuser_id then
					local value = vRP.getUData(nuser_id,"vRP:multas")
					local valormultas = json.decode(value) or 0
					local identity = vRP.getUserIdentity(nuser_id)
					-- local carteira = vRP.getMoney(nuser_id)
					-- local banco = vRP.getBankMoney(nuser_id)
					-- vRPclient.setDiv(source,"completerg",".div_completerg { background-color: rgba(0,0,0,0.60); font-size: 13px; font-family: arial; color: #fff; width: 420px; padding: 20px 20px 5px; bottom: 8%; right: 2.5%; position: absolute; border: 1px solid rgba(255,255,255,0.2); letter-spacing: 0.5px; } .local { width: 220px; padding-bottom: 15px; float: left; } .local2 { width: 200px; padding-bottom: 15px; float: left; } .local b, .local2 b { color: #d1257d; }","<div class=\"local\"><b>Nome:</b> "..identity.name.." "..identity.firstname.." ( "..vRP.format(identity.user_id).." )</div><div class=\"local2\"><b>Identidade:</b> "..identity.registration.."</div><div class=\"local\"><b>Idade:</b> "..identity.age.." Anos</div><div class=\"local2\"><b>Telefone:</b> "..identity.phone.."</div><div class=\"local\"><b>Multas pendentes:</b> "..vRP.format(parseInt(valormultas)).."</div><div class=\"local2\"><b>Carteira:</b> "..vRP.format(parseInt(carteira)).."</div>")
					vRPclient.setDiv(source,"completerg",".div_completerg { background-color: rgba(0,0,0,0.60); font-size: 13px; font-family: arial; color: #fff; width: 420px; padding: 20px 20px 5px; bottom: 8%; right: 2.5%; position: absolute; border: 1px solid rgba(255,255,255,0.2); letter-spacing: 0.5px; } .local { width: 220px; padding-bottom: 15px; float: left; } .local2 { width: 200px; padding-bottom: 15px; float: left; } .local b, .local2 b { color: #00BFFF; }","<div class=\"local\"><b>Nome:</b> "..identity.name.." "..identity.firstname.." ( "..vRP.format(identity.user_id).." )</div><div class=\"local2\"><b>Identidade:</b> "..identity.registration.."</div><div class=\"local\"><b>Idade:</b> "..identity.age.." Anos</div><div class=\"local2\"><b>Telefone:</b> "..identity.phone.."</div><div class=\"local\"><b>Multas pendentes:</b> "..vRP.format(parseInt(valormultas)).."</div>")
					vRP.request(source,"Você deseja fechar o registro geral?",1000)
					vRPclient.removeDiv(source,"completerg")
				end
			else
				TriggerClientEvent("Notify",source,"negado","O cidadão não quis mostrar o RG!")
			end
		end
	else
		local nplayer = vRPclient.getNearestPlayer(source,2)
		local nuser_id = vRP.getUserId(nplayer)
		
		local ok = true
		if vRPclient.getHealth(nplayer) > 100 and not (vRP.hasPermission(user_id,"admin.permissao") or vRP.hasPermission(user_id,"moderador.permissao")) then
			TriggerClientEvent("Notify",source,"importante","Foi solicitado o RG, aguarde o mesmo te mostrar!")
			ok = vRP.request(nplayer,"Entregar registro de identidade?",15)
		end
		if ok then
			if nuser_id then
				local value = vRP.getUData(nuser_id,"vRP:multas")
				local valormultas = json.decode(value) or 0
				local identity = vRP.getUserIdentity(nuser_id)
				-- local carteira = vRP.getMoney(nuser_id)
				-- local banco = vRP.getBankMoney(nuser_id)
				vRPclient.setDiv(source,"completerg",".div_completerg { background-color: rgba(0,0,0,0.60); font-size: 13px; font-family: arial; color: #fff; width: 420px; padding: 20px 20px 5px; bottom: 8%; right: 2.5%; position: absolute; border: 1px solid rgba(255,255,255,0.2); letter-spacing: 0.5px; } .local { width: 220px; padding-bottom: 15px; float: left; } .local2 { width: 200px; padding-bottom: 15px; float: left; } .local b, .local2 b { color: #d1257d; }","<div class=\"local\"><b>Nome:</b> "..identity.name.." "..identity.firstname.." ( "..vRP.format(identity.user_id).." )</div><div class=\"local2\"><b>Identidade:</b> "..identity.registration.."</div><div class=\"local\"><b>Idade:</b> "..identity.age.." Anos</div><div class=\"local2\"><b>Telefone:</b> "..identity.phone.."</div><div class=\"local\"><b>Multas pendentes:</b> "..vRP.format(parseInt(valormultas)).."</div>")
				vRP.request(source,"Você deseja fechar o registro geral?",1000)
				vRPclient.removeDiv(source,"completerg")
			end
		else
			TriggerClientEvent("Notify",source,"negado","O cidadão não quis mostrar o RG!")
		end
	end
	-- end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ALGEMAR1
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("vrp_policia:algemar")
AddEventHandler("vrp_policia:algemar",function()
	local source = source
	local user_id = vRP.getUserId(source)
	local nplayer = vRPclient.getNearestPlayer(source,2)
	if nplayer then
		if vRPclient.getHealth(nplayer) > 100 then
			if vRP.getInventoryItemAmount(user_id,"algemas") >= 1 then
				if vRPclient.isHandcuffed(nplayer) then
					vRPclient.toggleHandcuff(nplayer)
					vRPclient._playAnim(source,false,{{"mp_arresting","a_uncuff"}},false)
					vRPclient._playAnim(nplayer,false,{{"mp_arresting","b_uncuff"}},false)
					vRPclient._stopAnim(source,false)
					TriggerClientEvent("vrp_sound:source",source,'uncuff',0.5)
					TriggerClientEvent("vrp_sound:source",nplayer,'uncuff',0.5)
					TriggerClientEvent('removealgemas',nplayer)
				else
					TriggerClientEvent('cancelando',source,true)
					TriggerClientEvent('cancelando',nplayer,true)
					TriggerClientEvent('carregar',nplayer,source)
					vRPclient._playAnim(source,false,{{"mp_arrest_paired","cop_p2_back_left"}},false)
					vRPclient._playAnim(nplayer,false,{{"mp_arrest_paired","crook_p2_back_left"}},false)
					SetTimeout(3500,function()
						vRPclient._stopAnim(source,false)
						vRPclient.toggleHandcuff(nplayer)
						TriggerClientEvent('carregar',nplayer,source)
						TriggerClientEvent('cancelando',source,false)
						TriggerClientEvent('cancelando',nplayer,false)
						TriggerClientEvent("vrp_sound:source",source,'cuff',0.5)
						TriggerClientEvent("vrp_sound:source",nplayer,'cuff',0.5)
						TriggerClientEvent('setalgemas',nplayer)
					end)
				end
			else
				if vRP.hasPermission(user_id,"policia.permissao")  then
					if vRPclient.isHandcuffed(nplayer) then
						vRPclient.toggleHandcuff(nplayer)
						vRPclient._playAnim(source,false,{{"mp_arresting","a_uncuff"}},false)
						vRPclient._playAnim(nplayer,false,{{"mp_arresting","b_uncuff"}},false)
						vRPclient._stopAnim(source,false)
						TriggerClientEvent("vrp_sound:source",source,'uncuff',0.5)
						TriggerClientEvent("vrp_sound:source",nplayer,'uncuff',0.5)
						TriggerClientEvent('removealgemas',nplayer)
					else
						TriggerClientEvent('cancelando',source,true)
						TriggerClientEvent('cancelando',nplayer,true)
						TriggerClientEvent('carregar',nplayer,source)
						vRPclient._playAnim(source,false,{{"mp_arrest_paired","cop_p2_back_left"}},false)
						vRPclient._playAnim(nplayer,false,{{"mp_arrest_paired","crook_p2_back_left"}},false)
						SetTimeout(3500,function()
							vRPclient._stopAnim(source,false)
							vRPclient.toggleHandcuff(nplayer)
							TriggerClientEvent('carregar',nplayer,source)
							TriggerClientEvent('cancelando',source,false)
							TriggerClientEvent('cancelando',nplayer,false)
							TriggerClientEvent("vrp_sound:source",source,'cuff',0.5)
							TriggerClientEvent("vrp_sound:source",nplayer,'cuff',0.5)
							TriggerClientEvent('setalgemas',nplayer)
						end)
					end
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ALGEMAR2
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('cuff',function(source,args,rawCommand)
	local source = source
	local user_id = vRP.getUserId(source)
	local nplayer = vRPclient.getNearestPlayer(source,2)
	if nplayer then
		if vRPclient.getHealth(nplayer) > 100 then
			if vRP.getInventoryItemAmount(user_id,"algemas") >= 1 then
				if vRPclient.isHandcuffed(nplayer) then
					vRPclient.toggleHandcuff(nplayer)
					vRPclient._playAnim(source,false,{{"mp_arresting","a_uncuff"}},false)
					vRPclient._playAnim(nplayer,false,{{"mp_arresting","b_uncuff"}},false)
					vRPclient._stopAnim(source,false)
					TriggerClientEvent("vrp_sound:source",source,'uncuff',0.5)
					TriggerClientEvent("vrp_sound:source",nplayer,'uncuff',0.5)
					TriggerClientEvent('removealgemas',nplayer)
				else
					TriggerClientEvent('cancelando',source,true)
					TriggerClientEvent('cancelando',nplayer,true)
					TriggerClientEvent('carregar',nplayer,source)
					vRPclient._playAnim(source,false,{{"mp_arresting","a_uncuff"}},false)
					vRPclient._playAnim(nplayer,false,{{"mp_arresting","b_uncuff"}},false)
					SetTimeout(3500,function()
						vRPclient._stopAnim(source,false)
						vRPclient.toggleHandcuff(nplayer)
						TriggerClientEvent('carregar',nplayer,source)
						TriggerClientEvent('cancelando',source,false)
						TriggerClientEvent('cancelando',nplayer,false)
						TriggerClientEvent("vrp_sound:source",source,'cuff',0.5)
						TriggerClientEvent("vrp_sound:source",nplayer,'cuff',0.5)
						TriggerClientEvent('setalgemas',nplayer)
					end)
				end
			else
				if vRP.hasPermission(user_id,"policia.permissao") or vRP.hasPermission(user_id,"admin.permissao") then
					if vRPclient.isHandcuffed(nplayer) then
						vRPclient.toggleHandcuff(nplayer)
						vRPclient._playAnim(source,false,{{"mp_arresting","a_uncuff"}},false)
						vRPclient._playAnim(nplayer,false,{{"mp_arresting","b_uncuff"}},false)
						vRPclient._stopAnim(source,false)
						TriggerClientEvent("vrp_sound:source",source,'uncuff',0.5)
						TriggerClientEvent("vrp_sound:source",nplayer,'uncuff',0.5)
						TriggerClientEvent('removealgemas',nplayer)
					else
						TriggerClientEvent('cancelando',source,true)
						TriggerClientEvent('cancelando',nplayer,true)
						TriggerClientEvent('carregar',nplayer,source)
						vRPclient._playAnim(source,false,{{"mp_arresting","a_uncuff"}},false)
						vRPclient._playAnim(nplayer,false,{{"mp_arresting","b_uncuff"}},false)
						SetTimeout(3500,function()
							vRPclient._stopAnim(source,false)
							vRPclient.toggleHandcuff(nplayer)
							TriggerClientEvent('carregar',nplayer,source)
							TriggerClientEvent('cancelando',source,false)
							TriggerClientEvent('cancelando',nplayer,false)
							TriggerClientEvent("vrp_sound:source",source,'cuff',0.5)
							TriggerClientEvent("vrp_sound:source",nplayer,'cuff',0.5)
							TriggerClientEvent('setalgemas',nplayer)
						end)
					end
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CARREGAR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("vrp_policia:carregar")
AddEventHandler("vrp_policia:carregar",function()
	local source = source
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"polpar.permissao") or vRP.hasPermission(user_id,"moderador.permissao") then
		local nplayer = vRPclient.getNearestPlayer(source,10)
		if nplayer then
			TriggerClientEvent('carregar',nplayer,source)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- RMASCARA
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('rmascara',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"polpar.permissao") then
		local nplayer = vRPclient.getNearestPlayer(source,2)
		if nplayer then
			TriggerClientEvent('rmascara',nplayer)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- RCHAPEU
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('rchapeu',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"polpar.permissao") then
		local nplayer = vRPclient.getNearestPlayer(source,2)
		if nplayer then
			TriggerClientEvent('rchapeu',nplayer)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- RCAPUZ
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('rcapuz',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"polpar.permissao") or vRP.hasPermission(user_id,"moderador.permissao") then
		local nplayer = vRPclient.getNearestPlayer(source,2)
		if nplayer then
			if vRPclient.isCapuz(nplayer) then
				vRPclient.setCapuz(nplayer)
				TriggerClientEvent("Notify",source,"sucesso","Capuz colocado com sucesso.")
			else
				TriggerClientEvent("Notify",source,"importante","A pessoa não está com o capuz na cabeça.")
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- RE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('re',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"polpar.permissao") or vRP.hasPermission(user_id,"moderador.permissao") then
		local nplayer = vRPclient.getNearestPlayer(source,2)
		if nplayer then
			if vRPclient.isInComa(nplayer) then
				TriggerClientEvent('cancelando',source,true)
				vRPclient._playAnim(source,false,{{"amb@medic@standing@tendtodead@base","base"},{"mini@cpr@char_a@cpr_str","cpr_pumpchest"}},true)
				TriggerClientEvent("progress",source,30000,"reanimando")
				SetTimeout(30000,function()
					vRPclient.killGod(nplayer, true)
					vRPclient._stopAnim(source,false)
					vRP.giveMoney(user_id,300)
					TriggerClientEvent('cancelando',source,false)
				end)
			else
				TriggerClientEvent("Notify",source,"importante","A pessoa precisa estar em coma para prosseguir.")
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CV
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('cv',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"polpar.permissao") then
		local nplayer = vRPclient.getNearestPlayer(source,10)
		if nplayer then
			vRPclient.putInNearestVehicleAsPassenger(nplayer,7)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- RV
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('rv',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"polpar.permissao") then
		local nplayer = vRPclient.getNearestPlayer(source,10)
		if nplayer then
			vRPclient.ejectVehicle(nplayer)
		end
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- APREENDER
-----------------------------------------------------------------------------------------------------------------------------------------
local itemlist = {
	"c4,",
	"dinheirosujo",
	"algemas",
	"capuz",
	"chavemestra",
	"lockpick",
	"masterpick",
	"orgao",
	"etiqueta",
	"pendrive",
	"relogioroubado",
	"pulseiraroubada",
	"anelroubado",
	"colarroubado",
	"brincoroubado",
	"carteiraroubada",
	"carregadorroubado",
	"tabletroubado",
	"sapatosroubado",
	"vibradorroubado",
	"perfumeroubado",
	"maquiagemroubada",
	"rubberducky",
	"cartaoclonado",
	"logsinvasao",
	"logsacesso",
	"keylogs",
	"cocaina",
	"metanfetamina",
	"maconha",
	"ticketcorrida",
	"ticketcorrida",
	"yellowcard",
	"capsulafiveseven",
	"capsulatec9",
	"capsulauzi",
	"capsulamtar21",
	"capsulathompson",
	"capsulacarabina",
	"capsulaak103",
	"pecasfiveseven",
	"pecastec9",
	"pecasuzi",
	"pecasmtar21",
	"pecasthompson",
	"pecascarabina",
	"pecasak103",
	"wbody|WEAPON_DAGGER",
	"wbody|WEAPON_BAT",
	"wbody|WEAPON_BOTTLE",
	"wbody|WEAPON_CROWBAR",
	"wbody|WEAPON_FLASHLIGHT",
	"wbody|WEAPON_GOLFCLUB",
	"wbody|WEAPON_HAMMER",
	"wbody|WEAPON_HATCHET",
	"wbody|WEAPON_KNUCKLE",
	"wbody|WEAPON_KNIFE",
	"wbody|WEAPON_MACHETE",
	"wbody|WEAPON_SWITCHBLADE",
	"wbody|WEAPON_NIGHTSTICK",
	"wbody|WEAPON_WRENCH",
	"wbody|WEAPON_BATTLEAXE",
	"wbody|WEAPON_POOLCUE",
	"wbody|WEAPON_STONE_HATCHET",
	"wbody|WEAPON_PISTOL",
	"wbody|WEAPON_COMBATPISTOL",
	"wbody|WEAPON_CARBINERIFLE",
	"wbody|WEAPON_SMG",
	"wbody|WEAPON_PUMPSHOTGUN_MK2",
	"wbody|WEAPON_PUMPSHOTGUN",
	"wbody|WEAPON_STUNGUN",
	"wbody|WEAPON_NIGHTSTICK",
	"wbody|WEAPON_SNSPISTOL",
	"wbody|WEAPON_MICROSMG",
	"wbody|WEAPON_ASSAULTRIFLE",
	"wbody|WEAPON_FIREEXTINGUISHER",
	"wbody|WEAPON_FLARE",
	"wbody|WEAPON_REVOLVER",
	"wbody|WEAPON_PISTOL_MK2",
	"wbody|WEAPON_VINTAGEPISTOL",
	"wbody|WEAPON_MUSKET",
	"wbody|WEAPON_GUSENBERG",
	"wbody|WEAPON_ASSAULTSMG",
	"wbody|WEAPON_COMBATPDW",
	"wammo|WEAPON_DAGGER",
	"wammo|WEAPON_BAT",
	"wammo|WEAPON_BOTTLE",
	"wammo|WEAPON_CROWBAR",
	"wammo|WEAPON_FLASHLIGHT",
	"wammo|WEAPON_GOLFCLUB",
	"wammo|WEAPON_HAMMER",
	"wammo|WEAPON_HATCHET",
	"wammo|WEAPON_KNUCKLE",
	"wammo|WEAPON_KNIFE",
	"wammo|WEAPON_MACHETE",
	"wammo|WEAPON_SWITCHBLADE",
	"wammo|WEAPON_NIGHTSTICK",
	"wammo|WEAPON_WRENCH",
	"wammo|WEAPON_BATTLEAXE",
	"wammo|WEAPON_POOLCUE",
	"wammo|WEAPON_STONE_HATCHET",
	"wammo|WEAPON_PISTOL",
	"wammo|WEAPON_COMBATPISTOL",
	"wammo|WEAPON_CARBINERIFLE",
	"wammo|WEAPON_SMG",
	"wammo|WEAPON_PUMPSHOTGUN_MK2",
	"wammo|WEAPON_STUNGUN",
	"wammo|WEAPON_NIGHTSTICK",
	"wammo|WEAPON_SNSPISTOL",
	"wammo|WEAPON_MICROSMG",
	"wammo|WEAPON_ASSAULTRIFLE",
	"wammo|WEAPON_FIREEXTINGUISHER",
	"wammo|WEAPON_FLARE",
	"wammo|WEAPON_REVOLVER",
	"wammo|WEAPON_PISTOL_MK2",
	"wammo|WEAPON_VINTAGEPISTOL",
	"wammo|WEAPON_MUSKET",
	"wammo|WEAPON_GUSENBERG",
	"wammo|WEAPON_ASSAULTSMG",
	"wammo|WEAPON_COMBATPDW",
	"wbody|WEAPON_MACHINEPISTOL",
	"wammo|WEAPON_MACHINEPISTOL",
	"wbody|WEAPON_SPECIALCARBINE",
	"wammo|WEAPON_SPECIALCARBINE"
}

RegisterCommand('apreender',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"policia.permissao") then
		local nplayer = vRPclient.getNearestPlayer(source,2)
		if nplayer then
			local nuser_id = vRP.getUserId(nplayer)
			if nuser_id then
				local weapons = vRPclient.replaceWeapons(nplayer,{})
				for k,v in pairs(weapons) do
					vRP.giveInventoryItem( nuser_id,"wbody|"..k,1)
					if v.ammo > 0 then
						vRP.giveInventoryItem( nuser_id,"wammo|"..k,v.ammo)
					end
				end

				local inv = vRP.getInventory(nuser_id)
				for k,v in pairs(itemlist) do
					local sub_items = { v }
					if string.sub(v,1,1) == "*" then
						local idname = string.sub(v,2)
						sub_items = {}
						for fidname,_ in pairs(inv) do
							if splitString(fidname,"|")[1] == idname then
								table.insert(sub_items,fidname)
							end
						end
					end

					for _,idname in pairs(sub_items) do
						local amount = vRP.getInventoryItemAmount(nuser_id,idname)
						if amount > 0 then
							local item_name,item_weight = vRP.getItemDefinition(idname)
							if item_name then
								if vRP.tryGetInventoryItem(nuser_id,idname,amount,true) then
									vRP.giveInventoryItem( user_id,idname,amount)
								end
							end
						end
					end
				end
				TriggerClientEvent("Notify",nplayer,"importante","Todos os seus pertences foram apreendidos.")
				TriggerClientEvent("Notify",source,"importante","Apreendeu todos os pertences da pessoa.")
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ARSENAL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('arsenal',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"policia.permissao") then
		TriggerClientEvent('arsenal',source)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- EXTRAS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('extras',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"policia.permissao") then
		TriggerClientEvent('extras',source)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('cone',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"polpar.permissao") then
		TriggerClientEvent('cone',source,args[1])
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONE
-----------------------------------------------------------------------------------------------------------------------------------------
local policia = {}
RegisterCommand('p',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	local uplayer = vRP.getUserSource(user_id)
	local identity = vRP.getUserIdentity(user_id)
	local x,y,z = vRPclient.getPosition(source)
	if vRPclient.getHealth(source) > 0 then
		if vRP.hasPermission(user_id,"policia.permissao") then
			local soldado = vRP.getUsersByPermission("policia.permissao")
			for l,w in pairs(soldado) do
				local player = vRP.getUserSource(parseInt(w))
				if player and player ~= uplayer then
					async(function()
						local id = idgens:gen()
						policia[id] = vRPclient.addBlip(player,x,y,z,153,84,"10-13 OFICIAL FERIDO"..identity.name.." "..identity.firstname,0.5,false)
						TriggerClientEvent("Notify",player,"importante","10-13 [Oficial Ferido]:<b>"..identity.name.." "..identity.firstname.."</b>.")
						TriggerClientEvent("vrp_sound:source",player,'aviso',0.2)
						SetTimeout(60000,function() vRPclient.removeBlip(player,policia[id]) idgens:free(id) end)
					end)
				end
			end
			TriggerClientEvent("Notify",source,"sucesso","10-13 [Oficial Ferido]:<b>"..identity.name.." "..identity.firstname.."</b>.")
			TriggerClientEvent("vrp_sound:source",source,'aviso',0.2)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BARREIRA
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('barreira',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"polpar.permissao") then
		TriggerClientEvent('barreira',source,args[1])
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SPIKE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('spike',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"policia.permissao") then
		TriggerClientEvent('spike',source,args[1])
	end
end)
--------------------------------------------------------------------------------------------------------------------------------------------------
-- DISPAROS
--------------------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent('atirando')
AddEventHandler('atirando',function(x,y,z)
	local user_id = vRP.getUserId(source)
	if user_id then
		if not vRP.hasPermission(user_id,"policia.permissao") or vRP.hasPermission(user_id,"admin.permissao") then
			local policiais = vRP.getUsersByPermission("policia.permissao")
			for l,w in pairs(policiais) do
				local player = vRP.getUserSource(w)
				if player then
					TriggerClientEvent('notificacao',player,x,y,z,user_id)
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ANUNCIO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('anuncio',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"polpar.permissao") then
		local identity = vRP.getUserIdentity(user_id)
		local mensagem = vRP.prompt(source,"Mensagem:","")
		if mensagem == "" then
			return
		end
		vRPclient.setDiv(-1,"anuncio",".div_anuncio { background: rgba(0,128,192,0.8); font-size: 11px; font-family: arial; color: #fff; padding: 20px; bottom: 7%; right: 5%; max-width: 500px; position: absolute; -webkit-border-radius: 5px; } bold { font-size: 15px; }","<bold>"..mensagem.."</bold><br><br>Mensagem enviada por: "..identity.name.." "..identity.firstname)
		SetTimeout(30000,function()
			vRPclient.removeDiv(-1,"anuncio")
		end)
	end
end)

function addGroup()
	local source = source
	local user_id = vRP.getUserId(source)
	addUserGroup(user_id,"ilegal")
end
--------------------------------------------------------------------------------------------------------------------------------------------------
-- PRISÃO
--------------------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("vRP:playerSpawn",function(user_id,source,first_spawn)
	local player = vRP.getUserSource(parseInt(user_id))
	if player then
		SetTimeout(30000,function()
			local value = vRP.getUData(parseInt(user_id),"vRP:prisao")
			local tempo = json.decode(value) or -1

			if tempo == -1 then
				return
			end

			if tempo > 0 then
				TriggerClientEvent('prisioneiro',player,true)
				vRPclient.teleport(player,1680.1,2513.0,46.5)
				addUserGroup(player,"ilegal")
				prison_lock(parseInt(user_id))
			end
		end)
	end
end)

RegisterServerEvent("prison_lock")
AddEventHandler("prison_lock",function(target_id)
	prison_lock(target_id)
end)

function prison_lock(target_id)
	local player = vRP.getUserSource(parseInt(target_id))
	if player then
		SetTimeout(60000,function()
			local value = vRP.getUData(parseInt(target_id),"vRP:prisao")
			local tempo = json.decode(value) or 0
			if parseInt(tempo) >= 1 then
				TriggerClientEvent("Notify",player,"importante","Ainda vai passar <b>"..parseInt(tempo).." meses</b> preso.")
				vRP.setUData(parseInt(target_id),"vRP:prisao",json.encode(parseInt(tempo)-1))
				prison_lock(parseInt(target_id))
			elseif parseInt(tempo) == 0 then
				TriggerClientEvent('prisioneiro',player,false)
				vRPclient.teleport(player,1850.5,2604.0,45.5)
				vRP.setUData(parseInt(target_id),"vRP:prisao",json.encode(-1))
				TriggerClientEvent("Notify",player,"importante","Sua sentença terminou, esperamos não ve-lo novamente.")
			end
			vRPclient.killGod(player, false)
		end)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DIMINUIR PENA
-----------------------------------------------------------------------------------------------------------------------------------------
--[[RegisterServerEvent("diminuirpena")
AddEventHandler("diminuirpena",function()
	local source = source
	local user_id = vRP.getUserId(source)
	local value = vRP.getUData(parseInt(user_id),"vRP:prisao")
	local tempo = json.decode(value) or 0
	if tempo >= 10 then
		vRP.setUData(parseInt(user_id),"vRP:prisao",json.encode(parseInt(tempo)-4))
		TriggerClientEvent("Notify",source,"importante","Sua pena foi reduzida em <b>4 meses</b>, continue o trabalho.")
	else
		TriggerClientEvent("Notify",source,"importante","Atingiu o limite da redução de pena, não precisa mais trabalhar.")
	end
end)]]
-----------------------------------------------------------------------------------------------------------------------------------------
-- PRESET
-----------------------------------------------------------------------------------------------------------------------------------------
local presets = {
	["1"] = {
		[1885233650] = {
			[1] = { 121,0 },
			[5] = { -1,0 },
			[7] = { -1,0 },
			[3] = { 1,0 },
			[4] = { 25,0 },
			[8] = { 58,0 },
			[6] = { 21,0 },
			[11] = { 26,0 },
			[9] = { 13,0 },
			[10] = { -1,0 },
			["p0"] = { 13,0 },
			["p1"] = { 5,5 },
			["p2"] = { -1,0 },
			["p6"] = { -1,0 },
			["p7"] = { -1,0 }
		},
		[-1667301416] = {
			[1] = { 121,0 },
			[5] = { -1,0 },
			[7] = { -1,0 },
			[3] = { 14,0 },
			[4] = { 41,0 },
			[8] = { 35,0 },
			[6] = { 59,1 },
			[11] = { 25,0 },
			[9] = { 14,0 },
			[10] = { -1,0 },
			["p0"] = { 13,0 },
			["p1"] = { 7,1 },
			["p2"] = { -1,0 },
			["p6"] = { -1,0 },
			["p7"] = { -1,0 }
		}
	},
	["2"] = {
		[1885233650] = {
			[1] = { 121,0 },
			[5] = { -1,0 },
			[7] = { -1,0 },
			[3] = { 0,0 },
			[4] = { 25,0 },
			[8] = { 58,0 },
			[6] = { 21,0 },
			[11] = { 118,0 },
			[9] = { 13,0 },
			[10] = { -1,0 },
			["p0"] = { 13,0 },
			["p1"] = { 5,5 },
			["p2"] = { -1,0 },
			["p6"] = { -1,0 },
			["p7"] = { -1,0 }
		}
	},
	["3"] = {
		[1885233650] = {
			[1] = { 121,0 },
			[5] = { -1,0 },
			[7] = { 125,0 },
			[3] = { 0,0 },
			[4] = { 47,0 },
			[8] = { 57,0 },
			[6] = { 15,0 },
			[11] = { 93,0 },
			[9] = { -1,0 },
			[10] = { -1,0 },
			["p0"] = { 96,0 },
			["p1"] = { -1,0 },
			["p2"] = { -1,0 },
			["p6"] = { -1,0 },
			["p7"] = { -1,0 }
		},
		[-1667301416] = {
			[1] = { 121,0 },
			[5] = { -1,0 },
			[7] = { 95,0 },
			[3] = { 14,0 },
			[4] = { 49,0 },
			[8] = { 34,0 },
			[6] = { 57,0 },
			[11] = { 84,0 },
			[9] = { -1,0 },
			[10] = { -1,0 },
			["p0"] = { 95,0 },
			["p1"] = { -1,0 },
			["p2"] = { -1,0 },
			["p6"] = { -1,0 },
			["p7"] = { -1,0 }
		}
	},
	["4"] = {
		[1885233650] = {
			[1] = { 121,0 },
			[5] = { -1,0 },
			[7] = { 126,0 },
			[3] = { 74,0 },
			[4] = { 96,0 },
			[8] = { 57,0 },
			[6] = { 8,0 },
			[11] = { 250,0 },
			[9] = { -1,0 },
			[10] = { 58,0 },
			["p0"] = { 122,0 },
			["p1"] = { -1,0 },
			["p2"] = { -1,0 },
			["p6"] = { -1,0 },
			["p7"] = { -1,0 }
		},
		[-1667301416] = {
			[1] = { 121,0 },
			[5] = { -1,0 },
			[7] = { 96,0 },
			[3] = { 96,0 },
			[4] = { 99,0 },
			[8] = { 34,0 },
			[6] = { 4,1 },
			[11] = { 258,0 },
			[9] = { -1,0 },
			[10] = { 66,0 },
			["p0"] = { 121,0 },
			["p1"] = { -1,0 },
			["p2"] = { -1,0 },
			["p6"] = { -1,0 },
			["p7"] = { -1,0 }
		}
	},
	["5"] = {
		[1885233650] = {
			[1] = { -1,0 },
			[5] = { -1,0 },
			[7] = { 126,0 },
			[3] = { 82,0 },
			[4] = { 25,5 },
			[8] = { 31,0 },
			[6] = { 21,9 },
			[11] = { 31,7 },
			[9] = { -1,0 },
			[10] = { -1,0 },
			["p0"] = { -1,0 },
			["p1"] = { -1,0 },
			["p2"] = { -1,0 },
			["p6"] = { -1,0 },
			["p7"] = { -1,0 }
		},
		[-1667301416] = {
			[1] = { -1,0 },
			[5] = { -1,0 },
			[7] = { 96,0 },
			[3] = { 88,0 },
			[4] = { 23,0 },
			[8] = { 39,0 },
			[6] = { 42,0 },
			[11] = { 57,7 },
			[9] = { -1,0 },
			[10] = { -1,0 },
			["p0"] = { -1,0 },
			["p1"] = { -1,0 },
			["p2"] = { -1,0 },
			["p6"] = { -1,0 },
			["p7"] = { -1,0 }
		}
	},
	["6"] = {
		[1885233650] = {
			[1] = { -1,0 },
			[5] = { -1,0 },
			[7] = { -1,0 },
			[3] = { 74,0 },
			[4] = { 3,3 },
			[8] = { 15,0 },
			[6] = { 8,0 },
			[11] = { 16,1 },
			[9] = { -1,0 },
			[10] = { -1,0 },
			["p0"] = { -1,0 },
			["p1"] = { -1,0 },
			["p2"] = { -1,0 },
			["p6"] = { -1,0 },
			["p7"] = { -1,0 }
		},
		[-1667301416] = {
			[1] = { -1,0 },
			[5] = { -1,0 },
			[7] = { -1,0 },
			[3] = { 96,0 },
			[4] = { 111,0 },
			[8] = { 15,0 },
			[6] = { 4,1 },
			[11] = { 280,0 },
			[9] = { -1,0 },
			[10] = { -1,0 },
			["p0"] = { -1,0 },
			["p1"] = { -1,0 },
			["p2"] = { -1,0 },
			["p6"] = { -1,0 },
			["p7"] = { -1,0 }
		}
	},
	["7"] = {
		[1885233650] = {
			[1] = { 121,0 },
			[5] = { -1,0 },
			[7] = { 126,0 },
			[3] = { 81,0 },
			[4] = { 10,0 },
			[8] = { 57,0 },
			[6] = { 8,0 },
			[11] = { 95,1 },
			[9] = { -1,0 },
			[10] = { 58,0 },
			["p0"] = { -1,0 },
			["p1"] = { -1,0 },
			["p2"] = { -1,0 },
			["p6"] = { -1,0 },
			["p7"] = { -1,0 }
		},
		[-1667301416] = {
			[1] = { 0,0 },
			[5] = { 0,0 },
			[7] = { 96,0 },
			[3] = { 106,1 },
			[4] = { 52,2 },
			[8] = { 34,0 },
			[6] = { 4,1 },
			[11] = { 86,1 },
			[9] = { -1,0 },
			[10] = { 66,0 },
			["p0"] = { -1,0 },
			["p1"] = { -1,0 },
			["p2"] = { -1,0 },
			["p6"] = { -1,0 },
			["p7"] = { -1,0 }
		}
	},
	["8"] = {
		[1885233650] = {
			[1] = { 121,0 },
			[5] = { -1,0 },
			[7] = { 126,0 },
			[3] = { 38,0 },
			[4] = { 96,0 },
			[8] = { 71,3 },
			[6] = { 56,1 },
			[11] = { 249,0 },
			[9] = { -1,0 },
			[10] = { 57,0 },
			["p0"] = { -1,0 },
			["p1"] = { 18,1 },
			["p2"] = { -1,0 },
			["p6"] = { -1,0 },
			["p7"] = { -1,0 }
		},
		[-1667301416] = {
			[1] = { 121,0 },
			[5] = { -1,0 },
			[7] = { 96,0 },
			[3] = { 18,0 },
			[4] = { 99,0 },
			[8] = { 77,3 },
			[6] = { 7,0 },
			[11] = { 257,0 },
			[9] = { -1,0 },
			[10] = { 65,0 },
			["p0"] = { -1,0 },
			["p1"] = { 21,0 },
			["p2"] = { -1,0 },
			["p6"] = { -1,0 },
			["p7"] = { -1,0 }
		}
	},
	["9"] = {
		[1885233650] = {
			[1] = { 121,0 },
			[5] = { -1,0 },
			[7] = { 125,0 },
			[3] = { 1,0 },
			[4] = { 33,0 },
			[8] = { 0,4 },
			[6] = { 25,0 },
			[11] = { 151,0 },
			[9] = { -1,0 },
			[10] = { -1,0 },
			["p0"] = { 58,2 },
			["p1"] = { 5,0 },
			["p2"] = { -1,0 },
			["p6"] = { -1,0 },
			["p7"] = { -1,0 }
		},
		[-1667301416] = {
			[1] = { 121,0 },
			[5] = { -1,0 },
			[7] = { 95,0 },
			[3] = { 1,0 },
			[4] = { 33,0 },
			[8] = { 0,4 },
			[6] = { 25,0 },
			[11] = { 151,0 },
			[9] = { -1,0 },
			[10] = { -1,0 },
			["p0"] = { 58,2 },
			["p1"] = { 5,0 },
			["p2"] = { -1,0 },
			["p6"] = { -1,0 },
			["p7"] = { -1,0 }
		}
	},
	["10"] = {
		[1885233650] = {
			[1] = { 121,0 },
			[5] = { -1,0 },
			[7] = { 126,0 },
			[3] = { 81,0 },
			[4] = { 20,0 },
			[8] = { 38,0 },
			[6] = { 8,0 },
			[11] = { 13,0 },
			[9] = { -1,0 },
			[10] = { -1,0 },
			["p0"] = { -1,0 },
			["p1"] = { -1,0 },
			["p2"] = { -1,0 },
			["p6"] = { -1,0 },
			["p7"] = { -1,0 }
		},
		[-1667301416] = {
			[1] = { 121,0 },
			[5] = { -1,0 },
			[7] = { 96,0 },
			[3] = { 85,0 },
			[4] = { 23,0 },
			[8] = { 27,0 },
			[6] = { 4,1 },
			[11] = { 27,0 },
			[9] = { -1,0 },
			[10] = { -1,0 },
			["p0"] = { -1,0 },
			["p1"] = { -1,0 },
			["p2"] = { -1,0 },
			["p6"] = { -1,0 },
			["p7"] = { -1,0 }
		}
	},
	["11"] = {
		[1885233650] = {
			[1] = { 121,0 },
			[3] = { 59,0 },
			[4] = { 31,0 },
			[5] = { -1,0 },
			[6] = { 25,0 },
			[7] = { 1,0 },			
			[8] = { 57,0 },
			[9] = { 7,1 },
			[10] = { -1,0 },
			[11] = { 222,20 },		
			["p0"] = { 10,0 },
			["p1"] = { 5,0 },
			["p2"] = { -1,0 },
			["p6"] = { -1,0 },
			["p7"] = { -1,0 }
		},
		[-1667301416] = {
			[1] = { 121,0 },
			[3] = { 60,0 },
			[4] = { 30,0 },
			[5] = { -1,0 },
			[6] = { 25,0 },
			[7] = { 1,0 },			
			[8] = { 34,0 },
			[9] = { 7,1 },
			[10] = { -1,0 },
			[11] = { 232,20 },
			["p0"] = { 10,0 },
			["p1"] = { 11,0 },
			["p2"] = { -1,0 },
			["p6"] = { -1,0 },
			["p7"] = { -1,0 }
		}
	},
	["12"] = {
			[1885233650] = {
			[1] = { 121,0 },
			[3] = { 4,0 },
			[4] = { 25,1 },
			[5] = { -1,0 },
			[6] = { 21,0 },
			[7] = { -1,0 },			
			[8] = { 58,0 },
			[9] = { 13,0 },
			[10] = { -1,0 },
			[11] = { 26,1 },
			["p0"] = { 13,1 },
			["p1"] = { 5,5 },
			["p2"] = { -1,0 },
			["p6"] = { -1,0 },
			["p7"] = { -1,0 }
		},
		[-1667301416] = {
			[1] = { 121,0 },
			[3] = { 14,0 },
			[4] = { 41,1 },
			[5] = { -1,0 },
			[6] = { 59,1 },
			[7] = { -1,0 },			
			[8] = { 35,0 },
			[9] = { 14,0 },
			[10] = { -1,0 },
			[11] = { 25,1 },			
			["p0"] = { 13,1 },
			["p1"] = { 11,0 },
			["p2"] = { -1,0 },
			["p6"] = { -1,0 },
			["p7"] = { -1,0 }
		}
	},
	["13"] = {
		[1885233650] = {
			[1] = { 121,1 },
			[3] = { 0,0 },
			[4] = { 47,1 },
			[5] = { -1,0 },
			[6] = { 25,0 },
			[7] = { 1,0 },			
			[8] = { 57,0 },
			[9] = { -1,0 },
			[10] = { -1,0 },
			[11] = { 93,1 },		
			["p0"] = { 10,1 },
			["p1"] = { 5,0 },
			["p2"] = { -1,0 },
			["p6"] = { -1,0 },
			["p7"] = { -1,0 }
		},
		[-1667301416] = {
			[1] = { 121,0 },
			[3] = { 14,0 },
			[4] = { 49,1 },
			[5] = { -1,0 },
			[6] = { 25,0 },
			[7] = { 1,0 },			
			[8] = { 34,0 },
			[9] = { -1,0 },
			[10] = { -1,0 },
			[11] = { 84,1 },
			["p0"] = { 10,1 },
			["p1"] = { 11,0 },
			["p2"] = { -1,0 },
			["p6"] = { -1,0 },
			["p7"] = { -1,0 }
		}
	},
} 

RegisterCommand('preset',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id,"polpar.permissao") then
		if args[1] then
			local custom = presets[tostring(args[1])]
			if custom then
				local old_custom = vRPclient.getCustomization(source)
				local idle_copy = {}

				idle_copy = vRP.save_idle_custom(source,old_custom)
				idle_copy.modelhash = nil

				for l,w in pairs(custom[old_custom.modelhash]) do
					idle_copy[l] = w
				end
				vRPclient._setCustomization(source,idle_copy)
			end
		else
			vRP.removeCloak(source)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ARSENAL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('a',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if args[1] == "tazer" and vRP.hasPermission(user_id,"admin.permissao")  then
			vRPclient.giveWeapons(source,{["WEAPON_STUNGUN"] = { ammo = 0 }})
		elseif args[1] == "cassetete" and vRP.hasPermission(user_id,"admin.permissao")  then
			vRPclient.giveWeapons(source,{["WEAPON_NIGHTSTICK"] = { ammo = 0 }})
		elseif args[1] == "lanterna" and vRP.hasPermission(user_id,"admin.permissao")  then
			vRPclient.giveWeapons(source,{["WEAPON_FLASHLIGHT"] = { ammo = 0 }})
		elseif args[1] == "extintor" and vRP.hasPermission(user_id,"admin.permissao")  then
			vRPclient.giveWeapons(source,{["WEAPON_FIREEXTINGUISHER"] = { ammo = 0 }})
		elseif args[1] == "glock" and vRP.hasPermission(user_id,"admin.permissao")  then
			vRPclient.giveWeapons(source,{["WEAPON_COMBATPISTOL"] = { ammo = 100 }})
		elseif args[1] == "limpar" and vRP.hasPermission(user_id,"admin.permissao")  then
			vRPclient.giveWeapons(source,{},true)
			
		elseif args[1] == "foguetinho" and vRP.hasPermission(user_id,"admin.permissao")  then
			vRPclient.giveWeapons(source,{["WEAPON_FIREWORK"] = { ammo = 10 }})
		elseif args[1] == "flare" and vRP.hasPermission(user_id,"admin.permissao")  then
			vRPclient.giveWeapons(source,{["WEAPON_FLAREGUN"] = { ammo = 10 }})	
		elseif args[1] == "bombc4" and vRP.hasPermission(user_id,"admin.permissao")  then
			vRPclient.giveWeapons(source,{["WEAPON_STICKYBOMB"] = { ammo = 5 }})
		elseif args[1] == "sniper" and vRP.hasPermission(user_id,"admin.permissao")  then
			vRPclient.giveWeapons(source,{["WEAPON_SNIPERRIFLE"] = { ammo = 100 }})	

		elseif args[1] == "ak103" and vRP.hasPermission(user_id,"admin.permissao")  then
			vRPclient.giveWeapons(source,{["WEAPON_ASSAULTRIFLE"] = { ammo = 250 }})	
		elseif args[1] == "m4a1" and vRP.hasPermission(user_id,"admin.permissao")  then
			vRPclient.giveWeapons(source,{["WEAPON_CARBINERIFLE_MK2"] = { ammo = 250 }})	
		elseif args[1] == "pump12" and vRP.hasPermission(user_id,"admin.permissao")  then
			vRPclient.giveWeapons(source,{["WEAPON_PUMPSHOTGUN"] = { ammo = 150 }})	

		elseif vRP.hasPermission(user_id,"polpar.permissao") then
			TriggerClientEvent("Notify",source,"negado","Armamento não encontrado.")
		end
	end
end)


-----------------------------------------------------------------------------------------------------------------------------------------
-- 911
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('911',function(source,args,rawCommand)
	if args[1] then
		local user_id = vRP.getUserId(source)
		local identity = vRP.getUserIdentity(user_id)
		if user_id then
			if vRP.hasPermission(user_id, "policia.permissao") then
				TriggerClientEvent('chatMessage',-1,"E.P.D | "..identity.name.." "..identity.firstname,{65,130,255},rawCommand:sub(4))
			else
				TriggerClientEvent('chatMessage',-1,identity.name.." "..identity.firstname,{65,130,255},rawCommand:sub(4))
			end
		end
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- PR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('pr',function(source,args,rawCommand)
	if args[1] then
		local user_id = vRP.getUserId(source)
		local identity = vRP.getUserIdentity(user_id)
		local permission = "policia.permissao"
		if vRP.hasPermission(user_id,permission) then
			local soldado = vRP.getUsersByPermission(permission)
			for l,w in pairs(soldado) do
				local player = vRP.getUserSource(parseInt(w))
				if player then
					async(function()
						TriggerClientEvent('chatMessage',player,identity.name.." "..identity.firstname,{255,175,175},rawCommand:sub(3))
					end)
				end
			end
		end
	end
end)


local policia = {}
RegisterServerEvent("vrp_policia:localizacao")
AddEventHandler("vrp_policia:localizacao",function()
	local source = source
	local user_id = vRP.getUserId(source)
	local uplayer = vRP.getUserSource(user_id)
	local identity = vRP.getUserIdentity(user_id)
	local x,y,z = vRPclient.getPosition(source)
	if vRPclient.getHealth(source) > 100 then
		if vRP.hasPermission(user_id,"policia.permissao") then
			TriggerClientEvent("Notify",source,"aviso","Localização enviada.")
			local soldado = vRP.getUsersByPermission("policia.permissao")
			for l,w in pairs(soldado) do
				local player = vRP.getUserSource(parseInt(w))
				if player and player ~= uplayer then
					async(function()
						local id = idgens:gen()
						TriggerClientEvent("Notify",player,"importante","Localização recebida de <b>"..identity.name.." "..identity.firstname.."</b>.")
						TriggerClientEvent("vrp_sound:source",source,'aviso',0.2)

						policia[id] = vRPclient.addRadiusBlip(player, x, y, z, 3, 150.0, 60)	
						SetTimeout(30000,function() 
							vRPclient.removeBlip(player,policia[id]) 
							idgens:free(id) 
						end)							
					end)
				end
			end
		end
	end
end)

-- QUANDO O PLAYER SAIR DO SERVER ELE VAI SAIR DO SERVICO
AddEventHandler("playerDropped",function(reason)
	local source = source
	local user_id = vRP.getUserId(source)

	if vRP.hasPermission(user_id,"policia.permissao") then
		DISCORD_WEBHOOK = "https://discordapp.com/api/webhooks/694063563441963109/IRe8EF-FIGOlX95QvC-l8aXrr-a6QQEd0OMRCXMCI_9s3hG0PfzfhuUCrSEUh8_cfVX5"
		TriggerEvent("everest:postarDiscord", source, DISCORD_WEBHOOK, "ELETRÔNICO POLICIA","SAIU DE SERVIÇO")
		vRP.addUserGroup(user_id,"PaisanaPolicia")
	elseif vRP.hasPermission(user_id,"paramedico.permissao") then
		DISCORD_WEBHOOK = "https://discordapp.com/api/webhooks/694051812910825523/xk0RUFkNSgtBCjXpsLGoPMZmf2Pa8hfbdVZzhtj90NKlMpRYslHVARn7qeP3QRr9hxrU"
		TriggerEvent("everest:postarDiscord", source, DISCORD_WEBHOOK, "ELETRÔNICO EMC","SAIU DE SERVIÇO")
		vRP.addUserGroup(user_id,"PaisanaParamedico")
	elseif vRP.hasPermission(user_id,"mecanico.permissao") then
		DISCORD_WEBHOOK = "https://discordapp.com/api/webhooks/676619687437664270/DsLy7zesfgIAVRKqTJupH4M56XarRqfC7fog1xbZOXh9P_kg8isUEi5uGHU07LPdZ0kW"
		TriggerEvent("everest:postarDiscord", source, DISCORD_WEBHOOK, "ELETRÔNICO MECANICO","SAIU DE SERVIÇO")
		vRP.addUserGroup(user_id,"PaisanaMecanico")
	elseif vRP.hasPermission(user_id,"taxista.permissao") then
		vRP.addUserGroup(user_id,"PaisanaTaxista")
	end

	vRP.removeUserGroup(user_id,"Taxista")
	vRP.removeUserGroup(user_id,"PaisanaTaxista")

	TriggerEvent('eblips:remove',source)
end)



RegisterServerEvent('heli:spotlight')
AddEventHandler('heli:spotlight', function(state)
	local serverID = source
	TriggerClientEvent('heli:spotlight', -1, serverID, state)
end)
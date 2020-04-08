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
Tunnel.bindInterface("vrp_residencia",src)
vCLIENT = Tunnel.getInterface("vrp_residencia")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local timehouses = {}
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		for k,v in pairs(timehouses) do
			if v > 0 then
				timehouses[k] = v - 1
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKLOCKPICK
-----------------------------------------------------------------------------------------------------------------------------------------
function src.checkLockpick(id,x,y,z,x2,y2,z2)
	local source = source
	local user_id = vRP.getUserId(source)
	local identity_user = vRP.getUserIdentity(user_id)
	if user_id then
		local policia = vRP.getUsersByPermission("policia.permissao")
		if #policia >= 2 then
			if timehouses[id] == 0 or not timehouses[id] then
				if vRP.getInventoryItemAmount(user_id,"chavemestra") >= 1 then
					vRP.tryGetInventoryItem(user_id,"chavemestra",1)
					timehouses[id] = 3600
					vCLIENT.checkStatus(source,true)
					vRPclient._playAnim(source,false,{{"amb@prop_human_parking_meter@female@idle_a","idle_a_female"}},true)	
					TriggerClientEvent("progress",source,20000,"invadindo")
					TriggerClientEvent("Notify",source,"sucesso","<b>Chave mestra</b> utilizada com sucesso.",8000)
					DISCORD_WEBHOOK = "https://discordapp.com/api/webhooks/676609249903640587/Pl8ZSwRrwIKpT6l12xhl9nwjs_MpUKpKBvOOdhFATcFvhFYaIkXxpou8AXEV5_X7vqa4"
                    sendToDiscordCAIXA("[ROUBO EM RESIDENCIA]","[ID]:"..user_id.."  "..identity_user.name.." "..identity_user.firstname , 16711680)
					SetTimeout(20000,function()
						if math.random(100) >= 97 then
							timehouses[id] = 0
							vCLIENT.checkStatus(source,false)
							vRPclient._stopAnim(source,false)
							TriggerClientEvent("Notify",source,"negado","Fechadura emperrada.",8000)
						else
							if math.random(100) >= 90 then
								vCLIENT.createLocker(source,true,x2,y2,z2)
							else
								vCLIENT.createLocker(source,false,x2,y2,z2)
							end
							vRPclient.teleport(source,x,y,z)
							TriggerEvent('vRP:isProcurado', user_id) -- Seta como procurado
							TriggerClientEvent('iniciandoRoubo',source,x,y,z)
						end
					end)
				else
					TriggerClientEvent("Notify",source,"negado","<b>Chave Mestra</b> não encontrada.",8000)
				end
			else
				TriggerClientEvent("Notify",source,"importante","Aguarde <b>"..timehouses[id].." segundos</b>.",8000)
			end
		else
			TriggerClientEvent("Notify",source,"aviso","Número insuficiente de policiais no momento.",8000)
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ITEMLIST
-----------------------------------------------------------------------------------------------------------------------------------------
local itemlist = {
	["gavetas"] = {
		[1] = { ['index'] = "carteiraroubada", ['qtd'] = 4, ['name'] = "Carteira" },
		[2] = { ['index'] = "relogioroubado", ['qtd'] = 4, ['name'] = "Relógio" },
		[3] = { ['index'] = "carregadorroubado", ['qtd'] = 3, ['name'] = "Carregador" },
		[4] = { ['index'] = "pulseiraroubada", ['qtd'] = 3, ['name'] = "Pulseira" },
		[5] = { ['index'] = "anelroubado", ['qtd'] = math.random(4), ['name'] = "Anel" },
		[6] = { ['index'] = "colarroubado", ['qtd'] = 3, ['name'] = "Colar" },
		[7] = { ['index'] = "brincoroubado", ['qtd'] = 3, ['name'] = "Brinco" }
	},
	["estante"] = {
		[1] = { ['index'] = "relogioroubado", ['qtd'] = 1, ['name'] = "Relógio" },
		[2] = { ['index'] = "carregadorroubado", ['qtd'] = 1, ['name'] = "Carregador" },
		[3] = { ['index'] = "pulseiraroubada", ['qtd'] = 1, ['name'] = "Pulseira" },
		[4] = { ['index'] = "anelroubado", ['qtd'] = math.random(4), ['name'] = "Anel" },
		[5] = { ['index'] = "colarroubado", ['qtd'] = 1, ['name'] = "Colar" },
		[6] = { ['index'] = "brincoroubado", ['qtd'] = 1, ['name'] = "Brinco" }
	},
	["cabeceira"] = {
		[1] = { ['index'] = "carteiraroubada", ['qtd'] = 4, ['name'] = "Carteira" },
		[2] = { ['index'] = "relogioroubado", ['qtd'] = 3, ['name'] = "Relógio" },
		[3] = { ['index'] = "carregadorroubado", ['qtd'] = 4, ['name'] = "Carregador" },
		[4] = { ['index'] = "pulseiraroubada", ['qtd'] = 5, ['name'] = "Pulseira" },
		[5] = { ['index'] = "anelroubado", ['qtd'] = math.random(4), ['name'] = "Anel" },
		[6] = { ['index'] = "colarroubado", ['qtd'] = 4, ['name'] = "Colar" },
		[7] = { ['index'] = "brincoroubado", ['qtd'] = 4, ['name'] = "Brinco" }
	},
	["mesinha"] = {
		[1] = { ['index'] = "carteiraroubada", ['qtd'] = 1, ['name'] = "Carteira" },
		[2] = { ['index'] = "relogioroubado", ['qtd'] = 1, ['name'] = "Relógio" },
		[3] = { ['index'] = "carregadorroubado", ['qtd'] = 1, ['name'] = "Carregador" },
		[4] = { ['index'] = "pulseiraroubada", ['qtd'] = 1, ['name'] = "Pulseira" },
		[5] = { ['index'] = "anelroubado", ['qtd'] = math.random(4), ['name'] = "Anel" },
		[6] = { ['index'] = "colarroubado", ['qtd'] = 1, ['name'] = "Colar" },
		[7] = { ['index'] = "brincoroubado", ['qtd'] = 1, ['name'] = "Brinco" }
	},
	["televisao"] = {
		[1] = { ['index'] = "tabletroubado", ['qtd'] = 1, ['name'] = "Tablet" },
		[2] = { ['index'] = "carregadorroubado", ['qtd'] = 1, ['name'] = "Carregador" }
	},
	["armario"] = {
		[1] = { ['index'] = "sapatosroubado", ['qtd'] = 1, ['name'] = "Sapatos" },
		[2] = { ['index'] = "vibradorroubado", ['qtd'] = 1, ['name'] = "Vibrador" },
		[3] = { ['index'] = "perfumeroubado", ['qtd'] = 1, ['name'] = "Perfume" }
	},
	["bau"] = {
		[1] = { ['index'] = "sapatosroubado", ['qtd'] = 1, ['name'] = "Sapatos" },
		[2] = { ['index'] = "tabletroubado", ['qtd'] = 1, ['name'] = "Tablet" },
		[3] = { ['index'] = "dinheirosujo", ['qtd'] = math.random(3000,5000), ['name'] = "Dinheiro Sujo" },
		[4] = { ['index'] = "mochila", ['qtd'] = 1, ['name'] = "Mochila" },
		[5] = { ['index'] = "bandagem", ['qtd'] = 1, ['name'] = "Bandagem" }
	},
	["comoda"] = {
		[1] = { ['index'] = "dinheirosujo", ['qtd'] = math.random(3000,5000), ['name'] = "Dinheiro Sujo" },
		[2] = { ['index'] = "relogioroubado", ['qtd'] = 1, ['name'] = "Relógio" },
		[3] = { ['index'] = "carregadorroubado", ['qtd'] = 1, ['name'] = "Carregador" },
		[4] = { ['index'] = "maquiagemroubada", ['qtd'] = 1, ['name'] = "Maquiagem" },
		[5] = { ['index'] = "pulseiraroubada", ['qtd'] = 1, ['name'] = "Pulseira" },
		[6] = { ['index'] = "anelroubado", ['qtd'] = math.random(4), ['name'] = "Anel" },
		[7] = { ['index'] = "colarroubado", ['qtd'] = 1, ['name'] = "Colar" },
		[8] = { ['index'] = "brincoroubado", ['qtd'] = 1, ['name'] = "Brinco" }
	},
	["roupas"] = {
		[1] = { ['index'] = "sapatosroubado", ['qtd'] = 1, ['name'] = "Sapatos" },
		[2] = { ['index'] = "vibradorroubado", ['qtd'] = 1, ['name'] = "Vibrador" },
		[3] = { ['index'] = "mochila", ['qtd'] = 1, ['name'] = "Mochila" },
		[4] = { ['index'] = "maquiagemroubada", ['qtd'] = 1, ['name'] = "Maquiagem" },
		[5] = { ['index'] = "carregadorroubado", ['qtd'] = 1, ['name'] = "Carregador" },
		[6] = { ['index'] = "maquiagemroubada", ['qtd'] = 1, ['name'] = "Maquiagem" }
	},
	["pia"] = {
		[1] = { ['index'] = "perfumeroubado", ['qtd'] = 1, ['name'] = "Perfume" },
		[2] = { ['index'] = "carregadorroubado", ['qtd'] = 1, ['name'] = "Carregador" },
		[3] = { ['index'] = "relogioroubado", ['qtd'] = 1, ['name'] = "Relógio" },
		[4] = { ['index'] = "maquiagemroubada", ['qtd'] = 1, ['name'] = "Maquiagem" },
		[5] = { ['index'] = "pulseiraroubada", ['qtd'] = 2, ['name'] = "Pulseira" },
		[6] = { ['index'] = "anelroubado", ['qtd'] = math.random(2), ['name'] = "Anel" },
		[7] = { ['index'] = "colarroubado", ['qtd'] = 1, ['name'] = "Colar" },
		[8] = { ['index'] = "brincoroubado", ['qtd'] = 1, ['name'] = "Brinco" },
		[9] = { ['index'] = "bandagem", ['qtd'] = math.random(3), ['name'] = "Bandagem" }
	},
	["cama"] = {
		[1] = { ['index'] = "carteiraroubada", ['qtd'] = 1, ['name'] = "Carteira" },
		[2] = { ['index'] = "vibradorroubado", ['qtd'] = 2, ['name'] = "Vibrador" },
		[3] = { ['index'] = "tabletroubado", ['qtd'] = 1, ['name'] = "Tablet" },
		[4] = { ['index'] = "dinheirosujo", ['qtd'] = math.random(3000,5000), ['name'] = "Dinheiro Sujo" },
		[5] = { ['index'] = "carregadorroubado", ['qtd'] = 1, ['name'] = "Carregador" },
		[6] = { ['index'] = "maquiagemroubada", ['qtd'] = 1, ['name'] = "Maquiagem" },
		[7] = { ['index'] = "pulseiraroubada", ['qtd'] = 1, ['name'] = "Pulseira" },
		[8] = { ['index'] = "anelroubado", ['qtd'] = math.random(2), ['name'] = "Anel" },
		[9] = { ['index'] = "colarroubado", ['qtd'] = 1, ['name'] = "Colar" },
		[10] = { ['index'] = "brincoroubado", ['qtd'] = 2, ['name'] = "Brinco" }
	},
	["locker2"] = {
		[1] = { ['index'] = "dinheirosujo", ['qtd'] = math.random(20000,60000), ['name'] = "Dinheiro Sujo" }
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKPAYMENT
-----------------------------------------------------------------------------------------------------------------------------------------
function src.checkPayment(house,mod,x,y,z)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRPclient.getAgachar(source) then
			randlist = math.random(100)
		else
			randlist = math.random(115)
		end
		if randlist <= 95 then
			local randitem = math.random(#itemlist[mod])
			vRP.giveInventoryItem( user_id,itemlist[mod][randitem].index,itemlist[mod][randitem].qtd)
			TriggerClientEvent("Notify",source,"sucesso","Você encontrou "..itemlist[mod][randitem].qtd.."x <b>"..itemlist[mod][randitem].name.."</b>.",8000)
		elseif randlist >= 75 and randlist <= 95 then
			TriggerClientEvent("Notify",source,"importante","Compartimento vazio.",8000)
		elseif randlist >= 60 then
			TriggerClientEvent("vrp_sound:source",source,'alarm',0.4)
			TriggerEvent("global:avisarPolicia", "O alarme da residência ^1"..house.."^0 disparou, verifique o ocorrido.",x,y,z, 1)
		end
	end
end

function sendToDiscordCAIXA(name, message, color)
    local connect = {
          {
              ["color"] = color,
              ["title"] = "".. name .."",
              ["description"] = message,
              ["footer"] = {["text"] = "Everest RolePlay"},
          }
      }
    PerformHttpRequest(DISCORD_WEBHOOK, function(err, text, headers) end, 'POST', json.encode({username = DISCORD_NAME, embeds = connect, avatar_url = DISCORD_IMAGE}), { ['Content-Type'] = 'application/json' })
end

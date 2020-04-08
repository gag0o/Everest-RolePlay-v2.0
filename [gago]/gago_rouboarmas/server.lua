-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONEXÃO
-----------------------------------------------------------------------------------------------------------------------------------------
src = {}
Tunnel.bindInterface("gago_rouboarmas",src)
vCLIENT = Tunnel.getInterface("gago_rouboarmas")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local robbery = false
local timedown = 0
-----------------------------------------------------------------------------------------------------------------------------------------
-- ROBBERS
-----------------------------------------------------------------------------------------------------------------------------------------
local robbers = {
	[1] = { "Loja de Armas",60,50000,67000 },
	[2] = { "Loja de Armas",60,50000,67000 },
	[3] = { "Loja de Armas",60,50000,67000 },
	[4] = { "Loja de Armas",60,50000,67000 },
	[5] = { "Loja de Armas",60,50000,67000 },
	[6] = { "Loja de Armas",60,50000,67000 },
	[7] = { "Loja de Armas",60,50000,67000 },

}
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKPOLICE
-----------------------------------------------------------------------------------------------------------------------------------------
function src.checkPolice()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local policia = vRP.getUsersByPermission("policia.permissao")
		if #policia <= 1 then
			TriggerClientEvent("Notify",source,"aviso","Sistema indisponível no momento.",8000)
			return false
		elseif (parseInt(os.time())-timedown) <= 7200 then
			TriggerClientEvent("Notify",source,"importante","Aguarde "..vRP.getMinSecs(parseInt(7200-(os.time()-timedown)))..".",8000)
			return false
		end
	end
	return true
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- STARTROBBERY
-----------------------------------------------------------------------------------------------------------------------------------------
function src.startRobbery(id,x,y,z)
	local source = source
	local user_id = vRP.getUserId(source)
	local identity_user = vRP.getUserIdentity(user_id)
	if user_id then
		robbery = true
		timedown = parseInt(os.time())
		vCLIENT.startRobbery(source,robbers[id][2],x,y,z)

		local policia = vRP.getUsersByPermission("policia.permissao")
		for k,v in pairs(policia) do
			local policial = vRP.getUserSource(v)
			if policial then
				async(function()
					vCLIENT.startRobberyPolice(policial,x,y,z,robbers[id][1])
							DISCORD_WEBHOOK = "https://discordapp.com/api/webhooks/676609249903640587/Pl8ZSwRrwIKpT6l12xhl9nwjs_MpUKpKBvOOdhFATcFvhFYaIkXxpou8AXEV5_X7vqa4"
                    sendToDiscordCAIXA("[ROUBO EM LOJA DE ARMAS]","[ID]:"..user_id.."  "..identity_user.name.." "..identity_user.firstname , 16711680)
					vRPclient.playSound(policial,"Oneshot_Final","MP_MISSION_COUNTDOWN_SOUNDSET")
					TriggerClientEvent('chatMessage',policial,"Dispatch",{65,130,255},"O roubo começou no ^1"..robbers[id][1].."^0, dirija-se até o local e intercepte os assaltantes.")
				end)
			end
		end

		SetTimeout(robbers[id][2]*1000,function()
			if robbery then
				robbery = false
				vRP.searchTimer(user_id,1800)
				vRP.giveInventoryItem( user_id,"dinheirosujo",parseInt(math.random(robbers[id][3],robbers[id][4])))

				if parseInt(math.random(100)) >= 10 then
					local weaponsort = math.random(1)
					if parseInt(weaponsort) == 1 then
						vRP.giveInventoryItem( user_id,"dinheirosujo",1)
						vRP.giveInventoryItem( user_id,"dinheirosujo",1)
					elseif parseInt(weaponsort) == 2 then
						vRP.giveInventoryItem( user_id,"dinheirosujo",1)
						vRP.giveInventoryItem( user_id,"dinheirosujo",1)
					--elseif parseInt(weaponsort) == 3 then
						--vRP.giveInventoryItem( user_id,"wbody|WEAPON_SNSPISTOL_MK2",1)
						--vRP.giveInventoryItem( user_id,"wbody|WEAPON_REVOLVER",1)
					end
				end

				for k,v in pairs(policia) do
					local policial = vRP.getUserSource(v)
					if policial then
						async(function()
							vCLIENT.stopRobberyPolice(policial)
							TriggerClientEvent('chatMessage',policial,"Dispatch",{65,130,255},"O roubo terminou, os assaltantes estão correndo antes que vocês cheguem.")
						end)
					end
				end
			end
		end)

	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- STOPROBBERY
-----------------------------------------------------------------------------------------------------------------------------------------
function src.stopRobbery()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if robbery then
			robbery = false
			local policia = vRP.getUsersByPermission("policia.permissao")
			for k,v in pairs(policia) do
				local policial = vRP.getUserSource(v)
				if policial then
					async(function()
						vCLIENT.stopRobberyPolice(policial)
						TriggerClientEvent('chatMessage',policial,"Dispatch",{65,130,255},"O assaltante saiu correndo e deixou tudo para trás.")
					end)
				end
			end
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

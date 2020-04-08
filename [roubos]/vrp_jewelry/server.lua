local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
local Tools = module("vrp","lib/Tools")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")

func = {}
Tunnel.bindInterface("vrp_jewelry",func)
local idgens = Tools.newIDGenerator()
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local timers = 0
local andamento = false
local roubando = false
local segundos = 0
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKJEWELRY
-----------------------------------------------------------------------------------------------------------------------------------------
function func.checkJewelry(x,y,z,h,sec,tipo)
	local source = source
	local user_id = vRP.getUserId(source)
	local identity_user = vRP.getUserIdentity(user_id)
	local policia = vRP.getUsersByPermission("policia.permissao")
	if user_id then
		if #policia < 4 then
			TriggerClientEvent("Notify",source,"aviso","Número insuficiente de policiais no momento.",8000)
		elseif (os.time()-timers) <= 10800 then
			TriggerClientEvent("Notify",source,"aviso","A joalheria não se recuperou do ultimo roubo, aguarde <b>"..vRP.format(parseInt((10800-(os.time()-timers)))).." segundos</b> até que o sistema seja restaurado.",8000)
		else
			if vRP.getInventoryItemAmount(user_id,"pendrive") >= 1 and not roubando then
				roubando = true
				vRPclient._playAnim(source,false,{{"anim@heists@prison_heistig1_p1_guard_checks_bus","loop"}},true)
				TriggerClientEvent('iniciandojewelry',source,x,y,z,h,sec,tipo,true)
				local firewall = math.random(100)
				SetTimeout(sec*1000,function()
					if firewall >= 20 then
						segundos = 600
						andamento = true
						timers = os.time()
						TriggerClientEvent('iniciandojewelry',source,x,y,z,h,sec,tipo,false)
						TriggerClientEvent("Notify",source,"sucesso","A proteção do <b>Baidu Antivirus</b> foi comprometida e todos os balcões foram liberados.",8000)
						SetTimeout(60000,function()
							vRPclient.setStandBY(source,parseInt(300))
							func.callPolice(x,y,z)
						end)
						DISCORD_WEBHOOK = "https://discordapp.com/api/webhooks/676609249903640587/Pl8ZSwRrwIKpT6l12xhl9nwjs_MpUKpKBvOOdhFATcFvhFYaIkXxpou8AXEV5_X7vqa4"
					 sendToDiscordCAIXA("[ROUBO EM JOALHERIA]","[ID]:"..user_id.."  "..identity_user.name.." "..identity_user.firstname , 16711680)
					else
						roubando = false
						func.callPolice(x,y,z)
						TriggerClientEvent('iniciandojewelry',source,x,y,z,h,sec,tipo,false)
						TriggerClientEvent("Notify",source,"aviso","O computador é protegido pelo <b>Baidu Antivirus</b>, ele bloqueou sua conexão, tente novamente.",8000)
					end
				end)
			else
				TriggerClientEvent("Notify",source,"importante","Precisa de um <b>Pendrive</b> para hackear as câmeras de segurança.",8000)
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CALLPOLICE
-----------------------------------------------------------------------------------------------------------------------------------------
function func.callPolice(x,y,z)
	local source = source
	TriggerClientEvent("vrp_sound:fixed",-1,source,x,y,z,100,'alarm',0.7)
	TriggerEvent("global:avisarPolicia", "O roubo começou na ^1Joalheria^0, dirija-se até o local e intercepte o assaltante.",x,y,z, 1)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- RETURNJEWELRY
-----------------------------------------------------------------------------------------------------------------------------------------
function func.returnJewelry()
	return andamento
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TIMEROBBERY
-----------------------------------------------------------------------------------------------------------------------------------------
local timers = {}
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		for k,v in pairs(timers) do
			if v > 0 then
				timers[k] = v - 1
			end
		end
		if andamento then
			segundos = segundos - 1
			if segundos <= 0 then
				timers = {}
				andamento = false
				roubando = false
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKJEWELS
-----------------------------------------------------------------------------------------------------------------------------------------
local jewels = {
	[1] = { item = "relogioroubado" },
	[2] = { item = "pulseiraroubada" },
	[3] = { item = "anelroubado" },
	[4] = { item = "colarroubado" },
	[5] = { item = "brincoroubado" }
}

function func.checkJewels(id,x,y,z,h,tipo)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if timers[id] == 0 or not timers[id] then
			timers[id] = 600
			TriggerClientEvent('iniciandojewelry',source,x,y,z,h,10,tipo,true)
			vRPclient._playAnim(source,false,{{"oddjobs@shop_robbery@rob_till","loop"}},true)
			SetTimeout(10000,function()
				vRPclient.setStandBY(source,parseInt(60))
				vRP.giveInventoryItem( user_id,jewels[math.random(5)].item,math.random(15,25))
			end)
		else
			TriggerClientEvent("Notify",source,"aviso","O balcão está vazio, aguarde <b>"..vRP.format(parseInt(timers[id])).." segundos</b> até que a loja se recupera do ultimo roubo.",8000)
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

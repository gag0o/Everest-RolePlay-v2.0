local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP", "vrp_anticopy")

src = {}
Tunnel.bindInterface("vrp_anticopy",src)
Proxy.addInterface("vrp_anticopy",src)

local DISCORD_WEBHOOK = "https://discordapp.com/api/webhooks/676606486239248394/hWvsGxsA-38936Fj_LRZc1wyi3zfR3F5j6-lJfKIGQL_EpflRlLaJzGEXOBd0MD0P9Qk"

local loaded = {}
function src.pegaTrouxa()
	local source = source
	local user_id = vRP.getUserId(source)

	local fields2 = {}
	table.insert(fields2, { name = "Espertao Detector:", value = 'ID => **'..user_id..'** \nFoi pego tentando roubar scripts da cidade.', inline = true });
	TriggerEvent("everest:postarDiscord", source, DISCORD_WEBHOOK, "LOGS RESOURCE", "ID: "..user_id.. "\nTENTOU ROUBAR RESOURCE", 16711680)
    PerformHttpRequest("postadiscord", function(err, text, headers) end, 'POST', json.encode({username = "In Game Log System", content = nil, embeds = {{color = 16754176, fields = fields2,}}}), { ['Content-Type'] = 'application/json' }) 
	--print("Tentativa de Acesso ao Chrome Inspector! ID: "..user_id)
	local source = source
	local user_id = vRP.getUserId(source)
	vRP.setBanned(user_id,1)
	vRP.kick(source,"EVEREST SYSTEM : UM TROUXA FOI PEGO,TENTANDO ROUBAR RESOURCE!")	


end


local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")

src = {}
Tunnel.bindInterface("vrp_anticopy",src)
Proxy.addInterface("vrp_anticopy",src)
acClient = Tunnel.getInterface("vrp_anticopy")

RegisterNUICallback("loadNuis", function(data, cb)
	acClient.pegaTrouxa()
end)



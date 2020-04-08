local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","gago_roupas")
vRPloja = Tunnel.getInterface("gago_roupas")

RegisterServerEvent("LojaDeRoupas:Comprar")
AddEventHandler("LojaDeRoupas:Comprar", function(preco)
    local user_id = vRP.getUserId(source)
    if preco then
        if vRP.tryPayment(user_id, preco) then
        	TriggerClientEvent("Notify",source,"sucesso","Comprou <b>$"..vRP.format(parseInt(preco)).."</b> em roupas e acessórios.")
            TriggerClientEvent('LojaDeRoupas:ReceberCompra', source, true)
        else
            TriggerClientEvent("Notify",source,"negado","Dinheiro insuficiente.")
            TriggerClientEvent('LojaDeRoupas:ReceberCompra', source, false)
        end
    end
end)


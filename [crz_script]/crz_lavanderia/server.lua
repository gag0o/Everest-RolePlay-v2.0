local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")

RegisterServerEvent('crz_lavanderia:depositarDSujo')
AddEventHandler('crz_lavanderia:depositarDSujo', function(maq)
    local src = source
    local user_id = vRP.getUserId(source)
    local prompt = vRP.prompt(src,"Colocar quanto na máquina?", "10000")
    if tonumber(prompt) <= 10000 then
        if vRP.tryGetInventoryItem(user_id,"dinheirosujo",tonumber(prompt),false) then
            vRPclient._playAnim(src,true,{{"mp_common","givetake1_a",1}},false)
            TriggerClientEvent('crz_lavanderia:coloqueiDinheiro', src, maq, tonumber(prompt))
        end
    else
        TriggerClientEvent('chatMessage',src,"ALERTA",{255,70,50},"Limite de até 10.000 dinheiro sujo.")
    end
end)

RegisterServerEvent('crz_lavanderia:enviarQuantia')
AddEventHandler('crz_lavanderia:enviarQuantia', function(receber)
    local src = source
    local user_id = vRP.getUserId(source)
    local pagamento = receber*0.5
    vRP.giveMoney(user_id,parseInt(pagamento))
    TriggerClientEvent('chatMessage',source,"ALERTA",{255,70,50},"Você recebeu $"..pagamento..".")
end)
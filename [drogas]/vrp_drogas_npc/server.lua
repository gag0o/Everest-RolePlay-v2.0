local Proxy = module("vrp", "lib/Proxy")
local Tunnel = module("vrp", "lib/Tunnel")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")

func = {}
Tunnel.bindInterface("vrp_drogas_npc", func)

local isVendendo = {}
local ultimoLocal = 0
local locaisVenda = {}
-- local blips = {}
-- local timers = {}

RegisterCommand('droga', function(source, args, rawCommand)
    local user_id = vRP.getUserId(source)
    if not vRP.hasPermission(user_id,"groove.permissao") and not vRP.hasPermission(user_id,"vagos.permissao") and not vRP.hasPermission(user_id,"ballas.permissao") and not vRP.hasPermission(user_id,"bahamas.permissao") then
        if isVendendo[user_id] then
            isVendendo[user_id] = false

            -- vRPclient.removeBlip(source, blips[user_id])
            TriggerClientEvent("Notify", source, "aviso", "Você parou de vender!")
            TriggerClientEvent("vrp_drogas_npc:changeLocalVenda", source, 0)
        else
            isVendendo[user_id] = true
            TriggerClientEvent("Notify", source, "aviso",
                            "Boas vendas!")
            TriggerClientEvent("vrp_drogas_npc:changeLocalVenda", source,1)
            -- func.marcarLocalVenda(source, false)
        end
    else
        TriggerClientEvent("Notify", source, "negado",
                            "Você não pode trabalhar como avião!")
    end
end)

function func.marcarLocalVenda(source, changeCoord)
    local user_id = vRP.getUserId(source)
    if isVendendo[user_id] then
        local localAtual = math.random(#Config.Locais)

        if ultimoLocal == localAtual then
            func.marcarLocalVenda(source, true)
            return
        else
            ultimoLocal = localAtual
        end

        if not locaisVenda[user_id] or changeCoord then
            if localAtual == locaisVenda[user_id] then
                localAtual = math.random(#Config.Locais)
            end
            locaisVenda[user_id] = localAtual
        end

        -- local coords = Config.Locais[locaisVenda[user_id]]
        -- blips[user_id] = vRPclient.addRadiusBlip(source, coords.x, coords.y,
        --                                          coords.z, 3, 500.0, 40)

        TriggerClientEvent("vrp_drogas_npc:changeLocalVenda", source,
                           locaisVenda[user_id])

        -- timers[user_id] = os.time()

        -- SetTimeout(coords.minutes * 60 * 1000, function()
        --     if os.time() - timers[user_id] == coords.minutes * 60 then
        --         vRPclient.removeBlip(source, blips[user_id])
        --         TriggerClientEvent("Notify", source, "aviso",
        --                            "Uma nova área de venda foi demarcada, venda as drogas no local!")
        --         func.marcarLocalVenda(source, true)
        --     end
        -- end)
    end
end

function func.venderDroga()
    local source = source
    local user_id = vRP.getUserId(source)
    local player = vRP.getUserSource(user_id)
    local drugs = {"maconha", "cocaina", "metanfetamina", "moonshine"} -- total drugs list

    local t = math.random(#drugs)
    if math.random(1, 2) ~= 2 then
      local index = 0
        while index ~= 2 and vRP.getInventoryItemAmount(user_id, drugs[t]) == 0 do
            Citizen.Wait(0)
            index = index+1
            t = math.random(#drugs)
        end
    end

    local qtd = math.random(1, 3)
    if vRP.tryGetInventoryItem(user_id, drugs[t], qtd, true) then
        local policia = vRP.getUsersByPermission("policia.permissao")

        local valor = 600*qtd

        --[[if #policia > 4 then
            local porcentagem = 0.4*qtd
            valor = (300 + (300 * porcentagem)) * qtd
        end]]

         if #policia > 4 then
             valor = 300 * qtd
         elseif #policia > 7 then
             valor = 600 * qtd
         elseif #policia > 11 then
             valor = 1400 * qtd
         elseif #policia > 14 then
             valor = 2000 * qtd
         end
        
        local msg = "Você recebeu <b>$" .. valor .. " por " .. qtd .. " " ..
                        drugs[t] .. "(s)</b>."
        TriggerClientEvent("Notify", source, "sucesso", msg)
        vRP.giveInventoryItem( user_id, "dinheirosujo", valor)
        return true
    else
        TriggerClientEvent("Notify", source, "negado", "O usuário queria " ..
                               qtd .. " " .. drugs[t] ..
                               "(s), mas você não tem!")
        return false
    end
end

function func.MarcarOcorrencia()
    local source = source
    local user_id = vRP.getUserId(source)
    local x, y, z = vRPclient.getPosition(source)
    TriggerEvent("global:avisarPolicia",
                 "Recebemos a denuncia de venda de droga.", x, y, z, 2)
end

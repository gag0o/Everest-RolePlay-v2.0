-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- WEB-OKC
-----------------------------------------------------------------------------------------------------------------------------------------
local DISCORD_WEBHOOK =
    "https://discordapp.com/api/webhooks/668180827242496005/1Mq1fHIYyI3nra_lxud7V2ow_0EqPFwD0cWOx2lugtsg7TaLnCXgYQG8m70QkYcRdfnR"
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONEXÃO
-----------------------------------------------------------------------------------------------------------------------------------------
src = {}
Tunnel.bindInterface("vrp_ammunation", src)
vCLIENT = Tunnel.getInterface("vrp_ammunation")
-----------------------------------------------------------------------------------------------------------------------------------------
-- UTILIDADES
-----------------------------------------------------------------------------------------------------------------------------------------
local utilidades = {
    ["wbody|GADGET_PARACHUTE"] = {['price'] = 5000},
    ["radio"] = {['price'] = 3000},
    ["postit"] = {['price'] = 250}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- ARMAMENTOS
-----------------------------------------------------------------------------------------------------------------------------------------
local armamentos = {
    ["wbody|WEAPON_MUSKET"] = {['price'] = 50000},
    ["wbody|WEAPON_FLARE"] = {['price'] = 1000},
    ["wbody|WEAPON_KNIFE"] = {['price'] = 2000},
    ["wbody|WEAPON_DAGGER"] = {['price'] = 2000},
    ["wbody|WEAPON_KNUCKLE"] = {['price'] = 2000},
    ["wbody|WEAPON_MACHETE"] = {['price'] = 2000},
    ["wbody|WEAPON_SWITCHBLADE"] = {['price'] = 2000},
    ["wbody|WEAPON_WRENCH"] = {['price'] = 2000},
    ["wbody|WEAPON_HAMMER"] = {['price'] = 2000},
    ["wbody|WEAPON_GOLFCLUB"] = {['price'] = 2000},
    ["wbody|WEAPON_CROWBAR"] = {['price'] = 2000},
    ["wbody|WEAPON_HATCHET"] = {['price'] = 2000},
    ["wbody|WEAPON_FLASHLIGHT"] = {['price'] = 2000},
    ["wbody|WEAPON_BAT"] = {['price'] = 2000},
    ["wbody|WEAPON_BOTTLE"] = {['price'] = 2000},
    ["wbody|WEAPON_BATTLEAXE"] = {['price'] = 2000},
    ["wbody|WEAPON_POOLCUE"] = {['price'] = 2000},
    ["wbody|WEAPON_STONE_HATCHET"] = {['price'] = 3000}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- MUNICOES
-----------------------------------------------------------------------------------------------------------------------------------------
local municoes = {
    ["wammo|WEAPON_MUSKET"] = {['price'] = 50},
    ["wammo|WEAPON_FLARE"] = {['price'] = 10}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- UTILIDADESLIST
-----------------------------------------------------------------------------------------------------------------------------------------
function src.utilidadesList()
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        local itemlist = {}
        for k, v in pairs(utilidades) do
            table.insert(itemlist, {
                index = k,
                name = vRP.itemNameList(k),
                price = parseInt(v.price)
            })
        end
        return itemlist
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ARMAMENTOSLIST
-----------------------------------------------------------------------------------------------------------------------------------------
function src.armamentosList()
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        local itemlist = {}
        for k, v in pairs(armamentos) do
            table.insert(itemlist, {
                index = k,
                name = vRP.itemNameList(k),
                price = parseInt(v.price)
            })
        end
        return itemlist
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- MUNICOESLIST
-----------------------------------------------------------------------------------------------------------------------------------------
function src.municoesList()
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        local itemlist = {}
        for k, v in pairs(municoes) do
            table.insert(itemlist, {
                index = k,
                name = vRP.itemNameList(k),
                price = parseInt(v.price)
            })
        end
        return itemlist
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SHOPBUY
-----------------------------------------------------------------------------------------------------------------------------------------
function src.shopBuy(index, price, amount)
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        if vRP.getInventoryWeight(user_id) + vRP.getItemWeight(index) *
            parseInt(amount) <= vRP.getInventoryMaxWeight(user_id) then

            local valor = parseInt(price * amount)
            if vRP.getPremium(user_id) then
                valor = parseInt(price * amount) * 0.95
            end
            if vRP.tryFullPayment(user_id, parseInt(price * amount)) then
                vRP.giveInventoryItem(user_id, index, parseInt(amount))
                TriggerClientEvent("Notify", source, "sucesso",
                                   "Comprou <b>" .. vRP.format(parseInt(amount)) ..
                                       "x " .. vRP.itemNameList(index) ..
                                       "</b> por <b>$" ..
                                       vRP.format(parseInt(price * amount)) ..
                                       " dólares</b>.", 8000)
                TriggerEvent("everest:postarDiscord", source, DISCORD_WEBHOOK,
                             "Ammunation","[ID]: " .. user_id .. "\n[Comprou]: " ..
                                 parseInt(amount) .. "x " ..
                                 vRP.itemNameList(index) .. "\n $ " ..
                                 vRP.format(parseInt((price * amount) * 0.95)))
            else
                TriggerClientEvent("Notify", source, "negado",
                                   "Dinheiro insuficiente.", 8000)
            end

        else
            TriggerClientEvent("Notify", source, "negado",
                               "<b>Mochila</b> cheia.", 8000)
        end
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKSEARCH
-----------------------------------------------------------------------------------------------------------------------------------------
function src.checkSearch()
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        if not vRP.searchReturn(source, user_id) then return true end
        return false
    end
end
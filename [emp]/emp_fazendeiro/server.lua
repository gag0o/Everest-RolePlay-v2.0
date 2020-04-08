-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
local Tools = module("vrp","lib/Tools")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONEXÃO
-----------------------------------------------------------------------------------------------------------------------------------------
fan = {}
local idgens = Tools.newIDGenerator()
Tunnel.bindInterface("emp_fazendeiro",fan)
vCLIENT = Tunnel.getInterface("emp_fazendeiro")
vRPclient = Tunnel.getInterface("vRP")

function fan.checkWeigth(item, amount)
	local source = source
	local user_id = vRP.getUserId(source)
    if user_id then
		return vRP.getInventoryWeight(user_id)+vRP.getItemWeight(item)*amount <= vRP.getInventoryMaxWeight(user_id)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REMOVEITEM
-----------------------------------------------------------------------------------------------------------------------------------------
function fan.takeItem(item, amount)
    local source = source
    local user_id = vRP.getUserId(source)
    if vRP.tryGetInventoryItem(user_id, item, amount) then
        return true
    else
        return false
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADDITEM
-----------------------------------------------------------------------------------------------------------------------------------------
function fan.giveItem(item, amount)
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
       if vRP.giveInventoryItem(user_id, item, amount) then
       end
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
local Tools = module("vrp","lib/Tools")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONEXÃO
-----------------------------------------------------------------------------------------------------------------------------------------
src = {}
Tunnel.bindInterface("vrp_postit",src)
vCLIENT = Tunnel.getInterface("vrp_postit")
local idgens = Tools.newIDGenerator()
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIÁVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local postits = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- CREATEEVIDENCES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand('postit',function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if string.len(rawCommand:sub(8)) > 0 and string.len(rawCommand:sub(8)) < 80 then
			if vRP.tryGetInventoryItem(user_id,"postit",1) then
				local x,y,z = vRPclient.getPosition(source)
				if args[1] then
					local id = idgens:gen()
					if id then
						postits[id] = { user_id = parseInt(user_id), text = rawCommand:sub(8), x = x, y = y, z = z, time = 1800 }
						vCLIENT.postitsPlayers(-1,id,postits[id])
					end
				end
			end
		else
			TriggerClientEvent("Notify",source,"sucesso","O máximo de letras no post-it é <b>80</b>.",8000)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PICKUPEVIDENCES
-----------------------------------------------------------------------------------------------------------------------------------------
function src.pickupPostits(id)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasPermission(user_id,"admin.permissao") then
			TriggerClientEvent("Notify",source,"sucesso","Postado pelo passaporte <b>"..postits[id].user_id.."</b>.",8000)
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- EVIDENCESTIMEDOWN
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10000)
		for k,v in pairs(postits) do
			if postits[k].time > 0 then
				postits[k].time = postits[k].time - 10
				if postits[k].time <= 0 then
					postits[k] = nil
					idgens:free(k)
					vCLIENT.removePostits(-1,k)
				end
			end
			Citizen.Wait(10)
		end
	end
end)
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
local Tools = module("vrp", "lib/Tools")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")

vRPN = {}
Tunnel.bindInterface("vrp_inventory", vRPN)
Proxy.addInterface("vrp_inventory", vRPN)

local idgens = Tools.newIDGenerator()

vGARAGE = Tunnel.getInterface("vrp_garages")

local cfg = module("vrp_inventory","config")

vRP._prepare("creative/set_premium",
             "UPDATE vrp_users SET premium = @premium WHERE id = @user_id")
vRP._prepare("creative/get_priority",
             "SELECT * FROM vrp_priority WHERE user_id = @user_id")
vRP._prepare("creative/set_priority",
             "INSERT INTO vrp_priority(user_id,steam,priority) VALUES(@user_id,@steam,@priority)")
vRP._prepare("creative/rem_priority",
             "DELETE FROM vrp_priority WHERE user_id = @user_id")
             ------------------------------------------------------------------------------------------------------------------------------------------
-- WEB-OKC
-----------------------------------------------------------------------------------------------------------------------------------------
local DISCORD_WEBHOOK = "https://discordapp.com/api/webhooks/676632491188027402/0kBhFGxQqoznzkwcVYUiKoJJDLYZDy84xDJSivVx27UIGjCRts5monrJ9G9IzpNsM_27"
local DISCORD_NAME = "EVEREST INFINITY"
--local STEAM_KEY = ""
local DISCORD_IMAGE = "https://pbs.twimg.com/profile_images/847824193899167744/J1Teh4Di_400x400.jpg" -- default is FiveM logo
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIÁVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local pick = {}
local actived = {}
local vehicles = {}
local bandagem = {}
local remedio = {}
local colete = {}

function vRPN.checkBurguer()
    local user_id = vRP.getUserId(source)
    if vRP.tryGetInventoryItem(user_id, "xtudo", 1) or
        vRP.tryGetInventoryItem(user_id, "donut", 1) or
        vRP.tryGetInventoryItem(user_id, "hotdog", 1) or
        vRP.tryGetInventoryItem(user_id, "taco", 1) or
        vRP.tryGetInventoryItem(user_id, "sanduiche", 1) or
        vRP.tryGetInventoryItem(user_id, "chocolate", 1) or
        vRP.tryGetInventoryItem(user_id, "batatafrita", 1) then
        return true
    else
        return false
    end
end

function vRPN.checkWater()
    local user_id = vRP.getUserId(source)
    if vRP.tryGetInventoryItem(user_id, "agua", 1) or
        vRP.tryGetInventoryItem(user_id, "cocacola", 1) or
        vRP.tryGetInventoryItem(user_id, "fanta", 1) or
        vRP.tryGetInventoryItem(user_id, "cafe", 1) then

        return true
    else
        return false
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- MOCHILA
-----------------------------------------------------------------------------------------------------------------------------------------
function vRPN.Mochila()
	local source = source
	local user_id = vRP.getUserId(source)
	local data = vRP.getUserDataTable(user_id)
	local inventario = {}
	if data and data.inventory then
		for k,v in pairs(data.inventory) do
			if vRP.itemBodyList(k) then
				table.insert(inventario,{ amount = parseInt(v.amount), name = vRP.itemNameList(k), index = vRP.itemIndexList(k), key = k, type = vRP.itemTypeList(k), peso = vRP.getItemWeight(k) })
			end
		end
		return inventario,vRP.getInventoryWeight(user_id),vRP.getInventoryMaxWeight(user_id)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SENDITEM
-----------------------------------------------------------------------------------------------------------------------------------------
function vRPN.sendItem(itemName,amount)
	local source = source
	if itemName then
		local user_id = vRP.getUserId(source)
		local nplayer = vRPclient.getNearestPlayer(source,2)
		local nuser_id = vRP.getUserId(nplayer)
		local identity = vRP.getUserIdentity(user_id)
		local identitynu = vRP.getUserIdentity(nuser_id)
		if nuser_id and vRP.itemIndexList(itemName) and item ~= vRP.itemIndexList("identidade") then
			if parseInt(amount) > 0 then
				if vRP.getInventoryWeight(nuser_id) + vRP.getItemWeight(itemName) * amount <= vRP.getInventoryMaxWeight(nuser_id) then
					if vRP.tryGetInventoryItem(user_id,itemName,amount) then
						vRP.giveInventoryItem(nuser_id,itemName,amount)
						vRPclient._playAnim(source,true,{{"mp_common","givetake1_a"}},false)
						TriggerClientEvent("Notify",source,"sucesso","Enviou <b>"..vRP.format(amount).."x "..vRP.itemNameList(itemName).."</b>.",8000)
						sendToDiscordInventario("\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[ENVIOU]: "..vRP.format(amount).." "..vRP.itemNameList(itemName).." \n[PARA O ID]: "..nuser_id.." "..identitynu.name.." "..identitynu.firstname.." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
						TriggerClientEvent("Notify",nplayer,"sucesso","Recebeu <b>"..vRP.format(amount).."x "..vRP.itemNameList(itemName).."</b>.",8000)
						vRPclient._playAnim(nplayer,true,{{"mp_common","givetake1_a"}},false)
						TriggerClientEvent('Creative:Update',source,'updateMochila')
						TriggerClientEvent('Creative:Update',nplayer,'updateMochila')
						return true
					end
				end
			else
				local data = vRP.getUserDataTable(user_id)
				for k,v in pairs(data.inventory) do
					if itemName == k then
						if vRP.getInventoryWeight(nuser_id) + vRP.getItemWeight(itemName) * parseInt(v.amount) <= vRP.getInventoryMaxWeight(nuser_id) then
							if vRP.tryGetInventoryItem(user_id,itemName,parseInt(v.amount)) then
								vRP.giveInventoryItem(nuser_id,itemName,parseInt(v.amount))
								vRPclient._playAnim(source,true,{{"mp_common","givetake1_a"}},false)
								TriggerClientEvent("Notify",source,"sucesso","Enviou <b>"..vRP.format(parseInt(v.amount)).."x "..vRP.itemNameList(itemName).."</b>.",8000)
								sendToDiscordInventario("prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[ENVIOU]: "..vRP.format(parseInt(v.amount)).." "..vRP.itemNameList(itemName).." \n[PARA O ID]: "..nuser_id.." "..identitynu.name.." "..identitynu.firstname.." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
								TriggerClientEvent("Notify",nplayer,"sucesso","Recebeu <b>"..vRP.format(parseInt(v.amount)).."x "..vRP.itemNameList(itemName).."</b>.",8000)
								vRPclient._playAnim(nplayer,true,{{"mp_common","givetake1_a"}},false)
								TriggerClientEvent('Creative:Update',source,'updateMochila')
								TriggerClientEvent('Creative:Update',nplayer,'updateMochila')
								return true
							end
						end
					end
				end
			end
		end
	end
	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DROPITEM
-----------------------------------------------------------------------------------------------------------------------------------------
function vRPN.dropItem(itemName,amount)
	local source = source
	if itemName then
		local user_id = vRP.getUserId(source)
		local identity = vRP.getUserIdentity(user_id)
		local x,y,z = vRPclient.getPosition(source)
		if parseInt(amount) > 0 and vRP.tryGetInventoryItem(user_id,itemName,amount) then
			TriggerEvent("DropSystem:create",itemName,amount,x,y,z,3600)
			vRPclient._playAnim(source,true,{{"pickup_object","pickup_low"}},false)
			sendToDiscordInventario("prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[DROPOU]: "..vRP.itemNameList(itemName).." \n[QUANTIDADE]: "..vRP.format(parseInt(amount)).." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
			TriggerClientEvent('Creative:Update',source,'updateMochila')
			return true
		else
			local data = vRP.getUserDataTable(user_id)
			for k,v in pairs(data.inventory) do
				if itemName == k then
					if vRP.tryGetInventoryItem(user_id,itemName,parseInt(v.amount)) then
						TriggerEvent("DropSystem:create",itemName,parseInt(v.amount),x,y,z,3600)
						vRPclient._playAnim(source,true,{{"pickup_object","pickup_low"}},false)
						sendToDiscordInventario("prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[DROPOU]: "..vRP.itemNameList(itemName).." \n[QUANTIDADE]: "..vRP.format(parseInt(v.amount)).." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
						TriggerClientEvent('Creative:Update',source,'updateMochila')
						return true
					end
				end
			end
		end
	end
	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- BANDAGEM
-----------------------------------------------------------------------------------------------------------------------------------------
local bandagem = {}
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		for k,v in pairs(bandagem) do
			if v > 0 then
				bandagem[k] = v - 1
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REMEDIO
-----------------------------------------------------------------------------------------------------------------------------------------
local remedio = {}
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		for k,v in pairs(remedio) do
			if v > 0 then
				remedio[k] = v - 1
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VEHITENS
-----------------------------------------------------------------------------------------------------------------------------------------
local vehItens = cfg.vehItens
local alimentos = cfg.alimentos

local inProgress = false
function vRPN.useItem(itemName, type, ramount)
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id and ramount ~= nil and parseInt(ramount) >= 0 and
        not actived[user_id] and actived[user_id] == nil then
        
        if type == "usar" and inProgress == false then

            for k, v in pairs(alimentos) do
                if itemName == v[1] then
                    if vRP.tryGetInventoryItem(user_id, itemName, 1) then
                        inProgress = true
                        
                        if v[2] == "comer" then
                            TriggerClientEvent("progress", source, 10000, "comendo")
                            vRPclient._CarregarObjeto(source,"amb@code_human_wander_eating_donut@male@idle_a","idle_c", v[3],49, 28422)
                        elseif v[2] == "beber" then
                            TriggerClientEvent("progress", source, 10000, "bebendo")
                            vRPclient._CarregarObjeto(source,"amb@world_human_drinking@beer@male@idle_a","idle_a",v[3], 49,28422)
                        end

                        
                        async(function()
                            while inProgress do
                                Citizen.Wait(1000)
                                if v[2] == "comer" then
                                    TriggerClientEvent("updateFome", source, 4)
                                elseif v[2] == "beber" then
                                    TriggerClientEvent("updateSede", source, 4)
                                end
                            end
                        end)
                        SetTimeout(10000, function()
                            vRPclient._DeletarObjeto(source)
                            inProgress = false
                        end)
                    end
                    return
                end
            end            


            if itemName == "bandagem" then
                if vRPclient.getHealth(source) > 101 and
                    vRPclient.getHealth(source) < 400 then
                    if bandagem[user_id] == 0 or not bandagem[user_id] then
                        if vRP.tryGetInventoryItem(user_id, "bandagem", 1) then
                            bandagem[user_id] = 30
                            actived[user_id] = true
                            vRPclient._CarregarObjeto(source,"amb@world_human_clipboard@male@idle_a","idle_c","v_ret_ta_firstaid",49,60309)
                            TriggerClientEvent('Creative:Update', source,
                                               'updateMochila')
                            TriggerClientEvent('cancelando', source, true)
                            TriggerClientEvent("progress", source, 10000,
                                               "bandagem")
                            SetTimeout(10000, function()
                                actived[user_id] = nil
                                TriggerClientEvent('bandagem', source)
                                vRPclient._DeletarObjeto(source)
                                TriggerClientEvent('cancelando', source, false)
                                TriggerClientEvent("Notify", source, "sucesso",
                                                   "Bandagem utilizada com sucesso.",
                                                   8000)
                                TriggerEvent('resetWarfarina')
                                TriggerEvent('resetBleeding')
                                TriggerEvent('resetDiagnostic')
                            end)
                        end
                    else
                        TriggerClientEvent("Notify", source, "importante",
                                           "Aguarde " ..
                                               vRP.getMinSecs(
                                                   parseInt(bandagem[user_id])) ..
                                               ".", 8000)
                    end
                else
                    TriggerClientEvent("Notify", source, "aviso",
                                       "Você não pode utilizar de vida cheia ou nocauteado.",
                                       8000)
                end
            elseif itemName == "remedio" then
                if vRPclient.getHealth(source) > 101 and
                    vRPclient.getHealth(source) < 400 then
                    if remedio[user_id] == 0 or not remedio[user_id] then
                        if vRP.tryGetInventoryItem(user_id, "remedio", 1) then
                            remedio[user_id] = 120
                            actived[user_id] = true
                            TriggerClientEvent('Creative:Update', source,
                                               'updateMochila')
                            TriggerClientEvent('cancelando', source, true)
                            vRPclient._CarregarObjeto(source,
                                                      "amb@world_human_drinking@beer@male@idle_a",
                                                      "idle_a",
                                                      "prop_ld_flow_bottle", 49,
                                                      28422)
                            TriggerClientEvent("progress", source, 15000,
                                               "remedio")
                            SetTimeout(15000, function()
                                actived[user_id] = nil
                                TriggerClientEvent('remedio', source)
                                TriggerClientEvent('cancelando', source, false)
                                TriggerClientEvent('cancelando', source, false)
                                vRPclient._DeletarObjeto(source)
                                TriggerClientEvent("Notify", source, "sucesso",
                                                   "Remedio utilizado com sucesso.",
                                                   8000)
                            end)
                        end
                    else
                        TriggerClientEvent("Notify", source, "importante",
                                           "Aguarde " ..
                                               vRP.getMinSecs(
                                                   parseInt(remedio[user_id])) ..
                                               ".", 8000)
                    end
                else
                    TriggerClientEvent("Notify", source, "aviso",
                                       "Você não pode utilizar de vida cheia ou nocauteado.",
                                       8000)
                end
            elseif itemName == "mochila" then
                if vRP.tryGetInventoryItem(user_id, "mochila", 1) then
                    TriggerClientEvent('Creative:Update', source,
                                       'updateMochila')
                    vRP.varyExp(user_id, "physical", "strength", 650)
                    TriggerClientEvent("Notify", source, "sucesso",
                                       "Mochila utilizada com sucesso.", 8000)
                end
            elseif itemName == "cerveja" then
                if vRP.tryGetInventoryItem(user_id, "cerveja", 1) then
                    actived[user_id] = true
                    TriggerClientEvent('Creative:Update', source,
                                       'updateMochila')
                    TriggerClientEvent('cancelando', source, true)
                    vRPclient._CarregarObjeto(source,
                                              "amb@world_human_drinking@beer@male@idle_a",
                                              "idle_a", "prop_amb_beer_bottle",
                                              49, 28422)
                    TriggerClientEvent("progress", source, 10000, "bebendo")
                    SetTimeout(10000, function()
                        actived[user_id] = nil
                        vRPclient.playScreenEffect(source, "RaceTurbo", 180)
                        vRPclient.playScreenEffect(source,
                                                   "DrugsTrevorClownsFight", 180)
                        TriggerClientEvent('cancelando', source, false)
                        vRPclient._DeletarObjeto(source)
                        TriggerClientEvent("Notify", source, "sucesso",
                                           "Cerveja utilizada com sucesso.",
                                           8000)
                    end)
                end
            elseif itemName == "tarjapreta" then
                if vRP.tryGetInventoryItem(user_id, "tarjapreta", 1) then
                    actived[user_id] = true
                    TriggerClientEvent('Creative:Update', source,
                                       'updateMochila')
                    TriggerClientEvent('cancelando', source, true)
                    vRPclient._CarregarObjeto(source,
                                              "amb@world_human_drinking@beer@male@idle_a",
                                              "idle_a", "prop_ld_flow_bottle",
                                              49, 28422)
                    TriggerClientEvent("progress", source, 10000, "bebendo")
                    SetTimeout(10000, function()
                        actived[user_id] = nil
                        vRPclient.playScreenEffect(source, "RaceTurbo", 180)
                        vRPclient.playScreenEffect(source,
                                                   "DrugsTrevorClownsFight", 180)
                        TriggerClientEvent('cancelando', source, false)
                        vRPclient._DeletarObjeto(source)
                        TriggerClientEvent("Notify", source, "sucesso",
                                           "Tarja preta utilizada com sucesso.",
                                           8000)
                    end)
                end
            elseif itemName == "dipirona" then
                if vRP.tryGetInventoryItem(user_id, "dipirona", 1) then
                    actived[user_id] = true
                    TriggerClientEvent('Creative:Update', source,
                                       'updateMochila')
                    TriggerClientEvent('cancelando', source, true)
                    vRPclient._CarregarObjeto(source,
                                              "amb@world_human_drinking@beer@male@idle_a",
                                              "idle_a", "prop_ld_flow_bottle",
                                              49, 28422)
                    TriggerClientEvent("progress", source, 10000, "bebendo")
                    SetTimeout(10000, function()
                        actived[user_id] = nil
                        vRPclient.playScreenEffect(source, "RaceTurbo", 180)
                        vRPclient.playScreenEffect(source,"DrugsTrevorClownsFight",180)
                        TriggerClientEvent('cancelando', source, false)
                        vRPclient._DeletarObjeto(source)
                        TriggerClientEvent("Notify", source, "sucesso",
                                           "Dipirona utilizada com sucesso.",
                                           8000)
                    end)
                end
            elseif itemName == "tequila" then
                if vRP.tryGetInventoryItem(user_id, "tequila", 1) then
                    actived[user_id] = true
                    TriggerClientEvent('Creative:Update', source,
                                       'updateMochila')
                    TriggerClientEvent('cancelando', source, true)
                    vRPclient._CarregarObjeto(source,
                                              "amb@world_human_drinking@beer@male@idle_a",
                                              "idle_a", "prop_amb_beer_bottle",
                                              49, 28422)
                    TriggerClientEvent("progress", source, 10000, "bebendo")
                    SetTimeout(10000, function()
                        actived[user_id] = nil
                        vRPclient.playScreenEffect(source, "RaceTurbo", 180)
                        vRPclient.playScreenEffect(source,
                                                   "DrugsTrevorClownsFight", 180)
                        TriggerClientEvent('cancelando', source, false)
                        vRPclient._DeletarObjeto(source)
                        TriggerClientEvent("Notify", source, "sucesso",
                                           "Tequila utilizada com sucesso.",
                                           8000)
                    end)
                end
            elseif itemName == "vodka" then
                if vRP.tryGetInventoryItem(user_id, "vodka", 1) then
                    actived[user_id] = true
                    TriggerClientEvent('Creative:Update', source,
                                       'updateMochila')
                    TriggerClientEvent('cancelando', source, true)
                    vRPclient._CarregarObjeto(source,
                                              "amb@world_human_drinking@beer@male@idle_a",
                                              "idle_a", "prop_amb_beer_bottle",
                                              49, 28422)
                    TriggerClientEvent("progress", source, 10000, "bebendo")
                    SetTimeout(10000, function()
                        actived[user_id] = nil
                        vRPclient.playScreenEffect(source, "RaceTurbo", 180)
                        vRPclient.playScreenEffect(source,
                                                   "DrugsTrevorClownsFight", 180)
                        TriggerClientEvent('cancelando', source, false)
                        vRPclient._DeletarObjeto(source)
                        TriggerClientEvent("Notify", source, "sucesso",
                                           "Vodka utilizada com sucesso.", 8000)
                    end)
                end
            elseif itemName == "whisky" then
                if vRP.tryGetInventoryItem(user_id, "whisky", 1) then
                    actived[user_id] = true
                    TriggerClientEvent('Creative:Update', source,
                                       'updateMochila')
                    TriggerClientEvent('cancelando', source, true)
                    vRPclient._CarregarObjeto(source,
                                              "amb@world_human_drinking@beer@male@idle_a",
                                              "idle_a", "p_whiskey_notop", 49,
                                              28422)
                    TriggerClientEvent("progress", source, 10000, "bebendo")
                    SetTimeout(10000, function()
                        actived[user_id] = nil
                        vRPclient.playScreenEffect(source, "RaceTurbo", 180)
                        vRPclient.playScreenEffect(source,
                                                   "DrugsTrevorClownsFight", 180)
                        TriggerClientEvent('cancelando', source, false)
                        vRPclient._DeletarObjeto(source)
                        TriggerClientEvent("Notify", source, "sucesso",
                                           "Whisky utilizado com sucesso.", 8000)
                    end)
                end
            elseif itemName == "conhaque" then
                if vRP.tryGetInventoryItem(user_id, "conhaque", 1) then
                    actived[user_id] = true
                    TriggerClientEvent('Creative:Update', source,
                                       'updateMochila')
                    TriggerClientEvent('cancelando', source, true)
                    vRPclient._CarregarObjeto(source,
                                              "amb@world_human_drinking@beer@male@idle_a",
                                              "idle_a", "prop_amb_beer_bottle",
                                              49, 28422)
                    TriggerClientEvent("progress", source, 10000, "bebendo")
                    SetTimeout(10000, function()
                        actived[user_id] = nil
                        vRPclient.playScreenEffect(source, "RaceTurbo", 180)
                        vRPclient.playScreenEffect(source,
                                                   "DrugsTrevorClownsFight", 180)
                        TriggerClientEvent('cancelando', source, false)
                        vRPclient._DeletarObjeto(source)
                        TriggerClientEvent("Notify", source, "sucesso",
                                           "Conhaque utilizado com sucesso.",
                                           8000)
                    end)
                end
            elseif itemName == "absinto" then
                if vRP.tryGetInventoryItem(user_id, "absinto", 1) then
                    actived[user_id] = true
                    TriggerClientEvent('Creative:Update', source,
                                       'updateMochila')
                    TriggerClientEvent('cancelando', source, true)
                    vRPclient._CarregarObjeto(source,
                                              "amb@world_human_drinking@beer@male@idle_a",
                                              "idle_a", "prop_amb_beer_bottle",
                                              49, 28422)
                    TriggerClientEvent("progress", source, 10000, "bebendo")
                    SetTimeout(10000, function()
                        actived[user_id] = nil
                        vRPclient.playScreenEffect(source, "RaceTurbo", 180)
                        vRPclient.playScreenEffect(source,
                                                   "DrugsTrevorClownsFight", 180)
                        TriggerClientEvent('cancelando', source, false)
                        vRPclient._DeletarObjeto(source)
                        TriggerClientEvent("Notify", source, "sucesso",
                                           "Absinto utilizado com sucesso.",
                                           8000)
                    end)
                end
            elseif itemName == "moonshine" then
                if vRP.tryGetInventoryItem(user_id, "moonshine", 1) then
                    actived[user_id] = true
                    TriggerClientEvent('Creative:Update', source,
                                       'updateMochila')
                    TriggerClientEvent('cancelando', source, true)
                    vRPclient._CarregarObjeto(source,
                                              "amb@world_human_drinking@beer@male@idle_a",
                                              "idle_a", "prop_amb_beer_bottle",
                                              49, 28422)
                    TriggerClientEvent("progress", source, 10000, "bebendo")
                    SetTimeout(10000, function()
                        actived[user_id] = nil
                        vRPclient.playScreenEffect(source, "RaceTurbo", 180)
                        vRPclient.playScreenEffect(source,
                                                   "DrugsTrevorClownsFight", 380)
                        TriggerClientEvent('cancelando', source, false)
                        vRPclient._DeletarObjeto(source)
                        TriggerClientEvent("Notify", source, "sucesso",
                                           "Moonshine utilizado com sucesso.",
                                           8000)
                    end)
                end
            elseif itemName == "identidade" then
                local nplayer = vRPclient.getNearestPlayer(source, 2)
                if nplayer then
                    local identity = vRP.getUserIdentity(user_id)
                    if identity then
                        TriggerClientEvent("Identity2", nplayer, identity.name,
                                           identity.firstname, identity.user_id,
                                           identity.registration)
                    end
                end
            elseif itemName == "maconha" then
                if vRP.tryGetInventoryItem(user_id, "maconha", 1) then
                    actived[user_id] = true
                    TriggerClientEvent('Creative:Update', source,
                                       'updateMochila')
                    vRPclient._playAnim(source, true, {
                        {"mp_player_int_uppersmoke", "mp_player_int_smoke"}
                    }, true)
                    TriggerClientEvent('cancelando', source, true)
                    TriggerClientEvent("progress", source, 10000, "fumando")
                    SetTimeout(10000, function()
                        actived[user_id] = nil
                        vRPclient._stopAnim(source, false)
                        TriggerClientEvent('energeticos', source, true)
                        TriggerClientEvent('cancelando', source, false)
                        vRPclient.playScreenEffect(source, "RaceTurbo", 180)
                        vRPclient.playScreenEffect(source,
                                                   "DrugsTrevorClownsFight", 180)
                        TriggerClientEvent("Notify", source, "sucesso",
                                           "Maconha utilizada com sucesso.",
                                           8000)
                    end)
                    SetTimeout(180000, function()
                        TriggerClientEvent('energeticos', source, false)
                        TriggerClientEvent("Notify", source, "aviso",
                                           "O efeito da maconha passou e o coração voltou a bater normalmente.",
                                           8000)
                    end)
                end
            elseif itemName == "cocaina" then
                if vRP.tryGetInventoryItem(user_id, "cocaina", 1) then
                    actived[user_id] = true
                    TriggerClientEvent('Creative:Update', source,
                                       'updateMochila')
                    vRPclient._playAnim(source, true, {
                        {"mp_player_int_uppersmoke", "mp_player_int_smoke"}
                    }, true)
                    TriggerClientEvent('cancelando', source, true)
                    TriggerClientEvent("progress", source, 10000, "cheirando")
                    SetTimeout(10000, function()
                        actived[user_id] = nil
                        vRPclient._stopAnim(source, false)
                        TriggerClientEvent('energeticos', source, true)
                        TriggerClientEvent('cancelando', source, false)
                        vRPclient.playScreenEffect(source, "RaceTurbo", 180)
                        vRPclient.playScreenEffect(source,
                                                   "DrugsTrevorClownsFight", 180)
                        TriggerClientEvent("Notify", source, "sucesso",
                                           "Cocaína utilizada com sucesso.",
                                           8000)
                    end)
                    SetTimeout(180000, function()
                        TriggerClientEvent('energeticos', source, false)
                        TriggerClientEvent("Notify", source, "aviso",
                                           "O efeito da cocaína passou e o coração voltou a bater normalmente.",
                                           8000)
                    end)
                end
            elseif itemName == "metanfetamina" then
                if vRP.tryGetInventoryItem(user_id, "metanfetamina", 1) then
                    actived[user_id] = true
                    TriggerClientEvent('Creative:Update', source,
                                       'updateMochila')
                    vRPclient._playAnim(source, true, {
                        {"mp_player_int_uppersmoke", "mp_player_int_smoke"}
                    }, true)
                    TriggerClientEvent('cancelando', source, true)
                    TriggerClientEvent("progress", source, 10000, "usando")
                    SetTimeout(10000, function()
                        actived[user_id] = nil
                        vRPclient._stopAnim(source, false)
                        TriggerClientEvent('energeticos', source, true)
                        TriggerClientEvent('cancelando', source, false)
                        vRPclient.playScreenEffect(source, "RaceTurbo", 180)
                        vRPclient.playScreenEffect(source,
                                                   "DrugsTrevorClownsFight", 180)
                        TriggerClientEvent("Notify", source, "sucesso",
                                           "Metanfetamina utilizada com sucesso.",
                                           8000)
                    end)
                    SetTimeout(180000, function()
                        TriggerClientEvent('energeticos', source, false)
                        TriggerClientEvent("Notify", source, "aviso",
                                           "O efeito da metanfetamina passou e o coração voltou a bater normalmente.",
                                           8000)
                    end)
                end
            elseif itemName == "capuz" then
                if vRP.getInventoryItemAmount(user_id, "capuz") >= 1 then
                    local nplayer = vRPclient.getNearestPlayer(source, 2)
                    if nplayer then
                        vRPclient.setCapuz(nplayer)
                        vRP.closeMenu(nplayer)
                        TriggerClientEvent("Notify", source, "sucesso",
                                           "Capuz utilizado com sucesso.", 8000)
                    end
                end
            elseif itemName == "premium" then
                if not vRP.getPremium(user_id) then
                    if vRP.tryGetInventoryItem(user_id, "premium", 1) then
                        TriggerClientEvent('Creative:Update', source,
                                           'updateMochila')
                        vRP.execute("creative/set_premium", {
                            user_id = parseInt(user_id),
                            premium = parseInt(os.time())
                        })
                        TriggerClientEvent("Notify", source, "sucesso",
                                           "Você acaba de ativar <b>30 dias</b> de benefícios <b>Premium</b>.",
                                           8000)

                        local resultado =
                            vRP.query("creative/get_priority",
                                      {user_id = parseInt(user_id)})
                        if resultado[1] == nil then
                            for k, v in ipairs(GetPlayerIdentifiers(source)) do
                                if string.sub(v, 1, 5) == "steam" then
                                    vRP.execute("creative/set_priority", {
                                        user_id = parseInt(user_id),
                                        steam = v,
                                        priority = 50
                                    })
                                end
                            end
                        end
                    end
                else
                    TriggerClientEvent("Notify", source, "importante",
                                       "Você possui os benefícios <b>Premium</b> ativo no momento.",
                                       8000)
                end
            elseif itemName == "goldbar" then
                if vRP.tryGetInventoryItem(user_id, "goldbar", 1) then
                    TriggerClientEvent('Creative:Update', source,
                                       'updateMochila')
                    vRP.giveMoney(user_id, 6000)
                end
            elseif itemName == "energetico" then
                if vRP.tryGetInventoryItem(user_id, "energetico", 1) then
                    actived[user_id] = true
                    TriggerClientEvent('Creative:Update', source,
                                       'updateMochila')
                    TriggerClientEvent('cancelando', source, true)
                    vRPclient._CarregarObjeto(source,
                                              "amb@world_human_drinking@beer@male@idle_a",
                                              "idle_a", "prop_energy_drink", 49,
                                              28422)
                    TriggerClientEvent("progress", source, 10000, "bebendo")
                    SetTimeout(10000, function()
                        actived[user_id] = nil
                        TriggerClientEvent('energeticos', source, true)
                        TriggerClientEvent('cancelando', source, false)
                        vRPclient._DeletarObjeto(source)
                        TriggerClientEvent("Notify", source, "sucesso",
                                           "Energético utilizado com sucesso.",
                                           8000)
                    end)
                    SetTimeout(60000, function()
                        TriggerClientEvent('energeticos', source, false)
                        TriggerClientEvent("Notify", source, "aviso",
                                           "O efeito do energético passou e o coração voltou a bater normalmente.",
                                           8000)
                    end)
                end
            elseif itemName == "lockpick" then
                vRP.tryGetInventoryItem(user_id,"lockpick",1) 
                if not vRPclient.isInVehicle(source) then
                    local vehicle, vnetid, placa, vname, lock, banned, trunk,
                          model, street = vRPclient.vehList(source, 7)

                    TriggerClientEvent('Creative:AlarmCar', source, vehicle, true)
                    

                    if vehicle then
                        actived[user_id] = true
                        if vRP.hasPermission(user_id, "admin2.permissao") then
                            actived[user_id] = nil
                            TriggerEvent("setPlateEveryone", placa)
                            vGARAGE.vehicleClientLock(-1, vnetid, lock)
                            return
                        end

                        TriggerClientEvent('cancelando', source, true)
                        vRPclient._playAnim(source, false, {
                            {
                                "amb@prop_human_parking_meter@female@idle_a",
                                "idle_a_female"
                            }
                        }, true)
                        TriggerClientEvent("progress", source, 30000, "roubando")
                        SetTimeout(30000, function()
                            actived[user_id] = nil
                            TriggerClientEvent('cancelando', source, false)
                            vRPclient._stopAnim(source, false)

                            if math.random(100) >= 50 then
                                TriggerEvent("setPlateEveryone", placa)
                                vGARAGE.vehicleClientLock(-1, vnetid, lock)
                                TriggerClientEvent("vrp_sound:source", source,
                                                   'lock', 0.1)
                            else
                                TriggerClientEvent("Notify", source, "negado",
                                                   "Roubo do veículo falhou e as autoridades foram acionadas.",
                                                   8000)

                                chamarPolicia(source, street, model, placa)

                            end
                        end)
                    end
                else
                    local value, vnetid, placa, model, street =
                        vRPclient.getSeatVehicle(source)

                    if value ~= nil then
                        local placa_user_id = vRP.getUserByRegistration(placa)
                        if not placa_user_id then
                            actived[user_id] = true
                            if not vehicles[vnetid .. "-" .. value] or
                                vehicles[vnetid .. "-" .. value] == nil then
                                vehicles[vnetid .. "-" .. value] = true
                                TriggerClientEvent("cancelando", source, true)
                                vGARAGE.startAnimHotwired(source)

                                if value == 1 then
                                    TriggerClientEvent("progress", source,
                                                       15000,
                                                       "vasculhando porta-luvas")
                                elseif value == 2 then
                                    TriggerClientEvent("progress", source,
                                                       15000,
                                                       "vasculhando banco esquerdo")
                                elseif value == 3 then
                                    TriggerClientEvent("progress", source,
                                                       15000,
                                                       "vasculhando banco direito")
                                end

                                Citizen.Wait(15500)
                                if math.random(100) >= 70 then
                                    local rand = math.random(#vehItens)
                                    if vRP.getInventoryWeight(user_id) +
                                        vRP.getItemWeight(vehItens[rand][1]) *
                                        vehItens[rand][2] <=
                                        vRP.getInventoryMaxWeight(user_id) then
                                        vRP.giveInventoryItem(user_id,
                                                              vehItens[rand][1],
                                                              vehItens[rand][2])
                                        TriggerClientEvent("Notify", source,
                                                           "sucesso",
                                                           "Você encontrou <b>" ..
                                                               vehItens[rand][2] ..
                                                               "x " ..
                                                               vRP.itemNameList(
                                                                   vehItens[rand][1]) ..
                                                               "</b>.", 8000)
                                    else
                                        TriggerClientEvent("Notify", source,
                                                           "negado",
                                                           "<b>Mochila</b> cheia.",
                                                           8000)
                                    end
                                else
                                    TriggerClientEvent("Notify", source,
                                                       "importante",
                                                       "Compartimento vazio.",
                                                       8000)
                                end

                                if value == 1 then
                                    TriggerClientEvent("progress", source,
                                                       15000,
                                                       "vasculhando porta direita")
                                elseif value == 2 then
                                    TriggerClientEvent("progress", source,
                                                       15000,
                                                       "vasculhando porta esquerda")
                                elseif value == 3 then
                                    TriggerClientEvent("progress", source,
                                                       15000,
                                                       "vasculhando porta direita")
                                end

                                Citizen.Wait(15500)
                                if math.random(100) >= 70 then
                                    local rand = math.random(#vehItens)
                                    if vRP.getInventoryWeight(user_id) +
                                        vRP.getItemWeight(vehItens[rand][1]) *
                                        vehItens[rand][2] <=
                                        vRP.getInventoryMaxWeight(user_id) then
                                        vRP.giveInventoryItem(user_id,
                                                              vehItens[rand][1],
                                                              vehItens[rand][2])
                                        TriggerClientEvent("Notify", source,
                                                           "sucesso",
                                                           "Você encontrou <b>" ..
                                                               vehItens[rand][2] ..
                                                               "x " ..
                                                               vRP.itemNameList(
                                                                   vehItens[rand][1]) ..
                                                               "</b>.", 8000)
                                    else
                                        TriggerClientEvent("Notify", source,
                                                           "negado",
                                                           "<b>Mochila</b> cheia.",
                                                           8000)
                                    end
                                else
                                    TriggerClientEvent("Notify", source,
                                                       "importante",
                                                       "Compartimento vazio.",
                                                       8000)
                                end

                                vGARAGE.stopAnimHotwired(source, veh, false)
                                TriggerClientEvent("cancelando", source, false)

                                if math.random(100) >= 50 then
                                    chamarPolicia(source, street, model, placa)
                                end
                            end
                            actived[user_id] = nil
                        end
                    else
                        local veh, placa, model, street =
                            vRPclient.getVehplate(source)
                        if veh then
                            actived[user_id] = true
                            TriggerClientEvent("cancelando", source, true)
                            vGARAGE.startAnimHotwired(source)
                            TriggerClientEvent("progress", source, 10000,
                                               "retirando o painel")
                            Citizen.Wait(10500)
                            TriggerClientEvent("progress", source, 10000,
                                               "puxando os fios")
                            Citizen.Wait(10500)
                            TriggerClientEvent("progress", source, 10000,
                                               "desencapando fios")
                            Citizen.Wait(10500)
                            TriggerClientEvent("progress", source, 10000,
                                               "ligação direta")
                            Citizen.Wait(10500)
                            actived[user_id] = nil
                            vGARAGE.stopAnimHotwired(source, veh, true)
                            TriggerEvent("setPlateEveryone", placa)
                            TriggerClientEvent("cancelando", source, false)

                            if math.random(100) >= 50 then
                                chamarPolicia(source, street, model, placa)
                            end
                        end
                    end
                end
            elseif itemName == "masterpick" then
                if not vRPclient.isInVehicle(source) then
                    local vehicle, vnetid, placa, vname, lock, banned, trunk,
                          model, street = vRPclient.vehList(source, 7)
                    if vehicle then
                        actived[user_id] = true
                        if vRP.hasPermission(user_id, "admin2.permissao") then
                            actived[user_id] = nil
                            TriggerEvent("setPlateEveryone", placa)
                            vGARAGE.vehicleClientLock(-1, vnetid, lock)
                            return
                        end

                        TriggerClientEvent('cancelando', source, true)
                        vRPclient._playAnim(source, false, {
                            {
                                "amb@prop_human_parking_meter@female@idle_a",
                                "idle_a_female"
                            }
                        }, true)
                        TriggerClientEvent("progress", source, 60000, "roubando")
                        SetTimeout(60000, function()
                            actived[user_id] = nil
                            TriggerClientEvent('cancelando', source, false)
                            vRPclient._stopAnim(source, false)

                            TriggerEvent("setPlateEveryone", placa)
                            vGARAGE.vehicleClientLock(-1, vnetid, lock)
                            TriggerClientEvent("vrp_sound:source", source,
                                               'lock', 0.1)

                            chamarPolicia(source, street, model, placa)
                        end)
                    end
                else
                    local value, vnetid, placa, model, street =
                        vRPclient.getSeatVehicle(source)
                    if value ~= nil then
                        local placa_user_id = vRP.getUserByRegistration(placa)
                        if not placa_user_id then
                            actived[user_id] = true
                            if not vehicles[vnetid .. "-" .. value] or
                                vehicles[vnetid .. "-" .. value] == nil then
                                vehicles[vnetid .. "-" .. value] = true
                                TriggerClientEvent("cancelando", source, true)
                                vGARAGE.startAnimHotwired(source)

                                if value == 1 then
                                    TriggerClientEvent("progress", source,
                                                       12000,
                                                       "vasculhando porta-luvas")
                                elseif value == 2 then
                                    TriggerClientEvent("progress", source,
                                                       12000,
                                                       "vasculhando banco esquerdo")
                                elseif value == 3 then
                                    TriggerClientEvent("progress", source,
                                                       12000,
                                                       "vasculhando banco direito")
                                end

                                Citizen.Wait(12500)
                                if math.random(100) >= 50 then
                                    local rand = math.random(#vehItens)
                                    if vRP.getInventoryWeight(user_id) +
                                        vRP.getItemWeight(vehItens[rand][1]) *
                                        vehItens[rand][2] <=
                                        vRP.getInventoryMaxWeight(user_id) then
                                        vRP.giveInventoryItem(user_id,
                                                              vehItens[rand][1],
                                                              vehItens[rand][2])
                                        TriggerClientEvent("Notify", source,
                                                           "sucesso",
                                                           "Você encontrou <b>" ..
                                                               vehItens[rand][2] ..
                                                               "x " ..
                                                               vRP.itemNameList(
                                                                   vehItens[rand][1]) ..
                                                               "</b>.", 8000)
                                    else
                                        TriggerClientEvent("Notify", source,
                                                           "negado",
                                                           "<b>Mochila</b> cheia.",
                                                           8000)
                                    end
                                else
                                    TriggerClientEvent("Notify", source,
                                                       "importante",
                                                       "Compartimento vazio.",
                                                       8000)
                                end

                                if value == 1 then
                                    TriggerClientEvent("progress", source,
                                                       12000,
                                                       "vasculhando porta direita")
                                elseif value == 2 then
                                    TriggerClientEvent("progress", source,
                                                       12000,
                                                       "vasculhando porta esquerda")
                                elseif value == 3 then
                                    TriggerClientEvent("progress", source,
                                                       12000,
                                                       "vasculhando porta direita")
                                end

                                Citizen.Wait(12500)
                                if math.random(100) >= 50 then
                                    local rand = math.random(#vehItens)
                                    if vRP.getInventoryWeight(user_id) +
                                        vRP.getItemWeight(vehItens[rand][1]) *
                                        vehItens[rand][2] <=
                                        vRP.getInventoryMaxWeight(user_id) then
                                        vRP.giveInventoryItem(user_id,
                                                              vehItens[rand][1],
                                                              vehItens[rand][2])
                                        TriggerClientEvent("Notify", source,
                                                           "sucesso",
                                                           "Você encontrou <b>" ..
                                                               vehItens[rand][2] ..
                                                               "x " ..
                                                               vRP.itemNameList(
                                                                   vehItens[rand][1]) ..
                                                               "</b>.", 8000)
                                    else
                                        TriggerClientEvent("Notify", source,
                                                           "negado",
                                                           "<b>Mochila</b> cheia.",
                                                           8000)
                                    end
                                else
                                    TriggerClientEvent("Notify", source,
                                                       "importante",
                                                       "Compartimento vazio.",
                                                       8000)
                                end

                                vGARAGE.stopAnimHotwired(source, veh, false)
                                TriggerClientEvent("cancelando", source, false)

                                if math.random(100) >= 50 then
                                    chamarPolicia(source, street, model, placa)
                                end
                            end
                            actived[user_id] = nil
                        end
                    else
                        local veh, placa, model, street =
                            vRPclient.getVehplate(source)
                        if veh then
                            actived[user_id] = true
                            TriggerClientEvent("cancelando", source, true)
                            vGARAGE.startAnimHotwired(source)
                            TriggerClientEvent("progress", source, 8000,
                                               "retirando o painel")
                            Citizen.Wait(8500)
                            TriggerClientEvent("progress", source, 8000,
                                               "puxando os fios")
                            Citizen.Wait(8500)
                            TriggerClientEvent("progress", source, 8000,
                                               "desencapando fios")
                            Citizen.Wait(8500)
                            TriggerClientEvent("progress", source, 8000,
                                               "ligação direta")
                            Citizen.Wait(8500)
                            actived[user_id] = nil
                            vGARAGE.stopAnimHotwired(source, veh, true)
                            TriggerEvent("setPlateEveryone", placa)
                            TriggerClientEvent("cancelando", source, false)

                            chamarPolicia(source, street, model, placa)
                        end
                    end
                end
            elseif itemName == "kitreparos" then
                if not vRPclient.isInVehicle(source) then
                    local vehicle = vRPclient.getNearestVehicle(source, 7)
                    if vehicle then
                        if vRP.hasPermission(user_id, "mecanico.permissao") then
                            actived[user_id] = true
                            TriggerClientEvent('cancelando', source, true)
                            vRPclient._playAnim(source, false, {
                                {"mini@repair", "fixing_a_player"}
                            }, true)
                            TriggerClientEvent("progress", source, 30000,
                                               "reparando veículo")
                            SetTimeout(30000, function()
                                actived[user_id] = nil
                                TriggerClientEvent('cancelando', source, false)
                                TriggerClientEvent('reparar', source, vehicle)
                                vRPclient._stopAnim(source, false)
                            end)
                        else
                            if vRP.tryGetInventoryItem(user_id, "kitreparos", 1) then
                                actived[user_id] = true
                                TriggerClientEvent('Creative:Update', source,
                                                   'updateMochila')
                                TriggerClientEvent('cancelando', source, true)
                                vRPclient._playAnim(source, false, {
                                    {"mini@repair", "fixing_a_player"}
                                }, true)
                                TriggerClientEvent("progress", source, 30000,
                                                   "reparando veículo")
                                SetTimeout(30000, function()
                                    actived[user_id] = nil
                                    TriggerClientEvent('cancelando', source,
                                                       false)
                                    TriggerClientEvent('reparar', source,
                                                       vehicle)
                                    vRPclient._stopAnim(source, false)
                                end)
                            end
                        end
                    end
                end
            elseif itemName == "notebook" then
                if vRPclient.isInVehicle(source) then
                    local vehicle, vnetid, placa = vRPclient.vehList(source, 7)
                    if vehicle then
                        local placa_user_id = vRP.getUserByRegistration(placa)
                        if not placa_user_id then
                            if vRP.tryGetInventoryItem(user_id, "notebook", 1) then
                                TriggerClientEvent('vehtuning', source, vehicle)
                                TriggerClientEvent('Creative:Update', source,
                                                   'updateMochila')
                            end
                        end
                    end
                end
            elseif itemName == "colete" then
                if colete[user_id] == 0 or not colete[user_id] then
                    if vRP.tryGetInventoryItem(user_id, "colete", 1) then
                        colete[user_id] = 600
                        vRPclient.setArmour(source, 200)
                        TriggerClientEvent('Creative:Update', source,
                                           'updateMochila')
                    end
                else
                    TriggerClientEvent("Notify", source, "importante",
                                       "Aguarde " ..
                                           vRP.getMinSecs(
                                               parseInt(colete[user_id])) .. ".",
                                       8000)
                end
            elseif itemName == "nightvision" then
                TriggerClientEvent("nightVision", source)
            elseif itemName == "pneus" then
                if not vRPclient.isInVehicle(source) then
                    local vehicle = vRPclient.getNearestVehicle(source, 7)
                    if vehicle then
                        if vRP.hasPermission(user_id, "mecanico.permissao") then
                            actived[user_id] = true
                            TriggerClientEvent('cancelando', source, true)
                            vRPclient._playAnim(source, false, {
                                {"mini@repair", "fixing_a_player"}
                            }, true)
                            TriggerClientEvent("progress", source, 30000,
                                               "reparando pneus")
                            SetTimeout(30000, function()
                                actived[user_id] = nil
                                TriggerClientEvent('cancelando', source, false)
                                TriggerClientEvent('repararpneus', source,
                                                   vehicle)
                                vRPclient._stopAnim(source, false)
                            end)
                        else
                            if vRP.tryGetInventoryItem(user_id, "pneus", 1) then
                                actived[user_id] = true
                                TriggerClientEvent('Creative:Update', source,
                                                   'updateMochila')
                                TriggerClientEvent('cancelando', source, true)
                                vRPclient._playAnim(source, false, {
                                    {"mini@repair", "fixing_a_player"}
                                }, true)
                                TriggerClientEvent("progress", source, 30000,
                                                   "reparando pneus")
                                SetTimeout(30000, function()
                                    actived[user_id] = nil
                                    TriggerClientEvent('cancelando', source,
                                                       false)
                                    TriggerClientEvent('repararpneus', source,
                                                       vehicle)
                                    vRPclient._stopAnim(source, false)
                                end)
                            end
                        end
                    end
                end
            elseif itemName == "militec" then
                if not vRPclient.isInVehicle(source) then
                    local vehicle = vRPclient.getNearestVehicle(source, 7)
                    if vehicle then
                        if vRP.hasPermission(user_id, "mecanico.permissao") then
                            actived[user_id] = true
                            TriggerClientEvent('cancelando', source, true)
                            vRPclient._playAnim(source, false, {
                                {"mini@repair", "fixing_a_player"}
                            }, true)
                            TriggerClientEvent("progress", source, 30000,
                                               "reparando motor")
                            SetTimeout(30000, function()
                                actived[user_id] = nil
                                TriggerClientEvent('cancelando', source, false)
                                TriggerClientEvent('repararmotor', source,
                                                   vehicle)
                                vRPclient._stopAnim(source, false)
                            end)
                        else
                            if vRP.tryGetInventoryItem(user_id, "militec", 1) then
                                actived[user_id] = true
                                TriggerClientEvent('Creative:Update', source,
                                                   'updateMochila')
                                TriggerClientEvent('cancelando', source, true)
                                vRPclient._playAnim(source, false, {
                                    {"mini@repair", "fixing_a_player"}
                                }, true)
                                TriggerClientEvent("progress", source, 30000,
                                                   "reparando motor")
                                SetTimeout(30000, function()
                                    actived[user_id] = nil
                                    TriggerClientEvent('cancelando', source,
                                                       false)
                                    TriggerClientEvent('repararmotor', source,
                                                       vehicle)
                                    vRPclient._stopAnim(source, false)
                                end)
                            end
                        end
                    end
                end
            elseif itemName == "placa" then
                if vRPclient.isInVehicle(source) then
                    if vRP.tryGetInventoryItem(user_id, "placa", 1) then
                        local placa = vRP.generatePlate()
                        TriggerClientEvent("cloneplates", source, placa)
                        TriggerClientEvent('Creative:Update', source,
                                           'updateMochila')

                        local veh, placa, model, street =
                            vRPclient.getVehplate(source)
                        if veh then
                            actived[user_id] = true
                            TriggerClientEvent("cancelando", source, true)
                            TriggerClientEvent("progress", source, 3000,
                                               "modificando placa")
                            Citizen.Wait(3500)
                            actived[user_id] = nil
                            TriggerClientEvent("setPlateEveryone", placa)
                            TriggerClientEvent("cancelando", source, false)
                        end
                    end
                end
            elseif itemName == "morfina" then
                local paramedico = vRP.getUsersByPermission("polpar.permissao")
                if parseInt(#paramedico) < 1 then
                    local nplayer = vRPclient.getNearestPlayer(source, 2)
                    if nplayer then
                        if vRPclient.isComa(nplayer) then
                            if vRP.tryGetInventoryItem(user_id, "morfina", 1) then
                                TriggerClientEvent('cancelando', source, true)
                                TriggerClientEvent('Creative:Update', source,
                                                   'updateMochila')
                                vRPclient._playAnim(source, false, {
                                    {
                                        "amb@medic@standing@tendtodead@base",
                                        "base"
                                    },
                                    {"mini@cpr@char_a@cpr_str", "cpr_pumpchest"}
                                }, true)
                                TriggerClientEvent("progress", source, 30000,
                                                   "reanimando")
                                SetTimeout(30000, function()
                                    vRPclient.networkRessurection(nplayer)
                                    vRPclient._stopAnim(source, false)
                                    TriggerClientEvent('cancelando', source,
                                                       false)
                                end)
                            end
                        else
                            TriggerClientEvent("Notify", source, "importante",
                                               "A pessoa precisa estar em coma para prosseguir.",
                                               8000)
                        end
                    end
                end
                -- [Evento]--
            elseif itemName == "balademorango" then
                local source = source
                local user_id = vRP.getUserId(source)
                local pagamento = math.random(2000, 3500)
                if user_id then
                    if math.random(100) >= 50 then
                        if vRP.tryGetInventoryItem(user_id, "balademorango", 1) then
                            TriggerClientEvent('cancelando', source, true)
                            TriggerClientEvent('Creative:Update', source,
                                               'updateMochila')
                            TriggerClientEvent("progress", source, 1000,
                                               "comendo")
                            SetTimeout(1000, function()
                                TriggerClientEvent('cancelando', source, false)
                                vRP.giveMoney(user_id, pagamento)
                                TriggerClientEvent("Notify", source, "sucesso",
                                                   "Você recebeu <b>$" ..
                                                       pagamento ..
                                                       " dólares.</b>")
                            end)
                        end
                    else
                        vRP.tryGetInventoryItem(user_id, "balademorango", 1)
                        TriggerClientEvent('cancelando', source, true)
                        TriggerClientEvent('Creative:Update', source,
                                           'updateMochila')
                        TriggerClientEvent("Notify", source, "importante",
                                           "Ganhou nada comendo <b>Bala de Morango</b>.",
                                           8000)
                        TriggerClientEvent('cancelando', source, false)
                    end
                end
            elseif itemName == "presente" then
                local source = source
                local user_id = vRP.getUserId(source)
                local pagamento = math.random(2000, 3500)
                if user_id then
                    if math.random(100) >= 50 then
                        if vRP.tryGetInventoryItem(user_id, "presente", 1) then
                            TriggerClientEvent('cancelando', source, true)
                            TriggerClientEvent('Creative:Update', source,
                                               'updateMochila')
                            TriggerClientEvent("progress", source, 1000,
                                               "comendo")
                            SetTimeout(1000, function()
                                TriggerClientEvent('cancelando', source, false)
                                vRP.giveMoney(user_id, pagamento)
                                TriggerClientEvent("Notify", source, "sucesso",
                                                   "Você recebeu <b>$" ..
                                                       pagamento ..
                                                       " dólares.</b>")
                            end)
                        end
                    else
                        vRP.tryGetInventoryItem(user_id, "presente", 1)
                        TriggerClientEvent('cancelando', source, true)
                        TriggerClientEvent('Creative:Update', source,
                                           'updateMochila')
                        TriggerClientEvent("Notify", source, "importante",
                                           "Ganhou nada comendo <b>Bala de Morango</b>.",
                                           8000)
                        TriggerClientEvent('cancelando', source, false)
                    end
                end
            elseif itemName == "bengaladoce" then
                local source = source
                local user_id = vRP.getUserId(source)
                local pagamento = math.random(2000, 3500)
                if user_id then
                    if math.random(100) >= 50 then
                        if vRP.tryGetInventoryItem(user_id, "bengaladoce", 1) then
                            TriggerClientEvent('cancelando', source, true)
                            TriggerClientEvent('Creative:Update', source,
                                               'updateMochila')
                            TriggerClientEvent("progress", source, 1000,
                                               "comendo")
                            SetTimeout(1000, function()
                                TriggerClientEvent('cancelando', source, false)
                                vRP.giveMoney(user_id, pagamento)
                                TriggerClientEvent("Notify", source, "sucesso",
                                                   "Você recebeu <b>$" ..
                                                       pagamento ..
                                                       " dólares.</b>")
                            end)
                        end
                    else
                        vRP.tryGetInventoryItem(user_id, "bengaladoce", 1)
                        TriggerClientEvent('cancelando', source, true)
                        TriggerClientEvent('Creative:Update', source,
                                           'updateMochila')
                        TriggerClientEvent("Notify", source, "importante",
                                           "Ganhou nada comendo <b>Bengala Doce</b>.",
                                           8000)
                        TriggerClientEvent('cancelando', source, false)
                    end
                end
            elseif itemName == "donut" then
                local source = source
                local user_id = vRP.getUserId(source)
                local pagamento = math.random(0, 0)
                if user_id then
                    if math.random(100) >= 10 then
                        if vRP.tryGetInventoryItem(user_id, "donut", 1) then
                            TriggerClientEvent('cancelando', source, true)
                            vRPclient._CarregarObjeto(source,
                                                      "amb@code_human_wander_eating_donut@male@idle_a",
                                                      "idle_c",
                                                      "prop_amb_donut", 49,
                                                      28422)
                            TriggerClientEvent('Creative:Update', source,
                                               'updateMochila')
                            TriggerClientEvent("progress", source, 10000,
                                               "Comendo")
                            SetTimeout(10000, function()
                                actived[user_id] = nil
                                vRPclient._stopAnim(source, false)
                                TriggerClientEvent('cancelando', source, false)

                                TriggerClientEvent('cancelando', source, false)
                                vRP.giveMoney(user_id, pagamento)
                                TriggerClientEvent("Notify", source, "sucesso",
                                                   "Você acabou de comer um <b>Donut</b>")
                            end)
                        end
                    else
                        vRP.tryGetInventoryItem(user_id, "donut", 1)
                        TriggerClientEvent('cancelando', source, true)
                        TriggerClientEvent('Creative:Update', source,
                                           'updateMochila')
                        TriggerClientEvent("Notify", source, "importante",
                                           "Parece que vocé não gostou muito do <b>Donut</b>.",
                                           8000)
                        TriggerClientEvent('cancelando', source, false)
                    end
                end
            elseif itemName == "biscoito" then
                local source = source
                local user_id = vRP.getUserId(source)
                local pagamento = math.random(3000, 4000)
                if user_id then
                    if math.random(100) >= 50 then
                        if vRP.tryGetInventoryItem(user_id, "biscoito", 1) then
                            TriggerClientEvent('cancelando', source, true)
                            TriggerClientEvent('Creative:Update', source,
                                               'updateMochila')
                            TriggerClientEvent("progress", source, 1000,
                                               "comendo")
                            SetTimeout(1000, function()
                                TriggerClientEvent('cancelando', source, false)
                                vRP.giveMoney(user_id, pagamento)
                                TriggerClientEvent("Notify", source, "sucesso",
                                                   "Você recebeu <b>$" ..
                                                       pagamento ..
                                                       " dólares.</b>")
                            end)
                        end
                    else
                        vRP.tryGetInventoryItem(user_id, "biscoito", 1)
                        TriggerClientEvent('cancelando', source, true)
                        TriggerClientEvent('Creative:Update', source,
                                           'updateMochila')
                        TriggerClientEvent("Notify", source, "importante",
                                           "Ganhou nada comendo <b>Biscoito Doce</b>.",
                                           8000)
                        TriggerClientEvent('cancelando', source, false)
                    end
                end
            elseif itemName == "chocolateruim" then
                local source = source
                local user_id = vRP.getUserId(source)
                local pagamento = math.random(3500, 4500)
                if user_id then
                    if math.random(100) >= 50 then
                        if vRP.tryGetInventoryItem(user_id, "chocolateruim", 1) then
                            TriggerClientEvent('cancelando', source, true)
                            TriggerClientEvent('Creative:Update', source,
                                               'updateMochila')
                            TriggerClientEvent("progress", source, 1000,
                                               "comendo")
                            SetTimeout(1000, function()
                                TriggerClientEvent('cancelando', source, false)
                                vRP.giveMoney(user_id, pagamento)
                                TriggerClientEvent("Notify", source, "sucesso",
                                                   "Você recebeu <b>$" ..
                                                       pagamento ..
                                                       " dólares.</b>")
                            end)
                        end
                    else
                        vRP.tryGetInventoryItem(user_id, "chocolateruim", 1)
                        TriggerClientEvent('cancelando', source, true)
                        TriggerClientEvent('Creative:Update', source,
                                           'updateMochila')
                        TriggerClientEvent("Notify", source, "importante",
                                           "Ganhou nada comendo <b>Chocolate Amargo</b>.",
                                           8000)
                        TriggerClientEvent('cancelando', source, false)
                    end
                end
            elseif itemName == "cupcake" then
                local source = source
                local user_id = vRP.getUserId(source)
                local pagamento = math.random(3500, 4500)
                if user_id then
                    if math.random(100) >= 50 then
                        if vRP.tryGetInventoryItem(user_id, "cupcake", 1) then
                            TriggerClientEvent('cancelando', source, true)
                            TriggerClientEvent('Creative:Update', source,
                                               'updateMochila')
                            TriggerClientEvent("progress", source, 1000,
                                               "comendo")
                            SetTimeout(1000, function()
                                TriggerClientEvent('cancelando', source, false)
                                vRP.giveMoney(user_id, pagamento)
                                TriggerClientEvent("Notify", source, "sucesso",
                                                   "Você recebeu <b>$" ..
                                                       pagamento ..
                                                       " dólares.</b>")
                            end)
                        end
                    else
                        vRP.tryGetInventoryItem(user_id, "cupcake", 1)
                        TriggerClientEvent('cancelando', source, true)
                        TriggerClientEvent('Creative:Update', source,
                                           'updateMochila')
                        TriggerClientEvent("Notify", source, "importante",
                                           "Ganhou nada comendo <b>Cupcake de Morango</b>.",
                                           8000)
                        TriggerClientEvent('cancelando', source, false)
                    end
                end
            elseif itemName == "pirulito" then
                local source = source
                local user_id = vRP.getUserId(source)
                local pagamento = math.random(2000, 3000)
                if user_id then
                    if math.random(100) >= 50 then
                        if vRP.tryGetInventoryItem(user_id, "pirulito", 1) then
                            TriggerClientEvent('cancelando', source, true)
                            TriggerClientEvent('Creative:Update', source,
                                               'updateMochila')
                            TriggerClientEvent("progress", source, 1000,
                                               "comendo")
                            SetTimeout(1000, function()
                                TriggerClientEvent('cancelando', source, false)
                                vRP.giveMoney(user_id, pagamento)
                                TriggerClientEvent("Notify", source, "sucesso",
                                                   "Você recebeu <b>$" ..
                                                       pagamento ..
                                                       " dólares.</b>")
                            end)
                        end
                    else
                        vRP.tryGetInventoryItem(user_id, "pirulito", 1)
                        TriggerClientEvent('cancelando', source, true)
                        TriggerClientEvent('Creative:Update', source,
                                           'updateMochila')
                        TriggerClientEvent("Notify", source, "importante",
                                           "Ganhou nada comendo <b>Pirulito de Tutti-frutti</b>.",
                                           8000)
                        TriggerClientEvent('cancelando', source, false)
                    end
                end
            end
        elseif type == "equipar" then
			if vRP.tryGetInventoryItem(user_id,itemName,1) then
				local weapons = {}
				local identity = vRP.getUserIdentity(user_id)
				weapons[string.gsub(itemName,"wbody|","")] = { ammo = 0 }
				vRPclient._giveWeapons(source,weapons)
				sendToDiscordInventario("\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[EQUIPOU]: "..vRP.itemNameList(itemName).." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
				TriggerClientEvent('Creative:Update',source,'updateMochila')
			end
		elseif type == "recarregar" then
			local uweapons = vRPclient.getWeapons(source)
      local weaponuse = string.gsub(itemName,"wammo|","")
      local weaponusename = "wammo|"..weaponuse
			local identity = vRP.getUserIdentity(user_id)
      if uweapons[weaponuse] then
        local itemAmount = 0
        local data = vRP.getUserDataTable(user_id)
        for k,v in pairs(data.inventory) do
          if weaponusename == k then
            if v.amount > 250 then
              v.amount = 250
            end

            itemAmount = v.amount

            if vRP.tryGetInventoryItem(user_id, weaponusename, parseInt(v.amount)) then
              local weapons = {}
              weapons[weaponuse] = { ammo = v.amount }
              itemAmount = v.amount
              vRPclient._giveWeapons(source,weapons,false)
              sendToDiscordInventario("[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." \n[RECARREGOU]: "..vRP.itemNameList(itemName).." \n[MUNICAO]: "..parseInt(v.amount).." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
              TriggerClientEvent('Creative:Update',source,'updateMochila')
            end
          end
        end
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERLEAVE
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("vRP:playerLeave", function(user_id, source)
    actived[parseInt(user_id)] = nil
    --[[ 	if not vRP.getPremium(parseInt(user_id)) then
		local resultado = vRP.query("creative/get_priority",{ user_id = parseInt(user_id) })
		if resultado[1] then
			vRP.execute("creative/rem_priority",{ user_id = parseInt(user_id) })
		end
	end]]
end)

function chamarPolicia(source, street, model, placa)
    local x, y, z = vRPclient.getPosition(source)
    TriggerEvent("global:avisarPolicia",
                 "Roubo na ^1" .. street .. "^0 do veículo ^1" .. model ..
                     "^0 de placa ^1" .. placa .. "^0 verifique o ocorrido.", x,
                 y, z, 1)
end


function sendToDiscordInventario(name, message, color)
    local connect = {
          {
              ["color"] = color,
              ["title"] = "**".. name .."**",
              ["description"] = message,
              ["footer"] = {
                  ["text"] = "Everest Infinity",
              },
          }
      }
    PerformHttpRequest(DISCORD_WEBHOOK, function(err, text, headers) end, 'POST', json.encode({username = DISCORD_NAME, embeds = connect, avatar_url = DISCORD_IMAGE}), { ['Content-Type'] = 'application/json' })
end 

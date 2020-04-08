-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")

src = {}
Tunnel.bindInterface("gago_paramedico",src)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PREPARE
-----------------------------------------------------------------------------------------------------------------------------------------
vRP._prepare("vRP/gago_table", [[
CREATE TABLE IF NOT EXISTS gago_paramedico(
	slot INTEGER AUTO_INCREMENT,
	user_id INTEGER,
	type VARCHAR(255),
	value INTEGER,
	data VARCHAR(255),
	info VARCHAR(255),
	officer VARCHAR(255),
	CONSTRAINT pk_ebay PRIMARY KEY(slot)
);
]])

async(function()
	vRP._execute("vRP/gago_table")
end)
vRP._prepare("paramedico/get_user_inssues","SELECT * FROM gago_paramedico WHERE user_id = @user_id")
vRP._prepare("paramedico/get_user_arrest","SELECT * FROM gago_paramedico WHERE user_id = @user_id AND type = @type")
vRP._prepare("paramedico/add_user_inssues","INSERT INTO gago_paramedico(user_id,type,value,data,info,officer) VALUES(@user_id,@type,@value,@data,@info,@officer); SELECT LAST_INSERT_ID() AS slot")
-----------------------------------------------------------------------------------------------------------------------------------------
-- SEARCH INFO
-----------------------------------------------------------------------------------------------------------------------------------------
function src.infoUser(user)
	local source = source
	if user then
		local value = vRP.getUData(parseInt(user),"vRP:multas")
		local multas = json.encode(value) or 0
		local identity = vRP.getUserIdentity(parseInt(user))
		local arrests = vRP.query("paramedico/get_user_arrest",{ user_id = parseInt(user), type = "arrest" })
		local tickets = vRP.query("paramedico/get_user_arrest",{ user_id = parseInt(user), type = "ticket" })
		local warnings = vRP.query("paramedico/get_user_arrest",{ user_id = parseInt(user), type = "warning" })
		if identity then
			return multas,identity.name,identity.firstname,identity.registration,parseInt(identity.age),#arrests,#warnings
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SEARCH ARRESTS
-----------------------------------------------------------------------------------------------------------------------------------------
function src.arrestsUser(user)
	local source = source
	if user then
		local data = vRP.query("paramedico/get_user_arrest",{ user_id = user, type = "arrest" })
		local arrest = {}
		if data then
			for k,v in pairs(data) do
				table.insert(arrest,{ data = v.data, value = v.value, info  = v.info, officer = v.officer })
			end
			return arrest
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SEARCH TICKETS
-----------------------------------------------------------------------------------------------------------------------------------------
function src.ticketsUser(user)
	local source = source
	if user then
		local data = vRP.query("paramedico/get_user_arrest",{ user_id = user, type = "ticket" })
		local arrest = {}
		if data then
			for k,v in pairs(data) do
				table.insert(arrest,{ data = v.data, value = v.value, info  = v.info, officer = v.officer })
			end
			return arrest
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SEARCH WARNINGS
-----------------------------------------------------------------------------------------------------------------------------------------
function src.warningsUser(user)
	local source = source
	if user then
		local data = vRP.query("paramedico/get_user_arrest",{ user_id = user, type = "warning" })
		local arrest = {}
		if data then
			for k,v in pairs(data) do
				table.insert(arrest,{ data = v.data, value = v.value, info  = v.info, officer = v.officer })
			end
			return arrest
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- WARNING
-----------------------------------------------------------------------------------------------------------------------------------------
function src.warningUser(user,date,info,officer)
	local source = source
	if user then
		vRP.execute("paramedico/add_user_inssues",{ user_id = user, type = "warning", value = 0, data = date, info = info, officer = officer })
		TriggerClientEvent("Notify",source,"sucesso","Consulta registado com sucesso.",8000)
		vRPclient.playSound(source,"Hack_Success","DLC_HEIST_BIOLAB_PREP_HACKING_SOUNDS")
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TICKET
-----------------------------------------------------------------------------------------------------------------------------------------
function src.ticketUser(user,value,date,info,officer)
	local source = source
	if user then
		local valor = vRP.getUData(parseInt(user),"vRP:multas")
		local multas = json.decode(valor) or 0
		if value > 0 then
		vRP.execute("paramedico/add_user_inssues",{ user_id = user, type = "ticket", value = parseInt(value), data = date, info = info, officer = officer })
		TriggerClientEvent("Notify",source,"sucesso","Prontuario registrado com sucesso.",8000)
		vRPclient.playSound(source,"Hack_Success","DLC_HEIST_BIOLAB_PREP_HACKING_SOUNDS")
	  else
		TriggerClientEvent("Notify",source,"negado","Você precisa colocar um valor positivo.",8000)
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ARREST
-----------------------------------------------------------------------------------------------------------------------------------------
--[[function src.arrestUser(user,value,date,info,officer)
    local source = source
    if user then
        local player = vRP.getUserSource(parseInt(user))
        if player then
        	if value > 0 then
            vRP.setUData(parseInt(user),"vRP:prisao",json.encode(parseInt(value)))
            vRPclient.setHandcuffed(player,false)
            TriggerClientEvent('prisioneiro',player,true)
            vRPclient.teleport(player,1680.1,2513.0,45.5)
            TriggerEvent("prison_lock",parseInt(user))
            vRP.execute("paramedico/add_user_inssues",{ user_id = user, type = "arrest", value = parseInt(value), data = date, info = info, officer = officer })
            TriggerClientEvent("Notify",source,"sucesso","Prisão aplicada com sucesso.",8000)
            vRPclient.playSound(source,"Hack_Success","DLC_HEIST_BIOLAB_PREP_HACKING_SOUNDS")
        else
        	vRP.execute("paramedico/add_user_inssues",{ user_id = user, type = "arrest", value = parseInt(value), data = date, info = info, officer = officer })
        	vRPclient.playSound(source,"Hack_Success","DLC_HEIST_BIOLAB_PREP_HACKING_SOUNDS")
        	TriggerClientEvent("Notify",source,"negado","O cidadão foi registrado mas não enviado ao presidio.",8000)
        	end
        end
    end
end]]

-----------------------------------------------------------------------------------------------------------------------------------------
-- GROUP PERMISSION
-----------------------------------------------------------------------------------------------------------------------------------------
function src.checkPermission()
	local source = source
	local user_id = vRP.getUserId(source)
	return vRP.hasPermission(user_id,"paramedico.permissao")
end
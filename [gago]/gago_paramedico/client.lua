-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vSERVER = Tunnel.getInterface("gago_paramedico")
-----------------------------------------------------------------------------------------------------------------------------------------
-- FOCUS
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	SetNuiFocus(false,false)
end)

local localidades = {
	{308.6,-594.88,43.29}

}

Citizen.CreateThread(function()
	SetNuiFocus(false,false)
	while true do
		Citizen.Wait(5)
		local ped = PlayerPedId()
		if not IsPedInAnyVehicle(ped) then
			local x,y,z = table.unpack(GetEntityCoords(ped))
			for k,v in pairs(localidades) do
				local distance = Vdist(x,y,z,v[1],v[2],v[3])
				if distance <= 1.2 and IsControlJustPressed(0,38) and vSERVER.checkPermission() then
					SetNuiFocus(true,true)
					SendNUIMessage({ action = "showMenu" })
					vRP._CarregarObjeto("amb@code_human_in_bus_passenger_idles@female@tablet@idle_a","idle_b","prop_cs_tablet",49,28422)
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLOSE paramedico
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("mdtClose",function(data,cb)
	SetNuiFocus(false,false)
	SendNUIMessage( { action = "hideMenu" })
	vRP._DeletarObjeto()
	vRP._stopAnim(false)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GET INFOS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("infoUser",function(data,cb)
	local tickets,name,lastname,identity,age,arrests,warnings = vSERVER.infoUser(data.user)
	cb({ tickets = tickets, name = name, lastname = lastname, identity = identity, age = age, arrests = arrests, warnings = warnings })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ARRESTS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("arrestsUser",function(data,cb)
	local arrests = vSERVER.arrestsUser(data.user)
	if arrests then
		cb({ arrests = arrests})
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TICKETS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("ticketsUser",function(data,cb)
	local tickets = vSERVER.ticketsUser(data.user)
	if tickets then
		cb({ tickets = tickets})
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- WARNINGS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("warningsUser",function(data,cb)
	local warnings = vSERVER.warningsUser(data.user)
	if warnings then
		cb({ warnings = warnings})
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- WARNING
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("warningUser",function(data,cb)
	if data.user then
		vSERVER.warningUser(data.user,data.date,data.info,data.officer)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TICKET
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("ticketUser",function(data,cb)
	if data.user then
		vSERVER.ticketUser(data.user,data.value,data.date,data.info,data.officer)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ARREST
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("arrestUser",function(data,cb)
	if data.user then
		vSERVER.arrestUser(data.user,data.value,data.date,data.info,data.officer)
	end
end)
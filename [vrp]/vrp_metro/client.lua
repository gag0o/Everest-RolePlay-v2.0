local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNCTION
-----------------------------------------------------------------------------------------------------------------------------------------
local menuactive = false

function ToggleActionMenu()
	menuactive = not menuactive
	if menuactive then
		SetNuiFocus(true,true)
		SendNUIMessage({ showmenu = true })
	else
		SetNuiFocus(false)
		SendNUIMessage({ hidemenu = true })
	end
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- BUTTON
-----------------------------------------------------------------------------------------------------------------------------------------

RegisterNUICallback("ButtonClick",function(data,cb)
	local ped = PlayerPedId()
	if data == "carson" then
		ToggleActionMenu()
		DoScreenFadeOut(1000)
		TriggerEvent("Notify","importante","Você está viajando... aguarde o trem chegar no local.")
		Citizen.Wait(1000)
		TriggerEvent("vrp_sound:source",'train',1.0)
		SetEntityVisible(ped,false,false)
		Citizen.Wait(65000)
		DoScreenFadeIn(1000)
		vRP.teleport(103.64,-1715.84,30.11)
		SetEntityVisible(ped,true,true)
	elseif data == "alta" then
		ToggleActionMenu()
		DoScreenFadeOut(1000)
		TriggerEvent("Notify","importante","Você está viajando... aguarde o trem chegar no local.")
		Citizen.Wait(1000)
		TriggerEvent("vrp_sound:source",'train',1.0)
		SetEntityVisible(ped,false,false)
		Citizen.Wait(65000)
		DoScreenFadeIn(1000)
		SetEntityVisible(ped,true,true)
		vRP.teleport(-208.18,-1019.04,30.13)
	elseif data == "sanandreas" then
		ToggleActionMenu()
		DoScreenFadeOut(1000)
		TriggerEvent("Notify","importante","Você está viajando... aguarde o trem chegar no local.")
		Citizen.Wait(1000)
		TriggerEvent("vrp_sound:source",'train',1.0)
		SetEntityVisible(ped,false,false)
		Citizen.Wait(65000)
		DoScreenFadeIn(1000)
		SetEntityVisible(ped,true,true)
		vRP.teleport(-527.465,-676.487,11.808)
	elseif data == "southrockford" then
		ToggleActionMenu()
		DoScreenFadeOut(1000)
		TriggerEvent("Notify","importante","Você está viajando... aguarde o trem chegar no local.")
		Citizen.Wait(1000)
		TriggerEvent("vrp_sound:source",'train',1.0)
		SetEntityVisible(ped,false,false)
		Citizen.Wait(65000)
		DoScreenFadeIn(1000)
		SetEntityVisible(ped,true,true)
		vRP.teleport(-1366.9066162109,-444.40420532227,15.049792289734)
	elseif data == "paletobay" then
		ToggleActionMenu()
		DoScreenFadeOut(1000)
		TriggerEvent("Notify","importante","Você está viajando... aguarde o trem chegar no local.")
		Citizen.Wait(1000)
		TriggerEvent("vrp_sound:source",'train',1.0)
		SetEntityVisible(ped,false,false)
		Citizen.Wait(65000)
		DoScreenFadeIn(1000)
		SetEntityVisible(ped,true,true)
		vRP.teleport(210.69091796875,6374.7036132813,31.651838302612)
	elseif data == "madeira" then
		ToggleActionMenu()
		DoScreenFadeOut(1000)
		TriggerEvent("Notify","importante","Você está viajando... aguarde o trem chegar no local.")
		Citizen.Wait(1000)
		TriggerEvent("vrp_sound:source",'train',1.0)
		SetEntityVisible(ped,false,false)
		Citizen.Wait(65000)
		DoScreenFadeIn(1000)
		SetEntityVisible(ped,true,true)
		vRP.teleport(-481.33349609375,5254.515625,87.035224914551)
	elseif data == "joshua" then
		ToggleActionMenu()
		DoScreenFadeOut(1000)
		TriggerEvent("Notify","importante","Você está viajando... aguarde o trem chegar no local.")
		Citizen.Wait(1000)
		TriggerEvent("vrp_sound:source",'train',1.0)
		SetEntityVisible(ped,false,false)
		Citizen.Wait(65000)
		DoScreenFadeIn(1000)
		SetEntityVisible(ped,true,true)
		vRP.teleport(2424.177734375,3851.5451660156,38.540668487549)
	elseif data == "fechar" then
		ToggleActionMenu()
	end
	TriggerEvent("ToogleBackCharacter")
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- TOOGLE LOGIN
-----------------------------------------------------------------------------------------------------------------------------------------
local marcacoes = {
	{ -208.18,-1019.04,30.13 },
	{ 103.64,-1715.84,30.11 },
	{ -472.79,-709.83,20.03 },
	{ -1352.17,-507.31,23.26 },
	{ -96.64,6148.02,31.80 },
	{ -487.37,5258.76,87.02 },
	{ -1023.98,-2755.87,0.80 },
	{ 135.81,-592.28,17.77 }
}

Citizen.CreateThread(function()
	SetNuiFocus(false,false)
	while true do
		Citizen.Wait(1)
		for _,mark in pairs(marcacoes) do
			local x,y,z = table.unpack(mark)
			local distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),x,y,z,true)
			if distance <= 25 then
			DrawMarker(21, x, y, z-0.7, 0, 0, 0, 0, 0, 0, 0.3, 0.5, 0.5, 255, 255, 255, 25, 1, 0, 0, 1)
			end
			if distance <= 1.2 then
				
				if IsControlJustPressed(0,38) then
					ToggleActionMenu()
				end
			end
		end
	end
end)



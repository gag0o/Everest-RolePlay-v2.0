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
	if data == "andar1" then
		ToggleActionMenu()
		DoScreenFadeOut(2100)
		TriggerEvent("Notify","importante","Você está no elevador aguarde...")
		Citizen.Wait(1000)
		TriggerEvent("vrp_sound:source",'elevator',1.0)
		SetEntityVisible(ped,false,false)
		Citizen.Wait(25000)
		DoScreenFadeIn(1500)
		vRP.teleport(332.28,-595.79,43.29)
		SetEntityVisible(ped,true,true)
	elseif data == "andar2" then
		ToggleActionMenu()
		DoScreenFadeOut(1000)
		TriggerEvent("Notify","importante","Você está no elevador aguarde...")
		Citizen.Wait(1000)
		TriggerEvent("vrp_sound:source",'elevator',1.0)
		SetEntityVisible(ped,false,false)
		Citizen.Wait(25000)
		DoScreenFadeIn(1500)
		SetEntityVisible(ped,true,true)
		vRP.teleport(275.74,-1361.42,24.53)
	elseif data == "andar3" then
		ToggleActionMenu()
		DoScreenFadeOut(1000)
		TriggerEvent("Notify","importante","Você está no elevador aguarde...")
		Citizen.Wait(1000)
		TriggerEvent("vrp_sound:source",'elevador',1.0)
		SetEntityVisible(ped,false,false)
		Citizen.Wait(25000)
		DoScreenFadeIn(1500)
		SetEntityVisible(ped,true,true)
		vRP.teleport(338.4,-584.4,74.17)
	elseif data == "andar4" then
		ToggleActionMenu()
		DoScreenFadeOut(1000)
		TriggerEvent("Notify","importante","Você está no elevador aguarde...")
		Citizen.Wait(1000)
		TriggerEvent("vrp_sound:source",'elevador',1.0)
		SetEntityVisible(ped,false,false)
		Citizen.Wait(25000)
		DoScreenFadeIn(1500)
		SetEntityVisible(ped,true,true)
		vRP.teleport(251.43,-1366.38,39.54)
	elseif data == "fechar" then
		ToggleActionMenu()
	end
	TriggerEvent("ToogleBackCharacter")
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- TOOGLE LOGIN
-----------------------------------------------------------------------------------------------------------------------------------------
local marcacoes = {
	{ 279.68,-1349.88,24.54 },
	{331.86,-596.61,43.29 },
	{330.04,-601.48,43.29 },
	{326.76,-603.64,43.29 },
	{338.4,-584.4,74.17 },
	{252.48,-1367.36,39.54 }
}

Citizen.CreateThread(function()
	SetNuiFocus(false,false)
	while true do
		Citizen.Wait(1)
		for _,mark in pairs(marcacoes) do
			local x,y,z = table.unpack(mark)
			local distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),x,y,z,true)
			if distance <= 2 then
			DrawText3Ds( x, y, z-0.0,"~g~E ~w~  PARA USAR O ELEVADOR")
			end
			if distance <= 1.2 then
				
				if IsControlJustPressed(0,38) then
					ToggleActionMenu()
				end
			end
		end
	end
end)

function DrawText3Ds(x,y,z,text)
	local onScreen,_x,_y = World3dToScreen2d(x,y,z)
	SetTextFont(4)
	SetTextScale(0.35,0.35)
	SetTextColour(255,255,255,150)
	SetTextEntry("STRING")
	SetTextCentre(1)
	AddTextComponentString(text)
	DrawText(_x,_y)
	local factor = (string.len(text))/370
	DrawRect(_x,_y+0.0125,0.01+factor,0.03,0,0,0,80)
end
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
	if data == "terreo" then
		ToggleActionMenu()
		DoScreenFadeOut(2100)
		TriggerEvent("Notify","importante","Você está no elevador aguarde...")
		Citizen.Wait(10000)
		TriggerEvent("vrp_sound:source",'elevator',1.0)
		SetEntityVisible(ped,false,false)
		Citizen.Wait(7000)
		DoScreenFadeIn(1500)
		vRP.teleport(944.77,48.06,80.3)
		SetEntityVisible(ped,true,true)
	elseif data == "lazer" then
		ToggleActionMenu()
		DoScreenFadeOut(1000)
		TriggerEvent("Notify","importante","Você está no elevador aguarde...")
		Citizen.Wait(1000)
		TriggerEvent("vrp_sound:source",'elevator',1.0)
		SetEntityVisible(ped,false,false)
		Citizen.Wait(10000)
		DoScreenFadeIn(1500)
		SetEntityVisible(ped,true,true)
		vRP.teleport(964.18,58.73,112.56)
	elseif data == "heliponto" then
		ToggleActionMenu()
		DoScreenFadeOut(1000)
		TriggerEvent("Notify","importante","Você está no elevador aguarde...")
		Citizen.Wait(1000)
		TriggerEvent("vrp_sound:source",'elevator',1.0)
		SetEntityVisible(ped,false,false)
		Citizen.Wait(10000)
		DoScreenFadeIn(1500)
		SetEntityVisible(ped,true,true)
		vRP.teleport(959.6,31.93,120.23)
	elseif data == "fechar" then
		ToggleActionMenu()
	end
	TriggerEvent("ToogleBackCharacter")
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- TOOGLE LOGIN
-----------------------------------------------------------------------------------------------------------------------------------------
local marcacoes = {
	{943.51,49.36,80.3 },
	{964.01,57.78,112.56 },
	958.99,32.52,120.23
	
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
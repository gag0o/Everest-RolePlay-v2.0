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
	if data == "ferro" then
		TriggerServerEvent("minerador-crafting","ferro")
	elseif data == "bronze" then
		TriggerServerEvent("minerador-crafting","bronze")
	elseif data == "ouro" then
		TriggerServerEvent("minerador-crafting","ouro")
	elseif data == "rubi" then
		TriggerServerEvent("minerador-crafting","rubi")
	elseif data == "diamante" then
		TriggerServerEvent("minerador-crafting","diamante")



	elseif data == "fechar" then
		ToggleActionMenu()
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- LOCAIS
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	SetNuiFocus(false,false)
	while true do
		Citizen.Wait(5)
		local distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),1085.06,-2002.56,31.38,true)
		if distance <= 30 then
			DrawMarker(23,1085.06,-2002.56,31.38-0.97,0,0,0,0,0,0,1.0,1.0,0.5,240,200,80,20,0,0,0,0)
			if distance <= 1.2 then
				if IsControlJustPressed(0,38) then
					ToggleActionMenu()
				end
			end
		end
	end
end)
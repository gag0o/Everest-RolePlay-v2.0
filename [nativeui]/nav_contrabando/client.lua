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

	if data == "utilidades-comprar-chavemestra" then
		TriggerServerEvent("contrabando-comprar","chavemestra")
	elseif data == "utilidades-comprar-pendrive" then
		TriggerServerEvent("contrabando-comprar","pendrive")
	elseif data == "utilidades-comprar-rebite" then
		TriggerServerEvent("contrabando-comprar","rebite")
	elseif data == "utilidades-comprar-placa" then
		TriggerServerEvent("contrabando-comprar","placa")
	elseif data == "utilidades-comprar-rubberducky" then
		TriggerServerEvent("contrabando-comprar","rubberducky")	
	elseif data == "utilidades-comprar-c4flare" then
		TriggerServerEvent("contrabando-comprar","c4flare")
	elseif data == "utilidades-comprar-serra" then
		TriggerServerEvent("contrabando-comprar","serra")
	elseif data == "utilidades-comprar-furadeira" then
		TriggerServerEvent("contrabando-comprar","furadeira")
	elseif data == "utilidades-comprar-keylogs" then
		TriggerServerEvent("contrabando-comprar","keylogs")

	elseif data == "utilidades-vender-algemas" then
		TriggerServerEvent("contrabando-vender","algemas")
	elseif data == "utilidades-vender-capuz" then
		TriggerServerEvent("contrabando-vender","capuz")
	elseif data == "utilidades-vender-pendrive" then
		TriggerServerEvent("contrabando-vender","pendrive")
	elseif data == "utilidades-vender-rebite" then
		TriggerServerEvent("contrabando-vender","rebite")
	elseif data == "utilidades-vender-placa" then
		TriggerServerEvent("contrabando-vender","placa")
	elseif data == "utilidades-vender-rubberducky" then
		TriggerServerEvent("contrabando-vender","rubberducky")	
	elseif data == "utilidades-vender-c4flare" then
		TriggerServerEvent("contrabando-vender","c4flare")
	elseif data == "utilidades-vender-chavemestra" then
		TriggerServerEvent("contrabando-vender","chavemestra")
	elseif data == "utilidades-vender-serra" then
		TriggerServerEvent("contrabando-vender","serra")
	elseif data == "utilidades-vender-furadeira" then
		TriggerServerEvent("contrabando-vender","furadeira")
	elseif data == "utilidades-comprar-keylogs" then
		TriggerServerEvent("contrabando-vender","keylogs")		

	elseif data == "fechar" then
		ToggleActionMenu()
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- LOCAIS 1229.14,-2911.37,9.31 / 1243.25,1869.41,78.96
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	SetNuiFocus(false,false)
	while true do
		Citizen.Wait(1)
		local distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),-112.37,1881.97,197.34,true)
		if distance <= 2.0 then
			if IsControlJustPressed(0,38) then
				ToggleActionMenu()
			end
		end
	end
end)
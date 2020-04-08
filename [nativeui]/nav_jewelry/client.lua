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
	if data == "relogioroubado" then
		TriggerServerEvent("jewelry-vender","relogioroubado")
	elseif data == "pulseiraroubada" then
		TriggerServerEvent("jewelry-vender","pulseiraroubada")
	elseif data == "orgao" then
		TriggerServerEvent("jewelry-vender","orgao")
	elseif data == "anelroubado" then
		TriggerServerEvent("jewelry-vender","anelroubado")
	elseif data == "colarroubado" then
		TriggerServerEvent("jewelry-vender","colarroubado")
	elseif data == "brincoroubado" then
		TriggerServerEvent("jewelry-vender","brincoroubado")
	elseif data == "carteiraroubada" then
		TriggerServerEvent("jewelry-vender","carteiraroubada")
	elseif data == "carregadorroubado" then
		TriggerServerEvent("jewelry-vender","carregadorroubado")
	elseif data == "tabletroubado" then
		TriggerServerEvent("jewelry-vender","tabletroubado")
	elseif data == "sapatosroubado" then
		TriggerServerEvent("jewelry-vender","sapatosroubado")
	elseif data == "vibradorroubado" then
		TriggerServerEvent("jewelry-vender","vibradorroubado")
	elseif data == "perfumeroubado" then
		TriggerServerEvent("jewelry-vender","perfumeroubado")
	elseif data == "maquiagemroubada" then
		TriggerServerEvent("jewelry-vender","maquiagemroubada")

	elseif data == "fechar" then
		ToggleActionMenu()
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- LOCAIS
-----------------------------------------------------------------------------------------------------------------------------------------
local marcacoes = {
	{-477.94,-2688.89,8.77},
    {707.31,-966.99,30.41}
}

Citizen.CreateThread(function()
	SetNuiFocus(false,false)
	while true do
		Citizen.Wait(1)
		for _,mark in pairs(marcacoes) do
			local x,y,z = table.unpack(mark)
			local distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),x,y,z,true)
			if distance <= 1.5 then
				DrawMarker(21,x,y,z-0.6,0,0,0,0.0,0,0,0.5,0.5,0.4,255,255,255,25,0,0,0,1)
				if IsControlJustPressed(0,38) then
					ToggleActionMenu()
				end
			end
		end
	end
end)
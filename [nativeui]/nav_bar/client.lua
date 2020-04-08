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
	if data == "bebidas-comprar-cerveja" then
		TriggerServerEvent("bar-comprar","cerveja")
	elseif data == "bebidas-comprar-tequila" then
		TriggerServerEvent("bar-comprar","tequila")
	elseif data == "bebidas-comprar-vodka" then
		TriggerServerEvent("bar-comprar","vodka")
	elseif data == "bebidas-comprar-whisky" then
		TriggerServerEvent("bar-comprar","whisky")
	elseif data == "bebidas-comprar-conhaque" then
		TriggerServerEvent("bar-comprar","conhaque")
	elseif data == "bebidas-comprar-absinto" then
		TriggerServerEvent("bar-comprar","absinto")
	elseif data == "bebidas-comprar-energetico" then
		TriggerServerEvent("bar-comprar","energetico")

	elseif data == "bebidas-vender-cerveja" then
		TriggerServerEvent("bar-vender","cerveja")
	elseif data == "bebidas-vender-tequila" then
		TriggerServerEvent("bar-vender","tequila")
	elseif data == "bebidas-vender-vodka" then
		TriggerServerEvent("bar-vender","vodka")
	elseif data == "bebidas-vender-whisky" then
		TriggerServerEvent("bar-vender","whisky")
	elseif data == "bebidas-vender-conhaque" then
		TriggerServerEvent("bar-vender","conhaque")
	elseif data == "bebidas-vender-absinto" then
		TriggerServerEvent("bar-vender","absinto")
	elseif data == "bebidas-vender-energetico" then
		TriggerServerEvent("bar-vender","energetico")

	elseif data == "fechar" then
		ToggleActionMenu()
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- LOCAIS
-----------------------------------------------------------------------------------------------------------------------------------------
local marcacoes = {
	{ 213.53,-926.24,214.44 },
	{ 886.71,-2097.55,35.61 },
	{ -1577.95,-3014.95,-79.00 },
	{ -1586.78,-3012.70,-76.00 },
	{ -1585.76,-3016.63,-76.00 },
	{ -1585.74,-3008.66,-76.00 },
	{ -1723.59,365.74,89.77 },
	{ -1436.99,207.11,57.82 },
	{ -2334.99,-656.63,13.41 },
	{ -2335.07,-659.86,13.41 },
	{ -1391.5673828125,-604.95422363281,30.319551467896 },
	{ -1375.7781982422,-628.95080566406,30.819568634033 },
	{ 1087.40,87.98,82.89 },
	{ -75.71,940.32,232.81 }
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
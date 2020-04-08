RegisterNetEvent("global:addMochilaAleatoria")
AddEventHandler("global:addMochilaAleatoria",function()
	local ped = PlayerPedId()
	local bolsas = {
		40, 41, 44, 45
	}
	SetPedComponentVariation(ped,5,bolsas[math.random(1,4)],0,2)
end)

RegisterNetEvent("global:getMochilaRoubo")
AddEventHandler("global:getMochilaRoubo",function()
	local ped = PlayerPedId()
	SetPedComponentVariation(ped,5,45,0,2)
end)
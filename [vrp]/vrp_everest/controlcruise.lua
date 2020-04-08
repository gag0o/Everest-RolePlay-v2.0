RegisterCommand("cr",function(source,args)
	local veh = GetVehiclePedIsIn(PlayerPedId(),false)
	local vehspeed = GetEntitySpeed(veh)*2.236936
	if GetPedInVehicleSeat(veh,-1) == PlayerPedId() and math.ceil(vehspeed) >= 0 then
		if args[1] == nil then
			SetEntityMaxSpeed(veh,300.00)
		else
			SetEntityMaxSpeed(veh,0.45*args[1]-0.45)
			TriggerEvent("Notify","sucesso","Velocidade máxima travada em <b>"..args[1].." km/h</b>.")
		end
	end
end)


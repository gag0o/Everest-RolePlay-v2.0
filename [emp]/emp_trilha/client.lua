local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
emP = Tunnel.getInterface("emp_trilha")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS -757.17974853516,5539.6782226563,33.485721588135
-----------------------------------------------------------------------------------------------------------------------------------------
local blips = false
local inrace = false
local timerace = 0
local racepoint = 1
local racepos = 0 
local CoordenadaX = -757.17
local CoordenadaY = 5539.67
local CoordenadaZ = 33.48
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local races = {
	[1] = {
		['time'] = 600,
		[1] = { ['x'] = -821.47, ['y'] = 5438.27, ['z'] = 32.83 },-- -821.47827148438,5438.2797851563,32.834419250488
		[2] = { ['x'] = -760.47, ['y'] = 5322.00, ['z'] = 73.70 },-- -760.4775390625,5322.0053710938,73.704399108887
		[3] = { ['x'] = -833.55, ['y'] = 5261.29, ['z'] = 86.53 },-- -833.55035400391,5261.294921875,86.538017272949
		[4] = { ['x'] = -623.38, ['y'] = 5084.37, ['z'] = 131.12 },-- -623.38031005859,5084.376953125,131.12649536133
		[5] = { ['x'] = -420.68, ['y'] = 4929.68, ['z'] = 175.03 },-- -420.68020629883,4929.6831054688,175.03831481934
		[6] = { ['x'] = -225.92, ['y'] = 4904.51, ['z'] = 311.63 },-- -225.92337036133,4904.5126953125,311.63064575195
		[7] = { ['x'] = 16.024, ['y'] = 5032.59, ['z'] = 452.34 },-- 16.024547576904,5032.5986328125,452.34130859375
		[8] = { ['x'] = 227.67, ['y'] = 5297.37, ['z'] = 619.17 },-- 227.67863464355,5297.3798828125,619.17175292969
		[9] = { ['x'] = 498.51, ['y'] = 5535.00, ['z'] = 777.63 },-- 498.51379394531,5535.0068359375,777.63165283203
		[10] = { ['x'] = 865.57, ['y'] = 5659.28, ['z'] = 677.76 },-- 865.57647705078,5659.287109375,677.76416015625
		[11] = { ['x'] = 1336.00, ['y'] = 5555.71, ['z'] = 473.82 },-- 1336.0009765625,5555.7104492188,473.82434082031
		[12] = { ['x'] = 1816.14, ['y'] = 5418.125, ['z'] = 248.08 },-- 1816.1477050781,5418.125,248.08903503418
		[13] = { ['x'] = 2391.03, ['y'] = 5324.11, ['z'] = 97.94 },-- 2391.037109375,5324.11328125,97.949043273926
		[14] = { ['x'] = 2469.56, ['y'] = 5133.94, ['z'] = 48.15 },-- 2469.5693359375,5133.9458007813,48.152900695801
		[15] = { ['x'] = 2191.00, ['y'] = 4933.93, ['z'] = 40.11 },-- 2191.0083007813,4933.9301757813,40.114452362061
		[16] = { ['x'] = 1912.07, ['y'] = 4730.93, ['z'] = 40.20 },-- 1912.0749511719,4730.9379882813,40.204578399658
		[17] = { ['x'] = 1741.90, ['y'] = 4964.41, ['z'] = 45.63 }-- 1741.9056396484,4964.419921875,45.636013031006
	}
}

-----------------------------------------------------------------------------------------------------------------------------------------
-- STARTRACES
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if not inrace then
			local ped = PlayerPedId()
			local vehicle = GetVehiclePedIsUsing(ped)
			local x,y,z = table.unpack(GetEntityCoords(ped))
			local bowz,cdz = GetGroundZFor_3dCoord(CoordenadaX,CoordenadaY,CoordenadaZ)
			local distance = GetDistanceBetweenCoords(CoordenadaX,CoordenadaY,cdz,x,y,z,true)

			if distance <= 30.0 then
				if IsEntityAVehicle(vehicle) and GetVehicleClass(vehicle) ~= 8 or GetVehicleClass(vehicle) ~= 14 and GetPedInVehicleSeat(vehicle,-1) == ped then
					DrawMarker(23,CoordenadaX,CoordenadaY,CoordenadaZ-0.96,0,0,0,0,0,0,10.0,10.0,1.0,255,255,255,25,0,0,0,0)
					if distance <= 5.9 then
						drawTxt("PRESSIONE  ~b~E~w~  PARA INICIAR A TRILHA",4,0.5,0.93,0.50,255,255,255,180)
						if IsControlJustPressed(0,38) then
							inrace = true
							racepos = 1
							racepoint = emP.getRacepoint()
							timerace = races[racepoint].time
							CriandoBlip(races,racepoint,racepos)
						end
					end
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKPOINTS
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if inrace then
			local ped = PlayerPedId()
			local vehicle = GetVehiclePedIsUsing(ped)
			local x,y,z = table.unpack(GetEntityCoords(ped))
			local bowz,cdz = GetGroundZFor_3dCoord(races[racepoint][racepos].x,races[racepoint][racepos].y,races[racepoint][racepos].z)
			local distance = GetDistanceBetweenCoords(races[racepoint][racepos].x,races[racepoint][racepos].y,cdz,x,y,z,true)

			if distance <= 100.0 then
				if IsEntityAVehicle(vehicle) and GetVehicleClass(vehicle) ~= 8 or GetVehicleClass(vehicle) ~= 14 then
					DrawMarker(1,races[racepoint][racepos].x,races[racepoint][racepos].y,races[racepoint][racepos].z-3,0,0,0,0,0,0,12.0,12.0,8.0,255,255,255,25,0,0,0,0)
					DrawMarker(21,races[racepoint][racepos].x,races[racepoint][racepos].y,races[racepoint][racepos].z+1,0,0,0,0,180.0,130.0,3.0,3.0,2.0,255,255,255,25,1,0,0,1)
					if distance <= 15.1 then
						RemoveBlip(blips)
						if racepos == #races[racepoint] then
							inrace = false
							PlaySoundFrontend(-1,"RACE_PLACED","HUD_AWARDS",false)
							emP.paymentCheck(racepoint,2)
						else
							emP.paymentCheck(racepoint,1)
							racepos = racepos + 1
							CriandoBlip(races,racepoint,racepos)
						end
					end
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TIMEDRAWN
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if inrace and timerace > 0 and GetVehiclePedIsUsing(PlayerPedId()) then
			drawTxt("RESTAM ~b~"..timerace.." SEGUNDOS ~w~PARA CHEGAR AO DESTINO FINAL DA CORRIDA",4,0.5,0.905,0.45,255,255,255,100)
			drawTxt("VENÇA A CORRIDA E SUPERE SEUS PROPRIOS RECORDES ANTES DO TEMPO ACABAR",4,0.5,0.93,0.38,255,255,255,50)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TIMERACE
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		if inrace and timerace > 0 then
			timerace = timerace - 1
			if timerace <= 0 then
				inrace = false
				RemoveBlip(blips)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CANCELAR
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if inrace then
			if IsControlJustPressed(0,168) then
				inrace = false
				RemoveBlip(blips)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNÇÕES
-----------------------------------------------------------------------------------------------------------------------------------------
function drawTxt(text,font,x,y,scale,r,g,b,a)
	SetTextFont(font)
	SetTextScale(scale,scale)
	SetTextColour(r,g,b,a)
	SetTextOutline()
	SetTextCentre(1)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x,y)
end

function CriandoBlip(races,racepoint,racepos)
	blips = AddBlipForCoord(races[racepoint][racepos].x,races[racepoint][racepos].y,races[racepoint][racepos].z)
	SetBlipSprite(blips,1)
	SetBlipColour(blips,1)
	SetBlipScale(blips,0.4)
	SetBlipAsShortRange(blips,false)
	SetBlipRoute(blips,true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Corrida de Trilha")
	EndTextCommandSetBlipName(blips)
end
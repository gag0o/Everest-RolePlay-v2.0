local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
func = Tunnel.getInterface("gago_mechmission")

emservicomech = false
selecionado = 0

mx,my,mz = -370.62,-117.22,38.7

local locs = {
	[1] = { ['x'] = -48.83, ['y'] = -1261.99, ['z'] = 29.059 },
	[2] = { ['x'] = 26.43, ['y'] = -1178.21, ['z'] = 29.30 },
	[3] = { ['x'] = 252.53, ['y'] = -747.16, ['z'] = 34.63 },
	[4] = { ['x'] = 282.01, ['y'] = -186.09, ['z'] = 61.57 },
	[5] = { ['x'] = 443.87, ['y'] = 257.94, ['z'] = 103.209 },
	[6] = { ['x'] = 667.27, ['y'] = 186.30, ['z'] = 93.10 },
	[7] = { ['x'] = 902.30, ['y'] = -64.49, ['z'] = 78.76 },
	[8] = { ['x'] = 1212.28, ['y'] = -281.45, ['z'] = 69.08 },
	[9] = { ['x'] = 1199.29, ['y'] = -538.10, ['z'] = 67.29 },
	[10] = { ['x'] = 1210.15, ['y'] = -1066.17, ['z'] = 40.01 },
	[11] = { ['x'] = 1201.73, ['y'] = -1325.20, ['z'] = 35.22 },
	[12] = { ['x'] = 1441.26, ['y'] = -1766.27, ['z'] = 68.850 },
	[13] = { ['x'] = 959.73, ['y'] = -1959.55, ['z'] = 30.67 }
}

local carsmodels = {
	"tornado3",
	"buccaneer",
	"blista",
	"minivan2"
}

RegisterCommand("trabalharmec",function()
	emservicomech = true
	selecionado = math.random(1,13)
	if func.checkqunatidade(selecionado) then
		CriandoBlip(locs,selecionado)
		local xc,yc,zc = locs[selecionado].x,locs[selecionado].y,locs[selecionado].z
		----print(xc,yc,zc)

		local carModel = GetHashKey(carsmodels[math.random(1,4)])
		RequestModel(carModel)

		while not HasModelLoaded(carModel) do
			Wait(0)
		end
		
		Veh = CreateVehicle(carModel, xc,yc,zc, 0, true, false)

		SetModelAsNoLongerNeeded(carModel)	

		func.quantidade(selecionado)
	end	
end)

RegisterCommand("parartrabalhomec",function()
	if emservicomech then
		DeleteEntity(Veh)
		func.removequantidade(selecionado)
		RemoveBlip(blips)
		TriggerEvent("Notify","sucesso","Você parou de trabalhar")	
	else
		TriggerEvent("Notify","negado","Você não está trabalhando")	
	end	
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		carx,cary,carz = table.unpack(GetEntityCoords(Veh))
		DrawMarker(2,carx,cary,carz+1.97,0,0,0,180.0,0,0,1.0,1.0,1.5,255,255,255,25,1,1,0,0)
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		local bowz,cdz = GetGroundZFor_3dCoord(carx,cary,carz)
		local distance = GetDistanceBetweenCoords(carx,cary,cdz,mx,my,mz,true)
		if distance < 10 then
			DeleteEntity(Veh)
			func.removequantidade(selecionado)
			func.moneyaward(math.random(300,500))
			RemoveBlip(blips)
		end	
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		if IsEntityAttached(Veh) then
			RemoveBlip(blips)
			CriandoBlipBase(mx,my,mz)
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		DrawMarker(23,mx,my,mz-0.92,0,0,0,180.0,0,0,10.0,10.0,1.0,255,255,255,25,0,0,0,0)
	end	
end)

function CriandoBlip(locs,selecionado)
	blips = AddBlipForCoord(locs[selecionado].x,locs[selecionado].y,locs[selecionado].z)
	SetBlipSprite(blips,1)
	SetBlipColour(blips,5)
	SetBlipScale(blips,0.4)
	SetBlipAsShortRange(blips,false)
	SetBlipRoute(blips,true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Reboque de Carro")
	EndTextCommandSetBlipName(blips)
end

function CriandoBlipBase(x,y,z)
	blips = AddBlipForCoord(x,y,z)
	SetBlipSprite(blips,1)
	SetBlipColour(blips,5)
	SetBlipScale(blips,0.4)
	SetBlipAsShortRange(blips,false)
	SetBlipRoute(blips,true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Reboque de Carro")
	EndTextCommandSetBlipName(blips)
end


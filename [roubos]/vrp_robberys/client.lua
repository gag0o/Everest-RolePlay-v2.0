-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONEXÃO
-----------------------------------------------------------------------------------------------------------------------------------------
src = {}
Tunnel.bindInterface("vrp_robberys",src)
vSERVER = Tunnel.getInterface("vrp_robberys")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local robbery = false
local timedown = 0
local robmark = nil
-----------------------------------------------------------------------------------------------------------------------------------------
-- ROBBERS
-----------------------------------------------------------------------------------------------------------------------------------------
local robbers = {
	[1] = { 28.29,-1339.2,29.5 },
	[2] = { 2549.29,384.81,108.63 },
	[3] = { 1159.62,-316.6,69.21 },
	[4] = { -709.56,-904.27,19.22 },
	[5] = { -43.35,-1748.35,29.43 },
	[6] = { 378.16,333.35,103.57 },
	[7] = { -3249.94,1004.4,12.84 },
	[8] = { 1734.84,6420.79,35.04 },
	[9] = { 546.38,2662.76,42.16 },
	[10] = { 1959.2,3748.85,32.35 },
	[11] = { 2672.86,3286.71,55.25 },
	[12] = { 1707.84,4920.42,42.07 },
	[13] = { -1829.21,798.87,138.2 },
	[14] = { 1394.9,3613.84,34.99 },
	[15] = { -2959.65,387.16,14.05 },
	[16] = { -3047.9,585.61,7.91 },
	[17] = { 1126.75,-980.16,45.42 },
	[18] = { 1169.24,2717.78,37.16 },
	[19] = { -1478.92,-375.36,39.17 },
	[20] = { -1220.79,-915.98,11.33 },
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- ROBBERSBUTTON
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)
		if not robbery then
			local ped = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(ped))
			for k,v in pairs(robbers) do
				local distance = Vdist(x,y,z,v[1],v[2],v[3])
				if distance <= 1.1 and GetEntityHealth(ped) > 101 then
					drawText("PRESSIONE  ~b~E~w~  PARA INICIAR O ROUBO",4,0.5,0.93,0.50,255,255,255,180)
					if IsControlJustPressed(0,38) and timedown <= 0 then
						timedown = 3
						if vSERVER.checkPolice() then
							vSERVER.startRobbery(k,v[1],v[2],v[3])
						end
					end
				end
			end
		else
			drawText("PARA CANCELAR O ROUBO SAIA PELA PORTA DA FRENTE",4,0.5,0.88,0.36,255,255,255,50)
			drawText("AGUARDE ~g~"..timedown.." SEGUNDOS~w~ ATÉ QUE TERMINE O ROUBO",4,0.5,0.9,0.46,255,255,255,150)
			if GetEntityHealth(PlayerPedId()) <= 101 then
				robbery = false
				vSERVER.stopRobbery()
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- STARTROBBERY
-----------------------------------------------------------------------------------------------------------------------------------------
function src.startRobbery(time,x2,y2,z2)
	robbery = true
	timedown = time
	SetPedComponentVariation(PlayerPedId(),9,0,0,2)
	SetPedComponentVariation(PlayerPedId(),5,45,0,2)
	Citizen.CreateThread(function()
		while robbery do
			Citizen.Wait(5)
			local ped = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(ped))
			local distance = Vdist(x,y,z,x2,y2,z2)
			if distance >= 15.0 then
				robbery = false
				vSERVER.stopRobbery()
			end
		end
	end)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- STARTROBBERYPOLICE
-----------------------------------------------------------------------------------------------------------------------------------------
function src.startRobberyPolice(x,y,z,localidade)
	if not DoesBlipExist(robmark) then
		robmark = AddBlipForCoord(x,y,z)
		SetBlipScale(robmark,0.5)
		SetBlipSprite(robmark,1)
		SetBlipColour(robmark,59)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Roubo: "..localidade)
		EndTextCommandSetBlipName(robmark)
		SetBlipAsShortRange(robmark,false)
		SetBlipRoute(robmark,true)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- STOPROBBERYPOLICE
-----------------------------------------------------------------------------------------------------------------------------------------
function src.stopRobberyPolice()
	if DoesBlipExist(robmark) then
		RemoveBlip(robmark)
		robmark = nil
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TIMEDOWN
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		if timedown >= 1 then
			timedown = timedown - 1
			if timedown == 0 then
				robbery = false
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DRAWTEXT
-----------------------------------------------------------------------------------------------------------------------------------------
function drawText(text,font,x,y,scale,r,g,b,a)
	SetTextFont(font)
	SetTextScale(scale,scale)
	SetTextColour(r,g,b,a)
	SetTextOutline()
	SetTextCentre(1)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x,y)
end
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
emP = Tunnel.getInterface("emp_leiteiro")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local processo = false
local segundos = 0
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local blips = false
local servico = false
local selecionado = 0
local CoordenadaX = 173.10
local CoordenadaY = -26.04
local CoordenadaZ = 68.34
local quantia = 0
RegisterNetEvent('event:SetLeite')
AddEventHandler('event:SetLeite', function(var)
    quantia = var
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CORDENADAS DAS VACAS
-----------------------------------------------------------------------------------------------------------------------------------------
local vacas = {
	{ 2432.78,4802.78,34.82 },
	{ 2440.98,4794.38,34.66 },
	{ 2449.0,4786.67,34.65 },
	{ 2457.28,4778.75,34.52 },
	{ 2464.67,4770.23,34.38 }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- RESIDENCIAS
-----------------------------------------------------------------------------------------------------------------------------------------
local locs = {
	[1] = { ['x'] = 1135.35, ['y'] = -980.69, ['z'] = 46.41 },
	[2] = { ['x'] = 25.75, ['y'] = -1346.49, ['z'] = 29.49 },
	[3] = { ['x'] = -48.54, ['y'] = -1758.17, ['z'] = 29.42 },
	[4] = { ['x'] = 373.69, ['y'] = 325.99, ['z'] = 103.56 },
	[5] = { ['x'] = 1163.37, ['y'] = -322.49, ['z'] = 69.20 },
	[6] = { ['x'] = -1487.80, ['y'] = -378.52, ['z'] = 40.16 },
	[7] = { ['x'] = -2967.94, ['y'] = 389.41, ['z'] = 15.04 },
	[8] = { ['x'] = -707.40, ['y'] = -914.98, ['z'] = 19.21 },
	[9] = { ['x'] = -1224.17, ['y'] = -908.10, ['z'] = 12.32 }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- PROCESSO LEITE
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if not processo then
			for _,func in pairs(vacas) do
				local ped = PlayerPedId()
				local x,y,z = table.unpack(func)
				local distancia = GetDistanceBetweenCoords(GetEntityCoords(ped),x,y,z)
				if distancia <= 1.2 then
					drawTxt("PRESSIONE  ~b~E~w~  PARA ORDENHAR A VACA",4,0.5,0.93,0.50,255,255,255,180)
					if IsControlJustPressed(0,38) and emP.ilegal()  then		
						if emP.checkLeites() then
							vRP._playAnim(false,{{"amb@medic@standing@tendtodead@base","base"}},true)	
							TriggerEvent('cancelando',true)
							processo = true
							segundos = 8
						end
					end
				end
			end
		end
		if processo then
			drawTxt("AGUARDE ~b~"..segundos.."~w~ SEGUNDOS ATÉ FINALIZAR A EXTRAÇÃO DO LEITE",4,0.5,0.93,0.50,255,255,255,180)
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		if processo then
			if segundos > 0 then
				segundos = segundos - 1
				if segundos == 0 then
					processo = false
					TriggerEvent("Notify","sucesso","Você recebeu <b>3x Garrafas de Leite .</b>")
					vRP._stopAnim(false)
					TriggerEvent('cancelando',false)
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TRABALHAR
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if not servico then
			local ped = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(ped))
			local bowz,cdz = GetGroundZFor_3dCoord(CoordenadaX,CoordenadaY,CoordenadaZ)
			local distance = GetDistanceBetweenCoords(CoordenadaX,CoordenadaY,cdz,x,y,z,true)

			if distance <= 30.0 then
				DrawMarker(23,CoordenadaX,CoordenadaY,CoordenadaZ-0.97,0,0,0,0,0,0,1.0,1.0,0.5,255,255,255,25,0,0,0,0)
				if distance <= 1.2 then
					drawTxt("PRESSIONE  ~b~E~w~  PARA INICIAR ENTREGAS",4,0.5,0.93,0.50,255,255,255,180)
					if IsControlJustPressed(0,38) and emP.ilegal()  then
						servico = true
						TriggerServerEvent('event:GetLeite')
						selecionado = math.random(9)
						CriandoBlip(locs,selecionado)
					end
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ENTREGAS
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if servico then
			local ped = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(ped))
			local bowz,cdz = GetGroundZFor_3dCoord(locs[selecionado].x,locs[selecionado].y,locs[selecionado].z)
			local distance = GetDistanceBetweenCoords(locs[selecionado].x,locs[selecionado].y,cdz,x,y,z,true)

			if distance <= 30.0 then
				DrawMarker(21,locs[selecionado].x,locs[selecionado].y,locs[selecionado].z-0.27,0,0,0,0,0,0,0.5,0.5,-0.5,255,255,255,25,1,0,0,1)
				if distance <= 1.2 then
					drawTxt("PRESSIONE  ~b~G~w~  PARA ENTREGAR",4,0.5,0.93,0.50,255,255,255,180)
					if IsControlJustPressed(0,47) and emP.ilegal() then
						if emP.checkPayment() then
							RemoveBlip(blips)
							backentrega = selecionado
							while true do
								if backentrega == selecionado then
									selecionado = math.random(9)
								else
									break
								end
								Citizen.Wait(1)
							end
							TriggerServerEvent('event:GetLeite')
							CriandoBlip(locs,selecionado)
						end
					end
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNÇÕES
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if servico then
			drawTxt("PRESSIONE ~r~F7~w~ SE DESEJA FINALIZAR O EXPEDIENTE",4,0.251,0.935,0.448,255,255,255,80)
			drawTxt("VA ATE O ~y~DESTINO~w~ E ENTREGUE ~g~"..quantia.."~w~ GARRAFAS DE LEITE.",4,0.2612,0.956,0.48,255,255,255,200)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CANCELAR
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if servico then
			if IsControlJustPressed(0,168) then
				servico = false
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

function CriandoBlip(locs,selecionado)
	blips = AddBlipForCoord(locs[selecionado].x,locs[selecionado].y,locs[selecionado].z)
	SetBlipSprite(blips,1)
	SetBlipColour(blips,5)
	SetBlipScale(blips,0.4)
	SetBlipAsShortRange(blips,false)
	SetBlipRoute(blips,true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Entrega de Leite")
	EndTextCommandSetBlipName(blips)
end
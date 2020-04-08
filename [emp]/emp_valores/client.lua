local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
emP = Tunnel.getInterface("emp_valores")
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
local CoordenadaX =  4.62
local CoordenadaY = -656.63
local CoordenadaZ = 33.46
local quantia = 0
RegisterNetEvent('event:SetMalotededinheiro')
AddEventHandler('event:SetMalotededinheiro', function(var)
    quantia = var
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CORDENADAS DOS MALOTE
-----------------------------------------------------------------------------------------------------------------------------------------
local malote = {
	{-2947.82,483.19,15.65}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- RESIDENCIAS
-----------------------------------------------------------------------------------------------------------------------------------------
local locs = {
	[1] = { ['x'] = -1315.86, ['y'] = -834.6, ['z'] = 16.97 },
	[2] = { ['x'] = -1409.47, ['y'] = -100.18, ['z'] = 52.4 },
	[3] = { ['x'] = -1205.75, ['y'] = -324.66, ['z'] = 37.87  },
	[4] = { ['x'] = -350.98, ['y'] = -49.88, ['z'] = 49.05  },
	[5] = { ['x'] = -2072.47, ['y'] = -317.53, ['z'] = 13.32  },
	[6] = { ['x'] = 148.0, ['y'] = -1035.12, ['z'] = 29.35  },
	[7] = { ['x'] = -31.28, ['y'] = -1121.9, ['z'] = 26.56  },
	[8] = { ['x'] = 119.62, ['y'] = -883.5, ['z'] = 31.13  },
	[9] = { ['x'] = -526.16, ['y'] = -1222.43, ['z'] = 18.46  },
	[10] = { ['x'] = -821.65, ['y'] = -1082.39, ['z'] = 11.14  },
	[11] = { ['x'] = 314.6, ['y'] = -279.22, ['z'] = 54.18  }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- PROCESSO MALOTE
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if not processo then
			for _,func in pairs(malote) do
				local ped = PlayerPedId()
				local x,y,z = table.unpack(func)
				local distancia = GetDistanceBetweenCoords(GetEntityCoords(ped),x,y,z)
				if distancia <= 1.8 then
					drawTxt("PRESSIONE  ~b~E~w~  PARA INICAR A EXTRAÇÃO DO DINHEIRO",4,0.5,0.93,0.50,255,255,255,180)
					if IsControlJustPressed(0,38)  and emP.ilegal() then
						if emP.checkMalotededinheiro() then
							TriggerEvent('cancelando',true)
							processo = true
							segundos = 10
						end
					end
				end
			end
		end
		if processo then
			drawTxt("AGUARDE ~b~"..segundos.."~w~ SEGUNDOS ATÉ FINALIZAR EXTRAÇÃO DO DINHEIRO",4,0.5,0.93,0.50,255,255,255,180)
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
					vRP._stopAnim(false)
					TriggerEvent('cancelando',false)
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TRABALHAR MALOTE
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
					drawTxt("PRESSIONE  ~b~E~w~  PARA INICIAR A ENTREGAR DO MALOTE DE DINHEIRO",4,0.5,0.93,0.50,255,255,255,180)
					if IsControlJustPressed(0,38) and emP.ilegal() then
						servico = true
						TriggerServerEvent('event:GetMalotededinheiro')
						selecionado = math.random(11)
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
			local vehicle = GetPlayersLastVehicle()
			local x,y,z = table.unpack(GetEntityCoords(ped))
			local bowz,cdz = GetGroundZFor_3dCoord(locs[selecionado].x,locs[selecionado].y,locs[selecionado].z)
			local distance = GetDistanceBetweenCoords(locs[selecionado].x,locs[selecionado].y,locs[selecionado].z,GetEntityCoords(ped),true)


			if distance <= 30.0 then
				DrawMarker(21,locs[selecionado].x,locs[selecionado].y,locs[selecionado].z-0.27,0,0,0,0,0,0,0.5,0.5,-0.5,255,255,255,25,1,0,0,1)
				if distance <= 1.2 then
					drawTxt("PRESSIONE  ~b~Z~w~  PARA ENTREGAR MALOTE DE DINHEIRO",4,0.5,0.95,0.50,255,255,255,180)
					if IsControlJustPressed(0,48) and not IsPedInAnyVehicle(ped) and  GetEntityModel(vehicle) == 1747439474 and emP.ilegal()   then
						if emP.checkPayment() then
							RemoveBlip(blips)
							backentrega = selecionado
							while true do
								if backentrega == selecionado then
									selecionado = math.random(11)
								else
									break
								end
								Citizen.Wait(1)
							end
							TriggerServerEvent('event:GetMalotededinheiro')
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
			drawTxt("VA ATE O ~y~DESTINO~w~ E ENTREGUE ~g~"..quantia.."~w~ MALOTE DE DINHEIRO",4,0.2612,0.956,0.48,255,255,255,200)
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
	AddTextComponentString("Entrega de Malote")
	EndTextCommandSetBlipName(blips)
end
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
emP = Tunnel.getInterface("emp_motorista")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local emservico = false
local verificando = false
local CoordenadaX = 453.48
local CoordenadaY = -607.74
local CoordenadaZ = 28.57
-----------------------------------------------------------------------------------------------------------------------------------------
-- GERANDO LOCAL DE ENTREGA
-----------------------------------------------------------------------------------------------------------------------------------------
local entregas = {
	[1] = { x=309.95,y=-760.52,z=30.09 },
	[2] = { x=204.65,y=-1111.11,z=29.33 },
	[3] = { x=-9.7425737380981,y=-1580.0404052734,z=29.337545394897},
	[4] = { x=-394.11618041992,y=-1781.8328857422,z=21.256942749023},
	[5] = { x=-264.08148193359,y=-1168.8731689453,z=23.001838684082},
	[6] = { x=-155.39869689941,y=-839.67974853516,z=30.614002227783},
	[7] = { x=11.658317565918,y=-356.35638427734,z=41.609546661377},
	[8] = { x=256.31448364258,y=-376.39260864258,z=44.542572021484},
	[9] = { x=889.95172119141,y=-240.06773376465,z=70.304100036621},
	[10] = { x=997.00610351563,y=-452.78872680664,z=63.088893890381},
	[11] = { x=1026.8458251953,y=-742.59606933594,z=57.700378417969},
	[12] = { x=1265.7258300781,y=-574.21508789063,z=68.501251220703},
	[13] = { x=1027.0587158203,y=-192.54937744141,z=69.742790222168},
	[14] = { x=564.79046630859,y=75.621200561523,z=94.86547088623},
	[15] = { x=454.94204711914,y=287.61349487305,z=102.47624206543},
	[16] = { x=42.686458587646,y=293.19454956055,z=109.78017425537},
	[17] = { x=-518.703125,y=258.17144775391,z=82.578620910645},
	[18] = { x=-1260.7923583984,y=234.95259094238,z=61.751537322998},
	[19] = { x=-1439.9858398438,y=-51.340721130371,z=52.069198608398},
	[20] = { x=-1782.7734375,y=-533.44226074219,z=32.687553405762},
	[21] = { x=-1841.4533691406,y=-602.51171875,z=10.90495967865},
	[22] = { x=-1392.3411865234,y=-831.69415283203,z=18.460557937622},
	[23] = { x=-1210.2465820313,y=-1218.7680664063,z=7.2002139091492},
	[24] = { x=-1212.6887207031,y=-1363.8815917969,z=3.7676713466644},
	[25] = { x=-1047.1038818359,y=-1638.7819824219,z=3.9675016403198},
	[26] = { x=-1057.9516601563,y=-1320.4528808594,z=5.0265502929688},
	[27] = { x=-558.58618164063,y=-845.79302978516,z=26.970634460449},
	[28] = { x=34.83517074585,y=-795.25579833984,z=31.069641113281},
	[29] = { x=370.16760253906,y=-859.38171386719,z=28.847764968872},
	[30] = { x=407.52029418945,y=-709.91870117188,z=28.796251296997}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- TRABALHAR
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if not emservico then
			local ped = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(ped))
			local bowz,cdz = GetGroundZFor_3dCoord(CoordenadaX,CoordenadaY,CoordenadaZ)
			local distance = GetDistanceBetweenCoords(CoordenadaX,CoordenadaY,cdz,x,y,z,true)

			if distance <= 30.0 then
				DrawMarker(23,CoordenadaX,CoordenadaY,CoordenadaZ-0.97,0,0,0,0,0,0,1.0,1.0,0.5,255,255,255,25,0,0,0,0)
				if distance <= 1.2 then
					drawTxt("PRESSIONE  ~b~E~w~  PARA INICIAR ROTA",4,0.5,0.93,0.50,255,255,255,180)
					if IsControlJustPressed(0,38) and emP.ilegal() then
						emservico = true
						verificando = true
						destino = 1
						CriandoBlip(entregas,destino)
					end
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GERANDO ENTREGA
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if emservico then
			local distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),entregas[destino].x,entregas[destino].y,entregas[destino].z,true)
			if distance <= 100 then
				DrawMarker(21,entregas[destino].x,entregas[destino].y,entregas[destino].z+0.12,0,0,0,0,180.0,130.0,2.0,2.0,1.0,255,255,255,25,1,0,0,1)
				if distance <= 2.5 then
					drawTxt("PRESSIONE  ~b~E~w~  PARA CONTINUAR A ROTA",4,0.5,0.93,0.50,255,255,255,180)
					if IsControlJustPressed(0,38) and emP.ilegal() then
						if IsVehicleModel(GetVehiclePedIsUsing(PlayerPedId()),GetHashKey("coach")) or IsVehicleModel(GetVehiclePedIsUsing(PlayerPedId()),GetHashKey("bus")) then
							RemoveBlip(blip)
							verificando = true
							if destino == 30 then
								emP.checkPayment(0)
								destino = 1
							else
								emP.checkPayment(bonus)
								destino = destino + 1
							end
							CriandoBlip(entregas,destino)
						end
					end
				end
			end
		end
	end
end)


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if verificando then
			local ped = PlayerPedId()
			local vehicle = GetVehiclePedIsUsing(ped)
			local speed = GetEntitySpeed(vehicle)*2.236936

			if speed >= 50 then
				bonus = 0
				TriggerEvent("Notify","importante","Você não receberá o bônus porque ultrapassou o limite de <b>50MPH</b>.")
				verificando = false			
			else
				bonus = 25
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
		if emservico then
			drawTxt("PRESSIONE ~r~F7~w~ SE DESEJA FINALIZAR O EXPEDIENTE",4,0.252,0.935,0.448,255,255,255,100)
			drawTxt("VA ATÉ O PRÓXIMO DESTINO E AGUARDE OS ~g~PASSAGEIROS~w~.",4,0.272,0.956,0.48,255,255,255,220)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CANCELANDO ENTREGA
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if emservico then
			if IsControlJustPressed(0,168) then
				emservico = false
				RemoveBlip(blip)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNCOES
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

function CriandoBlip(entregas,destino)
	blip = AddBlipForCoord(entregas[destino].x,entregas[destino].y,entregas[destino].z)
	SetBlipSprite(blip,1)
	SetBlipColour(blip,5)
	SetBlipScale(blip,0.4)
	SetBlipAsShortRange(blip,false)
	SetBlipRoute(blip,true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Rota de Motorista")
	EndTextCommandSetBlipName(blip)
end
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
emp = Tunnel.getInterface("entrega_motor")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local emservico = false
local quantidade = 0
local statuses = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- GERANDO LOCAL DE ENTREGA
-----------------------------------------------------------------------------------------------------------------------------------------
local entregas = {
	[1] = {x=346.67907714844,y=440.79693603516,z=147.70222473145},
	[2] = {x=-181.36228942871,y=961.12164306641,z=237.73609924316},
	[3] = {x=-658.83435058594,y=888.18243408203,z=229.2488861084},
	[4] = {x=-895.40484619141,y=-4.2093172073364,z=43.798915863037},
	[5] = {x=-481.68829345703,y=-400.99075317383,z=34.546604156494},
	[6] = {x=282.94515991211,y=-801.49285888672,z=29.316823959351},
	[7] = {x=340.80706787109,y=-1270.474609375,z=31.994277954102},
	[8] = {x=489.57330322266,y=-1499.6684570313,z=29.196603775024},
	[9] = {x=-3.0023820400238,y=-1496.6760253906,z=31.850204467773},
	[10] = {x=-46.985218048096,y=-1446.6619873047,z=32.429595947266},
	[11] = {x=-38.181610107422,y=-1071.8767089844,z=27.545513153076},
	[12] = {x=136.72857666016,y=-1047.1979980469,z=29.325469970703},
	[13] = {x=-766.37976074219,y=-916.80993652344,z=21.297966003418},
	[14] = {x=-680.55181884766,y=-923.99389648438,z=23.076787948608},
	[15] = {x=-72.294319152832,y=-1820.2810058594,z=26.942153930664},
	[16] = {x=-38.448745727539,y=-614.30206298828,z=35.106479644775},
	[17] = {x=952.93707275391,y=-1059.5412597656,z=36.913986206055},
	[18] = {x=1238.6782226563,y=-1096.3197021484,z=38.52551651001},
	[19] = {x=1125.4381103516,y=-1242.6003417969,z=21.363445281982},
	[20] = {x=926.24383544922,y=-1563.9464111328,z=30.967506408691},
	[21] = {x=805.73767089844,y=-2948.5529785156,z=6.0206589698792},
	[22] = {x=89.471710205078,y=-2563.5012207031,z=5.9999957084656},
	[23] = {x=-659.48297119141,y=-2369.3596191406,z=13.944519996643},
	[24] = {x=-1157.3226318359,y=-1452.0090332031,z=4.465488910675},
	[25] = {x=-739.89428710938,y=-1224.1309814453,z=10.626365661621},
	[26] = {x=-451.80322265625,y=395.39791870117,z=104.77417755127},
	[27] = {x=-176.86965942383,y=423.41952514648,z=111.24967193604},
	[28] = {x=224.87487792969,y=337.41616821289,z=105.60335540771},
	[29] = {x=331.24685668945,y=466.12274169922,z=151.17176818848},
	[30] = {x=119.32124328613,y=564.38214111328,z=183.95948791504},
	[31] = {x=-663.92834472656,y=742.25427246094,z=174.28401184082},
	[32] = {x=-1055.5211181641,y=761.55334472656,z=167.31793212891}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- INICIANDO TRABALHO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent('entrega_motor:iniciar')
AddEventHandler('entrega_motor:iniciar',function()
	if not emservico then
		emservico = true
		destino = math.random(1,32)
		quantidade = emp.Quantidade()
		CriandoBlip(entregas,destino)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GERANDO ENTREGA
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), 453.33941650391,-1305.0018310547,30.120868682861,true) <= 1 then
			if IsControlJustPressed(0,38) then	
				TriggerServerEvent('entrega_motor:start')
			end
		end
		if emservico then
			local ui = GetMinimapAnchor()
			local distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),entregas[destino].x,entregas[destino].y,entregas[destino].z,true)
			if IsControlJustPressed(0,168) then	
				statuses = not statuses
			end
			if statuses then
				drawTxt(ui.right_x+0.005,ui.bottom_y-0.046,1.0,1.0,0.35,"PRESSIONE ~r~F11 ~w~PARA CANCELAR A MISSÃO",255,255,255,150)
				drawTxt(ui.right_x+0.005,ui.bottom_y-0.028,1.0,1.0,0.45,"ENTREGUE ~g~"..quantidade.."~w~ PEÇAS",255,255,255,255)
			else
				drawTxt(ui.right_x+0.005,ui.bottom_y-0.028,1.0,1.0,0.35,"PRESSIONE ~r~F7 ~w~PARA VER A MISSÃO",255,255,255,150)
			end
			if distance <= 50 then
				DrawMarker(21,entregas[destino].x,entregas[destino].y,entregas[destino].z+0.10,0,0,0,0,180.0,130.0,1.0,1.0,1.0,255,255,255,25,1,0,0,1)
				if distance < 3 then
					if IsControlJustPressed(0,38) then
						destinoantigo = destino
						RemoveBlip(blip)
						emp.EntregarItens()
						while true do
							if destinoantigo == destino then
								destino = math.random(1,32)
							else
								break
							end
							Citizen.Wait(1)
						end
						quantidade = emp.Quantidade()
						CriandoBlip(entregas,destino)
					end
				end
			end
		end
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- CANCELANDO ENTREGA
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if IsControlJustPressed(0,344) and emservico then
			emservico = false
			RemoveBlip(blip)
		end
	end
end)

RegisterNetEvent('cancelarmissao:entregador')
AddEventHandler('cancelarmissao:entregador',function()
	if emservico then
		emservico = false
		RemoveBlip(blip)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNCOES
-----------------------------------------------------------------------------------------------------------------------------------------
function DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0,0,1,-1)
end

function drawTxt(x,y,width,height,scale,text,r,g,b,a)
    SetTextFont(4)
    SetTextScale(scale,scale)
    SetTextColour(r,g,b,a)
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x,y)
end

function DrawText3Ds(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
end

function GetMinimapAnchor()
    local safezone = GetSafeZoneSize()
    local safezone_x = 1.0 / 20.0
    local safezone_y = 1.0 / 20.0
    local aspect_ratio = GetAspectRatio(0)
    local res_x, res_y = GetActiveScreenResolution()
    local xscale = 1.0 / res_x
    local yscale = 1.0 / res_y
    local Minimap = {}
    Minimap.width = xscale * (res_x / (4 * aspect_ratio))
    Minimap.height = yscale * (res_y / 5.674)
    Minimap.left_x = xscale * (res_x * (safezone_x * ((math.abs(safezone - 1.0)) * 10)))
    Minimap.bottom_y = 1.0 - yscale * (res_y * (safezone_y * ((math.abs(safezone - 1.0)) * 10)))
    Minimap.right_x = Minimap.left_x + Minimap.width
    Minimap.top_y = Minimap.bottom_y - Minimap.height
    Minimap.x = Minimap.left_x
    Minimap.y = Minimap.top_y
    Minimap.xunit = xscale
    Minimap.yunit = yscale
    return Minimap
end

function CriandoBlip(entregas,destino)
	blip = AddBlipForCoord(entregas[destino].x,entregas[destino].y,entregas[destino].z)
	SetBlipSprite(blip,1)
	SetBlipColour(blip,5)
	SetBlipScale(blip,0.7)
	SetBlipAsShortRange(blip,false)
	SetBlipRoute(blip,true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Entrega de Peça")
	EndTextCommandSetBlipName(blip)
end
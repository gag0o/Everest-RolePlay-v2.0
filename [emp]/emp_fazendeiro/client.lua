-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONEXÂO
-----------------------------------------------------------------------------------------------------------------------------------------
fan = {}
Tunnel.bindInterface("emp_fazendeiro", fan)
vSERVER = Tunnel.getInterface("emp_fazendeiro")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local InJob = false
local CdsX = 751.99
local CdsY = 6459.15
local CdsZ = 31.52
local processo = {}
local counter = {}
local TP = 10000
local TS = 100000
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLANTACAO
-----------------------------------------------------------------------------------------------------------------------------------------
local plant = {
    { 1,742.61798095703,6454.2700195313,31.913808822632},
    { 2,738.21142578125,6454.6733398438,31.898696899414},
    { 3,732.52087402344,6455.0561523438,31.737192153931},
    { 4,727.27099609375,6455.4506835938,31.557058334351},
    { 5,721.73449707031,6456.2270507813,31.312044143677},
    { 6,742.97076416016,6459.1533203125,31.603021621704 },
    { 7,738.39013671875,6459.4287109375,31.739553451538 },
    { 8,732.51751708984,6459.8525390625,31.627613067627 },
    { 9,727.60003662109,6460.634765625,31.28539276123 },
    { 10,721.68627929688,6461.1469726563,30.924402236938 },
    { 11,742.93383789063,6463.7670898438,30.983860015869 },
    { 12,738.39526367188,6463.8598632813,31.222665786743 },
    { 13,732.75665283203,6464.6030273438,31.245250701904 },
    { 14,727.21282958984,6464.8891601563,30.882354736328 },
    { 15,721.94439697266,6465.330078125,30.436504364014 },
    { 16,743.50347900391,6468.5336914063,29.89701461792 },
    { 17,738.47082519531,6468.8276367188,30.06830406189 },
    { 18,732.36077880859,6469.1889648438,30.20637512207 },
    { 19,727.41217041016,6470.0327148438,29.987518310547 },
    { 20,721.943359375,6470.2407226563,29.560247421265 },
    { 21,744.12280273438,6473.2104492188,28.800415039063 },
    { 22,738.95538330078,6473.3432617188,28.92622756958 },
    { 23,732.44940185547,6473.5971679688,29.159372329712 },
    { 24,727.2861328125,6474.2426757813,29.144666671753 },
    { 25,722.22186279297,6474.7553710938,28.93957901001 },
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- TIMER
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
        Citizen.Wait(1000)
        if InJob then
            for k,v in pairs(counter) do
                if v > 0 then
                    counter[k] = v - 1
                end
            end
        end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- JOBSTART
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
        if not InJob then
            local x,y,z = table.unpack(GetEntityCoords(PlayerPedId()))
            local distance = Vdist(x,y,z,CdsX,CdsY,CdsZ)
			if distance <= 30.0 then
				DrawMarker(23,CdsX,CdsY,CdsZ-0.97,0,0,0,0,0,0,1.0,1.0,0.5,240,200,80,20,0,0,0,0)
				if distance <= 1.2 then
					drawTxt("PRESSIONE  ~b~E~w~  PARA TRABALHAR",4,0.5,0.93,0.50,255,255,255,180)
					if IsControlJustPressed(0,38) then
                        InJob = true
                    end
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREAD
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        if InJob then
            local ped = PlayerPedId()
            local x,y,z = table.unpack(GetEntityCoords(ped))
            for k,v in pairs(plant) do
                if Vdist(x,y,z,v[2],v[3],v[4]) <= 1.0 then
                    if IsControlJustPressed(0,38) and not processo[v[1]] then
                        if not counter[v[1]] or counter[v[1]] == 0 then
                            if vSERVER.takeItem("semente",1) then
                                counter[v[1]] = 180
                                vRP._playAnim(false,{{"amb@world_human_gardener_plant@female@idle_a","idle_a_female"}},true)
                                TriggerEvent('cancelando',true)
                                TriggerEvent("progress",TP,"plantando")
                                SetTimeout(TP,function()
                                    processo[v[1]] = 1
                                    stop()
                                end)
                                SetTimeout(TP+TS,function() processo[v[1]] = 2 end)
                            else
                                TriggerEvent("Notify","negado","<b>Falta</b> Sementes")
                            end
                        end
                    end
                    if IsControlJustPressed(0,38) and processo[v[1]] == 2 then
                        if not counter[v[1]] or counter[v[1]] == 0 then
                            if vSERVER.checkWeigth("trigo",3) then
                                counter[v[1]] = 180
                                vRP._playAnim(false,{{"amb@world_human_gardener_plant@female@base","base_female"}},true)
                                TriggerEvent('cancelando',true)
                                TriggerEvent("progress",TP,"colhendo")
                                SetTimeout(TP,function()
                                    processo[v[1]] = 3
                                    vSERVER.giveItem("trigo",3)
                                    stop()
                                end)
                                SetTimeout(TP+TS,function() processo[v[1]] = nil end)
                            else
                                TriggerEvent("Notify","negado","<b>Mochila</b> Cheia.")
                            end
                        end
                    end  
                end
            end
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TEXT
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        if InJob then 
            local x,y,z = table.unpack(GetEntityCoords(PlayerPedId()))
            for k,v in pairs(plant) do
                if Vdist(x,y,z,v[2],v[3],v[4]) <= 8.0 then
                    if not processo[v[1]] then
                        DrawMarker(21,v[2],v[3],v[4]-0.50,0,0,0,0,180.0,130.0,1.0,1.0,0.5,211,176,72,100,1,0,0,1)
                        DrawText3D(v[2],v[3],v[4],"~g~E~w~ PARA PLANTAR")
                    elseif processo[v[1]] == 1 then
                        DrawMarker(21,v[2],v[3],v[4]-0.50,0,0,0,0,180.0,130.0,1.0,1.0,0.5,0,75,255,100,1,0,0,1)
                        DrawText3D(v[2],v[3],v[4],"CRESCENDO")
                    elseif processo[v[1]] == 2 then
                        DrawMarker(21,v[2],v[3],v[4]-0.50,0,0,0,0,180.0,130.0,1.0,1.0,0.5,255,0,72,100,1,0,0,1)
                        DrawText3D(v[2],v[3],v[4],"~g~E~w~ PARA COLHER")
                    end
                end
            end
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CANCEL
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if InJob then
			if IsControlJustPressed(0,168) then
                InJob = false
                processo = {}
                stop()
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- Stop
-----------------------------------------------------------------------------------------------------------------------------------------
function stop()
    vRP._stopAnim(false)
    vRP._DeletarObjeto()
    TriggerEvent('cancelando',false)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DRAW
-----------------------------------------------------------------------------------------------------------------------------------------
function DrawText3D(x,y,z,text)
    local onScreen,_x,_y = World3dToScreen2d(x,y,z)
    SetTextFont(4)
    SetTextScale(0.35,0.35)
    SetTextColour(255,255,255,150)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text))/370
    DrawRect(_x,_y+0.0125,0.01+factor,0.03,0,0,0,80)
end

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
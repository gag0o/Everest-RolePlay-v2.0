local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

emP = Tunnel.getInterface("emp_drogas_gangue")

local blips = false
local servico = false
local selecionado = 0

local Coordenadas = {
    {-150.24,-1625.55,33.66}, -- -198.02,-1598.19,34.91 groove
    {84.16,-1966.79,20.94}, -- 84.3,-1966.68,20.94    ballas
    {342.07,-2075.05,20.94}, -- 342.1,-2074.94,20.94 vagos
}

local inicio = 0
local fim = 0

local quantia = 0
RegisterNetEvent('event:SetDrogas')
AddEventHandler('event:SetDrogas', function(var) quantia = var end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- LOCAIS
-----------------------------------------------------------------------------------------------------------------------------------------
local locs = {
    [1] = {['x'] = -17.23, ['y'] = -296.64, ['z'] = 45.76},
    [2] = {['x'] = -239.27, ['y'] = 244.48, ['z'] = 92.05},
    [3] = {['x'] = -559.41, ['y'] = -1804.25, ['z'] = 22.60},
    [4] = {['x'] = -566.13, ['y'] = 295.44, ['z'] = 83.02},
    [5] = {['x'] = 138.72, ['y'] = -1293.62, ['z'] = 29.23},
    [6] = {['x'] = 962.17, ['y'] = -2189.49, ['z'] = 30.50},
    [7] = {['x'] = 1121.15, ['y'] = -645.60, ['z'] = 56.81},
    [8] = {['x'] = 1242.95, ['y'] = -3113.73, ['z'] = 6.02},
    [9] = {['x'] = -67.10, ['y'] = -1312.11, ['z'] = 29.28},
    [10] = {['x'] = 1338.12, ['y'] = -1524.22, ['z'] = 54.58},
    [11] = {['x'] = -330.49, ['y'] = -2778.76, ['z'] = 5.32},
    [12] = {['x'] = 318.93, ['y'] = 268.84, ['z'] = 104.54},
    [13] = {['x'] = 1029.21, ['y'] = -408.81, ['z'] = 65.95},
    [14] = {['x'] = 632.83, ['y'] = -3015.15, ['z'] = 7.34},
    [15] = {['x'] = 183.03, ['y'] = -1688.77, ['z'] = 29.68},
    [16] = {['x'] = -1715.55, ['y'] = -447.27, ['z'] = 42.65},
    [17] = {['x'] = -1753.0, ['y'] = -724.24, ['z'] = 10.42},
    [18] = {['x'] = 794.5, ['y'] = -102.84, ['z'] = 82.04},
    [19] = {['x'] = -1116.95, ['y'] = -1505.63, ['z'] = 4.4},
    [20] = {['x'] = 941.16, ['y'] = -2141.44, ['z'] = 31.23},

    [21] = {['x'] = -18.4, ['y'] = 218.91, ['z'] = 106.75},
    [22] = {['x'] = -556.45, ['y'] = 274.72, ['z'] = 83.01},
    [23] = {['x'] = 91.33, ['y'] = 298.52, ['z'] = 110.22},
    [24] = {['x'] = -1038.40, ['y'] = -1396.94, ['z'] = 5.55},
    [25] = {['x'] = -1192.20, ['y'] = -1546.56, ['z'] = 4.37},
    [26] = {['x'] = -3005.09, ['y'] = 79.05, ['z'] = 11.60},
    [27] = {['x'] = 793.79, ['y'] = -735.68, ['z'] = 27.96},
    [28] = {['x'] = 220.47, ['y'] = 304.54, ['z'] = 105.57},
    [29] = {['x'] = 1234.31, ['y'] = -354.74, ['z'] = 69.08},
    [30] = {['x'] = -1342.50, ['y'] = -871.89, ['z'] = 16.85},
    [31] = {['x'] = 225.58, ['y'] = -1746.03, ['z'] = 29.28},
    [32] = {['x'] = -428.07, ['y'] = 294.03, ['z'] = 83.22},
    [33] = {['x'] = 930.08, ['y'] = 41.57, ['z'] = 81.09},
    [34] = {['x'] = -3152.76, ['y'] = 1110.03, ['z'] = 20.87},
    [35] = {['x'] = -1829.52, ['y'] = 801.37, ['z'] = 138.41}
}

-----------------------------------------------------------------------------------------------------------------------------------------
-- TRABALHAR
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
    SetNuiFocus(false, false)
    while true do
        Citizen.Wait(1)
        if not servico then
            for _, mark in pairs(Coordenadas) do
                local x, y, z = table.unpack(mark)
                local distance = GetDistanceBetweenCoords(
                                     GetEntityCoords(PlayerPedId()), x, y, z,
                                     true)
                if distance <= 30.0 then
                    if distance <= 1.2 then
                        drawTxt("PRESSIONE  ~b~E~w~  PARA INICIAR ENTREGAS", 4,
                                0.5, 0.93, 0.50, 255, 255, 255, 180)
                        if IsControlJustPressed(0, 38)  then
                            if GetDistanceBetweenCoords(
                                GetEntityCoords(PlayerPedId()),-150.24,-1625.55,33.66, true) <= 1.2 then
                                servico = true
                                inicio = 1
                                fim = 20
                                selecionado = math.random(inicio, fim)
                                CriandoBlip(locs, selecionado)
                            elseif GetDistanceBetweenCoords(
                                GetEntityCoords(PlayerPedId()), 84.3, -1966.68, 20.94, true) <= 1.2 then
                                servico = true
                                inicio = 1
                                fim = 20
                                selecionado = math.random(inicio, fim)
                                CriandoBlip(locs, selecionado)
                            elseif GetDistanceBetweenCoords(
                                GetEntityCoords(PlayerPedId()),342.07,-2075.05,20.94, true) <= 1.2 then
                                servico = true
                                inicio = 1
                                fim = 20
                                selecionado = math.random(inicio, fim)
                                CriandoBlip(locs, selecionado)
                            end
                            TriggerServerEvent('event:GetDrogas')
                        end
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
            local x, y, z = table.unpack(GetEntityCoords(ped))
            local bowz, cdz = GetGroundZFor_3dCoord(locs[selecionado].x,
                                                    locs[selecionado].y,
                                                    locs[selecionado].z)
            local distance = GetDistanceBetweenCoords(locs[selecionado].x,
                                                      locs[selecionado].y, cdz,
                                                      x, y, z, true)
            if distance <= 30.0 then
                DrawMarker(21, locs[selecionado].x, locs[selecionado].y,
                           locs[selecionado].z - 0.27, 0, 0, 0, 0, 0, 0, 0.5,
                           0.5, -0.5, 255, 0, 0, 50, 1, 0, 0, 1)
                if distance <= 1.2 then
                    drawTxt("PRESSIONE  ~b~E~w~  PARA ENTREGAR", 4, 0.5, 0.93,
                            0.50, 255, 255, 255, 180)
                    if IsControlJustPressed(0, 38) then
                        if emP.checkPayment() then

                            porcentagem = math.random(100)
                            if porcentagem >= 70 then
                                emP.MarcarOcorrencia()
                            end

                            RemoveBlip(blips)
                            backentrega = selecionado
                            while true do
                                if backentrega == selecionado then
                                    selecionado = math.random(inicio, fim)
                                else
                                    break
                                end
                                Citizen.Wait(1)
                            end
                            TriggerServerEvent('event:GetDrogas')
                            CriandoBlip(locs, selecionado)
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
            drawTxt("PRESSIONE ~r~F7~w~ SE DESEJA FINALIZAR O EXPEDIENTE", 4,
                    0.2532, 0.935, 0.448, 255, 255, 255, 100)
            drawTxt("VA ATE O ~y~DESTINO~w~ E ENTREGUE ~g~" .. quantia ..
                        "~w~ DROGAS.", 4, 0.2438, 0.956, 0.48, 255, 255, 255,
                    200)
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
            if IsControlJustPressed(0, 168) then
                servico = false
                RemoveBlip(blips)
            end
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNÇÕES
-----------------------------------------------------------------------------------------------------------------------------------------
function drawTxt(text, font, x, y, scale, r, g, b, a)
    SetTextFont(font)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextOutline()
    SetTextCentre(1)
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x, y)
end

function CriandoBlip(locs, selecionado)
    blips = AddBlipForCoord(locs[selecionado].x, locs[selecionado].y,
                            locs[selecionado].z)
    SetBlipSprite(blips, 1)
    SetBlipColour(blips, 5)
    SetBlipScale(blips, 0.4)
    SetBlipAsShortRange(blips, false)
    SetBlipRoute(blips, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Entrega de Drogas")
    EndTextCommandSetBlipName(blips)
end

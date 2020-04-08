local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
func = Tunnel.getInterface("vrp_mafia")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNCTION
-----------------------------------------------------------------------------------------------------------------------------------------
local menuactive = false
function ToggleActionMenu(type)
    menuactive = not menuactive
    if menuactive then
        SetNuiFocus(true, true)
        SendNUIMessage({showmenu = true, type = type})
    else
        SetNuiFocus(false)
        SendNUIMessage({hidemenu = true})
    end
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- LOCAIS 
-----------------------------------------------------------------------------------------------------------------------------------------
local locais = {
    {x = 907.86, y = -3211.16, z = -98.22, type = "mafia"}
}
Citizen.CreateThread(function()
    SetNuiFocus(false, false)
    menuactive = false
    TriggerEvent("animacao", source, false)
    while true do
        Citizen.Wait(1)

        for i, item in pairs(locais) do
            local distance = GetDistanceBetweenCoords(
                                 GetEntityCoords(PlayerPedId()), item.x, item.y,
                                 item.z, true)
            if distance <= 1 and not menuactive then
                -- DrawMarker(23,566.00,-3124.73,18.76-0.97,0,0,0,0,0,0,1.0,1.0,0.5,240,200,80,20,0,0,0,0)
                drawTxt("PRESSIONE ~b~E~w~ PARA ABRIR O MENU", 4, 0.5, 0.93,
                        0.50, 255, 255, 255, 180)

                if IsControlJustPressed(0, 38) then
                    if item.type == "mafia" and func.checkPermission() then
                        ToggleActionMenu(item.type)
                    end
                end

            end
        end
    end
end)

RegisterNUICallback("ButtonClick", function(data, cb)
    if data == "fechar" then
        ToggleActionMenu()
    else
        TriggerServerEvent("mafia-comprar", data)
    end
end)

RegisterNetEvent('vrp_mafia:fecharMenu')
AddEventHandler('vrp_mafia:fecharMenu', function() ToggleActionMenu() end)

RegisterNetEvent('vrp_mafia:animacao')
AddEventHandler('vrp_mafia:animacao', function(isPlay)
    if isPlay then
        TriggerEvent('cancelando', true)
        vRP._playAnim(false, {
            {"amb@prop_human_parking_meter@female@idle_a", "idle_a_female"}
        }, true)
    else
        TriggerEvent('cancelando', false)
        ClearPedTasks(PlayerPedId())
    end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNÇÕES
-----------------------------------------------------------------------------------------------------------------------------------------
function DrawText3Ds(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoords())

    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x, _y)
    local factor = (string.len(text)) / 370
    DrawRect(_x, _y + 0.0125, 0.015 + factor, 0.03, 41, 11, 41, 68)
end

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
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")

vRPServer = Tunnel.getInterface("crz_arsenal")

inMenu = true
local Menu = true
local player = PlayerPedId()
local isPolice = false

local arsenal = {
    {458.76,-979.08,30.69}, {1841.54,3692.07,34.29},
    {-451.12, 6011.6, 31.72}, {-1105.41,-821.83,14.29},
    {-435.89,5998.02,31.72},
}

if Menu then
    Citizen.CreateThread(function()
        inMenu = false
        SetNuiFocus(false)
        SendNUIMessage({type = 'closeAll'})

        local policePermission = vRPServer.isPolice()

        if policePermission then init() end

        -- while not isPolice do
        --     Citizen.Wait(time)
        --     --print(policePermission)
        -- 	if policePermission then
        -- 		init()
        -- 	end
        -- end
    end)
end

RegisterNetEvent("global:loadJob")
AddEventHandler("global:loadJob", function()
    local policePermission = vRPServer.isPolice()
    if policePermission then
        init()
    else
        isPolice = false
    end
end)

function init()
    isPolice = true
    while isPolice do
        Wait(1)
        for _, lugares in pairs(arsenal) do
            local x, y, z = table.unpack(lugares)
            local distance = GetDistanceBetweenCoords(
                                 GetEntityCoords(GetPlayerPed(-1)), x, y, z,
                                 true)
            DrawMarker(21, x, y + 0.0, z - 0.40, 0, 0, 0, 0, 0.0, 0.0, 0.75,
                       1.0, 0.50, 255, 255, 255, 25, true, true, 2, nil, false)
            if distance <= 1 then
                if IsControlJustPressed(0, 51) then
                    TriggerServerEvent('crz_arsenal:permissao')
                end
            end
        end
    end
end

RegisterNetEvent('crz_arsenal:permissao')
AddEventHandler('crz_arsenal:permissao', function()
    inMenu = true
    SetNuiFocus(true, true)
    SendNUIMessage({type = 'openGeneral'})
end)

RegisterNUICallback('NUIFocusOff', function()
    inMenu = false
    SetNuiFocus(false)
    SendNUIMessage({type = 'closeAll'})
end)

RegisterNUICallback('Agua', function()
    local ped = PlayerPedId()
    vRP.giveInventoryItem( user_id,"radio",1)
    vRPServer.webHook("Radio")
end)

RegisterNUICallback('DonutX', function()
    local ped = PlayerPedId()
    GiveWeaponToPed(ped, GetHashKey("WEAPON_PUMPSHOTGUN_MK2"), 24, 0, 1)
    vRPServer.webHook("Remington")
end)

RegisterNUICallback('Pizza', function()
    local ped = PlayerPedId()
    GiveWeaponToPed(ped, GetHashKey("WEAPON_APPISTOL"), 24, 0, 1)
    vRPServer.webHook("Appistol")
end)

RegisterNUICallback('Cerveja', function()
    local ped = PlayerPedId()
    GiveWeaponToPed(ped, GetHashKey("WEAPON_STUNGUN"), 0, 0, 0)
    vRPServer.webHook("Tazer")
end)

RegisterNUICallback('Vodka', function()
    local ped = PlayerPedId()
    GiveWeaponToPed(ped, GetHashKey("WEAPON_NIGHTSTICK"), 0, 0, 0)
    vRPServer.webHook("Cacetete")
end)
RegisterNUICallback('Conhaque',
                    function() TriggerServerEvent('crz_arsenal:colete') end)
RegisterNUICallback('Whisky', function()
    local ped = PlayerPedId()
    GiveWeaponToPed(ped, GetHashKey("WEAPON_FIREEXTINGUISHER"), 1, 0, 1)
    vRPServer.webHook("Extintor")
end)
RegisterNUICallback('Tequila', function()
    local ped = PlayerPedId()
    GiveWeaponToPed(ped, GetHashKey("WEAPON_FLASHLIGHT"), 0, 0, 0)
    vRPServer.webHook("Lanterna")
end)
RegisterNUICallback('Leite', function()
    local ped = PlayerPedId()
    RemoveAllPedWeapons(ped, true)
end)
RegisterNUICallback('Dourado', function()
    local ped = PlayerPedId()
    SetPedAmmo(ped, GetHashKey("WEAPON_COMBATPISTOL"), 0)
    SetPedAmmo(ped, GetHashKey("WEAPON_REVOLVER_MK2"), 0)

    RemoveWeaponFromPed(ped, GetHashKey("WEAPON_COMBATPISTOL"))
    RemoveWeaponFromPed(ped,GetHashKey("WEAPON_COMBATPISTOL"))
    GiveWeaponToPed(ped,GetHashKey("WEAPON_COMBATPISTOL"),150,0,1)
    GiveWeaponComponentToPed(ped,GetHashKey("WEAPON_COMBATPISTOL"),GetHashKey("COMPONENT_AT_PI_FLSH"))
    GiveWeaponComponentToPed(ped,GetHashKey("WEAPON_COMBATPISTOL"),GetHashKey("COMPONENT_COMBATPISTOL_CLIP_02"))
    vRPServer.webHook("Glock")
end)
RegisterNUICallback('Taco', function()
    local ped = PlayerPedId()
    SetPedAmmo(ped,GetHashKey("WEAPON_SMG"),0)
    RemoveWeaponFromPed(ped,GetHashKey("WEAPON_SMG"))
    GiveWeaponToPed(ped,GetHashKey("WEAPON_SMG"),250,0,1)
    GiveWeaponComponentToPed(ped,GetHashKey("WEAPON_SMG"),GetHashKey("COMPONENT_SMG_CLIP_02"))
    GiveWeaponComponentToPed(ped,GetHashKey("WEAPON_SMG"),GetHashKey("COMPONENT_AT_AR_FLSH"))
    GiveWeaponComponentToPed(ped,GetHashKey("WEAPON_SMG"),GetHashKey("COMPONENT_AT_PI_SUPP"))
    GiveWeaponComponentToPed(ped,GetHashKey("WEAPON_SMG"),GetHashKey("COMPONENT_AT_SCOPE_MACRO_02"))
    vRPServer.webHook("MP5")
end)
RegisterNUICallback('Donut', function()
    local ped = PlayerPedId()
    SetPedAmmo(ped, GetHashKey("WEAPON_COMBATPDW"), 0)
    RemoveWeaponFromPed(ped, GetHashKey("WEAPON_COMBATPDW"))
    GiveWeaponToPed(ped, GetHashKey("WEAPON_COMBATPDW"), 180, 0, 1)
    GiveWeaponComponentToPed(ped, GetHashKey("WEAPON_COMBATPDW"),
                             GetHashKey("COMPONENT_COMBATPDW_CLIP_02"))
    GiveWeaponComponentToPed(ped, GetHashKey("WEAPON_COMBATPDW"),
                             GetHashKey("COMPONENT_AT_AR_FLSH"))
    GiveWeaponComponentToPed(ped, GetHashKey("WEAPON_COMBATPDW"),
                             GetHashKey("COMPONENT_AT_SCOPE_SMALL"))
    GiveWeaponComponentToPed(ped, GetHashKey("WEAPON_COMBATPDW"),
                             GetHashKey("COMPONENT_AT_AR_AFGRIP"))
    vRPServer.webHook("Remington")
end)

RegisterNUICallback('Pizza', function()
    local ped = PlayerPedId()
    SetPedAmmo(ped, GetHashKey("WEAPON_APPISTOL"), 0)
    RemoveWeaponFromPed(ped, GetHashKey("WEAPON_APPISTOL"))
    GiveWeaponToPed(ped, GetHashKey("WEAPON_APPISTOL"), 180, 0, 1)
    vRPServer.webHook("Appistol")
end)

RegisterNUICallback('Hamburguer', function()
    local ped = PlayerPedId()
    SetPedAmmo(ped,GetHashKey("WEAPON_CARBINERIFLE_MK2"),0)
		RemoveWeaponFromPed(ped,GetHashKey("WEAPON_CARBINERIFLE_MK2"))
		GiveWeaponToPed(ped,GetHashKey("WEAPON_CARBINERIFLE_MK2"),250,0,1)
		GiveWeaponComponentToPed(ped,GetHashKey("WEAPON_CARBINERIFLE_MK2"),GetHashKey("COMPONENT_CARBINERIFLE_MK2_CLIP_02"))
		GiveWeaponComponentToPed(ped,GetHashKey("WEAPON_CARBINERIFLE_MK2"),GetHashKey("COMPONENT_AT_AR_FLSH"))
		GiveWeaponComponentToPed(ped,GetHashKey("WEAPON_CARBINERIFLE_MK2"),GetHashKey("COMPONENT_CARBINERIFLE_MK2_CAMO_04"))
		GiveWeaponComponentToPed(ped,GetHashKey("WEAPON_CARBINERIFLE_MK2"),GetHashKey("COMPONENT_AT_SCOPE_MEDIUM_MK2"))
		GiveWeaponComponentToPed(ped,GetHashKey("WEAPON_CARBINERIFLE_MK2"),GetHashKey("COMPONENT_AT_AR_SUPP"))
		GiveWeaponComponentToPed(ped,GetHashKey("WEAPON_CARBINERIFLE_MK2"),GetHashKey("COMPONENT_AT_MUZZLE_04"))
		GiveWeaponComponentToPed(ped,GetHashKey("WEAPON_CARBINERIFLE_MK2"),GetHashKey("COMPONENT_AT_AR_AFGRIP_02"))
		GiveWeaponComponentToPed(ped,GetHashKey("WEAPON_CARBINERIFLE_MK2"),GetHashKey("COMPONENT_AT_CR_BARREL_02"))
    vRPServer.webHook("M4A1")
end)

RegisterNUICallback('Salmao', function()
    local ped = PlayerPedId()
    RemoveAllPedWeapons(ped, true)
end)
RegisterNUICallback('HotDog', function()
    local ped = PlayerPedId()

    SetPedAmmo(ped, GetHashKey("WEAPON_COMBATPISTOL"), 0)
    SetPedAmmo(ped, GetHashKey("WEAPON_REVOLVER_MK2"), 0)

    GiveWeaponToPed(ped, GetHashKey("WEAPON_REVOLVER_MK2"), 48, 0, 1)
    vRPServer.webHook("Revolver")
end)




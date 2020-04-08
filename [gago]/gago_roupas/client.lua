local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRPrp = {}
vRP = Proxy.getInterface("vRP")
vRPserver = Tunnel.getInterface("vRP")
Tunnel.bindInterface("gago_roupas", vRPrp)
Proxy.addInterface("gago_roupas", vRPrp)

local lojaderoupa = {
    { 
        ['name'] = "Loja de Roupas", 
        ['id'] = 73, 
        ['color'] = 2, 
        ['x'] = 75.342, ['y'] = -1392.800, ['z'] = 29.376, 
        ['provador'] = {
            ['x'] = 71.140, ['y'] = -1387.064, ['z'] = 29.376, ['heading'] = 180.000
        }
    },
    { 
        ['name'] = "Loja de Roupas", 
        ['id'] = 73, 
        ['color'] = 2, 
        ['x'] = -710.018, ['y'] = -153.072, ['z'] = 37.415, 
        ['provador'] = {
            ['x'] = -704.473, ['y'] = -151.684, ['z'] = 37.415, ['heading'] = 180.000
        }
    },
    { 
        ['name'] = "Loja de Roupas", 
        ['id'] = 73, 
        ['color'] = 2, 
        ['x'] = -163.261, ['y'] = -302.830, ['z'] = 39.733, 
        ['provador'] = {
            ['x'] = -167.876, ['y'] = -299.099, ['z'] = 39.733, ['heading'] = 357.678
        }
    },
    { 
        ['name'] = "Loja de Roupas", 
        ['id'] = 73, 
        ['color'] = 2, 
        ['x'] = 428.934, ['y'] = -799.841, ['z'] = 29.491, 
        ['provador'] = {
            ['x'] = 429.750, ['y'] = -812.192, ['z'] = 29.491, ['heading'] = 2.052
        }
    },
    { 
        ['name'] = "Loja de Roupas", 
        ['id'] = 73, 
        ['color'] = 2, 
        ['x'] = -1450.320, ['y'] = -237.514, ['z'] = 49.810, 
        ['provador'] = {
            ['x'] = -1447.237, ['y'] = -242.818, ['z'] = 49.822, ['heading'] = 91.148
        }
    },
    { 
        ['name'] = "Loja de Roupas", 
        ['id'] = 73, 
        ['color'] = 2, 
        ['x'] = 12.138, ['y'] = 6514.402, ['z'] = 31.877, 
        ['provador'] = {
            ['x'] = 3.373, ['y'] = 6505.400, ['z'] = 31.877, ['heading'] = 312.959
        }
    },
    { 
        ['name'] = "Loja de Roupas", 
        ['id'] = 73, 
        ['color'] = 2, 
        ['x'] = 125.112, ['y'] = -223.696, ['z'] = 54.557, 
        ['provador'] = {
            ['x'] = 123.094, ['y'] = -229.752, ['z'] = 54.557, ['heading'] = 339.498
        }
    },
    { 
        ['name'] = "Loja de Roupas", 
        ['id'] = 73, 
        ['color'] = 2, 
        ['x'] = -3170.55, ['y'] = 1043.99, ['z'] = 20.87, 
        ['provador'] = {
            ['x'] = -3175.28, ['y'] = 1044.32, ['z'] = 20.87, ['heading'] = 239.62176513672
        }
    },
    { 
        ['name'] = "Loja de Roupas", 
        ['id'] = 73, 
        ['color'] = 2, 
        ['x'] = 1196.6, ['y'] = 2710.23, ['z'] = 38.23, 
        ['provador'] = {
            ['x'] = 1202.43, ['y'] = 2714.39, ['z'] = 38.23, ['heading'] = 339.498
        }
    },
}

local parts = {
    mascara = 1,
    mao = 3,
    calca = 4,
    sapato = 6,
    mochila = 5,
    acessiorios = 7,
    camisa = 8,
    colete = 9,
    jaqueta = 11,
    bone = "p0",
    oculos = "p1",
    orelha = "p2",
    relogio = "p6",
    pulseira = "p7"
}

local drawables = {}
local textures = {}
local old_custom = {}
local old_position = {}	
local in_loja = false
local atLoja = false
-- Provador
local chegou = false
local noProvador = false
-- Cam controll
local pos = nil
local camPos = nil
local cam = -1


function SetCameraCoords()
    local ped = PlayerPedId()
	RenderScriptCams(false, false, 0, 1, 0)
    DestroyCam(cam, false)
    
	if not DoesCamExist(cam) then
        cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
		SetCamActive(cam, true)
        RenderScriptCams(true, true, 500, true, true)

        pos = GetEntityCoords(PlayerPedId())
        camPos = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 2.0, 0.0)
        SetCamCoord(cam, camPos.x, camPos.y, camPos.z+0.75)
        PointCamAtCoord(cam, pos.x, pos.y, pos.z+0.15)
    end

end

function DeleteCam()
	SetCamActive(cam, false)
	RenderScriptCams(false, true, 0, true, true)
	cam = nil
end

function openGuiLojaRoupa()
    SetNuiFocus(true, true)
    SendNUIMessage({ openLojaRoupa = true })
    SetCameraCoords()
    in_loja = true
end

function closeGuiLojaRoupa()
    local ped = PlayerPedId()
    DeleteCam()
    SetNuiFocus(false, false)
    SendNUIMessage({ openLojaRoupa = false })
    TaskGoToCoordAnyMeans(ped, old_position[ped].x, old_position[ped].y, old_position[ped].z, 1.0, 0, 0, 786603, 0xbf800000)
    FreezeEntityPosition(ped, false)
    SetEntityInvincible(ped, false)
    PlayerReturnInstancia()

    in_loja = false
    noProvador = false
    chegou = false
    old_position[ped] = nil
    drawables = {}
    textures = {}
    old_custom = {}
end

function MainRoupa()
    old_custom = vRP.getCustomization()
    old_custom.modelhash = nil

    for k, v in pairs(parts) do
        drawables[k] = { 0, 0 }
        textures[k] = { 0, 0 }

        local old_part = old_custom[v]

        if old_part then
            drawables[k][1] = old_part[1]
            textures[k][1] = old_part[2]
        end

        drawables[k][2] = vRP.getDrawables(v)
        textures[k][2] = vRP.getDrawableTextures(v, drawables[k][1])
    end
end

function Drawing(mod, choice, drawables, textures)
    local isprop, index = parse_part(parts[choice])
    local drawable = drawables[choice]
    drawable[1] = drawable[1] + mod

    if isprop then
        if drawable[1] >= drawable[2] then
            drawable[1] = -1
        elseif drawable[1] < -1 then
            drawable[1] = drawable[2] - 1
        end
    else
        if drawable[1] >= drawable[2] then
            drawable[1] = 0
        elseif drawable[1] < 0 then
            drawable[1] = drawable[2]
        end
    end

    local custom = {}
    custom[parts[choice]] = { drawable[1], textures[choice][1] }
    vRP.setCustomization(custom)

    local n = vRP.getDrawableTextures(parts[choice], drawable[1])
    textures[choice][2] = n
    if textures[choice][1] >= n then
        textures[choice][1] = 0
    end

end

function ClotheTexture(choice)
    local texture = textures[choice]
    texture[1] = texture[1] + 1
    if texture[1] >= texture[2] then
        texture[1] = 0
    end

    local custom = {}
    custom[parts[choice]] = { drawables[choice][1], texture[1] }

    vRP.setCustomization(custom)
end

function parse_part(key)
    if type(key) == "string" and string.sub(key, 1, 1) == "p" then
        return true, tonumber(string.sub(key, 2))
    else
        return false, tonumber(key)
    end
end

function PlayerInstancia()
    for i = 0, 255 do
        local ped = PlayerPedId()
        local otherPlayer = GetPlayerPed(player)
        if ped ~= otherPlayer then
            SetEntityVisible(otherPlayer, false)
            SetEntityNoCollisionEntity(ped, otherPlayer, true)
        end
    end
end

function PlayerReturnInstancia()
    for i = 0, 255 do
        local ped = PlayerPedId()
        local otherPlayer = GetPlayerPed(player)
        if ped ~= otherPlayer then
            SetEntityVisible(otherPlayer, true)
            SetEntityCollision(ped, true)
        end
    end
end

function DrawText3D(x,y,z, text)
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
end

RegisterNetEvent('LojaDeRoupas:ReceberCompra')
AddEventHandler('LojaDeRoupas:ReceberCompra', function(comprar)
    if comprar then
        in_loja = false
        closeGuiLojaRoupa()
    else
        in_loja = false
        vRP.setCustomization(old_custom)
        closeGuiLojaRoupa()
    end
end)

RegisterNUICallback('rotaterightheading', function(data)
	local currentHeading = GetEntityHeading(PlayerPedId())
    heading = currentHeading-tonumber(data.value)
    SetEntityHeading(PlayerPedId(), heading)
end)

RegisterNUICallback("next_custom", function(data, cb)
    local choice = 1
    local mod = data.type
    Drawing(choice, mod, drawables, textures)
    cb("ok")
end)

RegisterNUICallback("anterior_custom", function(data, cb)
    local choice = -1
    local mod = data.type
    Drawing(choice, mod, drawables, textures)
    cb("ok")
end)

RegisterNUICallback("cor", function(data, cb)
    local choice = -1
    local mod = data.type
    ClotheTexture(mod)
    cb("ok")
end)

RegisterNUICallback("comprar", function(data, cb)
    local preco = data.preco
    noProvador = false
    TriggerServerEvent("LojaDeRoupas:Comprar", preco)
end)

RegisterNUICallback("close", function(data, cb)
    noProvador = false
    vRP.setCustomization(old_custom)
    closeGuiLojaRoupa()
    cb('ok')
end)

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        SetNuiFocus(false, false)
    end
end)



Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        local ped = PlayerPedId()
        local playerCoords = GetEntityCoords(ped, true)
        
        for k, v in pairs(lojaderoupa) do
            local provador = lojaderoupa[k].provador

            if GetDistanceBetweenCoords(playerCoords.x, playerCoords.y, playerCoords.z, lojaderoupa[k].x, lojaderoupa[k].y, lojaderoupa[k].z, true ) <= 5 and not in_loja then
                DrawText3D(lojaderoupa[k].x, lojaderoupa[k].y, lojaderoupa[k].z-0.1, "\n~g~[E]~w~ para acessar a loja")
            end

            if GetDistanceBetweenCoords(GetEntityCoords(ped), lojaderoupa[k].x, lojaderoupa[k].y, lojaderoupa[k].z, true ) < 1 then
                if IsControlJustPressed(0, 38) and not vRP.isHandcuffed() then
                    local x,y,z = vRP.getPosition()
                    noProvador = true
                    old_position[ped] = {x = x, y = y, z = z}
                    TaskGoToCoordAnyMeans(ped, provador.x, provador.y, provador.z, 1.0, 0, 0, 786603, 0xbf800000)
                    MainRoupa()
                end
            end

            if noProvador then
                if GetDistanceBetweenCoords(GetEntityCoords(ped), provador.x, provador.y, provador.z, true ) < 0.5 and not chegou then
                    chegou = true
                    SetEntityHeading(PlayerPedId(), provador.heading)
                    FreezeEntityPosition(ped, true)
                    SetEntityInvincible(ped, true)
                    openGuiLojaRoupa()
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        if noProvador then
            PlayerInstancia()
            DisableControlAction(1, 1, true)
            DisableControlAction(1, 2, true)
            DisableControlAction(1, 24, true)
            DisablePlayerFiring(PlayerPedId(), true)
            DisableControlAction(1, 142, true)
            DisableControlAction(1, 106, true)
            DisableControlAction(1, 37, true)
        end
        Citizen.Wait(1)
    end
end)

Citizen.CreateThread(function()
    while true do
        N_0xf4f2c0d4ee209e20()
        Citizen.Wait(1000)
    end
end)
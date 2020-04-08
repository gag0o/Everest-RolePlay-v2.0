local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")

func = Tunnel.getInterface("kv_hud")

fome = 100
sede = 100

alertmaxfome = false
alertmaxsede = false

-- FOMESEDE
Citizen.CreateThread(function()
    local fomeSede = func.getFomeSede()
    if fomeSede ~= nil then
        fome = fomeSede.fome
        sede = fomeSede.sede
    end

    while true do
        Citizen.Wait(10000)
        local ped = GetPlayerPed(-1)

        controleFome(ped)
        controleVidaComFome(ped)
    end
end)

RegisterNetEvent("updateFome")
AddEventHandler("updateFome", function(valor)
    fome = fome + valor
    ajustarFomeSede()
end)

RegisterNetEvent("updateSede")
AddEventHandler("updateSede", function(valor)
    sede = sede + valor
    ajustarFomeSede()
end)

--- FUNCTIONS 

function ajustarFomeSede()
    if fome < 0 then
        fome = 0
    elseif fome > 100 then
        fome = 100
    end

    if sede < 0 then
        sede = 0
    elseif sede > 100 then
        sede = 100
    end
end

function controleFome(ped)
    fome = fome - 0.01 * 10
    sede = sede - 0.01 * 10

    ajustarFomeSede()

    if IsPedRunning(ped) then
        fome = fome - 0.04 * 10
        sede = sede - 0.06 * 10
    end

    func.setFomeSede(fome, sede)

    if fome <= 10 then
        TriggerEvent("Notify", "importante", "Você está com fome!")
    end

    if sede <= 10 then
        TriggerEvent("Notify", "importante", "Você está com sede!")
    end
end

function controleVidaComFome(ped)
    local health = GetEntityHealth(ped)
    -- --print(health)
    local newhealth = health - 10
    if fome == 0 then
        if not alertmaxfome then
            TriggerEvent("Notify", "importante",
                         "Você irá morrer se não comer!")
            alertmaxfome = true
        end
        SetEntityHealth(ped, newhealth)
    end
    if sede == 0 then
        if not alertmaxsede then
            TriggerEvent("Notify", "importante",
                         "Você irá morrer se não beber!")
            alertmaxsede = true
        end
        SetEntityHealth(ped, newhealth)
    end
end

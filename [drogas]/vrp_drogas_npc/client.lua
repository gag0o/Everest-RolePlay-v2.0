local Proxy = module("vrp", "lib/Proxy")
local Tunnel = module("vrp", "lib/Tunnel")
vRP = Proxy.getInterface("vRP")

vRPNserver = Tunnel.getInterface("vrp_drogas_npc")

local has = true
local selling = false
local secondsRemaining = 0
local ped = nil
local pos = nil
local playerloc = nil
local oldped = {}
local indexLocalVenda = 0
local emVeiculo = false

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        if indexLocalVenda > 0 then
            
            if IsControlJustPressed(1, 103) and not selling then
                
                local player = PlayerPedId()
                playerloc = GetEntityCoords(player)
                -- local coordsVenda = Config.Locais[indexLocalVenda]
                -- local areaVenda = GetDistanceBetweenCoords(playerloc,
                --                                            coordsVenda.x,
                --                                            coordsVenda.y,
                --                                            coordsVenda.z, true)
                secondsRemaining = 25
                -- if areaVenda <= 500.0 then

                ped = getNPCMaisProximo(player)
                pos = GetEntityCoords(ped)
                local distance = GetDistanceBetweenCoords(pos.x, pos.y,
                                                            pos.z,
                                                            playerloc['x'],
                                                            playerloc['y'],
                                                            playerloc['z'],
                                                            true)

                local javendeu = false
                for a, b in pairs(oldped) do
                    if b == ped then
                        javendeu = true
                        TaskCombatPed(ped, player, 0, 16)
                        TriggerEvent("Notify", "negado","Você já ofereceu droga para está pessoa!")
                    end
                end

                if javendeu == false and not IsPedInAnyVehicle(player) and
                    distance <= 2.0 and not IsPedDeadOrDying(ped) then
                    table.insert(oldped, ped)

                    emVeiculo = IsPedInAnyVehicle(ped)
                    prepararNPC()

                    

                    local random = math.random(1, 12)
                    if random == 3 or random == 7 or random == 11 or random == 5 or random == 9 then

                        TriggerEvent("Notify", "negado", "Não é usuário de drogas!")
                        selling = false

                        if math.random(0,1) == 1 then
                            vRPNserver.MarcarOcorrencia()
                        end

                        FreezeEntityPosition(ped, false)
                        SetPedAsNoLongerNeeded(ped)
                        ClearPedTasks(ped)

                    else

                        async(function() time() end)
                        while secondsRemaining > 0 do
                            Citizen.Wait(1)
                            drawTxt("AGUARDE ~b~".. secondsRemaining .."~w~ SEGUNDOS ATÉ FINALIZAR A NEGOCIAÇÃO.",4,0.5,0.93,0.50,255,255,255,180)
                        end

                        if secondsRemaining == 0 and vRPNserver.venderDroga() then
                            TaskPlayAnim(player, "mp_common", "givetake1_a",
                                            8.0, 8.0, -1, 49, 10, 0, 0, 0)
                            TaskPlayAnim(ped, "mp_common", "givetake1_a",
                                            8.0, 8.0, -1, 49, 10, 0, 0, 0)
                            Citizen.Wait(1300)
                            ClearPedTasks(ped)
                            ClearPedTasks(player)

                            if not emVeiculo then
                                async(function()
                                    local pedAnim = ped
                                    SetTimeout(500, function()
                                        TaskStartScenarioInPlace(pedAnim,
                                                                "WORLD_HUMAN_DRUG_DEALER",
                                                                0, true)
                                        SetTimeout(10000, function()
                                            ClearPedTasks(pedAnim)
                                            request("move_m@drunk@moderatedrunk")
                                            SetPedMovementClipset(pedAnim,
                                                                "move_m@drunk@moderatedrunk",
                                                                0.25)
                                        end)
                                    end)
                                end)
                            end
                            
                        end

                        FreezeEntityPosition(ped, false)
                        SetPedAsNoLongerNeeded(ped)
                        ped = nil
                    end
                end
                -- end
                
            end
        end
    end
end)

function prepararNPC()
    request("random@mugging3")
    request("mp_common")

    if IsPedSittingInAnyVehicle(ped) then
        local veh = GetVehiclePedIsIn(ped, false)
        if veh then
          TaskLeaveVehicle(ped, veh, 64)
          Citizen.Wait(1000)
        end
    end

    ClearPedTasks(ped)
    FreezeEntityPosition(ped, true)
    SetEntityAsMissionEntity(ped)
    TaskStandStill(ped, 10)
    FreezeEntityPosition(ped, true)

end

function getVehicleInDirection(coordsfrom, coordsto)
    local handle = CastRayPointToPoint(coordsfrom.x, coordsfrom.y, coordsfrom.z,
                                       coordsto.x, coordsto.y, coordsto.z, 10,
                                       PlayerPedId(), false)
    local a, b, c, d, vehicle = GetRaycastResult(handle)
    return vehicle
end

function time()
    secondsRemaining = 25
    selling = true
    while selling do
        Citizen.Wait(1000)

        playerloc = GetEntityCoords(PlayerPedId())
        distance = GetDistanceBetweenCoords(pos.x, pos.y, pos.z, playerloc['x'],
                                            playerloc['y'], playerloc['z'], true)

        if distance > 5.0 then
            secondsRemaining = -1
            selling = false
            TriggerEvent("Notify", "negado", "Você abandonou a negociação!")
        end

        secondsRemaining = secondsRemaining - 1
        if secondsRemaining == 0 then selling = false end
    end
end

RegisterNetEvent('vrp_drogas_npc:changeLocalVenda')
AddEventHandler('vrp_drogas_npc:changeLocalVenda',
                function(index) indexLocalVenda = index end)

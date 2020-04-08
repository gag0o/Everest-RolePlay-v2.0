-- ANIMACAO QUANDO FERIDO
local isFerido = false
Citizen.CreateThread(function()
    while true do
        player = PlayerPedId()
        local vida = GetEntityHealth(player)
        if vida < 200 * 0.7 then
            if agachar == false then
                isFerido = true
                vRP.loadAnimSet("move_m@injured")
            end
        else
            if isFerido then
                ResetPedMovementClipset(player, 0.0)
                isFerido = false
            end
        end

        Citizen.Wait(1000)
    end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- AGACHAR
-----------------------------------------------------------------------------------------------------------------------------------------
local agachar = false
Citizen.CreateThread(function()
    while true do        
        Citizen.Wait(1)
        local ped = PlayerPedId()
        DisableControlAction(0, 36, true)
        if not IsPedInAnyVehicle(ped) then
            RequestAnimSet("move_ped_crouched")
            RequestAnimSet("move_ped_crouched_strafing")
            if IsDisabledControlJustPressed(0, 36) then
                if agachar then
                    ResetPedMovementClipset(ped, 0.25)
                    ResetPedStrafeClipset(ped)
                    agachar = false
                else
                    SetPedMovementClipset(ped, "move_ped_crouched", 0.25)
                    SetPedStrafeClipset(ped, "move_ped_crouched_strafing")
                    agachar = true
                end
            end
        end
    end
end)

local entrou = false
local maquinas = { 
    {id = 1, x= 26.713558197021,y=-1397.1311035156,z=28.756034851074,h=0, state = 0, value = 0, propAberto = "bkr_prop_prtmachine_dryer_op", propFechado = "bkr_prop_prtmachine_dryer_spin"},
    --{id = 2, x= 24.562040328979,y=-1397.2487792969,z=28.755546569824,h=0, state = 0, value = 0, propAberto = "bkr_prop_prtmachine_dryer_op", propFechado = "bkr_prop_prtmachine_dryer_spin"},
    --{id = 3, x= 22.65030670166,y=-1397.37890625,z=28.754905700684,h=0, state = 0, value = 0, propAberto = "bkr_prop_prtmachine_dryer_op", propFechado = "bkr_prop_prtmachine_dryer_spin"},
}
------------------------
Citizen.CreateThread(function()
    while true do
        Wait(0)
        local obj = GetClosestObjectOfType(26.713558197021,-1397.1311035156,28.756034851074, 1.0, GetHashKey("bkr_prop_prtmachine_dryer_op"), false, true ,true) or GetClosestObjectOfType(1123.12,-3193.55,-40.39, 1.0, GetHashKey("bkr_prop_prtmachine_dryer_spin"), false, true ,true) 
        --local obj2 = GetClosestObjectOfType(24.562040328979,-1397.2487792969,28.755546569824, 1.0, GetHashKey("bkr_prop_prtmachine_dryer_op"), false, true ,true) or GetClosestObjectOfType(1124.73,-3193.45,-40.39, 1.0, GetHashKey("bkr_prop_prtmachine_dryer_spin"), false, true ,true) 
        --local obj3 = GetClosestObjectOfType(22.65030670166,-1397.37890625,28.754905700684, 1.0, GetHashKey("bkr_prop_prtmachine_dryer_op"), false, true ,true) or GetClosestObjectOfType(1126.95,-3193.25,-40.39, 1.0, GetHashKey("bkr_prop_prtmachine_dryer_spin"), false, true ,true) 
        if obj == 0 then
            if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), 29.361137390137,-1398.1926269531,28.749402999878,true) <= 1 then
                DrawText3Ds(29.361137390137,-1398.1926269531,28.749402999878,"PRESSIONE ~g~G~w~ PARA ATIVAR")                
                if IsControlJustPressed(0,47) then	
                    TriggerEvent('crz_lavanderia:criarMaquinas', 1)
                end
            end
        end
    end
end)

RegisterNetEvent('crz_lavanderia:statuses')
AddEventHandler('crz_lavanderia:statuses', function(maq)
    for k,v in pairs(maquinas) do
        if v.id == maq then
            Citizen.CreateThread(function() 
                while v.state == 2 do
                    Wait(0)
                    if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), v.x,v.y,v.z,true) <= 1.5 then
                        DrawText3Ds(v.x,v.y,v.z,"PRESSIONE ~g~G~w~ PARA DEPOSITAR DINHEIRO SUJO")    
                        if IsControlJustPressed(0,47) then	
                            TriggerServerEvent('crz_lavanderia:depositarDSujo', maq)
                        end
                    end
                end
                while v.state == 3 do
                    Wait(0)
                    if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), v.x,v.y,v.z,true) <= 1.5 then
                        DrawText3Ds(v.x,v.y,v.z,"PRESSIONE ~g~G~w~ PARA ATIVAR MÁQUINA")    
                        if IsControlJustPressed(0,47) then	
                            if DoesObjectOfTypeExistAtCoords(v.x,v.y,v.z,0.9,GetHashKey(v.propAberto),true) then
                                local nome = "prop_"..v.id
                                nome = GetClosestObjectOfType(v.x,v.y,v.z,0.9,GetHashKey(v.propAberto),false,false,false)
                                SetEntityAsMissionEntity(nome,true,true)
                                DeleteObject(nome)
                                v.state = 4 
                                local nivel2 = "prop_"..v.id
                                nivel2 = CreateObject(GetHashKey(v.propFechado), v.x,v.y,v.z, true, true, true)
                                SetEntityAsMissionEntity(nivel2,true,true)
                                PlaceObjectOnGroundProperly(nivel2)
                                SetEntityHeading(nivel2,v.h)
                                FreezeEntityPosition(nivel2,true)
                            end
                        end
                    end
                end
                while v.state == 4 do
                    Wait(0)
                    if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), v.x,v.y,v.z,true) <= 1.5 then
                        DrawText3Ds(v.x,v.y,v.z,"AGUARDE A LAVAGEM DO SEU DINHEIRO.")   
                    end
                    if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), v.x,v.y,v.z,true) <= 1.5 and not entrou then
                        entrou = true
                        TriggerEvent('crz_lavanderia:TESTE', maq)
                    end
                end
            end)
        end
    end
end)

RegisterNetEvent('crz_lavanderia:TESTE')
AddEventHandler('crz_lavanderia:TESTE', function(maq) 
    for k,v in pairs(maquinas) do
        if v.id == maq then
            Citizen.Wait(20*1000)
            v.state = 5
            Citizen.CreateThread(function()
                while v.state == 5 do
                    Wait(0)
                    if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), v.x,v.y,v.z,true) <= 1.5 then
                        DrawText3Ds(v.x,v.y,v.z,"PRESSIONE ~r~G~w~ PARA RECOLHER SEU DINHEIRO..")
                    end
                    if IsControlJustPressed(0,47) then
                        TriggerServerEvent('crz_lavanderia:enviarQuantia', v.value)
                        if DoesObjectOfTypeExistAtCoords(v.x,v.y,v.z,0.9,GetHashKey(v.propFechado),true) then
                            local nome = "prop_"..v.id
                            nome = GetClosestObjectOfType(v.x,v.y,v.z,0.9,GetHashKey(v.propFechado),false,false,false)
                            SetEntityAsMissionEntity(nome,true,true)
                            DeleteObject(nome)
                            v.state = 0
                            entrou = false
                        end
                    end
                end
            end)
        end
    end
end)

RegisterNetEvent('crz_lavanderia:criarMaquinas')
AddEventHandler('crz_lavanderia:criarMaquinas', function(maq) 
    for k,v in pairs(maquinas) do
        if v.id == maq then
            local nivel1 = "prop_"..v.id
            nivel1 = CreateObject(GetHashKey(v.propAberto), v.x,v.y,v.z, true, true, true)
            PlaceObjectOnGroundProperly(nivel1)
            SetEntityHeading(nivel1,v.h)
            FreezeEntityPosition(nivel1,true)
            SetEntityAsMissionEntity(nivel1,true,true)
            -- state 1
            v.state = 1
            Citizen.Wait(2*1000)
            v.state = 2
            TriggerEvent('crz_lavanderia:statuses', maq)
        end
    end
end)

RegisterNetEvent('crz_lavanderia:coloqueiDinheiro')
AddEventHandler('crz_lavanderia:coloqueiDinheiro', function(maq, quantidade) 
    for k,v in pairs(maquinas) do
        if v.id == maq then
            v.value = quantidade
            v.state = 3
            TriggerEvent('crz_lavanderia:statuses', maq)
        end
    end
end)

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

local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
emP = Tunnel.getInterface("emp_hospital")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local macas = {
	{ ['x'] = 321.99, ['y'] = -586.16, ['z'] = 43.29, ['x2'] = 322.63, ['y2'] = -587.14, ['z2'] = 44.21, ['h'] = 330.0 },
	{ ['x'] = 323.14, ['y'] = -582.52, ['z'] = 43.29, ['x2'] = 324.33, ['y2'] = -582.66, ['z2'] = 44.21, ['h'] = 150.0 },
	{ ['x'] = 318.58, ['y'] = -580.63, ['z'] = 43.29, ['x2'] = 319.36, ['y2'] = -581.07, ['z2'] = 44.21, ['h'] = 150.0 },
	{ ['x'] = 316.77, ['y'] = -585.04, ['z'] = 43.29, ['x2'] = 317.55, ['y2'] = -585.54, ['z2'] = 44.21, ['h'] = 330.0 },
	{ ['x'] = 314.78, ['y'] = -579.45, ['z'] = 43.29, ['x2'] = 313.85, ['y2'] = -578.97, ['z2'] = 44.21, ['h'] = 150.0 },
	{ ['x'] = 315.51, ['y'] = -584.34, ['z'] = 43.29, ['x2'] = 314.7, ['y2'] = -584.14, ['z2'] = 44.21, ['h'] = 330.0 },
	{ ['x'] = 312.06, ['y'] = -583.16, ['z'] = 43.29, ['x2'] = 311.25, ['y2'] = -582.76, ['z2'] = 44.21, ['h'] = 330.0 },
	{ ['x'] = 310.18, ['y'] = -577.86, ['z'] = 43.29, ['x2'] = 309.14, ['y2'] = -577.31, ['z2'] = 44.21, ['h'] = 150.0 },
	{ ['x'] = 308.65, ['y'] = -581.96, ['z'] = 43.29, ['x2'] = 307.82, ['y2'] = -581.72, ['z2'] = 44.21, ['h'] = 150.0 },
	{ ['x'] = -260.83, ['y'] = 6321.18, ['z'] = 32.44, ['x2'] = -260.29, ['y2'] = 6320.26, ['z2'] = 33.36, ['h'] = 150.0 },
	{ ['x'] = -258.95, ['y'] = 6318.47, ['z'] = 32.44, ['x2'] = -257.88, ['y2'] = 6318.06, ['z2'] = 33.36, ['h'] = 140.0 },
	{ ['x'] = -251.15, ['y'] = 6327.15, ['z'] = 32.44, ['x2'] = -250.43, ['y2'] = 6327.68, ['z2'] = 33.48, ['h'] = 58.0 },
	{ ['x'] = 354.06, ['y'] = -594.14, ['z'] = 43.29, ['x2'] = 354.27, ['y2'] = -593.15, ['z2'] = 43.99, ['h'] = 600.0 },
	{ ['x'] = 354.5, ['y'] = -599.16, ['z'] = 43.29, ['x2'] = 354.35, ['y2'] = -600.08, ['z2'] = 44.22, ['h'] = 430.0 },
	{ ['x'] = 359.93, ['y'] = -585.27, ['z'] = 43.29, ['x2'] = 359.52, ['y2'] = -586.27, ['z2'] = 44.21, ['h'] = 430.0 },
	{ ['x'] = 361.45, ['y'] = -580.33, ['z'] = 43.29, ['x2'] = 361.43, ['y2'] = -581.21, ['z2'] = 44.2, ['h'] = 430.0 },
	{ ['x'] = 347.96, ['y'] = -579.15, ['z'] = 43.29, ['x2'] = 348.83, ['y2'] = -579.06, ['z2'] = 44.19, ['h'] = 344.2251890898 },
	{ ['x'] = 337.72, ['y'] = -575.55, ['z'] = 43.29, ['x2'] =  337.03, ['y2'] = -575.29, ['z2'] = 44.19, ['h'] = 344.2251890898 },
	{ ['x'] =  439.29,['y'] = -976.39, ['z'] = 26.67,['x2'] = 438.35, ['y2'] = -976.43, ['z2'] = 27.59,  ['h'] = 179.6 },

}
-----------------------------------------------------------------------------------------------------------------------------------------
-- DEITANDO
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)
		for k,v in pairs(macas) do
			local ped = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(ped))
			local bowz,cdz = GetGroundZFor_3dCoord(v.x,v.y,v.z)
			local distance = GetDistanceBetweenCoords(v.x,v.y,cdz,x,y,z,true)
			if distance <= 1.1 then
				drawTxt("~r~E~w~  DEITAR    ~g~G~w~  TRATAMENTO",4,0.5,0.93,0.50,255,255,255,180)
				if IsControlJustPressed(0,38) then
					SetEntityCoords(ped,v.x2,v.y2,v.z2)
					SetEntityHeading(ped,v.h)
					vRP._playAnim(false,{{"mini@cpr@char_b@cpr_str","cpr_kol_idle"}},true)
				end
				if IsControlJustPressed(0,47) then
					if emP.checkServices() then
						TriggerEvent('tratamento-macas')
						TriggerEvent('resetDiagnostic')
						TriggerEvent('resetWarfarina')
						SetEntityCoords(ped,v.x2,v.y2,v.z2)
						SetEntityHeading(ped,v.h)
						vRP._playAnim(false,{{"mini@cpr@char_b@cpr_str","cpr_kol_idle"}},true)
					else
						TriggerEvent("Notify","aviso","Existem paramédicos em serviço.")
					end
				end
			end
		end
	end
end)


-----------------------------------------------------------------------------------------------------------------------------------------
-- REMEDIO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent('remedio')
AddEventHandler('remedio',function()
	local remedio = 1
	repeat
		remedio = remedio + 1
		SetEntityHealth(PlayerPedId(),GetEntityHealth(PlayerPedId())+5)
		Citizen.Wait(3600)
	until GetEntityHealth(PlayerPedId()) >= 400 or GetEntityHealth(PlayerPedId()) <= 10 or remedio == 10
		TriggerEvent("Notify","sucesso","Tratamento concluido.")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TRATAMENTO
-----------------------------------------------------------------------------------------------------------------------------------------
local tratamento = false
RegisterNetEvent("tratamento")
AddEventHandler("tratamento",function()
    local ped = PlayerPedId()
    local health = GetEntityHealth(ped)
    local armour = GetPedArmour(ped)

    local x,y,z = table.unpack(GetEntityCoords(ped))
    --NetworkResurrectLocalPlayer(x,y,z,GetEntityHeading(ped),true,false)
    SetEntityHealth(ped,health)
    SetPedArmour(ped,armour)

    if tratamento then
        return
    end

    tratamento = true
    TriggerEvent("Notify","sucesso","Diagnostico feito,aguarde a liberação do Médico.",8000)
    TriggerEvent('resetWarfarina')
    TriggerEvent('resetDiagnostic')
    

	if tratamento then
		TriggerEvent('tratamento-macas')
        repeat
            Citizen.Wait(600)
            if GetEntityHealth(ped) > 101 then
                SetEntityHealth(ped,GetEntityHealth(ped)+1)
            end
        until GetEntityHealth(ped) >= 400 or GetEntityHealth(ped) <= 101
            TriggerEvent("Notify","sucesso","Tratamento concluido.",8000)
            tratamento = false
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BANDAGEM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent('bandagem')
AddEventHandler('bandagem',function()
    local ped = PlayerPedId()
    local bandagem = 0
    repeat
        Citizen.Wait(100)
		bandagem = bandagem + 1
		TriggerEvent('resetWarfarina')
        if GetEntityHealth(ped) > 101 then
            SetEntityHealth(ped,GetEntityHealth(ped)+0)
        end
	until GetEntityHealth(ped) >= 400 or GetEntityHealth(ped) <= 101 or bandagem == 1
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNÇÕES
-----------------------------------------------------------------------------------------------------------------------------------------
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

RegisterNetEvent('tratamento-macas')
AddEventHandler('tratamento-macas',function()
	TriggerEvent("cancelando",true)
	repeat
		SetEntityHealth(PlayerPedId(),GetEntityHealth(PlayerPedId())+5)
		Citizen.Wait(1500)
	until GetEntityHealth(PlayerPedId()) >= 400 or GetEntityHealth(PlayerPedId()) <= 100
	TriggerEvent("Notify","importante","Tratamento concluido.")
	TriggerEvent("cancelando",false)
end)
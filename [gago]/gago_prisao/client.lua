local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local blips = nil
local prisioneiro = false
local reducaopenal = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- PRISIONEIRO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent('prisioneiro')
AddEventHandler('prisioneiro',function(status)
	prisioneiro = status
	reducaopenal = false
	local ped = PlayerPedId()
	if prisioneiro then
		SetEntityInvincible(ped,true)
		FreezeEntityPosition(ped,true)
		SetEntityVisible(ped,false,false)
		SetTimeout(10000,function()
			SetEntityInvincible(ped,false)
			FreezeEntityPosition(ped,false)
			SetEntityVisible(ped,true,false)
		end)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TRY ESCAPE
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5000)
		if prisioneiro then
			local distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),1700.5,2605.2,45.5,true)
			if distance >= 200 then
				SetEntityCoords(PlayerPedId(),1680.1,2513.0,45.5)
				TriggerEvent("Notify","aviso","O agente penitenciário encontrou você tentando escapar.",8000)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- JOB
-----------------------------------------------------------------------------------------------------------------------------------------
local selecionado = 1
local locs = {
	[1] = { 1652.53,2563.94,45.56,2.51 },
	[2] = { 1629.97,2563.90,45.56,2.27 },
	[3] = { 1609.17,2566.87,45.56,48.45 },
	[4] = { 1610.03,2539.81,45.56,134.02 },
	[5] = { 1622.67,2507.77,45.56,93.96 },
	[6] = { 1643.83,2491.00,45.56,185.73 },
	[7] = { 1679.89,2480.62,45.56,133.81 },
	[8] = { 1700.07,2474.96,45.56,224.84 },
	[9] = { 1706.74,2481.33,45.56,227.88 },
	[10] = { 1737.45,2504.93,45.56,164.46 },
	[11] = { 1760.36,2519.16,45.56,254.58 }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- EMSERVICO
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)
		if prisioneiro and not servico then
			local ped = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(ped))
			local distance = Vdist(x,y,z,locs[selecionado][1],locs[selecionado][2],locs[selecionado][3])

			if distance <= 60.0 then
				DrawMarker(21,locs[selecionado][1],locs[selecionado][2],locs[selecionado][3],0,0,0,0,180.0,130.0,1.0,1.0,0.5,255,255,255,100,1,0,0,1)
				if distance <= 1.2 then
					if IsControlJustPressed(0,38) then
						servico = true
						TriggerEvent("cancelando",true)
						TriggerEvent("progress",8000,"trabalhando")
						vRP._playAnim(false,{{"anim@amb@business@coc@coc_packing_hi@","full_cycle_v1_pressoperator"}},true)
						SetEntityHeading(ped,locs[selecionado][4])
						SetTimeout(8000,function()
							servico = false
							TriggerEvent("cancelando",false)
							TriggerServerEvent("diminuirpena")
							vRP._stopAnim(false)
							if DoesBlipExist(blips) then
								RemoveBlip(blips)
							end
							backentrega = selecionado
							while true do
								if backentrega == selecionado then
									selecionado = math.random(#locs)
								else
									break
								end
								Citizen.Wait(10)
							end
							CriandoBlip(locs,selecionado)
						end)
					end
				end
			end
		else
			if DoesBlipExist(blips) then
				RemoveBlip(blips)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNÇÕES
-----------------------------------------------------------------------------------------------------------------------------------------
function CriandoBlip(locs,selecionado)
	blips = AddBlipForCoord(locs[selecionado][1],locs[selecionado][2],locs[selecionado][3])
	SetBlipSprite(blips,430)
	SetBlipColour(blips,14)
	SetBlipScale(blips,0.4)
	SetBlipAsShortRange(blips,false)
	SetBlipRoute(blips,true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Relógio Quebrado")
	EndTextCommandSetBlipName(blips)
end
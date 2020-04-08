-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONEXÃO
-----------------------------------------------------------------------------------------------------------------------------------------
src = {}
Tunnel.bindInterface("vrp_robnpcs",src)
vSERVER = Tunnel.getInterface("vrp_robnpcs")
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNCTIONS
-----------------------------------------------------------------------------------------------------------------------------------------
local rendendo = false
local selectnpc = nil
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		local ped = PlayerPedId()
		local distance = GetDistanceBetweenCoords(GetEntityCoords(ped),-27.45,6504.77,31.4,true)
		if distance <= 10100 then
			local aim,npc = GetEntityPlayerIsFreeAimingAt(PlayerId())
			local distancia = GetDistanceBetweenCoords(GetEntityCoords(ped),GetEntityCoords(npc),true)
			if aim and distancia <= 6.0 then
				if not IsPedDeadOrDying(npc) and not IsPedAPlayer(npc) and not rendendo and not IsPedInAnyVehicle(ped) and not IsPedInAnyVehicle(npc) and GetPedType(npc) ~= 28 and not vSERVER.checkPedlist(npc) and (GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_PISTOL") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_PISTOL_MK2") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_SNSPISTOL") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_VINTAGEPISTOL") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_MACHINEPISTOL") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_REVOLVER") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_HEAVYPISTOL")) then

					rendendo = true
					selectnpc = npc
					vSERVER.pressedPedlist(npc)

					request("random@mugging3")
					request("mp_common")

					ClearPedTasks(npc)
					TaskSetBlockingOfNonTemporaryEvents(npc,true)
					SetEntityAsMissionEntity(npc,true,true)
					FreezeEntityPosition(npc,true)
					TaskPlayAnim(npc,"random@mugging3","handsup_standing_base",8.0,8.0,-1,49,10,0,0,0)
					SetTimeout(10000,function()
						if rendendo then
							selectnpc = nil
							rendendo = false
							vSERVER.checkPayment()
							TaskPlayAnim(npc,"mp_common","givetake1_a",8.0,8.0,-1,49,10,0,0,0)
							Citizen.Wait(1300)
							ClearPedTasks(npc)
							FreezeEntityPosition(npc,false)
							TaskWanderStandard(npc,10.0,10)
						end
					end)
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DIMINUINDO O TEMPO
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		if rendendo then
			local distancia = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),GetEntityCoords(selectnpc),true)
			if distancia >= 6.01 or IsPedDeadOrDying(selectnpc) then
				FreezeEntityPosition(selectnpc,false)
				ClearPedTasks(selectnpc)
				TaskWanderStandard(selectnpc,10.0,10)
				rendendo = false
				selectnpc = nil
			end
		end
	end
end)

function request(dict)
	RequestAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
		Citizen.Wait(10)
	end
end
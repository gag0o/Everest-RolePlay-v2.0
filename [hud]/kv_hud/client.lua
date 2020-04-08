local Config = module('kv_hud', 'config')
-- 3.001 | 10.001 | 25.001 | 50.001
local lastVoice
local voiceSettings = {
	[1] = {3.001, 'SUSSURO'},
	[2] = {10.001, 'NORMAL'},
	[3] = {25.001, 'GRITANDO'}
	-- [4] = {50.001}
}

local lastHealth
--local lastArmour
local lastGear
local lastLightsOn
local lastHighbeamsOn
local lastFuel
local lastPauseMenuIsActive = false
local lastIsPlayerTalking = false

local isOverlappingMenuActive = false
local vehicleHUDopen = false
local changingSeatbeltState = false

local hour
local minute


Citizen.CreateThread(function()
	while true do
		updateHud()

		local isPlayerTalking = NetworkIsPlayerTalking(PlayerId())
		if isPlayerTalking ~= lastIsPlayerTalking then
			lastIsPlayerTalking = isPlayerTalking
			SendNUIMessage(
				{
					micOn = isPlayerTalking
				}
			)
		end

		Citizen.Wait(250)
	end
end)

local sBuffer = {}
local vBuffer = {}
local CintoSeguranca = false
local ExNoCarro = false
local segundos = 0
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)

		HideComponent()

		if IsControlJustPressed(0, 213) then
			lastVoice = lastVoice + 1

			if lastVoice > #voiceSettings then
				lastVoice = 1
			end

			local rangeUnit = voiceSettings[lastVoice][1]

			SendNUIMessage({ micrange = voiceSettings[lastVoice][2] })

			NetworkClearVoiceChannel()
			NetworkSetTalkerProximity(rangeUnit)
		end

		local ped = PlayerPedId()

		if IsPedInAnyVehicle(ped, false) then
			DisplayRadar(true)
		else
			DisplayRadar(false)
		end

		if segundos > 0 and GetEntityHealth(ped) > 100 then
			SetPedToRagdoll(ped, 1000, 1000, 0, 0, 0, 0)
		end

		local car = GetVehiclePedIsIn(ped)

		if car ~= 0 and (ExNoCarro or IsCar(car)) then
			DisplayRadar(true)
			ExNoCarro = true
			if CintoSeguranca then
				DisableControlAction(0, 75)
			end

			sBuffer[2] = sBuffer[1]
			sBuffer[1] = GetEntitySpeed(car)

			if sBuffer[2] ~= nil and not CintoSeguranca and GetEntitySpeedVector(car, true).y > 1.0 and sBuffer[1] > 10.25 and (sBuffer[2] - sBuffer[1]) > (sBuffer[1] * 0.255) then
				local co = GetEntityCoords(ped)
				local fw = Fwv(ped)
				SetEntityHealth(ped, GetEntityHealth(ped) - 150)
				SetEntityCoords(ped, co.x + fw.x, co.y + fw.y, co.z - 0.47, true, true, true)
				SetEntityVelocity(ped, vBuffer[2].x, vBuffer[2].y, vBuffer[2].z)
				segundos = 5
			end

			vBuffer[2] = vBuffer[1]
			vBuffer[1] = GetEntityVelocity(car)

			if not changingSeatbeltState then
				if IsControlJustReleased(1, 47) then
					changingSeatbeltState = true
					if CintoSeguranca then
						TriggerEvent('vrp_sound:source', 'unbelt', 0.5)
						SetTimeout(
							1000,
							function()
								CintoSeguranca = false
								changingSeatbeltState = false
								SendNUIMessage(
									{
										seatbelt = CintoSeguranca
									}
								)
							end
						)
					else
						TriggerEvent('vrp_sound:source', 'belt', 0.5)
						SetTimeout(
							2000,
							function()
								CintoSeguranca = true
								changingSeatbeltState = false
								SendNUIMessage(
									{
										seatbelt = CintoSeguranca
									}
								)
							end
						)
					end
				end
			end
		elseif ExNoCarro then
			ExNoCarro = false
			CintoSeguranca = false
			sBuffer[1], sBuffer[2] = 0.0, 0.0
			changingSeatbeltState = false
		end
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- CONTAGEM
-----------------------------------------------------------------------------------------------------------------------------------------

Citizen.CreateThread(function()
	while true do
		if segundos > 0 then
			segundos = segundos - 1
		end

		CalculateTimeToDisplay()
		Citizen.Wait(1000)
	end
end)
----------------------------------------------------------------------------------------------------------------------------------------
-- AGACHAR
-----------------------------------------------------------------------------------------------------------------------------------------
local agachar = false
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		local ped = PlayerPedId()
		DisableControlAction(0,36,true)
		if not IsPedInAnyVehicle(ped) then
			RequestAnimSet("move_ped_crouched")
			RequestAnimSet("move_ped_crouched_strafing")
			if IsDisabledControlJustPressed(0,36) then
				if agachar then
					ResetPedMovementClipset(ped,0.25)
					ResetPedStrafeClipset(ped)
					agachar = false
				else
					SetPedMovementClipset(ped,"move_ped_crouched",0.25)
					SetPedStrafeClipset(ped,"move_ped_crouched_strafing")
					agachar = true
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- EVENTOS / CALLBACKS
-----------------------------------------------------------------------------------------------------------------------------------------

RegisterNUICallback('getMinimapAnchor', function(data, cb)
	SetScriptGfxAlign(string.byte('L'), string.byte('B'))
	local minimapTopX, minimapTopY = GetScriptGfxPosition(-0.0045, 0.002 + (-0.188888))
	ResetScriptGfxAlign()

	local w, h = GetActiveScreenResolution()

	SendNUIMessage(
		{
			minimapTopX = w * minimapTopX,
			minimapTopY = h * minimapTopY,
			minimapHeight = h * 0.188888
		}
	)

	updateHud()
	CalculateTimeToDisplay()
end)

RegisterNetEvent('status:celular')
AddEventHandler('status:celular', function(status)
	isOverlappingMenuActive = status
	SendNUIMessage(
		{
			show = not status
		}
	)
end)

-- RegisterNetEvent('status:inventario')
-- AddEventHandler('status:inventario',function(status)
-- 	isOverlappingMenuActive = status
-- 	SendNUIMessage(
-- 		{
-- 			show = not status
-- 		}
-- 	)
-- end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNÇÕES
-----------------------------------------------------------------------------------------------------------------------------------------

function IsCar(veh)
	local vc = GetVehicleClass(veh)
	return (vc >= 0 and vc <= 7) or (vc >= 9 and vc <= 12) or (vc >= 17 and vc <= 20)
end

function Fwv(entity)
	local hr = GetEntityHeading(entity) + 90.0
	if hr < 0.0 then
		hr = 360.0 + hr
	end
	hr = hr * 0.0174533
	return {x = math.cos(hr) * 2.0, y = math.sin(hr) * 2.0}
end

function CalculateTimeToDisplay()
	hour = GetClockHours()
	minute = GetClockMinutes()
	if hour <= 9 then
		hour = '0' .. hour
	end
	if minute <= 9 then
		minute = '0' .. minute
	end

	SendNUIMessage(
		{
			date = hour .. ':' .. minute
		}
	)
end

function updateHud()
	if isOverlappingMenuActive == false then
		local pauseMenu = IsPauseMenuActive()
		-- --print(pauseMenu)
		-- if lastPauseMenuIsActive ~= pauseMenu then
		if (lastPauseMenuIsActive == nil and pauseMenu == false) or (lastPauseMenuIsActive ~= nil and lastPauseMenuIsActive ~= pauseMenu) then
			lastPauseMenuIsActive = pauseMenu
			if pauseMenu == true or pauseMenu == 1 then
				SendNUIMessage(
					{
						show = false
					}
				)
			else
				SendNUIMessage(
					{
						show = true
					}
				)
			end
		end

		if lastPauseMenuIsActive == false then
			local ped = PlayerPedId()

			local health = (((GetEntityHealth(ped) - 100) / (GetEntityMaxHealth(ped) - 100)) * 100)

			if lastHealth == nil or lastHealth ~= health then
				SendNUIMessage(
					{
						health = health
					}
				)
				lastHealth = health
			end


		--[[	local armour = GetPedArmour(ped)

			if lastArmour == nil or lastArmour ~= armour then
				SendNUIMessage(
					{
						armour = armour
					}
				)
				lastArmour = armour
			end]]

			local pedVehicle = GetVehiclePedIsIn(ped, false)

			if pedVehicle == 0 then
				if vehicleHUDopen == true then
					SendNUIMessage(
						{
							showVhud = false
						}
					)
					vehicleHUDopen = false
				end
				lastFuel = nil
			else
				if vehicleHUDopen == false then
					SendNUIMessage(
						{
							showVhud = true
						}
					)
					vehicleHUDopen = true
				end

				local gear = GetVehicleCurrentGear(pedVehicle)

				if lastGear == nil or lastGear ~= gear then
					SendNUIMessage(
						{
							gear = gear
						}
					)
				end

				local bool, lightsOn, highbeamsOn = GetVehicleLightsState(pedVehicle)

				if lastLightsOn == nil or lastLightsOn ~= lightsOn or lastHighbeamsOn ~= highbeamsOn then
					SendNUIMessage(
						{
							lightsOn = lightsOn,
							highbeamsOn = highbeamsOn
						}
					)
					lastLightsOn = lightsOn
					lastHighbeamsOn = highbeamsOn
				end

				local vehicleSpeed = math.ceil(GetEntitySpeed(pedVehicle) * 2.236936)

				SendNUIMessage(
					{
						kmh = vehicleSpeed,
						maxSpeed = math.ceil(GetVehicleMaxSpeed(pedVehicle) * 2.236936)
					}
				)

				local fuel = math.ceil(GetVehicleFuelLevel(pedVehicle))

				if lastFuel == nil or lastFuel ~= fuel then
					SendNUIMessage(
						{
							fuel = fuel
						}
					)
					lastFuel = fuel
				end
			end

			if lastVoice == nil then
				lastVoice = 2

				local rangeUnit = voiceSettings[lastVoice][1]

				SendNUIMessage(
					{
						micrange = voiceSettings[lastVoice][2]
					}
				)

				 NetworkClearVoiceChannel()
				NetworkSetTalkerProximity(rangeUnit)
			end
		end
	end
end

Citizen.CreateThread(function()

	while true do
		Citizen.Wait(1000)

		local playerStatus 
		local showPlayerStatus = 0
		playerStatus = { action = 'setStatus', status = {} }

		TriggerServerEvent('kv_hud:getServerInfo')

		if showPlayerStatus > 0 then
			SendNUIMessage(playerStatus)
		end

	end
end)

RegisterNetEvent('kv_hud:setInfo')
AddEventHandler('kv_hud:setInfo', function(info)

	local fome = info['hunger']

	if lastFome == nil or lastFome ~= fome then
		SendNUIMessage(
			{
				hunger = fome
			}
		)
		lastFome = fome
	end

	local sede = info['thirst']

	if lastSede == nil or lastSede ~= sede then
		SendNUIMessage(
			{
				thirst = sede
			}
		)
		lastSede = sede
	end
end)

function HideComponent()
	HideHudComponentThisFrame(6)
	HideHudComponentThisFrame(7)	
	HideHudComponentThisFrame(8)	
	HideHudComponentThisFrame(9)
end

exports('createStatus', function(args)
	local statusCreation = { action = 'createStatus', status = args['status'], color = args['color'], icon = args['icon'] }
	SendNUIMessage(statusCreation)
end)




exports('setStatus', function(args)
	local playerStatus = { action = 'setStatus', status = {
		{ name = args['name'], value = args['value'] }
	}}
	SendNUIMessage(playerStatus)
end) 
-- Config
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")

ykP = Tunnel.getInterface("vrp_rastreador")
local showGPS = true
local alertOnEntry = true
local toggleMouse = false

local status_r = 255
local status_g = 255
local status_b = 255

local blipColor = 4
local blipHeading = true
local blipSprite = 225

local alertSuspect = "Você furtou um veículo com rastreador e ele foi desligado remotamente, os policiais receberam a sua localização."
local successInstalled = "<b>Rastreador</b> instalado com sucesso!"
local errorOutOfVehicle = "Você está fora do veículo ou um rastreador já está instalado."
local errorNoCar = "Veículo não encontrado."
local errorLockedArm = "O veículo precisa ser <b>desarmado</b> antes de instalar o rastreador novamente."
local errorMoving = "O veículo precisa estar parado para instalar o rastreador."

local bcinstalled = false
local vehR = nil
local bctemp = nil
local bctempu = nil
local isDisabled = false
local isUnlocked = false
local suspect = false
local alerted = false
local dashcamActive = false
local allowedToUse = false
local playSounds = true 

RegisterNetEvent('instalarRastreador')
AddEventHandler('instalarRastreador', function()
	if IsPedInAnyVehicle(PlayerPedId(), false) then
		loadAnimDict("anim@veh@std@panto@ds@base")
		TaskPlayAnim(PlayerPedId(), "anim@veh@std@panto@ds@base", "hotwire", 8.0, 1.0, -1, 0, 0, false, false, false)

		if playSounds then
			PlaySoundFrontend(-1, "Bomb_Disarmed", "GTAO_Speed_Convoy_Soundset", 0)
		end

		vehR = GetVehiclePedIsIn(PlayerPedId(), false)
		manageGPS(vehR)
		bcinstalled = true
	else
		TriggerEvent("Notify","negado","É preciso estar dentro do veículo.")
	end
end)

RegisterNetEvent('desativarRastreador')
AddEventHandler('desativarRastreador', function(target)
	bctemp = NetworkGetEntityFromNetworkId(target)
	NetworkRequestControlOfNetworkId(target)
	SetNetworkIdCanMigrate(target, false)
	local targetveh = NetworkGetEntityFromNetworkId(target)
	isDisabled = true
end)

RegisterNetEvent('destravarRastreador')
AddEventHandler('destravarRastreador', function(target)
	NetworkRequestControlOfNetworkId(target)
	SetNetworkIdCanMigrate(target, false)
	bctempu = NetworkGetEntityFromNetworkId(target)
	local targetveh = NetworkGetEntityFromNetworkId(target)
	isDisabled = false
	isUnlocked = true
	SetVehicleDoorsLockedForAllPlayers(targetveh, false)
	suspect = false
	alerted = false
	SetFakeWantedLevel(0)

	if playSounds then
		PlaySoundFrontend(-1, "Breaker_01", "DLC_HALLOWEEN_FVJ_Sounds", 0)
	end
end)

RegisterNetEvent('reativarRastreador')
AddEventHandler('reativarRastreador', function(target)
	isUnlocked = false
	local targetveh = NetworkGetEntityFromNetworkId(target)
	SetVehicleFixed(targetveh)
	SetVehicleEngineOn(targetveh, true, true, false)
	if playSounds then PlaySoundFrontend(-1, "Bomb_Disarmed", "GTAO_Speed_Convoy_Soundset", 0) end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if(isDisabled) then
			if PlayerPedId() then
				if (IsPedSittingInVehicle(PlayerPedId(), bctemp)) then
					suspect = true
					if not alerted then
						TriggerEvent("Notify","importante",""..alertSuspect.."")
						if playSounds then PlaySoundFrontend(-1, "Arming_Countdown", "GTAO_Speed_Convoy_Soundset", 0) end
						SetFakeWantedLevel(5)
						alerted = true
					end
					for i = -1, GetVehicleMaxNumberOfPassengers(bctemp) - 1, 1
					do 
						if (GetPedInVehicleSeat(bctemp, i) == PlayerPedId()) then
							myseat = i
						end
					end
				elseif suspect then
					ClearPedTasksImmediately(PlayerPedId())
					TaskWarpPedIntoVehicle(PlayerPedId(), bctemp, myseat)
				end
				for i = 0, 6, 1
				do 
					SetVehicleDoorShut(bctemp, i, true)
				end
				SetVehicleDoorsLockedForAllPlayers(bctemp, true) 
				SetVehicleEngineHealth(bctemp, -0)
				SetVehicleEngineOn(bctemp, false, true, false)
			end
		elseif(isUnlocked) then
			if PlayerPedId() then
				if (IsPedSittingInVehicle(PlayerPedId(), bctempu)) then
					for i = -1, GetVehicleMaxNumberOfPassengers(bctempu) - 1, 1
					do
						if (GetPedInVehicleSeat(bctempu, i) == PlayerPedId()) then
							myseat = i
						end
					end
				end
				SetVehicleDoorsLockedForAllPlayers(bctempu, false) 
				SetVehicleEngineHealth(bctempu, -0)
				SetVehicleEngineOn(bctempu, false, true, false)
			end
		end
	end
end)

RegisterNetEvent('getNetID_travar')
AddEventHandler('getNetID_travar', function(netID, target)
	if DoesEntityExist(vehR) then
		if isVehicleOccupied(vehR) then
			TriggerServerEvent("netTravar", netID , target)
		else
			TriggerEvent("Notify","negado","Você está tentando desarmar um carro não protegido.")
		end
	else
		TriggerEvent("Notify","negado","Nenhum veículo encontrado.")
	end
end)

RegisterNetEvent('getNetID_destravar')
AddEventHandler('getNetID_destravar', function(netID, target)
	if DoesEntityExist(vehR) then
		TriggerServerEvent("netDestravar", netID, target)
	else
		TriggerEvent("Notify","negado","Nenhum veículo encontrado.")
	end
end)

RegisterNetEvent('getNetID_reativar')
AddEventHandler('getNetID_reativar', function(netID, target)
	if DoesEntityExist(vehR) then
		if isDisabled == false then
			TriggerServerEvent("netReativar", netID, target)
			TriggerEvent('reparar',source)
		elseif isUnlocked == false then
			TriggerServerEvent("netReativar", netID, target)
		else
			TriggerEvent("Notify","negado",""..errorLockedArm.."")
		end
	else
		TriggerEvent("Notify","negado",""..errorNoCar.."")
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if DoesEntityExist(vehR) then
			if isVehicleOccupied(vehR) and alertOnEntry then
				if not dashcamActive and not IsPedInVehicle(PlayerPedId(), vehR, true) then drawTxt2(1.0, 1.45, 1.0, 1.0, 0.45, "Veículo seguro ocupado.", status_r, status_g, status_b, 255) end
			end	
		end	
	end
end)

function manageGPS(veh)
	if showGPS and DoesEntityExist(veh) then 
		if not DoesBlipExist(blip) then blip = AddBlipForEntity(veh) end
		SetBlipSprite(blip, blipSprite)
		SetBlipColour(blip, blipColor)
		SetBlipAlpha(blip, 255)
		SetBlipRoute(blip,  true)
		ShowHeadingIndicatorOnBlip(blip, blipHeading)
	elseif DoesBlipExist(blip) then
		RemoveBlip(blip)
	end
end

local cameraHandle = nil
local shader = "scanline_cam_cheap"

Citizen.CreateThread(function()
	while true do
		if dashcamActive then
			local bonPos = GetWorldPositionOfEntityBone(vehR, GetEntityBoneIndexByName(vehR, "windscreen"))
			local vehRot = GetEntityRotation(vehR, 0)
			SetCamCoord(cameraHandle, bonPos.x , bonPos.y, bonPos.z)
			SetCamRot(cameraHandle, vehRot.x - 180.0, -vehRot.y -180.0, vehRot.z, 0)
		DisableControlAction(0, 75)
		end
		Citizen.Wait(1)
	end
end)

function EnableDash()
	SetTimecycleModifier(shader)
	local cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
	RenderScriptCams(1, 0, 0, 1, 1)
	SetFocusEntity(vehR)
	cameraHandle = cam
	dashcamActive = true
end

function DisableDash()
	ClearTimecycleModifier(shader)
	RenderScriptCams(0, 0, 1, 1, 1)
	DestroyCam(cameraHandle, false)
	SetFocusEntity(GetPlayerPed(PlayerId()))
	dashcamActive = false
end


RegisterCommand("rastreador",function(source,args)
	
	if args[1] == "instalar" then
		if IsPedInAnyVehicle(PlayerPedId(), false) and not IsPedInVehicle(PlayerPedId(), vehR) then
			if GetEntitySpeed(GetVehiclePedIsIn(PlayerPedId())) <= 0.5 then
				local veh,vehNet,placa,vName = vRP.vehList()
				if not ykP.checkRastreio(veh,vehNet,placa,vName) then
					if ykP.checkItem(veh,vehNet,placa,vName) then
					TriggerEvent('instalarRastreador')
					TriggerEvent("Notify","sucesso",""..successInstalled.."")
					end
				else
					TriggerEvent("Notify","negado","Você já possui um rastreador instalado neste veículo.")
				end
			else
			TriggerEvent("Notify","negado",""..errorMoving.."")
			end
		else
			TriggerEvent("Notify","negado",""..errorOutOfVehicle.."")
		end
	end
	if args[1] == "ligar" then
		if IsPedInAnyVehicle(PlayerPedId(), false) and not IsPedInVehicle(PlayerPedId(), vehR) then
			if GetEntitySpeed(GetVehiclePedIsIn(PlayerPedId())) <= 0.5 then
				local veh,vehNet,placa,vName = vRP.vehList()
				if ykP.checkRastreio(veh,vehNet,placa,vName) then
				TriggerEvent('instalarRastreador')
				TriggerEvent("Notify","sucesso","O rastreador está ligado.")
				end
			else
			TriggerEvent("Notify","negado",""..errorMoving.."")
			end
		else
			TriggerEvent("Notify","negado",""..errorOutOfVehicle.."")
		end
	end
	if args[1] == "travar" then
		if DoesEntityExist(vehR) then
			targetveh =	NetworkGetNetworkIdFromEntity(vehR)
			targetPed = GetPlayerServerId(NetworkGetPlayerIndexFromPed(GetPedInVehicleSeat(vehR, -1)))
			TriggerEvent('getNetID_travar', targetveh, targetPed)
		else
			TriggerEvent("Notify","negado",""..errorNoCar.."")
		end
	end
	if args[1] == "destravar" then
		if DoesEntityExist(vehR) then
			targetveh =	NetworkGetNetworkIdFromEntity(vehR)
			targetPed = GetPlayerServerId(NetworkGetPlayerIndexFromPed(GetPedInVehicleSeat(vehR, -1)))
			TriggerEvent('getNetID_destravar', targetveh, targetPed)
			TriggerEvent("Notify","sucesso","Veículo destrancado.")
		else
			TriggerEvent("Notify","negado",""..errorNoCar.."")
		end
	end
--[[ 	if args[1] == "reparar" then
		if DoesEntityExist(vehR) then
			targetveh =	NetworkGetNetworkIdFromEntity(vehR)
			targetPed = GetPlayerServerId(NetworkGetPlayerIndexFromPed(GetPedInVehicleSeat(vehR, -1)))
			TriggerEvent('getNetID_reativar', targetveh, targetPed)
			TriggerEvent("Notify","sucesso","Veículo reparado.")
		else
			TriggerEvent("Notify","negado",""..errorNoCar.."")
		end
	end ]]

	if args[1] == "camera" then
		if DoesEntityExist(vehR) then
			if dashcamActive then
				DisableDash()
			else
				EnableDash()
			end
			TriggerEvent("Notify","sucesso","Alternando camêras de vídeo.")
		else
			TriggerEvent("Notify","negado",""..errorNoCar.."")
		end
	end
end)


function isVehicleOccupied(veh)
	local passenger = false
	for i = -1, GetVehicleMaxNumberOfPassengers(veh) - 1, 1
	do 
		if (GetPedInVehicleSeat(veh, i) ~= 0) then
			passenger = true
		end
	end
	return passenger
end

function drawTxt(x,y ,width,height,scale, text, r,g,b,a)
	SetTextFont(4)
	SetTextProportional(0)
	SetTextScale(scale, scale)
	SetTextColour(r, g, b, a)
	SetTextDropShadow(0, 0, 0, 0,255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x - width/2, y - height/2 + 0.005)
end

function drawTxt2(x,y ,width,height,scale, text, r,g,b,a)
		SetTextFont(6)
		SetTextProportional(0)
		SetTextScale(scale, scale)
		SetTextColour(r, g, b, a)
		SetTextDropShadow(0, 0, 0, 0,255)
		SetTextEdge(1, 0, 0, 0, 255)
		SetTextDropShadow()
		SetTextOutline()
		SetTextEntry("STRING")
		AddTextComponentString(text)
		DrawText(x - width/2, y - height/2 + 0.005)
end

function loadAnimDict(dict)
	while (not HasAnimDictLoaded(dict)) do
		RequestAnimDict(dict)
		Citizen.Wait(5)
	end
end
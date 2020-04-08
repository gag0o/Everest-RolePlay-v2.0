local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
func = Tunnel.getInterface("emp_trafico_ilegal")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- TELEPORT 
-----------------------------------------------------------------------------------------------------------------------------------------
--[[ local Teleport = {
	["TRAFICO01"] = {
		positionFrom = { ['x'] = -119.98, ['y'] = -612.42, ['z'] = 36.28, ['perm'] = "admin.permissao" },
		positionTo = { ['x'] = -141.24, ['y'] = -614.47, ['z'] = 168.82, ['perm'] = "admin.permissao" }
	},
}

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		for k,v in pairs(Teleport) do
			local ped = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(ped))
			local bowz,cdz = GetGroundZFor_3dCoord(v.positionFrom.x,v.positionFrom.y,v.positionFrom.z)
			local distance = GetDistanceBetweenCoords(v.positionFrom.x,v.positionFrom.y,cdz,x,y,z,true)
			local bowz,cdz2 = GetGroundZFor_3dCoord(v.positionTo.x,v.positionTo.y,v.positionTo.z)
			local distance2 = GetDistanceBetweenCoords(v.positionTo.x,v.positionTo.y,cdz2,x,y,z,true)

			if distance <= 10 then
				DrawMarker(23,v.positionFrom.x,v.positionFrom.y,v.positionFrom.z-0.97,0,0,0,0,0,0,1.0,1.0,0.5,217,217,25,0,0,0,0,0)
				if distance <= 1.5 then
					if IsControlJustPressed(0,38) and func.checkPermission(v.positionTo.perm) then
						SetEntityCoords(PlayerPedId(),v.positionTo.x,v.positionTo.y,v.positionTo.z-0.50)
					end
				end
			end

			if distance2 <= 10 then
				DrawMarker(23,v.positionTo.x,v.positionTo.y,v.positionTo.z-1,0,0,0,0,0,0,1.0,1.0,1.0,240,200,80,0,0,0,0,0)
				if distance2 <= 1.5 then
					if IsControlJustPressed(0,38) and func.checkPermission(v.positionFrom.perm) then
						SetEntityCoords(PlayerPedId(),v.positionFrom.x,v.positionFrom.y,v.positionFrom.z-0.50)
					end
				end
			end
		end
	end
end) ]]
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local processo = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- LOCAIS 
-----------------------------------------------------------------------------------------------------------------------------------------
local locais = {
	--{ ['id'] = 1, ['x'] = -1109.5676269531, ['y'] = 4949.7456054688, ['z'] = 218.64973449707, ['text'] = "FOLHADECOCA", ['perm'] = "vagos.permissao" },
	{ ['id'] = 2, ['x'] = -1107.7684326172, ['y'] = 4939.4853515625, ['z'] = 218.64973449707, ['text'] = "PASTADECOCA", ['perm'] = "ballas.permissao" }, 
	{ ['id'] = 3, ['x'] = -1106.1566162109, ['y'] = 4946.7177734375, ['z'] = 218.64973449707, ['text'] = "COCAÍNA", ['perm'] = "ballas.permissao" }, 

	--{ ['id'] = 4, ['x'] = 99.836387634277, ['y'] = 6344.4326171875, ['z'] = 31.375883102417, ['text'] = "ADUBO", ['perm'] = "groove.permissao" }, 
	{ ['id'] = 5, ['x'] = 94.383850097656, ['y'] = 6348.3989257813, ['z'] = 31.375888824463, ['text'] = "FERTILIZANTE", ['perm'] = "groove.permissao" }, 
	{ ['id'] = 6, ['x'] = 114.30159759521, ['y'] = 6360.2065429688, ['z'] = 32.305633544922, ['text'] = "MACONHA", ['perm'] = "groove.permissao" },

	--{ ['id'] = 7, ['x'] = 1505.1885986328, ['y'] = 6392.0893554688, ['z'] = 20.783924102783, ['text'] = "METIL", ['perm'] = "vagos.permissao" }, 
	{ ['id'] = 8, ['x'] = 1493.294921875, ['y'] = 6390.3129882813, ['z'] = 21.257772445679, ['text'] = "CRYSTALMELAMINE", ['perm'] = "vagos.permissao" },
	{ ['id'] = 9, ['x'] = 1494.5162353516, ['y'] = 6395.3823242188, ['z'] = 20.783899307251, ['text'] = "METANFETAMINA", ['perm'] = "vagos.permissao" },

  	{ ['id'] = 10, ['x'] = 1005.79, ['y'] = -3200.35, ['z'] = -38.51, ['text'] = "BEBIDAFERMENTADA", ['perm'] = "bahamas.permissao" },
	{ ['id'] = 11, ['x'] = 1011.36, ['y'] = -3197.09, ['z'] = -38.99, ['text'] = "MOONSHINE", ['perm'] = "bahamas.permissao" },

	--{ ['id'] = 12, ['x'] = 1389.94, ['y'] = 3608.76, ['z'] = 38.95, ['text'] = "CRACK", ['perm'] = "crips.permissao" }, 


} 
-----------------------------------------------------------------------------------------------------------------------------------------
-- PRODUZIR
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		for k,v in pairs(locais) do
			local ped = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(ped))
			local bowz,cdz = GetGroundZFor_3dCoord(v.x,v.y,v.z)
			local distance = GetDistanceBetweenCoords(v.x,v.y,cdz,x,y,z,true)
			if distance <= 2.0 and not processo then
				drawTxt("PRESSIONE  ~b~E~w~  PARA COLETAR "..v.text,4,0.5,0.93,0.50,255,255,255,180)
				if IsControlJustPressed(0,38) and func.checkPermission(v.perm) then
					if func.checkPayment(v.id) then
						processo = true
						vRP.playAnim(true,{{"mini@repair","fixing_a_player"}},true)
						TriggerEvent('cancelando',true)
						TriggerEvent("progress",10000,"coletando")
						SetTimeout(10000,function()
							processo = false
							TriggerEvent('cancelando',false)
							vRP._stopAnim(source,false)
							vRP._DeletarObjeto(source)
						end)
					end
				end
			end
		end
	end
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

















--[[ DESATIVADO
    { ['id'] = 10, ['x'] = 901.53454589844, ['y'] = -3219.3286132813, ['z'] = -98.242530822754, ['text'] = "CAPSULA", ['perm'] = "motoclub.permissao" },
	{ ['id'] = 11, ['x'] = 907.91235351563, ['y'] = -3211.3962402344, ['z'] = -98.222061157227, ['text'] = "POLVORA", ['perm'] = "motoclub.permissao" }, 
	{ ['id'] = 12, ['x'] = 896.90856933594, ['y'] = -3217.5610351563, ['z'] = -98.227172851563, ['text'] = "MUNIÇÃO", ['perm'] = "motoclub.permissao" },

	{ ['id'] = 14, ['x'] = 819.67022705078, ['y'] = -2155.4133300781, ['z'] = 29.619016647339, ['text'] = "PEÇAS", ['perm'] = "mafia.permissao" }, 
	{ ['id'] = 15, ['x'] = 826.70434570313, ['y'] = -2149.46875, ['z'] = 29.619016647339, ['text'] = "COMPONENTES", ['perm'] = "mafia.permissao" },

	{ ['id'] = 17, ['x'] = 1692.9901123047, ['y'] = 3762.5649414063, ['z'] = 34.705352783203, ['text'] = "PEÇAS", ['perm'] = "betainc.permissao" }, 
	{ ['id'] = 18, ['x'] = 1696.6053466797, ['y'] = 3760.6784667969, ['z'] = 34.7053565979, ['text'] = "COMPONENTES", ['perm'] = "betainc.permissao" },
	
	{ ['id'] = 20, ['x'] = 1070.2265625, ['y'] = -202.43980407715, ['z'] = 71.301536560059, ['text'] = "DADOS DE ACESSO", ['perm'] = "yakuza.permissao" }, 
	{ ['id'] = 21, ['x'] = 1071.1599121094, ['y'] = -192.47134399414, ['z'] = 71.302001953125, ['text'] = "LOGS DE INVASÃO", ['perm'] = "yakuza.permissao" },

	{ ['id'] = 22, ['x'] = 1098.849609375, ['y'] = -3142.1345214844, ['z'] = -37.518577575684, ['text'] = "CAPSULA", ['perm'] = "motoclub2.permissao" },
	{ ['id'] = 23, ['x'] = 1109.9645996094, ['y'] = -3150.6264648438, ['z'] = -37.518577575684, ['text'] = "POLVORA", ['perm'] = "motoclub2.permissao" }, 
	{ ['id'] = 24, ['x'] = 1122.6655273438, ['y'] = -3161.6608886719, ['z'] = -36.870498657227, ['text'] = "MUNIÇÃO", ['perm'] = "motoclub2.permissao" } 
]]
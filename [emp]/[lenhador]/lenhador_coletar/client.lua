local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
emP = Tunnel.getInterface("lenhador_coletar")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local list = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- CORDENADAS DAS ARVORES
-----------------------------------------------------------------------------------------------------------------------------------------
local arvores = {
	{ 1578.97,4538.94,18.98 },
	{ 1572.79,4520.81,19.07 },
	{ 1575.64,4517.89,19.24 },
	{ 1574.02,4513.43,19.98 },
	{ 1572.27,4503.38,21.09 },
	{ 1577.34,4504.02,20.82 },
	{ 1580.87,4495.17,21.35 },
	{ 1586.38,4500.06,20.75 },
	{ 1591.82,4503.67,20.38 },
	{ -1592.93,4501.04,20.44 },
	{ -1596.97,4496.67,20.07 },
	{ -1597.50,4487.70,18.69 },
	{ -1602.40,4480.68,16.42 },
	{ -1603.45,4483.81,17.05 },
	{ -1605.55,4485.84,17.09 },
	{ -1592.38,4484.62,17.17 },
	{ -1591.48,4481.66,16.31 },
	{ -1589.24,4487.65,18.72 },
	{ -1584.40,4491.20,20.81 },
	{ -1574.44,4496.91,21.73 },
	{ -1574.99,4491.95,22.53 },
	{ -1576.33,4485.01,22.22 },
	{ -1578.53,4511.93,19.95 },
	{ -1581.35,4513.32,19.59 },
	{ -1583.85,4515.67,19.07 },
	{ -1585.75,4517.67,18.66 },
	{ -1592.67,4516.29,17.82 },
	{ -1591.53,4513.23,18.69 },
	{ -1599.65,4509.46,18.32 },
	{ -1605.21,4508.43,17.04 },
	{ -1599.58,4517.08,16.56 },
	{ -1585.39,4509.44,19.97 },
	{ -1589.57,4507.30,20.12 },
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- PROCESSO
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	vRP._stopAnim(false)
	TriggerEvent('cancelando',false)
	local time = 1
	
	while true do
		
		Citizen.Wait(time)
		time = 3000

		if not processo then
			for i,func in pairs(arvores) do
				local ped = PlayerPedId()
				local x,y,z = table.unpack(func)
				local distancia = GetDistanceBetweenCoords(GetEntityCoords(ped),x,y,z)
				if distancia <= 30 and list[i] == nil then
					time = 1
					DrawMarker(21,x,y,z,0,0,0,0,180.0,130.0,0.6,0.8,0.5,255,255,255,25,1,0,0,1)
					if distancia <= 1.2 then
						drawTxt("PRESSIONE ~b~E~w~ PARA CORTAR MADEIRA",4,0.5,0.93,0.50,255,255,255,180)
						if IsControlJustPressed(0,38) then
							if GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_HATCHET") or GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_BATTLEAXE") then
								local qtd = emP.checkPayment()
								if qtd > 0 then
									list[i] = true
									
									SetEntityCoords(ped,x,y,z-1)
									SetEntityHeading(ped,100.0)
									TriggerEvent('cancelando',true)
									vRP._playAnim(false,{{"melee@hatchet@streamed_core","plyr_front_takedown_b"}},true)
									TriggerEvent("progress",3000,"COLETANDO MADEIRA")
									Citizen.Wait(3000)
									vRP._stopAnim(false)
									TriggerEvent('cancelando',false)
									TriggerEvent("Notify","sucesso","Coletou  <b>"..qtd.."x Toras de madeira</b>.",8000)
								else
									TriggerEvent("Notify","aviso","Inventário cheio!",8000)
								end
							end
						end
					end
				end
			end
		end
	
	end
end)


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(180000)
		list = {}
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
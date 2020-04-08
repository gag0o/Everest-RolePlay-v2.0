local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
func = {}
Tunnel.bindInterface("gago_mechmission",func)

local cars = {0}

function func.quantidade(qtd)
	qtd = qtd
	table.insert(cars,1,qtd)
	--print(table.unpack(cars))
end	

function func.removequantidade(qtd2)
	qtd2 = qtd2
	--table.remove(cars,qtd2)
end	

function func.checkqunatidade(qtd)
	for i = 1,#cars do
		if cars[i] ~= qtd then
			return true
		end	
	end	
end	

function func.moneyaward(amount)
	local user_id = vRP.getUserId(source)
	vRP.giveMoney(user_id,amount)
	TriggerClientEvent("Notify", source, "sucesso","Você ganhou <b>$"..amount.."</b>")
end	
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
local Tools = module("vrp","lib/Tools")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")

emP = {}
Tunnel.bindInterface("emp_drogas_entrega",emP)
local idgens = Tools.newIDGenerator()
------------------------------------------------------------------------
-- FUNÇÕES
------------------------------------------------------------------------
function emP.checkPermission()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if not vRP.hasPermission(user_id,"vagos.permissao") or vRP.hasPermission(user_id,"ballas.permissao") or vRP.hasPermission(user_id,"groove.permissao") then
			return true
		else
			TriggerClientEvent("Notify",source,"negado","Sai Para la Safado,Não vou te entregar a lista")
			return false
		end						
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local quantidade = {}
local quantia = 0

RegisterServerEvent('event:GetDrogas')
AddEventHandler('event:GetDrogas', function()
	quantia = math.random(5,5)
	TriggerClientEvent('event:SetDrogas', source, quantia)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- QUANTIDADE
-----------------------------------------------------------------------------------------------------------------------------------------
function emP.Quantidade()
	local source = source
	if quantidade[source] == nil then
		quantidade[source] = quantia
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECAGEM
-----------------------------------------------------------------------------------------------------------------------------------------
function emP.checkItens()
	emP.Quantidade()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.getInventoryItemAmount(user_id,"cocaina") > 1 and not vRP.hasPermission(user_id,"ballas.permissao") then
			return vRP.getInventoryItemAmount(user_id,"cocaina") >= quantidade[source]
		end
		if vRP.getInventoryItemAmount(user_id,"maconha") > 1  and not vRP.hasPermission(user_id,"groove.permissao") then
			return vRP.getInventoryItemAmount(user_id,"maconha") >= quantidade[source]
		end
		if vRP.getInventoryItemAmount(user_id,"metanfetamina") > 1  and not vRP.hasPermission(user_id,"vagos.permissao") then
			return vRP.getInventoryItemAmount(user_id,"metanfetamina") >= quantidade[source]
		end
		if vRP.getInventoryItemAmount(user_id,"moonshine") > 1  and not vRP.hasPermission(user_id,"bahamas.permissao") then
			return vRP.getInventoryItemAmount(user_id,"moonshine") >= quantidade[source]
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PAGAMENTO
-----------------------------------------------------------------------------------------------------------------------------------------
function emP.checkPayment()
	emP.Quantidade()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local policia = vRP.getUsersByPermission("policia.permissao")
		if vRP.tryGetInventoryItem(user_id,"cocaina",quantidade[source]) or vRP.tryGetInventoryItem(user_id,"maconha",quantidade[source]) or vRP.tryGetInventoryItem(user_id,"metanfetamina",quantidade[source]) or vRP.tryGetInventoryItem(user_id,"moonshine",quantidade[source]) then
			local pagamento = math.random(600,650)*quantidade[source]+(#policia*5)
			vRP.giveInventoryItem(user_id,"dinheirosujo",pagamento)
			TriggerClientEvent("Notify",source,"sucesso","Você recebeu <b>$"..pagamento.." dólares</b>.")
			TriggerClientEvent("vrp_sound:source",source,'coins',0.5)
			vRPclient._playAnim(source,true,{{"mp_common","givetake1_a"}},false)
			quantidade[source] = nil 
			return true
		else
			TriggerClientEvent("Notify",source,"aviso","Você precisa de <b>"..quantidade[source].."x Drogas.</b>")
		end
	end
end

function emP.MarcarOcorrencia()
	local source = source
	local user_id = vRP.getUserId(source)
	local x,y,z = vRPclient.getPosition(source)
	if user_id then
		--TriggerClientEvent("Notify",source,"aviso","A policia foi acionada.")
		TriggerEvent("global:avisarPolicia", "Recebemos uma denuncia de drogas, verifique o ocorrido.",x,y,z, 1)
	end
end
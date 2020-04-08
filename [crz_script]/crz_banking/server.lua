local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
-----------------------------------------------------------------------------------------------------------------------------------------
-- WEB-OKC
-----------------------------------------------------------------------------------------------------------------------------------------
local DISCORD_WEBHOOK = "https://discordapp.com/api/webhooks/658485600164380682/Gdbd40PQhaVLgYI7Henp46ytyNL6BCiPBBcv2E5eIXzdff5ehBQpfnJD1ATSwxAS1trj"
local DISCORD_NAME = "EVEREST ROLEPLAY"
--local STEAM_KEY = ""
local DISCORD_IMAGE = "https://pbs.twimg.com/profile_images/847824193899167744/J1Teh4Di_400x400.jpg" -- default is FiveM logo
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNCAO
-----------------------------------------------------------------------------------------------------------------------------------------
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")


RegisterServerEvent('bank:deposit')
AddEventHandler('bank:deposit', function(amount)
	local thePlayer = source
	
	local user_id = vRP.getUserId(thePlayer)
	local walletMoney = vRP.getMoney(user_id)
	local bankMoney = vRP.getBankMoney(user_id)
	if(tonumber(amount))then
		if(vRP.tryPayment(user_id, amount))then
			vRP.setBankMoney(user_id, bankMoney+amount)
			vRP.setMoney(user_id, walletMoney-amount)
			TriggerClientEvent("Notify",thePlayer,"sucesso","Depositou <b>$"..vRP.format(parseInt(amount)).." reais</b> na sua conta bancária.")
			sendToDiscord("BANCO DIGITAL", "[ID]: "..vRP.getUserId(thePlayer).. "\n[Depositou]: $ "..amount, 16711680)
		else
			TriggerClientEvent("Notify",thePlayer,"negado","Você não tem dinheiro suficiente.")
		end
	else
		TriggerClientEvent("Notify",thePlayer,"negado","Número inválido.")
	end
end)


RegisterServerEvent('bank:withdraw')
AddEventHandler('bank:withdraw', function(amount)
	local thePlayer = source
	
	local user_id = vRP.getUserId(thePlayer)
	local walletMoney = vRP.getMoney(user_id)
	local bankMoney = vRP.getBankMoney(user_id)
	if(tonumber(amount))then	
		amount = tonumber(amount)
		if(amount > 0 and amount <= bankMoney)then
			vRP.setBankMoney(user_id, bankMoney-amount)
			vRP.setMoney(user_id, walletMoney+amount)
			TriggerClientEvent("Notify",thePlayer,"sucesso","Sacou <b>$"..vRP.format(parseInt(amount)).." reais</b> da sua conta bancária.")
			sendToDiscord("BANCO DIGITAL", "[ID]: "..vRP.getUserId(thePlayer).. "\n[Retirou]: $ "..amount, 16711680)
		else
			TriggerClientEvent("Notify",thePlayer,"negado","Não possui <b>$"..vRP.format(parseInt(amount)).." reais</b> em sua conta bancária.")
		end
	else
		TriggerClientEvent("Notify",thePlayer,"aviso","Passaporte não encontrado.")
	end
end)

RegisterServerEvent('bank:balance')
AddEventHandler('bank:balance', function()
	local thePlayer = source
	
	local user_id = vRP.getUserId(thePlayer)
	local bankMoney = vRP.getBankMoney(user_id)
	TriggerClientEvent('currentbalance1', thePlayer, bankMoney)
end)


RegisterServerEvent('bank:transfer')
AddEventHandler('bank:transfer', function(to, amount)
	local thePlayer = source
	local user_id = vRP.getUserId(thePlayer)
	if(tonumber(to)  and to ~= "" and to ~= nil)then
		to = tonumber(to)
		theTarget = vRP.getUserSource(to)
		if(theTarget)then
			if(thePlayer == theTarget)then
				TriggerClientEvent("Notify",thePlayer,"negado","Não pode transferir para você mesmo.")
			else
				if(tonumber(amount) and tonumber(amount) > 0 and amount ~= "" and amount ~= nil)then
					amount = tonumber(amount)
					bankMoney = vRP.getBankMoney(user_id)
					if(bankMoney >= amount)then
						newBankMoney = tonumber(bankMoney - amount)
						vRP.setBankMoney(user_id, newBankMoney)
						vRP.giveBankMoney({to, amount})
						TriggerClientEvent("Notify",thePlayer,"sucesso","Você transferiu <b>$"..vRP.format(parseInt(amount)).." reais</b> para" ..GetPlayerName(theTarget))
						sendToDiscord("BANCO DIGITAL", "[ID]: "..vRP.getUserId(thePlayer).. "\n[Transferiu]: $ "..amount, 16711680)
						TriggerClientEvent("Notify",theTarget,"sucesso","Transferencia Efetuada <b>$"..vRP.format(parseInt(amount)).." reais</b> para" ..GetPlayerName(thePlayer))
					else
						TriggerClientEvent("Notify",thePlayer,"negado","Você não tem dinheiro suficiente.")
					end
				else
					TriggerClientEvent("Notify",thePlayer,"negado","Passaporte inválido.")
				end
			end
		else
			TriggerClientEvent("Notify",thePlayer,"aviso","Passaporte não encontrado ou indisponível no momento.")
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- WEB-OKC
-----------------------------------------------------------------------------------------------------------------------------------------
function GetIDFromSource(Type, ID) --(Thanks To WolfKnight [forum.FiveM.net])
    local IDs = GetPlayerIdentifiers(ID)
    for k, CurrentID in pairs(IDs) do
        local ID = stringsplit(CurrentID, ':')
        if (ID[1]:lower() == string.lower(Type)) then
            return ID[2]:lower()
        end
    end
    return nil
end

function stringsplit(input, seperator)
	if seperator == nil then
		seperator = '%s'
	end
	
	local t={} ; i=1
	
	for str in string.gmatch(input, '([^'..seperator..']+)') do
		t[i] = str
		i = i + 1
	end
	
	return t
end

function sendToDiscord(name, message, color)
  local connect = {
        {
            ["color"] = color,
            ["title"] = "**".. name .."**",
            ["description"] = message,
            ["footer"] = {
                ["text"] = "EVEREST-RP",
            },
        }
    }
  PerformHttpRequest(DISCORD_WEBHOOK, function(err, text, headers) end, 'POST', json.encode({username = DISCORD_NAME, embeds = connect, avatar_url = DISCORD_IMAGE}), { ['Content-Type'] = 'application/json' })
end
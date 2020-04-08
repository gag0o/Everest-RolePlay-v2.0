--====================================================================================
--  Function APP bank
--====================================================================================

--[[
      Appeller SendNUIMessage({event = 'updatebankbalance', banking = xxxx})
      à la connection & à chaque changement du compte
--]]

-- ES / ESX Implementation

local bank = 0
function setbankBalance (value)
      bank = value
      SendNUIMessage({event = 'bank', bank = bank})
end

RegisterNetEvent('es:playerLoaded')
AddEventHandler('es:playerLoaded', function(playerData)
      local accounts = playerData.accounts or {}
      for index, account in ipairs(accounts) do 
            if account.name == 'bank' then
                  setbankBalance(account.money)
                  break
            end
      end
end)

RegisterNetEvent('es:setAccountMoney')
AddEventHandler('es:setAccountMoney', function(account)
      if account.name == 'bank' then
            setbankBalance(account.money)
      end
end)

RegisterNetEvent("es:addedbank")
AddEventHandler("es:addedbank", function(m)
      setbankBalance(bank + m)
end)

RegisterNetEvent("es:removedbank")
AddEventHandler("es:removedbank", function(m)
      setbankBalance(bank - m)
end)

RegisterNetEvent('es:displaybank')
AddEventHandler('es:displaybank', function(bank)
      setbankBalance(bank)
end)

RegisterNetEvent('vrp:displaybank')
AddEventHandler('vrp:displaybank', function(bank)
      setbankBalance(bank)
end)
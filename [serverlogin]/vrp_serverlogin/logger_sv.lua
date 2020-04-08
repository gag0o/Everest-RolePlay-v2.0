local logs = "https://discordapp.com/api/webhooks/676637190196953089/gvdtSx6-uOjW1ElHr4KVrqHwzfK7X0dwjpzrfuiJU3t45NV3xUWD3I518rmj6Ttwt_CU"
local communityname = "Everest Roleplay"
local communtiylogo = "https://cdn.discordapp.com/attachments/668188821166227497/676636494064255016/EVEREST.png" --Must end with .png

AddEventHandler('playerConnecting', function()
local name = GetPlayerName(source)
local ip = GetPlayerEndpoint(source)
local ping = GetPlayerPing(source)
local steamhex = GetPlayerIdentifier(source)
local connect = {
        {
            ["color"] = "65280",
            ["title"] = "Server Login",
            ["description"] = "Jogador: **"..name.."**\nIP: **"..ip.."**\n Steam Hex: **"..steamhex.."**",
	        ["footer"] = {
                ["text"] = communityname,
                ["icon_url"] = communtiylogo,
            },
        }
    }

PerformHttpRequest(logs, function(err, text, headers) end, 'POST', json.encode({username = "Assistente de Login", embeds = connect}), { ['Content-Type'] = 'application/json' })
end)

AddEventHandler('playerDropped', function(reason)
local name = GetPlayerName(source)
local ip = GetPlayerEndpoint(source)
local ping = GetPlayerPing(source)
local steamhex = GetPlayerIdentifier(source)
local disconnect = {
        {
            ["color"] = "16711680",
            ["title"] = "Server Logout",
            ["description"] = "Jogador: **"..name.."** \nRazão: **"..reason.."**\nIP: **"..ip.."**\n Steam Hex: **"..steamhex.."**",
	        ["footer"] = {
                ["text"] = communityname,
                ["icon_url"] = communtiylogo,
            },
        }
    }

    PerformHttpRequest(logs, function(err, text, headers) end, 'POST', json.encode({username = "Assistente de Login", embeds = disconnect}), { ['Content-Type'] = 'application/json' })
end)

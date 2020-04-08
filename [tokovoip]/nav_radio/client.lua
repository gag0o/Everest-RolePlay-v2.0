local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
emP = Tunnel.getInterface("nav_radio")
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNCTION
-----------------------------------------------------------------------------------------------------------------------------------------
local menuactive = false
function ToggleActionMenu()
    menuactive = not menuactive
    if menuactive then
        SetNuiFocus(true, true)
        SendNUIMessage({showmenu = true})
    else
        SetNuiFocus(false)
        SendNUIMessage({hidemenu = true})
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- BUTTON
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("ButtonClick", function(data, cb)
    if data == "moderador" then
        if emP.checkPermission("moderador.permissao", "Administracão") then
            outServers()
            exports.tokovoip_script:addPlayerToRadio(1)
        end
    elseif data == "policia" then
        if emP.checkPermission("policia.permissao", "Polícia") then
            outServers()
            exports.tokovoip_script:addPlayerToRadio(2)
        end
    elseif data == "paramedico" then
        if emP.checkPermission("paramedico.permissao", "Paramédicos") then
            outServers()
            exports.tokovoip_script:addPlayerToRadio(3)
        end
    elseif data == "mecanico" then
        if emP.checkPermission("mecanico.permissao", "Mecânicos") then
            outServers()
            exports.tokovoip_script:addPlayerToRadio(4)
        end

    elseif data == "Vanilla" then
        if emP.checkPermission("vanilla.permissao", "Vanilla") then
            outServers()
            exports.tokovoip_script:addPlayerToRadio(5)
        end
    elseif data == "bennys" then
        if emP.checkPermission("bennys.permissao", "Bennys") then
            outServers()
            exports.tokovoip_script:addPlayerToRadio(6)
        end
    elseif data == "juridico" then
        if emP.checkPermission("juridico.permissao", "Juridico") then
            outServers()
            exports.tokovoip_script:addPlayerToRadio(7)
        end

    elseif data == "Motoclub" then
        if emP.checkPermission("motoclub.permissao", "Motoclub") then
            outServers()
            exports.tokovoip_script:addPlayerToRadio(8)
        end
    elseif data == "Motoclub2" then
        if emP.checkPermission("motoclub2.permissao", "Motoclub2") then
            outServers()
            exports.tokovoip_script:addPlayerToRadio(9)
        end
    elseif data == "Mafia" then
        if emP.checkPermission("mafia.permissao", "Mafia") then
            outServers()
            exports.tokovoip_script:addPlayerToRadio(10)
        end
    elseif data == "Crips" then
        if emP.checkPermission("crips.permissao", "Crips") then
            outServers()
            exports.tokovoip_script:addPlayerToRadio(11)
        end
    elseif data == "Mafia02" then
        if emP.checkPermission("mafia2.permissao", "Mafia02") then
            outServers()
            exports.tokovoip_script:addPlayerToRadio(12)
        end
    elseif data == "Vagos" then
        if emP.checkPermission("vagos.permissao", "Vagos") then
            outServers()
            exports.tokovoip_script:addPlayerToRadio(13)
        end
    elseif data == "Ballas" then
        if emP.checkPermission("ballas.permissao", "Ballas") then
            outServers()
            exports.tokovoip_script:addPlayerToRadio(14)
        end
    elseif data == "Groove" then
        if emP.checkPermission("groove.permissao", "Groove") then
            outServers()
            exports.tokovoip_script:addPlayerToRadio(15)
        end
    elseif data == "Liberty" then
        if emP.checkPermission("liberty.permissao", "Liberty") then
            outServers()
            exports.tokovoip_script:addPlayerToRadio(16)
        end
    elseif data == "policia2" then
        if emP.checkPermission("policia.permissao", "Polícia2") then
            outServers()
            exports.tokovoip_script:addPlayerToRadio(17)
        end
    elseif data == "Bloods" then
        if emP.checkPermission("bloods.permissao", "Bloods") then
            outServers()
            exports.tokovoip_script:addPlayerToRadio(18)
        end
    elseif data == "Bahamas" then
        if emP.checkPermission("bahamas.permissao", "Bahamas") then
            outServers()
            exports.tokovoip_script:addPlayerToRadio(18)
        end

    elseif data == "desconectar" then
        outServers()
        TriggerEvent("Notify", "sucesso", "Desconectou de todos os canais.")
    elseif data == "fechar" then
        ToggleActionMenu()
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- OUTSERVERS
-----------------------------------------------------------------------------------------------------------------------------------------
function outServers()
    for i = 1, 500 do
        if exports.tokovoip_script:isPlayerInChannel(i) == true then
            exports.tokovoip_script:removePlayerFromRadio(i)
        end
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- RADIO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("radio", function(source, args)
    if emP.checkRadio() then ToggleActionMenu() end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- RADIO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("radiooff", function(source, args)
    outServers()
    TriggerEvent("Notify", "sucesso", "Desconectou de todos os canais.")
end)

RegisterCommand("radiof", function(source, args)
    if emP.checkRadio() then
        if parseInt(args[1]) >= 19 and parseInt(args[1]) <= 500 then
            exports.tokovoip_script:addPlayerToRadio(parseInt(args[1]))
            TriggerEvent("Notify", "sucesso",
                         "Conectou na <b>frequência " ..
                             tostring(args[1]) .. "</b>.", 8000)
        end
    end
end)

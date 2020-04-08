-----------------------------------------------------------------------------------------------------------------------------------------
-- GAGO_hud
-----------------------------------------------------------------------------------------------------------------------------------------
 
dir = { [0] = '-N-', [90] = '-W-', [180] = '-S-', [270] = '-E-', [360] = '-N-'}
 
Citizen.CreateThread(function()
    while true do
        CheckClock()
        CheckPlayerPosition()
        Citizen.Wait(1000)
    end
end)
 
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        disableHud()
 
        local UI = GetMinimapAnchor()
        local Breath = GetPlayerUnderwaterTimeRemaining(PlayerId()) / 10.0
 
        if IsPedInAnyVehicle(PlayerPedId(), false) then
            DisplayRadar(true) -- Activates minimap
            drawTxt(UI.Left_x + 0.830 , UI.Bottom_y - 0.217 , 0.58, heading, 192, 192, 192, 255, 8) -- Heading
            drawTxt(UI.Left_x + 0.860 , UI.Bottom_y - 0.218 , 0.3, GetStreetNameFromHashKey(rua), 255, 255, 255, 255, 8) -- Street
        else
            DisplayRadar(false) -- Deactivates minimap
            drawTxt(UI.Left_x + 0.830 , UI.Bottom_y - 0.050 , 0.58, heading, 192, 192, 192, 255, 8) -- Heading
            drawTxt(UI.Left_x + 0.860 , UI.Bottom_y - 0.040 , 0.3, GetStreetNameFromHashKey(rua), 255, 255, 255, 255, 8) -- Street
        end
 
    end
end)
 
function CheckClock()
    Hours = GetClockHours()
    if Hours > 12 then
        Hours = Hours - 12
        Period = "PM"
    else
        Period = "AM"
    end
    if Hours < 10 then Hours = "0" .. Hours end
    Minutes = GetClockMinutes()
    if Minutes < 10 then Minutes = "0" .. Minutes end
    for k,v in pairs(dir)do
        heading = GetEntityHeading(PlayerPedId())
        if(math.abs(heading - k) < 45)then
            heading = v
            break
        end
    end
end
 
function CheckPlayerPosition()
    pos = GetEntityCoords(PlayerPedId())
    rua, cross = GetStreetNameAtCoord(pos.x, pos.y, pos.z)
    Zone = GetLabelText(GetNameOfZone(pos.x, pos.y, pos.z))
end
 
function drawRct(x,y,Width,height,r,g,b,a)
    DrawRect(x+Width/2,y+height/2,Width,height,r,g,b,a)
end
 
function drawTxt(x,y,scale,text,r,g,b,a,font)
    SetTextFont(font)
    SetTextScale(scale,scale)
    SetTextColour(r,g,b,a)
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x,y)
end
 
function disableHud()
    HideHudComponentThisFrame(6)
    HideHudComponentThisFrame(7)   
    HideHudComponentThisFrame(8)   
    HideHudComponentThisFrame(9)
end
 
function GetMinimapAnchor()
    local safezone = GetSafeZoneSize()
    local safezone_x = 1.0 / 20.0
    local safezone_y = 1.0 / 20.0
    local aspect_ratio = GetAspectRatio(0)
    local res_x, res_y = GetActiveScreenResolution()
    local xscale = 1.0 / res_x
    local yscale = 1.0 / res_y
    local Minimap = {}
    Minimap.Width = xscale * (res_x / (4 * aspect_ratio))
    Minimap.height = yscale * (res_y / 5.674)
    Minimap.Left_x = xscale * (res_x * (safezone_x * ((math.abs(safezone - 1.0)) * 10)))
    Minimap.Bottom_y = 1.0 - yscale * (res_y * (safezone_y * ((math.abs(safezone - 1.0)) * 10)))
    Minimap.right_x = Minimap.Left_x + Minimap.Width
    Minimap.top_y = Minimap.Bottom_y - Minimap.height
    Minimap.x = Minimap.Left_x
    Minimap.y = Minimap.top_y
    Minimap.xunit = xscale
    Minimap.yunit = yscale
    return Minimap
end

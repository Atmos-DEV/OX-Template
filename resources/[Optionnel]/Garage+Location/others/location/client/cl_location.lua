QDCLocation = {
    isMenuOpened = false
}

CreateThread(function()
    for k, v in pairs(ConfigLocation.listPosition) do
        QDC:createBlip(v.menuPosition, 77, 5, 0.5, "Location")
    end
end)

RMenu.Add("location", "menu", RageUI.CreateMenu("Location", "~b~Choix :", nil, nil, "aLib", "black"))
RMenu:Get("location", "menu").Closed = function()
    QDCLocation.isMenuOpened = false
    FreezeEntityPosition(PlayerPedId(), false)
end

local function openMenu(spawnPosition, spawnHeading)

    FreezeEntityPosition(PlayerPedId(), true)

    if QDCLocation.isMenuOpened then return end
    QDCLocation.isMenuOpened = true

    RageUI.Visible(RMenu:Get("location", "menu"), true)

    Citizen.CreateThread(function()
        while QDCLocation.isMenuOpened do
            RageUI.IsVisible(RMenu:Get("location", "menu"),true,true,true,function()
                RageUI.Separator(('↓ Véhicules disponibles : ~b~%s~s~ ↓'):format(#ConfigLocation.vehicleList))
                for k, v in pairs(ConfigLocation.vehicleList) do
                    RageUI.Button(v.label, nil, {RightLabel = v.price.." $"}, true, {
                        onSelected = function()
                            ESX.TriggerServerCallback("QDCLocation:requestPlayerMoney", function(hasEnoughMoney)
                                if hasEnoughMoney then
                                    QDC:spawnVehicle(v.name, spawnPosition, spawnHeading, false, true)
                                    RageUI.CloseAll()
                                    QDCLocation.isMenuOpened = false
                                    FreezeEntityPosition(PlayerPedId(), false)
                                end
                            end, v.price)
                        end
                    })
                end
            end)
            Wait(0)
        end
    end)
end

CreateThread(function()
    while true do
        interval = 750
        for k, v in pairs(ConfigLocation.listPosition) do
            local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, v.menuPosition)
            if dist <= 15 then
                interval = 1
                DrawMarker(1, v.menuPosition, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.0, 120, 120, 240, 100, false, true, 2, false, false, false, false)
                if dist <= 1.2 and not QDCLocation.isMenuOpened then
                    ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour accéder à la location")
                    if IsControlJustPressed(1,51) then
                        openMenu(v.spawnPosition, v.spawnHeading)
                    end
                end
            end
        end
        Citizen.Wait(interval)
    end
end)
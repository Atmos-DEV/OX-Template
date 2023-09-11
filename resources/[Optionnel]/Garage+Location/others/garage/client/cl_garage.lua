QDCGarage = {
    isMenuOpenend = false,
    vehicleListPerso = nil,
    filtreText = {"Garage", "Fourrière"},
    filtreIndex = 1,
}

CreateThread(function()
    for k, v in pairs(ConfigGarage.listPersoGarage) do
        local blipCoords = vector3(v.menuPos.x, v.menuPos.y, v.menuPos.z)
        QDC:createBlip(blipCoords, 290, 3, 0.5, "Garage Publique")
    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
end)

RMenu.Add("garage", "menu", RageUI.CreateMenu("Garage", "~b~Options :", nil, nil, "aLib", "black"))
RMenu:Get("garage", "menu").Closed = function()
    FreezeEntityPosition(PlayerPedId(), false)
    QDCGarage.isMenuOpened = false
end

local function openMenu(spawnX, spawnY, spawnZ, spawnHeading, societyName, societyLabel)
    FreezeEntityPosition(PlayerPedId(), true)

    if QDCGarage.isMenuOpened then return end
    QDCGarage.isMenuOpened = true

    RageUI.Visible(RMenu:Get("garage", "menu"), true)

    Citizen.CreateThread(function()
        while QDCGarage.isMenuOpened do
            RageUI.IsVisible(RMenu:Get("garage", "menu"),true,true,true,function()
                if QDCGarage.vehicleList then
                    if not societyName then
                        RageUI.Separator('↓ Garage : ~b~Perso~s~ ↓')
                        carIndex = 'none'
                    else
                        RageUI.Separator(('↓ Garage : ~b~%s~s~ ↓'):format(societyLabel))
                        carIndex = societyName
                    end
                    RageUI.List("Filtre(s)", QDCGarage.filtreText, QDCGarage.filtreIndex, nil, {}, true, {
                        onListChange = function(Index) QDCGarage.filtreIndex= Index; end })
                    RageUI.Line()
                    for k, v in ipairs(QDCGarage.vehicleList) do
                        if QDCGarage.filtreIndex == 1 then
                            if QDCGarage.vehicleList then
                                if v.job == carIndex then
                                    local vehicleModel  = GetLabelText(GetDisplayNameFromVehicleModel(v.vehicle.model))
                                    RageUI.Button(vehicleModel.." ["..v.plate.."]", nil, {RightLabel = "→→→"}, v.stored, {
                                        onSelected = function()
                                            spawnVehicle(v.vehicle, v.plate, spawnX, spawnY, spawnZ, spawnHeading)
                                            RageUI.CloseAll()
                                            FreezeEntityPosition(PlayerPedId(), false)
                                            QDCGarage.isMenuOpened = false
                                        end
                                    })
                                end
                            end
                        elseif QDCGarage.filtreIndex == 2 then
                            if QDCGarage.vehicleList then
                                if v.job == carIndex then
                                    if not v.stored then
                                        local vehicleModel  = GetLabelText(GetDisplayNameFromVehicleModel(v.vehicle.model))
                                        RageUI.Button(vehicleModel.." ["..v.plate.."]", nil, {RightLabel = '~r~'..ConfigGarage.priceFourriere.."$"}, true, {
                                            onSelected = function()
                                                ESX.TriggerServerCallback("QDCGarage:getPlayerMoney", function(hasEnoughtMoney)
                                                    if hasEnoughtMoney then
                                                        spawnVehicle(v.vehicle, v.plate, spawnX, spawnY, spawnZ, spawnHeading)
                                                        RageUI.CloseAll()
                                                        FreezeEntityPosition(PlayerPedId(), false)
                                                        QDCGarage.isMenuOpened = false
                                                    else
                                                        ESX.ShowNotification("Vous n'avez pas les fonds nécessaires !")
                                                    end
                                                end)
                                            end
                                        })
                                    end
                                end
                            end
                        end
                    end
                end
            end, function()end, 1)
            Wait(0)
        end
    end)
end

Citizen.CreateThread(function()
    Wait(5000)
    while true do
        interval = 750
        for k, v in pairs(ConfigGarage.listPersoGarage) do
            local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, v.menuPos.x, v.menuPos.y, v.menuPos.z)
            if dist <= 15 then
                interval = 1
                DrawMarker(1, v.menuPos.x, v.menuPos.y, v.menuPos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.0, 0, 255, 0, 100, false, true, 2, false, false, false, false)
                if dist <= 1.2 and not isMenuOpened then
                    ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour ouvrir le garage personnel")
                    if IsControlJustPressed(1,51) then
                        ESX.TriggerServerCallback('QDCGarage:getVehicle', function(data)
                            QDCGarage.vehicleList = data
                        end)
                        openMenu(v.spawnPoint.pos.x, v.spawnPoint.pos.y, v.spawnPoint.pos.z, v.spawnPoint.heading)
                    end
                end
            end
            -- Delete point
            local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, v.deletePoint.pos.x, v.deletePoint.pos.y, v.deletePoint.pos.z)
            if dist <= 15 then
                interval = 1
                DrawMarker(1, v.deletePoint.pos.x, v.deletePoint.pos.y, v.deletePoint.pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.0, v.deletePoint.colorMarker.r, v.deletePoint.colorMarker.y, v.deletePoint.colorMarker.z, 100, false, true, 2, false, false, false, false)
                if dist <= 1.2 then
                    ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour ranger le véhicule")
                    if IsControlJustPressed(1,51) then
                        stockVehicle()
                    end
                end
            end
        end
        for k, v in pairs(ConfigGarage.listSocietyGarage) do
            local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, v.menuPos.x, v.menuPos.y, v.menuPos.z)
            if ESX.PlayerData.job.name and ESX.PlayerData.faction.name then
                if ESX.PlayerData.job.name == k or ESX.PlayerData.faction.name == k then
                    if dist <= 15 then
                        interval = 1
                        DrawMarker(1, v.menuPos.x, v.menuPos.y, v.menuPos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.0, 0, 255, 0, 100, false, true, 2, false, false, false, false)
                        if dist <= 1.2 and not isMenuOpened then
                            ESX.ShowHelpNotification(("Appuyez sur ~INPUT_CONTEXT~ pour ouvrir le garage %s"):format(v.labelName))
                            if IsControlJustPressed(1,51) then
                                ESX.TriggerServerCallback('QDCGarage:getVehicle', function(data)
                                    QDCGarage.vehicleList = data
                                end, k)
                                openMenu(v.spawnPoint.pos.x, v.spawnPoint.pos.y, v.spawnPoint.pos.z, v.spawnPoint.heading, k, v.labelName)
                            end
                        end
                    end
                    -- Delete point
                    local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
                    local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, v.deletePoint.pos.x, v.deletePoint.pos.y, v.deletePoint.pos.z)
                    if dist <= 15 then
                        interval = 1
                        DrawMarker(1, v.deletePoint.pos.x, v.deletePoint.pos.y, v.deletePoint.pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.0, v.deletePoint.colorMarker.r, v.deletePoint.colorMarker.y, v.deletePoint.colorMarker.z, 100, false, true, 2, false, false, false, false)
                        if dist <= 1.2 then
                            ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour ranger le véhicule")
                            if IsControlJustPressed(1,51) then
                                stockVehicle(k)
                            end
                        end
                    end
                end
            end
        end
        Citizen.Wait(interval)
    end
end)

-- Functions
function spawnVehicle(vehicleModel, vehiclePlate, spawnX, spawnY, spawnZ, spawnHeading)
    x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1),true))
    ESX.Game.SpawnVehicle(vehicleModel.model, {
        x = spawnX,
        y = spawnY,
        z = spawnZ,
    }, spawnHeading, function(callback_vehicle)
        ESX.Game.SetVehicleProperties(callback_vehicle, vehicleModel)
        SetVehRadioStation(callback_vehicle, "OFF")
        SetVehicleFixed(callback_vehicle)
        SetVehicleDeformationFixed(callback_vehicle)
        SetVehicleUndriveable(callback_vehicle, false)
        SetVehicleEngineOn(callback_vehicle, true, true)
        TaskWarpPedIntoVehicle(GetPlayerPed(-1), callback_vehicle, -1)
        TriggerServerEvent("QDCGarage:changeStoredStatus", vehiclePlate, false)
    end)
end

function stockVehicle(vehicleSociety)
    if IsPedInAnyVehicle(PlayerPedId(),  false) then
        local vehicle      = GetVehiclePedIsIn(PlayerPedId(), true)
        local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
        ESX.TriggerServerCallback("QDCGarage:checkOwner", function(ownerStatus)
            if ownerStatus then
                DeleteEntity(vehicle)
                TriggerServerEvent("QDCGarage:changeStoredStatus", vehicleProps.plate, true)
                ESX.ShowNotification("Vous venez de ranger votre véhicule !")
            else
                ESX.ShowNotification("Le véhicule ne t'appartient pas !")
            end
        end, vehicleProps, vehicleSociety)
    else
        ESX.ShowNotification("Vous êtes dans aucun véhicule !")
    end
end
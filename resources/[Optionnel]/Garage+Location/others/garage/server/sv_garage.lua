ESX.RegisterServerCallback('QDCGarage:getVehicle', function(source, cb, societyName)
    local carList = {}
    local xPlayer = ESX.GetPlayerFromId(source)
    if not societyName then
        MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner', {
            ['@owner'] = xPlayer.identifier,
        }, function(data)
            for _,v in pairs(data) do
                local vehicle = json.decode(v.vehicle)
                table.insert(carList, {vehicle = vehicle, stored = v.stored, plate = v.plate, job = v.job})
            end
            cb(carList)
        end)
    else
        MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE job = @job', {
            ['@job'] = societyName,
        }, function(data)
            for _,v in pairs(data) do
                local vehicle = json.decode(v.vehicle)
                table.insert(carList, {vehicle = vehicle, stored = v.stored, plate = v.plate, job = v.job})
            end
            cb(carList)
        end)
    end
end)

RegisterNetEvent("QDCGarage:changeStoredStatus")
AddEventHandler("QDCGarage:changeStoredStatus", function(vehiclePlate, storedStatus)
    MySQL.Async.execute('UPDATE owned_vehicles SET `stored` = @stored WHERE plate = @plate', {
        ['@plate'] = vehiclePlate,
        ['@stored'] = storedStatus,
    })
end)

ESX.RegisterServerCallback("QDCGarage:getPlayerMoney", function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getMoney() >= ConfigGarage.priceFourriere then
        cb(true)
        xPlayer.removeMoney(ConfigGarage.priceFourriere)
    else
        cb(false)
    end
end)

ESX.RegisterServerCallback('QDCGarage:checkOwner', function (source, cb, vehicleProps, vehicleSociety)
    local vehplate = vehicleProps.plate:match("^%s*(.-)%s*$")
    local vehiclemodel = vehicleProps.model
    local xPlayer = ESX.GetPlayerFromId(source)
    if not vehicleSociety then
        MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND @plate = plate', {
            ['@owner'] = xPlayer.identifier,
            ['@plate'] = vehicleProps.plate
        }, function (result)
            if result[1] ~= nil and result[1].job == 'none' then
                local originalvehprops = json.decode(result[1].vehicle)
                if originalvehprops.model == vehiclemodel then
                    MySQL.Async.execute('UPDATE owned_vehicles SET vehicle = @vehicle WHERE plate = @plate', {
                        ['@vehicle'] = json.encode(vehicleProps),
                        ['@plate'] = vehicleProps.plate
                    }, function (rowsChanged)
                        cb(true)
                    end)
                else
                    cb(false)
                end
            else
                cb(false)
            end
        end)
    else
        MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE job = job AND @plate = plate', {
            ['@job'] = vehicleSociety,
            ['@plate'] = vehicleProps.plate
        }, function (result)
            if result[1] ~= nil and result[1].job == xPlayer.job.name then
                local originalvehprops = json.decode(result[1].vehicle)
                if originalvehprops.model == vehiclemodel then
                    MySQL.Async.execute('UPDATE owned_vehicles SET vehicle = @vehicle WHERE plate = @plate', {
                        ['@vehicle'] = json.encode(vehicleProps),
                        ['@plate'] = vehicleProps.plate
                    }, function (rowsChanged)
                        cb(true)
                    end)
                else
                    cb(false)
                end
            else
                cb(false)
            end
        end)
    end
end)
ESX.RegisterServerCallback("QDCLocation:requestPlayerMoney", function(source, cb, vehiclePrice)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        local playerMoney = xPlayer.getMoney()
        if playerMoney >= vehiclePrice then
            xPlayer.removeMoney(vehiclePrice)
            xPlayer.showNotification(("Vous avez payé %s$ !"):format(vehiclePrice))
            cb(true)
        else
            xPlayer.showNotification("Vous n'avez pas l'argent nécessaire !")
            cb(false)
        end
    end
end)
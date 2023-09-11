ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('aPersonalMenu:munitionserver')
AddEventHandler('aPersonalMenu:munitionserver', function(plyId, value, quantity)
    TriggerClientEvent('aPersonalMenu:donnermunitions', plyId, value, quantity)
end)

RegisterServerEvent('aPersonalMenu:donnerargent')
AddEventHandler('aPersonalMenu:donnerargent', function(target2, quantity)
    local _src = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local target = ESX.GetPlayerFromId(target2)
    local donne = xPlayer.getMoney()

    if donne >= quantity then
        xPlayer.removeMoney(quantity)
        target.addMoney(quantity)
        TriggerClientEvent("esx:showNotification", _src, "Vous venez de donner ~r~"..quantity.." $ ~s~à ~b~"..GetPlayerName(target2).."~s~ !")
        TriggerClientEvent("esx:showNotification", target2,"~b~"..GetPlayerName(_src).."~s~ vous à donné ~g~"..quantity.. " $ ~s~!")
    else
        TriggerClientEvent("esx:showNotification", _src, "~r~Problème~s~ : Vous n'avez pas les fonds nécessaire !")
    end
end)

ESX.RegisterServerCallback('aPersonalMenu:factures', function(source, cb, plate)
    local xPlayer = ESX.GetPlayerFromId(source)
    local keys = {}
    MySQL.Async.fetchAll('SELECT * FROM billing WHERE identifier = @identifier', {['@identifier'] = xPlayer.identifier}, 
        function(result)
        for selected = 1, #result, 1 do
            table.insert(keys, {
                label = result[selected].label,
                amount = result[selected].amount,
                id = result[selected].id,
				sender = result[selected].sender
            })
        end
        cb(keys)
    end)
end)

ESX.RegisterServerCallback('aPersonalMenu:cles', function(source, cb, plate)
    local xPlayer = ESX.GetPlayerFromId(source)
    local keys = {}
    MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner', {['@owner'] = xPlayer.identifier},
        function(result)
        for selected = 1, #result, 1 do
            table.insert(keys, {
                owner = result[selected].identifier,
				plate = result[selected].plate,
            })
        end
        cb(keys)
    end)
end)

RegisterServerEvent('aPersonalMenu:donnervoiture')
AddEventHandler('aPersonalMenu:donnervoiture', function(target2, plate)
    local src = source
    local xTarget = ESX.GetPlayerFromId(target2)
	MySQL.Sync.execute('UPDATE owned_vehicles SET owner = @owner WHERE plate = @plate', {
        ['@plate'] = plate,
		['@owner'] = xTarget.identifier,
	})
    TriggerClientEvent("esx:showNotification", src, "Clés donné avec ~g~succès~s~ !")
    TriggerClientEvent("esx:showNotification", target2, "Vous venez de ~g~recevoir~s~ des clés !")
end) 

RegisterServerEvent('aPersonalMenu:detruire')
AddEventHandler('aPersonalMenu:detruire', function(plate)
    MySQL.Async.execute('DELETE FROM owned_vehicles WHERE plate = @plate', {
        ['@plate'] = plate
    })  
    TriggerClientEvent("esx:showNotification", source, "Clés détruites avec ~g~succès~s~ !")
end) 

-- Boss 

local function makeTargetedEventFunction(fn)
	return function(target, ...)
		if tonumber(target) == -1 then return end
		fn(target, ...)
	end
end

function getMaximumGrade(jobName)
	local p = promise.new()

	MySQL.Async.fetchScalar('SELECT grade FROM job_grades WHERE job_name = @job_name ORDER BY `grade` DESC', { ['@job_name'] = jobName }, function(result)
		p:resolve(result)
	end)

	local queryResult = Citizen.Await(p)

	return tonumber(queryResult)
end


RegisterServerEvent('aPersonalMenu:Boss_promouvoirplayer')
AddEventHandler('aPersonalMenu:Boss_promouvoirplayer', makeTargetedEventFunction(function(target)
	local sourceXPlayer = ESX.GetPlayerFromId(source)
	local sourceJob = sourceXPlayer.getJob()

	if sourceJob.grade_name == 'boss' then
		local targetXPlayer = ESX.GetPlayerFromId(target)
		local targetJob = targetXPlayer.getJob()

		if sourceJob.name == targetJob.name then
			local newGrade = tonumber(targetJob.grade) + 1

			if newGrade ~= getMaximumGrade(targetJob.name) then
				targetXPlayer.setJob(targetJob.name, newGrade)

				TriggerClientEvent('esx:showNotification', sourceXPlayer.source, ('Vous avez ~g~promu %s~w~.'):format(targetXPlayer.name))
				TriggerClientEvent('esx:showNotification', target, ('Vous avez été ~g~promu par %s~w~.'):format(sourceXPlayer.name))
			else
				TriggerClientEvent('esx:showNotification', sourceXPlayer.source, 'Vous devez demander une autorisation ~r~Gouvernementale~w~.')
			end
		else
			TriggerClientEvent('esx:showNotification', sourceXPlayer.source, 'Le joueur n\'est pas dans votre entreprise.')
		end
	else
		TriggerClientEvent('esx:showNotification', sourceXPlayer.source, 'Vous n\'avez pas ~r~l\'autorisation~w~.')
	end
end))

RegisterServerEvent('aPersonalMenu:Boss_destituerplayer')
AddEventHandler('aPersonalMenu:Boss_destituerplayer', makeTargetedEventFunction(function(target)
	local sourceXPlayer = ESX.GetPlayerFromId(source)
	local sourceJob = sourceXPlayer.getJob()

	if sourceJob.grade_name == 'boss' then
		local targetXPlayer = ESX.GetPlayerFromId(target)
		local targetJob = targetXPlayer.getJob()

		if sourceJob.name == targetJob.name then
			local newGrade = tonumber(targetJob.grade) - 1

			if newGrade >= 0 then
				targetXPlayer.setJob(targetJob.name, newGrade)

				TriggerClientEvent('esx:showNotification', sourceXPlayer.source, ('Vous avez ~r~rétrogradé %s~w~.'):format(targetXPlayer.name))
				TriggerClientEvent('esx:showNotification', target, ('Vous avez été ~r~rétrogradé par %s~w~.'):format(sourceXPlayer.name))
			else
				TriggerClientEvent('esx:showNotification', sourceXPlayer.source, 'Vous ne pouvez pas ~r~rétrograder~w~ d\'avantage.')
			end
		else
			TriggerClientEvent('esx:showNotification', sourceXPlayer.source, 'Le joueur n\'est pas dans votre organisation.')
		end
	else
		TriggerClientEvent('esx:showNotification', sourceXPlayer.source, 'Vous n\'avez pas ~r~l\'autorisation~w~.')
	end
end))

RegisterServerEvent('aPersonalMenu:Boss_recruterplayer')
AddEventHandler('aPersonalMenu:Boss_recruterplayer', makeTargetedEventFunction(function(target)
	local sourceXPlayer = ESX.GetPlayerFromId(source)
	local sourceJob = sourceXPlayer.getJob()

	if sourceJob.grade_name == 'boss' then
		local targetXPlayer = ESX.GetPlayerFromId(target)

		targetXPlayer.setJob(sourceJob.name, 0)
		TriggerClientEvent('esx:showNotification', sourceXPlayer.source, ('Vous avez ~g~recruté %s~w~.'):format(targetXPlayer.name))
		TriggerClientEvent('esx:showNotification', target, ('Vous avez été ~g~embauché par %s~w~.'):format(sourceXPlayer.name))
	end
end))

RegisterServerEvent('aPersonalMenu:Boss_virerplayer')
AddEventHandler('aPersonalMenu:Boss_virerplayer', makeTargetedEventFunction(function(target)
	local sourceXPlayer = ESX.GetPlayerFromId(source)
	local sourceJob = sourceXPlayer.getJob()

	if sourceJob.grade_name == 'boss' then
		local targetXPlayer = ESX.GetPlayerFromId(target)
		local targetJob = targetXPlayer.getJob()

		if sourceJob.name == targetJob.name then
			targetXPlayer.setJob('unemployed', 0)
			TriggerClientEvent('esx:showNotification', sourceXPlayer.source, ('Vous avez ~r~viré %s~w~.'):format(targetXPlayer.name))
			TriggerClientEvent('esx:showNotification', target, ('Vous avez été ~g~viré par %s~w~.'):format(sourceXPlayer.name))
		else
			TriggerClientEvent('esx:showNotification', sourceXPlayer.source, 'Le joueur n\'est pas dans votre entreprise.')
		end
	else
		TriggerClientEvent('esx:showNotification', sourceXPlayer.source, 'Vous n\'avez pas ~r~l\'autorisation~w~.')
	end
end))

RegisterServerEvent('aPersonalMenu:Boss_promouvoirplayer2')
AddEventHandler('aPersonalMenu:Boss_promouvoirplayer2', function(target)
	local _source = source

	local sourceXPlayer = ESX.GetPlayerFromId(_source)
	local targetXPlayer = ESX.GetPlayerFromId(target)
	local maximumgrade = tonumber(getMaximumGrade(sourceXPlayer.faction.name)) -1

	if (targetXPlayer.faction.grade == maximumgrade) then
		TriggerClientEvent('esx:showNotification', _source, "Vous devez demander une autorisation du ~r~Gouvernement~w~.")
	else
		if (sourceXPlayer.faction.name == targetXPlayer.faction.name) then
			local grade2 = tonumber(targetXPlayer.faction.grade) + 1
			local faction = targetXPlayer.faction.name

			targetXPlayer.setFaction(faction, grade2)

			TriggerClientEvent('esx:showNotification', _source, "Vous avez ~g~promu " .. targetXPlayer.name .. "~w~.")
			TriggerClientEvent('esx:showNotification', target, "Vous avez été ~g~promu par " .. sourceXPlayer.name .. "~w~.")
		else
			TriggerClientEvent('esx:showNotification', _source, "Vous n'avez pas ~r~l'autorisation~w~.")
		end
	end
end)

RegisterServerEvent('aPersonalMenu:Boss_destituerplayer2')
AddEventHandler('aPersonalMenu:Boss_destituerplayer2', function(target)
	local _source = source

	local sourceXPlayer = ESX.GetPlayerFromId(_source)
	local targetXPlayer = ESX.GetPlayerFromId(target)

	if (targetXPlayer.faction.grade == 0) then
		TriggerClientEvent('esx:showNotification', _source, "Vous ne pouvez pas plus ~r~rétrograder~w~ davantage.")
	else
		if (sourceXPlayer.faction.name == targetXPlayer.faction.name) then
			local grade2 = tonumber(targetXPlayer.faction.grade) - 1
			local faction = targetXPlayer.faction.name

			targetXPlayer.setFaction(faction, grade2)

			TriggerClientEvent('esx:showNotification', _source, "Vous avez ~r~rétrogradé " .. targetXPlayer.name .. "~w~.")
			TriggerClientEvent('esx:showNotification', target, "Vous avez été ~r~rétrogradé par " .. sourceXPlayer.name .. "~w~.")
		else
			TriggerClientEvent('esx:showNotification', _source, "Vous n'avez pas ~r~l'autorisation~w~.")
		end
	end
end)

RegisterServerEvent('aPersonalMenu:Boss_recruterplayer2')
AddEventHandler('aPersonalMenu:Boss_recruterplayer2', function(target, faction, grade2)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xTarget = ESX.GetPlayerFromId(target)

	xTarget.setFaction(faction, grade2)

	TriggerClientEvent('esx:showNotification', _source, "Vous avez ~g~recruté " .. xTarget.name .. "~w~.")
	TriggerClientEvent('esx:showNotification', target, "Vous avez été ~g~embauché par " .. xPlayer.name .. "~w~.")
end)

RegisterServerEvent('aPersonalMenu:Boss_virerplayer2')
AddEventHandler('aPersonalMenu:Boss_virerplayer2', function(target)
	local _source = source

	local sourceXPlayer = ESX.GetPlayerFromId(_source)
	local targetXPlayer = ESX.GetPlayerFromId(target)
	local faction = "nofaction"
	local grade2 = "0"

	if (sourceXPlayer.faction.name == targetXPlayer.faction.name) then
		targetXPlayer.setFaction(faction, grade2)

		TriggerClientEvent('esx:showNotification', _source, "Vous avez ~r~viré " .. targetXPlayer.name .. "~w~.")
		TriggerClientEvent('esx:showNotification', target, "Vous avez été ~g~viré par " .. sourceXPlayer.name .. "~w~.")
	else
		TriggerClientEvent('esx:showNotification', _source, "Vous n'avez pas ~r~l'autorisation~w~.")
	end
end)


RegisterServerEvent('aPersonalMenu:envoyeremployer')
AddEventHandler('aPersonalMenu:envoyeremployer', function(PriseOuFin, message)
	local _source = source
	local _raison = PriseOuFin
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers = ESX.GetPlayers()
	local name = xPlayer.getName(_source)
	local job = xPlayer.getJob()
	for i = 1, #xPlayers, 1 do
		local thePlayer = ESX.GetPlayerFromId(xPlayers[i])
		if thePlayer.job.name == job.name then
			TriggerClientEvent('aPersonalMenu:envoyeremployer', xPlayers[i], _raison, name, message)
		end
	end
end)

ESX.RegisterServerCallback("aPersonalMenu:getboutiqueid", function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local result = MySQL.Sync.fetchAll('SELECT idvote FROM users WHERE identifier = @identifier', {['@identifier'] = xPlayer.identifier})
	cb(result[1].idvote)
end)
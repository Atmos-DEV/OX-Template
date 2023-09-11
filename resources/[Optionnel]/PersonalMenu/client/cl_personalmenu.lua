ESX = nil

local isMenuOpened = false
local entrepriseargent = nil
local societymoney2 = nil
local array = {
    "Aucun",
}
local filtre2 = {
    "Vêtements",
    "Accesoires"
}
local arrayIndex = 1
local filtre2Index = 1

local aPerso = {
    DoorState = {
        FrontLeft = false,
        FrontRight = false,
        BackLeft = false,
        BackRight = false,
        Hood = false,
        Trunk = false
    },
    ItemSelected = {},
    ItemSelected2 = {},
    WeaponData = {},
    Factures = {},
    Cles = {},
    DoorIndex = 1,
    DoorList = {"Avant Gauche", "Avant Droite", "Arrère Gauche", "Arrère Droite"},
}
local ragdolling = false

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    ESX.PlayerData = xPlayer
end)

RegisterNetEvent('es:activateMoney')
AddEventHandler('es:activateMoney', function(money)
    ESX.PlayerData.money = money
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
end)

RegisterNetEvent('esx:setfaction')
AddEventHandler('esx:setfaction', function(faction)
    ESX.PlayerData.faction = faction
end)

RegisterNetEvent('esx:setAccountMoney')
AddEventHandler('esx:setAccountMoney', function(account)
    ESX.PlayerData = ESX.GetPlayerData()
    for i=1, #ESX.PlayerData.accounts, 1 do
        if ESX.PlayerData.accounts[i].name == account.name then
            ESX.PlayerData.accounts[i] = account
            break
        end
    end
end)

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(750)
    end
end)

RegisterNetEvent('aPersonalMenu:envoyeremployer')
AddEventHandler('aPersonalMenu:envoyeremployer', function(service, nom, message)
    if service == 'patron' then
        PlaySoundFrontend(-1, "Start_Squelch", "CB_RADIO_SFX", 1)
        ESX.ShowAdvancedNotification('INFO '..ESX.PlayerData.job.label, '~b~A lire', 'Patron: ~g~'..nom..'\n~w~Message: ~g~'..message..'', 'CHAR_MINOTAUR', 8)
        Wait(1000)
        PlaySoundFrontend(-1, "End_Squelch", "CB_RADIO_SFX", 1)
    end
end)


function CheckQuantity(number)
    number = tonumber(number)

    if type(number) == 'number' then
        number = ESX.Math.Round(number)

        if number > 0 then
            return true, number
        end
    end

    return false, number
end

function KeyboardInput(entryTitle, textEntry, inputText, maxLength)
    AddTextEntry(entryTitle, textEntry)
    DisplayOnscreenKeyboard(1, entryTitle, "", inputText, "", "", "", maxLength)
    blockinput = true

    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
        Citizen.Wait(0)
    end

    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
        Citizen.Wait(500)
        blockinput = false
        return result
    else
        Citizen.Wait(500)
        blockinput = false
        return nil
    end
end

RMenu.Add("atmos", "principal", RageUI.CreateMenu("Template", "~b~Actions :", nil, nil, "aLib", "black"))
RMenu:Get("atmos", "principal").Closed = function()
    currentWeight = 0
    isMenuOpened = false
end

RMenu.Add("atmos", "inventaire", RageUI.CreateSubMenu(RMenu:Get("atmos", "principal"), "Template", "~b~Inventaire :"))
RMenu:Get("atmos", "inventaire").Closed = function()end

RMenu.Add("atmos", "actioninventaire", RageUI.CreateSubMenu(RMenu:Get("atmos", "principal"), "Template", "~b~Inventaire :"))
RMenu:Get("atmos", "actioninventaire").Closed = function()end

RMenu.Add("atmos", "actionarme", RageUI.CreateSubMenu(RMenu:Get("atmos", "inventaire"), "Template", "~b~Inventaire :"))
RMenu:Get("atmos", "actionarme").Closed = function()end

RMenu.Add("atmos", "portefeuille", RageUI.CreateSubMenu(RMenu:Get("atmos", "principal"), "Template", "~b~Portefeuille :"))
RMenu:Get("atmos", "portefeuille").Closed = function()end

RMenu.Add("atmos", "actionargent", RageUI.CreateSubMenu(RMenu:Get("atmos", "portefeuille"), "Template", "~b~Portefeuille :"))
RMenu:Get("atmos", "actionargent").Closed = function()end

RMenu.Add("atmos", "actionsale", RageUI.CreateSubMenu(RMenu:Get("atmos", "portefeuille"), "Template", "~b~Portefeuille :"))
RMenu:Get("atmos", "actionsale").Closed = function()end

RMenu.Add("atmos", "factures", RageUI.CreateSubMenu(RMenu:Get("atmos", "portefeuille"), "Template", "~b~Portefeuille :"))
RMenu:Get("atmos", "factures").Closed = function()end

RMenu.Add("atmos", "licenses", RageUI.CreateSubMenu(RMenu:Get("atmos", "portefeuille"), "Template", "~b~Portefeuille :"))
RMenu:Get("atmos", "licenses").Closed = function()end

RMenu.Add("atmos", "vetements", RageUI.CreateSubMenu(RMenu:Get("atmos", "principal"), "Template", "~b~Vêtements :"))
RMenu:Get("atmos", "vetements").Closed = function()end

RMenu.Add("atmos", "cles", RageUI.CreateSubMenu(RMenu:Get("atmos", "principal"), "Template", "~b~Mes clés :"))
RMenu:Get("atmos", "cles").Closed = function()end

RMenu.Add("atmos", "entreprise", RageUI.CreateSubMenu(RMenu:Get("atmos", "principal"), "Template", "~b~Gestion entreprise :"))
RMenu:Get("atmos", "entreprise").Closed = function()end

RMenu.Add("atmos", "organisation", RageUI.CreateSubMenu(RMenu:Get("atmos", "principal"), "Template", "~b~Gestion organisation :"))
RMenu:Get("atmos", "organisation").Closed = function()end

RMenu.Add("atmos", "actioncle", RageUI.CreateSubMenu(RMenu:Get("atmos", "principal"), "Template", "~b~Mes clés :"))
RMenu:Get("atmos", "actioncle").Closed = function()end

RMenu.Add("atmos", "divers", RageUI.CreateSubMenu(RMenu:Get("atmos", "principal"), "Template", "~b~Divers :"))
RMenu:Get("atmos", "divers").Closed = function()end

RMenu.Add("atmos", "actionfacture", RageUI.CreateSubMenu(RMenu:Get("atmos", "portefeuille"), "Template", "~b~Gestion factures :"))
RMenu:Get("atmos", "actionfacture").Closed = function()end

RMenu.Add("atmos", "gestionvehicle", RageUI.CreateSubMenu(RMenu:Get("atmos", "principal"), "Template", "~b~Gestion véhiucle :"))
RMenu:Get("atmos", "gestionvehicle").Closed = function()end


local function openMenuPersonal()

    ESX.PlayerData = ESX.GetPlayerData()

    if isMenuOpened then return end
    isMenuOpened = true

    RageUI.Visible(RMenu:Get("atmos","principal"), true)


    Citizen.CreateThread(function()
        while isMenuOpened do
            RageUI.IsVisible(RMenu:Get("atmos","principal"),true,true,true,function()
                RageUI.Separator("~r~→~s~ ID : ~b~"..GetPlayerServerId(PlayerId()).." ~r~←~s~")
                RageUI.ButtonWithStyle("> Portefeuille", nil, {RightLabel = '→→→'}, true,function(a,h,s)
                end, RMenu:Get("atmos", "portefeuille"))
                if IsPedSittingInAnyVehicle(PlayerPedId()) then
                    statveh = true
                else statveh = false end
                RageUI.ButtonWithStyle("> Gestion véhicule", nil, {RightLabel = '→→→'}, statveh,function(a,h,s)
                end, RMenu:Get("atmos", "gestionvehicle"))
                RageUI.ButtonWithStyle("> Mes clées", nil, {RightLabel = '→→→'}, true,function(a,h,s)
                    if s then
                        ESX.TriggerServerCallback('aPersonalMenu:cles', function(keys)
                            aPerso.Cles = keys
                        end)
                    end
                end, RMenu:Get("atmos", "cles"))
                if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.grade_name == 'boss' then
                    entre = true
                else entre = false end
                if ESX.PlayerData.faction ~= nil and ESX.PlayerData.faction.grade_name == 'boss' then
                    orga = true
                else orga = false end
                RageUI.ButtonWithStyle("> Gestion entreprise", nil, {RightLabel = '→→→'}, entre,function(a,h,s)
                    if s then
                        argententre()
                    end
                end, RMenu:Get("atmos", "entreprise"))
                RageUI.ButtonWithStyle("> Gestion Organisation", nil, {RightLabel = '→→→'}, orga,function(a,h,s)
                    if s then
                        RefreshMoney2()
                    end
                end, RMenu:Get("atmos", "organisation"))
                RageUI.ButtonWithStyle("> Divers", nil, {RightLabel = '→→→'}, true,function(a,h,s)
                end, RMenu:Get("atmos", "divers"))
            end, function()end, 1)
            RageUI.IsVisible(RMenu:Get("atmos",'inventaire'),true,true,true,function()
                    iventaire()
            end, function()end, 1)
            RageUI.IsVisible(RMenu:Get("atmos","actioninventaire"),true,true,true,function()
                RageUI.ButtonWithStyle("Utiliser", nil, {RightBadge = RageUI.BadgeStyle.Heart}, true, function(Hovered, Active, Selected)
                    if (Selected) then
                        if aPerso.ItemSelected.usable then
                            TriggerServerEvent('esx:useItem', aPerso.ItemSelected.name)
                        else
                            ESX.ShowNotification('~r~Problème~s~ : l\'items n\'est pas utilisable', aPerso.ItemSelected.label)
                        end
                    end
                end)
                RageUI.ButtonWithStyle("Jeter", nil, {RightBadge = RageUI.BadgeStyle.Alert}, true, function(Hovered, Active, Selected)
                    if (Selected) then
                        if aPerso.ItemSelected.canRemove then
                            local post,quantity = CheckQuantity(KeyboardInput("atmos", 'Quantité', '', 100))
                            if post then
                                if not IsPedSittingInAnyVehicle(PlayerPedId()) then
                                    TriggerServerEvent('esx:removeInventoryItem', 'item_standard', aPerso.ItemSelected.name, quantity)
                                    TriggerServerEvent('Logs:dropitems', GetPlayerName(PlayerId()), aPerso.ItemSelected.name, quantity)
                                else
                                    ESX.ShowNotification("~r~Problème~s~ : Vous ne pouvez pas faire ceci dans un véhicule !")
                                end
                            end
                        end
                    end
                end)
                RageUI.ButtonWithStyle("Donner", nil, {RightBadge = RageUI.BadgeStyle.Tick}, true, function(Hovered, Active, Selected)
                    if (Selected) then
                        local sonner,quantity = CheckQuantity(KeyboardInput("atmos", 'Quantité', '', 100))
                        local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                        local pPed = GetPlayerPed(-1)
                        local coords = GetEntityCoords(pPed)
                        local x,y,z = table.unpack(coords)

                        if sonner then
                            if closestDistance ~= -1 and closestDistance <= 3 then
                                local closestPed = GetPlayerPed(closestPlayer)

                                if IsPedOnFoot(closestPed) then
                                    TriggerServerEvent('esx:giveInventoryItem', GetPlayerServerId(closestPlayer), 'item_standard', aPerso.ItemSelected.name, quantity)
                                else
                                    ESX.ShowNotification("~r~Problème~s~ : Nombres d'items invalid !")
                                end
                            else
                                ESX.ShowNotification("Personnes autour", 'Problème')
                            end
                        end
                    end
                end)
            end, function()end, 1)
            RageUI.IsVisible(RMenu:Get("atmos",'portefeuille'),true,true,true,function()
                RageUI.Separator("↓ Informations du Compte ↓")
                for i = 1, #ESX.PlayerData.accounts, 1 do
                    if ESX.PlayerData.accounts[i].name == "money" then
                        RageUI.ButtonWithStyle("Argent en liquide : ~g~" ..ESX.Math.GroupDigits(ESX.PlayerData.accounts[i].money)..' $', nil, {RightLabel = '→→→'}, true,function(a,h,s)
                        end, RMenu:Get("atmos", "actionargent"))
                    end
                    if ESX.PlayerData.accounts[i].name == 'black_money'  then
                        RageUI.ButtonWithStyle("Argent en sale : ~r~" ..ESX.Math.GroupDigits(ESX.PlayerData.accounts[i].money)..' $', nil, {RightLabel = '→→→'}, true,function(a,h,s)
                        end, RMenu:Get("atmos",'actionsale'))
                    end
                end
                RageUI.ButtonWithStyle("> Accéder à vos factures", nil, {RightLabel = '→→→'}, true,function(a,h,s)
                    if s then
                        ESX.TriggerServerCallback('aPersonalMenu:factures', function(keys)
                            aPerso.Factures = keys
                        end)
                    end
                end, RMenu:Get("atmos", "factures"))
                RageUI.Separator("↓ Informations Personnelles ↓")
                RageUI.ButtonWithStyle("Métier", nil, {RightLabel = "~b~"..ESX.PlayerData.job.label..', '..ESX.PlayerData.job.grade_label}, true,function(a,h,s)
                end)
                RageUI.ButtonWithStyle("Organisation", nil, {RightLabel = "~b~"..ESX.PlayerData.faction.label..', '..ESX.PlayerData.faction.grade_label}, true,function(a,h,s)
                end)
            end, function()end, 1)
            RageUI.IsVisible(RMenu:Get("atmos","actionargent"),true,true,true,function()
                RageUI.ButtonWithStyle("Donner", nil, {RightBadge = RageUI.BadgeStyle.Lock}, true, function(Hovered,Active,Selected)
                    if Selected then
                        local cash, quantity = CheckQuantity(KeyboardInput('atmos', "Montant", '', 6), '', 100)
                        if cash then
                            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                            if closestDistance ~= -1 and closestDistance <= 3 then
                                local closestPed = GetPlayerPed(closestPlayer)
                                if not IsPedSittingInAnyVehicle(closestPed) then
                                    TriggerServerEvent("aPersonalMenu:donnerargent", GetPlayerServerId(closestPlayer), quantity)
                                else
                                    ESX.ShowNotification('~r~Problème~s~ : Vous ne pouvez pas donner de l\'argent dans un véhicles !')
                                end
                            else
                                ESX.ShowNotification('~r~Problème~s~ : Aucun joueur proche !')
                            end
                        else
                            ESX.ShowNotification('~r~Problème~s~ : Somme invalide !')
                        end
                    end
                end)
            end, function()end, 1)
            RageUI.IsVisible(RMenu:Get("atmos",'actionsale'),true,true,true,function()
                for i = 1, #ESX.PlayerData.accounts, 1 do
                    if ESX.PlayerData.accounts[i].name == 'black_money' then
                        RageUI.ButtonWithStyle("Donner", nil, {RightBadge = RageUI.BadgeStyle.Lock}, true, function(Hovered,Active,Selected)
                            if Selected then
                                local quantity = KeyboardInput('atmos', "Montant", '', 6)
                                if tonumber(quantity) then
                                    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

                                    if closestDistance ~= -1 and closestDistance <= 3 then
                                        local closestPed = GetPlayerPed(closestPlayer)

                                        if not IsPedSittingInAnyVehicle(closestPed) then
                                            TriggerServerEvent('esx:giveInventoryItem', GetPlayerServerId(closestPlayer), 'item_account', ESX.PlayerData.accounts[i].name, tonumber(quantity))
                                            --RageUI.CloseAll()
                                        else
                                            ESX.ShowNotification('~r~Problème~s~ : Vous ne pouvez pas donner de l\'argent dans un véhicles')
                                        end
                                    else
                                        ESX.ShowNotification('~r~Problème~s~ : Aucun joueur proche !')
                                    end
                                else
                                    ESX.ShowNotification('~r~Problème~s~ : Somme invalide')
                                end
                            end
                        end)
                    end
                end
            end, function()end, 1)
            RageUI.IsVisible(RMenu:Get("atmos",'factures'),true,true,true,function()
                RageUI.Separator('↓ Vos factures ↓')
                for selected = 1, #aPerso.Factures, 1 do
                    RageUI.ButtonWithStyle(aPerso.Factures[selected].label, nil, {RightLabel = "[~r~"..ESX.Math.GroupDigits(aPerso.Factures[selected].amount).."$~s~] →→→"}, true,function(a,h,s)
                        if s then
                            labelfacture = aPerso.Factures[selected].label
                            pricefacture = aPerso.Factures[selected].amount
                            idfacture = aPerso.Factures[selected].id
                            senderfacture = aPerso.Factures[selected].sender
                        end
                    end, RMenu:Get("atmos", "actionfacture"))
                end
            end, function()end, 1)
            RageUI.IsVisible(RMenu:Get("atmos", "actionfacture"),true,true,true,function()
                RageUI.Separator("~r~→~s~ Factures : "..labelfacture.." ~r~←~s~")
                RageUI.Separator("~r~→~s~ Prix : "..pricefacture.."$ ~r~←~s~")
                RageUI.ButtonWithStyle("Payer en espèce", nil, {RightLabel = "→→→"}, true,function(a,h,s)
                    if s then
                        RageUI.GoBack()
                        ESX.TriggerServerCallback('esx_billing:payBill', function()
                        end, idfacture, 'cash')
                    end
                end)
                RageUI.ButtonWithStyle("Payer par carte", nil, {RightLabel = "→→→"}, true,function(a,h,s)
                    if s then
                        RageUI.GoBack()
                        ESX.TriggerServerCallback('esx_billing:payBill', function()
                        end, idfacture, 'bank')
                    end
                end)
                RageUI.ButtonWithStyle("Payer avec l'entreprise [~b~"..ESX.PlayerData.job.label.."~s~]", nil, {RightLabel = "→→→"}, entre,function(a,h,s)
                    if s then

                        local societe = "society_"..ESX.PlayerData.job.name
                        print(societe)
                        RageUI.GoBack()
                        ESX.TriggerServerCallback('esx_billing:payBill', function()
                        end, idfacture, 'society', societe)
                    end
                end)
            end, function()end, 1)
            RageUI.IsVisible(RMenu:Get("atmos",'licenses'),true,true,true,function()
                RageUI.Separator('↓ Carte d\'identité ↓')
                RageUI.ButtonWithStyle("~r~Montrer sa carte d'identité", nil, {RightLabel = '→→→'}, true,function(a,h,s)
                    if s then
                        local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                        if closestDistance ~= -1 and closestDistance <= 3.0 then
                            TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(closestPlayer))
                        else
                            ESX.ShowNotification("Personnes autour", 'Problème')
                        end
                    end
                end)
                RageUI.ButtonWithStyle("~r~Regarder sa carte d'identité", nil, {RightLabel = '→→→'}, true,function(a,h,s)
                    if s then
                        TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()))
                    end
                end)
                RageUI.Separator('↓ Permis de conduire ↓')
                RageUI.ButtonWithStyle("~r~Montrer son permis de conduire", nil, {RightLabel = '→→→'}, true,function(a,h,s)
                    if s then
                        local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

                        if closestDistance ~= -1 and closestDistance <= 3.0 then
                            TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(closestPlayer), 'driver')
                        else
                            ESX.ShowNotification("Personnes autour", 'Problème')
                        end
                    end
                end)
                RageUI.ButtonWithStyle("~r~Regarder son permis de conduire", nil, {RightLabel = '→→→'}, true,function(a,h,s)
                    if s then
                        TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), 'driver')
                    end
                end)
                RageUI.Separator('↓ Permis de port d\'armes ↓')
                RageUI.ButtonWithStyle("~r~Montrer son permis de port d'armes", nil, {RightLabel = '→→→'}, true,function(a,h,s)
                    if s then
                        local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

                        if closestDistance ~= -1 and closestDistance <= 3.0 then
                            TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(closestPlayer), 'weapon')
                        else
                            ESX.ShowNotification("Personnes autour", 'Problème')
                        end
                    end
                end)
                RageUI.ButtonWithStyle("~r~Regarder son permis de port d'armes", nil, {RightLabel = '→→→'}, true,function(a,h,s)
                    if s then
                        TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), 'weapon')
                    end
                end)
            end, function()end, 1)
            RageUI.IsVisible(RMenu:Get("atmos",'vetements'),true,true,true,function()
                RageUI.Separator('↓ Actions vêtements ↓')
                RageUI.ButtonWithStyle("Haut", nil, {RightBadge = RageUI.BadgeStyle.Clothes}, true,function(a,h,s)
                    if s then
                        TriggerEvent('aPersonalMenu:actionhaut')
                    end
                end)
                RageUI.ButtonWithStyle("Pantalon", nil, {RightBadge = RageUI.BadgeStyle.Clothes}, true,function(a,h,s)
                    if s then
                        TriggerEvent('aPersonalMenu:actionpantalon')
                    end
                end)
                RageUI.ButtonWithStyle("Chaussure", nil, {RightBadge = RageUI.BadgeStyle.Clothes}, true,function(a,h,s)
                    if s then
                        TriggerEvent('aPersonalMenu:actionchaussure')
                    end
                end)
                RageUI.ButtonWithStyle("Gilet par balles", nil, {RightBadge = RageUI.BadgeStyle.Clothes}, true,function(a,h,s)
                    if s then
                        TriggerEvent('aPersonalMenu:actiongiletparballe')
                    end
                end)
                RageUI.Separator('↓ Mes vêtements ↓')
                    iventaire2()
            end, function()end, 1)
            RageUI.IsVisible(RMenu:Get("atmos","cles"),true,true,true,function()
                RageUI.Separator('↓ Vos clées ↓')
                for selected = 1, #aPerso.Cles, 1 do
                    RageUI.ButtonWithStyle("["..aPerso.Cles[selected].plate.."]", nil, {RightLabel = '→→→'}, true,function(a,h,s)
                        if s then
                            plate = aPerso.Cles[selected].plate
                        end
                    end, RMenu:Get("atmos", "actioncle"))
                end
            end, function()end, 1)
            RageUI.IsVisible(RMenu:Get("atmos","actioncle"),true,true,true,function()
                RageUI.ButtonWithStyle("Donner le véhicule", nil, {RightBadge = RageUI.BadgeStyle.Car}, true,function(a,h,s)
                    if s then
                        local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                        if closestDistance ~= -1 and closestDistance <= 3 then
                            local closestPed = GetPlayerPed(closestPlayer)
                            TriggerServerEvent("aPersonalMenu:donnervoiture", GetPlayerServerId(closestPlayer), plate)
                        else
                            ESX.ShowNotification("Personnes autour", 'Problème')
                        end
                    end
                end)
                RageUI.ButtonWithStyle("~r~Détruire clées véhicules", nil, {RightBadge = RageUI.BadgeStyle.Alert}, true,function(a,h,s)
                    if s then
                        TriggerServerEvent("aPersonalMenu:detruire", plate)
                        RageUI.GoBack()
                    end
                end)
            end, function()end, 1)
            RageUI.IsVisible(RMenu:Get("atmos","divers"),true,true,true,function()
                RageUI.Checkbox("Activer/Désactiver le radar", nil, bol, { Style = RageUI.CheckboxStyle.Tick }, function(h, s, a, c)
                    bol = c;
                end, function()
                    DisplayRadar(false)
                end, function()
                    DisplayRadar(true)
                end)
                RageUI.ButtonWithStyle('Dormir / Se Reveiller', nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if (Selected) then
                        ragdoll()
                    end
                end)
            end, function()end, 1)
            RageUI.IsVisible(RMenu:Get("atmos","entreprise"),true,true,true,function()
                RageUI.Separator("↓ ~b~"..ESX.PlayerData.job.label.."~s~ - ~b~"..ESX.PlayerData.job.grade_label.." ~s~↓")
                if entrepriseargent ~= nil then
                    RageUI.Separator("↓ Coffre entreprise : ~g~"..entrepriseargent.." $ ~s~↓")
                end
                RageUI.ButtonWithStyle('Recruter une personne', nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if (Selected) then
                        if ESX.PlayerData.job.grade_name == 'boss' then
                            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

                            if closestPlayer == -1 or closestDistance > 3.0 then
                                ESX.ShowNotification('~r~Problème~s~ : Aucun joueur proche')
                            else
                                TriggerServerEvent('aPersonalMenu:Boss_recruterplayer', GetPlayerServerId(closestPlayer))
                            end
                        else
                            ESX.ShowNotification('~r~Problème~s~ : Vous n\'avez pas les ~r~droits~w~')
                        end
                    end
                end)

                RageUI.ButtonWithStyle('Virer une personne', nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if (Selected) then
                        if ESX.PlayerData.job.grade_name == 'boss' then
                            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

                            if closestPlayer == -1 or closestDistance > 3.0 then
                                ESX.ShowNotification('~r~Problème~s~ : Aucun joueur proche')
                            else
                                TriggerServerEvent('aPersonalMenu:Boss_virerplayer', GetPlayerServerId(closestPlayer))
                            end
                        else
                            ESX.ShowNotification('~r~Problème~s~ : Vous n\'avez pas les ~r~droits~w~')
                        end
                    end
                end)

                RageUI.ButtonWithStyle('Promouvoir une personne', nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if (Selected) then
                        if ESX.PlayerData.job.grade_name == 'boss' then
                            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

                            if closestPlayer == -1 or closestDistance > 3.0 then
                                ESX.ShowNotification('~r~Problème~s~ : Aucun joueur proche')
                            else
                                TriggerServerEvent('aPersonalMenu:Boss_promouvoirplayer', GetPlayerServerId(closestPlayer))
                            end
                        else
                            ESX.ShowNotification('~r~Problème~s~ : Vous n\'avez pas les ~r~droits~w~')
                        end
                    end
                end)

                RageUI.ButtonWithStyle('Destituer une personne', nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if (Selected) then
                        if ESX.PlayerData.job.grade_name == 'boss' then
                            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

                            if closestPlayer == -1 or closestDistance > 3.0 then
                                ESX.ShowNotification('~r~Problème~s~ : Aucun joueur proche')
                            else
                                TriggerServerEvent('aPersonalMenu:Boss_destituerplayer', GetPlayerServerId(closestPlayer))
                            end
                        else
                            ESX.ShowNotification('~r~Problème~s~ : Vous n\'avez pas les ~r~droits~w~')
                        end
                    end
                end)

                RageUI.ButtonWithStyle("Message aux employés", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if (Selected) then
                        local info = 'patron'
                        local message = KeyboardInput('bite', 'Message :', '', 40)
                        TriggerServerEvent('aPersonalMenu:envoyeremployer', info, message)
                    end
                end)
            end, function()end, 1)
            RageUI.IsVisible(RMenu:Get("atmos","organisation"),true,true,true,function()
                RageUI.Separator("↓ ~b~"..ESX.PlayerData.faction.label.."~s~ - ~b~"..ESX.PlayerData.faction.grade_label.." ~s~↓")
                if societymoney2 ~= nil then
                    RageUI.Separator("↓ Coffre organisation : ~r~"..societymoney2.." $ ~s~↓")
                end
                RageUI.ButtonWithStyle('Recruter une personne', nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if (Selected) then
                        if ESX.PlayerData.faction.grade_name == 'boss' then
                            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

                            if closestPlayer == -1 or closestDistance > 3.0 then
                                ESX.ShowNotification('~r~Problème~s~ : Aucun joueur proche')
                            else
                                TriggerServerEvent('aPersonalMenu:Boss_recruterplayer2', GetPlayerServerId(closestPlayer), ESX.PlayerData.faction.name, 0)
                            end
                        else
                            ESX.ShowNotification('~r~Problème~s~ : Vous n\'avez pas les ~r~droits~w~')
                        end
                    end
                end)

                RageUI.ButtonWithStyle('Virer une personne', nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if (Selected) then
                        if ESX.PlayerData.faction.grade_name == 'boss' then
                            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

                            if closestPlayer == -1 or closestDistance > 3.0 then
                                ESX.ShowNotification('~r~Problème~s~ : Aucun joueur proche')
                            else
                                TriggerServerEvent('aPersonalMenu:Boss_virerplayer2', GetPlayerServerId(closestPlayer))
                            end
                        else
                            ESX.ShowNotification('~r~Problème~s~ : Vous n\'avez pas les ~r~droits~w~')
                        end
                    end
                end)

                RageUI.ButtonWithStyle('Promouvoir une personne', nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if (Selected) then
                        if ESX.PlayerData.faction.grade_name == 'boss' then
                            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

                            if closestPlayer == -1 or closestDistance > 3.0 then
                                ESX.ShowNotification('~r~Problème~s~ : Aucun joueur proche')
                            else
                                TriggerServerEvent('aPersonalMenu:Boss_promouvoirplayer2', GetPlayerServerId(closestPlayer))
                            end
                        else
                            ESX.ShowNotification('~r~Problème~s~ : Vous n\'avez pas les ~r~droits~w~')
                        end
                    end
                end)

                RageUI.ButtonWithStyle('Destituer une personne', nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if (Selected) then
                        if ESX.PlayerData.faction.grade_name == 'boss' then
                            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

                            if closestPlayer == -1 or closestDistance > 3.0 then
                                ESX.ShowNotification('~r~Problème~s~ : Aucun joueur proche')
                            else
                                TriggerServerEvent('aPersonalMenu:Boss_destituerplayer2', GetPlayerServerId(closestPlayer))
                            end
                        else
                            ESX.ShowNotification('~r~Problème~s~ : Vous n\'avez pas les ~r~droits~w~')
                        end
                    end
                end)
            end, function()end, 1)
            RageUI.IsVisible(RMenu:Get("atmos", "gestionvehicle"),true,true,true,function()
                RageUI.Separator('↓ Véhicule ↓')
                RageUI.List("Ouvrir porte", aPerso.DoorList, aPerso.DoorIndex, nil, {}, true, function(h, a, s, i) aPerso.DoorIndex = i
                    if s then
                        if not IsPedSittingInAnyVehicle(PlayerPedId()) then
                            ESX.ShowNotification("~r~Problème~s~ : Vous devez être dans un véhicule !")
                        elseif IsPedSittingInAnyVehicle(PlayerPedId()) then
                            local plyVeh = GetVehiclePedIsIn(PlayerPedId(), false)
                            if i == 1 then
                                if not aPerso.DoorState.FrontLeft then
                                    aPerso.DoorState.FrontLeft = true
                                    SetVehicleDoorOpen(plyVeh, 0, false, false)
                                elseif aPerso.DoorState.FrontLeft then
                                    aPerso.DoorState.FrontLeft = false
                                    SetVehicleDoorShut(plyVeh, 0, false, false)
                                end
                            elseif i == 2 then
                                if not aPerso.DoorState.FrontRight then
                                    aPerso.DoorState.FrontRight = true
                                    SetVehicleDoorOpen(plyVeh, 1, false, false)
                                elseif aPerso.DoorState.FrontRight then
                                    aPerso.DoorState.FrontRight = false
                                    SetVehicleDoorShut(plyVeh, 1, false, false)
                                end
                            elseif i == 3 then
                                if not aPerso.DoorState.BackLeft then
                                    aPerso.DoorState.BackLeft = true
                                    SetVehicleDoorOpen(plyVeh, 2, false, false)
                                elseif aPerso.DoorState.BackLeft then
                                    aPerso.DoorState.BackLeft = false
                                    SetVehicleDoorShut(plyVeh, 2, false, false)
                                end
                            elseif i == 4 then
                                if not aPerso.DoorState.BackRight then
                                    aPerso.DoorState.BackRight = true
                                    SetVehicleDoorOpen(plyVeh, 3, false, false)
                                elseif aPerso.DoorState.BackRight then
                                    aPerso.DoorState.BackRight = false
                                    SetVehicleDoorShut(plyVeh, 3, false, false)
                                end
                            end
                        end
                    end
                    aPerso.DoorIndex = i
                end)
                RageUI.ButtonWithStyle("Ouvre/Fermer coffre", nil, {RightLabel = "→→→"}, true,function(a,h,s)
                    if s then
                        if not IsPedSittingInAnyVehicle(PlayerPedId()) then
                            ESX.ShowNotification("~r~Problème~s~ : Vous devez être dans un véhicule !")
                        elseif IsPedSittingInAnyVehicle(PlayerPedId()) then
                            local plyVeh = GetVehiclePedIsIn(PlayerPedId(), false)
                            if not aPerso.DoorState.Trunk then
                                aPerso.DoorState.Trunk = true
                                SetVehicleDoorOpen(plyVeh, 5, false, false)
                            elseif aPerso.DoorState.Trunk then
                                aPerso.DoorState.Trunk = false
                                SetVehicleDoorShut(plyVeh, 5, false, false)
                            end
                        end
                    end
                end)
                RageUI.ButtonWithStyle("Ouvrir/Fermer capot", nil, {RightLabel = "→→→"}, true,function(a,h,s)
                    if s then
                        if not IsPedSittingInAnyVehicle(PlayerPedId()) then
                            ESX.ShowNotification("~r~Problème~s~ : Vous devez être dans un véhicule !")
                        elseif IsPedSittingInAnyVehicle(PlayerPedId()) then
                            local plyVeh = GetVehiclePedIsIn(PlayerPedId(), false)

                            if not aPerso.DoorState.Hood then
                                aPerso.DoorState.Hood = true
                                SetVehicleDoorOpen(plyVeh, 4, false, false)
                            elseif aPerso.DoorState.Hood then
                                aPerso.DoorState.Hood = false
                                SetVehicleDoorShut(plyVeh, 4, false, false)
                            end
                        end
                    end
                end)
                RageUI.ButtonWithStyle("Allumer/Eteindre moteur", nil, {RightLabel = "→→→"}, true,function(a,h,s)
                    if s then
                        if not IsPedSittingInAnyVehicle(PlayerPedId()) then
                            ESX.ShowNotification("~r~Problème~s~ : Vous devez être dans un véhicule !")
                        elseif IsPedSittingInAnyVehicle(PlayerPedId()) then
                            local plyVeh = GetVehiclePedIsIn(PlayerPedId(), false)
                            if GetIsVehicleEngineRunning(plyVeh) then
                                SetVehicleEngineOn(plyVeh, false, false, true)
                                SetVehicleUndriveable(plyVeh, true)
                            elseif not GetIsVehicleEngineRunning(plyVeh) then
                                SetVehicleEngineOn(plyVeh, true, false, true)
                                SetVehicleUndriveable(plyVeh, false)
                            end
                        end
                    end
                end)
            end, function()end, 1)
            Wait(0)
        end
    end)
end

RegisterCommand('personalmenu', function()
    openMenuPersonal()
end, false)

RegisterKeyMapping('personalmenu', 'Menu personnel', 'keyboard', 'F5')

-- functions

-- Inventaire et vetements

function IsClothesCategory(itemName)
    return itemName:find('imask') or
    itemName:find('iears') or
    itemName:find('ihelmet') or
    itemName:find('iglass') or
    itemName:find('ibag') or
    itemName:find('hazmat') or
    itemName == 'covid'
end

function iventaire()
    ESX.PlayerData = ESX.GetPlayerData()
    RageUI.Separator('↓ Poids : ' .. ESX.PlayerData.weight .. '/' .. ESX.PlayerData.maxWeight .. 'kg ↓')
    for i = 1, #ESX.PlayerData.inv do
        if ESX.PlayerData.inv[i].count > 0 and IsClothesCategory(ESX.PlayerData.inv[i].name) == false then
            RageUI.ButtonWithStyle("> "..ESX.PlayerData.inv[i].label.." ("..ESX.PlayerData.inv[i].weight.."kg)", nil, {RightLabel = "Quantité : ~r~x"..ESX.PlayerData.inv[i].count}, true, function(Hovered, Active, Selected) 
                if (Selected) then 
                    aPerso.ItemSelected = ESX.PlayerData.inv[i]
                end
            end, RMenu:Get("atmos", "actioninventaire"))
        end
    end
end

function iventaire2()
    ESX.PlayerData = ESX.GetPlayerData()
    for i = 1, #ESX.PlayerData.inv do
        if ESX.PlayerData.inv[i].count > 0 and IsClothesCategory(ESX.PlayerData.inv[i].name) then
            RageUI.ButtonWithStyle("> "..ESX.PlayerData.inv[i].label.." ("..ESX.PlayerData.inv[i].weight.."kg)", nil, {RightLabel = "~r~x"..ESX.PlayerData.inv[i].count}, true, function(Hovered, Active, Selected)
                if (Selected) then
                    aPerso.ItemSelected = ESX.PlayerData.inv[i]
                end
            end, RMenu:Get("atmos", "actioninventaire"))
        end
    end
end

function armes()
    RageUI.Separator('↓ Vos Armes ↓')
    local weaponList = ESX.GetWeaponList()
    for i=1, #weaponList, 1 do
        local weaponHash = GetHashKey(weaponList[i].name)
        local Ammo = GetAmmoInPedWeapon(PlayerPedId(), weaponHash)
        if HasPedGotWeapon(PlayerPedId(), weaponHash, false) and weaponList[i].name ~= 'WEAPON_UNARMED' then
            RageUI.ButtonWithStyle("> "..weaponList[i].label, nil, {RightLabel = "Munition(s) : ~r~x"..Ammo}, true, function(Hovered, Active, Selected)
                if Selected then
                    aPerso.ItemSelected2 = weaponList[i]
                    aPerso.ItemSelected2.hash = weaponHash
                end
            end, RMenu:Get("atmos", "actionarme"))
        end
    end
end

RegisterNetEvent('aPersonalMenu:donnermunitions')
AddEventHandler('aPersonalMenu:donnermunitions', function(value, quantity)
    local weaponHash = GetHashKey(value)
    local PlayerPed = PlayerPedId()
    if HasPedGotWeapon(PlayerPed, weaponHash, false) and value ~= 'WEAPON_UNARMED' then
        AddAmmoToPed(PlayerPed, value, quantity)
        ESX.ShowNotification("Vous venez de recevoir ~g~x"..quantity.."~s~ !")
    end
end)

-- Vetements

function startAnimAction(lib, anim)
    ESX.Streaming.RequestAnimDict(lib, function()
        TaskPlayAnim(plyPed, lib, anim, 8.0, 1.0, -1, 49, 0, false, false, false)
        RemoveAnimDict(lib)
    end)
end

RegisterNetEvent('aPersonalMenu:actionhaut')
AddEventHandler('aPersonalMenu:actionhaut', function()
    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skina)
        TriggerEvent('skinchanger:getSkin', function(skinb)
            local lib, anim = 'clothingtie', 'try_tie_neutral_a'
            ESX.Streaming.RequestAnimDict(lib, function()
                TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
            end)
            Citizen.Wait(1000)
            ClearPedTasks(PlayerPedId())

            if skina.torso_1 ~= skinb.torso_1 then
                vethaut = true
                TriggerEvent('skinchanger:loadClothes', skinb, {['torso_1'] = skina.torso_1, ['torso_2'] = skina.torso_2, ['tshirt_1'] = skina.tshirt_1, ['tshirt_2'] = skina.tshirt_2, ['arms'] = skina.arms})
            else
                TriggerEvent('skinchanger:loadClothes', skinb, {['torso_1'] = 15, ['torso_2'] = 0, ['tshirt_1'] = 15, ['tshirt_2'] = 0, ['arms'] = 15})
                vethaut = false
            end
        end)
    end)
end)

RegisterNetEvent('aPersonalMenu:actionpantalon')
AddEventHandler('aPersonalMenu:actionpantalon', function()
    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skina)
        TriggerEvent('skinchanger:getSkin', function(skinb)
            local lib, anim = 'clothingtrousers', 'try_trousers_neutral_c'

            ESX.Streaming.RequestAnimDict(lib, function()
                TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
            end)
            Citizen.Wait(1000)
            ClearPedTasks(PlayerPedId())

            if skina.pants_1 ~= skinb.pants_1 then
                TriggerEvent('skinchanger:loadClothes', skinb, {['pants_1'] = skina.pants_1, ['pants_2'] = skina.pants_2})
                vetbas = true
            else
                vetbas = false
                if skina.sex == 1 then
                    TriggerEvent('skinchanger:loadClothes', skinb, {['pants_1'] = 15, ['pants_2'] = 3})
                else
                    TriggerEvent('skinchanger:loadClothes', skinb, {['pants_1'] = 91, ['pants_2'] = 1})
                end
            end
        end)
    end)
end)


RegisterNetEvent('aPersonalMenu:actionchaussure')
AddEventHandler('aPersonalMenu:actionchaussure', function()
    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skina)
        TriggerEvent('skinchanger:getSkin', function(skinb)
            local lib, anim = 'clothingshoes', 'try_shoes_positive_a'
            ESX.Streaming.RequestAnimDict(lib, function()
                TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
            end)
            Citizen.Wait(1000)
            ClearPedTasks(PlayerPedId())
            if skina.shoes_1 ~= skinb.shoes_1 then
                TriggerEvent('skinchanger:loadClothes', skinb, {['shoes_1'] = skina.shoes_1, ['shoes_2'] = skina.shoes_2})
                vetch = true
            else
                vetch = false
                if skina.sex == 1 then
                    TriggerEvent('skinchanger:loadClothes', skinb, {['shoes_1'] = 63, ['shoes_2'] = 0})
                else
                    TriggerEvent('skinchanger:loadClothes', skinb, {['shoes_1'] = 72, ['shoes_2'] = 0})
                end
            end
        end)
    end)
end)

RegisterNetEvent('aPersonalMenu:actionsac')
AddEventHandler('aPersonalMenu:actionsac', function()
    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skina)
        TriggerEvent('skinchanger:getSkin', function(skinb)
            local lib, anim = 'clothingtie', 'try_tie_neutral_a'
            ESX.Streaming.RequestAnimDict(lib, function()
                TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
            end)
            Citizen.Wait(1000)
            ClearPedTasks(PlayerPedId())
            if skina.bags_1 ~= skinb.bags_1 then
                TriggerEvent('skinchanger:loadClothes', skinb, {['bags_1'] = skina.bags_1, ['bags_2'] = skina.bags_2})
                vetsac = true
            else
                TriggerEvent('skinchanger:loadClothes', skinb, {['bags_1'] = 0, ['bags_2'] = 0})
                vetsac = false
            end
        end)
    end)
end)


RegisterNetEvent('aPersonalMenu:actiongiletparballe')
AddEventHandler('aPersonalMenu:actiongiletparballe', function()
    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skina)
        TriggerEvent('skinchanger:getSkin', function(skinb)
            local lib, anim = 'clothingtie', 'try_tie_neutral_a'
            ESX.Streaming.RequestAnimDict(lib, function()
                TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
            end)
            Citizen.Wait(1000)
            ClearPedTasks(PlayerPedId())
            if skina.bproof_1 ~= skinb.bproof_1 then
                TriggerEvent('skinchanger:loadClothes', skinb, {['bproof_1'] = skina.bproof_1, ['bproof_2'] = skina.bproof_2})
                vetgilet = true
            else
                TriggerEvent('skinchanger:loadClothes', skinb, {['bproof_1'] = 0, ['bproof_2'] = 0})
                vetgilet = false
            end
        end)
    end)
end)

function setAccessory(accessory)
    ESX.TriggerServerCallback('esx_accessories:get', function(hasAccessory, accessorySkin)
        local _accessory = (accessory):lower()

        if hasAccessory then
            TriggerEvent('skinchanger:getSkin', function(skin)
                local mAccessory = -1
                local mColor = 0

                if _accessory == 'ears' then
                    startAnimAction('mini@ears_defenders', 'takeoff_earsdefenders_idle')
                    Citizen.Wait(250)
                    ClearPedTasks(plyPed)
                elseif _accessory == 'glasses' then
                    mAccessory = 0
                    startAnimAction('clothingspecs', 'try_glasses_positive_a')
                    Citizen.Wait(1000)
                    ClearPedTasks(plyPed)
                elseif _accessory == 'helmet' then
                    startAnimAction('missfbi4', 'takeoff_mask')
                    Citizen.Wait(1000)
                    ClearPedTasks(plyPed)
                elseif _accessory == 'mask' then
                    mAccessory = 0
                    startAnimAction('missfbi4', 'takeoff_mask')
                    Citizen.Wait(850)
                    ClearPedTasks(plyPed)
                end

                if skin[_accessory .. '_1'] == mAccessory then
                    mAccessory = accessorySkin[_accessory .. '_1']
                    mColor = accessorySkin[_accessory .. '_2']
                end

                local accessorySkin = {}
                accessorySkin[_accessory .. '_1'] = mAccessory
                accessorySkin[_accessory .. '_2'] = mColor
                TriggerEvent('skinchanger:loadClothes', skin, accessorySkin)
            end)
        else
            if _accessory == 'ears' then
                ESX.ShowNotification("~r~Problème~s~ : Vous ne possédez pas d'accesoire d'oreilles !")
            elseif _accessory == 'glasses' then
                ESX.ShowNotification("~r~Problème~s~ : Vous ne possédez pas de lunette !")
            elseif _accessory == 'helmet' then
                ESX.ShowNotification("~r~Problème~s~ : Vous ne possédez pas de casque !")
            elseif _accessory == 'mask' then
                ESX.ShowNotification("~r~Problème~s~ : Vous ne possédez pas de masque !")
            end
        end
    end, accessory)
end



function argententre()
    if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.grade_name == 'boss' then
        ESX.TriggerServerCallback('esx_society:getSocietyMoney', function(money)
            entrepriseargent = ESX.Math.GroupDigits(money)
        end, ESX.PlayerData.job.name)
    end
end

function RefreshMoney2()
    if ESX.PlayerData.faction ~= nil and ESX.PlayerData.faction.grade_name == 'boss' then
        ESX.TriggerServerCallback('esx_society:getSocietyMoney', function(money)
            societymoney2 = ESX.Math.GroupDigits(money)
        end, ESX.PlayerData.faction.name)
    end
end

function ragdoll()
    ragdolling = not ragdolling
    while ragdolling do
        Wait(0)
        local myPed = GetPlayerPed(-1)
        SetPedToRagdoll(myPed, 1000, 1000, 0, 0, 0, 0)
        ResetPedRagdollTimer(myPed)
        AddTextEntry(GetCurrentResourceName(), ('Appuyez sur ~INPUT_JUMP~ pour vous ~b~Réveillé'))
        DisplayHelpTextThisFrame(GetCurrentResourceName(), false)
        ResetPedRagdollTimer(myPed)
        if IsControlJustPressed(0, 22) then
            break
        end
    end
end

RegisterCommand('ragdol', function()
    ragdoll()
end)

-- Pointing

local function startPointing()
    local ped = GetPlayerPed(-1)
    RequestAnimDict("anim@mp_point")
    while not HasAnimDictLoaded("anim@mp_point") do
        Wait(0)
    end
    SetPedCurrentWeaponVisible(ped, 0, 1, 1, 1)
    SetPedConfigFlag(ped, 36, 1)
    Citizen.InvokeNative(0x2D537BA194896636, ped, "task_mp_pointing", 0.5, 0, "anim@mp_point", 24)
    RemoveAnimDict("anim@mp_point")
end

local function stopPointing()
    local ped = GetPlayerPed(-1)
    Citizen.InvokeNative(0xD01015C7316AE176, ped, "Stop")
    if not IsPedInjured(ped) then
        ClearPedSecondaryTask(ped)
    end
    if not IsPedInAnyVehicle(ped, 1) then
        SetPedCurrentWeaponVisible(ped, 1, 1, 1, 1)
    end
    SetPedConfigFlag(ped, 36, 0)
    ClearPedSecondaryTask(PlayerPedId())
end

local pointing = false
local handsUp = false
local crouched = false

RegisterCommand('pointing', function()
    local plyPed = PlayerPedId()
    if (DoesEntityExist(plyPed)) and (not IsEntityDead(plyPed)) and (IsPedOnFoot(plyPed)) then
        if handsUp then
            handsUp = false
        end
        pointing = not pointing
        if pointing then
            startPointing()
        else
            stopPointing()
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        interval = 750
        if pointing then
            interval = 1
            local ped = PlayerPedId()
            local camPitch = GetGameplayCamRelativePitch()
            if camPitch < -70.0 then
                camPitch = -70.0
            elseif camPitch > 42.0 then
                camPitch = 42.0
            end
            camPitch = (camPitch + 70.0) / 112.0
            local camHeading = GetGameplayCamRelativeHeading()
            local cosCamHeading = Cos(camHeading)
            local sinCamHeading = Sin(camHeading)
            if camHeading < -180.0 then
                camHeading = -180.0
            elseif camHeading > 180.0 then
                camHeading = 180.0
            end
            camHeading = (camHeading + 180.0) / 360.0
            local coords = GetOffsetFromEntityInWorldCoords(ped, (cosCamHeading * -0.2) - (sinCamHeading * (0.4 * camHeading + 0.3)), (sinCamHeading * -0.2) + (cosCamHeading * (0.4 * camHeading + 0.3)), 0.6)
            local rayHandle, blocked = GetShapeTestResult(StartShapeTestCapsule(coords.x, coords.y, coords.z - 0.2, coords.x, coords.y, coords.z + 0.2, 0.4, 95, ped, 7))
            SetTaskMoveNetworkSignalFloat(ped, 'Pitch', camPitch)
            SetTaskMoveNetworkSignalFloat(ped, 'Heading', (camHeading * -1.0) + 1.0)
            SetTaskMoveNetworkSignalBool(ped, 'isBlocked', blocked)
            SetTaskMoveNetworkSignalBool(ped, 'isFirstPerson', N_0xee778f8c7e1142e2(N_0x19cafa3c87f7c2ff()) == 4)
        end
        Wait(interval)
    end
end)

RegisterCommand("crounch", function()
    DisableControlAction(0, 36, true)
    crouched = not crouched
    if crouched then
        ESX.Streaming.RequestAnimSet('move_ped_crouched', function()
            SetPedMovementClipset(PlayerPedId(), 'move_ped_crouched', 0.25)
            RemoveAnimSet('move_ped_crouched')
        end)
    else
        ResetPedMovementClipset(PlayerPedId(), 0)
    end
end)

RegisterCommand('handsup', function()
    local plyPed = PlayerPedId()
    if (DoesEntityExist(plyPed)) and not (IsEntityDead(plyPed)) and (IsPedOnFoot(plyPed)) then
        if pointing then
            pointing = false
        end
        handsUp = not handsUp
        if handsUp then
            ESX.Streaming.RequestAnimDict('random@mugging3', function()
                TaskPlayAnim(plyPed, 'random@mugging3', 'handsup_standing_base', 8.0, -8, -1, 49, 0, 0, 0, 0)
                RemoveAnimDict('random@mugging3')
            end)
        else
            ClearPedSecondaryTask(plyPed)
        end
    end
end)

RegisterKeyMapping('handsup', 'Mains en l\'air', 'keyboard', 'x')
RegisterKeyMapping('pointing', 'Pointer du doigt', 'keyboard', 'b')
RegisterKeyMapping('ragdol', 'S\'écrouler', 'keyboard', 'EQUALS')
RegisterKeyMapping('crounch', 'S\'accroupir', 'keyboard', 'LCONTROL')


local RSGCore = exports['rsg-core']:GetCoreObject()
local horseSpawned = false
local RodeoSecondsRemaining = 0
local rodeoactive = false
lib.locale()

--------------------------------------
-- prompts and blips
--------------------------------------
Citizen.CreateThread(function()
    for _,v in pairs(Config.RodeoLocations) do
        exports['rsg-core']:createPrompt(v.prompt, v.coords, RSGCore.Shared.Keybinds[Config.Keybind], locale('cl_lang_13'), {
            type = 'client',
            event = 'rex-rodeo:client:choosestake',
            args = { v.horsespawn, v.horsemodel }
        })
        if v.showblip == true then    
            local RodeoBlip = BlipAddForCoords(1664425300, v.blipCoords)
            SetBlipSprite(RodeoBlip, joaat(v.blipSprite), true)
            SetBlipScale(RodeoBlip, v.blipScale)
            SetBlipName(RodeoBlip, v.blipName)
        end
    end
end)

----------------------------------------------------
-- function time format
----------------------------------------------------
function secondsToClock(seconds)
    local hours = math.floor(seconds / 3600)
    local minutes = math.floor((seconds % 3600) / 60)
    local seconds = math.floor(seconds % 60)
    return string.format("%02d:%02d:%02d", hours, minutes, seconds)
end

----------------------------------------------------
-- rodeo timer
----------------------------------------------------
local function RodeoTimer(stake, horsePed, playerCoords)
    
    RodeoSecondsRemaining = (45)

    local success = math.random(0,1)
    local failtime = math.random(30,Config.RideTime-1)

    CreateThread(function()
        
        while true do

            if RodeoSecondsRemaining > 0 then
                
                Wait(1000)
                RodeoSecondsRemaining = RodeoSecondsRemaining - 1

                local mounted = IsPedOnMount(cache.ped)
                
                -- player unmounts from horse : fail
                if not mounted then
                    Wait(3000)
                    DoScreenFadeOut(500)
                    DeleteEntity(horsePed)
                    horseSpawned = false
                    rodeoactive = false
                    Wait(1000)
                    SetEntityCoordsAndHeading(cache.ped, playerCoords)
                    Wait(1500)
                    DoScreenFadeIn(1800)
                    lib.notify({ 
                        title = locale('cl_lang_1'),
                        description = locale('cl_lang_2'),
                        type = 'error',
                        position = 'center-right',
                        duration = 7000
                    })
                end
                
                -- fail rodeo and throw rider
                if success == 0 and RodeoSecondsRemaining == failtime and horseSpawned == true then
                    TaskHorseAction(horsePed, 2, 0, 0)
                    Wait(3000)
                    DoScreenFadeOut(500)
                    DeleteEntity(horsePed)
                    horseSpawned = false
                    rodeoactive = false
                    Wait(1000)
                    SetEntityCoordsAndHeading(cache.ped, playerCoords)
                    Wait(1500)
                    DoScreenFadeIn(1800)
                    lib.notify({ 
                        title = locale('cl_lang_1'),
                        description = locale('cl_lang_3')..stake,
                        type = 'error',
                        position = 'center-right',
                        duration = 7000
                    })
                end
                
                -- successful rodeo
                if RodeoSecondsRemaining == 0 and horseSpawned == true then
                    Wait(3000)
                    DoScreenFadeOut(500)
                    DeleteEntity(horsePed)
                    horseSpawned = false
                    rodeoactive = false
                    Wait(1000)
                    SetEntityCoordsAndHeading(cache.ped, playerCoords)
                    Wait(1500)
                    DoScreenFadeIn(1800)
                    local doublestake = stake * 2
                    TriggerServerEvent('rex-rodeo:server:paydoublestake', doublestake)
                    lib.notify({ 
                        title = locale('cl_lang_4'),
                        description = locale('cl_lang_5')..doublestake,
                        type = 'success',
                        position = 'center-right',
                        duration = 7000
                    })
                end
            end

            -- show clock
            if rodeoactive then
                local formattedTime = secondsToClock(RodeoSecondsRemaining)
                lib.showTextUI(locale('cl_lang_6')..formattedTime, {
                    position = "top-center",
                    icon = 'fa-regular fa-clock',
                    style = {
                        borderRadius = 0,
                        backgroundColor = '#82283E',
                        color = 'white'
                    }
                })
                Wait(0)
            else
                lib.hideTextUI()
                return
            end
            Wait(0)
        end
    end)
end

RegisterNetEvent('rex-rodeo:client:choosestake', function(horsespawn, horsemodel)

    RSGCore.Functions.TriggerCallback('rex-rodeo:server:getmoney', function(results)

        local input = lib.inputDialog(locale('cl_lang_7'), {
            { 
                label = locale('cl_lang_8'),
                description = locale('cl_lang_9'),
                type = 'select',
                options = { 
                    { value = Config.Stake1Value, label = Config.Stake1Label },
                    { value = Config.Stake2Value, label = Config.Stake2Label },
                    { value = Config.Stake3Value, label = Config.Stake3Label },
                    { value = Config.Stake4Value, label = Config.Stake4Label },
                    { value = Config.Stake5Value, label = Config.Stake5Label }
                },
                required = true,
                icon = 'fa-solid fa-circle-question'
            },
        })

        if not input then
            return
        end

        local cash = tonumber(results)
        local stake = tonumber(input[1])

        if cash >= stake then
            TriggerServerEvent('rex-rodeo:server:paystake', input[1], horsespawn, horsemodel)
        else
            lib.notify({ 
                title = locale('cl_lang_10'),
                description = locale('cl_lang_11')..stake..locale('cl_lang_12'),
                type = 'error',
                position = 'center-right',
                duration = 7000
            })
        end
        
    end)

end)

RegisterNetEvent('rex-rodeo:client:startrodeo', function(stake, horsespawn, horsemodel)

    local playerCoords = GetEntityCoords(cache.ped)

    if not horseSpawned then

        RequestModel(horsemodel)
        
        while not HasModelLoaded(horsemodel) do
            Wait(500)
        end

        -- spawn rodeo horse
        local horsePed = CreatePed(horsemodel, horsespawn.x, horsespawn.y, horsespawn.z, 0.0, true, false)
        TaskMountAnimal(cache.ped, horsePed, 10000, -1, 1.0, 1, 0, 0)
        SetRandomOutfitVariation(horsePed, true)
        EnableAttributeOverpower(horsePed, 0, 10000.0) -- health overpower
        EnableAttributeOverpower(horsePed, 1, 10000.0) -- stamina overpower
        EnableAttributeOverpower(horsePed, 0, 10000.0) -- set health with overpower
        EnableAttributeOverpower(horsePed, 1, 10000.0) -- set stamina with overpower
        ApplyShopItemToPed(horsePed, -447673416, true, true, true) -- add saddle
        Citizen.InvokeNative(0xA3DB37EDF9A74635, PlayerId(), horsePed, 27, 1, true)
        NetworkSetEntityInvisibleToNetwork(horsePed, true)
        horseSpawned = true
        rodeoactive = true
        
        RodeoTimer(stake, horsePed, playerCoords)
        
        -- set horse always wild
        while horseSpawned do
            local isWild = GetAnimalIsWild(horsePed)
            if isWild == 0 then
                SetAnimalIsWild(horsePed, true)
            end
            Wait(1000)
        end

    end
end)

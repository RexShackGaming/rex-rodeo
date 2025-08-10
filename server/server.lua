local RSGCore = exports['rsg-core']:GetCoreObject()
lib.locale()

----------------------------------------------------
-- get cash
----------------------------------------------------
RSGCore.Functions.CreateCallback('rex-rodeo:server:getmoney', function(source, cb)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    local cash = Player.PlayerData.money['cash']
    cb(cash)
end)

----------------------------------------------------
-- pay stake and start rodeo
----------------------------------------------------
RegisterNetEvent('rex-rodeo:server:paystake', function(stake, horsespawn, horsemodel)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    Player.Functions.RemoveMoney('cash', stake, 'rodeo-stake')
    TriggerClientEvent('rex-rodeo:client:startrodeo', src, stake, horsespawn, horsemodel)
end)

----------------------------------------------------
-- pay double stake
----------------------------------------------------
RegisterNetEvent('rex-rodeo:server:paydoublestake', function(doublestake)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    Player.Functions.AddMoney('cash', doublestake, 'rodeo-stake')
end)

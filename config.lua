Config = {}

---------------------------------
-- general settings
---------------------------------
Config.AutoMount = true
Config.DistanceThreshold = 10.0
Config.Keybind = 'J'
Config.RideTime = 45

---------------------------------
-- npc settings
---------------------------------
Config.DistanceSpawn = 20.0
Config.FadeIn = true

---------------------------------
-- rodeo settings
---------------------------------
Config.RodeoLocations = {

    {
        name = 'Rodeo',
        prompt = 'rodeo1',
        coords = vector3(1393.51, 227.37, 91.20),
        horsespawn = vector3(1386.10, 222.21, 91.47),
        horsemodel = `a_c_horse_andalusian_darkbay`,
        npcmodel = `u_m_m_bwmstablehand_01`,
        npccoords = vector4(1393.51, 227.37, 91.20, 308.73),
        blipCoords = vector3(1393.51, 227.37, 91.20),
        blipSprite = 'blip_shop_horse_saddle',
        blipScale = 0.2,
        blipName = 'Rodeo',
        showblip = true
    },

}

---------------------------------
-- stake settings
---------------------------------
Config.Stake1Value = '5'
Config.Stake1Label = '$5'

Config.Stake2Value = '10'
Config.Stake2Label = '$10'

Config.Stake3Value = '15'
Config.Stake3Label = '$15'

Config.Stake4Value = '25'
Config.Stake4Label = '$25'

Config.Stake5Value = '50'
Config.Stake5Label = '$50'
---------------------------------

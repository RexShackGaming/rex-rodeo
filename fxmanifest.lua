fx_version 'cerulean'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'
game 'rdr3'

description 'rex-rodeo'
version '2.0.2'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua',
}

client_scripts {
    'client/client.lua',
    'client/npcs.lua'
}

server_scripts {
    'server/server.lua'
}

dependencies {
    'rsg-core',
    'rsg-target',
    'ox_lib',
}

files {
  'locales/*.json'
}

this_is_a_map 'yes'

lua54 'yes'

fx_version 'bodacious'
game 'gta5'

shared_scripts {
    'shared/*.lua'
}


server_scripts {
    '@async/async.lua',
    '@mysql-async/lib/MySQL.lua',
    'server/**/*.lua',
}

client_scripts {
    'lib/RageUI/RMenu.lua',
    'lib/RageUI/menu/RageUI.lua',
    'lib/RageUI/menu/Menu.lua',
    'lib/RageUI/menu/MenuController.lua',
    'lib/RageUI/components/*.lua',
    'lib/RageUI/menu/elements/*.lua',
    'lib/RageUI/menu/items/*.lua',
    'lib/RageUI/menu/panels/*.lua',
    'lib/RageUI/menu/windows/*.lua',
    'client/**/*.lua',
}

dependency 'es_extended'


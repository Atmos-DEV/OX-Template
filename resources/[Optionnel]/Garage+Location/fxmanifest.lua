fx_version 'bodacious'
game 'gta5'

shared_scripts {
    '@es_extended/locale.lua',
    -- Export
    "utils/export.lua",
    -- Utils
    "utils/**/shared/*.lua",
    -- Others
    "others/**/shared/*.lua",
}


server_scripts {
    '@async/async.lua',
    "@mysql-async/lib/MySQL.lua",
    -- Utils
    "utils/**/server/*.lua",
    -- Others
    "others/**/server/*.lua",
}

client_scripts {
    -- RageUi
    "lib/RageUI/RMenu.lua",
    "lib/RageUI/menu/RageUI.lua",
    "lib/RageUI/menu/Menu.lua",
    "lib/RageUI/menu/MenuController.lua",
    "lib/RageUI/components/*.lua",
    "lib/RageUI/menu/elements/*.lua",
    "lib/RageUI/menu/items/*.lua",
    "lib/RageUI/menu/panels/*.lua",
    "lib/RageUI/menu/windows/*.lua",


    -- Utils
    "utils/**/client/*.lua",
    -- Others
    "others/**/client/*.lua",
}
fx_version 'adamant'
game 'gta5'

client_scripts {
	'config.lua',
	'client/classes/status.lua',
	'client/main.lua'
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'config.lua',
	'server/main.lua'
}

ui_page {
	"html/ui.html"
}

files {
	'html/ui.html',
	'html/css/app.css',
	'html/scripts/app.js'
}

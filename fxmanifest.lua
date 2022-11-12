fx_version 'adamant'
games { 'gta5' }

author 'Musiker15 - MSK Scripts'
name 'msk_setplayerped'
description 'Set your PlayerPed to an animal'
version '1.0'

lua54 'yes'

client_scripts {
	'client.lua',
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'server.lua'
}
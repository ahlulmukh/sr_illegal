-- Fx Info
fx_version 'cerulean'
game 'gta5'
lua54 'yes'


-- Resource Info
version '1.0.0'
author 'Bagah Project'
description 'Penyabut ganja rework'


-- Shared Script
shared_scripts {
	'@ox_lib/init.lua',
	'config.lua',
}

-- Server Script
server_scripts {
	'server/main.lua',
	'bridge/server/**.lua',
}

-- Client Side Script
client_scripts {
	'bridge/client/**.lua',
	'client/main.lua',
	'client/proses.lua',
	'client/sell.lua',
	'client/cuciduit.lua',
}

fx_version 'cerulean'
game 'rdr3'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

description 'QB-Diceroll'
version '1.0.0'

shared_scripts { 
	'config.lua'
}

client_scripts {
	"client/main.lua",
    "config.lua",
}

server_scripts {
    "server/main.lua",
    "config.lua",
}
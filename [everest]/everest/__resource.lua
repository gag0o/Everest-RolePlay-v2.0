resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

client_scripts {
	"@vrp/lib/utils.lua",
	"lib/utils.lua",
	"lib/enum.lua",
	"cfg/npcs.lua",
	"client/client.lua",
	"client/troca_assento.lua",
	--"client/recoil.lua",
	--"client/pistola.lua",
	--"client/npc_control.lua",
	"client/realisticvehicle.lua",
	"client/remove_dano.lua",
	"client/guincho.lua",
	-- "client/forcefirst.lua",
	-- "client/armas_costas.lua",
}

server_scripts {
	"@vrp/lib/utils.lua",
	"lib/utils.lua",
	"server/server.lua",
	"server/discordPost.lua",
}
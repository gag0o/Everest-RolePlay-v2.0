resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

ui_page "nui/index.html"

client_scripts {
	"@vrp/lib/utils.lua",
	"client.lua"
}

server_scripts {
	"@vrp/lib/utils.lua",
	"server.lua"
}

files {
	"nui/css.css",
	"nui/jquery.js",
	"nui/index.html",
	"nui/inicio.html",
	"nui/armamentos.html",
	"nui/municoes.html",
	"nui/images/background.png"
}
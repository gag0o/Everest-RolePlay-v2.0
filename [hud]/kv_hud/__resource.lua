resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

client_scripts {
    "@vrp/lib/utils.lua",
    'config.lua',
    'client.lua',
    "controle_fome_sede.lua"
}

server_scripts {
    "@vrp/lib/utils.lua",
    'config.lua',
    'server.lua'
}


ui_page "HTML/index.html"

files {
    "HTML/fonts/*",
    "HTML/images/*",
    "HTML/design.css",
    "HTML/index.html",
    "HTML/script.js",
    "HTML/images/disneylogo.gif"
}

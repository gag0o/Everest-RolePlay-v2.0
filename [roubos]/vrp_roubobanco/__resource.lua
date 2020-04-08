------------------------------------------------------
----------https://github.com/DaviReisVieira-----------
------------EMAIL:VIEIRA08DAVI38@GMAIL.COM------------
---------------DISCORD: DAVI REIS #2602---------------
------------------------------------------------------

resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description "vrp_hacker por Davi Reis"

dependency "vrp"

client_scripts{ 
  "@vrp/lib/utils.lua",
  "config.lua",
  "client.lua"
}

server_scripts{ 
  "@vrp/lib/utils.lua",
  "config.lua",
  "server.lua"
}
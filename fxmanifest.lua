fx_version "cerulean"
game "gta5"
lua54 "yes"

author "Edward Lewis"
description "A resource that interacts with Discord's API"

client_script "client.lua"

server_scripts {
  "config.lua",
  "server/api.lua",
  "server/logging.lua",
}
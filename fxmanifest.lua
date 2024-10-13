fx_version "cerulean"
game "gta5"
lua54 "yes"

author "Edward Lewis"
description "A queue system to manage player queues."

client_script "client.lua"

server_scripts {
  "config.lua",
  "server/api.lua",
  "server/logging.lua",
  "example.lua"
}
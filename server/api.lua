API = setmetatable({ cache = {} }, {
  __index = function(table, index)
    return rawget(table, index)
  end
})

local token <const> = GetConvar("discord_token", "not-found")
local guild <const> = GetConvar("discord_guild", "not-found")

CreateThread(function()
  if token == "not-found" and guild == "not-found" then 
    API:logging("error", ("Missing Information - ^8token: %s^7, ^8guild: %s^7"):format(token, guild))
  else
    local resultGuild = API:request("GET", ("guilds/%s"):format(guild))

    if resultGuild then
      API:logging("success", ("Authenticated Discord To ^2%s^7"):format(resultGuild.name))
    else
      API:logging("error", "Discord Authentication Failed - Make Sure You Configed The Correct Guild And Token")
    end
  end
end)

local headers <const> = {
  ["Content-Type"] = "application/json", 
  ["Authorization"] = ("Bot %s"):format(token)
}

---Request Discord's API
---@param method string
---@param endpoint string
function API:request(method, endpoint)
  assert(method and endpoint, ("Missing Arguments - method: %s, endpoint: %s"):format(method, endpoint))

  if token == "not-found" and guild == "not-found" then 
    return self:logging("error", ("Missing Information - token: %s, guild: %s"):format(token, guild))
  end

  local endpoint <const> = ("https://discord.com/api/v10/%s"):format(endpoint)
  local promise = promise.new()

  PerformHttpRequest(endpoint, function(status, body, _, _)
    if status == 200 then
      promise:resolve(json.decode(body))
    else
      promise:reject("Request was not successful.")
    end
  end, method, "", headers)

  return Citizen.Await(promise)
end

--- Creates discord cache for player
---@param playerId number
function API:createCache(playerId)
  local name <const> = GetPlayerName(playerId)

  if self:fetchCache(playerId) then
    return self:logging("warn", ("Cache For ^3%s^7 Already Exists"):format(name))
  end

  local identifier <const> = GetPlayerIdentifierByType(tostring(playerId), "discord")

  if not identifier then
    self.cache[playerId] = {
      username = "Not Found",
      avatar = "https://files.catbox.moe/1zzk92.png", -- Default Avatar
      roles = {}
    }

    return self:logging("success", ("Successfully Created Discord Cache For ^2%s^7"):format(name))
  end

  local formattedIdentifier <const> = identifier:gsub("discord:", "")
  local profile <const> = self:request("GET", ("guilds/%s/members/%s"):format(guild, formattedIdentifier))

  if not profile then return self:logging("error", "An Error Occured Trying To Fetch Player Profile") end

  self.cache[playerId] = {
    username = profile.username,
    avatar = ("https://cdn.discordapp.com/avatars/%s/%s"):format(formattedIdentifier, profile.avatar),
    roles = profile.roles
  }
  
  self:logging("success", ("Successfully Created Discord Cache For ^2%s^7"):format(name))
end

--- Fetches players discord cache
---@param playerId number
---@return table | nil
function API:fetchCache(playerId)
  return self.cache[playerId]
end

---Deletes players discord cache
---@param playerId number
function API:deleteCache(playerId)
  local name <const> = GetPlayerName(playerId)

  if not self:fetchCache(playerId) then
    return self:logging("error", ("Could Not Find Cache For ^8%s^7"):format(name))
  end

  self.cache[playerId] = nil

  self:logging("success", ("Successfully Deleted Cache For ^2%s^7"):format(name))
end

---Fetches players discord roles
---@param playerId number
---@return table
function API:GetDiscordRoles(playerId)
  return self.cache[playerId]?.roles
end

---Fetches players discord username
---@param playerId number
---@return string
function API:GetDiscordUsername(playerId)
  return self.cache[playerId]?.username
end

---Fetches players discord avatar
---@param playerId number
---@return string
function API:GetDiscordAvatar(playerId)
  return self.cache[playerId]?.avatar
end

RegisterNetEvent("over_discord:playerLoaded", function()
  local source = source

  API:createCache(source)
end)

AddEventHandler("playerDropped", function()
  local source = source

  API:deleteCache(source)
end)

exports("FetchCache", function(playerId) API:fetchCache(playerId) end)
exports("DeleteCache", function(playerId) API:deleteCache(playerId) end)
exports("GetDiscordRoles", function(playerId) API:GetDiscordRoles(playerId) end)
exports("GetDiscordUsername", function(playerId) API:GetDiscordUsername(playerId) end)
exports("GetDiscordAvatar", function(playerId) API:GetDiscordAvatar(playerId) end)
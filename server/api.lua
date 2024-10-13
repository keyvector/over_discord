API = setmetatable({ cache = {} }, {
  __index = function(table, index)
    return rawget(table, index)
  end
})

local token <const> = GetConvar("discord_token", "not-found")
local guild <const> = GetConvar("discord_guild", "not-found")

if token == "not-found" and guild == "not-found" then 
  API:logging("warn", ("Missing Information - token: %s, guild: %s"):format(token, guild))
end

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
    return self:logging("warn", ("Missing Information - token: %s, guild: %s"):format(token, guild))
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

function API:createCache(player)
  if self:fetchCache(player) then
    return self:logging("warn", ("Cache for %s already exists"):format(GetPlayerName(player)))
  end

  -- local identifier = GetPlayerIdentifierByType(player, "discord"):gsub("discord:", "")

  -- if not identifier then
  --   self.cache[player] = {
  --     username = "Not Found",
  --     avatar = "https://files.catbox.moe/1zzk92.png", -- Default Avatar
  --     roles = {}
  --   }
  -- end

  local username = self:request("GET", "users/427864377043976216")

  print(json.encode(username, { indent = true }))
end

function API:fetchCache(player)
  return self.cache[player]
end

API:createCache(1)
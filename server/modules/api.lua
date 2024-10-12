local token <const> = GetConvar("discord_token", "not-found")
local guild <const> = GetConvar("discord_guild", "not-found")

assert(token and guild, ("Missing Information - token: %s, guild: %s"):format(token, guild))

local headers <const> = {
  ["Content-Type"] = "application/json", 
  ["Authorization"] = ("Bot %s"):format(token)
}

API = setmetatable({}, {
  __index = function(table, index)
    return rawget(table, index)
  end
})

---Request Discord's API
---@param method string
---@param endpoint string
function API:request(method, endpoint)
  assert(method and endpoint, ("Missing Arguments - method: %s, endpoint: %s"):format(method, endpoint))

  local endpoint <const> = ("https://discord.com/api/%s"):format(endpoint)
  local promise = promise.new()

  PerformHttpRequest(endpoint, function(status, body, _, _)
    print(status, body, _, _)
  end, method, "")

  return Citizen.Await(promise)
end
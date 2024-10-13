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

  local endpoint <const> = ("https://discord.com/api/%s"):format(endpoint)
  local promise = promise.new()

  PerformHttpRequest(endpoint, function(status, body, _, _)
    if status == 200 then
      promise:resolve(body)
    else
      promise:reject("Request was not successful.")
    end
  end, method, "", headers)

  return Citizen.Await(promise)
end

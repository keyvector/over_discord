--- Logs a message in the server console
---@param type string
---@param message string
function API:logging(type, message)
  if not Config.logging then return end

  local resource = GetCurrentResourceName()
  local time = os.date("%Y-%m-%d %H:%M:%S")

  if type == "warn" then
    return print(("[%s] [WARN] [%s] %s"):format(time, resource, message))
  elseif type == "success" then
    return print(("[%s] [SUCCESS] [%s] %s"):format(time, resource, message))
  elseif type == "error" then
    return print(("[%s] [ERROR] [%s] %s"):format(time, resource, message))
  end
end
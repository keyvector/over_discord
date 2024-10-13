--- Logs a message in the server console
---@param type string
---@param message string
function API:logging(type, message)
  if not Config.logging then return end

  local resource = GetCurrentResourceName()
  local time = os.date("%Y-%m-%d %H:%M:%S")

  if type == "warn" then
    return print(("^3[%s] [WARN] [%s]^7 %s"):format(time, resource, message))
  elseif type == "success" then
    return print(("^2[%s] [SUCCESS] [%s]^7 %s"):format(time, resource, message))
  elseif type == "error" then
    return print(("^8[%s] [ERROR] [%s]^7 %s"):format(time, resource, message))
  end
end
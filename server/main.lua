Queue = setmetatable({}, {
  __index = function(table, index)
    return rawget(table, index)
  end
})
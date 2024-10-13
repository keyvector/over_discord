Queue = setmetatable({ list = {} }, {
  __index = function(table, index)
    return rawget(table, index)
  end
})

local function showAdaptiveCard(deferrals)
  return deferrals.presentCard({
    ["type"] = "AdaptiveCard",
    ["$schema"] = "http://adaptivecards.io/schemas/adaptive-card.json",
    ["version"] = "1.2",
    ["body"] = {
      {
        ["type"] = "TextBlock",
        ["text"] = "Over Queue System",
        ["size"] = "ExtraLarge",
        ["horizontalAlignment"] = "Center",
        ["weight"] = "Bolder",
        ["isSubtle"] = true
      }
    }
  })
end

function Queue:add(source, identifier, deferrals)
  deferrals.defer()

  showAdaptiveCard(deferrals)
end

AddEventHandler("playerConnecting", function(name, _, deferrals)
  local source <const> = source
  -- local identifier <const> = GetPlayerIdentifierByType(source, "discord"):gsub("discord:", "")

  Queue:add(source, identifier, deferrals)
end)
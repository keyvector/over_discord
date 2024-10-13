CreateThread(function()
  repeat
    Wait(500)
  until NetworkIsPlayerActive(PlayerId())

  TriggerServerEvent("over_discord:playerLoaded")
end)
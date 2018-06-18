--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

net.Receive( "get_yrp_realistic_neww", function( len )
  if pa( settingsWindow ) then

  end
end)

hook.Add( "open_server_realistic", "open_server_realistic", function()
  SaveLastSite()
  local ply = LocalPlayer()

  local w = settingsWindow.window.sitepanel:GetWide()
  local h = settingsWindow.window.sitepanel:GetTall()

  settingsWindow.window.site = createD( "DPanel", settingsWindow.window.sitepanel, w, h, 0, 0 )
end)

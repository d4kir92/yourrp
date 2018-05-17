--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

local _advertname = "NULL"
local _restartTime = 0
hook.Add( "open_server_general", "open_server_general", function()
  SaveLastSite()
  local ply = LocalPlayer()

  local w = settingsWindow.window.sitepanel:GetWide()
  local h = settingsWindow.window.sitepanel:GetTall()

  settingsWindow.window.site = createD( "DPanel", settingsWindow.window.sitepanel, w, h, 0, 0 )

  local _ug = string.lower( ply:GetUserGroup() )
  if _ug == "superadmin" or _ug == "owner" then
    
  else
    F8RequireUG( lang_string( "general" ), "superadmin or owner" )
  end
end)

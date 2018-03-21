--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

hook.Add( "open_yourp_contact", "open_yourp_contact", function()
  local ply = LocalPlayer()

  local w = settingsWindow.window.sitepanel:GetWide()
  local h = settingsWindow.window.sitepanel:GetTall()

  settingsWindow.window.site = createD( "DPanel", settingsWindow.window.sitepanel, w, h, 0, 0 )
  settingsWindow.window.site.Paint = function( self, w, h ) draw.RoundedBox( 4, 0, 0, w, h, get_dbg_col() ) end

  function settingsWindow.window.site:Paint()
    --
  end

  local button = createVGUI( "DButton", settingsWindow.window.site, 2070, 2070, 0, 0 )
  button:SetText( lang_string( "contact" ) .. " (Discord-Link)" )
  function button:DoClick()
    gui.OpenURL( "https://discord.gg/CXXDCMJ" )
  end
end)

--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

--cl_settings_yourrp_contact.lua

hook.Add( "open_yourp_contact", "open_yourp_contact", function()
  local ply = LocalPlayer()

  local w = settingsWindow.sitepanel:GetWide()
  local h = settingsWindow.sitepanel:GetTall()

  settingsWindow.site = createD( "DPanel", settingsWindow.sitepanel, w, h, 0, 0 )
  settingsWindow.site.Paint = function( self, w, h ) draw.RoundedBox( 4, 0, 0, w, h, g_yrp.colors.dbackground ) end

  function settingsWindow.site:Paint()
    --
  end

  local button = createVGUI( "DButton", settingsWindow.site, 2070, 2070, 0, 0 )
  button:SetText( lang_string( "contact" ) .. " (Discord-Link)" )
  function button:DoClick()
    gui.OpenURL( "https://discord.gg/CXXDCMJ" )
  end
end)

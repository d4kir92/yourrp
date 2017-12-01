--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

hook.Add( "open_yourp_add_langu", "open_yourp_add_langu", function()
  local ply = LocalPlayer()

  local w = settingsWindow.sitepanel:GetWide()
  local h = settingsWindow.sitepanel:GetTall()

  settingsWindow.site = createD( "DPanel", settingsWindow.sitepanel, w, h, 0, 0 )
  settingsWindow.site.Paint = function( self, w, h ) draw.RoundedBox( 4, 0, 0, w, h, get_dbg_col() ) end

  function settingsWindow.sitepanel:Paint()
    --
  end

  local form = vgui.Create( "HTML", settingsWindow.site )
  form:SetSize( ctr( 2070 ), ctr( 2070 - 80 ) )
  form:SetPos( ctr( 5 ), ctr( 5 + 80 ) )
  form:OpenURL( "https://docs.google.com/document/d/e/2PACX-1vRrbPJkC5Eel86Hw9AeFTMCgebee1Ep2zB73jKV07-aMf4mSkcGiIdNXXdJ_wYPWguzWbrrPQ9OwV6B/pub" )

  local button = vgui.Create( "DButton", settingsWindow.site )
  button:SetSize( ctr( 2070 ), ctr( 160 ) )
  button:SetPos( ctr( 5 ), ctr( 5 ) )
  button:SetText( "Open Discord link in browser" )
  function button:DoClick()
    gui.OpenURL( "https://discord.gg/CXXDCMJ" )
  end
end)

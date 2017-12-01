--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

hook.Add( "open_yourp_workshop", "open_yourp_workshop", function()
  local ply = LocalPlayer()

  local w = settingsWindow.sitepanel:GetWide()
  local h = settingsWindow.sitepanel:GetTall()

  settingsWindow.site = createD( "DPanel", settingsWindow.sitepanel, w, h, 0, 0 )
  settingsWindow.site.Paint = function( self, w, h ) draw.RoundedBox( 4, 0, 0, w, h, get_dbg_col() ) end

  function settingsWindow.site:Paint()
    draw.SimpleTextOutlined( "Site is loading", "HudDefault", settingsWindow.site:GetWide()/2, settingsWindow.site:GetTall()/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
    --drawBackground( 0, 0, settingsWindow.site:GetWide(), settingsWindow.site:GetTall(), ctr( 0 ) )
  end

  local form = vgui.Create( "HTML", settingsWindow.site )
  form:SetSize( ctr( 2070 ), ctr( 2070 ) )
  form:SetPos( ctr( 5 ), ctr( 5 ) )
  form:OpenURL( "http://steamcommunity.com/sharedfiles/filedetails/?id=1114204152" )
end)

--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

hook.Add( "open_yourp_workshop", "open_yourp_workshop", function()
  local ply = LocalPlayer()

  local w = settingsWindow.window.sitepanel:GetWide()
  local h = settingsWindow.window.sitepanel:GetTall()

  settingsWindow.window.site = createD( "DPanel", settingsWindow.window.sitepanel, w, h, 0, 0 )
  settingsWindow.window.site.Paint = function( self, w, h ) draw.RoundedBox( 4, 0, 0, w, h, get_dbg_col() ) end

  function settingsWindow.window.site:Paint()
    draw.SimpleTextOutlined( "Site is loading", "HudDefault", settingsWindow.window.site:GetWide()/2, settingsWindow.window.site:GetTall()/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
    --drawBackground( 0, 0, settingsWindow.window.site:GetWide(), settingsWindow.window.site:GetTall(), ctr( 0 ) )
  end

  local form = createD( "HTML", settingsWindow.window.site, BScrW() - ctr( 20 ), ScrH() - ctr( 100 + 10 + 10 ), ctr( 10 ), ctr( 10 ) )
  form:OpenURL( "http://steamcommunity.com/sharedfiles/filedetails/?id=1114204152" )
end)

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

  local _bg = createD( "HTML", settingsWindow.window.site, ctr( 800-20 ), ctr( 200-20 ), ctr( 10+10 ), ctr( 10+10 ) )
  _bg:OpenURL( "https://discordapp.com/assets/4f004ac9be168ac6ee18fc442a52ab53.svg" )

  local button = createD( "DButton", settingsWindow.window.site, ctr( 800 ), ctr( 200 ), ctr( 10 ), ctr( 10 ) )
  button:SetText( "" )
  function button:Paint( pw, ph )
    local color = Color( 0, 255, 0 )
    if self:IsHovered() then
      color = Color( 255, 255, 0 )
    end
    drawRBBR( 0, 0, 0, pw, ph, color, ctr( 2 ) )
    surfaceText( lang_string( "contact" ), "SettingsNormal", pw/2, ph/2, Color( 255, 255, 255 ), 1, 1 )
  end
  function button:DoClick()
    gui.OpenURL( "https://discord.gg/CXXDCMJ" )
  end
end)

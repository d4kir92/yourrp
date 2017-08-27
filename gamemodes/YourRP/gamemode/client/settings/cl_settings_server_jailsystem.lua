--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

//cl_settings_server_jailsystem.lua

function tabServerJailSystem( sheet )
  local ply = LocalPlayer()

  local sv_questionPanel = vgui.Create( "DPanel", sheet )
  sheet:AddSheet( "Questions", sv_questionPanel, "icon16/brick.png" )
  function sv_questionPanel:Paint()
    //draw.RoundedBox( 4, 0, 0, sv_questionPanel:GetWide(), sv_questionPanel:GetTall(), yrp.colors.panel )
    draw.SimpleText( "Questions", "SettingsNormal", ctrW( 5 + 30 + 10 ), ctrW( 10 + 15 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
    draw.SimpleText( "Question", "SettingsNormal", ctrW( 5 + 30 + 10 + 400 ), ctrW( 10 + 15 + 50 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    draw.SimpleText( "Right Answer", "SettingsNormal", ctrW( 5 + 30 + 10 + 800 + 10 + 150 ), ctrW( 10 + 15 + 50 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    draw.SimpleText( "Wrong Answer", "SettingsNormal", ctrW( 5 + 30 + 10 + 800 + 300 + 10 + 150 + 10 ), ctrW( 10 + 15 + 50 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
  end

end

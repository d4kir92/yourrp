//cl_settings_server_buysystem.lua

function tabServerBuySystem( sheet )
  local ply = LocalPlayer()

  local sv_questionPanel = vgui.Create( "DPanel", sheet )
  sheet:AddSheet( "Buysystem", sv_questionPanel, "icon16/brick.png" )
  function sv_questionPanel:Paint()
    //draw.RoundedBox( 4, 0, 0, sv_questionPanel:GetWide(), sv_questionPanel:GetTall(), yrpsettings.color.panel )
    draw.SimpleText( "Questions", "SettingsNormal", calculateToResu( 5 + 30 + 10 ), calculateToResu( 10 + 15 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
    draw.SimpleText( "Question", "SettingsNormal", calculateToResu( 5 + 30 + 10 + 400 ), calculateToResu( 10 + 15 + 50 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    draw.SimpleText( "Right Answer", "SettingsNormal", calculateToResu( 5 + 30 + 10 + 800 + 10 + 150 ), calculateToResu( 10 + 15 + 50 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    draw.SimpleText( "Wrong Answer", "SettingsNormal", calculateToResu( 5 + 30 + 10 + 800 + 300 + 10 + 150 + 10 ), calculateToResu( 10 + 15 + 50 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
  end

end

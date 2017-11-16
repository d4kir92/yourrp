--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

--cl_settings_client_keybinds.lua

hook.Add( "open_client_keybinds", "open_client_keybinds", function()
  local ply = LocalPlayer()

  local w = settingsWindow.sitepanel:GetWide()
  local h = settingsWindow.sitepanel:GetTall()

  settingsWindow.site = createD( "DPanel", settingsWindow.sitepanel, w, h, 0, 0 )
  --sheet:AddSheet( lang_string( "character" ), cl_charPanel, "icon16/user_edit.png" )
  function settingsWindow.site:Paint( w, h )
    --draw.RoundedBox( 0, 0, 0, sv_generalPanel:GetWide(), sv_generalPanel:GetTall(), g_yrp.colors.panel )
    draw.SimpleTextOutlined( "in work!", "sef", ctr( 10 ), ctr( 45 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM, 1, Color( 0, 0, 0 ) )

    draw.SimpleTextOutlined( "in work!", "sef", ctr( 10 ), ctr( 200 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM, 1, Color( 0, 0, 0 ) )

    draw.SimpleTextOutlined( "in work!", "sef", ctr( 10 ), ctr( 400 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM, 1, Color( 0, 0, 0 ) )
  end
end)

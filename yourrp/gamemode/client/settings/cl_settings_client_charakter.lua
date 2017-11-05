--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

--cl_settings_client_charakter.lua

net.Receive( "getCharakterList", function()
  local ply = LocalPlayer()
  local _charTab = net.ReadTable()

  local cl_rpName = createVGUI( "DTextEntry", settingsWindow.site, 400, 50, 10, 40 )
  if _charTab.rpname != nil then
    cl_rpName:SetText( _charTab.rpname )
  end
  function cl_rpName:OnChange()
    net.Start( "dbUpdate" )
      net.WriteString( "yrp_characters" )
      net.WriteString( "rpname = '" .. cl_rpName:GetText() .. "'" )
      net.WriteString( "uniqueID = " .. _charTab.uniqueID )
    net.SendToServer()
  end

end)

hook.Add( "open_client_character", "open_client_character", function()
  local ply = LocalPlayer()

  local w = settingsWindow.sitepanel:GetWide()
  local h = settingsWindow.sitepanel:GetTall()

  settingsWindow.site = createD( "DPanel", settingsWindow.sitepanel, w, h, 0, 0 )
  --sheet:AddSheet( lang.character, cl_charPanel, "icon16/user_edit.png" )
  function settingsWindow.site:Paint( w, h )
    --draw.RoundedBox( 0, 0, 0, sv_generalPanel:GetWide(), sv_generalPanel:GetTall(), yrp.colors.panel )
    draw.SimpleTextOutlined( lang.name .. ":", "sef", ctrW( 10 ), ctrW( 45 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM, 1, Color( 0, 0, 0 ) )
  end

  net.Start( "getCharakterList" )
  net.SendToServer()
end)

--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

--cl_settings_client_charakter.lua

net.Receive( "getCharakterList", function()
  local ply = LocalPlayer()
  local _charTab = net.ReadTable()

  local cl_rpName = createVGUI( "DTextEntry", cl_charPanel, 400, 50, 10, 40 )
  cl_rpName:SetText( _charTab.rpname )
  function cl_rpName:OnChange()
    net.Start( "dbUpdate" )
      net.WriteString( "yrp_characters" )
      net.WriteString( "rpname = '" .. cl_rpName:GetText() .. "'" )
      net.WriteString( "uniqueID = " .. _charTab.uniqueID )
    net.SendToServer()
  end

end)

function tabClientChar( sheet )
  local ply = LocalPlayer()

  cl_charPanel = vgui.Create( "DPanel", sheet )
  sheet:AddSheet( lang.character, cl_charPanel, "icon16/user_edit.png" )
  function cl_charPanel:Paint( w, h )
    --draw.RoundedBox( 0, 0, 0, sv_generalPanel:GetWide(), sv_generalPanel:GetTall(), yrp.colors.panel )
    draw.SimpleText( lang.name .. ":", "sef", ctrW( 10 ), ctrW( 45 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM )
  end

  net.Start( "getCharakterList" )
  net.SendToServer()
end

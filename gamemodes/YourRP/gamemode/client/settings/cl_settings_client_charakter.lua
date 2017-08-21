//Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

//cl_settings_client_charakter.lua

net.Receive( "getCharakterList", function()
  local _charList = net.ReadTable()

  local cl_firstName = createVGUI( "DTextEntry", cl_charPanel, 400, 50, 10, 40 )
  cl_firstName:SetText( _charList[1].nameFirst )
  function cl_firstName:OnChange()
    net.Start( "updateFirstName" )
      local _tmp = string.Replace( cl_firstName:GetText(), " ", "" )
      local _newString = _tmp
      net.WriteString( _newString )
    net.SendToServer()
  end

  local cl_surName = createVGUI( "DTextEntry", cl_charPanel, 400, 50, 10, 140 )
  cl_surName:SetText( _charList[1].nameSur )
  function cl_surName:OnChange()
    net.Start( "updateSurName" )
      net.WriteString( cl_surName:GetText() )
    net.SendToServer()
  end
end)

function tabClientChar( sheet )
  local ply = LocalPlayer()

  cl_charPanel = vgui.Create( "DPanel", sheet )
  sheet:AddSheet( lang.character, cl_charPanel, "icon16/user_edit.png" )
  function cl_charPanel:Paint( w, h )
    //draw.RoundedBox( 0, 0, 0, sv_generalPanel:GetWide(), sv_generalPanel:GetTall(), yrpsettings.color.panel )
    draw.SimpleText( lang.firstname .. ":", "DermaDefault", calculateToResu( 10 ), calculateToResu( 10 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
    draw.SimpleText( lang.surname .. ":", "DermaDefault", calculateToResu( 10 ), calculateToResu( 110 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
  end

  net.Start( "getCharakterList" )
  net.SendToServer()
end

//Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

//cl_settings_server_whitelist.lua

net.Receive( "getRoleWhitelist", function( len )
  local _tmpWhiteList = net.ReadTable()
  local _tmpRoleList = net.ReadTable()
  local _tmpGroupList = net.ReadTable()

  local _whitelistListView = createVGUI( "DListView", sv_whitelistPanel, 1500, 1800, 10, 10 )
  _whitelistListView:AddColumn( "uniqueID" ):SetFixedWidth( 0 )
  _whitelistListView:AddColumn( "steamID" ):SetFixedWidth( 120 )
  _whitelistListView:AddColumn( lang.nick )
  _whitelistListView:AddColumn( lang.group )
  _whitelistListView:AddColumn( lang.role )

  for k, v in pairs( _tmpWhiteList ) do
    for l, w in pairs( _tmpRoleList ) do
      if ( w.uniqueID == v.roleID ) then
        for m, x in pairs( _tmpGroupList ) do
          if ( x.uniqueID == w.groupID ) then
            _whitelistListView:AddLine( v.uniqueID, v.steamID, v.nick, x.groupID, w.roleID )
            break
          end
        end
        break
      end
    end
  end


  local _buttonAdd = createVGUI( "DButton", sv_whitelistPanel, 300, 50, 10 + 1500 + 10, 10 )
  _buttonAdd:SetText( lang.addentry )
  function _buttonAdd:DoClick()
    local _whitelistFrame = createVGUI( "DFrame", nil, 400, 405, 0, 0 )
    _whitelistFrame:Center()
    _whitelistFrame:ShowCloseButton( true )
    _whitelistFrame:SetDraggable( true )
    _whitelistFrame:SetTitle( "Whitelist" )

    local _whitelistComboBoxPlys = createVGUI( "DComboBox", _whitelistFrame, 380, 50, 10, 85 )
    for k, v in pairs( player.GetAll() ) do
      _whitelistComboBoxPlys:AddChoice( v:Nick(), v:SteamID() )
    end

    local _whitelistComboBox = createVGUI( "DComboBox", _whitelistFrame, 380, 50, 10, 185 )
    for k, v in pairs( _tmpGroupList ) do
      _whitelistComboBox:AddChoice( v.groupID, v.uniqueID )
    end

    local _whitelistComboBox2 = createVGUI( "DComboBox", _whitelistFrame, 380, 50, 10, 285 )
    function _whitelistComboBox:OnSelect()
      _whitelistComboBox2:Clear()
      for k, v in pairs( _tmpRoleList ) do
        for l, w in pairs( _tmpGroupList ) do
          if ( _whitelistComboBox:GetOptionData( _whitelistComboBox:GetSelectedID() ) == v.groupID ) then
            _whitelistComboBox2:AddChoice( v.roleID, v.uniqueID )
            break
          end
        end
      end
    end

    local _whitelistButton = createVGUI( "DButton", _whitelistFrame, 380, 50, 10, 285+10+50 )
    _whitelistButton:SetText( lang.whitelistplayer )
    function _whitelistButton:DoClick()
      net.Start( "whitelistPlayer" )
        net.WriteString( _whitelistComboBoxPlys:GetOptionData( _whitelistComboBoxPlys:GetSelectedID() ) )
        net.WriteInt( _whitelistComboBox2:GetOptionData( _whitelistComboBox2:GetSelectedID() ), 16 )
      net.SendToServer()
      _whitelistListView:Remove()
      _whitelistFrame:Close()
    end

    function _whitelistFrame:Paint( pw, ph )
      draw.RoundedBox( 0, 0, 0, pw, ph, yrpsettings.color.background )

      draw.SimpleText( lang.player .. ":", "DermaDefault", calculateToResu( 10 ), calculateToResu( 50 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
      draw.SimpleText( lang.group .. ":", "DermaDefault", calculateToResu( 10 ), calculateToResu( 85+65 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
      draw.SimpleText( lang.role .. ":", "DermaDefault", calculateToResu( 10 ), calculateToResu( 185+65 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
    end

    _whitelistFrame:MakePopup()
  end

  local _buttonRem = createVGUI( "DButton", sv_whitelistPanel, 300, 50, 10 + 1500 + 10, 10 + 50 + 10 )
  _buttonRem:SetText( lang.removeentry )
  function _buttonRem:DoClick()
    if _whitelistListView:GetSelectedLine() != "" then
      net.Start( "whitelistPlayerRemove" )
        net.WriteInt( _whitelistListView:GetLine( _whitelistListView:GetSelectedLine() ):GetValue( 1 ) , 16 )
      net.SendToServer()
      _whitelistListView:RemoveLine( _whitelistListView:GetSelectedLine() )
    end
  end

  function _whitelistListView:OnRemove()
    _buttonAdd:Remove()
    _buttonRem:Remove()
  end
end)

function tabServerWhitelist( sheet )
  local ply = LocalPlayer()

  sv_whitelistPanel = vgui.Create( "DPanel", sheet )
  sheet:AddSheet( lang.whitelist, sv_whitelistPanel, "icon16/page_white_key.png" )
  function sv_whitelistPanel:Paint( pw, ph )
    draw.RoundedBox( 4, 0, 0, pw, ph, yrpsettings.color.background )
  end

  net.Start( "getRoleWhitelist" )
  net.SendToServer()
end

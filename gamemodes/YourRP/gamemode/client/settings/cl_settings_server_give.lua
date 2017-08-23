//Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

//cl_settings_server_give.lua

net.Receive( "getPlyList", function( len )
  local _tmpPlyList = net.ReadTable()
  local _tmpRoleList = net.ReadTable()
  local _tmpGroupList = net.ReadTable()

  local _giveListView = createVGUI( "DListView", sv_givePanel, 1800, 1800, 10, 10 )
  _giveListView:AddColumn( "steamID" ):SetFixedWidth( ctrW( 120 ) )
  _giveListView:AddColumn( lang.nick )
  _giveListView:AddColumn( lang.surname )
  _giveListView:AddColumn( lang.firstname )
  _giveListView:AddColumn( lang.gender )
  _giveListView:AddColumn( lang.group )
  _giveListView:AddColumn( lang.role )
  _giveListView:AddColumn( lang.money )

  for k, v in pairs( _tmpPlyList ) do
    for l, w in pairs( _tmpRoleList ) do
      if ( w.uniqueID == v.roleID ) then
        for m, x in pairs( _tmpGroupList ) do
          if ( x.uniqueID == w.groupID ) then
            _giveListView:AddLine( v.steamID, v.nick, v.nameSur, v.nameFirst, v.gender, x.groupID, w.roleID, v.money )
            break
          end
        end
        break
      end
    end
  end

  function _giveListView:OnRowRightClick( lineID, line )
    local _tmpSteamID = line:GetValue(1)
    local tmpX, tmpY = gui.MousePos()
    tmpX = tmpX - ctrW( 4 )
    tmpY = tmpY - ctrW( 4 )
  	local _tmpPanel = createVGUI( "DPanel", nil, 400 + 10 + 10, 10 + 50 + 10, tmpX*2 - 10, tmpY*2 - 10 )
    _tmpPanel:SetPos( tmpX, tmpY )
    _tmpPanel.ready = false
    timer.Simple( 0.2, function()
      _tmpPanel.ready = true
    end)

    local _buttonRole = createVGUI( "DButton", _tmpPanel, 400, 50, 10, 10 )
    _buttonRole:SetText( lang.giverole )
    function _buttonRole:DoClick()
      local _giveFrame = createVGUI( "DFrame", nil, 400, 305, 0, 0 )
      _giveFrame:Center()
      _giveFrame:ShowCloseButton( true )
      _giveFrame:SetDraggable( true )
      _giveFrame:SetTitle( lang.rolegiver )

      local _giveComboBox = createVGUI( "DComboBox", _giveFrame, 380, 50, 10, 85 )
      for k, v in pairs( _tmpGroupList ) do
        _giveComboBox:AddChoice( v.groupID, v.uniqueID )
      end

      local _giveComboBox2 = createVGUI( "DComboBox", _giveFrame, 380, 50, 10, 185 )
      function _giveComboBox:OnSelect()
        _giveComboBox2:Clear()
        for k, v in pairs( _tmpRoleList ) do
          for l, w in pairs( _tmpGroupList ) do
            if ( _giveComboBox:GetOptionData( _giveComboBox:GetSelectedID() ) == v.groupID ) then
              _giveComboBox2:AddChoice( v.roleID, v.uniqueID )
              break
            end
          end
        end
      end

      local _giveButton = createVGUI( "DButton", _giveFrame, 380, 50, 10, 185+10+50 )
      _giveButton:SetText( lang.give )
      function _giveButton:DoClick()
        net.Start( "giveRole" )
          net.WriteString( _tmpSteamID )
          net.WriteInt( _giveComboBox2:GetOptionData( _giveComboBox2:GetSelectedID() ), 16 )
        net.SendToServer()
        _giveFrame:Close()
      end

      function _giveFrame:Paint( pw, ph )
        draw.RoundedBox( 0, 0, 0, pw, ph, yrp.colors.background )

        draw.SimpleText( lang.group .. ":", "SettingsNormal", ctrW( 10 ), ctrW( 50 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
        draw.SimpleText( lang.role .. ":", "SettingsNormal", ctrW( 10 ), ctrW( 85+65 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
      end

      _giveFrame:MakePopup()
    end

    function _tmpPanel:Paint( pw, ph )
      draw.RoundedBox( 0, 0, 0, pw, ph, yrp.colors.panel )
      if !_tmpPanel:IsHovered() and !_buttonRole:IsHovered() and _tmpPanel.ready == true then
        _tmpPanel:Remove()
      end
    end
    _tmpPanel:MakePopup()
  end
end)

function tabServerGive( sheet )
  local ply = LocalPlayer()

  sv_givePanel = vgui.Create( "DPanel", sheet )
  sheet:AddSheet( lang.give, sv_givePanel, "icon16/user_go.png" )
  function sv_givePanel:Paint( pw, ph )
    draw.RoundedBox( 4, 0, 0, pw, ph, yrp.colors.background )
  end

  net.Start( "getPlyList" )
  net.SendToServer()
end

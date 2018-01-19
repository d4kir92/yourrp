--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

net.Receive( "getPlyList", function( len )
  local _tmpChaList = net.ReadTable()
  local _tmpRoleList = net.ReadTable()
  local _tmpGroupList = net.ReadTable()

  local _giveListView = createVGUI( "DListView", settingsWindow.window.site, 1800, 1800, 10, 10 )
  _giveListView:AddColumn( "SteamID" )
  _giveListView:AddColumn( lang_string( "nick" ) )
  _giveListView:AddColumn( lang_string( "name" ) )
  _giveListView:AddColumn( lang_string( "gender" ) )
  _giveListView:AddColumn( lang_string( "group" ) )
  _giveListView:AddColumn( lang_string( "role" ) )
  _giveListView:AddColumn( lang_string( "money" ) )

  for k, v in pairs( _tmpChaList ) do
    for l, w in pairs( _tmpRoleList ) do
      if ( tostring( w.uniqueID ) == tostring( v.roleID ) ) then
        for m, x in pairs( _tmpGroupList ) do
          if ( x.uniqueID == w.groupID ) then
            for n, y in pairs( player.GetAll() ) do
              if y:SteamID() == v.SteamID then
                _giveListView:AddLine( v.SteamID, y:SteamName(), v.rpname, v.gender, x.groupID, w.roleID, v.money )
                break
              end
            end
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
    tmpX = tmpX - ctr( 4 )
    tmpY = tmpY - ctr( 4 )
  	local _tmpPanel = createVGUI( "DPanel", nil, 400 + 10 + 10, 10 + 50 + 10, tmpX*2 - 10, tmpY*2 - 10 )
    _tmpPanel:SetPos( tmpX, tmpY )
    _tmpPanel.ready = false
    timer.Simple( 0.2, function()
      _tmpPanel.ready = true
    end)

    local _buttonRole = createVGUI( "DButton", _tmpPanel, 400, 50, 10, 10 )
    _buttonRole:SetText( lang_string( "giverole" ) )
    function _buttonRole:DoClick()
      local _giveFrame = createVGUI( "DFrame", nil, 400, 305, 0, 0 )
      _giveFrame:Center()
      _giveFrame:ShowCloseButton( true )
      _giveFrame:SetDraggable( true )
      _giveFrame:SetTitle( lang_string( "giverole" ) )

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
      _giveButton:SetText( lang_string( "give" ) )
      function _giveButton:DoClick()
        if isnumber( tonumber( _giveComboBox2:GetOptionData( _giveComboBox2:GetSelectedID() ) ) ) then
          net.Start( "giveRole" )
            net.WriteString( _tmpSteamID )
            net.WriteInt( _giveComboBox2:GetOptionData( _giveComboBox2:GetSelectedID() ), 16 )
          net.SendToServer()
          _giveFrame:Close()
        end
      end

      function _giveFrame:Paint( pw, ph )
        draw.RoundedBox( 0, 0, 0, pw, ph, get_dbg_col() )

        draw.SimpleTextOutlined( lang_string( "group" ) .. ":", "sef", ctr( 10 ), ctr( 50 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
        draw.SimpleTextOutlined( lang_string( "role" ) .. ":", "sef", ctr( 10 ), ctr( 85+65 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
      end

      _giveFrame:MakePopup()
    end

    function _tmpPanel:Paint( pw, ph )
      draw.RoundedBox( 0, 0, 0, pw, ph, get_ds_col() )
      if !_tmpPanel:IsHovered() and !_buttonRole:IsHovered() and _tmpPanel.ready == true then
        _tmpPanel:Remove()
      end
    end
    _tmpPanel:MakePopup()
  end
end)

hook.Add( "open_server_give", "open_server_give", function()
  local ply = LocalPlayer()

  local w = settingsWindow.window.sitepanel:GetWide()
  local h = settingsWindow.window.sitepanel:GetTall()

  settingsWindow.window.site = createD( "DPanel", settingsWindow.window.sitepanel, w, h, 0, 0 )

  function settingsWindow.window.site:Paint( pw, ph )
    draw.RoundedBox( 4, 0, 0, pw, ph, get_dbg_col() )
  end

  net.Start( "getPlyList" )
  net.SendToServer()
end)

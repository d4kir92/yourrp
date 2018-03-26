--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

hook.Add( "open_server_give", "open_server_give", function()
  local ply = LocalPlayer()

  local w = settingsWindow.window.sitepanel:GetWide()
  local h = settingsWindow.window.sitepanel:GetTall()

  settingsWindow.window.site = createD( "DPanel", settingsWindow.window.sitepanel, w, h, 0, 0 )

  function settingsWindow.window.site:Paint( pw, ph )
    --draw.RoundedBox( 4, 0, 0, pw, ph, get_dbg_col() )
    surfaceText( lang_string( "players" ), "roleInfoHeader", ctr( 10 ), ctr( 10 + 25 ), Color( 255, 255, 255 ), 0, 1 )
  end

  local _giveListView = createD( "DListView", settingsWindow.window.site, BScrW() - ctr( 20 ), ScrH() - ctr( 180 ), ctr( 10 ), ctr( 10 + 50 ) )
  _giveListView:AddColumn( "SteamID" )
  _giveListView:AddColumn( lang_string( "nick" ) )
  _giveListView:AddColumn( lang_string( "name" ) )
  _giveListView:AddColumn( lang_string( "group" ) )
  _giveListView:AddColumn( lang_string( "role" ) )
  _giveListView:AddColumn( lang_string( "money" ) )

  for n, y in pairs( player.GetAll() ) do
    _giveListView:AddLine( y:SteamID(), y:SteamName(), y:RPName(), y:GetNWString( "groupName" ), y:GetNWString( "roleName" ), y:GetNWInt( "money" ) )
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

      net.Receive( "give_getGroTab", function( len )
        local _tmpGroupList = net.ReadTable()
        for k, v in pairs( _tmpGroupList ) do
          _giveComboBox:AddChoice( v.groupID, v.uniqueID )
        end
      end)
      net.Start( "give_getGroTab" )
      net.SendToServer()

      local _giveComboBox2 = createVGUI( "DComboBox", _giveFrame, 380, 50, 10, 185 )
      function _giveComboBox:OnSelect( panel, index, value )
        _giveComboBox2:Clear()
        net.Start( "give_getRolTab" )
          net.WriteString( tostring( value ) )
        net.SendToServer()
        net.Receive( "give_getRolTab", function()
          local _tmpRolTab = net.ReadTable()
          for k, v in pairs( _tmpRolTab ) do
            _giveComboBox2:AddChoice( v.roleID, v.uniqueID )
          end
        end)
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

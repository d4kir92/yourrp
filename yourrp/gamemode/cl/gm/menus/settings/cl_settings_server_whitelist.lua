--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

net.Receive( "getRoleWhitelist", function( len )
  local _tmpWhiteList = net.ReadTable()
  local _tmpRoleList = net.ReadTable()
  local _tmpGroupList = net.ReadTable()

  local _whitelistListView = createVGUI( "DListView", settingsWindow.site, 1500, 1800, 10, 10 )
  _whitelistListView:AddColumn( "uniqueID" )
  _whitelistListView:AddColumn( "SteamID" )
  _whitelistListView:AddColumn( lang_string( "nick" ) )
  _whitelistListView:AddColumn( lang_string( "group" ) )
  _whitelistListView:AddColumn( lang_string( "role" ) )

  for k, v in pairs( _tmpWhiteList ) do
    for l, w in pairs( _tmpRoleList ) do
      if ( w.uniqueID == v.roleID ) then
        for m, x in pairs( _tmpGroupList ) do
          if ( x.uniqueID == w.groupID ) then
            _whitelistListView:AddLine( v.uniqueID, v.SteamID, v.nick, x.groupID, w.roleID )
            break
          end
        end
        break
      elseif v.roleID == "-1" then
        for m, x in pairs( _tmpGroupList ) do
          if ( x.uniqueID == v.groupID ) then
            _whitelistListView:AddLine( v.uniqueID, v.SteamID, v.nick, x.groupID, "" )
            break
          end
        end
        break
      end
    end
  end

  local _buttonAdd = createVGUI( "DButton", settingsWindow.site, 400, 50, 10 + 1500 + 10, 10 )
  _buttonAdd:SetText( lang_string( "addentry" ) )
  function _buttonAdd:DoClick()
    local _whitelistFrame = createVGUI( "DFrame", nil, 400, 500, 0, 0 )
    _whitelistFrame:Center()
    _whitelistFrame:ShowCloseButton( true )
    _whitelistFrame:SetDraggable( true )
    _whitelistFrame:SetTitle( "Whitelist" )

    local _whitelistComboBoxPlys = createVGUI( "DComboBox", _whitelistFrame, 380, 50, 10, 100 )
    for k, v in pairs( player.GetAll() ) do
      _whitelistComboBoxPlys:AddChoice( v:Nick(), v:SteamID() )
    end

    local _whitelistComboBox = createVGUI( "DComboBox", _whitelistFrame, 380, 50, 10, 200 )
    for k, v in pairs( _tmpGroupList ) do
      _whitelistComboBox:AddChoice( v.groupID, v.uniqueID )
    end

    local _whitelistComboBox2 = createVGUI( "DComboBox", _whitelistFrame, 380, 50, 10, 300 )
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

    local _whitelistButton = createVGUI( "DButton", _whitelistFrame, 380, 50, 10, 400 )
    _whitelistButton:SetText( lang_string( "whitelistplayer" ) )
    function _whitelistButton:DoClick()
      if _whitelistComboBoxPlys:GetOptionData( _whitelistComboBoxPlys:GetSelectedID() ) != nil then
        net.Start( "whitelistPlayer" )
          net.WriteString( _whitelistComboBoxPlys:GetOptionData( _whitelistComboBoxPlys:GetSelectedID() ) )
          net.WriteInt( _whitelistComboBox2:GetOptionData( _whitelistComboBox2:GetSelectedID() ), 16 )
        net.SendToServer()
      end
      _whitelistListView:Remove()
      _whitelistFrame:Close()
    end

    function _whitelistFrame:Paint( pw, ph )
      draw.RoundedBox( 0, 0, 0, pw, ph, get_dbg_col() )

      draw.SimpleTextOutlined( lang_string( "player" ) .. ":", "sef", ctr( 10 ), ctr( 50 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
      draw.SimpleTextOutlined( lang_string( "group" ) .. ":", "sef", ctr( 10 ), ctr( 85+65 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
      draw.SimpleTextOutlined( lang_string( "role" ) .. ":", "sef", ctr( 10 ), ctr( 185+65 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
    end

    _whitelistFrame:MakePopup()
  end

  local _buttonAddGroup = createVGUI( "DButton", settingsWindow.site, 400, 50, 10 + 1500 + 10, 70 )
  _buttonAddGroup:SetText( lang_string( "addentry" ) .. " (" .. lang_string( "group" ) .. ")" )
  function _buttonAddGroup:DoClick()
    local _whitelistFrame = createVGUI( "DFrame", nil, 400, 500, 0, 0 )
    _whitelistFrame:Center()
    _whitelistFrame:ShowCloseButton( true )
    _whitelistFrame:SetDraggable( true )
    _whitelistFrame:SetTitle( "Whitelist" )

    local _whitelistComboBoxPlys = createVGUI( "DComboBox", _whitelistFrame, 380, 50, 10, 100 )
    for k, v in pairs( player.GetAll() ) do
      _whitelistComboBoxPlys:AddChoice( v:Nick(), v:SteamID() )
    end

    local _whitelistComboBox = createVGUI( "DComboBox", _whitelistFrame, 380, 50, 10, 200 )
    for k, v in pairs( _tmpGroupList ) do
      _whitelistComboBox:AddChoice( v.groupID, v.uniqueID )
    end

    local _whitelistButton = createVGUI( "DButton", _whitelistFrame, 380, 50, 10, 400 )
    _whitelistButton:SetText( lang_string( "whitelistplayer" ) )
    function _whitelistButton:DoClick()
      if _whitelistComboBoxPlys:GetOptionData( _whitelistComboBoxPlys:GetSelectedID() ) != nil then
        net.Start( "whitelistPlayerGroup" )
          net.WriteString( _whitelistComboBoxPlys:GetOptionData( _whitelistComboBoxPlys:GetSelectedID() ) )
          net.WriteInt( _whitelistComboBox:GetOptionData( _whitelistComboBox:GetSelectedID() ), 16 )
        net.SendToServer()
      end
      _whitelistListView:Remove()
      _whitelistFrame:Close()
    end

    function _whitelistFrame:Paint( pw, ph )
      draw.RoundedBox( 0, 0, 0, pw, ph, get_dbg_col() )

      draw.SimpleTextOutlined( lang_string( "player" ) .. ":", "sef", ctr( 10 ), ctr( 50 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
      draw.SimpleTextOutlined( lang_string( "group" ) .. ":", "sef", ctr( 10 ), ctr( 85+65 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
    end

    _whitelistFrame:MakePopup()
  end

  local _buttonRem = createVGUI( "DButton", settingsWindow.site, 400, 50, 10 + 1500 + 10, 130 )
  _buttonRem:SetText( lang_string( "removeentry" ) )
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

hook.Add( "open_server_whitelist", "open_server_whitelist", function()
  local ply = LocalPlayer()

  local w = settingsWindow.sitepanel:GetWide()
  local h = settingsWindow.sitepanel:GetTall()

  settingsWindow.site = createD( "DPanel", settingsWindow.sitepanel, w, h, 0, 0 )

  function settingsWindow.site:Paint( pw, ph )
    draw.RoundedBox( 4, 0, 0, pw, ph, get_dbg_col() )
  end

  net.Start( "getRoleWhitelist" )
  net.SendToServer()
end)

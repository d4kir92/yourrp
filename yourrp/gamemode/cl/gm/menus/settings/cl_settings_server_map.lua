--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

local _groups = {}
local _roles = {}
net.Receive( "getMapList", function( len )
  local _tmpBool = net.ReadBool()

  local _tmpTable = net.ReadTable()
  _groups = net.ReadTable()
  _roles = net.ReadTable()
  if !_tmpBool then
    for k, v in pairs( _tmpTable ) do
      if tonumber( v.groupID ) != -1 then
        for l, w in pairs( _groups ) do
          if tostring( v.groupID ) == tostring( w.uniqueID ) and v.type == "GroupSpawnpoint" then
            if _mapListView != nil and ispanel( _mapListView ) then
              _mapListView:AddLine( v.uniqueID, v.position, v.angle, v.type, w.groupID, "" )
            end
            break
          end
        end
      elseif tonumber( v.roleID ) != -1 then
        for l, w in pairs( _roles ) do
          if tostring( v.roleID ) == tostring( w.uniqueID ) and v.type == "RoleSpawnpoint"  then
            if _mapListView != nil and ispanel( _mapListView ) then
              _mapListView:AddLine( v.uniqueID, v.position, v.angle, v.type, "", w.roleID )
            end
            break
          end
        end
      else
        _mapListView:AddLine( v.uniqueID, v.position, v.angle, v.type, "", "" )
      end
    end
  end
end)

function getMapPNG()
  local _mapName = db_sql_str2( string.lower( game.GetMap() ) )
  local _mapPicturePath = "maps/" .. _mapName .. ".png"
  local _mapPictureDesti = _mapPicturePath

  local _mapPNG = Material( "../maps/no_image.png", "noclamp smooth" )
  if file.Exists( _mapPicturePath, "GAME" ) then
    _mapPNG =  Material( "../" .. _mapPicturePath, "noclamp smooth" )
  else
    _mapPicturePath = "maps/thumb/" .. _mapName .. ".png"
    if file.Exists( _mapPicturePath, "GAME" ) then
      _mapPNG = Material( "../" .. _mapPicturePath, "noclamp smooth" )
    end
  end
  return _mapPNG
end

function getCopyMapPNG()
  local _mapName = db_sql_str2( string.lower( game.GetMap() ) )
  local _mapPicturePath = "maps/" .. _mapName .. ".png"
  local _mapPictureDesti = _mapPicturePath

  local _mapPNG = Material( "../maps/no_image.png", "noclamp smooth" )
  if file.Exists( _mapPicturePath, "GAME" ) then
    if !file.Exists( "maps", "DATA" ) then
      file.CreateDir( "maps" )
    end
    file.Write( _mapPicturePath, file.Read( _mapPicturePath, "GAME" ) )
    if file.Exists( _mapPicturePath, "DATA" ) then
  		_mapPNG =  Material( "../data/" .. _mapPicturePath, "noclamp smooth" )
    end
  else
    _mapPicturePath = "maps/thumb/" .. _mapName .. ".png"
    if file.Exists( _mapPicturePath, "GAME" ) then
      if !file.Exists( "maps", "DATA" ) then
        file.CreateDir( "maps" )
      end
      file.Write( _mapPictureDesti, file.Read( _mapPicturePath, "GAME" ) )
      if file.Exists( _mapPictureDesti, "DATA" ) then
    		_mapPNG = Material( "../data/" .. _mapPictureDesti, "noclamp smooth" )
      end
    end
  end
  return _mapPNG
end

hook.Add( "open_server_map", "open_server_map", function()
  local ply = LocalPlayer()

  local w = settingsWindow.sitepanel:GetWide()
  local h = settingsWindow.sitepanel:GetTall()

  settingsWindow.site = createD( "DPanel", settingsWindow.sitepanel, w, h, 0, 0 )

  function settingsWindow.site:Paint( pw, ph )
    draw.RoundedBox( 4, 0, 0, pw, ph, get_dbg_col() )
  end
  local _mapPanel = createVGUI( "DPanel", settingsWindow.site, 256, 256, 10, 10 )
  local _mapPNG = getMapPNG()
  function _mapPanel:Paint( pw, ph )
    surface.SetDrawColor( 255, 255, 255, 255 )
  	surface.SetMaterial( _mapPNG	)
  	surface.DrawTexturedRect( 0, 0, ctr( 256 ), ctr( 256 ) )
  end

  local _mapName = createVGUI( "DPanel", settingsWindow.site, 2000 - 10 - 256, 256, 10 + 256, 10 )
  function _mapName:Paint( pw, ph )
    draw.RoundedBox( 0, 0,0, pw, ph, get_dp_col() )
    draw.SimpleTextOutlined( lang_string( "map" ) .. ": " .. db_sql_str2( string.lower( game.GetMap() ) ), "sef", ctr( 10 ), ctr( 10 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
  end

  _mapListView = createVGUI( "DListView", settingsWindow.site, 1600, 1600, 10, 10 + 256 + 10 )
  _mapListView:AddColumn( "uniqueID" ):SetFixedWidth( ctr( 100 ) )
  _mapListView:AddColumn( lang_string( "position" ) )
  _mapListView:AddColumn( lang_string( "angle" ) )
  _mapListView:AddColumn( lang_string( "type" ) )
  _mapListView:AddColumn( lang_string( "group" ) )
  _mapListView:AddColumn( lang_string( "role" ) )

  local _buttonDelete = createVGUI( "DButton", settingsWindow.site, 400, 50, 10 + 1600 + 10, 10 + 256 + 10 )
  _buttonDelete:SetText( lang_string( "deleteentry" ) )
  function _buttonDelete:DoClick()
    if _mapListView:GetSelectedLine() != nil then
      net.Start( "removeMapEntry" )
        net.WriteString( _mapListView:GetLine(_mapListView:GetSelectedLine()):GetValue( 1 ) )
      net.SendToServer()
      _mapListView:RemoveLine(  _mapListView:GetSelectedLine() )
    end
  end

  local _buttonAddGroupSpawnPoint = createVGUI( "DButton", settingsWindow.site, 400, 50, 1620, 336 )
  _buttonAddGroupSpawnPoint:SetText( lang_string( "addgroupspawnpoint" ) )
  function _buttonAddGroupSpawnPoint:DoClick()
    local tmpFrame = createD( "DFrame", nil, ctr( 1200 ), ctr( 290 ), 0, 0 )
    tmpFrame:Center()
    tmpFrame:SetTitle( "" )
    function tmpFrame:Paint( pw, ph )
      draw.RoundedBox( 0, 0,0, pw, ph, get_dbg_col() )
      draw.SimpleTextOutlined( lang_string( "groupspawnpointcreator" ), "sef", ctr( 10 ), ctr( 10 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
      draw.SimpleTextOutlined( lang_string( "creategroupspawnpoint" ), "sef", ctr( 10 ), ctr( 60 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
      draw.SimpleTextOutlined( lang_string( "selectgroup" ) .. ":", "sef", ctr( 10 ), ctr( 110 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
    end

    local tmpGroup = createD( "DComboBox", tmpFrame, ctr( 400 ), ctr( 50 ), ctr( 10 ), ctr( 170 ) )
    for k, v in pairs( _groups ) do
      tmpGroup:AddChoice( v.groupID, v.uniqueID )
    end

    local tmpButton = createD( "DButton", tmpFrame, ctr( 400 ), ctr( 50 ), ctr( 600-200 ), ctr( 230 ) )
    tmpButton:SetText( lang_string( "add" ) )
    function tmpButton:DoClick()
      net.Start( "dbInsertIntoMap" )
        net.WriteString( "yrp_" .. db_sql_str2( string.lower( game.GetMap() ) ) )
        net.WriteString( "position, angle, groupID, type" )
        local tmpPos = string.Explode( " ", tostring( ply:GetPos() ) )
        local tmpAng = string.Explode( " ", tostring( ply:GetAngles() ) )
        local tmpGroupID = tostring( tmpGroup:GetOptionData( tmpGroup:GetSelectedID() ) )
        local tmpString = "'" .. math.Round( tonumber( tmpPos[1] ), 2 ) .. "," .. math.Round( tonumber( tmpPos[2] ), 2 ) .. "," .. math.Round( tonumber( tmpPos[3] + 4 ), 2 ) .. "', '" .. math.Round( tonumber( tmpAng[1] ), 2 ) .. "," .. math.Round( tonumber( tmpAng[2] ), 2 ) .. "," .. math.Round( tonumber( tmpAng[3] ), 2 ) .. "', " .. tmpGroupID .. ", 'GroupSpawnpoint'"
        net.WriteString( tmpString )
      net.SendToServer()

      _mapListView:Clear()
      net.Start( "getMapList" )
      net.SendToServer()
      tmpFrame:Close()
    end

    tmpFrame:MakePopup()
  end

  local _buttonAddRoleSpawnPoint = createVGUI( "DButton", settingsWindow.site, 400, 50, 1620, 396 )
  _buttonAddRoleSpawnPoint:SetText( lang_string( "addrolespawnpoint" ) )
  function _buttonAddRoleSpawnPoint:DoClick()
    local tmpFrame = createD( "DFrame", nil, ctr( 1200 ), ctr( 290 ), 0, 0 )
    tmpFrame:Center()
    tmpFrame:SetTitle( "" )
    function tmpFrame:Paint( pw, ph )
      draw.RoundedBox( 0, 0,0, pw, ph, get_dbg_col() )
      draw.SimpleTextOutlined( lang_string( "rolespawnpointcreator" ), "sef", ctr( 10 ), ctr( 10 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
      draw.SimpleTextOutlined( lang_string( "createrolespawnpoint" ), "sef", ctr( 10 ), ctr( 60 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
      draw.SimpleTextOutlined( lang_string( "selectrole" ) .. ":", "sef", ctr( 10 ), ctr( 110 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
    end

    local tmpRole = createD( "DComboBox", tmpFrame, ctr( 400 ), ctr( 50 ), ctr( 10 ), ctr( 170 ) )
    for k, v in pairs( _roles ) do
      tmpRole:AddChoice( v.roleID, v.uniqueID )
    end

    local tmpButton = createD( "DButton", tmpFrame, ctr( 400 ), ctr( 50 ), ctr( 600-200 ), ctr( 230 ) )
    tmpButton:SetText( lang_string( "add" ) )
    function tmpButton:DoClick()
      net.Start( "dbInsertIntoMap" )
        net.WriteString( "yrp_" .. db_sql_str2( string.lower( game.GetMap() ) ) )
        net.WriteString( "position, angle, roleID, type" )
        local tmpPos = string.Explode( " ", tostring( ply:GetPos() ) )
        local tmpAng = string.Explode( " ", tostring( ply:GetAngles() ) )
        local tmpRoleID = tostring( tmpRole:GetOptionData( tmpRole:GetSelectedID() ) )
        local tmpString = "'" .. math.Round( tonumber( tmpPos[1] ), 2 ) .. "," .. math.Round( tonumber( tmpPos[2] ), 2 ) .. "," .. math.Round( tonumber( tmpPos[3] + 4 ), 2 ) .. "', '" .. math.Round( tonumber( tmpAng[1] ), 2 ) .. "," .. math.Round( tonumber( tmpAng[2] ), 2 ) .. "," .. math.Round( tonumber( tmpAng[3] ), 2 ) .. "', " .. tmpRoleID .. ", 'RoleSpawnpoint'"
        net.WriteString( tmpString )
      net.SendToServer()

      _mapListView:Clear()
      net.Start( "getMapList" )
      net.SendToServer()
      tmpFrame:Close()
    end

    tmpFrame:MakePopup()
  end

  local _buttonAddJailPoint = createVGUI( "DButton", settingsWindow.site, 400, 50, 1620, 456 )
  _buttonAddJailPoint:SetText( lang_string( "addjailpoint" ) )
  function _buttonAddJailPoint:DoClick()
    net.Start( "dbInsertIntoMap" )
      net.WriteString( "yrp_" .. db_sql_str2( string.lower( game.GetMap() ) ) )
      net.WriteString( "position, angle, type" )
      local tmpPos = string.Explode( " ", tostring( ply:GetPos() ) )
      local tmpAng = string.Explode( " ", tostring( ply:GetAngles() ) )
      local tmpString = "'" .. math.Round( tonumber( tmpPos[1] ), 2 ) .. "," .. math.Round( tonumber( tmpPos[2] ), 2 ) .. "," .. math.Round( tonumber( tmpPos[3] + 4 ), 2 ) .. "', '" .. math.Round( tonumber( tmpAng[1] ), 2 ) .. "," .. math.Round( tonumber( tmpAng[2] ), 2 ) .. "," .. math.Round( tonumber( tmpAng[3] ), 2 ) .. "', 'jailpoint'"
      net.WriteString( tmpString )
    net.SendToServer()

    _mapListView:Clear()
    net.Start( "getMapList" )
    net.SendToServer()
  end

  local _buttonAddReleasePoint = createVGUI( "DButton", settingsWindow.site, 400, 50, 1620, 516 )
  _buttonAddReleasePoint:SetText( lang_string( "addjailfreepoint" ) )
  function _buttonAddReleasePoint:DoClick()
    net.Start( "dbInsertIntoMap" )
      net.WriteString( "yrp_" .. db_sql_str2( string.lower( game.GetMap() ) ) )
      net.WriteString( "position, angle, type" )
      local tmpPos = string.Explode( " ", tostring( ply:GetPos() ) )
      local tmpAng = string.Explode( " ", tostring( ply:GetAngles() ) )
      local tmpString = "'" .. math.Round( tonumber( tmpPos[1] ), 2 ) .. "," .. math.Round( tonumber( tmpPos[2] ), 2 ) .. "," .. math.Round( tonumber( tmpPos[3] + 4 ), 2 ) .. "', '" .. math.Round( tonumber( tmpAng[1] ), 2 ) .. "," .. math.Round( tonumber( tmpAng[2] ), 2 ) .. "," .. math.Round( tonumber( tmpAng[3] ), 2 ) .. "', 'releasepoint'"
      net.WriteString( tmpString )
    net.SendToServer()

    _mapListView:Clear()
    net.Start( "getMapList" )
    net.SendToServer()
  end

  net.Start( "getMapList" )
  net.SendToServer()
end)

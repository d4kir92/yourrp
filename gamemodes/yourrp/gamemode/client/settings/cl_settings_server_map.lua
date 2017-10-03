--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

--cl_settings_server_map.lua

local _groups = {}
net.Receive( "getMapList", function( len )
  local _tmpBool = net.ReadBool()

  local _tmpTable = net.ReadTable()
  _groups = net.ReadTable()
  if !_tmpBool then
    for k, v in pairs( _tmpTable ) do
      if tonumber( v.groupID ) != -1 then
        for l, w in pairs( _groups ) do
          if tostring( v.groupID ) == tostring( w.uniqueID ) then
            if _mapListView != nil then
              _mapListView:AddLine( v.uniqueID, v.position, v.angle, v.type, w.groupID )
            end
            break
          end
        end
      else
        _mapListView:AddLine( v.uniqueID, v.position, v.angle, v.type, "" )
      end
    end
  end
end)

function getMapPNG()
  local _mapName = string.lower( game.GetMap() )
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
  local _mapName = string.lower( game.GetMap() )
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
    draw.RoundedBox( 4, 0, 0, pw, ph, yrp.colors.dbackground )
  end
  local _mapPanel = createVGUI( "DPanel", settingsWindow.site, 256, 256, 10, 10 )
  local _mapPNG = getMapPNG()
  function _mapPanel:Paint( pw, ph )
    surface.SetDrawColor( 255, 255, 255, 255 )
  	surface.SetMaterial( _mapPNG	)
  	surface.DrawTexturedRect( 0, 0, ctrW( 256 ), ctrW( 256 ) )
  end

  local _mapName = createVGUI( "DPanel", settingsWindow.site, 2000 - 10 - 256, 256, 10 + 256, 10 )
  function _mapName:Paint( pw, ph )
    draw.RoundedBox( 0, 0,0, pw, ph, yrp.colors.dprimary )
    draw.SimpleText( lang.map .. ": " .. string.lower( game.GetMap() ), "sef", ctrW( 10 ), ctrW( 10 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
  end

  _mapListView = createVGUI( "DListView", settingsWindow.site, 1600, 1600, 10, 10 + 256 + 10 )
  _mapListView:AddColumn( "uniqueID" ):SetFixedWidth( ctrW( 100 ) )
  _mapListView:AddColumn( lang.position ):SetFixedWidth( ctrW( 200 ) )
  _mapListView:AddColumn( lang.angle ):SetFixedWidth( ctrW( 200 ) )
  _mapListView:AddColumn( lang.type )
  _mapListView:AddColumn( lang.group )

  local _buttonDelete = createVGUI( "DButton", settingsWindow.site, 400, 50, 10 + 1600 + 10, 10 + 256 + 10 )
  _buttonDelete:SetText( lang.deleteentry )
  function _buttonDelete:DoClick()
    if _mapListView:GetSelectedLine() != nil then
      net.Start( "removeMapEntry" )
        net.WriteString( _mapListView:GetLine(_mapListView:GetSelectedLine()):GetValue( 1 ) )
      net.SendToServer()
      _mapListView:RemoveLine(  _mapListView:GetSelectedLine() )
    end
  end

  local _buttonAddSpawnPoint = createVGUI( "DButton", settingsWindow.site, 400, 50, 10 + 1600 + 10, 10 + 256 + 10 + 50 + 10 )
  _buttonAddSpawnPoint:SetText( lang.addspawnpoint )
  function _buttonAddSpawnPoint:DoClick()
    local tmpFrame = createVGUI( "DFrame", nil, 500, 10 + 50 + 10 + 50 + 10 + 50 + 10 + 50 + 10, 0, 0 )
    tmpFrame:Center()
    tmpFrame:SetTitle( "" )
    function tmpFrame:Paint( pw, ph )
      draw.RoundedBox( 0, 0,0, pw, ph, yrp.colors.dbackground )
      draw.SimpleText( lang.spawnpointcreator, "sef", ctrW( 10 ), ctrW( 10 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
      draw.SimpleText( lang.createspawnpointonyou, "sef", ctrW( 10 ), ctrW( 50 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
      draw.SimpleText( lang.selectgroup .. ":", "sef", ctrW( 10 ), ctrW( 90 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
    end

    local tmpGroup = createVGUI( "DComboBox", tmpFrame, 200, 50, 10, 50 + 10 + 50 + 10 )
    for k, v in pairs( _groups ) do
      tmpGroup:AddChoice( v.groupID, v.uniqueID )
    end

    local tmpButton = createVGUI( "DButton", tmpFrame, 200, 50, 150, 50 + 10 + 50 + 10 + 50 + 10 )
    tmpButton:SetText( lang.add )
    function tmpButton:DoClick()
      net.Start( "dbInsertInto" )
        net.WriteString( "yrp_" .. string.lower( game.GetMap() ) )
        net.WriteString( "position, angle, groupID, type" )
        local tmpPos = string.Explode( " ", tostring( ply:GetPos() ) )
        local tmpAng = string.Explode( " ", tostring( ply:GetAngles() ) )
        local tmpGroupID = tostring( tmpGroup:GetOptionData( tmpGroup:GetSelectedID() ) )
        local tmpString = "'" .. math.Round( tonumber( tmpPos[1] ), 2 ) .. "," .. math.Round( tonumber( tmpPos[2] ), 2 ) .. "," .. math.Round( tonumber( tmpPos[3] + 4 ), 2 ) .. "', '" .. math.Round( tonumber( tmpAng[1] ), 2 ) .. "," .. math.Round( tonumber( tmpAng[2] ), 2 ) .. "," .. math.Round( tonumber( tmpAng[3] ), 2 ) .. "', " .. tmpGroupID .. ", 'Spawnpoint'"
        net.WriteString( tmpString )
      net.SendToServer()

      _mapListView:Clear()
      net.Start( "getMapList" )
      net.SendToServer()
      tmpFrame:Close()
    end

    tmpFrame:MakePopup()
  end

  local _buttonAddJailPoint = createVGUI( "DButton", settingsWindow.site, 400, 50, 10 + 1600 + 10, 10 + 256 + 10 + 50 + 10 + 50 + 10 )
  _buttonAddJailPoint:SetText( lang.addjailpoint )
  function _buttonAddJailPoint:DoClick()
    net.Start( "dbInsertInto" )
      net.WriteString( "yrp_" .. string.lower( game.GetMap() ) )
      net.WriteString( "position, angle, type" )
      local tmpPos = string.Explode( " ", tostring( ply:GetPos() ) )
      local tmpAng = string.Explode( " ", tostring( ply:GetAngles() ) )
      local tmpString = "'" .. math.Round( tonumber( tmpPos[1] ), 2 ) .. "," .. math.Round( tonumber( tmpPos[2] ), 2 ) .. "," .. math.Round( tonumber( tmpPos[3] + 4 ), 2 ) .. "', '" .. math.Round( tonumber( tmpAng[1] ), 2 ) .. "," .. math.Round( tonumber( tmpAng[2] ), 2 ) .. "," .. math.Round( tonumber( tmpAng[3] ), 2 ) .. "', 'Jailpoint'"
      net.WriteString( tmpString )
    net.SendToServer()

    _mapListView:Clear()
    net.Start( "getMapList" )
    net.SendToServer()
  end

  net.Start( "getMapList" )
  net.SendToServer()
end)

--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

--sv_sizer.lua

--##############################################################################
--Map vars
mapSize = {}
mapSize.size = 9999999999

mapSize.sizeN = -mapSize.size
mapSize.sizeS = mapSize.size
mapSize.sizeW = mapSize.size
mapSize.sizeE = -mapSize.size

mapSize.sizeX = -mapSize.size
mapSize.sizeY = -mapSize.size

mapSize.sizeUp = -mapSize.size

mapSize.sizeFE = -mapSize.size

mapSize.spawnPointsH = -mapSize.size
mapSize.eventH = -mapSize.size

mapSize.error = 1

mapSize.facX = 1
mapSize.facY = 1

--Ohne Problem durchgelaufen
mapSize.error = 0
--##############################################################################

local skyCamera = nil

--##############################################################################
--util
util.AddNetworkString( "askCoords" )
util.AddNetworkString( "sendCoords" )
--##############################################################################

--##############################################################################
--net.Receive
net.Receive( "askCoords", function( len, ply )
  if mapSize.sizeN == -9999999999 or mapSize.sizeS == 9999999999 or mapSize.sizeW == 9999999999 or mapSize.sizeE == -9999999999 then
    net.Start( "sendCoords" )
      net.WriteBool( false )
      net.WriteTable( mapSize )
    net.Send( ply )

    getMapCoords()
  else
    net.Start( "sendCoords" )
      net.WriteBool( true )
      net.WriteTable( mapSize )
    net.Send( ply )
  end
end)
--##############################################################################

--##############################################################################
--tryNewPos
function tryNewPos( dir, size, space, tmpX, tmpY, tmpZ )
  local fails = 1
  local tmpEnd = 0
  local result = dir

  for i = dir, size, space do
    if util.IsInWorld( Vector( tmpX or i, tmpY or i, tmpZ or i ) ) and tmpEnd < fails then
      result = i
      if tmpEnd > 0 then
        tmpEnd = 0
      end
    else
      tmpEnd = tmpEnd + 1
      if tmpEnd >= fails then
        break
      end
    end
  end
  if skyCamera != nil then
    if skyCamera:GetPos():Distance( Vector( tmpX, tmpY, result ) ) < 500 then
      if result != nil then
        return result
      end
    end
  end
  return result
end
--##############################################################################

function searchCoords( ent )
  local size = 1000000
	local space = 8

  if ent:GetPos().z - 64 > mapSize.spawnPointsH then
    mapSize.spawnPointsH = ent:GetPos().z - 64
  end

  local testUp = tryNewPos( ent:GetPos().z, size, space, ent:GetPos().x, ent:GetPos().y, nil )
  if testUp > mapSize.sizeUp then
    mapSize.sizeUp = testUp
  end

  local testE = tryNewPos( ent:GetPos().x, size, space, nil, ent:GetPos().y, mapSize.sizeUp )
  if testE > mapSize.sizeE then
    mapSize.sizeE = testE
  end
  local testW = tryNewPos( ent:GetPos().x, -size, -space, nil, ent:GetPos().y, mapSize.sizeUp )
  if testW < mapSize.sizeW then
    mapSize.sizeW = testW
  end

  local testN = tryNewPos( ent:GetPos().y, size, space, ent:GetPos().x, nil, mapSize.sizeUp )
  if testN > mapSize.sizeN then
    mapSize.sizeN = testN
  end
  local testS = tryNewPos( ent:GetPos().y, -size, -space, ent:GetPos().x, nil, mapSize.sizeUp )
  if testS < mapSize.sizeS then
    mapSize.sizeS = testS
  end
end

function getCoords()
  if skyCamera == nil then
    skyCamera = ents.FindByClass( "sky_camera" )
    skyCamera = skyCamera[1]
  end

  if mapSize.hasFog == nil then
    local tmpTable = ents.FindByClass( "fog_controller" )
    if tmpTable[1] != nil then
      mapSize.hasFog = true
    else
      mapSize.hasFog = false
    end
  end

  local _hasNoSpawnpoints = true
  for k, v in pairs( ents.GetAll() ) do
    if v:GetClass() == "info_player_teamspawn"
			or v:GetClass() == "info_player_terrorist"
			or v:GetClass() == "info_player_counterterrorist"
			then
      _hasNoSpawnpoints = true
    end
  end

	for k, v in pairs( ents.GetAll() ) do
    if _hasNoSpawnpoints then
      if v:GetClass() == "info_player_start" then
        searchCoords( v )
      end
    else
  		if v:GetClass() == "info_player_teamspawn" then
        searchCoords( v )
      elseif v:GetClass() == "info_player_terrorist" then
        searchCoords( v )
      elseif v:GetClass() == "info_player_counterterrorist" then
        searchCoords( v )
      end
    end

    if v:GetClass() == "prop_door_rotating" then
      searchCoords( v )
    end
	end

  --RoundDown
	mapSize.sizeN = math.Round(mapSize.sizeN)
	mapSize.sizeE = math.Round(mapSize.sizeE)
	mapSize.sizeS = math.Round(mapSize.sizeS)
	mapSize.sizeW = math.Round(mapSize.sizeW)

	mapSize.sizeUp = math.Round(mapSize.sizeUp)
	if mapSize.sizeUp-mapSize.spawnPointsH < 5000 then
		mapSize.eventH = mapSize.sizeUp
	else
		mapSize.eventH = mapSize.spawnPointsH + 5000
	end
  mapSize.eventH = mapSize.eventH - 256

	mapSize.sizeX = mapSize.sizeE + math.abs( mapSize.sizeW )
	mapSize.sizeY = mapSize.sizeN + math.abs( mapSize.sizeS )

  mapSize.sizeX = math.abs( mapSize.sizeX )
  mapSize.sizeY = math.abs( mapSize.sizeY )

	mapSize.sizeFE = mapSize.sizeX * mapSize.sizeY

	mapSize.midX = mapSize.sizeE - ( mapSize.sizeX / 2 )
	mapSize.midY = mapSize.sizeN - ( mapSize.sizeY / 2 )

  if mapSize.sizeX >= mapSize.sizeY then
    mapSize.facX = 1
    mapSize.facY = (mapSize.sizeX/mapSize.sizeY) --X: 30000 / 10000 = 3
  else
    mapSize.facX = (mapSize.sizeY/mapSize.sizeX) --Y: 30000 / 10000 = 3
    mapSize.facY = 1
  end

  --Ohne Problem durchgelaufen
	mapSize.error = 0

  if mapSize.sizeN == -9999999999 or mapSize.sizeS == 9999999999 or mapSize.sizeW == 9999999999 or mapSize.sizeE == -9999999999 then
    timer.Simple( 5, function()
      printGM( "note", "getMapCoords retry" )
      getMapCoords()
    end)
  end
end

--##############################################################################
--getMapCoords
function getMapCoords()
  getCoords()
end
--##############################################################################

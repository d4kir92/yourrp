//sv_sizer.lua

//##############################################################################
//Map vars
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
//##############################################################################

//##############################################################################
//util
util.AddNetworkString( "askCoords" )
util.AddNetworkString( "sendCoords" )
//##############################################################################

//##############################################################################
//net.Receive
net.Receive( "askCoords", function( len, ply )
  //PrintTable( mapSize )

  net.Start( "sendCoords" )
    net.WriteTable( mapSize )
  net.Send( ply )
end)
//##############################################################################

//##############################################################################
//tryNewPos
function tryNewPos( dir, size, space, tmpX, tmpY, tmpZ, fails )
  local tmpEnd = 0
  local result = nil
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
  return result
end
//##############################################################################

function getCoords()
	local size = 1000000
	local space = 32
	local fails = 4

	for k, v in pairs( ents.GetAll() ) do
		if v:GetClass() == "info_player_teamspawn"
			or v:GetClass() == "info_player_start"
			or v:GetClass() == "info_player_terrorist"
			or v:GetClass() == "info_player_counterterrorist"
			then

			if v:GetPos().z > mapSize.spawnPointsH then
				mapSize.spawnPointsH = v:GetPos().z
			end

      mapSize.sizeUp = tryNewPos( v:GetPos().z, size, space, v:GetPos().x, v:GetPos().y, nil, fails )

      mapSize.sizeE = tryNewPos( v:GetPos().x, size, space, nil, v:GetPos().y, mapSize.sizeUp, fails )
      mapSize.sizeW = tryNewPos( v:GetPos().x, -size, -space, nil, v:GetPos().y, mapSize.sizeUp, fails )

      mapSize.sizeN = tryNewPos( v:GetPos().y, size, space, v:GetPos().x, nil, mapSize.sizeUp, fails )
      mapSize.sizeS = tryNewPos( v:GetPos().y, -size, -space, v:GetPos().x, nil, mapSize.sizeUp, fails )
    end
	end

  //RoundDown
	mapSize.sizeN = math.Round(mapSize.sizeN)-64
	mapSize.sizeE = math.Round(mapSize.sizeE)-64
	mapSize.sizeS = math.Round(mapSize.sizeS)+64
	mapSize.sizeW = math.Round(mapSize.sizeW)+64

	mapSize.sizeUp = math.Round(mapSize.sizeUp)-128
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

  /*mapSizeMid = ents.Create( "gga_mid" )
  mapSizeMid:SetPos( Vector( mapSize.midX, mapSize.midY, mapSize.spawnPointsH ) )
  mapSizeMid:Spawn()*/

  if mapSize.sizeX >= mapSize.sizeY then
    print("FAC")
    mapSize.facX = 1
    mapSize.facY = (mapSize.sizeX/mapSize.sizeY) //X: 30000 / 10000 = 3
  else
    mapSize.facX = (mapSize.sizeY/mapSize.sizeX) //Y: 30000 / 10000 = 3
    mapSize.facY = 1
  end

  //Ohne Problem durchgelaufen
	mapSize.error = 0
end

//##############################################################################
//getMapCoords
function getMapCoords()
  print("getMapCoords")
  getCoords()
end
//##############################################################################

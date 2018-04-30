--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

-- DO NOT TOUCH THE DATABASE FILES! If you have errors, report them here:
-- https://discord.gg/sEgNZxg

util.AddNetworkString( "removeVehicleOwner" )

util.AddNetworkString( "getVehicleInfo" )

local _db_name = "yrp_vehicles"
SQL_ADD_COLUMN( _db_name, "keynr", "TEXT DEFAULT '-1'" )
SQL_ADD_COLUMN( _db_name, "price", "TEXT DEFAULT 100" )
SQL_ADD_COLUMN( _db_name, "ownerCharID", "TEXT DEFAULT ''" )
SQL_ADD_COLUMN( _db_name, "ClassName", "TEXT DEFAULT ''" )

--db_drop_table( _db_name )
--db_is_empty( _db_name )

function allowedToUseVehicle( id, ply )
  if ply:HasAccess() then
    return true
  else
    local _tmpVehicleTable = SQL_SELECT( "yrp_vehicles", "*", "uniqueID = '" .. id .. "'" )
    if _tmpVehicleTable[1] != nil then
      if tostring( _tmpVehicleTable[1].ownerCharID ) == ply:CharID() then
        return true
      end
    end
  end
  return false
end

net.Receive( "getVehicleInfo", function( len, ply )
  local _vehicle = net.ReadEntity()

  local _vehicleID = net.ReadString()

  local _vehicleTab = SQL_SELECT( "yrp_vehicles", "*", "uniqueID = " .. _vehicleID )

  if worked( _vehicleTab, "getVehicleInfo | No buyed vehicle! Dont work on spawnmenu vehicle" ) then
    local owner = ""
    for k, v in pairs( player.GetAll() ) do
      if tostring( v:CharID() ) == tostring( _vehicleTab[1].ownerCharID ) then
        owner = v:RPName()
      end
    end

    if _vehicleTab != nil then
      if allowedToUseVehicle( _vehicleID, ply ) then
        net.Start( "getVehicleInfo" )
          net.WriteBool( true )
          net.WriteEntity( _vehicle )
          net.WriteTable( _vehicleTab )
          net.WriteString( owner )
        net.Send( ply )
      else
        net.Start( "getVehicleInfo" )
          net.WriteBool( false )
        net.Send( ply )
      end
    end
  end
end)

function canVehicleLock( ply, tab )
  if tab.ownerCharID != "" then
    if tostring( ply:CharID() ) == tostring( tab.ownerCharID ) then
      return true
    end
    return false
  elseif tab.ownerCharID == "" then
    return false
  else
    printGM( "error", "canVehicleLock ELSE" )
    return false
  end
end

function unlockVehicle( ply, ent, nr )
  local _tmpVehicleTable = SQL_SELECT( "yrp_vehicles", "*", "uniqueID = '" .. nr .. "'" )
  if _tmpVehicleTable != nil then
    _tmpVehicleTable = _tmpVehicleTable[1]
    if canVehicleLock( ply, _tmpVehicleTable ) then
      ent:Fire( "Unlock" )
      return true
    end
  else
    return false
  end
end

function lockVehicle( ply, ent, nr )
  local _tmpVehicleTable = SQL_SELECT( "yrp_vehicles", "*", "uniqueID = '" .. nr .. "'" )
  if _tmpVehicleTable != nil then
    _tmpVehicleTable = _tmpVehicleTable[1]
    if canVehicleLock( ply, _tmpVehicleTable ) then
      ent:Fire( "Lock" )
      return true
    end
  else
    return false
  end
end

net.Receive( "removeVehicleOwner", function( len, ply )
  local _tmpVehicleID = net.ReadString()
  local _tmpTable = SQL_SELECT( "yrp_vehicles", "*", "uniqueID = '" .. _tmpVehicleID .. "'" )

  local result = SQL_UPDATE( "yrp_vehicles", "ownerCharID = ''", "uniqueID = '" .. _tmpVehicleID .. "'" )

  for k, v in pairs( ents.GetAll() ) do
    if tonumber( v:GetNWString( "item_uniqueID" ) ) == tonumber( _tmpVehicleID ) then
      v:SetNWString( "ownerRPName", "" )
    end
  end
end)

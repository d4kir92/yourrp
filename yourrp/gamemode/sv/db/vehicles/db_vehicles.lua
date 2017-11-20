--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

--db_vehicle.lua

util.AddNetworkString( "resetVehicleKey" )
util.AddNetworkString( "createVehicleKey" )
util.AddNetworkString( "removeVehicleOwner" )

util.AddNetworkString( "getVehicleInfo" )

local _db_name = "yrp_vehicles"
sql_add_column( _db_name, "keynr", "TEXT DEFAULT '-1'" )
sql_add_column( _db_name, "price", "TEXT DEFAULT 100" )
sql_add_column( _db_name, "ownerCharID", "TEXT DEFAULT ''" )
sql_add_column( _db_name, "ClassName", "TEXT DEFAULT ''" )

--db_drop_table( _db_name )
db_is_empty( _db_name )

function createVehicleKey( ent, id )
  local _tmp = id
  _tmp = _tmp .. math.Round( math.Rand( 100000, 999999 ), 0 )
  ent.keynr = _tmp
  local result = db_update( "yrp_vehicles", "keynr = '" .. _tmp .. "'", "uniqueID = " .. id )
  return _tmp
end

function getVehicleNumber( ent, id )
  if ent.keynr == nil then
    ent.keynr = createVehicleKey( ent, id )
  end
  return ent.keynr
end

function allowedToUseVehicle( id, ply )
  if ply:IsSuperAdmin() or ply:IsAdmin() then
    return true
  else
    local _tmpVehicleTable = db_select( "yrp_vehicles", "*", "uniqueID = '" .. id .. "'" )
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

  local _vehicleTab = db_select( "yrp_vehicles", "*", "uniqueID = " .. _vehicleID )

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

net.Receive( "resetVehicleKey", function( len, ply )
  local _vehicle = net.ReadEntity()
  local _tmpVehicleID = net.ReadInt( 16 )

  createVehicleKey( _vehicle, _tmpVehicleID )
end)

net.Receive( "createVehicleKey", function( len, ply )
  local _vehicle = net.ReadEntity()
  local _tmpVehicleID = net.ReadInt( 16 )

  local _keynr = -1
  for k, v in pairs( ply:GetWeapons() ) do
    if v.ClassName == "yrp_key" then
      _keynr = getVehicleNumber( _vehicle, _tmpVehicleID )
      local _oldkeynrs = db_select( "yrp_characters", "keynrs", "uniqueID = " .. ply:CharID() )
      local _tmpTable = string.Explode( ",", _oldkeynrs[1].keynrs )
      if !table.HasValue( _tmpTable, _keynr ) then
        v:AddKeyNr( _keynr )

        local _newkeynrs = ""
        for l, w in pairs( _tmpTable ) do
          if w != "" then
            _newkeynrs = _newkeynrs .. w
            _newkeynrs = _newkeynrs .. ","
          end
        end
        _newkeynrs = _newkeynrs .. _keynr
        db_update( "yrp_characters", "keynrs = '" .. _newkeynrs .. "'", "uniqueID = " .. ply:CharID() )
      else
        printGM( "note", "Key already exists")
      end
      break
    end
  end
end)

function canVehicleLock( ent, nr )
  local _tmpTable = db_select( "yrp_vehicles", "keynr", "uniqueID = " .. ent:GetNWInt( "vehicleID" ) )
  if _tmpTable != nil then
    if _tmpTable[1] != nil then
      if _tmpTable[1].keynr == nr then
        return true
      else
        return false
      end
    end
  end
  return false
end

function unlockVehicle( ent, nrs )
  for k, v in pairs( nrs ) do
    if canVehicleLock( ent, v ) then
      ent:Fire( "Unlock" )
      return true
    end
  end
  return false
end

function lockVehicle( ent, nrs )
  for k, v in pairs( nrs ) do
    if canVehicleLock( ent, v ) then
      ent:Fire( "Lock", "", 0 )
      return true
    end
  end
  return false
end

net.Receive( "removeVehicleOwner", function( len, ply )
  local _tmpVehicleID = net.ReadInt( 16 )
  local _tmpTable = db_select( "yrp_vehicles", "*", "uniqueID = '" .. _tmpVehicleID .. "'" )

  local result = db_update( "yrp_vehicles", "ownerCharID = ''", "uniqueID = '" .. _tmpVehicleID .. "'" )

  for k, v in pairs( ents.GetAll() ) do
    if tonumber( v:GetNWInt( "vehicleID" ) ) == tonumber( _tmpVehicleID ) then
      v:SetNWString( "ownerRPName", "" )
      createVehicleKey( v, _tmpVehicleID )
    end
  end
end)

--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

--db_map.lua

local _db_name = "yrp_" .. string.lower( game.GetMap() )

sql_add_column( _db_name, "position", "TEXT DEFAULT ''" )
sql_add_column( _db_name, "angle", "TEXT DEFAULT ''" )
sql_add_column( _db_name, "groupID", "INTEGER DEFAULT -1" )
sql_add_column( _db_name, "type", "TEXT DEFAULT ''" )

--sql.Query( "DROP TABLE " .. _db_name )
db_is_empty( _db_name )

function teleportToPoint( ply, pos )
  printGM( "note", "teleportToPoint " .. tostring( pos ) )
  tp_to( ply, Vector( pos[1], pos[2], pos[3] ) )
end

function teleportToSpawnpoint( ply )
  local groTab = ply:GetGroTab()

  local chaTab = ply:GetChaTab()
  if chaTab != nil then
    if chaTab.map == string.lower( game.GetMap() ) and chaTab.position != "NULL" and chaTab.angle != "NULL" then
      local _tmpMapTable = db_select( "yrp_" .. string.lower( game.GetMap() ), "*", "groupID = " .. groTab.uniqueID )
      if _tmpMapTable != nil then
        local _randomSpawnPoint = table.Random( _tmpMapTable )

        local _tmp = string.Explode( ",", _randomSpawnPoint.position )
        tp_to( ply, Vector( _tmp[1], _tmp[2], _tmp[3] ) )
        _tmp = string.Explode( ",", _randomSpawnPoint.angle )
        ply:SetEyeAngles( Angle( _tmp[1], _tmp[2], _tmp[3] ) )
      else
        printGM( "note", groTab.groupID .. " has no group spawn!" )
        tp_to( ply, ply:GetPos() )
      end
    end
  else
    printGM( "note", "map: no char" )
  end
end

util.AddNetworkString( "getMapList" )
util.AddNetworkString( "dbInsertInto" )
util.AddNetworkString( "removeMapEntry" )

net.Receive( "removeMapEntry", function( len, ply )
  local _tmpMapTable = sql.Query( "SELECT * FROM yrp_" .. string.lower( game.GetMap() ) )
  local _tmpUniqueID = net.ReadString()
  db_delete_from( "yrp_" .. string.lower( game.GetMap() ), "uniqueID = " .. _tmpUniqueID )
end)

net.Receive( "getMapList", function( len, ply )
  local _tmpMapTable = sql.Query( "SELECT * FROM yrp_" .. string.lower( game.GetMap() ) )
  local _tmpGroupTable = sql.Query( "SELECT * FROM yrp_groups" )

  if _tmpMapTable != nil then
    net.Start( "getMapList" )
      net.WriteBool( false )
      net.WriteTable( _tmpMapTable )
      net.WriteTable( _tmpGroupTable )
    net.Send( ply )
  else
    _tmpMapTable = {}
    net.Start( "getMapList" )
      net.WriteBool( true )
      net.WriteTable( _tmpMapTable )
      net.WriteTable( _tmpGroupTable )
    net.Send( ply )
  end
end)

net.Receive( "dbInsertInto", function()
  local _tmpDBTable = net.ReadString()
  local _tmpDBCol = net.ReadString()
  local _tmpDBVal = net.ReadString()
  if sql.TableExists( _tmpDBTable ) then
    db_insert_into( _tmpDBTable, _tmpDBCol, _tmpDBVal )
  else
    printGM( "error", "dbInsertInto: " .. _tmpDBTable .. " is not existing" )
  end
end)

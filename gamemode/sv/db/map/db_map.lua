--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

-- DO NOT TOUCH THE DATABASE FILES! If you have errors, report them here:
-- https://discord.gg/sEgNZxg

local _db_name = "yrp_" .. db_sql_str2( string.lower( game.GetMap() ) )

sql_add_column( _db_name, "position", "TEXT DEFAULT ''" )
sql_add_column( _db_name, "angle", "TEXT DEFAULT ''" )
sql_add_column( _db_name, "groupID", "INTEGER DEFAULT -1" )
sql_add_column( _db_name, "roleID", "INTEGER DEFAULT -1" )
sql_add_column( _db_name, "type", "TEXT DEFAULT ''" )
sql_add_column( _db_name, "linkID", "TEXT DEFAULT ''" )

--db_drop_table( _db_name )
--db_is_empty( _db_name )

function teleportToPoint( ply, pos )
  printGM( "note", "teleportToPoint " .. tostring( pos ) )
  tp_to( ply, Vector( pos[1], pos[2], pos[3] ) )
end

util.AddNetworkString( "yrp_noti" )
util.AddNetworkString( "yrp_info" )

function teleportToSpawnpoint( ply )
  --printGM( "note", "teleportToSpawnpoint " .. ply:Nick() )
  local rolTab = ply:GetRolTab()
  local groTab = ply:GetGroTab()
  local chaTab = ply:GetChaTab()

  if chaTab != nil and groTab != nil and rolTab != nil then
    if chaTab.map == db_sql_str2( string.lower( game.GetMap() ) ) and chaTab.position != "NULL" and chaTab.angle != "NULL" then
      local _tmpRoleSpawnpoints = db_select( "yrp_" .. db_sql_str2( string.lower( game.GetMap() ) ), "*", "roleID = " .. rolTab.uniqueID )
      local _tmpGroupSpawnpoints = db_select( "yrp_" .. db_sql_str2( string.lower( game.GetMap() ) ), "*", "groupID = " .. groTab.uniqueID )
      if _tmpRoleSpawnpoints != nil then
        local _randomSpawnPoint = table.Random( _tmpRoleSpawnpoints )
        printGM( "note", "[" .. ply:Nick() .. "] teleported to role (" .. tostring( _tmpRoleSpawnpoints.roleID ) .. ") spawnpoint " .. tostring( _randomSpawnPoint.position ) )

        local _tmp = string.Explode( ",", _randomSpawnPoint.position )
        tp_to( ply, Vector( math.Round( _tmp[1], 2 ), math.Round( _tmp[2], 2 ), math.Round( _tmp[3], 2 ) ) )
        _tmp = string.Explode( ",", _randomSpawnPoint.angle )
        ply:SetEyeAngles( Angle( _tmp[1], _tmp[2], _tmp[3] ) )
        return true
      elseif _tmpGroupSpawnpoints != nil then
        local _randomSpawnPoint = table.Random( _tmpGroupSpawnpoints )
        printGM( "note", "[" .. ply:Nick() .. "] teleported to group (" .. tostring( _tmpGroupSpawnpoints.groupID ) .. ") spawnpoint " .. tostring( _randomSpawnPoint.position ) )

        local _tmp = string.Explode( ",", _randomSpawnPoint.position )
        tp_to( ply, Vector( math.Round( _tmp[1], 2 ), math.Round( _tmp[2], 2 ), math.Round( _tmp[3], 2 ) ) )
        _tmp = string.Explode( ",", _randomSpawnPoint.angle )
        ply:SetEyeAngles( Angle( _tmp[1], _tmp[2], _tmp[3] ) )
        return true
      else
        local _has_ug = true
        local _ug = {}
        _ug.uppergroup = groTab.uppergroup

        while (_has_ug) do
          _ug = db_select( "yrp_groups", "*", "uniqueID = " .. _ug.uppergroup )

          if _ug != nil then
            _ug = _ug[1]
            local _gs = db_select( "yrp_" .. db_sql_str2( string.lower( game.GetMap() ) ), "*", "groupID = " .. _ug.uniqueID )
            if _gs != nil then
              local _randomSpawnPoint = table.Random( _gs )
              printGM( "note", "[" .. ply:Nick() .. "] teleported to group (" .. tostring( _ug.groupID ) .. ") spawnpoint " .. tostring( _randomSpawnPoint.position ) )
              local _tmp = string.Explode( ",", _randomSpawnPoint.position )
              tp_to( ply, Vector( math.Round( _tmp[1], 2 ), math.Round( _tmp[2], 2 ), math.Round( _tmp[3], 2 ) ) )
              _tmp = string.Explode( ",", _randomSpawnPoint.angle )
              ply:SetEyeAngles( Angle( _tmp[1], _tmp[2], _tmp[3] ) )
              return true
            end
          else
            _has_ug = false
          end
        end
        local _str = "[" .. tostring( groTab.groupID ) .. "]" .. " has NO role or group spawnpoint!"
        printGM( "note", _str )

        net.Start( "yrp_noti" )
          net.WriteString( "nogroupspawn" )
          net.WriteString( tostring( groTab.groupID ) )
        net.Broadcast()

        tp_to( ply, ply:GetPos() )
        return false
      end
    end
  else
    return false
  end
end

util.AddNetworkString( "getMapList" )
util.AddNetworkString( "dbInsertIntoMap" )
util.AddNetworkString( "removeMapEntry" )

net.Receive( "removeMapEntry", function( len, ply )
  local _tmpUniqueID = net.ReadString()

  local _tmpMapTable = db_select( "yrp_" .. db_sql_str2( string.lower( game.GetMap() ) ), "*", "uniqueID = '" .. _tmpUniqueID .. "'" )
  if _tmpMapTable != nil then
    _tmpMapTable = _tmpMapTable[1]
    if _tmpMapTable.type == "dealer" then
      dealer_rem( _tmpMapTable.linkID )
    end
  end
  db_delete_from( "yrp_" .. db_sql_str2( string.lower( game.GetMap() ) ), "uniqueID = " .. _tmpUniqueID )
end)

net.Receive( "getMapList", function( len, ply )
  local _tmpMapTable = db_select( "yrp_" .. db_sql_str2( string.lower( game.GetMap() ) ), "*", nil )
  local _tmpGroupTable = db_select( "yrp_groups", "*", nil )
  local _tmpRoleTable = db_select( "yrp_roles", "*", nil )

  if _tmpMapTable != nil then
    net.Start( "getMapList" )
      net.WriteBool( false )
      net.WriteTable( _tmpMapTable )
      net.WriteTable( _tmpGroupTable )
      net.WriteTable( _tmpRoleTable )
    net.Send( ply )
  else
    _tmpMapTable = {}
    net.Start( "getMapList" )
      net.WriteBool( true )
      net.WriteTable( _tmpMapTable )
      net.WriteTable( _tmpGroupTable )
      net.WriteTable( _tmpRoleTable )
    net.Send( ply )
  end
end)

net.Receive( "dbInsertIntoMap", function( len, ply )
  local _tmpDBTable = net.ReadString()
  local _tmpDBCol = net.ReadString()
  local _tmpDBVal = net.ReadString()
  if sql.TableExists( _tmpDBTable ) then
    db_insert_into( _tmpDBTable, _tmpDBCol, _tmpDBVal )
  else
    printGM( "error", "dbInsertInto: " .. _tmpDBTable .. " is not existing" )
  end
end)

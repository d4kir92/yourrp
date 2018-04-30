--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

-- DO NOT TOUCH THE DATABASE FILES! If you have errors, report them here:
-- https://discord.gg/sEgNZxg

local _db_name = "yrp_" .. GetMapNameDB()

SQL_ADD_COLUMN( _db_name, "position", "TEXT DEFAULT ''" )
SQL_ADD_COLUMN( _db_name, "angle", "TEXT DEFAULT ''" )
SQL_ADD_COLUMN( _db_name, "type", "TEXT DEFAULT ''" )
SQL_ADD_COLUMN( _db_name, "linkID", "TEXT DEFAULT ''" )
SQL_ADD_COLUMN( _db_name, "name", "TEXT DEFAULT ''" )

--db_drop_table( _db_name )
--db_is_empty( _db_name )

function teleportToPoint( ply, pos )
  printGM( "note", "teleportToPoint " .. tostring( pos ) )
  tp_to( ply, Vector( pos[1], pos[2], pos[3] ) )
end

util.AddNetworkString( "yrp_noti" )
util.AddNetworkString( "yrp_info" )

function teleportToSpawnpoint( ply )
  timer.Simple( 0.01, function()
    --printGM( "note", "teleportToSpawnpoint " .. ply:Nick() )
    local rolTab = ply:GetRolTab()
    local groTab = ply:GetGroTab()
    local chaTab = ply:GetChaTab()

    if chaTab != nil and groTab != nil and rolTab != nil then
      if chaTab.map == GetMapNameDB() then
        local _tmpRoleSpawnpoints = SQL_SELECT( "yrp_" .. GetMapNameDB(), "*", "type = 'RoleSpawnpoint' AND linkID = " .. rolTab.uniqueID )
        local _tmpGroupSpawnpoints = SQL_SELECT( "yrp_" .. GetMapNameDB(), "*", "type = 'GroupSpawnpoint' AND linkID = " .. groTab.uniqueID )
        if _tmpRoleSpawnpoints != nil then
          local _randomSpawnPoint = table.Random( _tmpRoleSpawnpoints )
          printGM( "note", "[" .. ply:Nick() .. "] teleported to role (" .. tostring( rolTab.roleID ) .. ") spawnpoint " .. tostring( _randomSpawnPoint.position ) )

          local _tmp = string.Explode( ",", _randomSpawnPoint.position )
          tp_to( ply, Vector( _tmp[1], _tmp[2], _tmp[3] ) )
          _tmp = string.Explode( ",", _randomSpawnPoint.angle )
          ply:SetEyeAngles( Angle( _tmp[1], _tmp[2], _tmp[3] ) )
          return true
        elseif _tmpGroupSpawnpoints != nil then
          local _randomSpawnPoint = table.Random( _tmpGroupSpawnpoints )
          printGM( "note", "[" .. ply:Nick() .. "] teleported to group (" .. tostring( groTab.groupID ) .. ") spawnpoint " .. tostring( _randomSpawnPoint.position ) )

          local _tmp = string.Explode( ",", _randomSpawnPoint.position )
          tp_to( ply, Vector( _tmp[1], _tmp[2], _tmp[3] ) )
          _tmp = string.Explode( ",", _randomSpawnPoint.angle )
          ply:SetEyeAngles( Angle( _tmp[1], _tmp[2], _tmp[3] ) )
          return true
        else
          local _has_ug = true
          local _ug = {}
          _ug.uppergroup = groTab.uppergroup

          while (_has_ug) do
            _ug = SQL_SELECT( "yrp_groups", "*", "uniqueID = " .. _ug.uppergroup )

            if _ug != nil then
              _ug = _ug[1]
              local _gs = SQL_SELECT( "yrp_" .. GetMapNameDB(), "*", "linkID = " .. _ug.uniqueID )
              if _gs != nil then
                local _randomSpawnPoint = table.Random( _gs )
                printGM( "note", "[" .. ply:Nick() .. "] teleported to uppergroup (" .. tostring( _ug.groupID ) .. ") spawnpoint " .. tostring( _randomSpawnPoint.position ) )
                local _tmp = string.Explode( ",", _randomSpawnPoint.position )
                tp_to( ply, Vector( _tmp[1], _tmp[2], _tmp[3] ) )
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
  end)
end

util.AddNetworkString( "getMapList" )
util.AddNetworkString( "dbInsertIntoMap" )
util.AddNetworkString( "removeMapEntry" )

net.Receive( "removeMapEntry", function( len, ply )
  local _tmpUniqueID = net.ReadString()

  local _tmpMapTable = SQL_SELECT( "yrp_" .. GetMapNameDB(), "*", "uniqueID = '" .. _tmpUniqueID .. "'" )
  if _tmpMapTable != nil then
    _tmpMapTable = _tmpMapTable[1]
    if _tmpMapTable.type == "dealer" then
      dealer_rem( _tmpMapTable.linkID )
    end
  end
  SQL_DELETE_FROM( "yrp_" .. GetMapNameDB(), "uniqueID = " .. _tmpUniqueID )
end)

net.Receive( "getMapList", function( len, ply )
  local _tmpMapTable = SQL_SELECT( "yrp_" .. GetMapNameDB(), "*", nil )
  if _tmpMapTable == nil or _tmpMapTable == false then
    _tmpMapTable = {}
  end
  local _tmpGroupTable = SQL_SELECT( "yrp_groups", "*", nil )
  local _tmpRoleTable = SQL_SELECT( "yrp_roles", "*", nil )
  local _tmpDealerTable = SQL_SELECT( "yrp_dealers", "*", nil )
  if _tmpDealerTable == nil or _tmpDealerTable == false then
    _tmpDealerTable = {}
  end

  net.Start( "getMapList" )
    net.WriteBool( false )
    net.WriteTable( _tmpMapTable )
    net.WriteTable( _tmpGroupTable )
    net.WriteTable( _tmpRoleTable )
    net.WriteTable( _tmpDealerTable )
  net.Send( ply )
end)

net.Receive( "dbInsertIntoMap", function( len, ply )
  local _tmpDBTable = net.ReadString()
  local _tmpDBCol = net.ReadString()
  local _tmpDBVal = net.ReadString()
  if sql.TableExists( _tmpDBTable ) then
    SQL_INSERT_INTO( _tmpDBTable, _tmpDBCol, _tmpDBVal )
  else
    printGM( "error", "dbInsertInto: " .. _tmpDBTable .. " is not existing" )
  end
end)

util.AddNetworkString( "dealer_settings" )
net.Receive( "dealer_settings", function( len, ply )
  local _storages = SQL_SELECT( _db_name, "*", "type = 'Storagepoint'" )
  if _storages == nil or _storages == false then
    _storages = {}
  end
  net.Start( "dealer_settings" )
    net.WriteTable( _storages )
  net.Send( ply )
end)

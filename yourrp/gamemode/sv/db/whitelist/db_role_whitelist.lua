--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

-- DO NOT TOUCH THE DATABASE FILES! If you have errors, report them here:
-- https://discord.gg/sEgNZxg

local _db_name = "yrp_role_whitelist"

sql_add_column( _db_name, "SteamID", "TEXT DEFAULT ''" )
sql_add_column( _db_name, "nick", "TEXT DEFAULT ''" )
sql_add_column( _db_name, "groupID", "INTEGER DEFAULT -1" )
sql_add_column( _db_name, "roleID", "INTEGER DEFAULT -1" )

--db_drop_table( _db_name )
--db_is_empty( _db_name )

util.AddNetworkString( "getRoleWhitelist" )
util.AddNetworkString( "whitelistPlayer" )
util.AddNetworkString( "whitelistPlayerRemove" )
util.AddNetworkString( "yrpInfoBox" )

function sendRoleWhitelist( ply )
  if ply:IsSuperAdmin() or ply:IsAdmin() then
    local _tmpWhiteList = db_select( "yrp_role_whitelist", "*", nil )
    local _tmpRoleList = db_select( "yrp_roles", "groupID, roleID, uniqueID", nil )
    local _tmpGroupList = db_select( "yrp_groups", "groupID, uniqueID", nil )

    if _tmpWhiteList != nil and _tmpRoleList != nil and _tmpGroupList != nil then

      net.Start( "getRoleWhitelist" )
        net.WriteTable( _tmpWhiteList )
        net.WriteTable( _tmpRoleList )
        net.WriteTable( _tmpGroupList )
      net.Send( ply )
    elseif _tmpRoleList != nil and _tmpGroupList != nil then
      printGM( "note", "sendRoleWhitelist Whitelist is empty" )
      _tmpWhiteList = {}
      net.Start( "getRoleWhitelist" )
        net.WriteTable( _tmpWhiteList )
        net.WriteTable( _tmpRoleList )
        net.WriteTable( _tmpGroupList )
      net.Send( ply )
    else
      printGM( "error", "group and role list broken" )
    end
  end
end

net.Receive( "whitelistPlayerRemove", function( len, ply )
  local _tmpUniqueID = net.ReadInt( 16 )
  db_delete_from( "yrp_role_whitelist", "uniqueID = " .. _tmpUniqueID )
end)

net.Receive( "whitelistPlayer", function( len, ply )
  if ply:IsSuperAdmin() or ply:IsAdmin() then
    local _SteamID = net.ReadString()
    local _nick = ""
    for k, v in pairs( player.GetAll() ) do
      if v:SteamID() == _SteamID then
        _nick = v:Nick()
      end
    end
    local _roleID = net.ReadInt( 16 )
    local _dbRole = db_select( "yrp_roles", "*", "uniqueID = " .. _roleID )
    local _groupID = _dbRole[1].groupID

    db_insert_into( "yrp_role_whitelist", "SteamID, nick, groupID, roleID", "'" .. _SteamID .. "', '" .. _nick .. "', " .. _groupID .. ", " .. _roleID )
  end
  sendRoleWhitelist( ply )
end)


net.Receive( "getRoleWhitelist", function( len, ply )
  sendRoleWhitelist( ply )
end)

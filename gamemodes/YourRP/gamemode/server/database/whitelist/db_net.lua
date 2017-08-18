util.AddNetworkString( "getRoleWhitelist" )
util.AddNetworkString( "whitelistPlayer" )
util.AddNetworkString( "whitelistPlayerRemove" )
util.AddNetworkString( "yrpInfoBox" )

net.Receive( "whitelistPlayerRemove", function( len, ply )
  local _tmpUniqueID = net.ReadInt( 16 )
  dbDeleteFrom( "yrp_role_whitelist", "uniqueID = " .. _tmpUniqueID )
end)

net.Receive( "whitelistPlayer", function( len, ply )
  if ply:IsSuperAdmin() or ply:IsAdmin() then
    local _steamID = net.ReadString()
    local _nick = ""
    for k, v in pairs( player.GetAll() ) do
      if v:SteamID() == _steamID then
        _nick = v:Nick()
      end
    end
    local _roleID = net.ReadInt( 16 )
    local _dbRole = dbSelect( "yrp_roles", "*", "uniqueID = " .. _roleID )
    local _groupID = _dbRole[1].groupID

    dbInsertInto( "yrp_role_whitelist", "steamID, nick, groupID, roleID", "'" .. _steamID .. "', '" .. _nick .. "', " .. _groupID .. ", " .. _roleID )
  end
  sendRoleWhitelist( ply )
end)


net.Receive( "getRoleWhitelist", function( len, ply )
  sendRoleWhitelist( ply )
end)

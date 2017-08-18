
util.AddNetworkString( "openCharakterMenu" )
util.AddNetworkString( "setPlayerValues" )
util.AddNetworkString( "setRoleValues" )

util.AddNetworkString( "getPlyList" )
util.AddNetworkString( "giveRole" )

util.AddNetworkString( "getCharakterList" )
util.AddNetworkString( "updateFirstName" )
util.AddNetworkString( "updateSurName" )

net.Receive( "updateSurName", function( len, ply )
  local _surName = string.Replace( net.ReadString(), " ", "" )
  local _result = dbUpdate( "yrp_players", "nameSur = '" .. _surName .. "'", "steamID = '" .. ply:SteamID() .. "'" )
  ply:SetNWString( "SurName", _surName )
end)

net.Receive( "updateFirstName", function( len, ply )
  local _firstName = string.Replace( net.ReadString(), " ", "" )
  local _result = dbUpdate( "yrp_players", "nameFirst = '" .. _firstName .. "'", "steamID = '" .. ply:SteamID() .. "'" )
  ply:SetNWString( "FirstName", _firstName )
end)

net.Receive( "getCharakterList", function( len, ply )
  local _tmpPlyList = dbSelect( "yrp_players", "*", "steamID = '" .. ply:SteamID() .. "'" )
  if _tmpPlyList != nil then
    net.Start( "getCharakterList" )
      net.WriteTable( _tmpPlyList )
    net.Send( ply )
  end
end)

net.Receive( "getPlyList", function( len, ply )
  local _tmpPlyList = dbSelect( "yrp_players", "*", nil )
  local _tmpRoleList = dbSelect( "yrp_roles", "*", nil )
  local _tmpGroupList = dbSelect( "yrp_groups", "*", nil )
  if _tmpPlyList != nil and _tmpRoleList != nil and _tmpGroupList != nil then
    net.Start( "getPlyList" )
      net.WriteTable( _tmpPlyList )
      net.WriteTable( _tmpRoleList )
      net.WriteTable( _tmpGroupList )
    net.Send( ply )
  end
end)

net.Receive( "giveRole", function( len, ply )
  local _tmpSteamID = net.ReadString()
  local uniqueIDRole = net.ReadInt( 16 )
  local tmpTable = sql.Query( "SELECT * FROM yrp_roles WHERE uniqueID = " .. uniqueIDRole )
  local _steamNick = _tmpSteamID

  if tmpTable != nil then
    if tmpTable[1].uses < tmpTable[1].maxamount or tonumber( tmpTable[1].maxamount ) == -1 then
      local query = ""
      query = query .. "UPDATE yrp_players "
      query = query .. "SET roleID = " .. tonumber( tmpTable[1].uniqueID ) .. ", "
      query = query .. "capital = " .. tonumber( tmpTable[1].capital ) .. " "
      query = query .. "WHERE steamID = '" .. _tmpSteamID .. "'"
      local result = sql.Query( query )
      setRole( _tmpSteamID, uniqueIDRole )

      updateUses()
      for k, v in pairs( player.GetAll() ) do
        if _tmpSteamID == v:SteamID() then
          _steamNick = v:Nick()
          updateHud( v )
          break
        end
      end
      printGM( "admin", ply:Nick() .. " gives " .. _steamNick .. " the Role: " .. tmpTable[1].roleID )
    else
      for k, v in pairs( player.GetAll() ) do
        if _tmpSteamID == v:SteamID() then
          _steamNick = v:Nick()
          break
        end
      end
      printGM( "admin", ply:Nick() .. " can't give " .. _steamNick .. " the Role: " .. tmpTable[1].roleID .. ", because max amount reached")
    end
  else
    printError( "Role " .. uniqueIDRole .. " is not available" )
  end
end)

function isWhitelisted( ply, id )
  local _plyAllowed = dbSelect( "yrp_role_whitelist", "*", "steamID = '" .. ply:SteamID() .. "' AND roleID = " .. id )
  if _plyAllowed != nil and _plyAllowed != false then
    return true
  else
    return false
  end
end

net.Receive( "wantRole", function( len, ply )
  local uniqueIDRole = net.ReadInt( 16 )
  local tmpTableRole = sql.Query( "SELECT * FROM yrp_roles WHERE uniqueID = " .. uniqueIDRole )

  if tmpTableRole != nil then
    local tmpTableGroup = sql.Query( "SELECT * FROM yrp_groups WHERE uniqueID = " .. tmpTableRole[1].groupID )
    if tmpTableRole[1].uses < tmpTableRole[1].maxamount or tonumber( tmpTableRole[1].maxamount ) == -1 then
      if tmpTableRole[1].adminonly == 1 then
        if ply:IsAdmin() or ply:IsSuperAdmin() then
        else
          return
        end
      elseif tonumber( tmpTableRole[1].whitelist ) == 1 then
        if !isWhitelisted( ply, uniqueIDRole ) then
          printGM( "user", ply:Nick() .. " is not in the whitelist for this role")
          net.Start( "yrpInfoBox" )
            net.WriteString( "You need to get whitelisted for this Role" )
          net.Send( ply )
          return
        end
      end
      local query = ""
      query = query .. "UPDATE yrp_players "
      query = query .. "SET roleID = " .. tonumber( tmpTableRole[1].uniqueID ) .. ", "
      query = query .. "capital = " .. tonumber( tmpTableRole[1].capital ) .. " "
      query = query .. "WHERE steamID = '" .. ply:SteamID() .. "'"
      local result = sql.Query( query )
      setRole( ply:SteamID(), uniqueIDRole )

      ply:KillSilent()

      updateHud( ply )

      printGM( "user", ply:Nick() .. " is now the Role: " .. tmpTableGroup[1].groupID .. " " .. tmpTableRole[1].roleID )

      updateUses()

    else
      printGM( "user", ply:Nick() .. " want the role: " .. tmpTableRole[1].roleID .. ", FAILED: Max amount reached" )
    end
  else
    printError( "Role " .. uniqueIDRole .. " is not available" )
  end
end)

net.Receive( "setPlayerValues", function( len, ply )
  local tmpSurname = string.Replace( net.ReadString(), " ", "" )
  local tmpFirstname = string.Replace( net.ReadString(), " ", "" )
  local tmpGender = string.Replace( net.ReadString(), " ", "" )

  local _result = sql.Query( "SELECT * FROM yrp_players WHERE steamID = '" .. ply:SteamID() .. "'" )
  if _result != nil then
    if tmpSurname != "" and tmpFirstname != "" and tmpGender != "" then
      local query = ""
      query = query .. "UPDATE yrp_players "
      query = query .. "SET nameFirst = '" .. tmpFirstname .. "', "
      query = query .. "nameSur = '" .. tmpSurname .. "', "
      query = query .. "gender = '" .. tmpGender .. "' "
      query = query .. "WHERE steamID = '" .. ply:SteamID() .. "'"
      sql.Query( query )
    else
      net.Start( "openCharakterMenu" )
      net.Send( ply )
    end
  end
end)

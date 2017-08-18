
function updateGroupTable()
  local _tmpGroups = dbSelect( "yrp_groups", "*", nil )
  net.Start( "updateGroups" )
    net.WriteTable( _tmpGroups )
  net.Broadcast()
end

function setRoleValues( ply )
  local tmpTablePly = dbSelect( "yrp_players", "*", "steamID = '" .. ply:SteamID() .. "'" )
  if tmpTablePly != false and tmpTablePly != nil then
    local tmpTableRole = dbSelect( "yrp_roles" , "*", "uniqueID = " .. tmpTablePly[1].roleID )
    if tmpTableRole != false and tmpTableRole != nil then
      local tmpTableGroup = dbSelect( "yrp_groups", "*", "uniqueID = " .. tmpTableRole[1].groupID )
      if tmpTableGroup != false and tmpTableGroup != nil then
        local modelsize = tmpTableRole[1].playermodelsize
        ply:SetWalkSpeed( tmpTableRole[1].speedwalk*modelsize )
        ply:SetRunSpeed( tmpTableRole[1].speedrun*modelsize )

        ply:SetMaxHealth( tonumber( tmpTableRole[1].hpmax ) )
        ply:SetHealth( tonumber( tmpTableRole[1].hp ) )
        ply:SetNWInt( "GetHealthReg", tonumber( tmpTableRole[1].hpreg ) )

        ply:SetNWInt( "GetMaxArmor", tonumber( tmpTableRole[1].armax ) )
        ply:SetNWInt( "GetArmorReg", tonumber( tmpTableRole[1].arreg ) )
        ply:SetArmor( tonumber( tmpTableRole[1].ar ) )

        ply:SetJumpPower( tonumber( tmpTableRole[1].powerjump ) * modelsize )

        ply:SetNWInt( "money", tmpTablePly[1].money )
        ply:SetNWInt( "moneybank", tmpTablePly[1].moneybank )
        ply:SetNWInt( "capital", tmpTableRole[1].capital )
        ply:SetNWString( "SurName", tmpTablePly[1].nameSur )
        ply:SetNWString( "FirstName", tmpTablePly[1].nameFirst )

        ply:SetNWString( "roleName", tmpTableRole[1].roleID )
        ply:SetNWString( "roleUniqueID", tmpTableRole[1].uniqueID )
        ply:SetNWString( "groupName", tmpTableGroup[1].groupID )
        ply:SetNWString( "groupUniqueID", tmpTableGroup[1].uniqueID )

        //sweps
        local tmpSWEPTable = string.Explode( ",", tmpTableRole[1].sweps )
        for k, swep in pairs( tmpSWEPTable ) do
          if swep != nil and swep != NULL and swep != "" then
            ply:Give( swep )
          end
        end
      else
        //
      end
    else
      //
    end
  else
    //
  end
end

function setRole( steamID, id )
  local tmpTableRole = sql.Query( "SELECT * FROM yrp_roles WHERE uniqueID = " .. id )

  local _result = sql.Query( "UPDATE yrp_players SET roleID = " .. id .. " WHERE steamID = '" .. steamID .. "'" )

  for k, ply in pairs( player.GetAll() ) do
    if ply:SteamID() == steamID then
      ply:StripWeapons()

      ply:SetModel( tmpTableRole[1].playermodel )
      local modelsize = tonumber( tmpTableRole[1].playermodelsize )
      yrpSetModelScale( ply, modelsize )

      setRoleValues( ply )

      updateHud( ply )
      break
    end
  end
end

//##############################################################################
function roleCheck( string )
  printGM( "db", "RoleCheck (" .. string .. ")" )

  //1 hour = 3600
  //1 day = 86400
  //1 week = 604800
  local tmpAfk = 604800
  local tmpCounter = 0

  local tmpTable = sql.Query( "SELECT timestamp, roleID, steamID FROM yrp_players" )
  if tmpTable != false and tmpTable != nil then
    for k, v in pairs( tmpTable ) do
      if ( os.time() - tonumber( v.timestamp ) ) > tmpAfk then
        local q = ""
        q = q .. "UPDATE yrp_players "
        q = q .. "SET "
        q = q .. "roleID = 1 "
        q = q .. "WHERE "
        q = q .. "steamID = '" .. v.steamID .. "'"
        sql.Query( q )
        tmpCounter = tmpCounter + 1
      end
    end
  end
  if tmpCounter > 0 then
    printGM( "db", "RoleCheck: " .. tmpCounter .. " roles are free." )
  end
  updateUses()
end
roleCheck( "Init" )
//##############################################################################

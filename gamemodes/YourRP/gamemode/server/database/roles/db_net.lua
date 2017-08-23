//Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

//##############################################################################
//utils
util.AddNetworkString( "getAllGroups" )

util.AddNetworkString( "newGroup" )
util.AddNetworkString( "getGroups" )
util.AddNetworkString( "getGroupLine" )
util.AddNetworkString( "removeGroup" )

util.AddNetworkString( "updateGroupName" )
util.AddNetworkString( "updateGroupColor" )
util.AddNetworkString( "updateUpperGroup" )
util.AddNetworkString( "updateFriendlyFire" )

util.AddNetworkString( "newRole" )
util.AddNetworkString( "getRoles" )
util.AddNetworkString( "getRoleLine" )
util.AddNetworkString( "removeRole" )

util.AddNetworkString( "updateRoleName" )
util.AddNetworkString( "updateRoleColor" )
util.AddNetworkString( "updateRolePlayermodel" )
util.AddNetworkString( "updateRolePlayermodelsize" )
util.AddNetworkString( "updateRoleDescription" )
util.AddNetworkString( "updateRoleCapital" )
util.AddNetworkString( "updateRoleMaxAmount" )
util.AddNetworkString( "updateRoleHp" )
util.AddNetworkString( "updateRoleHpMax" )
util.AddNetworkString( "updateRoleHpReg" )
util.AddNetworkString( "updateRoleAr" )
util.AddNetworkString( "updateRoleArMax" )
util.AddNetworkString( "updateRoleArReg" )
util.AddNetworkString( "updateRoleSpeedWalk" )
util.AddNetworkString( "updateRoleSpeedRun" )
util.AddNetworkString( "updateRolePowerJump" )
util.AddNetworkString( "updateRolePreRole" )
util.AddNetworkString( "updateRoleInstructor" )
util.AddNetworkString( "updateRoleGroup" )
util.AddNetworkString( "updateRoleSweps" )
util.AddNetworkString( "updateRoleAdminonly" )
util.AddNetworkString( "updateRoleWhitelist" )

util.AddNetworkString( "wantRole" )

util.AddNetworkString( "openInteractMenu" )
util.AddNetworkString( "promotePlayer" )
util.AddNetworkString( "demotePlayer" )

util.AddNetworkString( "getAllRoles" )

util.AddNetworkString( "updateGroups" )
//##############################################################################

//##############################################################################
//net.Receives
net.Receive( "updateGroups", function( len, ply )
  updateGroupTable()
end)

net.Receive( "getAllRoles", function( len, ply )
  local _allRoles = dbSelect( "yrp_roles", "*", nil )
  net.Start( "getAllRoles" )
    net.WriteTable( _allRoles )
  net.Send( ply )
end)

net.Receive( "demotePlayer", function( len, ply )
  local tmpTargetSteamID = net.ReadString()

  local tmpTableInstructor = sql.Query( "SELECT * FROM yrp_players WHERE steamID = '" .. ply:SteamID() .. "'" )
  local tmpTableInstructorRole = sql.Query( "SELECT * FROM yrp_roles WHERE uniqueID = " .. tmpTableInstructor[1].roleID )

  if tonumber( tmpTableInstructorRole[1].instructor ) == 1 then
    local tmpTableTarget = sql.Query( "SELECT * FROM yrp_players WHERE steamID = '" .. tmpTargetSteamID .. "'" )
    local tmpTableTargetRole = sql.Query( "SELECT * FROM yrp_roles WHERE uniqueID = " .. tmpTableTarget[1].roleID )
    local tmpTableTargetDemoteRole = sql.Query( "SELECT * FROM yrp_roles WHERE uniqueID = " .. tmpTableTargetRole[1].prerole )
    setRole( tmpTargetSteamID, tmpTableTargetDemoteRole[1].uniqueID )

    removeFromWhitelist( tmpTargetSteamID, tmpTableTargetRole[1].uniqueID )

    printGM( "instructor", ply:SteamID() .. " demoted " .. tmpTargetSteamID .. " to " .. tmpTableTargetDemoteRole[1].roleID )
    updateUses()
  else
    printERROR( "Player: " .. ply:Nick() .. " (" .. ply:SteamID() .. ") tried to use demote function! He is not an instructor!" )
  end
end)

function removeFromWhitelist( steamID, roleID )
  local _result = dbSelect( "yrp_role_whitelist", "*", "steamID = '" .. steamID .. "' AND roleID = " .. roleID )
  if _result != nil then
    dbDeleteFrom( "yrp_role_whitelist", "uniqueID = " .. _result[1].uniqueID )
  end
end

function addToWhitelist( steamID, roleID, groupID, nick )
  if dbSelect( "yrp_role_whitelist", "*", "steamID = '" .. steamID .. "' AND roleID = " .. roleID ) == nil then
    dbInsertInto( "yrp_role_whitelist", "steamID, nick, groupID, roleID", "'" .. steamID .. "', '" .. nick .. "', " .. groupID .. ", " .. roleID )
  else
    printGM( "note", "is already in whitelist")
  end
end

net.Receive( "promotePlayer", function( len, ply )
  local tmpTargetSteamID = net.ReadString()

  local tmpTableInstructor = dbSelect( "yrp_players", "roleID", "steamID = '" .. ply:SteamID() .. "'" )
  local tmpTableInstructorRole = dbSelect( "yrp_roles", "*", "uniqueID = " .. tmpTableInstructor[1].roleID )

  if tonumber( tmpTableInstructorRole[1].instructor ) == 1 then
    local tmpTableTarget = dbSelect( "yrp_players", "roleID", "steamID = '" .. tmpTargetSteamID .. "'" )
    local tmpTableTargetRole = dbSelect( "yrp_roles", "*", "uniqueID = " .. tmpTableTarget[1].roleID )
    local tmpTableTargetPromoteRole = dbSelect( "yrp_roles", "*", "prerole = " .. tmpTableTargetRole[1].uniqueID )

    setRole( tmpTargetSteamID, tmpTableTargetPromoteRole[1].uniqueID )

    for k, v in pairs(player.GetAll()) do
      if tostring( v:SteamID() ) == tostring( tmpTargetSteamID ) then
        local tmpTableTargetGroup = dbSelect( "yrp_groups", "*", "uniqueID = " .. tmpTableTargetRole[1].groupID )
        addToWhitelist( tmpTargetSteamID, tmpTableTargetPromoteRole[1].uniqueID, tmpTableTargetGroup[1].uniqueID, v:Nick() )
        break
      end
    end

    printGM( "instructor", ply:SteamID() .. " promoted " .. tmpTargetSteamID .. " to " .. tmpTableTargetPromoteRole[1].roleID )
    updateUses()
  else
    printERROR( "Player: " .. ply:Nick() .. " (" .. ply:SteamID() .. ") tried to use promote function! He is not an instructor!" )
  end
end)

net.Receive( "openInteractMenu", function( len, ply )
  local tmpTargetSteamID = net.ReadString()

  local tmpTargetRoleID = dbSelect( "yrp_players", "*", "steamID = '" .. tmpTargetSteamID .. "'" )
  local tmpTargetRole = dbSelect( "yrp_roles", "*", "uniqueID = " .. tmpTargetRoleID[1].roleID )

  local tmpT = sql.Query( "SELECT * FROM yrp_players WHERE steamID = '" .. ply:SteamID() .. "'" )
  local tmpTable = sql.Query( "SELECT * FROM yrp_roles WHERE uniqueID = " .. tmpT[1].roleID )

  local tmpBool = false

  local tmpPromote = false
  local tmpPromoteName = ""

  local tmpDemote = false
  local tmpDemoteName = ""

  if tonumber( tmpTable[1].instructor ) == 1 then
    tmpBool = true

    local tmpSearch = true  //tmpTargetSteamID
    local tmpTableSearch = sql.Query( "SELECT * FROM yrp_roles WHERE uniqueID = " .. tmpTable[1].prerole )
    if tmpTableSearch != nil then
      local tmpSearchUniqueID = tmpTableSearch[1].prerole
      local tmpCounter = 0
      while (tmpSearch) do
        tmpSearchUniqueID = tonumber( tmpTableSearch[1].prerole )

        if tonumber( tmpTargetRole[1].prerole ) != -1 and tmpTableSearch[1].uniqueID == tmpTargetRole[1].uniqueID then
          tmpDemote = true
          local tmp = sql.Query( "SELECT * FROM yrp_roles WHERE uniqueID = " .. tmpTargetRole[1].prerole )
          tmpDemoteName = tmp[1].roleID
        end

        if tonumber( tmpSearchUniqueID ) == tonumber( tmpTargetRole[1].uniqueID ) then
          tmpPromote = true
          tmpPromoteName = tmpTableSearch[1].roleID
        end
        if tmpSearchUniqueID == -1 then
          tmpSearch = false
        end
        if tmpCounter >= 100 then
          printERROR( "counter" )
          tmpSearch = false
        end
        tmpCounter = tmpCounter + 1
        tmpTableSearch = sql.Query( "SELECT * FROM yrp_roles WHERE uniqueID = " .. tmpSearchUniqueID )
      end
    end
  end

  net.Start( "openInteractMenu" )
    net.WriteBool( tmpBool )

    net.WriteBool( tmpPromote )
    net.WriteString( tmpPromoteName )

    net.WriteBool( tmpDemote )
    net.WriteString( tmpDemoteName )

  net.Send( ply )
end)

net.Receive( "getAllGroups", function( len, ply )
  local tmpUpperGroup = net.ReadInt( 16 )

  local tmpTable = sql.Query( "SELECT * FROM yrp_groups" )
  local tmpTable2 = sql.Query( "SELECT * FROM yrp_roles" )
  local tmpTable3 = dbSelect( "yrp_role_whitelist", "*", "steamID = '" .. ply:SteamID() .. "'" )
  if tmpTable3 == nil then
    tmpTable3 = {}
  end
  if tmpTable != nil then
    net.Start( "getAllGroups" )
      net.WriteTable( tmpTable )
      net.WriteTable( tmpTable2 )
      net.WriteTable( tmpTable3 )
    net.Send( ply )
  end
end)

net.Receive( "updateRolePlayermodelsize", function( len, ply )
  local tmpUniqueID = net.ReadInt( 16 )
  local tmpPlayermodelsize = net.ReadString()

  sql.Query( "UPDATE yrp_roles SET playermodelsize = " .. tonumber( tmpPlayermodelsize ) .. " WHERE uniqueID = " .. tmpUniqueID .. "" )
end)

net.Receive( "updateRoleWhitelist", function( len, ply )
  local tmpUniqueID = net.ReadInt( 16 )
  local tmpWhitelist = net.ReadInt( 4 )

  sql.Query( "UPDATE yrp_roles SET whitelist = " .. tmpWhitelist .. " WHERE uniqueID = " .. tmpUniqueID .. "" )
end)

net.Receive( "updateRoleAdminonly", function( len, ply )
  local tmpUniqueID = net.ReadInt( 16 )
  local tmpAdminonly = net.ReadInt( 4 )

  sql.Query( "UPDATE yrp_roles SET adminonly = " .. tmpAdminonly .. " WHERE uniqueID = " .. tmpUniqueID .. "" )
end)

net.Receive( "updateRoleSweps", function( len, ply )
  local tmpUniqueID = net.ReadInt( 16 )
  local tmpSweps = net.ReadString()

  sql.Query( "UPDATE yrp_roles SET sweps = '" .. tmpSweps .. "' WHERE uniqueID = " .. tmpUniqueID .. "" )
end)

net.Receive( "updateRoleGroup", function( len, ply )
  local tmpUniqueID = net.ReadInt( 16 )
  local tmpGroupID = net.ReadInt( 16 )

  sql.Query( "UPDATE yrp_roles SET groupID = " .. tmpGroupID .. " WHERE uniqueID = " .. tmpUniqueID .. "" )
end)

net.Receive( "updateRoleInstructor", function( len, ply )
  local tmpUniqueID = net.ReadInt( 16 )
  local tmpInstructor = net.ReadInt( 4 )

  sql.Query( "UPDATE yrp_roles SET instructor = " .. tmpInstructor .. " WHERE uniqueID = " .. tmpUniqueID .. "" )
end)

net.Receive( "updateRolePreRole", function( len, ply )
  local tmpUniqueID = net.ReadInt( 16 )
  local tmpPreRole = net.ReadInt( 16 )

  local _result = sql.Query( "UPDATE yrp_roles SET prerole = " .. tmpPreRole .. " WHERE uniqueID = " .. tmpUniqueID .. "" )
end)

net.Receive( "updateRolePowerJump", function( len, ply )
  local tmpUniqueID = net.ReadInt( 16 )
  local tmpJump = net.ReadString()

  sql.Query( "UPDATE yrp_roles SET powerjump = " .. tonumber(tmpJump) .. " WHERE uniqueID = " .. tmpUniqueID .. "" )
end)

net.Receive( "updateRoleSpeedRun", function( len, ply )
  local tmpUniqueID = net.ReadInt( 16 )
  local tmpRun = net.ReadString()

  sql.Query( "UPDATE yrp_roles SET speedrun = " .. tonumber(tmpRun) .. " WHERE uniqueID = " .. tmpUniqueID .. "" )
end)

net.Receive( "updateRoleSpeedWalk", function( len, ply )
  local tmpUniqueID = net.ReadInt( 16 )
  local tmpWalk = net.ReadString()

  sql.Query( "UPDATE yrp_roles SET speedwalk = " .. tonumber(tmpWalk) .. " WHERE uniqueID = " .. tmpUniqueID .. "" )
end)

net.Receive( "updateRoleAr", function( len, ply )
  local tmpUniqueID = net.ReadInt( 16 )
  local tmpAr = net.ReadString()

  sql.Query( "UPDATE yrp_roles SET ar = " .. tonumber(tmpAr) .. " WHERE uniqueID = " .. tmpUniqueID .. "" )
end)

net.Receive( "updateRoleArMax", function( len, ply )
  local tmpUniqueID = net.ReadInt( 16 )
  local tmpAr = net.ReadString()

  sql.Query( "UPDATE yrp_roles SET armax = " .. tonumber(tmpAr) .. " WHERE uniqueID = " .. tmpUniqueID .. "" )
end)

net.Receive( "updateRoleArReg", function( len, ply )
  local tmpUniqueID = net.ReadInt( 16 )
  local tmpAr = net.ReadString()

  sql.Query( "UPDATE yrp_roles SET arreg = " .. tonumber(tmpAr) .. " WHERE uniqueID = " .. tmpUniqueID .. "" )
end)

net.Receive( "updateRoleHp", function( len, ply )
  local tmpUniqueID = net.ReadInt( 16 )
  local tmpHp = net.ReadString()

  sql.Query( "UPDATE yrp_roles SET hp = " .. tonumber(tmpHp) .. " WHERE uniqueID = " .. tmpUniqueID .. "" )
end)

net.Receive( "updateRoleHpMax", function( len, ply )
  local tmpUniqueID = net.ReadInt( 16 )
  local tmpHp = net.ReadString()

  sql.Query( "UPDATE yrp_roles SET hpmax = " .. tonumber(tmpHp) .. " WHERE uniqueID = " .. tmpUniqueID .. "" )
end)

net.Receive( "updateRoleHpReg", function( len, ply )
  local tmpUniqueID = net.ReadInt( 16 )
  local tmpHp = net.ReadString()

  sql.Query( "UPDATE yrp_roles SET hpreg = " .. tonumber(tmpHp) .. " WHERE uniqueID = " .. tmpUniqueID .. "" )
end)

net.Receive( "updateRoleMaxAmount", function( len, ply )
  local tmpUniqueID = net.ReadInt( 16 )
  local tmpMaxAmount = net.ReadString()

  sql.Query( "UPDATE yrp_roles SET maxamount = " .. tonumber(tmpMaxAmount) .. " WHERE uniqueID = " .. tmpUniqueID .. "" )
end)

net.Receive( "updateRoleCapital", function( len, ply )
  local tmpUniqueID = net.ReadInt( 16 )
  local tmpCapital = net.ReadString()

  sql.Query( "UPDATE yrp_roles SET capital = " .. tonumber(tmpCapital) .. " WHERE uniqueID = " .. tmpUniqueID .. "" )
end)

net.Receive( "updateRoleDescription", function( len, ply )
  local tmpUniqueID = net.ReadInt( 16 )
  local tmpDescription = net.ReadString()

  sql.Query( "UPDATE yrp_roles SET description = '" .. tmpDescription .. "' WHERE uniqueID = " .. tmpUniqueID .. "" )
end)

net.Receive( "updateRolePlayermodel", function( len, ply )
  local tmpUniqueID = net.ReadInt( 16 )
  local tmpPlayermodel = net.ReadString()

  sql.Query( "UPDATE yrp_roles SET playermodel = '" .. tmpPlayermodel .. "' WHERE uniqueID = " .. tmpUniqueID .. "" )
end)

net.Receive( "updateRoleColor", function( len, ply )
  local tmpUniqueID = net.ReadInt( 16 )
  local tmpColor = net.ReadString()

  sql.Query( "UPDATE yrp_roles SET color = '" .. tmpColor .. "' WHERE uniqueID = " .. tmpUniqueID .. "" )
end)

net.Receive( "updateRoleName", function( len, ply )
  local tmpUniqueID = net.ReadInt( 16 )
  local tmpGroupID = net.ReadString()

  sql.Query( "UPDATE yrp_roles SET roleID = '" .. tmpGroupID .. "' WHERE uniqueID = " .. tmpUniqueID .. "" )
  for k, v in pairs(player.GetAll()) do
    updateHud( v )
  end
end)

net.Receive( "newRole", function( len, ply )
  local _tmpGroup = net.ReadInt( 16 )
  sql.Query( "INSERT INTO yrp_roles ( roleID, color, removeable, groupID ) VALUES ( 'new Role', '0,0,0', 1," .. _tmpGroup .. " )" )

  local tmpLast = sql.Query( "SELECT * FROM yrp_roles WHERE uniqueID = (SELECT MAX(uniqueID) FROM yrp_roles)")

  printGM( "db", ply:Nick() .. " created new Role: " .. tmpLast[1].roleID .. " (ID: " .. tmpLast[1].uniqueID .. ")" )
  sql.Query( "UPDATE yrp_roles SET roleID = '" .. tmpLast[1].roleID .. " (" .. tmpLast[1].uniqueID .. ")' WHERE uniqueID = " .. tmpLast[1].uniqueID .. "")

  net.Start( "getRoles" )
    net.WriteTable( sql.Query( "SELECT * FROM yrp_roles WHERE groupID = " .. _tmpGroup) )
  net.Send( ply )
end)

net.Receive( "removeRole", function( len, ply )
  local _tmpGroup = net.ReadInt( 16 )
  local tmpUniqueID = net.ReadInt( 16 )

  local tmpSelect = sql.Query( "SELECT * FROM yrp_roles WHERE uniqueID = " .. tmpUniqueID .. "" )

  if tmpSelect[1].removeable == "1" then
    printGM( "db", ply:Nick() .. " deleted Role: " .. tmpSelect[1].roleID .. " (ID: " .. tmpSelect[1].uniqueID .. ")" )
    sql.Query( "DELETE FROM yrp_roles WHERE uniqueID = " .. tmpUniqueID .. "" )

    local _tmpRoleList = sql.Query( "SELECT * FROM yrp_roles WHERE groupID = " .. _tmpGroup )
    net.Start( "getRoles" )
      if _tmpRoleList != nil then
        net.WriteTable( _tmpRoleList )
      else
        net.WriteTable( {} )
      end
    net.Send( ply )
  elseif tmpSelect[1].removeable == "0" then
    PrintMessage( HUD_PRINTCENTER, "You cant delete this!" )
  end
end)

net.Receive( "getRoles", function( len, ply )
  local _tmpGroup = net.ReadInt( 16 )
  local _tmpGroupList = sql.Query( "SELECT * FROM yrp_roles WHERE groupID = " .. _tmpGroup )
  net.Start( "getRoles" )
    if _tmpGroupList != nil then
      net.WriteTable( _tmpGroupList )
    else
      net.WriteTable( {} )
    end
  net.Send( ply )
end)

net.Receive( "getRoleLine", function( len, ply )
  net.Start( "getRoles" )
    net.WriteTable( sql.Query( "SELECT * FROM yrp_roles WHERE uniqueID = '" .. net.ReadString() .. "'" ) )
  net.Send( ply )
end)

net.Receive( "updateFriendlyFire", function( len, ply )
  local tmpUniqueID = net.ReadInt( 16 )
  local tmpFriendlyFire = net.ReadInt(4)

  sql.Query( "UPDATE yrp_groups SET friendlyfire = '" .. tmpFriendlyFire .. "' WHERE uniqueID = " .. tmpUniqueID .. "" )
end)

net.Receive( "updateUpperGroup", function( len, ply )
  local tmpUniqueID = net.ReadInt( 16 )
  local tmpUpperGroupUniqueID = net.ReadInt( 16 )

  local result = sql.Query( "UPDATE yrp_groups SET uppergroup = " .. tmpUpperGroupUniqueID .. " WHERE uniqueID = " .. tmpUniqueID .. "" )
  updateGroupTable()
end)

net.Receive( "updateGroupColor", function( len, ply )
  local tmpUniqueID = net.ReadInt( 16 )
  local tmpColor = net.ReadString()

  sql.Query( "UPDATE yrp_groups SET color = '" .. tmpColor .. "' WHERE uniqueID = " .. tmpUniqueID .. "" )
end)

net.Receive( "updateGroupName", function( len, ply )
  local tmpUniqueID = net.ReadInt( 16 )
  local tmpGroupID = net.ReadString()

  sql.Query( "UPDATE yrp_groups SET groupID = '" .. tmpGroupID .. "' WHERE uniqueID = " .. tmpUniqueID .. "" )
  for k, v in pairs(player.GetAll()) do
    updateHud( v )
  end
  updateGroupTable()
end)

net.Receive( "newGroup", function( len, ply )
  sql.Query( "INSERT INTO yrp_groups ( groupID, color, uppergroup, friendlyfire, removeable ) VALUES ( 'new Group', '0,0,0', -1, 1, 1 )" )

  local tmpLast = sql.Query( "SELECT * FROM yrp_groups WHERE uniqueID = (SELECT MAX(uniqueID) FROM yrp_groups)")

  sql.Query( "UPDATE yrp_groups SET groupID = '" .. tmpLast[1].groupID .. " (" .. tmpLast[1].uniqueID .. ")' WHERE uniqueID = " .. tmpLast[1].uniqueID .. "")

  printGM( "db", ply:Nick() .. " created new Group: " .. tmpLast[1].groupID .. " (ID: " .. tmpLast[1].uniqueID .. ")" )
  net.Start( "getGroups" )
    net.WriteTable( sql.Query( "SELECT * FROM yrp_groups" ) )
  net.Send( ply )
  updateGroupTable()
end)

net.Receive( "removeGroup", function( len, ply )
  local tmpUniqueID = net.ReadInt( 16 )

  local tmpSelect = sql.Query( "SELECT * FROM yrp_groups WHERE uniqueID = " .. tmpUniqueID .. "" )

  if tmpSelect[1].removeable == "1" then
    printGM( "db", ply:Nick() .. " deleted Group: " .. tmpSelect[1].groupID .. " (ID: " .. tmpSelect[1].uniqueID .. ")" )
    sql.Query( "DELETE FROM yrp_groups WHERE uniqueID = " .. tmpUniqueID .. "" )

    sql.Query( "DELETE FROM yrp_roles WHERE groupID = " .. tmpUniqueID )
    net.Start( "getGroups" )
      net.WriteTable( sql.Query( "SELECT * FROM yrp_groups" ) )
    net.Send( ply )
  elseif tmpSelect[1].removeable == "0" then
    printGM( "db", ply:Nick() .. " tried to delete an unremoveable Group: " .. tmpSelect[1].groupID .. " (ID: " .. tmpSelect[1].uniqueID .. ")" )
    ply:PrintMessage( HUD_PRINTCENTER, "You cant delete this!" )
  end
  updateGroupTable()
end)

net.Receive( "getGroups", function( len, ply )
  net.Start( "getGroups" )
    net.WriteTable( sql.Query( "SELECT * FROM yrp_groups" ) )
  net.Send( ply )
end)

net.Receive( "getGroupLine", function( len, ply )
  net.Start( "getGroups" )
    net.WriteTable( sql.Query( "SELECT * FROM yrp_groups WHERE uniqueID = '" .. net.ReadString() .. "'" ) )
  net.Send( ply )
end)
//##############################################################################

--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

--##############################################################################
--utils
util.AddNetworkString( "getAllGroups" )

util.AddNetworkString( "wantRole" )

util.AddNetworkString( "openInteractMenu" )
util.AddNetworkString( "promotePlayer" )
util.AddNetworkString( "demotePlayer" )
--NEW
util.AddNetworkString( "yrp_groups" )
util.AddNetworkString( "yrp_roles" )

util.AddNetworkString( "removeDBGroup" )
util.AddNetworkString( "removeDBRole" )

util.AddNetworkString( "addDBGroup" )
util.AddNetworkString( "addDBRole" )

util.AddNetworkString( "dupDBGroup" )
util.AddNetworkString( "dupDBRole" )

util.AddNetworkString( "getScoreboardGroups" )
--##############################################################################

function sendDBGroups( ply )
  local tmp = dbSelect( "yrp_groups", "*", nil )
  net.Start( "yrp_groups" )
    net.WriteTable( tmp )
  net.Send( ply )
end

function sendDBRoles( ply, groupID )
  local tmp = dbSelect( "yrp_roles", "*", "groupID = " .. groupID .. "" )
  if tmp == nil then
    tmp = {}
  end
  net.Start( "yrp_roles" )
    net.WriteTable( tmp )
  net.Send( ply )
end

--##############################################################################
--net.Receives
--NEW
net.Receive( "getScoreboardGroups", function( len, ply )
  local _tmpGroups = dbSelect( "yrp_groups", "*", nil )
  if _tmpGroups != nil then
    net.Start( "getScoreboardGroups" )
      net.WriteTable( _tmpGroups )
    net.Broadcast()
  end
end)

function duplicateRole( ply, uniqueID, newGroupID )
  if newGroupID != nil then
  end
  local _dR = dbSelect( "yrp_roles", "*", "uniqueID = " .. uniqueID )
  _dR = _dR[1]
  if newGroupID != nil then
    _dR.groupID = newGroupID
  end
  if tonumber( _dR.removeable ) == 1 then
    local _dbColumns = "adminonly, ar, armax, arreg, capital, color, description, groupID, hp, hpmax, hpreg, instructor, maxamount, playermodels, playermodelsize, powerjump, prerole, removeable, roleID, speedrun, speedwalk, sweps, whitelist"
    local _dbValues = _dR.adminonly .. ", " .. _dR.ar .. ", " .. _dR.armax .. ", " .. _dR.arreg .. ", " .. _dR.capital .. ", '" .. _dR.color .. "', '" .. _dR.description .. "', "
    _dbValues = _dbValues .. _dR.groupID .. ", " .. _dR.hp .. ", " .. _dR.hpmax .. ", " .. _dR.hpreg .. ", " .. _dR.instructor .. ", " .. _dR.maxamount .. ", "
    _dbValues = _dbValues .. "'" .. _dR.playermodels .. "', " .. _dR.playermodelsize .. ", " .. _dR.powerjump .. ", " .. _dR.prerole .. ", " .. _dR.removeable .. ", '" .. _dR.roleID .. "', "
    _dbValues = _dbValues .. _dR.speedrun .. ", " .. _dR.speedwalk .. ", '" .. _dR.sweps .. "', " .. _dR.whitelist
    dbInsertInto( "yrp_roles", _dbColumns, _dbValues )
  else
    printGM( "note", "not duplicateable!" )
  end
end

net.Receive( "dupDBRole", function( len, ply )
  local _tmpGroupID = net.ReadString()
  local _tmpUniqueID = net.ReadString()
  duplicateRole( ply, _tmpUniqueID, nil )
  sendDBRoles( ply, _tmpGroupID )
end)

function duplicateGroup( uniqueID )
  local _dR = dbSelect( "yrp_groups", "*", "uniqueID = " .. uniqueID )
  _dR = _dR[1]
  if tonumber( _dR.removeable ) == 1 then
    local _dbColumns = "groupID, color, uppergroup"
    local _dbValues = "'" .. _dR.groupID .. "', '" .. _dR.color .. "' , " .. _dR.uppergroup

    dbInsertInto( "yrp_groups", _dbColumns, _dbValues )

    local _lastGroup = dbSelect( "yrp_groups", "uniqueID", nil )

    local _allRolesFromGroup = dbSelect( "yrp_roles", "*", "groupID = " .. uniqueID )
    if _allRolesFromGroup != nil then
      for k, v in pairs( _allRolesFromGroup ) do
        duplicateRole( ply, v.uniqueID, _lastGroup[#_lastGroup].uniqueID )
      end
    end
  else
    printGM( "note", "not duplicateable!" )
  end
end

net.Receive( "dupDBGroup", function( len, ply )
  local _tmpUniqueID = net.ReadString()

  duplicateGroup( _tmpUniqueID )
  sendDBGroups( ply )
end)

net.Receive( "addDBRole", function( len, ply )
  printGM( "db", "addDBRole" )
  local _tmpUniqueID = net.ReadString()
  local result = dbInsertInto( "yrp_roles", "roleID, groupID", "'new Role', " .. _tmpUniqueID )
  printGM( "db", result)

  sendDBRoles( ply, _tmpUniqueID )
end)

net.Receive( "addDBGroup", function( len, ply )
  sql.Query( "INSERT INTO yrp_groups ( groupID, uppergroup, removeable ) VALUES ( 'new Group', -1, 1 )" )

  sendDBGroups( ply )
end)

function changeToDefault( table )
  for k, v in pairs( table ) do
    local _result = dbUpdate( "yrp_characters", "roleID = 1, groupID = 1" ,"uniqueID = " .. v.uniqueID )
  end
end

net.Receive( "removeDBRole", function( len, ply )
  local _dbSelect = dbSelect( "yrp_roles", "*", nil )
  local tmp = net.ReadString()
  local _tmpUniqueID = net.ReadString()
  for k, v in pairs( _dbSelect ) do
    if tonumber( v.uniqueID ) == tonumber( tmp ) then
      if tonumber( v.removeable ) == 1 then
        local _result = dbDeleteFrom( "yrp_roles", "uniqueID = " .. tmp )
        local _changeToDefault = dbSelect( "yrp_characters", "*", "roleID = " .. v.uniqueID )
        if _changeToDefault != nil then
          changeToDefault( _changeToDefault )
        end
      end
    end
  end

  sendDBRoles( ply, _tmpUniqueID )
end)

net.Receive( "removeDBGroup", function( len, ply )
  local _dbSelect = dbSelect( "yrp_groups", "*", nil )
  local tmp = net.ReadString()
  for k, v in pairs( _dbSelect ) do
    if tonumber( v.uniqueID ) == tonumber( tmp ) then
      if tonumber( v.removeable ) == 1 then
        dbDeleteFrom( "yrp_groups", "uniqueID = " .. tmp )
      end
    end
  end

  sendDBGroups( ply )
end)

net.Receive( "yrp_roles", function( len, ply )
  local _tmpGroupID = net.ReadString()
  sendDBRoles( ply, _tmpGroupID )
end)

net.Receive( "yrp_groups", function( len, ply )
  sendDBGroups( ply )
end)

net.Receive( "demotePlayer", function( len, ply )
  local tmpTargetSteamID = net.ReadString()

  local tmpTarget = nil
  for k, v in pairs( player.GetAll() ) do
    if v:SteamID() == tmpTargetSteamID then
      tmpTarget = v
    end
  end

  local tmpTableInstructor = ply:GetChaTab()
  local tmpTableInstructorRole = dbSelect( "yrp_roles", "*", "uniqueID = " .. tmpTableInstructor.roleID )

  local tmpTargetChaTab = tmpTarget:GetChaTab()

  if tonumber( tmpTableInstructorRole[1].instructor ) == 1 then


    local tmpTableTargetRole = dbSelect( "yrp_roles", "*", "uniqueID = " .. tmpTargetChaTab.roleID )
    local tmpTableTargetDemoteRole = dbSelect( "yrp_roles", "*", "uniqueID = " .. tmpTableTargetRole[1].prerole )
    local tmpTableTargetGroup = dbSelect( "yrp_groups", "*", "uniqueID = " .. tmpTableTargetDemoteRole[1].groupID )

    tmpTableTargetDemoteRole = tmpTableTargetDemoteRole[1]
    tmpTableTargetGroup = tmpTableTargetGroup[1]

    SetRole( tmpTarget, tmpTableTargetDemoteRole.uniqueID )
    SetRolVals( tmpTarget )

    removeFromWhitelist( tmpTarget:SteamID(), tmpTableTargetRole[1].uniqueID )

    printGM( "instructor", ply:Nick() .. " demoted " .. tmpTarget:Nick() .. " to " .. tmpTableTargetDemoteRole.roleID )
  else
    printERROR( "Player: " .. ply:Nick() .. " (" .. ply:SteamID() .. ") tried to use demote function! He is not an instructor!" )
  end
end)

function removeFromWhitelist( SteamID, roleID )
  local _result = dbSelect( "yrp_role_whitelist", "*", "SteamID = '" .. SteamID .. "' AND roleID = " .. roleID )
  if _result != nil then
    dbDeleteFrom( "yrp_role_whitelist", "uniqueID = " .. _result[1].uniqueID )
  end
end

function addToWhitelist( SteamID, roleID, groupID, nick )
  if dbSelect( "yrp_role_whitelist", "*", "SteamID = '" .. SteamID .. "' AND roleID = " .. roleID ) == nil then
    dbInsertInto( "yrp_role_whitelist", "SteamID, nick, groupID, roleID", "'" .. SteamID .. "', '" .. nick .. "', " .. groupID .. ", " .. roleID )
  else
    printGM( "note", "is already in whitelist")
  end
end

net.Receive( "promotePlayer", function( len, ply )
  local tmpTargetSteamID = net.ReadString()

  local tmpTarget = nil
  for k, v in pairs( player.GetAll() ) do
    if v:SteamID() == tmpTargetSteamID then
      tmpTarget = v
    end
  end

  local tmpTableInstructor = ply:GetChaTab()
  local tmpTableInstructorRole = dbSelect( "yrp_roles", "*", "uniqueID = " .. tmpTableInstructor.roleID )

  local tmpTargetChaTab = tmpTarget:GetChaTab()

  if tonumber( tmpTableInstructorRole[1].instructor ) == 1 then
    local tmpTableTargetRole = dbSelect( "yrp_roles", "*", "uniqueID = " .. tmpTargetChaTab.roleID )
    local tmpTableTargetPromoteRole = dbSelect( "yrp_roles", "*", "prerole = " .. tmpTableTargetRole[1].uniqueID )
    local tmpTableTargetGroup = dbSelect( "yrp_groups", "*", "uniqueID = " .. tmpTableTargetPromoteRole[1].groupID )

    tmpTableTargetPromoteRole = tmpTableTargetPromoteRole[1]
    tmpTableTargetGroup = tmpTableTargetGroup[1]

    SetRole( tmpTarget, tmpTableTargetPromoteRole.uniqueID )
    SetRolVals( tmpTarget )

    for k, v in pairs(player.GetAll()) do
      if tostring( v:SteamID() ) == tostring( tmpTargetSteamID ) then
        addToWhitelist( tmpTarget:SteamID(), tmpTableTargetPromoteRole.uniqueID, tmpTableTargetGroup.uniqueID, v:Nick() )
        break
      end
    end

    printGM( "instructor", ply:Nick() .. " promoted " .. tmpTarget:Nick() .. " to " .. tmpTableTargetPromoteRole.roleID )
  else
    printERROR( "Player: " .. ply:Nick() .. " (" .. ply:SteamID() .. ") tried to use promote function! He is not an instructor!" )
  end
end)

net.Receive( "openInteractMenu", function( len, ply )
  local tmpTargetSteamID = net.ReadString()

  local tmpTarget = nil
  for k, v in pairs( player.GetAll() ) do
    if v:SteamID() == tmpTargetSteamID then
      tmpTarget = v
    end
  end
  local tmpTargetChaTab = tmpTarget:GetChaTab()
  local tmpTargetRole = dbSelect( "yrp_roles", "*", "uniqueID = " .. tmpTargetChaTab.roleID )

  local tmpT = ply:GetChaTab()
  local tmpTable = dbSelect( "yrp_roles", "*", "uniqueID = " .. tmpT.roleID )

  local tmpBool = false

  local tmpPromote = false
  local tmpPromoteName = ""

  local tmpDemote = false
  local tmpDemoteName = ""

  if tonumber( tmpTable[1].instructor ) == 1 then
    tmpBool = true

    local tmpSearch = true  --tmpTargetSteamID
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
  local tmpTable3 = dbSelect( "yrp_role_whitelist", "*", "SteamID = '" .. ply:SteamID() .. "'" )
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
--##############################################################################

--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

--db_roles.lua

local _db_name = "yrp_roles"

sql_add_column( _db_name, "roleID", "TEXT DEFAULT ''" )
sql_add_column( _db_name, "description", "TEXT DEFAULT '-'" )
sql_add_column( _db_name, "playermodels", "TEXT DEFAULT ''" )
sql_add_column( _db_name, "playermodelsize", "INTEGER DEFAULT 1" )
sql_add_column( _db_name, "capital", "INTEGER DEFAULT 0" )
sql_add_column( _db_name, "groupID", "INTEGER DEFAULT 1" )
sql_add_column( _db_name, "color", "TEXT DEFAULT '0,0,0'" )
sql_add_column( _db_name, "sweps", "TEXT DEFAULT ''" )
sql_add_column( _db_name, "voteable", "INTEGER DEFAULT 0" )
sql_add_column( _db_name, "adminonly", "INTEGER DEFAULT 0" )
sql_add_column( _db_name, "whitelist", "INTEGER DEFAULT 0" )
sql_add_column( _db_name, "maxamount", "INTEGER DEFAULT -1" )
sql_add_column( _db_name, "hp", "INTEGER DEFAULT 100" )
sql_add_column( _db_name, "hpmax", "INTEGER DEFAULT 100" )
sql_add_column( _db_name, "hpreg", "INTEGER DEFAULT 0" )
sql_add_column( _db_name, "ar", "INTEGER DEFAULT 0" )
sql_add_column( _db_name, "armax", "INTEGER DEFAULT 100" )
sql_add_column( _db_name, "arreg", "INTEGER DEFAULT 0" )
sql_add_column( _db_name, "speedwalk", "INTEGER DEFAULT 150" )
sql_add_column( _db_name, "speedrun", "INTEGER DEFAULT 240" )
sql_add_column( _db_name, "powerjump", "INTEGER DEFAULT 200" )
sql_add_column( _db_name, "prerole", "INTEGER DEFAULT -1" )
sql_add_column( _db_name, "instructor", "INTEGER DEFAULT 0" )
sql_add_column( _db_name, "removeable", "INTEGER DEFAULT 1" )
sql_add_column( _db_name, "uses", "INTEGER DEFAULT 0" )
sql_add_column( _db_name, "capitaltime", "INTEGER DEFAULT 120" )

--db_drop_table( _db_name )
db_is_empty( _db_name )

if db_select( _db_name, "*", "uniqueID = 1" ) == nil then
  printGM( "note", _db_name .. " has not the default role" )
  local _result = db_insert_into( _db_name, "uniqueID, roleID, color, playermodels, removeable", "1, 'Civilian', '0,0,0', 'models/player/skeleton.mdl', 0" )
  printGM( "note", _result )
end

util.AddNetworkString( "getAllGroups" )

util.AddNetworkString( "wantRole" )

util.AddNetworkString( "openInteractMenu" )
util.AddNetworkString( "promotePlayer" )
util.AddNetworkString( "demotePlayer" )

util.AddNetworkString( "yrp_groups" )
util.AddNetworkString( "yrp_roles" )

util.AddNetworkString( "removeDBGroup" )
util.AddNetworkString( "removeDBRole" )

util.AddNetworkString( "addDBGroup" )
util.AddNetworkString( "addDBRole" )

util.AddNetworkString( "dupDBGroup" )
util.AddNetworkString( "dupDBRole" )

util.AddNetworkString( "getScoreboardGroups" )

function sendDBGroups( ply )
  local tmp = db_select( "yrp_groups", "*", nil )
  net.Start( "yrp_groups" )
    net.WriteTable( tmp )
  net.Send( ply )
end

function sendDBRoles( ply, groupID )
  local tmp = db_select( "yrp_roles", "*", "groupID = " .. groupID .. "" )
  if tmp == nil then
    tmp = {}
  end
  net.Start( "yrp_roles" )
    net.WriteTable( tmp )
  net.Send( ply )
end

net.Receive( "getScoreboardGroups", function( len, ply )
  local _tmpGroups = db_select( "yrp_groups", "*", nil )
  if _tmpGroups != nil then
    net.Start( "getScoreboardGroups" )
      net.WriteTable( _tmpGroups )
    net.Broadcast()
  end
end)

function duplicateRole( ply, uniqueID, newGroupID )
  if newGroupID != nil then
  end
  local _dR = db_select( "yrp_roles", "*", "uniqueID = " .. uniqueID )
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
    db_insert_into( "yrp_roles", _dbColumns, _dbValues )
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
  local _dR = db_select( "yrp_groups", "*", "uniqueID = " .. uniqueID )
  _dR = _dR[1]
  if tonumber( _dR.removeable ) == 1 then
    local _dbColumns = "groupID, color, uppergroup"
    local _dbValues = "'" .. _dR.groupID .. "', '" .. _dR.color .. "' , " .. _dR.uppergroup

    db_insert_into( "yrp_groups", _dbColumns, _dbValues )

    local _lastGroup = db_select( "yrp_groups", "uniqueID", nil )

    local _allRolesFromGroup = db_select( "yrp_roles", "*", "groupID = " .. uniqueID )
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
  local result = db_insert_into( "yrp_roles", "roleID, groupID", "'" .. lang_string( "newrole" ) .. "', " .. _tmpUniqueID )
  printGM( "db", result)

  sendDBRoles( ply, _tmpUniqueID )
end)

net.Receive( "addDBGroup", function( len, ply )
  db_insert_into( "yrp_groups", "groupID, uppergroup, removeable", "'" .. lang_string( "newgroup" ) .. "', -1, 1" )

  sendDBGroups( ply )
end)

function changeToDefault( table )
  for k, v in pairs( table ) do
    local _result = db_update( "yrp_characters", "roleID = 1, groupID = 1" ,"uniqueID = " .. v.uniqueID )
  end
end

net.Receive( "removeDBRole", function( len, ply )
  local _dbSelect = db_select( "yrp_roles", "*", nil )
  local tmp = net.ReadString()
  local _tmpUniqueID = net.ReadString()
  for k, v in pairs( _dbSelect ) do
    if tonumber( v.uniqueID ) == tonumber( tmp ) then
      if tonumber( v.removeable ) == 1 then
        local _result = db_delete_from( "yrp_roles", "uniqueID = " .. tmp )
        local _changeToDefault = db_select( "yrp_characters", "*", "roleID = " .. v.uniqueID )
        if _changeToDefault != nil then
          changeToDefault( _changeToDefault )
        end
      end
    end
  end

  sendDBRoles( ply, _tmpUniqueID )
end)

net.Receive( "removeDBGroup", function( len, ply )
  local _dbSelect = db_select( "yrp_groups", "*", nil )
  local tmp = net.ReadString()
  for k, v in pairs( _dbSelect ) do
    if tonumber( v.uniqueID ) == tonumber( tmp ) then
      if tonumber( v.removeable ) == 1 then
        db_delete_from( "yrp_groups", "uniqueID = " .. tmp )
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
  local tmpTableInstructorRole = db_select( "yrp_roles", "*", "uniqueID = " .. tmpTableInstructor.roleID )

  local tmpTargetChaTab = tmpTarget:GetChaTab()

  if tonumber( tmpTableInstructorRole[1].instructor ) == 1 then


    local tmpTableTargetRole = db_select( "yrp_roles", "*", "uniqueID = " .. tmpTargetChaTab.roleID )
    local tmpTableTargetDemoteRole = db_select( "yrp_roles", "*", "uniqueID = " .. tmpTableTargetRole[1].prerole )
    local tmpTableTargetGroup = db_select( "yrp_groups", "*", "uniqueID = " .. tmpTableTargetDemoteRole[1].groupID )

    tmpTableTargetDemoteRole = tmpTableTargetDemoteRole[1]
    tmpTableTargetGroup = tmpTableTargetGroup[1]

    set_role( tmpTarget, tmpTableTargetDemoteRole.uniqueID )
    set_role_values( tmpTarget )

    removeFromWhitelist( tmpTarget:SteamID(), tmpTableTargetRole[1].uniqueID )

    printGM( "instructor", ply:Nick() .. " demoted " .. tmpTarget:Nick() .. " to " .. tmpTableTargetDemoteRole.roleID )
  else
    printGM( "error", "Player: " .. ply:Nick() .. " (" .. ply:SteamID() .. ") tried to use demote function! He is not an instructor!" )
  end
end)

function removeFromWhitelist( SteamID, roleID )
  local _result = db_select( "yrp_role_whitelist", "*", "SteamID = '" .. SteamID .. "' AND roleID = " .. roleID )
  if _result != nil then
    db_delete_from( "yrp_role_whitelist", "uniqueID = " .. _result[1].uniqueID )
  end
end

function addToWhitelist( SteamID, roleID, groupID, nick )
  if db_select( "yrp_role_whitelist", "*", "SteamID = '" .. SteamID .. "' AND roleID = " .. roleID ) == nil then
    db_insert_into( "yrp_role_whitelist", "SteamID, nick, groupID, roleID", "'" .. SteamID .. "', '" .. nick .. "', " .. groupID .. ", " .. roleID )
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
  local tmpTableInstructorRole = db_select( "yrp_roles", "*", "uniqueID = " .. tmpTableInstructor.roleID )

  local tmpTargetChaTab = tmpTarget:GetChaTab()

  if tonumber( tmpTableInstructorRole[1].instructor ) == 1 then
    local tmpTableTargetRole = db_select( "yrp_roles", "*", "uniqueID = " .. tmpTargetChaTab.roleID )
    local tmpTableTargetPromoteRole = db_select( "yrp_roles", "*", "prerole = " .. tmpTableTargetRole[1].uniqueID )
    local tmpTableTargetGroup = db_select( "yrp_groups", "*", "uniqueID = " .. tmpTableTargetPromoteRole[1].groupID )

    tmpTableTargetPromoteRole = tmpTableTargetPromoteRole[1]
    tmpTableTargetGroup = tmpTableTargetGroup[1]

    set_role( tmpTarget, tmpTableTargetPromoteRole.uniqueID )
    set_role_values( tmpTarget )

    for k, v in pairs(player.GetAll()) do
      if tostring( v:SteamID() ) == tostring( tmpTargetSteamID ) then
        addToWhitelist( tmpTarget:SteamID(), tmpTableTargetPromoteRole.uniqueID, tmpTableTargetGroup.uniqueID, v:Nick() )
        break
      end
    end

    printGM( "instructor", ply:Nick() .. " promoted " .. tmpTarget:Nick() .. " to " .. tmpTableTargetPromoteRole.roleID )
  else
    printGM( "error", "Player: " .. ply:Nick() .. " (" .. ply:SteamID() .. ") tried to use promote function! He is not an instructor!" )
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
  local tmpTargetRole = db_select( "yrp_roles", "*", "uniqueID = " .. tmpTargetChaTab.roleID )

  local tmpT = ply:GetChaTab()
  local tmpTable = db_select( "yrp_roles", "*", "uniqueID = " .. tmpT.roleID )

  local tmpBool = false

  local tmpPromote = false
  local tmpPromoteName = ""

  local tmpDemote = false
  local tmpDemoteName = ""

  if tonumber( tmpTable[1].instructor ) == 1 then
    tmpBool = true

    local tmpSearch = true  --tmpTargetSteamID
    local tmpTableSearch = db_select( "yrp_roles", "*", "uniqueID = " .. tmpTable[1].prerole )
    if tmpTableSearch != nil then
      local tmpSearchUniqueID = tmpTableSearch[1].prerole
      local tmpCounter = 0
      while (tmpSearch) do
        tmpSearchUniqueID = tonumber( tmpTableSearch[1].prerole )

        if tonumber( tmpTargetRole[1].prerole ) != -1 and tmpTableSearch[1].uniqueID == tmpTargetRole[1].uniqueID then
          tmpDemote = true
          local tmp = db_select( "yrp_roles", "*", "uniqueID = " .. tmpTargetRole[1].prerole )
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
          printGM( "error", "counter" )
          tmpSearch = false
        end
        tmpCounter = tmpCounter + 1
        tmpTableSearch = db_select( "yrp_roles", "*", "uniqueID = " .. tmpSearchUniqueID )
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

  local tmpTable = db_select( "yrp_groups", "*", nil )
  local tmpTable2 = db_select( "yrp_roles", "*", nil )
  local tmpTable3 = db_select( "yrp_role_whitelist", "*", "SteamID = '" .. ply:SteamID() .. "'" )
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

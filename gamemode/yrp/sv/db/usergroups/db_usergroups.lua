--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

-- DO NOT TOUCH THE DATABASE FILES! If you have errors, report them here:
-- https://discord.gg/sEgNZxg

local DATABASE_NAME = "yrp_usergroups"

SQL_ADD_COLUMN( DATABASE_NAME, "removeable", "INT DEFAULT 1" )

SQL_ADD_COLUMN( DATABASE_NAME, "name", "TEXT DEFAULT 'Unnamed UserGroup'" )
SQL_ADD_COLUMN( DATABASE_NAME, "color", "TEXT DEFAULT '0,0,0,255'" )
SQL_ADD_COLUMN( DATABASE_NAME, "icon", "TEXT DEFAULT 'http://www.famfamfam.com/lab/icons/silk/icons/shield.png'" )
SQL_ADD_COLUMN( DATABASE_NAME, "sweps", "TEXT DEFAULT ' '" )
SQL_ADD_COLUMN( DATABASE_NAME, "sents", "TEXT DEFAULT ' '" )

SQL_ADD_COLUMN( DATABASE_NAME, "adminaccess", "INT DEFAULT 0" )

SQL_ADD_COLUMN( DATABASE_NAME, "interface", "INT DEFAULT 0" )
SQL_ADD_COLUMN( DATABASE_NAME, "general", "INT DEFAULT 0" )
SQL_ADD_COLUMN( DATABASE_NAME, "realistic", "INT DEFAULT 0" )
SQL_ADD_COLUMN( DATABASE_NAME, "groupsandroles", "INT DEFAULT 0" )
SQL_ADD_COLUMN( DATABASE_NAME, "players", "INT DEFAULT 0" )
SQL_ADD_COLUMN( DATABASE_NAME, "money", "INT DEFAULT 0" )
SQL_ADD_COLUMN( DATABASE_NAME, "licenses", "INT DEFAULT 0" )
SQL_ADD_COLUMN( DATABASE_NAME, "shops", "INT DEFAULT 0" )
SQL_ADD_COLUMN( DATABASE_NAME, "map", "INT DEFAULT 0" )
SQL_ADD_COLUMN( DATABASE_NAME, "whitelist", "INT DEFAULT 0" )
SQL_ADD_COLUMN( DATABASE_NAME, "feedback", "INT DEFAULT 0" )
SQL_ADD_COLUMN( DATABASE_NAME, "usergroups", "INT DEFAULT 0" )

SQL_ADD_COLUMN( DATABASE_NAME, "vehicles", "INT DEFAULT 0" )
SQL_ADD_COLUMN( DATABASE_NAME, "weapons", "INT DEFAULT 0" )
SQL_ADD_COLUMN( DATABASE_NAME, "entities", "INT DEFAULT 0" )
SQL_ADD_COLUMN( DATABASE_NAME, "effects", "INT DEFAULT 0" )
SQL_ADD_COLUMN( DATABASE_NAME, "npcs", "INT DEFAULT 0" )
SQL_ADD_COLUMN( DATABASE_NAME, "props", "INT DEFAULT 0" )
SQL_ADD_COLUMN( DATABASE_NAME, "ragdolls", "INT DEFAULT 0" )
SQL_ADD_COLUMN( DATABASE_NAME, "noclip", "INT DEFAULT 0" )

SQL_ADD_COLUMN( DATABASE_NAME, "removetool", "INT DEFAULT 0" )
SQL_ADD_COLUMN( DATABASE_NAME, "dynamitetool", "INT DEFAULT 0" )
SQL_ADD_COLUMN( DATABASE_NAME, "ignite", "INT DEFAULT 0" )
SQL_ADD_COLUMN( DATABASE_NAME, "drive", "INT DEFAULT 0" )
SQL_ADD_COLUMN( DATABASE_NAME, "collision", "INT DEFAULT 0" )
SQL_ADD_COLUMN( DATABASE_NAME, "gravity", "INT DEFAULT 0" )
SQL_ADD_COLUMN( DATABASE_NAME, "keepupright", "INT DEFAULT 0" )
SQL_ADD_COLUMN( DATABASE_NAME, "bodygroups", "INT DEFAULT 0" )
SQL_ADD_COLUMN( DATABASE_NAME, "physgunpickup", "INT DEFAULT 0" )
SQL_ADD_COLUMN( DATABASE_NAME, "physgunpickupplayer", "INT DEFAULT 0" )

--db_drop_table( DATABASE_NAME )
--db_is_empty( DATABASE_NAME )

if SQL_SELECT( DATABASE_NAME, "*", "name = 'superadmin'" ) == nil then
  local _str = "name, vehicles, weapons, entities, effects, npcs, props, ragdolls, noclip"
  _str = _str .. ", removetool, dynamitetool, ignite, drive, collision, gravity, keepupright, bodygroups, physgunpickup, physgunpickupplayer"
  _str = _str .. ", adminaccess, interface, general, realistic, groupsandroles, players, money, licenses, shops, map, whitelist, feedback, usergroups"
  local _str2 = "'superadmin', 1, 1, 1, 1, 1, 1, 1, 1"
  _str2 = _str2 .. ", 1, 1, 1, 1, 1, 1, 1, 1, 1, 1"
  _str2 = _str2 .. ", 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1"
  SQL_INSERT_INTO( DATABASE_NAME, _str , _str2 )
end

if SQL_SELECT( DATABASE_NAME, "*", "name = 'yrp_usergroups'" ) == nil then
  local _str = "name, vehicles, weapons, entities, effects, npcs, props, ragdolls, noclip"
  _str = _str .. ", removetool, dynamitetool, ignite, drive, collision, gravity, keepupright, bodygroups, physgunpickup, physgunpickupplayer"
  _str = _str .. ", adminaccess, interface, general, realistic, groupsandroles, players, money, licenses, shops, map, whitelist, feedback, usergroups"
  _str = _str .. ", removeable"
  local _str2 = "'yrp_usergroups', 1, 1, 1, 1, 1, 1, 1, 1"
  _str2 = _str2 .. ", 1, 1, 1, 1, 1, 1, 1, 1, 1, 1"
  _str2 = _str2 .. ", 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1"
  _str2 = _str2 .. ", 0"
  SQL_INSERT_INTO( DATABASE_NAME, _str , _str2 )
end

--[[ Global Handler ]]--
local HANDLER_USERGROUPS = {}

function RemFromHandler_UserGroups( ply )
  table.RemoveByValue( HANDLER_USERGROUPS, ply )
  printGM( "gm", ply:YRPName() .. " disconnected from UserGroups" )
end

function AddToHandler_UserGroups( ply )
  if !table.HasValue( HANDLER_USERGROUPS, ply ) then
    table.insert( HANDLER_USERGROUPS, ply )
    printGM( "gm", ply:YRPName() .. " connected to UserGroups" )
  else
    printGM( "gm", ply:YRPName() .. " already connected to UserGroups" )
  end
end

util.AddNetworkString( "Disconnect_Settings_UserGroups" )
net.Receive( "Disconnect_Settings_UserGroups", function( len, ply )
  RemFromHandler_UserGroups( ply )
end)

util.AddNetworkString( "Connect_Settings_UserGroups" )
net.Receive( "Connect_Settings_UserGroups", function( len, ply )
  printGM( "gm", "Connect_Settings_UserGroups => " .. ply:YRPName() )
  if ply:CanAccess( "usergroups" ) then
    AddToHandler_UserGroups( ply )
    local _usergroups = {}
    for k, v in pairs( player.GetAll() ) do
      local _ug = v:GetUserGroup()
      if SQL_SELECT( DATABASE_NAME, "*", "name = '" .. _ug .. "'" ) == nil then
        printGM( "note", "usergroup: " .. _ug .. " not found, adding to db" )
        SQL_INSERT_INTO( DATABASE_NAME, "name", "'" .. _ug .. "'" )
      end
    end

    local _tmp = SQL_SELECT( DATABASE_NAME, "*", nil )
    local _ugs = {}
    for i, ug in pairs( _tmp ) do
      _ugs[tonumber(ug.uniqueID)] = ug
    end
    net.Start( "Connect_Settings_UserGroups" )
      if _tmp != nil then
        net.WriteTable( _tmp )
      else
        net.WriteTable( {} )
      end
    net.Send( ply )
  end
end)

--[[ Usergroup Handler ]]--
local HANDLER_USERGROUP = {}

function RemFromHandler_UserGroup( ply, uid )
  table.RemoveByValue( HANDLER_USERGROUP[uid], ply )
  printGM( "gm", ply:YRPName() .. " disconnected from UserGroup ( " .. uid .. " )" )
end

function AddToHandler_UserGroup( ply, uid )
  HANDLER_USERGROUP[uid] = HANDLER_USERGROUP[uid] or {}
  if !table.HasValue( HANDLER_USERGROUP[uid], ply ) then
    table.insert( HANDLER_USERGROUP[uid], ply )
    printGM( "gm", ply:YRPName() .. " connected to UserGroup ( " .. uid .. " )" )
  else
    printGM( "gm", ply:YRPName() .. " already connected to UserGroup ( " .. uid .. " )" )
  end
end

util.AddNetworkString( "Disconnect_Settings_UserGroup" )
net.Receive( "Disconnect_Settings_UserGroup", function( len, ply )
  local uid = tonumber( net.ReadString() )
  RemFromHandler_UserGroup( ply, uid )
end)

util.AddNetworkString( "Connect_Settings_UserGroup" )
net.Receive( "Connect_Settings_UserGroup", function( len, ply )
  local uid = tonumber( net.ReadString() )
  AddToHandler_UserGroup( ply, uid )

  local _tmp = SQL_SELECT( DATABASE_NAME, "*", "uniqueID = " .. uid )
  if wk( _tmp ) then
    _tmp = _tmp[1]
  end

  net.Start( "Connect_Settings_UserGroup" )
    if _tmp != nil then
      net.WriteTable( _tmp )
    else
      net.WriteTable( {} )
    end
  net.Send( ply )
end)

util.AddNetworkString( "usergroup_add" )
net.Receive( "usergroup_add", function( len, ply )
  SQL_INSERT_INTO_DEFAULTVALUES( DATABASE_NAME )
  printGM( "gm", ply:YRPName() .. " added a new UserGroup" )

  local _tmp = SQL_SELECT( DATABASE_NAME, "*", nil )
  local _ugs = {}
  for i, ug in pairs( _tmp ) do
    _ugs[tonumber(ug.uniqueID)] = ug
  end
  for i, pl in pairs( HANDLER_USERGROUPS ) do
    net.Start( "usergroup_add" )
      net.WriteTable( _ugs )
    net.Send( pl )
  end
end)

util.AddNetworkString( "usergroup_rem" )
net.Receive( "usergroup_rem", function( len, ply )
  local uid = tonumber( net.ReadString() )
  SQL_DELETE_FROM( DATABASE_NAME, "uniqueID = '" .. uid .. "'" )
  printGM( "gm", ply:YRPName() .. " removed UserGroup ( " .. uid .. " )" )

  for i, pl in pairs( HANDLER_USERGROUPS ) do
    net.Start( "usergroup_rem" )
      net.WriteString( uid )
    net.Send( pl )
  end
end)

--[[ Access Functions ]]--

local Player = FindMetaTable( "Player" )

function Player:NoAccess( site, usergroups )
  net.Start( "setting_hasnoaccess" )
    net.WriteString( site )
    net.WriteString( usergroups or "yrp_usergroups" )
  net.Send( self )
end

util.AddNetworkString( "setting_hasnoaccess" )
function Player:CanAccess( site )
  printGM( "note", "CanAccess( " .. site .. " )" )
  local _b = SQL_SELECT( DATABASE_NAME, site, "name = '" .. string.lower( self:GetUserGroup() ) .. "'" )
  local _ugs = SQL_SELECT( DATABASE_NAME, "name", "usergroups = '1'" )
  if wk( _b ) then
    _b = tobool( _b[1][site] )
    local usergroups = ""
    for i, ug in pairs( _ugs ) do
      if usergroups == "" then
        usergroups = usergroups .. ug.name
      else
        usergroups = usergroups .. ", " .. ug.name
      end
    end
    if !_b then
      self:NoAccess( site, usergroups )
    end
    return tobool( _b )
  end
  self:NoAccess( site )

  return false
end

--[[ Usergroup Edit ]]--
util.AddNetworkString( "usergroup_update_name" )
net.Receive( "usergroup_update_name", function( len, ply )
  local uid = tonumber( net.ReadString() )
  local name = string.lower( net.ReadString() )
  SQL_UPDATE( DATABASE_NAME, "name = '" .. name .. "'", "uniqueID = '" .. uid .. "'" )

  printGM( "db", ply:YRPName() .. " updated name of usergroup ( " .. uid .. " ) to [" .. name .. "]" )

  for i, pl in pairs( HANDLER_USERGROUP[uid] ) do
    if pl != ply then
      net.Start( "usergroup_update_name" )
        net.WriteString( name )
      net.Send( pl )
    end
  end
end)

util.AddNetworkString( "usergroup_update_color" )
net.Receive( "usergroup_update_color", function( len, ply )
  local uid = tonumber( net.ReadString() )
  local color = net.ReadString()
  SQL_UPDATE( DATABASE_NAME, "color = '" .. color .. "'", "uniqueID = '" .. uid .. "'" )

  printGM( "db", ply:YRPName() .. " updated color of usergroup ( " .. uid .. " ) to [" .. color .. "]" )

  for i, pl in pairs( HANDLER_USERGROUP[uid] ) do
    if pl != ply then
      net.Start( "usergroup_update_color" )
        net.WriteString( color )
      net.Send( pl )
    end
  end
end)

util.AddNetworkString( "usergroup_update_icon" )
net.Receive( "usergroup_update_icon", function( len, ply )
  local uid = tonumber( net.ReadString() )
  local icon = net.ReadString()
  SQL_UPDATE( DATABASE_NAME, "icon = '" .. icon .. "'", "uniqueID = '" .. uid .. "'" )

  printGM( "db", ply:YRPName() .. " updated icon of usergroup ( " .. uid .. " ) to [" .. icon .. "]" )

  for i, pl in pairs( HANDLER_USERGROUP[uid] ) do
    if pl != ply then
      net.Start( "usergroup_update_icon" )
        net.WriteString( icon )
      net.Send( pl )
    end
  end
end)

util.AddNetworkString( "usergroup_update_sweps" )
net.Receive( "usergroup_update_sweps", function( len, ply )
  local uid = tonumber( net.ReadString() )
  local sweps = net.ReadString()
  SQL_UPDATE( DATABASE_NAME, "sweps = '" .. sweps .. "'", "uniqueID = '" .. uid .. "'" )

  printGM( "db", ply:YRPName() .. " updated sweps of usergroup ( " .. uid .. " ) to [" .. sweps .. "]" )

  for i, pl in pairs( HANDLER_USERGROUP[uid] ) do
    net.Start( "usergroup_update_sweps" )
      net.WriteString( sweps )
    net.Send( pl )
  end
end)

util.AddNetworkString( "usergroup_update_entities" )
net.Receive( "usergroup_update_entities", function( len, ply )
  local uid = tonumber( net.ReadString() )
  local entities = net.ReadString()
  SQL_UPDATE( DATABASE_NAME, "entities = '" .. entities .. "'", "uniqueID = '" .. uid .. "'" )

  printGM( "db", ply:YRPName() .. " updated entities of usergroup ( " .. uid .. " ) to [" .. entities .. "]" )

  for i, pl in pairs( HANDLER_USERGROUP[uid] ) do
    net.Start( "usergroup_update_entities" )
      net.WriteString( entities )
    net.Send( pl )
  end
end)

function AddSENTToSENTS( tbl, sent )
  local tmp = string.Explode( ",", sent )
  tbl[tmp[2]] = tmp[1]
  return tbl
end

function RemSENTFromSENTS( tbl, sent )
  tbl[sent] = nil
  return tbl
end

util.AddNetworkString( "usergroup_add_sent" )
net.Receive( "usergroup_add_sent", function( len, ply )
  local uid = tonumber( net.ReadString() )
  local sent = "1," .. net.ReadString()

  local sents = SQL_SELECT( DATABASE_NAME, "sents", "uniqueID = '" .. uid .. "'" )
  if wk( sents ) then
    sents = sents[1].sents
  else
    sents = ""
  end

  sents = SENTSTable( sents )
  sents = AddSENTToSENTS( sents, sent )
  sents = SENTSString( sents )

  SQL_UPDATE( DATABASE_NAME, "sents = '" .. sents .. "'", "uniqueID = '" .. uid .. "'" )

  printGM( "db", ply:YRPName() .. " added sent [ " .. sent .. " ] for usergroup ( " .. uid .. " )" )

  for i, pl in pairs( HANDLER_USERGROUP[uid] ) do
    net.Start( "usergroup_add_sent" )
      net.WriteString( sents )
    net.Send( pl )
  end
end)

util.AddNetworkString( "usergroup_rem_sent" )
net.Receive( "usergroup_rem_sent", function( len, ply )
  local uid = tonumber( net.ReadString() )
  local sent = net.ReadString()

  local sents = SQL_SELECT( DATABASE_NAME, "sents", "uniqueID = '" .. uid .. "'" )
  if wk( sents ) then
    sents = sents[1].sents
  else
    sents = ""
  end

  sents = SENTSTable( sents )
  sents = RemSENTFromSENTS( sents, sent )
  sents = SENTSString( sents )

  SQL_UPDATE( DATABASE_NAME, "sents = '" .. sents .. "'", "uniqueID = '" .. uid .. "'" )

  printGM( "db", ply:YRPName() .. " removed sent [ " .. sent .. " ] for usergroup ( " .. uid .. " )" )

  for i, pl in pairs( HANDLER_USERGROUP[uid] ) do
    net.Start( "usergroup_rem_sent" )
      net.WriteString( sent )
    net.Send( pl )
  end
end)

util.AddNetworkString( "usergroup_sent_up" )
net.Receive( "usergroup_sent_up", function( len, ply )
  local uid = tonumber( net.ReadString() )
  local sent = net.ReadString()

  local sents = SQL_SELECT( DATABASE_NAME, "sents", "uniqueID = '" .. uid .. "'" )
  if wk( sents ) then
    sents = sents[1].sents
  else
    sents = ""
  end

  sents = SENTSTable( sents )
  sents[sent] = tonumber( sents[sent] ) + 1
  sents = SENTSString( sents )

  SQL_UPDATE( DATABASE_NAME, "sents = '" .. sents .. "'", "uniqueID = '" .. uid .. "'" )

  for i, pl in pairs( HANDLER_USERGROUP[uid] ) do
    net.Start( "usergroup_sent_up" )
      net.WriteString( sents )
    net.Send( pl )
  end
end)

util.AddNetworkString( "usergroup_sent_dn" )
net.Receive( "usergroup_sent_dn", function( len, ply )
  local uid = tonumber( net.ReadString() )
  local sent = net.ReadString()

  local sents = SQL_SELECT( DATABASE_NAME, "sents", "uniqueID = '" .. uid .. "'" )
  if wk( sents ) then
    sents = sents[1].sents
  else
    sents = ""
  end

  sents = SENTSTable( sents )
  sents[sent] = tonumber( sents[sent] ) - 1
  sents = SENTSString( sents )

  SQL_UPDATE( DATABASE_NAME, "sents = '" .. sents .. "'", "uniqueID = '" .. uid .. "'" )

  for i, pl in pairs( HANDLER_USERGROUP[uid] ) do
    net.Start( "usergroup_sent_dn" )
      net.WriteString( sents )
    net.Send( pl )
  end
end)

function UGCheckBox( ply, uid, name, value )
  SQL_UPDATE( DATABASE_NAME, name .. " = '" .. value .. "'", "uniqueID = '" .. uid .. "'" )

  printGM( "db", ply:YRPName() .. " updated " .. name .. " of usergroup ( " .. uid .. " ) to [" .. value .. "]" )

  for i, pl in pairs( HANDLER_USERGROUP[uid] ) do
    net.Start( "usergroup_update_" .. name )
      net.WriteString( value )
    net.Send( pl )
  end
end

util.AddNetworkString( "usergroup_update_adminaccess" )
net.Receive( "usergroup_update_adminaccess", function( len, ply )
  local uid = tonumber( net.ReadString() )
  local adminaccess = net.ReadString()
  UGCheckBox( ply, uid, "adminaccess", adminaccess )
end)

util.AddNetworkString( "usergroup_update_general" )
net.Receive( "usergroup_update_general", function( len, ply )
  local uid = tonumber( net.ReadString() )
  local general = net.ReadString()
  UGCheckBox( ply, uid, "general", general )
end)

util.AddNetworkString( "usergroup_update_interface" )
net.Receive( "usergroup_update_interface", function( len, ply )
  local uid = tonumber( net.ReadString() )
  local interface = net.ReadString()
  UGCheckBox( ply, uid, "interface", interface )
end)

util.AddNetworkString( "usergroup_update_realistic" )
net.Receive( "usergroup_update_realistic", function( len, ply )
  local uid = tonumber( net.ReadString() )
  local realistic = net.ReadString()
  UGCheckBox( ply, uid, "realistic", realistic )
end)

util.AddNetworkString( "usergroup_update_money" )
net.Receive( "usergroup_update_money", function( len, ply )
  local uid = tonumber( net.ReadString() )
  local money = net.ReadString()
  UGCheckBox( ply, uid, "money", money )
end)

util.AddNetworkString( "usergroup_update_licenses" )
net.Receive( "usergroup_update_licenses", function( len, ply )
  local uid = tonumber( net.ReadString() )
  local licenses = net.ReadString()
  UGCheckBox( ply, uid, "licenses", licenses )
end)

util.AddNetworkString( "usergroup_update_shops" )
net.Receive( "usergroup_update_shops", function( len, ply )
  local uid = tonumber( net.ReadString() )
  local shops = net.ReadString()
  UGCheckBox( ply, uid, "shops", shops )
end)

util.AddNetworkString( "usergroup_update_map" )
net.Receive( "usergroup_update_map", function( len, ply )
  local uid = tonumber( net.ReadString() )
  local map = net.ReadString()
  UGCheckBox( ply, uid, "map", map )
end)

util.AddNetworkString( "usergroup_update_feedback" )
net.Receive( "usergroup_update_feedback", function( len, ply )
  local uid = tonumber( net.ReadString() )
  local feedback = net.ReadString()
  UGCheckBox( ply, uid, "feedback", feedback )
end)

util.AddNetworkString( "usergroup_update_feedback" )
net.Receive( "usergroup_update_feedback", function( len, ply )
  local uid = tonumber( net.ReadString() )
  local feedback = net.ReadString()
  UGCheckBox( ply, uid, "feedback", feedback )
end)

util.AddNetworkString( "usergroup_update_usergroups" )
net.Receive( "usergroup_update_usergroups", function( len, ply )
  local uid = tonumber( net.ReadString() )
  local usergroups = net.ReadString()
  UGCheckBox( ply, uid, "usergroups", usergroups )
end)

util.AddNetworkString( "usergroup_update_groupsandroles" )
net.Receive( "usergroup_update_groupsandroles", function( len, ply )
  local uid = tonumber( net.ReadString() )
  local groupsandroles = net.ReadString()
  UGCheckBox( ply, uid, "groupsandroles", groupsandroles )
end)

util.AddNetworkString( "usergroup_update_players" )
net.Receive( "usergroup_update_players", function( len, ply )
  local uid = tonumber( net.ReadString() )
  local players = net.ReadString()
  UGCheckBox( ply, uid, "players", players )
end)

util.AddNetworkString( "usergroup_update_vehicles" )
net.Receive( "usergroup_update_vehicles", function( len, ply )
  local uid = tonumber( net.ReadString() )
  local vehicles = net.ReadString()
  UGCheckBox( ply, uid, "vehicles", vehicles )
end)

util.AddNetworkString( "usergroup_update_weapons" )
net.Receive( "usergroup_update_weapons", function( len, ply )
  local uid = tonumber( net.ReadString() )
  local weapons = net.ReadString()
  UGCheckBox( ply, uid, "weapons", weapons )
end)

util.AddNetworkString( "usergroup_update_entities" )
net.Receive( "usergroup_update_entities", function( len, ply )
  local uid = tonumber( net.ReadString() )
  local entities = net.ReadString()
  UGCheckBox( ply, uid, "entities", entities )
end)

util.AddNetworkString( "usergroup_update_effects" )
net.Receive( "usergroup_update_effects", function( len, ply )
  local uid = tonumber( net.ReadString() )
  local effects = net.ReadString()
  UGCheckBox( ply, uid, "effects", effects )
end)

util.AddNetworkString( "usergroup_update_npcs" )
net.Receive( "usergroup_update_npcs", function( len, ply )
  local uid = tonumber( net.ReadString() )
  local npcs = net.ReadString()
  UGCheckBox( ply, uid, "npcs", npcs )
end)

util.AddNetworkString( "usergroup_update_props" )
net.Receive( "usergroup_update_props", function( len, ply )
  local uid = tonumber( net.ReadString() )
  local props = net.ReadString()
  UGCheckBox( ply, uid, "props", props )
end)

util.AddNetworkString( "usergroup_update_ragdolls" )
net.Receive( "usergroup_update_ragdolls", function( len, ply )
  local uid = tonumber( net.ReadString() )
  local ragdolls = net.ReadString()
  UGCheckBox( ply, uid, "ragdolls", ragdolls )
end)

util.AddNetworkString( "usergroup_update_noclip" )
net.Receive( "usergroup_update_noclip", function( len, ply )
  local uid = tonumber( net.ReadString() )
  local noclip = net.ReadString()
  UGCheckBox( ply, uid, "noclip", noclip )
end)

util.AddNetworkString( "usergroup_update_removetool" )
net.Receive( "usergroup_update_removetool", function( len, ply )
  local uid = tonumber( net.ReadString() )
  local removetool = net.ReadString()
  UGCheckBox( ply, uid, "removetool", removetool )
end)

util.AddNetworkString( "usergroup_update_dynamitetool" )
net.Receive( "usergroup_update_dynamitetool", function( len, ply )
  local uid = tonumber( net.ReadString() )
  local dynamitetool = net.ReadString()
  UGCheckBox( ply, uid, "dynamitetool", dynamitetool )
end)

util.AddNetworkString( "usergroup_update_ignite" )
net.Receive( "usergroup_update_ignite", function( len, ply )
  local uid = tonumber( net.ReadString() )
  local ignite = net.ReadString()
  UGCheckBox( ply, uid, "ignite", ignite )
end)

util.AddNetworkString( "usergroup_update_drive" )
net.Receive( "usergroup_update_drive", function( len, ply )
  local uid = tonumber( net.ReadString() )
  local drive = net.ReadString()
  UGCheckBox( ply, uid, "drive", drive )
end)

util.AddNetworkString( "usergroup_update_collision" )
net.Receive( "usergroup_update_collision", function( len, ply )
  local uid = tonumber( net.ReadString() )
  local collision = net.ReadString()
  UGCheckBox( ply, uid, "collision", collision )
end)

util.AddNetworkString( "usergroup_update_gravity" )
net.Receive( "usergroup_update_gravity", function( len, ply )
  local uid = tonumber( net.ReadString() )
  local gravity = net.ReadString()
  UGCheckBox( ply, uid, "gravity", gravity )
end)

util.AddNetworkString( "usergroup_update_keepupright" )
net.Receive( "usergroup_update_keepupright", function( len, ply )
  local uid = tonumber( net.ReadString() )
  local keepupright = net.ReadString()
  UGCheckBox( ply, uid, "keepupright", keepupright )
end)

util.AddNetworkString( "usergroup_update_bodygroups" )
net.Receive( "usergroup_update_bodygroups", function( len, ply )
  local uid = tonumber( net.ReadString() )
  local bodygroups = net.ReadString()
  UGCheckBox( ply, uid, "bodygroups", bodygroups )
end)

util.AddNetworkString( "usergroup_update_physgunpickup" )
net.Receive( "usergroup_update_physgunpickup", function( len, ply )
  local uid = tonumber( net.ReadString() )
  local physgunpickup = net.ReadString()
  UGCheckBox( ply, uid, "physgunpickup", physgunpickup )
end)

util.AddNetworkString( "usergroup_update_physgunpickupplayer" )
net.Receive( "usergroup_update_physgunpickupplayer", function( len, ply )
  local uid = tonumber( net.ReadString() )
  local physgunpickupplayer = net.ReadString()
  UGCheckBox( ply, uid, "physgunpickupplayer", physgunpickupplayer )
end)

--[[ Functions ]]--

hook.Add( "PlayerSpawnVehicle", "yrp_vehicles_restriction", function( pl, model, name, table )
  if ea( pl ) then
    local _tmp = SQL_SELECT( DATABASE_NAME, "vehicles", "name = '" .. string.lower( pl:GetUserGroup() ) .. "'" )
    if worked( _tmp, "PlayerSpawnVehicle failed" ) then
      _tmp = _tmp[1]
      if tobool( _tmp.vehicles ) then
        return true
      else
        printGM( "note", pl:Nick() .. " [" .. string.lower( pl:GetUserGroup() ) .. "] tried to spawn a vehicle." )

        net.Start( "yrp_info" )
          net.WriteString( "vehicles" )
        net.Send( pl )

        return false
      end
    end
  end
end)

hook.Add( "PlayerGiveSWEP", "yrp_weapons_restriction", function( pl )
  if ea( pl ) then
    local _tmp = SQL_SELECT( DATABASE_NAME, "weapons", "name = '" .. string.lower( pl:GetUserGroup() ) .. "'" )
    if worked( _tmp, "PlayerGiveSWEP failed" ) then
      _tmp = _tmp[1]
      if tobool( _tmp.weapons ) then
        return true
      else
        printGM( "note", pl:Nick() .. " [" .. string.lower( pl:GetUserGroup() ) .. "] tried to spawn a weapon." )

        net.Start( "yrp_info" )
          net.WriteString( "weapon" )
        net.Send( pl )

        return false
      end
    end
  end
end)

hook.Add( "PlayerSpawnSENT", "yrp_entities_restriction", function( pl )
  if ea( pl ) then
    local _tmp = SQL_SELECT( DATABASE_NAME, "entities", "name = '" .. string.lower( pl:GetUserGroup() ) .. "'" )
    if worked( _tmp, "PlayerSpawnSENT failed" ) then
      _tmp = _tmp[1]
      if tobool( _tmp.entities ) then
        return true
      else
        printGM( "note", pl:Nick() .. " [" .. string.lower( pl:GetUserGroup() ) .. "] tried to spawn an entity." )

        net.Start( "yrp_info" )
          net.WriteString( "entities" )
        net.Send( pl )

        return false
      end
    end
  end
end)

hook.Add( "PlayerSpawnEffect", "yrp_effects_restriction", function( pl )
  if ea( pl ) then
    local _tmp = SQL_SELECT( DATABASE_NAME, "effects", "name = '" .. string.lower( pl:GetUserGroup() ) .. "'" )
    if worked( _tmp, "PlayerSpawnEffect failed" ) then
      _tmp = _tmp[1]
      if tobool( _tmp.effects ) then
        return true
      else
        printGM( "note", pl:Nick() .. " [" .. string.lower( pl:GetUserGroup() ) .. "] tried to spawn an effect." )

        net.Start( "yrp_info" )
          net.WriteString( "effects" )
        net.Send( pl )

        return false
      end
    end
  end
end)

hook.Add( "PlayerSpawnNPC", "yrp_npcs_restriction", function( pl )
  if ea( pl ) then
    local _tmp = SQL_SELECT( DATABASE_NAME, "npcs", "name = '" .. string.lower( pl:GetUserGroup() ) .. "'" )
    if worked( _tmp, "PlayerSpawnNPC failed" ) then
      _tmp = _tmp[1]
      if tobool( _tmp.npcs ) then
        return true
      else
        printGM( "note", pl:Nick() .. " [" .. string.lower( pl:GetUserGroup() ) .. "] tried to spawn a npc." )

        net.Start( "yrp_info" )
          net.WriteString( "npcs" )
        net.Send( pl )

        return false
      end
    end
  end
end)

hook.Add( "PlayerSpawnProp", "yrp_props_restriction", function( pl )
  if ea( pl ) then
    local _tmp = SQL_SELECT( DATABASE_NAME, "props", "name = '" .. string.lower( pl:GetUserGroup() ) .. "'" )
    if worked( _tmp, "PlayerSpawnProp failed" ) then
      _tmp = _tmp[1]
      if tobool( _tmp.props ) then
        return true
      else
        printGM( "note", pl:Nick() .. " [" .. string.lower( pl:GetUserGroup() ) .. "] tried to spawn a prop." )

        net.Start( "yrp_info" )
          net.WriteString( "props" )
        net.Send( pl )

        return false
      end
    end
  end
end)

hook.Add( "PlayerSpawnRagdoll", "yrp_ragdolls_restriction", function( pl, model )
  if ea( pl ) then
    local _tmp = SQL_SELECT( DATABASE_NAME, "ragdolls", "name = '" .. tostring( string.lower( pl:GetUserGroup() ) ) .. "'" )
    if wk( _tmp ) then
      _tmp = _tmp[1]
      if tobool( _tmp.ragdolls ) then
        return true
      else
        printGM( "note", pl:Nick() .. " [" .. string.lower( pl:GetUserGroup() ) .. "] tried to spawn a ragdoll." )

        net.Start( "yrp_info" )
          net.WriteString( "ragdolls" )
        net.Send( pl )

        return false
      end
    else
      printGM( "db", "[PlayerSpawnRagdoll] failed! UserGroup not found in database." )
    end
  end
end)

function RenderEquipment( ply, name, mode, color )
  local _eq = ply:GetNWEntity( name )
  if ea( _eq ) then
    _eq:SetRenderMode( mode )
    _eq:SetColor( color )
    _eq:SetNWInt( name .. "mode", mode )
    _eq:SetNWString( name .. "color", color.r .. "," .. color.g .. "," .. color.b .. "," .. color.a )
  end
end

function RenderEquipments( ply, mode, color )
  RenderEquipment( ply, "backpack", mode, color )

  RenderEquipment( ply, "weaponprimary1", mode, color )
  RenderEquipment( ply, "weaponprimary2", mode, color )
  RenderEquipment( ply, "weaponsecondary1", mode, color )
  RenderEquipment( ply, "weaponsecondary2", mode, color )
  RenderEquipment( ply, "weapongadget", mode, color )
end

function RenderCloaked( ply )
  if ea( ply ) then
    local _alpha = 0
    ply:SetRenderMode( RENDERMODE_TRANSALPHA )
    ply:SetColor( Color( 255, 255, 255, _alpha ) )
    for i, wp in pairs(ply:GetWeapons()) do
      wp:SetRenderMode( RENDERMODE_TRANSALPHA )
      wp:SetColor( Color( 255, 255, 255, _alpha ) )
    end
    RenderEquipments( ply, RENDERMODE_TRANSALPHA, Color( 255, 255, 255, _alpha ) )
  end
end

function RenderNoClip( ply, alpha )
  if ea( ply ) then
    if ply:GetNWBool( "cloaked", false ) then
      RenderCloaked( ply )
    else
      local _alpha = 255
      if IsNoClipEffectEnabled() then
        if IsNoClipStealthEnabled() then
          _alpha = 0
        else
          _alpha = 180
        end
      end

      ply:SetRenderMode( RENDERMODE_TRANSALPHA )
      ply:SetColor( Color( 255, 255, 255, _alpha ) )
      for i, wp in pairs(ply:GetWeapons()) do
        wp:SetRenderMode( RENDERMODE_TRANSALPHA )
        wp:SetColor( Color( 255, 255, 255, _alpha ) )
      end
      RenderEquipments( ply, RENDERMODE_TRANSALPHA, Color( 255, 255, 255, _alpha ) )
    end
  end
end

function RenderFrozen( ply )
  if ea( ply ) then
    if ply:GetNWBool( "cloaked", false ) then
      RenderCloaked( ply )
    else
      ply:SetRenderMode( RENDERMODE_NORMAL )
      ply:SetColor( Color( 0, 0, 255 ) )
      for i, wp in pairs(ply:GetWeapons()) do
        wp:SetRenderMode( RENDERMODE_TRANSALPHA )
        wp:SetColor( Color( 0, 0, 255 ) )
      end
      RenderEquipments( ply, RENDERMODE_TRANSALPHA, Color( 0, 0, 255 ) )
    end
  end
end

function RenderNormal( ply )
  if ea( ply ) then
    if ply:GetNWBool( "cloaked", false ) then
      RenderCloaked( ply )
    elseif ply:IsFlagSet( FL_FROZEN ) then
      RenderFrozen( ply )
    else
      setPlayerModel( ply )
      ply:SetRenderMode( RENDERMODE_NORMAL )
      ply:SetColor( Color( 255, 255, 255, 255 ) )
      for i, wp in pairs(ply:GetWeapons()) do
        wp:SetRenderMode( RENDERMODE_NORMAL )
        wp:SetColor( Color( 255, 255, 255, 255 ) )
      end
      RenderEquipments( ply, RENDERMODE_NORMAL, Color( 255, 255, 255, 255 ) )
    end
  end
end

hook.Add( "PlayerNoClip", "yrp_noclip_restriction", function( pl, bool )
  if ea( pl ) then
    if !bool then
      -- TURNED OFF
      RenderNormal( pl )

      local _pos = pl:GetPos()

      -- Stuck?
      local tr = {
        start = _pos,
        endpos = _pos,
        mins = pl:OBBMins(),
        maxs = pl:OBBMaxs(),
        filter = pl
      }
      local _t = util.TraceHull( tr )

      if _t.Hit then
        -- Up
        local trup = {
          start = _pos+Vector(0,0,100),
          endpos = _pos,
          mins = Vector(1,1,0),
          maxs = Vector(-1,-1,0),
          filter = pl
        }
        local _tup = util.TraceHull( trup )

        -- Down
        local trdn = {
          start = _pos,
          endpos = _pos+Vector(0,0,100),
          mins = Vector(1,1,0),
          maxs = Vector(-1,-1,0),
          filter = pl
        }
        local _tdn = util.TraceHull( trdn )

        timer.Simple( 0.001, function()
          if !_tup.StartSolid and _tdn.StartSolid then
            pl:SetPos( _tup.HitPos + Vector( 0, 0, 1 ) )
          elseif _tup.StartSolid and !_tdn.StartSolid then
            pl:SetPos( _tdn.HitPos - Vector( 0, 0, 72+1 ) )
          elseif !_tup.StartSolid and !_tdn.StartSolid then
            _pos = _pos + Vector( 0, 0, 36 )
            if _pos:Distance( _tup.HitPos ) < _pos:Distance( _tdn.HitPos ) then
              pl:SetPos( _tup.HitPos + Vector( 0, 0, 1 ) )
            elseif _pos:Distance( _tup.HitPos ) > _pos:Distance( _tdn.HitPos ) then
              pl:SetPos( _tdn.HitPos - Vector( 0, 0, 72+6 ) )
            end
          end
        end)
      end
    else
      -- TURNED ON
      local _tmp = SQL_SELECT( DATABASE_NAME, "noclip", "name = '" .. string.lower( pl:GetUserGroup() ) .. "'" )
      if wk( _tmp ) then
        _tmp = _tmp[1]
        if tobool( _tmp.noclip ) then

          if IsNoClipModelEnabled() then
            local mdl = pl:GetNWString( "text_noclip_mdl", "" )
            if mdl != "" then
              pl:SetModel( mdl )
            end
          end

          RenderNoClip( pl )
          return true
        else
          printGM( "note", pl:Nick() .. " [" .. string.lower( pl:GetUserGroup() ) .. "] tried to noclip." )

          net.Start( "yrp_info" )
            net.WriteString( "noclip" )
          net.Send( pl )

          return false
        end
      else
        printGM( "db", "[noclip] failed! UserGroup not found in database." )
      end
    end
  end
end)

hook.Add( "PhysgunPickup", "yrp_physgun_pickup", function( pl, ent )
  if ea( pl ) then
    printGM( "gm", "PhysgunPickup: " .. pl:YRPName() )
    local _tmp = SQL_SELECT( DATABASE_NAME, "physgunpickup", "name = '" .. string.lower( pl:GetUserGroup() ) .. "'" )
    if wk( _tmp ) then
      _tmp = _tmp[1]
      if tobool( _tmp.physgunpickup ) then
        if ent:IsPlayer() then
          local _tmp2 = SQL_SELECT( DATABASE_NAME, "physgunpickupplayer", "name = '" .. string.lower( pl:GetUserGroup() ) .. "'" )
          if wk( _tmp2 ) then
            _tmp2 = _tmp2[1]
            if tobool( _tmp2.physgunpickupplayer ) then
              return true
            else
              net.Start( "yrp_info" )
                net.WriteString( "physgunpickupplayer" )
              net.Send( pl )
              return false
            end
          else
            return false
          end
        else
          return true
        end
      else
        net.Start( "yrp_info" )
          net.WriteString( "physgunpickup" )
        net.Send( pl )
        return false
      end
    else
      printGM( "db", "[PhysgunPickup] failed! UserGroup not found in database." )
      return false
    end
  end
end)

hook.Add( "CanTool", "yrp_can_tool", function( pl, tr, tool )
  if ea( pl ) then
    printGM( "gm", "CanTool: " .. tool )
    if tool == "remover" then
      local _tmp = SQL_SELECT( DATABASE_NAME, "removetool", "name = '" .. string.lower( pl:GetUserGroup() ) .. "'" )
      if _tmp != nil and _tmp != false then
        _tmp = _tmp[1]
        if tobool( _tmp.removetool ) then
          return true
        else
          net.Start( "yrp_info" )
            net.WriteString( "removetool" )
          net.Send( pl )
          return false
        end
      else
        printGM( "db", "[remover] failed! UserGroup not found in database." )
        return false
      end
    elseif tool == "dynamite" then
      local _tmp = SQL_SELECT( DATABASE_NAME, "dynamitetool", "name = '" .. string.lower( pl:GetUserGroup() ) .. "'" )
      if _tmp != nil and _tmp != false then
        _tmp = _tmp[1]
        if tobool( _tmp.dynamitetool ) then
          return true
        else
          net.Start( "yrp_info" )
            net.WriteString( "dynamitetool" )
          net.Send( pl )
          return false
        end
      else
        printGM( "db", "[dynamite] failed! UserGroup not found in database." )
        return false
      end
    end
  end
end)

hook.Add( "CanProperty", "yrp_canproperty", function( pl, property, ent )
  if ea( pl ) then
    printGM( "gm", "CanProperty: " .. property )
    if property == "ignite" then
      local _tmp = SQL_SELECT( DATABASE_NAME, "ignite", "name = '" .. string.lower( pl:GetUserGroup() ) .. "'" )
      if _tmp != nil and _tmp != false then
        _tmp = _tmp[1]
        if tobool( _tmp.ignite ) then
          return true
        else
          net.Start( "yrp_info" )
            net.WriteString( "ignite" )
          net.Send( pl )
          return false
        end
      else
        printGM( "db", "[ignite] failed! UserGroup not found in database." )
        return false
      end
    elseif property == "remover" then
      local _tmp = SQL_SELECT( DATABASE_NAME, "removetool", "name = '" .. string.lower( pl:GetUserGroup() ) .. "'" )
      if _tmp != nil and _tmp != false then
        _tmp = _tmp[1]
        if tobool( _tmp.removetool ) then
          return true
        else
          net.Start( "yrp_info" )
            net.WriteString( "removetool" )
          net.Send( pl )
          return false
        end
      else
        printGM( "db", "[remover] failed! UserGroup not found in database." )
        return false
      end
    elseif property == "drive" then
      local _tmp = SQL_SELECT( DATABASE_NAME, "drive", "name = '" .. string.lower( pl:GetUserGroup() ) .. "'" )
      if _tmp != nil and _tmp != false then
        _tmp = _tmp[1]
        if tobool( _tmp.drive ) then
          return true
        else
          net.Start( "yrp_info" )
            net.WriteString( "drive" )
          net.Send( pl )
          return false
        end
      else
        printGM( "db", "[drive] failed! UserGroup not found in database." )
        return false
      end
    elseif property == "collision" then
      local _tmp = SQL_SELECT( DATABASE_NAME, "collision", "name = '" .. string.lower( pl:GetUserGroup() ) .. "'" )
      if _tmp != nil and _tmp != false then
        _tmp = _tmp[1]
        if tobool( _tmp.collision ) then
          return true
        else
          net.Start( "yrp_info" )
            net.WriteString( "collision" )
          net.Send( pl )
          return false
        end
      else
        printGM( "db", "[collision] failed! UserGroup not found in database." )
        return false
      end
    elseif property == "keepupright" then
      local _tmp = SQL_SELECT( DATABASE_NAME, "keepupright", "name = '" .. string.lower( pl:GetUserGroup() ) .. "'" )
      if _tmp != nil and _tmp != false then
        _tmp = _tmp[1]
        if tobool( _tmp.keepupright ) then
          return true
        else
          net.Start( "yrp_info" )
            net.WriteString( "keepupright" )
          net.Send( pl )
          return false
        end
      else
        printGM( "db", "[keepupright] failed! UserGroup not found in database." )
        return false
      end
    elseif property == "bodygroups" then
      local _tmp = SQL_SELECT( DATABASE_NAME, "bodygroups", "name = '" .. string.lower( pl:GetUserGroup() ) .. "'" )
      if _tmp != nil and _tmp != false then
        _tmp = _tmp[1]
        if tobool( _tmp.bodygroups ) then
          return true
        else
          net.Start( "yrp_info" )
            net.WriteString( "bodygroups" )
          net.Send( pl )
          return false
        end
      else
        printGM( "db", "[bodygroups] failed! UserGroup not found in database." )
        return false
      end
    elseif property == "gravity" then
      local _tmp = SQL_SELECT( DATABASE_NAME, "gravity", "name = '" .. string.lower( pl:GetUserGroup() ) .. "'" )
      if _tmp != nil and _tmp != false then
        _tmp = _tmp[1]
        if tobool( _tmp.gravity ) then
          return true
        else
          net.Start( "yrp_info" )
            net.WriteString( "gravity" )
          net.Send( pl )
          return false
        end
      else
        printGM( "db", "[gravity] failed! UserGroup not found in database." )
        return false
      end
    elseif property == "persist" then
      if pl:HasAccess() then
        return true
      else
        net.Start( "yrp_info" )
          net.WriteString( "persist" )
        net.Send( pl )
        return false
      end
    end
  end
end)

local Player = FindMetaTable( "Player" )
function Player:UserGroupLoadout()
  printGM( "gm", self:SteamName() .. " UserGroupLoadout" )
  local UG = SQL_SELECT( DATABASE_NAME, "*", "name = '" .. self:GetUserGroup() .. "'" )
  if wk( UG ) then
    UG = UG[1]
    self:SetNWString( "usergroup_sweps", UG.sweps )
    local SWEPS = string.Explode( ",", UG.sweps )
    for i, swep in pairs( SWEPS ) do
      self:Give( swep )
    end
    self:SetNWBool( "adminaccess", tobool( UG.adminaccess ) )
  end
end

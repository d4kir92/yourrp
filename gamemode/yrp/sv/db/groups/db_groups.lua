--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

-- DO NOT TOUCH THE DATABASE FILES! If you have errors, report them here:
-- https://discord.gg/sEgNZxg

--[[
local DATABASE_NAME = "yrp_ply_groups"

SQL_ADD_COLUMN( DATABASE_NAME, "string_name", "TEXT DEFAULT 'GroupName'" )
SQL_ADD_COLUMN( DATABASE_NAME, "string_color", "TEXT DEFAULT '0,0,0'" )
SQL_ADD_COLUMN( DATABASE_NAME, "string_requireusergroup", "TEXT DEFAULT 'all'" )
SQL_ADD_COLUMN( DATABASE_NAME, "string_icon", "TEXT DEFAULT ''" )
SQL_ADD_COLUMN( DATABASE_NAME, "string_sweps", "TEXT DEFAULT ''" )
SQL_ADD_COLUMN( DATABASE_NAME, "string_ents", "TEXT DEFAULT ''" )

SQL_ADD_COLUMN( DATABASE_NAME, "int_parentgroup", "INTEGER DEFAULT 0" )
SQL_ADD_COLUMN( DATABASE_NAME, "int_requirelevel", "INTEGER DEFAULT 1" )
SQL_ADD_COLUMN( DATABASE_NAME, "int_position", "INTEGER DEFAULT 0" )
SQL_ADD_COLUMN( DATABASE_NAME, "int_up", "INTEGER DEFAULT 0" )
SQL_ADD_COLUMN( DATABASE_NAME, "int_dn", "INTEGER DEFAULT 0" )

SQL_ADD_COLUMN( DATABASE_NAME, "bool_whitelist", "INTEGER DEFAULT 0" )
SQL_ADD_COLUMN( DATABASE_NAME, "bool_groupvoicechat", "INTEGER DEFAULT 1" )
SQL_ADD_COLUMN( DATABASE_NAME, "bool_locked", "INTEGER DEFAULT 0" )

SQL_ADD_COLUMN( DATABASE_NAME, "bool_removeable", "INTEGER DEFAULT 1" )

if SQL_SELECT( DATABASE_NAME, "*", "uniqueID = 1" ) == nil then
	printGM( "note", DATABASE_NAME .. " has not the default group" )
	local _result = SQL_INSERT_INTO( DATABASE_NAME, "uniqueID, string_name, string_color, int_parentgroup, bool_removeable", "1, 'Civilians', '0,0,255', 0, 0" )
end

--db_drop_table( DATABASE_NAME )

local HANDLER_GROUPSANDROLES = {}
HANDLER_GROUPSANDROLES["groups"] = {}
HANDLER_GROUPSANDROLES["roles"] = {}

function RemFromHandler_GroupsAndRoles( ply )
	table.RemoveByValue( HANDLER_GROUPSANDROLES, ply )
	printGM( "gm", ply:YRPName() .. " disconnected from GroupsAndRoles" )
end

function AddToHandler_GroupsAndRoles( ply )
	if !table.HasValue( HANDLER_GROUPSANDROLES, ply ) then
		table.insert( HANDLER_GROUPSANDROLES, ply )
		printGM( "gm", ply:YRPName() .. " connected to GroupsAndRoles" )
	else
		printGM( "gm", ply:YRPName() .. " already connected to GroupsAndRoles" )
	end
end

function ConnectGroup(ply, uid)
	if HANDLER_GROUPSANDROLES["groups"][uid] == nil then
		HANDLER_GROUPSANDROLES["groups"][uid] = {}
	end
	if !table.HasValue( HANDLER_GROUPSANDROLES["groups"][uid], ply ) then
		table.insert( HANDLER_GROUPSANDROLES["groups"][uid], ply )
		printGM( "gm", ply:YRPName() .. " connected to Group-UID " .. uid )
	else
		printGM( "gm", ply:YRPName() .. " already connected to Group-UID " .. uid )
	end
end

function DisconnectGroup(ply, uid)
	if HANDLER_GROUPSANDROLES["groups"][uid] == nil then
		HANDLER_GROUPSANDROLES["groups"][uid] = {}
	end
	if table.HasValue(HANDLER_GROUPSANDROLES["groups"][uid], ply) then
		table.RemoveByValue(HANDLER_GROUPSANDROLES["groups"][uid], ply)
		printGM("gm", ply:YRPName() .. " disconnected to Group-UID " .. uid)
	end
end

util.AddNetworkString( "Connect_Settings_GroupsAndRoles" )
net.Receive( "Connect_Settings_GroupsAndRoles", function( len, ply )
	if ply:CanAccess( "groupsandroles" ) then
		AddToHandler_GroupsAndRoles( ply )

		net.Start( "Connect_Settings_GroupsAndRoles" )
		net.Send( ply )
	end
end)

util.AddNetworkString( "Disconnect_Settings_GroupsAndRoles" )
net.Receive( "Disconnect_Settings_GroupsAndRoles", function( len, ply )
	RemFromHandler_GroupsAndRoles( ply )
	local cur = tonumber(net.ReadString())
	DisconnectGroup(ply, cur)
end)

function SendGroupList(ply, uid)
	local tbl_groups = SQL_SELECT( DATABASE_NAME, "*", "int_parentgroup = '" .. uid .. "'" )
	if !wk( tbl_groups ) then
		tbl_groups = {}
	end
	local currentuid = uid
	local parentuid = SQL_SELECT( DATABASE_NAME, "*", "uniqueID = '" .. uid .. "'" )
	if wk(parentuid) then
		parentuid = parentuid[1].int_parentgroup
	else
		parentuid = 0
	end

	ConnectGroup(ply, currentuid)

	for i, pl in pairs(HANDLER_GROUPSANDROLES["groups"][uid]) do
		net.Start("settings_get_group_list")
			net.WriteTable(tbl_groups)
			net.WriteString(currentuid)
			net.WriteString(parentuid)
		net.Send(pl)
	end
end

util.AddNetworkString("settings_get_group_list")
net.Receive("settings_get_group_list", function(len, ply)
	local cur = tonumber(net.ReadString())
	local par = tonumber(net.ReadString())
	DisconnectGroup(ply, cur)
	SendGroupList(ply, par)
end)

util.AddNetworkString("settings_add_group")
net.Receive("settings_add_group", function(len, ply)
	local uid = tonumber(net.ReadString())
	SQL_INSERT_INTO(DATABASE_NAME, "int_parentgroup", "'" .. uid .. "'")

	local groups = SQL_SELECT(DATABASE_NAME, "*", "int_parentgroup = '" .. uid .. "'")

	local count = table.Count(groups)
	local new_group = groups[count]
	local up = groups[count - 1]
	SQL_UPDATE(DATABASE_NAME, "int_position = '" .. count .. "', int_up = '" .. up.uniqueID .. "'", "uniqueID = '" .. count .. "'")

	SQL_UPDATE(DATABASE_NAME, "int_dn = '" .. new_group.uniqueID .. "'", "uniqueID = '" .. up.uniqueID .. "'")

	SendGroupList(ply, uid)
end)

util.AddNetworkString("settings_group_position_up")
net.Receive("settings_group_position_up", function(len, ply)
	local uid = tonumber(net.ReadString())
	local group = SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '" .. uid .. "'")
	group = group[1]
	group.int_position = group.int_position - 1
	printGM("db", "[Group-UID: " .. uid .. "] Set position to: " .. group.int_position)
	SQL_UPDATE(DATABASE_NAME, "int_position = " .. group.int_position, "uniqueID = '" .. uid .. "'")

	group.int_parentgroup = tonumber(group.int_parentgroup)
	for i, pl in pairs(HANDLER_GROUPSANDROLES["groups"][group.int_parentgroup]) do
		net.Start("settings_group_position_up")
			net.WriteString(uid)
		net.Send(pl)
	end
end)

util.AddNetworkString("settings_group_position_dn")
net.Receive("settings_group_position_dn", function(len, ply)
	local uid = tonumber(net.ReadString())
	local group = SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '" .. uid .. "'")
	group = group[1]
	group.int_position = group.int_position + 1
	printGM("db", "[Group-UID: " .. uid .. "] Set position to: " .. group.int_position)
	SQL_UPDATE(DATABASE_NAME, "int_position = " .. group.int_position, "uniqueID = '" .. uid .. "'")

	group.int_parentgroup = tonumber(group.int_parentgroup)
	for i, pl in pairs(HANDLER_GROUPSANDROLES["groups"][group.int_parentgroup]) do
		net.Start("settings_group_position_dn")
			net.WriteString(uid)
		net.Send(pl)
	end
end)
]]

-- OLD BELOW

local _db_name = "yrp_groups"

SQL_ADD_COLUMN( _db_name, "groupID", "TEXT DEFAULT 'new Group'" )
SQL_ADD_COLUMN( _db_name, "uppergroup", "INTEGER DEFAULT -1" )
SQL_ADD_COLUMN( _db_name, "friendlyfire", "INTEGER DEFAULT 1" )
SQL_ADD_COLUMN( _db_name, "removeable", "INTEGER DEFAULT 1" )
SQL_ADD_COLUMN( _db_name, "color", "TEXT DEFAULT '0,0,0'" )

--db_drop_table( DATABASE_NAME )
--db_is_empty( _db_name )

if SQL_SELECT( _db_name, "*", "uniqueID = 1" ) == nil then
	printGM( "note", _db_name .. " has not the default group" )
	local _result = SQL_INSERT_INTO( _db_name, "uniqueID, groupID, color, uppergroup, friendlyfire, removeable", "1, 'Civilians', '0,0,255', -1, 1, 0" )
end

util.AddNetworkString( "get_grps" )

net.Receive( "get_grps", function( len, ply )
	local _uid = tonumber( net.ReadString() )

	local _get_grps = SQL_SELECT( _db_name, "*", "uppergroup = " .. _uid )
	if _get_grps != nil then

		net.Start( "get_grps" )
			net.WriteTable( _get_grps )
		net.Send( ply )
	end
end)

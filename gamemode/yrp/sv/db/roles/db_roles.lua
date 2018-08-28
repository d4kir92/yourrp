--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

-- DO NOT TOUCH THE DATABASE FILES! If you have errors, report them here:
-- https://discord.gg/sEgNZxg

local DATABASE_NAME = "yrp_ply_roles"

SQL_ADD_COLUMN( DATABASE_NAME, "string_name", "TEXT DEFAULT 'NewRole'" )
SQL_ADD_COLUMN( DATABASE_NAME, "string_icon", "TEXT DEFAULT ' '" )
SQL_ADD_COLUMN( DATABASE_NAME, "string_usergroups", "TEXT DEFAULT 'ALL'" )
SQL_ADD_COLUMN( DATABASE_NAME, "string_description", "TEXT DEFAULT '-'" )
SQL_ADD_COLUMN( DATABASE_NAME, "string_playermodels", "TEXT DEFAULT ' '" )
SQL_ADD_COLUMN( DATABASE_NAME, "int_salary", "INTEGER DEFAULT 50" )
SQL_ADD_COLUMN( DATABASE_NAME, "int_groupID", "INTEGER DEFAULT 1" )
SQL_ADD_COLUMN( DATABASE_NAME, "string_color", "TEXT DEFAULT '0,0,0'" )
SQL_ADD_COLUMN( DATABASE_NAME, "string_sweps", "TEXT DEFAULT ' '" )
SQL_ADD_COLUMN( DATABASE_NAME, "string_ammunation", "TEXT DEFAULT ' '" )
SQL_ADD_COLUMN( DATABASE_NAME, "bool_voteable", "INTEGER DEFAULT 0" )
SQL_ADD_COLUMN( DATABASE_NAME, "bool_adminonly", "INTEGER DEFAULT 0" )
SQL_ADD_COLUMN( DATABASE_NAME, "bool_whitelist", "INTEGER DEFAULT 0" )
SQL_ADD_COLUMN( DATABASE_NAME, "int_maxamount", "INTEGER DEFAULT -1" )
SQL_ADD_COLUMN( DATABASE_NAME, "int_hp", "INTEGER DEFAULT 100" )
SQL_ADD_COLUMN( DATABASE_NAME, "int_hpmax", "INTEGER DEFAULT 100" )
SQL_ADD_COLUMN( DATABASE_NAME, "float_hpreg", "INTEGER DEFAULT 0" )
SQL_ADD_COLUMN( DATABASE_NAME, "int_ar", "INTEGER DEFAULT 0" )
SQL_ADD_COLUMN( DATABASE_NAME, "int_armax", "INTEGER DEFAULT 100" )
SQL_ADD_COLUMN( DATABASE_NAME, "float_arreg", "INTEGER DEFAULT 0" )
SQL_ADD_COLUMN( DATABASE_NAME, "int_st", "INTEGER DEFAULT 50" )
SQL_ADD_COLUMN( DATABASE_NAME, "int_stmax", "INTEGER DEFAULT 100" )
SQL_ADD_COLUMN( DATABASE_NAME, "float_stregup", "INTEGER DEFAULT 1" )
SQL_ADD_COLUMN( DATABASE_NAME, "float_stregdn", "INTEGER DEFAULT 0.5" )

SQL_ADD_COLUMN( DATABASE_NAME, "string_abart", "TEXT DEFAULT 'mana'" )
SQL_ADD_COLUMN( DATABASE_NAME, "int_ab", "INTEGER DEFAULT 50" )
SQL_ADD_COLUMN( DATABASE_NAME, "int_abmax", "INTEGER DEFAULT 1000" )
SQL_ADD_COLUMN( DATABASE_NAME, "float_abreg", "INTEGER DEFAULT 5" )

SQL_ADD_COLUMN( DATABASE_NAME, "int_speedwalk", "INTEGER DEFAULT 150" )
SQL_ADD_COLUMN( DATABASE_NAME, "int_speedrun", "INTEGER DEFAULT 240" )
SQL_ADD_COLUMN( DATABASE_NAME, "int_powerjump", "INTEGER DEFAULT 200" )
SQL_ADD_COLUMN( DATABASE_NAME, "int_prerole", "INTEGER DEFAULT 0" )
SQL_ADD_COLUMN( DATABASE_NAME, "bool_instructor", "INTEGER DEFAULT 0" )
SQL_ADD_COLUMN( DATABASE_NAME, "bool_removeable", "INTEGER DEFAULT 1" )
SQL_ADD_COLUMN( DATABASE_NAME, "int_uses", "INTEGER DEFAULT 0" )
SQL_ADD_COLUMN( DATABASE_NAME, "int_salarytime", "INTEGER DEFAULT 120" )
SQL_ADD_COLUMN( DATABASE_NAME, "bool_voiceglobal", "INTEGER DEFAULT 0" )
SQL_ADD_COLUMN( DATABASE_NAME, "int_requireslevel", "INTEGER DEFAULT 1" )

SQL_ADD_COLUMN( DATABASE_NAME, "bool_canbeagent", "INTEGER DEFAULT 0" )
SQL_ADD_COLUMN( DATABASE_NAME, "bool_iscivil", "INTEGER DEFAULT 0" )
SQL_ADD_COLUMN( DATABASE_NAME, "bool_visible", "INTEGER DEFAULT 1" )
SQL_ADD_COLUMN( DATABASE_NAME, "bool_locked", "INTEGER DEFAULT 0" )

SQL_ADD_COLUMN( DATABASE_NAME, "string_licenses", "TEXT DEFAULT ' '" )

SQL_ADD_COLUMN( DATABASE_NAME, "int_position", "INTEGER DEFAULT 1" )

SQL_UPDATE( DATABASE_NAME, "uses = 0", nil )

local yrp_ply_roles = {}
local _init_ply_roles = SQL_SELECT( DATABASE_NAME, "*", "uniqueID = '1'" )
if wk(_init_ply_roles) then
	yrp_ply_roles = _init_ply_roles[1]
end

local HANDLER_GROUPSANDROLES = {}
HANDLER_GROUPSANDROLES["roleslist"] = {}
HANDLER_GROUPSANDROLES["roles"] = {}
HANDLER_GROUPSANDROLES["roles"] = {}

for str, val in pairs( yrp_ply_roles ) do
	if string.find( str, "string_" ) then
		local tab = {}
		tab.netstr = "update_role_" .. str
		util.AddNetworkString( tab.netstr )
		net.Receive( tab.netstr, function( len, ply )
			local uid = tonumber(net.ReadString())
			local s = net.ReadString()
			tab.ply = ply
			tab.id = str
			tab.value = s
			tab.db = DATABASE_NAME
			tab.uniqueID = uid
			UpdateString(tab)
			tab.handler = HANDLER_GROUPSANDROLES["roles"][tonumber(tab.uniqueID)]
			BroadcastString(tab)
			if tab.netstr == "update_role_string_name" then
				util.AddNetworkString("settings_role_update_name")
				local puid = SQL_SELECT( DATABASE_NAME, "*", "uniqueID = '" .. uid .. "'" )
				if wk(puid) then
					puid = puid[1]
					tab.handler = HANDLER_GROUPSANDROLES["roleslist"][tonumber(puid.int_parentrole)]
					tab.netstr = "settings_role_update_name"
					tab.uniqueID = tonumber(puid.uniqueID)
					tab.force = true
					BroadcastString(tab)
				end
			elseif tab.netstr == "update_role_string_color" then
				util.AddNetworkString("settings_role_update_color")
				local puid = SQL_SELECT( DATABASE_NAME, "*", "uniqueID = '" .. uid .. "'" )
				if wk(puid) then
					puid = puid[1]
					tab.handler = HANDLER_GROUPSANDROLES["roleslist"][tonumber(puid.int_parentrole)]
					tab.netstr = "settings_role_update_color"
					tab.uniqueID = tonumber(puid.uniqueID)
					tab.force = true
					BroadcastString(tab)
				end
			elseif tab.netstr == "update_role_string_icon" then
				util.AddNetworkString("settings_role_update_icon")
				local puid = SQL_SELECT( DATABASE_NAME, "*", "uniqueID = '" .. uid .. "'" )
				if wk(puid) then
					puid = puid[1]
					tab.handler = HANDLER_GROUPSANDROLES["roleslist"][tonumber(puid.int_parentrole)]
					tab.netstr = "settings_role_update_icon"
					tab.uniqueID = tonumber(puid.uniqueID)
					tab.force = true
					BroadcastString(tab)
				end
			end
		end)
	elseif string.find( str, "int_" ) then
		local tab = {}
		tab.netstr = "update_role_" .. str
		util.AddNetworkString( tab.netstr )
		net.Receive( tab.netstr, function( len, ply )
			local uid = tonumber(net.ReadString())
			local int = tonumber(net.ReadString())
			local cur = SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '" .. uid .. "'")
			tab.ply = ply
			tab.id = str
			tab.value = int
			tab.db = DATABASE_NAME
			tab.uniqueID = uid
			UpdateInt(tab)
			tab.handler = HANDLER_GROUPSANDROLES["roles"][tonumber(tab.uniqueID)]
			BroadcastInt(tab)
			if tab.netstr == "update_int_parentrole" then
				if wk(cur) then
					cur = cur[1]
					SendGroupList(tonumber(cur.int_parentrole))
				end
				SendGroupList(int)
			end
		end)
	elseif string.find( str, "bool_" ) then
		local tab = {}
		tab.netstr = "update_role_" .. str
		util.AddNetworkString( tab.netstr )
		net.Receive( tab.netstr, function( len, ply )
			local uid = tonumber(net.ReadString())
			local int = tonumber(net.ReadString())
			local cur = SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '" .. uid .. "'")
			tab.ply = ply
			tab.id = str
			tab.value = int
			tab.db = DATABASE_NAME
			tab.uniqueID = uid
			UpdateInt(tab)
			tab.handler = HANDLER_GROUPSANDROLES["roles"][tonumber(tab.uniqueID)]
			BroadcastInt(tab)
			if tab.netstr == "update_int_parentrole" then
				if wk(cur) then
					cur = cur[1]
					SendGroupList(tonumber(cur.int_parentrole))
				end
				SendGroupList(int)
			end
		end)
	end
end

function SubscribeRoleList(ply, uid)
	if HANDLER_GROUPSANDROLES["roleslist"][uid] == nil then
		HANDLER_GROUPSANDROLES["roleslist"][uid] = {}
	end
	if !table.HasValue( HANDLER_GROUPSANDROLES["roleslist"][uid], ply ) then
		table.insert( HANDLER_GROUPSANDROLES["roleslist"][uid], ply )
		printGM( "gm", ply:YRPName() .. " subscribed to RoleList " .. uid )
	else
		printGM( "gm", ply:YRPName() .. " already subscribed to RoleList " .. uid )
	end
end

function UnsubscribeRoleList(ply, uid)
	if HANDLER_GROUPSANDROLES["roleslist"][uid] == nil then
		HANDLER_GROUPSANDROLES["roleslist"][uid] = {}
	end
	if table.HasValue(HANDLER_GROUPSANDROLES["roleslist"][uid], ply) then
		table.RemoveByValue(HANDLER_GROUPSANDROLES["roleslist"][uid], ply)
		printGM("gm", ply:YRPName() .. " unsubscribed from RoleList " .. uid)
	end
end

function SubscribeRole(ply, uid)
	if HANDLER_GROUPSANDROLES["roles"][uid] == nil then
		HANDLER_GROUPSANDROLES["roles"][uid] = {}
	end
	if !table.HasValue( HANDLER_GROUPSANDROLES["roles"][uid], ply ) then
		table.insert( HANDLER_GROUPSANDROLES["roles"][uid], ply )
		printGM( "gm", ply:YRPName() .. " subscribed to Role " .. uid )
	else
		printGM( "gm", ply:YRPName() .. " already subscribed to Role " .. uid )
	end
end

function UnsubscribeRole(ply, uid)
	if HANDLER_GROUPSANDROLES["roles"][uid] == nil then
		HANDLER_GROUPSANDROLES["roles"][uid] = {}
	end
	if table.HasValue(HANDLER_GROUPSANDROLES["roles"][uid], ply) then
		table.RemoveByValue(HANDLER_GROUPSANDROLES["roles"][uid], ply)
		printGM("gm", ply:YRPName() .. " unsubscribed from Role " .. uid)
	end
end

function SortRoles(uid)
	local siblings = SQL_SELECT(DATABASE_NAME, "*", "int_groupID = '" .. uid .. "'")

	if wk(siblings) then
		for i, sibling in pairs(siblings) do
			sibling.int_position = tonumber(sibling.int_position)
		end

		local count = 0
		for i, sibling in SortedPairsByMemberValue(siblings, "int_position", false) do
			count = count + 1
			SQL_UPDATE(DATABASE_NAME, "int_position = '" .. count .. "'", "uniqueID = '" .. sibling.uniqueID .. "'")
		end
	end
end

function SendRoleList(uid)
	print("SendRoleList", uid)
	SortRoles(uid)

	local tbl_parentgroup = SQL_SELECT( "yrp_ply_groups", "*", "uniqueID = '" .. uid .. "'" )
	if !wk( tbl_parentgroup ) then
		tbl_parentgroup = {}
	else
		tbl_parentgroup = tbl_parentgroup[1]
	end

	local tbl_roles = SQL_SELECT( DATABASE_NAME, "*", "int_groupID = '" .. uid .. "'" )
	if !wk( tbl_roles ) then
		tbl_roles = {}
	end
	local currentuid = uid
	local parentuid = SQL_SELECT( DATABASE_NAME, "*", "uniqueID = '" .. uid .. "'" )
	if wk(parentuid) then
		parentuid = parentuid[1].int_groupID
	else
		parentuid = 0
	end

	HANDLER_GROUPSANDROLES["roleslist"][uid] = HANDLER_GROUPSANDROLES["roleslist"][uid] or {}
	for i, pl in pairs(HANDLER_GROUPSANDROLES["roleslist"][uid]) do
		net.Start("settings_subscribe_rolelist")
			net.WriteTable(tbl_parentgroup)
			net.WriteTable(tbl_roles)
			net.WriteString(currentuid)
			net.WriteString(parentuid)
		net.Send(pl)
	end
end

util.AddNetworkString("settings_subscribe_rolelist")
net.Receive("settings_subscribe_rolelist", function(len, ply)
	local par = tonumber(net.ReadString())
	SubscribeRoleList(ply, par)
	SendRoleList(par)
end)

util.AddNetworkString("settings_add_role")
net.Receive("settings_add_role", function(len, ply)
	local uid = tonumber(net.ReadString())
	SQL_INSERT_INTO(DATABASE_NAME, "int_groupID", "'" .. uid .. "'")

	local roles = SQL_SELECT(DATABASE_NAME, "*", "int_groupID = '" .. uid .. "'")

	local count = tonumber(table.Count(roles))
	local new_role = roles[count]
	local up = roles[count - 1]
	if count == 1 then
		SQL_UPDATE(DATABASE_NAME, "int_position = '" .. count .. "'", "uniqueID = '" .. new_role.uniqueID .. "'")
	else
		SQL_UPDATE(DATABASE_NAME, "int_position = '" .. count .. "', int_up = '" .. up.uniqueID .. "'", "uniqueID = '" .. new_role.uniqueID .. "'")
		SQL_UPDATE(DATABASE_NAME, "int_dn = '" .. new_role.uniqueID .. "'", "uniqueID = '" .. up.uniqueID .. "'")
	end

	printGM("db", "Added new role: " .. new_role.uniqueID)

	SendRoleList(uid)
end)

util.AddNetworkString("settings_role_position_up")
net.Receive("settings_role_position_up", function(len, ply)
	local uid = tonumber(net.ReadString())
	local role = SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '" .. uid .. "'")
	role = role[1]

	role.int_position = tonumber(role.int_position)

	local siblings = SQL_SELECT(DATABASE_NAME, "*", "int_groupID = '" .. role.int_groupID .. "'")

	for i, sibling in pairs(siblings) do
		sibling.int_position = tonumber(sibling.int_position)
	end

	local count = 0
	for i, sibling in SortedPairsByMemberValue(siblings, "int_position", false) do
		count = count + 1
		if tonumber(sibling.int_position) == role.int_position - 1 then
			SQL_UPDATE(DATABASE_NAME, "int_position = '" .. role.int_position .. "'", "uniqueID = '" .. sibling.uniqueID .. "'")
			SQL_UPDATE(DATABASE_NAME, "int_position = '" .. sibling.int_position .. "'", "uniqueID = '" .. uid .. "'")
		end
	end

	role.int_groupID = tonumber(role.int_groupID)
	SendRoleList(role.int_groupID)
end)

util.AddNetworkString("settings_role_position_dn")
net.Receive("settings_role_position_dn", function(len, ply)
	local uid = tonumber(net.ReadString())
	local role = SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '" .. uid .. "'")
	role = role[1]

	role.int_position = tonumber(role.int_position)

	local siblings = SQL_SELECT(DATABASE_NAME, "*", "int_groupID = '" .. role.int_groupID .. "'")

	for i, sibling in pairs(siblings) do
		sibling.int_position = tonumber(sibling.int_position)
	end

	local count = 0
	for i, sibling in SortedPairsByMemberValue(siblings, "int_position", false) do
		count = count + 1
		if tonumber(sibling.int_position) == role.int_position + 1 then
			SQL_UPDATE(DATABASE_NAME, "int_position = '" .. role.int_position .. "'", "uniqueID = '" .. sibling.uniqueID .. "'")
			SQL_UPDATE(DATABASE_NAME, "int_position = '" .. sibling.int_position .. "'", "uniqueID = '" .. uid .. "'")
		end
	end

	role.int_groupID = tonumber(role.int_groupID)
	SendRoleList(role.int_groupID)
end)

util.AddNetworkString("settings_subscribe_role")
net.Receive("settings_subscribe_role", function(len, ply)
	local uid = tonumber(net.ReadString())
	SubscribeRole(ply, uid)

	local role = SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '" .. uid .. "'")
	if !wk(role) then
		role = {}
	else
		role = role[1]
	end

	local roles = SQL_SELECT(DATABASE_NAME, "string_name, uniqueID", nil)
	if !wk(roles) then
		roles = {}
	end

	local usergroups = SQL_SELECT("yrp_usergroups", "*", nil)

	net.Start("settings_subscribe_role")
		net.WriteTable(role)
		net.WriteTable(roles)
		net.WriteTable(usergroups)
	net.Send(ply)
end)

util.AddNetworkString("settings_unsubscribe_role")
net.Receive("settings_unsubscribe_role", function(len, ply)
	local uid = tonumber(net.ReadString())
	UnsubscribeRole(ply, uid)
end)

util.AddNetworkString("settings_unsubscribe_rolelist")
net.Receive("settings_unsubscribe_rolelist", function(len, ply)
	local uid = tonumber(net.ReadString())
	UnsubscribeRoleList(ply, uid)
end)

util.AddNetworkString("settings_delete_role")
net.Receive("settings_delete_role", function(len, ply)
	local uid = tonumber(net.ReadString())
	local role = SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '" .. uid .. "'")
	if wk(role) then
		role = role[1]
		SQL_DELETE_FROM(DATABASE_NAME, "uniqueID = '" .. uid .. "'")

		local siblings = SQL_SELECT(DATABASE_NAME, "*", "int_groupID = '" .. role.int_groupID .. "'")
		if wk(siblings) then
			for i, sibling in pairs(siblings) do
				sibling.int_position = tonumber(sibling.int_position)
			end
			local count = 0
			for i, sibling in SortedPairsByMemberValue(siblings, "int_position", false) do
				count = count + 1
				SQL_UPDATE(DATABASE_NAME, "int_position = '" .. count .. "'", "uniqueID = '" .. sibling.uniqueID .. "'")
			end
		end

		role.int_groupID = tonumber(role.int_groupID)
		SendrpList(role.int_groupID)
	end
end)

-- OLD
local _db_name = "yrp_roles"

SQL_ADD_COLUMN( _db_name, "roleID", "TEXT DEFAULT ' '" )
SQL_ADD_COLUMN( _db_name, "description", "TEXT DEFAULT '-'" )
SQL_ADD_COLUMN( _db_name, "playermodels", "TEXT DEFAULT ' '" )
SQL_ADD_COLUMN( _db_name, "playermodelsnone", "TEXT DEFAULT ' '" )
SQL_ADD_COLUMN( _db_name, "playermodelsize", "INTEGER DEFAULT 1" )
SQL_ADD_COLUMN( _db_name, "salary", "INTEGER DEFAULT 50" )
SQL_ADD_COLUMN( _db_name, "roleID", "INTEGER DEFAULT 1" )
SQL_ADD_COLUMN( _db_name, "color", "TEXT DEFAULT '0,0,0'" )
SQL_ADD_COLUMN( _db_name, "sweps", "TEXT DEFAULT ' '" )
SQL_ADD_COLUMN( _db_name, "ammunation", "TEXT DEFAULT ' '" )
SQL_ADD_COLUMN( _db_name, "voteable", "INTEGER DEFAULT 0" )
SQL_ADD_COLUMN( _db_name, "adminonly", "INTEGER DEFAULT 0" )
SQL_ADD_COLUMN( _db_name, "whitelist", "INTEGER DEFAULT 0" )
SQL_ADD_COLUMN( _db_name, "maxamount", "INTEGER DEFAULT -1" )
SQL_ADD_COLUMN( _db_name, "hp", "INTEGER DEFAULT 100" )
SQL_ADD_COLUMN( _db_name, "hpmax", "INTEGER DEFAULT 100" )
SQL_ADD_COLUMN( _db_name, "hpreg", "INTEGER DEFAULT 0" )
SQL_ADD_COLUMN( _db_name, "ar", "INTEGER DEFAULT 0" )
SQL_ADD_COLUMN( _db_name, "armax", "INTEGER DEFAULT 100" )
SQL_ADD_COLUMN( _db_name, "arreg", "INTEGER DEFAULT 0" )
SQL_ADD_COLUMN( _db_name, "st", "INTEGER DEFAULT 50" )
SQL_ADD_COLUMN( _db_name, "stmax", "INTEGER DEFAULT 100" )
SQL_ADD_COLUMN( _db_name, "stregup", "INTEGER DEFAULT 1" )
SQL_ADD_COLUMN( _db_name, "stregdn", "INTEGER DEFAULT 0.5" )

SQL_ADD_COLUMN( _db_name, "abart", "TEXT DEFAULT 'mana'" )
SQL_ADD_COLUMN( _db_name, "ab", "INTEGER DEFAULT 50" )
SQL_ADD_COLUMN( _db_name, "abmax", "INTEGER DEFAULT 1000" )
SQL_ADD_COLUMN( _db_name, "abreg", "INTEGER DEFAULT 5" )

SQL_ADD_COLUMN( _db_name, "speedwalk", "INTEGER DEFAULT 150" )
SQL_ADD_COLUMN( _db_name, "speedrun", "INTEGER DEFAULT 240" )
SQL_ADD_COLUMN( _db_name, "powerjump", "INTEGER DEFAULT 200" )
SQL_ADD_COLUMN( _db_name, "prerole", "INTEGER DEFAULT -1" )
SQL_ADD_COLUMN( _db_name, "instructor", "INTEGER DEFAULT 0" )
SQL_ADD_COLUMN( _db_name, "removeable", "INTEGER DEFAULT 1" )
SQL_ADD_COLUMN( _db_name, "uses", "INTEGER DEFAULT 0" )
SQL_ADD_COLUMN( _db_name, "salarytime", "INTEGER DEFAULT 120" )
SQL_ADD_COLUMN( _db_name, "voiceglobal", "INTEGER DEFAULT 0" )

SQL_ADD_COLUMN( _db_name, "groupID", "INTEGER DEFAULT 1" )

SQL_ADD_COLUMN( _db_name, "canbeagent", "INTEGER DEFAULT 0" )
SQL_ADD_COLUMN( _db_name, "iscivil", "INTEGER DEFAULT 0" )

SQL_ADD_COLUMN( _db_name, "licenseIDs", "TEXT DEFAULT ' '" )

SQL_UPDATE( _db_name, "uses = 0", nil )

--db_drop_table( _db_name )
--db_is_empty( _db_name )

local _default_role = SQL_SELECT( _db_name, "*", "uniqueID = 1" )
if !wk(_default_role) then
	printGM( "note", _db_name .. " has not the default role" )
	local _result = SQL_INSERT_INTO( _db_name, "uniqueID, roleID, color, playermodels, removeable", "1, 'Civilian', '0,0,0', '', 0" )
	printGM( "note", _result )
end

util.AddNetworkString( "getAllGroups" )

util.AddNetworkString( "wantRole" )

util.AddNetworkString( "openInteractMenu" )
util.AddNetworkString( "promotePlayer" )
util.AddNetworkString( "demotePlayer" )

util.AddNetworkString( "yrp_ply_groups" )
util.AddNetworkString( "yrp_roles" )

util.AddNetworkString( "removeDBGroup" )
util.AddNetworkString( "removeDBRole" )

util.AddNetworkString( "addDBGroup" )
util.AddNetworkString( "addDBRole" )

util.AddNetworkString( "dupDBGroup" )
util.AddNetworkString( "dupDBRole" )

util.AddNetworkString( "getScoreboardGroups" )

util.AddNetworkString( "setting_getroles" )
net.Receive( "setting_getroles", function( len, ply )
	if ply:CanAccess( "groupsandroles" ) then
		net.Start( "setting_getroles" )
		net.Send( ply )
	end
end)

function sendDBGroups( ply )
	local tmp = SQL_SELECT( "yrp_ply_groups", "*", nil )
	net.Start( "yrp_ply_groups" )
		net.WriteTable( tmp )
	net.Send( ply )
end

function sendDBRoles( ply, groupID )
	local tmp = SQL_SELECT( "yrp_roles", "*", "groupID = " .. groupID .. "" )
	if tmp == nil then
		tmp = {}
	end
	net.Start( "yrp_roles" )
		net.WriteTable( tmp )
	net.Send( ply )
end

net.Receive( "getScoreboardGroups", function( len, ply )
	local _tmpGroups = SQL_SELECT( "yrp_ply_groups", "*", nil )
	if _tmpGroups != nil then
		net.Start( "getScoreboardGroups" )
			net.WriteTable( _tmpGroups )
		net.Broadcast()
	end
end)

function duplicateRole( ply, uniqueID, newGroupID )
	if newGroupID != nil then
	end
	local _dR = SQL_SELECT( "yrp_roles", "*", "uniqueID = " .. uniqueID )
	_dR = _dR[1]
	if newGroupID != nil then
		_dR.groupID = newGroupID
	end
	if tonumber( _dR.removeable ) == 1 then
		local _dbColumns = "adminonly, ar, armax, arreg, salary, color, description, groupID, hp, hpmax, hpreg, instructor, maxamount, playermodels, playermodelsnone, playermodelsize, powerjump, prerole, removeable, roleID, speedrun, speedwalk, sweps, whitelist"
		local _dbValues = _dR.adminonly .. ", " .. _dR.ar .. ", " .. _dR.armax .. ", " .. _dR.arreg .. ", " .. _dR.salary .. ", '" .. _dR.color .. "', '" .. _dR.description .. "', "
		_dbValues = _dbValues .. _dR.groupID .. ", " .. _dR.hp .. ", " .. _dR.hpmax .. ", " .. _dR.hpreg .. ", " .. _dR.instructor .. ", " .. _dR.maxamount .. ", "
		_dbValues = _dbValues .. "'" .. _dR.playermodels .. "', '" .. _dR.playermodelsnone .. "', " .. _dR.playermodelsize .. ", " .. _dR.powerjump .. ", " .. _dR.prerole .. ", " .. _dR.removeable .. ", '" .. _dR.roleID .. "', "
		_dbValues = _dbValues .. _dR.speedrun .. ", " .. _dR.speedwalk .. ", '" .. SQL_STR_IN( _dR.sweps ) .. "', " .. _dR.whitelist
		SQL_INSERT_INTO( "yrp_roles", _dbColumns, _dbValues )
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

net.Receive( "addDBRole", function( len, ply )
	printGM( "db", "addDBRole" )
	local _tmpUniqueID = net.ReadString()
	local result = SQL_INSERT_INTO( "yrp_roles", "roleID, groupID", "'" .. lang_string( "newrole" ) .. "', " .. _tmpUniqueID )
	printGM( "db", result)

	sendDBRoles( ply, _tmpUniqueID )
end)

function changeToDefault( table )
	for k, v in pairs( table ) do
		local _result = SQL_UPDATE( "yrp_characters", "roleID = 1, groupID = 1" ,"uniqueID = " .. v.uniqueID )
	end
end

net.Receive( "removeDBRole", function( len, ply )
	local _dbSelect = SQL_SELECT( "yrp_roles", "*", nil )
	local tmp = net.ReadString()
	local _tmpUniqueID = net.ReadString()
	for k, v in pairs( _dbSelect ) do
		if tonumber( v.uniqueID ) == tonumber( tmp ) then
			if tonumber( v.removeable ) == 1 then
				local _result = SQL_DELETE_FROM( "yrp_roles", "uniqueID = " .. tmp )
				local _changeToDefault = SQL_SELECT( "yrp_characters", "*", "roleID = " .. v.uniqueID )
				if _changeToDefault != nil then
					changeToDefault( _changeToDefault )
				end
			end
		end
	end

	sendDBRoles( ply, _tmpUniqueID )
end)

function DeleteRolesFromGroup( uid )
	SQL_DELETE_FROM( "yrp_roles", "groupID = '" .. uid .. "' AND removeable = '1'" )
end

net.Receive( "removeDBGroup", function( len, ply )
	local _dbSelect = SQL_SELECT( "yrp_ply_groups", "*", nil )
	local tmp = net.ReadString()
	for k, v in pairs( _dbSelect ) do
		if tonumber( v.uniqueID ) == tonumber( tmp ) then
			if tonumber( v.removeable ) == 1 then
				SQL_DELETE_FROM( "yrp_ply_groups", "uniqueID = " .. tmp )
				DeleteRolesFromGroup( tmp )
			end
		end
	end

	sendDBGroups( ply )
end)

net.Receive( "yrp_roles", function( len, ply )
	local _tmpGroupID = net.ReadString()
	sendDBRoles( ply, _tmpGroupID )
end)

net.Receive( "yrp_ply_groups", function( len, ply )
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
	local tmpTableInstructorRole = ply:GetRolTab()

	local tmpTargetChaTab = tmpTarget:GetChaTab()

	if tonumber( tmpTableInstructorRole.instructor ) == 1 then


		local tmpTableTargetRole = SQL_SELECT( "yrp_roles", "*", "uniqueID = " .. tmpTargetChaTab.roleID )
		local tmpTableTargetDemoteRole = SQL_SELECT( "yrp_roles", "*", "uniqueID = " .. tmpTableTargetRole[1].prerole )
		local tmpTableTargetGroup = SQL_SELECT( "yrp_ply_groups", "*", "uniqueID = " .. tmpTableTargetDemoteRole[1].groupID )

		tmpTableTargetDemoteRole = tmpTableTargetDemoteRole[1]
		tmpTableTargetGroup = tmpTableTargetGroup[1]

		removeFromWhitelist( tmpTarget:SteamID(), tmpTableTargetRole[1].uniqueID )
		SetRole( tmpTarget, tmpTableTargetDemoteRole.uniqueID )

		printGM( "instructor", ply:Nick() .. " demoted " .. tmpTarget:Nick() .. " to " .. tmpTableTargetDemoteRole.roleID )
	elseif tonumber( tmpTableInstructorRole.instructor ) == 0 then
		printGM( "error", "Player: " .. ply:Nick() .. " (" .. ply:SteamID() .. ") tried to use demote function! He is not an instructor!" )
	else
		printGM( "error", "ELSE demote: " .. tostring( tmpTableInstructorRole.instructor ) )
	end
end)

function removeFromWhitelist( SteamID, roleID )
	local _result = SQL_SELECT( "yrp_role_whitelist", "*", "SteamID = '" .. SteamID .. "' AND roleID = " .. roleID )
	if _result != nil then
		SQL_DELETE_FROM( "yrp_role_whitelist", "uniqueID = " .. _result[1].uniqueID )
	end
end

function addToWhitelist( SteamID, roleID, groupID, nick )
	if SQL_SELECT( "yrp_role_whitelist", "*", "SteamID = '" .. SteamID .. "' AND roleID = " .. roleID ) == nil then
		SQL_INSERT_INTO( "yrp_role_whitelist", "SteamID, nick, groupID, roleID", "'" .. SteamID .. "', '" .. nick .. "', " .. groupID .. ", " .. roleID )
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
	local tmpTableInstructorRole = ply:GetRolTab() --SQL_SELECT( "yrp_roles", "*", "uniqueID = " .. tmpTableInstructor.roleID )

	local tmpTargetChaTab = tmpTarget:GetChaTab()

	if tonumber( tmpTableInstructorRole.instructor ) == 1 then
		local tmpTableTargetRole = SQL_SELECT( "yrp_roles", "*", "uniqueID = " .. tmpTargetChaTab.roleID )
		local tmpTableTargetPromoteRole = SQL_SELECT( "yrp_roles", "*", "prerole = " .. tmpTableTargetRole[1].uniqueID .. " AND groupID = " .. tmpTableInstructorRole.groupID )

		local tmpTableTargetGroup = SQL_SELECT( "yrp_ply_groups", "*", "uniqueID = " .. tmpTableTargetPromoteRole[1].groupID )

		tmpTableTargetPromoteRole = tmpTableTargetPromoteRole[1]
		tmpTableTargetGroup = tmpTableTargetGroup[1]

		for k, v in pairs(player.GetAll()) do
			if tostring( v:SteamID() ) == tostring( tmpTargetSteamID ) then
				addToWhitelist( tmpTarget:SteamID(), tmpTableTargetPromoteRole.uniqueID, tmpTableTargetGroup.uniqueID, v:Nick() )
				break
			end
		end

		SetRole( tmpTarget, tmpTableTargetPromoteRole.uniqueID, true )

		printGM( "instructor", ply:Nick() .. " promoted " .. tmpTarget:Nick() .. " to " .. tmpTableTargetPromoteRole.roleID )
	elseif tonumber( tmpTableInstructorRole.instructor ) == 0 then
		printGM( "error", "Player: " .. ply:Nick() .. " (" .. ply:SteamID() .. ") tried to use promote function! He is not an instructor!" )
	else
		printGM( "error", "ELSE promote: " .. tostring( tmpTableInstructorRole.instructor ) )
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
	if ea( tmpTarget ) then
		if tmpTarget:IsPlayer() then
			local tmpTargetChaTab = tmpTarget:GetChaTab()
			if tmpTargetChaTab != nil then
				local tmpTargetRole = SQL_SELECT( "yrp_roles", "*", "uniqueID = " .. tmpTargetChaTab.roleID )

				local tmpT = ply:GetChaTab()
				local tmpTable = ply:GetRolTab()
				if wk( tmpT ) and wk( tmpTable ) then
					local tmpBool = false

					local tmpPromote = false
					local tmpPromoteName = ""

					local tmpDemote = false
					local tmpDemoteName = ""

					if tonumber( tmpTable.instructor ) == 1 then
						tmpBool = true

						local tmpSearch = true	--tmpTargetSteamID
						local tmpTableSearch = SQL_SELECT( "yrp_roles", "*", "uniqueID = " .. tmpTable.prerole )
						if tmpTableSearch != nil then
							local tmpSearchUniqueID = tmpTableSearch[1].prerole
							local tmpCounter = 0
							while (tmpSearch) do
								tmpSearchUniqueID = tonumber( tmpTableSearch[1].prerole )

								if tonumber( tmpTargetRole[1].prerole ) != -1 and tmpTableSearch[1].uniqueID == tmpTargetRole[1].uniqueID then
									tmpDemote = true
									local tmp = SQL_SELECT( "yrp_roles", "*", "uniqueID = " .. tmpTargetRole[1].prerole )
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
									printGM( "note", "You have a loop in your preroles!" )
									tmpSearch = false
								end
								tmpCounter = tmpCounter + 1
								tmpTableSearch = SQL_SELECT( "yrp_roles", "*", "uniqueID = " .. tmpSearchUniqueID )
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
				end
			end
		end
	end
end)

net.Receive( "getAllGroups", function( len, ply )
	local tmpUpperGroup = net.ReadInt( 16 )

	local tmpTable = SQL_SELECT( "yrp_ply_groups", "*", nil )
	local tmpTable2 = SQL_SELECT( "yrp_roles", "*", nil )
	local tmpTable3 = SQL_SELECT( "yrp_role_whitelist", "*", "SteamID = '" .. ply:SteamID() .. "'" )
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

--[[ Role menu ]]--
util.AddNetworkString( "get_grp_roles" )

net.Receive( "get_grp_roles", function( len, ply )
	local _uid = net.ReadString()
	local _roles = SQL_SELECT( _db_name, "*", "groupID = " .. _uid )
	if _roles != nil then
		net.Start( "get_grp_roles" )
			net.WriteTable( _roles )
		net.Send( ply )
	end
end)

util.AddNetworkString( "get_rol_prerole" )

net.Receive( "get_rol_prerole", function( len, ply )
	local _uid = net.ReadString()
	local _roles = SQL_SELECT( _db_name, "*", "prerole = " .. _uid )
	if _roles != nil then
		_roles = _roles[1]
		net.Start( "get_rol_prerole" )
			net.WriteTable( _roles )
		net.Send( ply )
	end
end)

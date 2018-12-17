--Copyright (C) 2017-2018 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

-- DO NOT TOUCH THE DATABASE FILES! If you have errors, report them here:
-- https://discord.gg/sEgNZxg

local DATABASE_NAME = "yrp_ply_roles"

SQL_ADD_COLUMN(DATABASE_NAME, "string_name", "TEXT DEFAULT 'NewRole'")
SQL_ADD_COLUMN(DATABASE_NAME, "string_icon", "TEXT DEFAULT ''")
SQL_ADD_COLUMN(DATABASE_NAME, "string_usergroups", "TEXT DEFAULT 'ALL'")
SQL_ADD_COLUMN(DATABASE_NAME, "string_description", "TEXT DEFAULT '-'")
SQL_ADD_COLUMN(DATABASE_NAME, "string_playermodels", "TEXT DEFAULT ''")
SQL_ADD_COLUMN(DATABASE_NAME, "int_salary", "INTEGER DEFAULT 50")
SQL_ADD_COLUMN(DATABASE_NAME, "int_groupID", "INTEGER DEFAULT 1")
SQL_ADD_COLUMN(DATABASE_NAME, "string_color", "TEXT DEFAULT '0,0,0'")
SQL_ADD_COLUMN(DATABASE_NAME, "string_sweps", "TEXT DEFAULT ''")
SQL_ADD_COLUMN(DATABASE_NAME, "string_ammunation", "TEXT DEFAULT ''")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_voteable", "INTEGER DEFAULT 0")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_adminonly", "INTEGER DEFAULT 0")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_whitelist", "INTEGER DEFAULT 0")
SQL_ADD_COLUMN(DATABASE_NAME, "int_maxamount", "INTEGER DEFAULT 0")
SQL_ADD_COLUMN(DATABASE_NAME, "int_hp", "INTEGER DEFAULT 100")
SQL_ADD_COLUMN(DATABASE_NAME, "int_hpmax", "INTEGER DEFAULT 100")
SQL_ADD_COLUMN(DATABASE_NAME, "int_hpup", "INTEGER DEFAULT 0")
SQL_ADD_COLUMN(DATABASE_NAME, "int_ar", "INTEGER DEFAULT 0")
SQL_ADD_COLUMN(DATABASE_NAME, "int_armax", "INTEGER DEFAULT 100")
SQL_ADD_COLUMN(DATABASE_NAME, "int_arup", "INTEGER DEFAULT 0")
SQL_ADD_COLUMN(DATABASE_NAME, "int_st", "INTEGER DEFAULT 50")
SQL_ADD_COLUMN(DATABASE_NAME, "int_stmax", "INTEGER DEFAULT 100")
SQL_ADD_COLUMN(DATABASE_NAME, "float_stup", "INTEGER DEFAULT 1")
SQL_ADD_COLUMN(DATABASE_NAME, "float_stdn", "INTEGER DEFAULT 0.5")

SQL_ADD_COLUMN(DATABASE_NAME, "string_abart", "TEXT DEFAULT 'mana'")
SQL_ADD_COLUMN(DATABASE_NAME, "int_ab", "INTEGER DEFAULT 50")
SQL_ADD_COLUMN(DATABASE_NAME, "int_abmax", "INTEGER DEFAULT 1000")
SQL_ADD_COLUMN(DATABASE_NAME, "float_abup", "INTEGER DEFAULT 5")

SQL_ADD_COLUMN(DATABASE_NAME, "int_speedwalk", "INTEGER DEFAULT 150")
SQL_ADD_COLUMN(DATABASE_NAME, "int_speedrun", "INTEGER DEFAULT 240")
SQL_ADD_COLUMN(DATABASE_NAME, "int_powerjump", "INTEGER DEFAULT 200")
SQL_ADD_COLUMN(DATABASE_NAME, "int_prerole", "INTEGER DEFAULT 0")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_instructor", "INTEGER DEFAULT 0")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_removeable", "INTEGER DEFAULT 1")
SQL_ADD_COLUMN(DATABASE_NAME, "int_uses", "INTEGER DEFAULT 0")
SQL_ADD_COLUMN(DATABASE_NAME, "int_salarytime", "INTEGER DEFAULT 120")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_voiceglobal", "INTEGER DEFAULT 0")
SQL_ADD_COLUMN(DATABASE_NAME, "int_requireslevel", "INTEGER DEFAULT 1")

SQL_ADD_COLUMN(DATABASE_NAME, "bool_canbeagent", "INTEGER DEFAULT 0")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_iscivil", "INTEGER DEFAULT 0")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_visible", "INTEGER DEFAULT 1")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_locked", "INTEGER DEFAULT 0")

SQL_ADD_COLUMN(DATABASE_NAME, "string_licenses", "TEXT DEFAULT ''")

SQL_ADD_COLUMN(DATABASE_NAME, "string_customflags", "TEXT DEFAULT ''")

SQL_ADD_COLUMN(DATABASE_NAME, "int_position", "INTEGER DEFAULT 1")

if SQL_SELECT(DATABASE_NAME, "*", "uniqueID = 1") == nil then
	printGM("note", DATABASE_NAME .. " has not the default role")
	local _result = SQL_INSERT_INTO(DATABASE_NAME, "uniqueID, string_name, string_color, int_groupID, bool_removeable", "1, 'Civilian', '0,0,255', 1, 0")
end

SQL_UPDATE(DATABASE_NAME, "uses = 0", nil)

-- CONVERTING
if wk(SQL_SELECT("yrp_roles", "*", nil)) then
	local oldroles = SQL_SELECT("yrp_roles", "*", nil)
	for i, role in pairs(oldroles) do
		if tonumber(role.uniqueID) > 1 then
			local cols = "string_name,"
			cols = cols .. "string_description,"
			cols = cols .. "int_salary,"
			cols = cols .. "int_groupID,"
			cols = cols .. "string_sweps,"
			cols = cols .. "bool_voteable,"
			cols = cols .. "bool_adminonly,"
			cols = cols .. "bool_whitelist,"
			cols = cols .. "int_maxamount,"
			cols = cols .. "int_hp,"
			cols = cols .. "int_hpmax,"
			cols = cols .. "int_ar,"
			cols = cols .. "int_armax,"
			cols = cols .. "int_speedwalk,"
			cols = cols .. "int_speedrun,"
			cols = cols .. "int_powerjump,"
			cols = cols .. "int_prerole,"
			cols = cols .. "bool_instructor,"
			cols = cols .. "int_salarytime,"
			cols = cols .. "string_licenses"

			local vals = "'" .. role.roleID .. "', "
			vals = vals .. "'" .. role.description .. "', "
			vals = vals .. "'" .. role.salary .. "', "
			vals = vals .. "'" .. role.groupID .. "', "
			vals = vals .. "'" .. role.sweps .. "', "
			vals = vals .. "'" .. role.voteable .. "', "
			vals = vals .. "'" .. role.adminonly .. "', "
			vals = vals .. "'" .. role.whitelist .. "', "
			vals = vals .. "'" .. role.maxamount .. "', "
			vals = vals .. "'" .. role.hp .. "', "
			vals = vals .. "'" .. role.hpmax .. "', "
			vals = vals .. "'" .. role.ar .. "', "
			vals = vals .. "'" .. role.armax .. "', "
			vals = vals .. "'" .. role.speedwalk .. "', "
			vals = vals .. "'" .. role.speedrun .. "', "
			vals = vals .. "'" .. role.powerjump .. "', "
			vals = vals .. "'" .. role.prerole .. "', "
			vals = vals .. "'" .. role.instructor .. "', "
			vals = vals .. "'" .. role.salarytime ..  "', "
			vals = vals .. "'" .. role.licenseIDs .. "' "

			SQL_INSERT_INTO(DATABASE_NAME, cols, vals)
			SQL_DELETE_FROM("yrp_roles", "uniqueID = '" .. role.uniqueID .. "'")
		end
	end
end
-- CONVERTING

local yrp_ply_roles = {}
local _init_ply_roles = SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '1'")
if wk(_init_ply_roles) then
	yrp_ply_roles = _init_ply_roles[1]
end

local HANDLER_GROUPSANDROLES = {}
HANDLER_GROUPSANDROLES["roleslist"] = {}
HANDLER_GROUPSANDROLES["roles"] = {}

for str, val in pairs(yrp_ply_roles) do
	if string.find(str, "string_") then
		local tab = {}
		tab.netstr = "update_role_" .. str
		util.AddNetworkString(tab.netstr)
		net.Receive(tab.netstr, function(len, ply)
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
				local puid = SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '" .. uid .. "'")
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
				local puid = SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '" .. uid .. "'")
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
				local puid = SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '" .. uid .. "'")
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
	elseif string.find(str, "int_") then
		local tab = {}
		tab.netstr = "update_role_" .. str
		util.AddNetworkString(tab.netstr)
		net.Receive(tab.netstr, function(len, ply)
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
	elseif string.find(str, "float_") then
		local tab = {}
		tab.netstr = "update_role_" .. str
		util.AddNetworkString(tab.netstr)
		net.Receive(tab.netstr, function(len, ply)
			local uid = tonumber(net.ReadString())
			local float = tonumber(net.ReadString())
			local cur = SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '" .. uid .. "'")
			tab.ply = ply
			tab.id = str
			tab.value = float
			tab.db = DATABASE_NAME
			tab.uniqueID = uid
			UpdateFloat(tab)
			tab.handler = HANDLER_GROUPSANDROLES["roles"][tonumber(tab.uniqueID)]
			BroadcastFloat(tab)
			if tab.netstr == "update_float_parentrole" then
				if wk(cur) then
					cur = cur[1]
					SendGroupList(tonumber(cur.float_parentrole))
				end
				SendGroupList(float)
			end
		end)
	elseif string.find(str, "bool_") then
		local tab = {}
		tab.netstr = "update_role_" .. str
		util.AddNetworkString(tab.netstr)
		net.Receive(tab.netstr, function(len, ply)
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
	if !table.HasValue(HANDLER_GROUPSANDROLES["roleslist"][uid], ply) then
		table.insert(HANDLER_GROUPSANDROLES["roleslist"][uid], ply)
		printGM("gm", ply:YRPName() .. " subscribed to RoleList " .. uid)
	else
		printGM("gm", ply:YRPName() .. " already subscribed to RoleList " .. uid)
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
	if !table.HasValue(HANDLER_GROUPSANDROLES["roles"][uid], ply) then
		table.insert(HANDLER_GROUPSANDROLES["roles"][uid], ply)
		printGM("gm", ply:YRPName() .. " subscribed to Role " .. uid)
	else
		printGM("gm", ply:YRPName() .. " already subscribed to Role " .. uid)
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
	SortRoles(uid)

	local tbl_parentgroup = SQL_SELECT("yrp_ply_groups", "*", "uniqueID = '" .. uid .. "'")
	if !wk(tbl_parentgroup) then
		tbl_parentgroup = {}
	else
		tbl_parentgroup = tbl_parentgroup[1]
	end

	local tbl_roles = SQL_SELECT(DATABASE_NAME, "*", "int_groupID = '" .. uid .. "'")
	if !wk(tbl_roles) then
		tbl_roles = {}
	end
	local currentuid = uid
	local parentuid = SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '" .. uid .. "'")
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

-- Role menu
util.AddNetworkString("get_grp_roles")
net.Receive("get_grp_roles", function(len, ply)
	local _uid = net.ReadString()
	local _roles = SQL_SELECT(DATABASE_NAME, "*", "int_groupID = " .. _uid)
	if _roles != nil then
		net.Start("get_grp_roles")
			net.WriteTable(_roles)
		net.Send(ply)
	end
end)

util.AddNetworkString("get_rol_prerole")
net.Receive("get_rol_prerole", function(len, ply)
	local _uid = net.ReadString()
	local _roles = SQL_SELECT(DATABASE_NAME, "*", "int_prerole = " .. _uid)
	if _roles != nil then
		_roles = _roles[1]
		net.Start("get_rol_prerole")
			net.WriteTable(_roles)
		net.Send(ply)
	end
end)

-- Role Settings
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

	local groups = SQL_SELECT("yrp_ply_groups", "*", nil)

	net.Start("settings_subscribe_role")
		net.WriteTable(role)
		net.WriteTable(roles)
		net.WriteTable(usergroups)
		net.WriteTable(groups)
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

util.AddNetworkString("getScoreboardGroups")
net.Receive( "getScoreboardGroups", function( len, ply )
	local _tmpGroups = SQL_SELECT( "yrp_ply_groups", "*", nil )
	if wk(_tmpGroups) then
		net.Start( "getScoreboardGroups" )
			net.WriteTable( _tmpGroups )
		net.Broadcast()
	else
		printGM("note", "getScoreboardGroups failed!")
		pTab(_tmpGroups)
	end
end)

function GetRole(uid)
	local role = SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '" .. uid .. "'")
	if wk(role) then
		return role[1]
	end
	return nil
end

function SendCustomFlags(uid)
	local cf = SQL_SELECT("yrp_flags", "*", "type = 'role' AND int_uid = '" .. uid .. "'")
	if !wk(cf) then
		cf = {}
	end
	local role = GetRole(uid)
	if wk(role) then
		local nettab = {}
		local flags = string.Explode(",", role.string_customflags)
		for i, val in pairs(flags) do
			local flag = SQL_SELECT("yrp_flags", "*", "uniqueID = '" .. val .. "'")
			if wk(flag) then
				flag = flag[1]
				local entry = {}
				entry.uniqueID = flag.uniqueID
				entry.string_name = flag.string_name
				table.insert(nettab, entry)
			end
		end

		for i, pl in pairs(HANDLER_GROUPSANDROLES["roles"][uid]) do
			net.Start("get_role_customflags")
				net.WriteTable(nettab)
			net.Send(pl)
		end
	end
end

util.AddNetworkString("get_role_customflags")
net.Receive("get_role_customflags", function(len, ply)
	local uid = net.ReadInt(32)
	SendCustomFlags(uid)
end)

util.AddNetworkString("get_all_role_customflags")
net.Receive("get_all_role_customflags", function(len, ply)
	local allflags = SQL_SELECT("yrp_flags", "*", "string_type = 'role'")
	if !wk(allflags) then
		allflags = {}
	end
	net.Start("get_all_role_customflags")
		net.WriteTable(allflags)
	net.Send(ply)
end)

util.AddNetworkString("add_role_flag")
net.Receive("add_role_flag", function(len, ply)
	local ruid = net.ReadInt(32)
	local fuid = net.ReadInt(32)
	role = GetRole(ruid)

	local customflags = string.Explode(",", role.string_customflags)
	if !table.HasValue(customflags, tostring(fuid)) then
		local oldflags = {}
		for i, v in pairs(customflags) do
			if v != "" then
				table.insert(oldflags, v)
			end
		end

		local newflags = oldflags
		table.insert(newflags, fuid)
		newflags = string.Implode(",", newflags)

		SQL_UPDATE(DATABASE_NAME, "string_customflags = '" .. newflags .. "'", "uniqueID = '" .. ruid .. "'")
		SendCustomFlags(ruid)
	end
end)

util.AddNetworkString("rem_role_flag")
net.Receive("rem_role_flag", function(len, ply)
	local ruid = net.ReadInt(32)
	local fuid = net.ReadInt(32)
	role = GetRole(ruid)

	local customflags = string.Explode(",", role.string_customflags)
	local oldflags = {}
	for i, v in pairs(customflags) do
		if v != "" then
			table.insert(oldflags, v)
		end
	end

	local newflags = oldflags
	table.RemoveByValue(newflags, tostring(fuid))
	newflags = string.Implode(",", newflags)

	SQL_UPDATE(DATABASE_NAME, "string_customflags = '" .. newflags .. "'", "uniqueID = '" .. ruid .. "'")
	SendCustomFlags(ruid)
end)

function SendPlayermodels(uid)
	local role = GetRole(uid)
	if wk(role) then
		local nettab = {}
		local flags = string.Explode(",", role.string_playermodels)
		for i, val in pairs(flags) do
			local pm = SQL_SELECT("yrp_playermodels", "*", "uniqueID = '" .. val .. "'")
			if wk(pm) then
				pm = pm[1]
				local entry = {}
				entry.uniqueID = pm.uniqueID
				local name = pm.string_name
				if name == "" or  name == " " then
					name = pm.string_model
				end
				entry.string_name = name
				entry.string_model = pm.string_model
				table.insert(nettab, entry)
			end
		end

		for i, pl in pairs(HANDLER_GROUPSANDROLES["roles"][uid]) do
			net.Start("get_role_playermodels")
				net.WriteTable(nettab)
			net.Send(pl)
		end
	end
end

util.AddNetworkString("get_role_playermodels")
net.Receive("get_role_playermodels", function(len, ply)
	local uid = net.ReadInt(32)
	SendPlayermodels(uid)
end)

util.AddNetworkString("get_all_playermodels")
net.Receive("get_all_playermodels", function(len, ply)
	local allpms = SQL_SELECT("yrp_playermodels", "*", nil)
	if !wk(allpms) then
		allpms = {}
	end
	net.Start("get_all_playermodels")
		net.WriteTable(allpms)
	net.Send(ply)
end)

function AddPlayermodelToRole(ruid, muid)
	role = GetRole(ruid)
	local pms = string.Explode(",", role.string_playermodels)
	if !table.HasValue(pms, tostring(muid)) then
		local oldpms = {}
		for i, v in pairs(pms) do
			if v != "" and v != " " then
				table.insert(oldpms, v)
			end
		end

		local newpms = oldpms
		table.insert(newpms, tostring(muid))
		newpms = string.Implode(",", newpms)

		SQL_UPDATE(DATABASE_NAME, "string_playermodels = '" .. newpms .. "'", "uniqueID = '" .. ruid .. "'")
		SendPlayermodels(ruid)
	end
end

util.AddNetworkString("add_role_playermodel")
net.Receive("add_role_playermodel", function(len, ply)
	local ruid = net.ReadInt(32)
	local muid = net.ReadInt(32)

	AddPlayermodelToRole(ruid, muid)
end)

util.AddNetworkString("add_playermodel")
net.Receive("add_playermodel", function(len, ply)
	local ruid = net.ReadInt(32)
	local WorldModel = net.ReadString()
	SQL_INSERT_INTO("yrp_playermodels", "string_model", "'" .. WorldModel .. "'")

	local lastentry = SQL_SELECT("yrp_playermodels", "*", nil)
	lastentry = lastentry[table.Count(lastentry)]
	AddPlayermodelToRole(ruid, lastentry.uniqueID)
end)

function RemPlayermodelFromRole(ruid, muid)
	role = GetRole(ruid)
	local pms = string.Explode(",", role.string_playermodels)
	local oldpms = {}
	for i, v in pairs(pms) do
		if v != "" and v != " " then
			table.insert(oldpms, v)
		end
	end

	local newpms = oldpms
	table.RemoveByValue(newpms, tostring(muid))
	newpms = string.Implode(",", newpms)

	SQL_UPDATE(DATABASE_NAME, "string_playermodels = '" .. newpms .. "'", "uniqueID = '" .. ruid .. "'")
	SendPlayermodels(ruid)
end

util.AddNetworkString("rem_role_playermodel")
net.Receive("rem_role_playermodel", function(len, ply)
	local ruid = net.ReadInt(32)
	local muid = net.ReadInt(32)

	RemPlayermodelFromRole(ruid, muid)
end)

function SendSweps(uid)
	local role = GetRole(uid)
	if wk(role) then
		local nettab = {}
		local sweps = string.Explode(",", role.string_sweps)
		for i, swep in pairs(sweps) do
			if swep != "" and swep != " " then
				table.insert(nettab, swep)
			end
		end

		for i, pl in pairs(HANDLER_GROUPSANDROLES["roles"][uid]) do
			net.Start("get_role_sweps")
				net.WriteTable(nettab)
			net.Send(pl)
		end
	end
end

util.AddNetworkString("get_role_sweps")
net.Receive("get_role_sweps", function(len, ply)
	local uid = net.ReadInt(32)
	SendSweps(uid)
end)

function AddSwepToRole(ruid, swepcn)
	role = GetRole(ruid)
	local sweps = string.Explode(",", role.string_sweps)
	if !table.HasValue(sweps, tostring(swepcn)) then
		local oldsweps = {}
		for i, v in pairs(sweps) do
			if v != "" and v != " " then
				table.insert(oldsweps, v)
			end
		end

		local newsweps = oldsweps
		table.insert(newsweps, tostring(swepcn))
		newsweps = string.Implode(",", newsweps)

		SQL_UPDATE(DATABASE_NAME, "string_sweps = '" .. newsweps .. "'", "uniqueID = '" .. ruid .. "'")
		SendSweps(ruid)
	end
end

util.AddNetworkString("add_role_swep")
net.Receive("add_role_swep", function(len, ply)
	local ruid = net.ReadInt(32)
	local swepcn = net.ReadString()

	AddSwepToRole(ruid, swepcn)
end)

function RemSwepFromRole(ruid, swepcn)
	role = GetRole(ruid)
	local sweps = string.Explode(",", role.string_sweps)
	local oldsweps = {}
	for i, v in pairs(sweps) do
		if v != "" and v != " " then
			table.insert(oldsweps, v)
		end
	end

	local newsweps = oldsweps
	table.RemoveByValue(newsweps, tostring(swepcn))
	newsweps = string.Implode(",", newsweps)

	SQL_UPDATE(DATABASE_NAME, "string_sweps = '" .. newsweps .. "'", "uniqueID = '" .. ruid .. "'")
	SendSweps(ruid)
end

util.AddNetworkString("rem_role_swep")
net.Receive("rem_role_swep", function(len, ply)
	local ruid = net.ReadInt(32)
	local swepcn = net.ReadString()

	RemSwepFromRole(ruid, swepcn)
end)

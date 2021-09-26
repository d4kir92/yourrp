--Copyright (C) 2017-2021 D4KiR (https://www.gnu.org/licenses/gpl.txt)

-- DO NOT TOUCH THE DATABASE FILES! If you have errors, report them here:
-- https://discord.gg/sEgNZxg

local DATABASE_NAME = "yrp_ply_groups"

SQL_ADD_COLUMN(DATABASE_NAME, "string_name", "TEXT DEFAULT 'GroupName'")
SQL_ADD_COLUMN(DATABASE_NAME, "string_description", "TEXT DEFAULT '-'")
SQL_ADD_COLUMN(DATABASE_NAME, "string_color", "TEXT DEFAULT '0,0,0'")
SQL_ADD_COLUMN(DATABASE_NAME, "string_usergroups", "TEXT DEFAULT 'ALL'")
SQL_ADD_COLUMN(DATABASE_NAME, "string_icon", "TEXT DEFAULT 'http://www.famfamfam.com/lab/icons/silk/icons/group.png'")
SQL_ADD_COLUMN(DATABASE_NAME, "string_sweps", "TEXT DEFAULT ''")
SQL_ADD_COLUMN(DATABASE_NAME, "string_ents", "TEXT DEFAULT ''")
SQL_ADD_COLUMN(DATABASE_NAME, "string_ammos", "TEXT DEFAULT ''")

SQL_ADD_COLUMN(DATABASE_NAME, "int_parentgroup", "INTEGER DEFAULT 0")
SQL_ADD_COLUMN(DATABASE_NAME, "int_requireslevel", "INTEGER DEFAULT 1")
SQL_ADD_COLUMN(DATABASE_NAME, "int_position", "INTEGER DEFAULT 0")

SQL_ADD_COLUMN(DATABASE_NAME, "bool_whitelist", "INTEGER DEFAULT 0")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_visible_cc", "INTEGER DEFAULT 1")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_visible_rm", "INTEGER DEFAULT 1")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_locked", "INTEGER DEFAULT 0")

SQL_ADD_COLUMN(DATABASE_NAME, "bool_iscp", "INTEGER DEFAULT 0")

SQL_ADD_COLUMN(DATABASE_NAME, "bool_removeable", "INTEGER DEFAULT 1")

-- PUBLIC GROUP
if SQL_SELECT(DATABASE_NAME, "*", "uniqueID = -1") == nil then
	local _result = SQL_INSERT_INTO(DATABASE_NAME, "uniqueID, string_name, string_color, int_parentgroup, bool_removeable, bool_locked, bool_visible_rm, bool_visible_cc", "-1, 'PUBLIC', '255,255,255', -1, 0, 0, 0, 0")
end
SQL_UPDATE(DATABASE_NAME, {["int_parentgroup"] = -1}, "uniqueID = '-1'")
SQL_DELETE_FROM(DATABASE_NAME, "uniqueID = '0'")

-- DEFAULT GROUP
if SQL_SELECT(DATABASE_NAME, "*", "uniqueID = 1") == nil then
	YRP.msg("note", DATABASE_NAME .. " has not the default group")
	local _result = SQL_INSERT_INTO(DATABASE_NAME, "uniqueID, string_name, string_color, int_parentgroup, bool_removeable", "'1', 'Civilians', '0,0,255', '0', '0'")
end

local dbtab = SQL_SELECT(DATABASE_NAME, "*", nil)
if dbtab then
	for i, v in pairs(SQL_SELECT(DATABASE_NAME, "*", nil)) do
		v.uniqueID = tonumber(v.uniqueID)
		v.int_parentgroup = tonumber(v.int_parentgroup)
		if v.uniqueID != -1 and v.int_parentgroup == v.uniqueID then
			SQL_UPDATE(DATABASE_NAME, {["int_parentgroup"] = 0}, "uniqueID = '" .. v.uniqueID .. "'")
		end
	end
end
--db_drop_table(DATABASE_NAME)

-- Local Table
local yrp_ply_groups = {}
local _init_ply_groups = SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '1'")
if wk(_init_ply_groups) then
	yrp_ply_groups = _init_ply_groups[1]
end

local HANDLER_GROUPSANDROLES = {}
HANDLER_GROUPSANDROLES["groupslist"] = {}
HANDLER_GROUPSANDROLES["groups"] = {}
HANDLER_GROUPSANDROLES["roles"] = {}

-- Network Things
for str, val in pairs(yrp_ply_groups) do
	if string.find(str, "string_") then
		local tab = {}
		tab.netstr = "update_group_" .. str
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
			tab.handler = HANDLER_GROUPSANDROLES["groups"][tonumber(tab.uniqueID)]
			BroadcastString(tab)
			if tab.netstr == "update_group_string_name" then
				util.AddNetworkString("settings_group_update_name")
				local puid = SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '" .. uid .. "'")
				if wk(puid) then
					puid = puid[1]
					tab.handler = HANDLER_GROUPSANDROLES["groupslist"][tonumber(puid.int_parentgroup)]
					tab.netstr = "settings_group_update_name"
					tab.uniqueID = tonumber(puid.uniqueID)
					tab.force = true
					BroadcastString(tab)
				end
			elseif tab.netstr == "update_group_string_color" then
				util.AddNetworkString("settings_group_update_color")
				local puid = SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '" .. uid .. "'")
				if wk(puid) then
					puid = puid[1]
					tab.handler = HANDLER_GROUPSANDROLES["groupslist"][tonumber(puid.int_parentgroup)]
					tab.netstr = "settings_group_update_color"
					tab.uniqueID = tonumber(puid.uniqueID)
					tab.force = true
					BroadcastString(tab)
				end
			elseif tab.netstr == "update_group_string_icon" then
				util.AddNetworkString("settings_group_update_icon")
				local puid = SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '" .. uid .. "'")
				if wk(puid) then
					puid = puid[1]
					tab.handler = HANDLER_GROUPSANDROLES["groupslist"][tonumber(puid.int_parentgroup)]
					tab.netstr = "settings_group_update_icon"
					tab.uniqueID = tonumber(puid.uniqueID)
					tab.force = true
					BroadcastString(tab)
				end
			end
		end)
	elseif string.find(str, "int_") then
		local tab = {}
		tab.netstr = "update_group_" .. str
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
			tab.handler = HANDLER_GROUPSANDROLES["groups"][tonumber(tab.uniqueID)]
			BroadcastInt(tab)
			if tab.netstr == "update_group_int_parentgroup" then
				if wk(cur) then
					cur = cur[1]
					SendGroupList(tonumber(cur.int_parentgroup))
				end
				SendGroupList(int)
			end
		end)
	elseif string.find(str, "bool_") then
		local tab = {}
		tab.netstr = "update_group_" .. str
		util.AddNetworkString(tab.netstr)
		net.Receive(tab.netstr, function(len, ply)
			local uid = tonumber(net.ReadString())
			local bool = tonumber(net.ReadString())
			tab.ply = ply
			tab.id = str
			tab.value = bool
			tab.db = DATABASE_NAME
			tab.uniqueID = uid
			UpdateBool(tab)
			tab.handler = HANDLER_GROUPSANDROLES["groups"][tonumber(tab.uniqueID)]
			BroadcastBool(tab)
		end)
	end
end

function RemFromHandler_GroupsAndRoles(ply)
	table.RemoveByValue(HANDLER_GROUPSANDROLES, ply)
end

function AddToHandler_GroupsAndRoles(ply)
	if !table.HasValue(HANDLER_GROUPSANDROLES, ply) then
		table.insert(HANDLER_GROUPSANDROLES, ply)
	end
end

function SubscribeGroupList(ply, uid)
	if HANDLER_GROUPSANDROLES["groupslist"][uid] == nil then
		HANDLER_GROUPSANDROLES["groupslist"][uid] = {}
	end
	if !table.HasValue(HANDLER_GROUPSANDROLES["groupslist"][uid], ply) then
		table.insert(HANDLER_GROUPSANDROLES["groupslist"][uid], ply)
	end
end

function UnsubscribeGroupList(ply, uid)
	if HANDLER_GROUPSANDROLES["groupslist"][uid] == nil then
		HANDLER_GROUPSANDROLES["groupslist"][uid] = {}
	end
	if table.HasValue(HANDLER_GROUPSANDROLES["groupslist"][uid], ply) then
		table.RemoveByValue(HANDLER_GROUPSANDROLES["groupslist"][uid], ply)
	end
end

function SubscribeGroup(ply, uid)
	if HANDLER_GROUPSANDROLES["groups"][uid] == nil then
		HANDLER_GROUPSANDROLES["groups"][uid] = {}
	end
	if !table.HasValue(HANDLER_GROUPSANDROLES["groups"][uid], ply) then
		table.insert(HANDLER_GROUPSANDROLES["groups"][uid], ply)
	end
end

function UnsubscribeGroup(ply, uid)
	if HANDLER_GROUPSANDROLES["groups"][uid] == nil then
		HANDLER_GROUPSANDROLES["groups"][uid] = {}
	end
	if table.HasValue(HANDLER_GROUPSANDROLES["groups"][uid], ply) then
		table.RemoveByValue(HANDLER_GROUPSANDROLES["groups"][uid], ply)
	end
end

util.AddNetworkString("Subscribe_Settings_GroupsAndRoles")
net.Receive("Subscribe_Settings_GroupsAndRoles", function(len, ply)
	if ply:CanAccess("bool_groupsandroles") then
		AddToHandler_GroupsAndRoles(ply)

		net.Start("Subscribe_Settings_GroupsAndRoles")
		net.Send(ply)
	end
end)

util.AddNetworkString("Unsubscribe_Settings_GroupsAndRoles")
net.Receive("Unsubscribe_Settings_GroupsAndRoles", function(len, ply)
	RemFromHandler_GroupsAndRoles(ply)
	local cur = tonumber(net.ReadString())
	UnsubscribeGroup(ply, cur)
end)

function SortGroups(uid)
	local siblings = SQL_SELECT(DATABASE_NAME, "*", "int_parentgroup = '" .. uid .. "'")

	if wk(siblings) then
		for i, sibling in pairs(siblings) do
			sibling.int_position = tonumber(sibling.int_position)
		end

		local count = 0
		for i, sibling in SortedPairsByMemberValue(siblings, "int_position", false) do
			count = count + 1
			SQL_UPDATE(DATABASE_NAME, {["int_position"] = count}, "uniqueID = '" .. sibling.uniqueID .. "'")
		end
	end
end

function SendGroupList(uid)
	uid = tonumber(uid)
	SortGroups(uid)

	local tbl_parentgroup = SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '" .. uid .. "'")
	if !wk(tbl_parentgroup) or uid < 1 then
		tbl_parentgroup = {}
	else
		tbl_parentgroup = tbl_parentgroup[1]
	end

	local tbl_groups = SQL_SELECT(DATABASE_NAME, "*", "int_parentgroup = '" .. uid .. "'")
	if !wk(tbl_groups) then
		tbl_groups = {}
	end
	local currentuid = uid
	local parentuid = SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '" .. uid .. "'")
	if wk(parentuid) then
		parentuid = parentuid[1].int_parentgroup
	else
		parentuid = 0
	end

	HANDLER_GROUPSANDROLES["groupslist"][uid] = HANDLER_GROUPSANDROLES["groupslist"][uid] or {}
	for i, pl in pairs(HANDLER_GROUPSANDROLES["groupslist"][uid]) do
		net.Start("settings_subscribe_grouplist")
			net.WriteTable(tbl_parentgroup)
			net.WriteTable(tbl_groups)
			net.WriteString(currentuid)
			net.WriteString(parentuid)
		net.Send(pl)
	end
end

-- Duplicate
function DuplicateGroup(guid)
	guid = tonumber(guid)
	local group = SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '" .. guid .. "'")
	if wk(group) then
		group = group[1]

		local cols = {}
		local vals = {}
		for name, value in pairs(group) do
			if name != "uniqueID" and name != "int_removeable" then
				table.insert(cols, name)
				table.insert(vals, "'" .. value .. "'")
			end
		end

		cols = table.concat(cols, ", ")
		vals = table.concat(vals, ", ")

		SQL_INSERT_INTO(DATABASE_NAME, cols, vals)
		local last = SQL_SELECT(DATABASE_NAME, "*", nil)
		last = last[table.Count(last)]

		local roles = SQL_SELECT("yrp_ply_roles", "*", "int_groupID = '" .. guid .. "'")
		if wk(roles) then
			for i, role in pairs(roles) do
				DuplicateRole(role.uniqueID, last.uniqueID)
			end
		end

		SendGroupList(group.int_parentgroup)
	else
		YRP.msg("note", "Group [" .. guid .. "] was deleted.")
	end
end

util.AddNetworkString("duplicated_group")
net.Receive("duplicated_group", function(len, ply)
	local guid = tonumber(net.ReadString())
	DuplicateGroup(guid)
end)


util.AddNetworkString("settings_subscribe_grouplist")
net.Receive("settings_subscribe_grouplist", function(len, ply)
	local par = tonumber(net.ReadString())
	SubscribeGroupList(ply, par)
	SendGroupList(par)
end)

util.AddNetworkString("settings_add_group")
net.Receive("settings_add_group", function(len, ply)
	local uid = tonumber(net.ReadString())
	SQL_INSERT_INTO(DATABASE_NAME, "int_parentgroup", "'" .. uid .. "'")

	local groups = SQL_SELECT(DATABASE_NAME, "*", "int_parentgroup = '" .. uid .. "'")

	local count = tonumber(table.Count(groups))
	local new_group = groups[count]
	local up = groups[count - 1]
	if count == 1 then
		SQL_UPDATE(DATABASE_NAME, {["int_position"] = count}, "uniqueID = '" .. new_group.uniqueID .. "'")
	else
		SQL_UPDATE(DATABASE_NAME, {["int_position"] = count}, "uniqueID = '" .. new_group.uniqueID .. "'")
		--SQL_UPDATE(DATABASE_NAME, {["int_dn"] = '" .. new_group.uniqueID .. "'", "uniqueID = '" .. up.uniqueID .. "'")
	end

	YRP.msg("db", "Added new group: " .. new_group.uniqueID)

	SendGroupList(uid)
end)

util.AddNetworkString("settings_group_position_up")
net.Receive("settings_group_position_up", function(len, ply)
	local uid = tonumber(net.ReadString())
	local group = SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '" .. uid .. "'")
	group = group[1]

	group.int_position = tonumber(group.int_position)

	local siblings = SQL_SELECT(DATABASE_NAME, "*", "int_parentgroup = '" .. group.int_parentgroup .. "'")

	for i, sibling in pairs(siblings) do
		sibling.int_position = tonumber(sibling.int_position)
	end

	local count = 0
	for i, sibling in SortedPairsByMemberValue(siblings, "int_position", false) do
		count = count + 1
		if tonumber(sibling.int_position) == group.int_position - 1 then
			SQL_UPDATE(DATABASE_NAME, {["int_position"] = group.int_position}, "uniqueID = '" .. sibling.uniqueID .. "'")
			SQL_UPDATE(DATABASE_NAME, {["int_position"] = sibling.int_position}, "uniqueID = '" .. uid .. "'")
		end
	end

	group.int_parentgroup = tonumber(group.int_parentgroup)
	SendGroupList(group.int_parentgroup)
end)

util.AddNetworkString("settings_group_position_dn")
net.Receive("settings_group_position_dn", function(len, ply)
	local uid = tonumber(net.ReadString())
	local group = SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '" .. uid .. "'")
	group = group[1]

	group.int_position = tonumber(group.int_position)

	local siblings = SQL_SELECT(DATABASE_NAME, "*", "int_parentgroup = '" .. group.int_parentgroup .. "'")

	for i, sibling in pairs(siblings) do
		sibling.int_position = tonumber(sibling.int_position)
	end

	local count = 0
	for i, sibling in SortedPairsByMemberValue(siblings, "int_position", false) do
		count = count + 1
		if tonumber(sibling.int_position) == group.int_position + 1 then
			SQL_UPDATE(DATABASE_NAME, {["int_position"] = group.int_position}, "uniqueID = '" .. sibling.uniqueID .. "'")
			SQL_UPDATE(DATABASE_NAME, {["int_position"] = sibling.int_position}, "uniqueID = '" .. uid .. "'")
		end
	end

	group.int_parentgroup = tonumber(group.int_parentgroup)
	SendGroupList(group.int_parentgroup)
end)

util.AddNetworkString("settings_subscribe_group")
net.Receive("settings_subscribe_group", function(len, ply)
	local uid = tonumber(net.ReadString())
	SubscribeGroup(ply, uid)

	local group = SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '" .. uid .. "'")
	if !wk(group) then
		group = {}
	else
		group = group[1]
	end

	local groups = SQL_SELECT(DATABASE_NAME, "string_name, uniqueID", nil)

	local usergroups = SQL_SELECT("yrp_usergroups", "*", nil)

	net.Start("settings_subscribe_group")
		net.WriteTable(group)
		net.WriteTable(groups)
		net.WriteTable(usergroups)
	net.Send(ply)
end)

util.AddNetworkString("settings_unsubscribe_group")
net.Receive("settings_unsubscribe_group", function(len, ply)
	local uid = tonumber(net.ReadString())
	UnsubscribeGroup(ply, uid)
end)

util.AddNetworkString("settings_unsubscribe_grouplist")
net.Receive("settings_unsubscribe_grouplist", function(len, ply)
	local uid = tonumber(net.ReadString())
	UnsubscribeGroupList(ply, uid)
end)

function RemoveUnusedGroups()
	local count = 0
	local all_groups = SQL_SELECT("yrp_ply_groups", "*", nil)
	for i, grp in pairs(all_groups) do
		grp.int_parentgroup = tonumber(grp.int_parentgroup)
		if grp.int_parentgroup > 0 then
			local parentgroup = SQL_SELECT("yrp_ply_groups", "*", "uniqueID = '" .. grp.int_parentgroup .. "'")
			if parentgroup == nil then
				count = count + 1
				SQL_DELETE_FROM("yrp_ply_groups", "uniqueID = '" .. grp.uniqueID .. "'")
			end
		end
	end
	if count > 0 then
		RemoveUnusedGroups()
	end
end

function RemoveUnusedRoles()
	local count = 0
	local all_roles = SQL_SELECT("yrp_ply_roles", "*", nil)
	for i, rol in pairs(all_roles) do
		rol.int_groupID = tonumber(rol.int_groupID)
		if rol.int_groupID > 0 then
			local group = SQL_SELECT("yrp_ply_groups", "*", "uniqueID = '" .. rol.int_groupID .. "'")
			if group == nil then
				count = count + 1
				SQL_DELETE_FROM("yrp_ply_roles", "uniqueID = '" .. rol.uniqueID .. "'")
			end
		end
	end
	if count > 0 then
		RemoveUnusedRoles()
	end
end

function DeleteGroup(guid, recursive)
	local group = SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '" .. guid .. "'")
	if wk(group) then
		group = group[1]
		SQL_DELETE_FROM(DATABASE_NAME, "uniqueID = '" .. guid .. "'")

		if recursive then
			-- Delete Groups Recursive
			RemoveUnusedGroups()

			-- Delete Roles Recursive
			RemoveUnusedRoles()
		else
			-- Position richtig anordnen
			local siblings = SQL_SELECT(DATABASE_NAME, "*", "int_parentgroup = '" .. group.int_parentgroup .. "'")
			if wk(siblings) then
				for i, sibling in pairs(siblings) do
					sibling.int_position = tonumber(sibling.int_position)
				end
				local count = 0
				for i, sibling in SortedPairsByMemberValue(siblings, "int_position", false) do
					count = count + 1
					SQL_UPDATE(DATABASE_NAME, {["int_position"] = count}, "uniqueID = '" .. sibling.uniqueID .. "'")
				end
			end
		end

		MoveUnusedGroups()
		MoveUnusedRolesToDefault()

		group.int_parentgroup = tonumber(group.int_parentgroup) or 1
		SendGroupList(group.int_parentgroup)
	end
end

util.AddNetworkString("settings_delete_group")
net.Receive("settings_delete_group", function(len, ply)
	local guid = tonumber(net.ReadString())
	local recursive = net.ReadBool()
	DeleteGroup(guid, recursive)
end)

util.AddNetworkString("get_grps")
net.Receive("get_grps", function(len, ply)
	local _uid = tonumber(net.ReadString())

	local _get_grps = SQL_SELECT("yrp_ply_groups", "*", "int_parentgroup = " .. _uid)
	if wk(_get_grps) then
		net.Start("get_grps")
			net.WriteTable(_get_grps)
		net.Send(ply)
	end
end)

function GetGroupTable(gid)
	local result = SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '" .. gid .. "'")
	if wk(result) then
		result = result[1]
	end
	return result
end

-- Faction Selection
util.AddNetworkString("yrp_factionselection_getfactions")
net.Receive("yrp_factionselection_getfactions", function(len, ply)
	local dbtab = SQL_SELECT(DATABASE_NAME, "uniqueID, string_icon, string_name, string_description, bool_visible_cc, bool_visible_rm", "int_parentgroup = '0'")

	local nettab = {}
	if wk(dbtab) then
		nettab = dbtab
	end

	net.Start("yrp_factionselection_getfactions")
		net.WriteTable(nettab)
	net.Send(ply)
end)

util.AddNetworkString("yrp_roleselection_getgroups")
net.Receive("yrp_roleselection_getgroups", function(len, ply)
	local fuid = net.ReadString()
	local dbtab = SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '" .. fuid .. "'")

	local nettab = {}
	if wk(dbtab) then
		nettab = dbtab
	end

	local factioncount = 0
	local fatab = SQL_SELECT(DATABASE_NAME, "*", "int_parentgroup = '" .. 0 .. "'")

	if wk(fatab) then
		for i, v in pairs(fatab) do
			factioncount = factioncount + 1
		end
	end

	net.Start("yrp_roleselection_getgroups")
		net.WriteTable(nettab)
		net.WriteString(factioncount)
	net.Send(ply)
end)

util.AddNetworkString("yrp_roleselection_getcontent")
net.Receive("yrp_roleselection_getcontent", function(len, ply)
	local guid = net.ReadString()
	local roltab = SQL_SELECT("yrp_ply_roles", "*", "int_groupID = '" .. guid .. "'")
	local grptab = SQL_SELECT(DATABASE_NAME, "*", "int_parentgroup = '" .. guid .. "'")
	
	if wk(roltab) then
		for i, v in pairs(roltab) do
			v.pms = GetPlayermodelsOfRole(v.uniqueID)
			updateRoleUses(v.uniqueID)
		end
	end

	if wk(roltab) and wk(grptab) then
		net.Start("yrp_roleselection_getcontent")
			net.WriteTable(roltab)
			net.WriteTable(grptab)
		net.Send(ply)
	elseif !wk(roltab) and wk(grptab) then
		net.Start("yrp_roleselection_getcontent")
			net.WriteTable({})
			net.WriteTable(grptab)
		net.Send(ply)
	elseif !wk(grptab) and wk(roltab) then
		net.Start("yrp_roleselection_getcontent")
			net.WriteTable(roltab)
			net.WriteTable({})
		net.Send(ply)
	else
		YRP.msg("note", "[yrp_roleselection_getcontent] Roles and Groups not exists anymore")
	end
end)

util.AddNetworkString("yrp_roleselection_getrole")
net.Receive("yrp_roleselection_getrole", function(len, ply)
	local ruid = net.ReadString()
	local roltab = SQL_SELECT("yrp_ply_roles", "*", "uniqueID = '" .. ruid .. "'")
	if wk(roltab) then
		for i, v in pairs(roltab) do
			v.pms = GetPlayermodelsOfRole(v.uniqueID)
		end
		roltab = roltab[1]

		net.Start("yrp_roleselection_getrole")
			net.WriteTable(roltab)
		net.Send(ply)
	else
		YRP.msg("error", "[yrp_roleselection_getrole] ruid not valid: " .. tostring(ruid))
	end
end)

util.AddNetworkString("yrp_char_getrole")
net.Receive("yrp_char_getrole", function(len, ply)
	local ruid = net.ReadString()
	local roltab = SQL_SELECT("yrp_ply_roles", "*", "uniqueID = '" .. ruid .. "'")
	
	if wk(roltab) then
		for i, v in pairs(roltab) do
			v.pms = GetPlayermodelsOfRole(v.uniqueID)
		end
		roltab = roltab[1]

		net.Start("yrp_char_getrole")
			net.WriteTable(roltab)
		net.Send(ply)
	else
		YRP.msg("error", "[yrp_char_getrole] ruid not valid: " .. tostring(ruid))
	end
end)



-- SWEPS
function GetGroup(uid)
	local group = SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '" .. uid .. "'")
	if wk(group) then
		return group[1]
	end
	return nil
end

function SendSwepsGroup(uid)
	local group = GetGroup(uid)
	if wk(group) then
		local nettab = {}
		local sweps = string.Explode(",", group.string_sweps)
		for i, swep in pairs(sweps) do
			if !strEmpty(swep) then
				table.insert(nettab, swep)
			end
		end

		if HANDLER_GROUPSANDROLES["groups"][uid] == nil then
			HANDLER_GROUPSANDROLES["groups"][uid] = {}
		end

		for i, pl in pairs(HANDLER_GROUPSANDROLES["groups"][uid]) do
			net.Start("get_group_sweps")
				net.WriteTable(nettab)
			net.Send(pl)
		end
	end
end

util.AddNetworkString("get_group_sweps")
net.Receive("get_group_sweps", function(len, ply)
	local uid = net.ReadInt(32)
	SendSwepsGroup(uid)
end)

function AddSwepToGroup(guid, swepcn)
	local group = GetGroup(guid)
	if wk(group) then
		local sweps = string.Explode(",", group.string_sweps)
		if !table.HasValue(sweps, tostring(swepcn)) then
			local oldsweps = {}
			for i, v in pairs(sweps) do
				if !strEmpty(v) then
					table.insert(oldsweps, v)
				end
			end

			local newsweps = oldsweps
			table.insert(newsweps, tostring(swepcn))
			newsweps = string.Implode(",", newsweps)

			SQL_UPDATE(DATABASE_NAME, {["string_sweps"] = newsweps}, "uniqueID = '" .. guid .. "'")
			SendSwepsGroup(guid)
		end
	end
end

util.AddNetworkString("add_group_swep")
net.Receive("add_group_swep", function(len, ply)
	local guid = net.ReadInt(32)
	local swepcn = net.ReadString()

	AddSwepToGroup(guid, swepcn)
end)

function RemSwepFromGroup(guid, swepcn)
	local group = GetGroup(guid)
	local sweps = string.Explode(",", group.string_sweps)
	local oldsweps = {}
	for i, v in pairs(sweps) do
		if !strEmpty(v) then
			table.insert(oldsweps, v)
		end
	end

	local newsweps = oldsweps
	table.RemoveByValue(newsweps, tostring(swepcn))
	newsweps = string.Implode(",", newsweps)

	SQL_UPDATE(DATABASE_NAME, {["string_sweps"] = newsweps}, "uniqueID = '" .. guid .. "'")
	SendSwepsGroup(guid)
end

util.AddNetworkString("rem_group_swep")
net.Receive("rem_group_swep", function(len, ply)
	local guid = net.ReadInt(32)
	local swepcn = net.ReadString()

	RemSwepFromGroup(guid, swepcn)
end)
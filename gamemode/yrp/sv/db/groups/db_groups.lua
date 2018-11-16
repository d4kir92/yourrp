--Copyright (C) 2017-2018 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

-- DO NOT TOUCH THE DATABASE FILES! If you have errors, report them here:
-- https://discord.gg/sEgNZxg

local DATABASE_NAME = "yrp_ply_groups"

SQL_ADD_COLUMN(DATABASE_NAME, "string_name", "TEXT DEFAULT 'GroupName'")
SQL_ADD_COLUMN(DATABASE_NAME, "string_color", "TEXT DEFAULT '0,0,0'")
SQL_ADD_COLUMN(DATABASE_NAME, "string_usergroups", "TEXT DEFAULT 'ALL'")
SQL_ADD_COLUMN(DATABASE_NAME, "string_icon", "TEXT DEFAULT 'http://www.famfamfam.com/lab/icons/silk/icons/group.png'")
SQL_ADD_COLUMN(DATABASE_NAME, "string_sweps", "TEXT DEFAULT ''")
SQL_ADD_COLUMN(DATABASE_NAME, "string_ents", "TEXT DEFAULT ''")

SQL_ADD_COLUMN(DATABASE_NAME, "int_parentgroup", "INTEGER DEFAULT 0")
SQL_ADD_COLUMN(DATABASE_NAME, "int_requireslevel", "INTEGER DEFAULT 1")
SQL_ADD_COLUMN(DATABASE_NAME, "int_position", "INTEGER DEFAULT 0")

SQL_ADD_COLUMN(DATABASE_NAME, "bool_whitelist", "INTEGER DEFAULT 0")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_groupvoicechat", "INTEGER DEFAULT 1")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_visible", "INTEGER DEFAULT 1")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_locked", "INTEGER DEFAULT 0")

SQL_ADD_COLUMN(DATABASE_NAME, "bool_removeable", "INTEGER DEFAULT 1")

if SQL_SELECT(DATABASE_NAME, "*", "uniqueID = 1") == nil then
	printGM("note", DATABASE_NAME .. " has not the default group")
	local _result = SQL_INSERT_INTO(DATABASE_NAME, "uniqueID, string_name, string_color, int_parentgroup, bool_removeable", "1, 'Civilians', '0,0,255', 0, 0")
end

--db_drop_table(DATABASE_NAME)

local yrp_ply_groups = {}
local _init_ply_groups = SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '1'")
if wk(_init_ply_groups) then
	yrp_ply_groups = _init_ply_groups[1]
end

local HANDLER_GROUPSANDROLES = {}
HANDLER_GROUPSANDROLES["groupslist"] = {}
HANDLER_GROUPSANDROLES["groups"] = {}
HANDLER_GROUPSANDROLES["roles"] = {}

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
	end
end

function RemFromHandler_GroupsAndRoles(ply)
	table.RemoveByValue(HANDLER_GROUPSANDROLES, ply)
	printGM("gm", ply:YRPName() .. " unsubscribed from GroupsAndRoles")
end

function AddToHandler_GroupsAndRoles(ply)
	if !table.HasValue(HANDLER_GROUPSANDROLES, ply) then
		table.insert(HANDLER_GROUPSANDROLES, ply)
		printGM("gm", ply:YRPName() .. " subscribed to GroupsAndRoles")
	else
		printGM("gm", ply:YRPName() .. " already subscribed to GroupsAndRoles")
	end
end

function SubscribeGroupList(ply, uid)
	if HANDLER_GROUPSANDROLES["groupslist"][uid] == nil then
		HANDLER_GROUPSANDROLES["groupslist"][uid] = {}
	end
	if !table.HasValue(HANDLER_GROUPSANDROLES["groupslist"][uid], ply) then
		table.insert(HANDLER_GROUPSANDROLES["groupslist"][uid], ply)
		printGM("gm", ply:YRPName() .. " subscribed to GroupList " .. uid)
	else
		printGM("gm", ply:YRPName() .. " already subscribed to GroupList " .. uid)
	end
end

function UnsubscribeGroupList(ply, uid)
	if HANDLER_GROUPSANDROLES["groupslist"][uid] == nil then
		HANDLER_GROUPSANDROLES["groupslist"][uid] = {}
	end
	if table.HasValue(HANDLER_GROUPSANDROLES["groupslist"][uid], ply) then
		table.RemoveByValue(HANDLER_GROUPSANDROLES["groupslist"][uid], ply)
		printGM("gm", ply:YRPName() .. " unsubscribed from GroupList " .. uid)
	end
end

function SubscribeGroup(ply, uid)
	if HANDLER_GROUPSANDROLES["groups"][uid] == nil then
		HANDLER_GROUPSANDROLES["groups"][uid] = {}
	end
	if !table.HasValue(HANDLER_GROUPSANDROLES["groups"][uid], ply) then
		table.insert(HANDLER_GROUPSANDROLES["groups"][uid], ply)
		printGM("gm", ply:YRPName() .. " subscribed to Group " .. uid)
	else
		printGM("gm", ply:YRPName() .. " already subscribed to Group " .. uid)
	end
end

function UnsubscribeGroup(ply, uid)
	if HANDLER_GROUPSANDROLES["groups"][uid] == nil then
		HANDLER_GROUPSANDROLES["groups"][uid] = {}
	end
	if table.HasValue(HANDLER_GROUPSANDROLES["groups"][uid], ply) then
		table.RemoveByValue(HANDLER_GROUPSANDROLES["groups"][uid], ply)
		printGM("gm", ply:YRPName() .. " unsubscribed from Group " .. uid)
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
			SQL_UPDATE(DATABASE_NAME, "int_position = '" .. count .. "'", "uniqueID = '" .. sibling.uniqueID .. "'")
		end
	end
end

function SendGroupList(uid)
	SortGroups(uid)

	local tbl_parentgroup = SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '" .. uid .. "'")
	if !wk(tbl_parentgroup) then
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
		SQL_UPDATE(DATABASE_NAME, "int_position = '" .. count .. "'", "uniqueID = '" .. new_group.uniqueID .. "'")
	else
		SQL_UPDATE(DATABASE_NAME, "int_position = '" .. count .. "', int_up = '" .. up.uniqueID .. "'", "uniqueID = '" .. new_group.uniqueID .. "'")
		SQL_UPDATE(DATABASE_NAME, "int_dn = '" .. new_group.uniqueID .. "'", "uniqueID = '" .. up.uniqueID .. "'")
	end

	printGM("db", "Added new group: " .. new_group.uniqueID)

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
			SQL_UPDATE(DATABASE_NAME, "int_position = '" .. group.int_position .. "'", "uniqueID = '" .. sibling.uniqueID .. "'")
			SQL_UPDATE(DATABASE_NAME, "int_position = '" .. sibling.int_position .. "'", "uniqueID = '" .. uid .. "'")
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
			SQL_UPDATE(DATABASE_NAME, "int_position = '" .. group.int_position .. "'", "uniqueID = '" .. sibling.uniqueID .. "'")
			SQL_UPDATE(DATABASE_NAME, "int_position = '" .. sibling.int_position .. "'", "uniqueID = '" .. uid .. "'")
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

util.AddNetworkString("settings_delete_group")
net.Receive("settings_delete_group", function(len, ply)
	local uid = tonumber(net.ReadString())
	local group = SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '" .. uid .. "'")
	if wk(group) then
		group = group[1]
		SQL_DELETE_FROM(DATABASE_NAME, "uniqueID = '" .. uid .. "'")

		local siblings = SQL_SELECT(DATABASE_NAME, "*", "int_parentgroup = '" .. group.int_parentgroup .. "'")
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

		group.int_parentgroup = tonumber(group.int_parentgroup)
		SendGroupList(group.int_parentgroup)
	end
end)

util.AddNetworkString("get_grps")

net.Receive("get_grps", function(len, ply)
	local _uid = tonumber(net.ReadString())

	local _get_grps = SQL_SELECT("yrp_ply_groups", "*", "int_parentgroup = " .. _uid)
	if _get_grps != nil then

		net.Start("get_grps")
			net.WriteTable(_get_grps)
		net.Send(ply)
	end
end)

-- Transfer
local old_groups = SQL_SELECT("yrp_groups", "*", nil)
if wk(old_groups) then
	for i, old_grp in pairs(old_groups) do
		local ogrp = SQL_SELECT("yrp_ply_groups", "*", "uniqueID = '" .. old_grp.uniqueID .. "'")
		if !wk(ogrp) then
			if tonumber(old_grp.uppergroup) == -1 then
				old_grp.uppergroup = 0
			end
			SQL_INSERT_INTO("yrp_ply_groups", "string_name, string_color, int_parentgroup, uniqueID", "'" .. old_grp.groupID .. "', '" .. old_grp.color .. "', '" .. old_grp.uppergroup .. "', '" .. old_grp.uniqueID .. "'")
		end
	end
end

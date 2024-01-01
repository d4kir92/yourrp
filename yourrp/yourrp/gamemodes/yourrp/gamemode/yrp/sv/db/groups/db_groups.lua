--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
-- DO NOT TOUCH THE DATABASE FILES! If you have errors, report them here:
-- https://discord.gg/sEgNZxg
local DATABASE_NAME = "yrp_ply_groups"
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "string_name", "TEXT DEFAULT 'GroupName'")
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "string_description", "TEXT DEFAULT '-'")
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "string_color", "TEXT DEFAULT '0,0,0'")
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "string_usergroups", "TEXT DEFAULT 'ALL'")
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "string_icon", "TEXT DEFAULT 'http://www.famfamfam.com/lab/icons/silk/icons/group.png'")
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "string_sweps", "TEXT DEFAULT ''")
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "string_ents", "TEXT DEFAULT ''")
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "string_ammos", "TEXT DEFAULT ''")
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "int_parentgroup", "INTEGER DEFAULT 0")
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "int_requireslevel", "INTEGER DEFAULT 1")
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "int_position", "INTEGER DEFAULT 0")
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_whitelist", "INTEGER DEFAULT 0")
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_visible_cc", "INTEGER DEFAULT 1")
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_visible_rm", "INTEGER DEFAULT 1")
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_locked", "INTEGER DEFAULT 0")
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_iscp", "INTEGER DEFAULT 0")
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_removeable", "INTEGER DEFAULT 1")
-- PUBLIC GROUP
if YRP_SQL_SELECT(DATABASE_NAME, "*", "uniqueID = -1") == nil then
	local _result = YRP_SQL_INSERT_INTO(DATABASE_NAME, "uniqueID, string_name, string_color, int_parentgroup, bool_removeable, bool_locked, bool_visible_rm, bool_visible_cc", "-1, 'PUBLIC', '255,255,255', -1, 0, 0, 0, 0")
end

YRP_SQL_UPDATE(
	DATABASE_NAME,
	{
		["int_parentgroup"] = -1
	}, "uniqueID = '-1'"
)

YRP_SQL_DELETE_FROM(DATABASE_NAME, "uniqueID = '0'")
-- DEFAULT GROUP
if YRP_SQL_SELECT(DATABASE_NAME, "*", "uniqueID = 1") == nil then
	YRP.msg("note", DATABASE_NAME .. " has not the default group")
	local _result = YRP_SQL_INSERT_INTO(DATABASE_NAME, "uniqueID, string_name, string_color, int_parentgroup, bool_removeable", "'1', 'Civilians', '0,0,255', '0', '0'")
end

YRP_SQL_UPDATE(
	DATABASE_NAME,
	{
		["bool_visible_cc"] = 1
	}, "uniqueID = '1'"
)

local dbTab = YRP_SQL_SELECT(DATABASE_NAME, "*", nil)
if dbTab then
	for i, v in pairs(YRP_SQL_SELECT(DATABASE_NAME, "*", nil)) do
		v.uniqueID = tonumber(v.uniqueID)
		v.int_parentgroup = tonumber(v.int_parentgroup)
		if v.uniqueID ~= -1 and v.int_parentgroup == v.uniqueID then
			YRP_SQL_UPDATE(
				DATABASE_NAME,
				{
					["int_parentgroup"] = 0
				}, "uniqueID = '" .. v.uniqueID .. "'"
			)
		end
	end
end

-- Local Table
local yrp_ply_groups = {}
local _init_ply_groups = YRP_SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '1'")
if IsNotNilAndNotFalse(_init_ply_groups) then
	yrp_ply_groups = _init_ply_groups[1]
end

local HANDLER_GROUPSANDROLES = {}
HANDLER_GROUPSANDROLES["groupslist"] = {}
HANDLER_GROUPSANDROLES["groups"] = {}
HANDLER_GROUPSANDROLES["roles"] = {}
-- Network Things
for str, val in pairs(yrp_ply_groups) do
	if string.find(str, "string_", 1, true) then
		local tab = {}
		tab.netstr = "nws_yrp_update_group_" .. str
		util.AddNetworkString(tab.netstr)
		net.Receive(
			tab.netstr,
			function(len, ply)
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
				if tab.netstr == "nws_yrp_update_group_string_name" then
					util.AddNetworkString("nws_yrp_settings_group_update_name")
					local puid = YRP_SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '" .. uid .. "'")
					if IsNotNilAndNotFalse(puid) then
						puid = puid[1]
						tab.handler = HANDLER_GROUPSANDROLES["groupslist"][tonumber(puid.int_parentgroup)]
						tab.netstr = "nws_yrp_settings_group_update_name"
						tab.uniqueID = tonumber(puid.uniqueID)
						tab.force = true
						BroadcastString(tab)
					end
				elseif tab.netstr == "nws_yrp_update_group_string_color" then
					util.AddNetworkString("nws_yrp_settings_group_update_color")
					local puid = YRP_SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '" .. uid .. "'")
					if IsNotNilAndNotFalse(puid) then
						puid = puid[1]
						tab.handler = HANDLER_GROUPSANDROLES["groupslist"][tonumber(puid.int_parentgroup)]
						tab.netstr = "nws_yrp_settings_group_update_color"
						tab.uniqueID = tonumber(puid.uniqueID)
						tab.force = true
						BroadcastString(tab)
					end
				elseif tab.netstr == "nws_yrp_update_group_string_icon" then
					util.AddNetworkString("nws_yrp_settings_group_update_icon")
					local puid = YRP_SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '" .. uid .. "'")
					if IsNotNilAndNotFalse(puid) then
						puid = puid[1]
						tab.handler = HANDLER_GROUPSANDROLES["groupslist"][tonumber(puid.int_parentgroup)]
						tab.netstr = "nws_yrp_settings_group_update_icon"
						tab.uniqueID = tonumber(puid.uniqueID)
						tab.force = true
						BroadcastString(tab)
					end
				end
			end
		)
	elseif string.find(str, "int_", 1, true) then
		local tab = {}
		tab.netstr = "nws_yrp_update_group_" .. str
		util.AddNetworkString(tab.netstr)
		net.Receive(
			tab.netstr,
			function(len, ply)
				local uid = tonumber(net.ReadString())
				local int = tonumber(net.ReadString())
				local cur = YRP_SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '" .. uid .. "'")
				tab.ply = ply
				tab.id = str
				tab.value = int
				tab.db = DATABASE_NAME
				tab.uniqueID = uid
				UpdateInt(tab)
				tab.handler = HANDLER_GROUPSANDROLES["groups"][tonumber(tab.uniqueID)]
				BroadcastInt(tab)
				if tab.netstr == "nws_yrp_update_group_int_parentgroup" then
					if IsNotNilAndNotFalse(cur) then
						cur = cur[1]
						SendGroupList(tonumber(cur.int_parentgroup))
					end

					SendGroupList(int)
				end
			end
		)
	elseif string.find(str, "bool_", 1, true) then
		local tab = {}
		tab.netstr = "nws_yrp_update_group_" .. str
		util.AddNetworkString(tab.netstr)
		net.Receive(
			tab.netstr,
			function(len, ply)
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
			end
		)
	end
end

function RemFromHandler_GroupsAndRoles(ply)
	table.RemoveByValue(HANDLER_GROUPSANDROLES, ply)
end

function AddToHandler_GroupsAndRoles(ply)
	if not table.HasValue(HANDLER_GROUPSANDROLES, ply) then
		table.insert(HANDLER_GROUPSANDROLES, ply)
	end
end

function SubscribeGroupList(ply, uid)
	if HANDLER_GROUPSANDROLES["groupslist"][uid] == nil then
		HANDLER_GROUPSANDROLES["groupslist"][uid] = {}
	end

	if not table.HasValue(HANDLER_GROUPSANDROLES["groupslist"][uid], ply) then
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

	if not table.HasValue(HANDLER_GROUPSANDROLES["groups"][uid], ply) then
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

util.AddNetworkString("nws_yrp_subscribe_Settings_GroupsAndRoles")
net.Receive(
	"nws_yrp_subscribe_Settings_GroupsAndRoles",
	function(len, ply)
		if not ply:CanAccess("bool_groupsandroles") then return end
		AddToHandler_GroupsAndRoles(ply)
		net.Start("nws_yrp_subscribe_Settings_GroupsAndRoles")
		net.Send(ply)
	end
)

util.AddNetworkString("nws_yrp_unsubscribe_Settings_GroupsAndRoles")
net.Receive(
	"nws_yrp_unsubscribe_Settings_GroupsAndRoles",
	function(len, ply)
		if not ply:CanAccess("bool_groupsandroles") then return end
		RemFromHandler_GroupsAndRoles(ply)
		local cur = tonumber(net.ReadString())
		UnsubscribeGroup(ply, cur)
	end
)

function SortGroups(uid)
	local siblings = YRP_SQL_SELECT(DATABASE_NAME, "*", "int_parentgroup = '" .. uid .. "'")
	if IsNotNilAndNotFalse(siblings) then
		for i, sibling in pairs(siblings) do
			sibling.int_position = tonumber(sibling.int_position)
		end

		local count = 0
		for i, sibling in SortedPairsByMemberValue(siblings, "int_position", false) do
			count = count + 1
			YRP_SQL_UPDATE(
				DATABASE_NAME,
				{
					["int_position"] = count
				}, "uniqueID = '" .. sibling.uniqueID .. "'"
			)
		end
	end
end

function SendGroupList(uid)
	uid = tonumber(uid)
	SortGroups(uid)
	local tbl_parentgroup = YRP_SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '" .. uid .. "'")
	if not IsNotNilAndNotFalse(tbl_parentgroup) or uid < 1 then
		tbl_parentgroup = {}
	else
		tbl_parentgroup = tbl_parentgroup[1]
	end

	local tbl_groups = YRP_SQL_SELECT(DATABASE_NAME, "*", "int_parentgroup = '" .. uid .. "'")
	if not IsNotNilAndNotFalse(tbl_groups) then
		tbl_groups = {}
	end

	local currentuid = uid
	local parentuid = YRP_SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '" .. uid .. "'")
	if IsNotNilAndNotFalse(parentuid) then
		parentuid = parentuid[1].int_parentgroup
	else
		parentuid = 0
	end

	HANDLER_GROUPSANDROLES["groupslist"][uid] = HANDLER_GROUPSANDROLES["groupslist"][uid] or {}
	for i, pl in pairs(HANDLER_GROUPSANDROLES["groupslist"][uid]) do
		net.Start("nws_yrp_settings_subscribe_grouplist")
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
	local group = YRP_SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '" .. guid .. "'")
	if IsNotNilAndNotFalse(group) then
		group = group[1]
		local cols = {}
		local vals = {}
		for name, value in pairs(group) do
			if name ~= "uniqueID" and name ~= "int_removeable" then
				table.insert(cols, name)
				table.insert(vals, "'" .. value .. "'")
			end
		end

		cols = table.concat(cols, ", ")
		vals = table.concat(vals, ", ")
		YRP_SQL_INSERT_INTO(DATABASE_NAME, cols, vals)
		local last = YRP_SQL_SELECT(DATABASE_NAME, "*", nil)
		last = last[table.Count(last)]
		local roles = YRP_SQL_SELECT("yrp_ply_roles", "*", "int_groupID = '" .. guid .. "'")
		if IsNotNilAndNotFalse(roles) then
			for i, role in pairs(roles) do
				DuplicateRole(role.uniqueID, last.uniqueID)
			end
		end

		SendGroupList(group.int_parentgroup)
	else
		YRP.msg("note", "Group [" .. guid .. "] was deleted.")
	end
end

util.AddNetworkString("nws_yrp_settings_duplicate_group")
net.Receive(
	"nws_yrp_settings_duplicate_group",
	function(len, ply)
		if not ply:CanAccess("bool_groupsandroles") then return end
		local guid = tonumber(net.ReadString())
		DuplicateGroup(guid)
	end
)

util.AddNetworkString("nws_yrp_settings_subscribe_grouplist")
net.Receive(
	"nws_yrp_settings_subscribe_grouplist",
	function(len, ply)
		if not ply:CanAccess("bool_groupsandroles") then return end
		local par = tonumber(net.ReadString())
		SubscribeGroupList(ply, par)
		SendGroupList(par)
	end
)

util.AddNetworkString("nws_yrp_settings_add_group")
net.Receive(
	"nws_yrp_settings_add_group",
	function(len, ply)
		if not ply:CanAccess("bool_groupsandroles") then return end
		local uid = tonumber(net.ReadString())
		YRP_SQL_INSERT_INTO(DATABASE_NAME, "int_parentgroup", "'" .. uid .. "'")
		local groups = YRP_SQL_SELECT(DATABASE_NAME, "*", "int_parentgroup = '" .. uid .. "'")
		local count = tonumber(table.Count(groups))
		local new_group = groups[count]
		if count == 1 then
			YRP_SQL_UPDATE(
				DATABASE_NAME,
				{
					["int_position"] = count
				}, "uniqueID = '" .. new_group.uniqueID .. "'"
			)
		else
			YRP_SQL_UPDATE(
				DATABASE_NAME,
				{
					["int_position"] = count
				}, "uniqueID = '" .. new_group.uniqueID .. "'"
			)
			--YRP_SQL_UPDATE(DATABASE_NAME, {["int_dn"] = '" .. new_group.uniqueID .. "'", "uniqueID = '" .. up.uniqueID .. "'" )
		end

		YRP.msg("db", "Added new group: " .. new_group.uniqueID)
		SendGroupList(uid)
	end
)

util.AddNetworkString("nws_yrp_settings_group_position_up")
net.Receive(
	"nws_yrp_settings_group_position_up",
	function(len, ply)
		if not ply:CanAccess("bool_groupsandroles") then return end
		local uid = tonumber(net.ReadString())
		local group = YRP_SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '" .. uid .. "'")
		group = group[1]
		group.int_position = tonumber(group.int_position)
		local siblings = YRP_SQL_SELECT(DATABASE_NAME, "*", "int_parentgroup = '" .. group.int_parentgroup .. "'")
		for i, sibling in pairs(siblings) do
			sibling.int_position = tonumber(sibling.int_position)
		end

		local count = 0
		for i, sibling in SortedPairsByMemberValue(siblings, "int_position", false) do
			count = count + 1
			if tonumber(sibling.int_position) == group.int_position - 1 then
				YRP_SQL_UPDATE(
					DATABASE_NAME,
					{
						["int_position"] = group.int_position
					}, "uniqueID = '" .. sibling.uniqueID .. "'"
				)

				YRP_SQL_UPDATE(
					DATABASE_NAME,
					{
						["int_position"] = sibling.int_position
					}, "uniqueID = '" .. uid .. "'"
				)
			end
		end

		group.int_parentgroup = tonumber(group.int_parentgroup)
		SendGroupList(group.int_parentgroup)
	end
)

util.AddNetworkString("nws_yrp_settings_group_position_dn")
net.Receive(
	"nws_yrp_settings_group_position_dn",
	function(len, ply)
		if not ply:CanAccess("bool_groupsandroles") then return end
		local uid = tonumber(net.ReadString())
		local group = YRP_SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '" .. uid .. "'")
		group = group[1]
		group.int_position = tonumber(group.int_position)
		local siblings = YRP_SQL_SELECT(DATABASE_NAME, "*", "int_parentgroup = '" .. group.int_parentgroup .. "'")
		for i, sibling in pairs(siblings) do
			sibling.int_position = tonumber(sibling.int_position)
		end

		local count = 0
		for i, sibling in SortedPairsByMemberValue(siblings, "int_position", false) do
			count = count + 1
			if tonumber(sibling.int_position) == group.int_position + 1 then
				YRP_SQL_UPDATE(
					DATABASE_NAME,
					{
						["int_position"] = group.int_position
					}, "uniqueID = '" .. sibling.uniqueID .. "'"
				)

				YRP_SQL_UPDATE(
					DATABASE_NAME,
					{
						["int_position"] = sibling.int_position
					}, "uniqueID = '" .. uid .. "'"
				)
			end
		end

		group.int_parentgroup = tonumber(group.int_parentgroup)
		SendGroupList(group.int_parentgroup)
	end
)

util.AddNetworkString("nws_yrp_settings_subscribe_group")
net.Receive(
	"nws_yrp_settings_subscribe_group",
	function(len, ply)
		if not ply:CanAccess("bool_groupsandroles") then return end
		local uid = tonumber(net.ReadString())
		SubscribeGroup(ply, uid)
		local group = YRP_SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '" .. uid .. "'")
		if not IsNotNilAndNotFalse(group) then
			group = {}
		else
			group = group[1]
		end

		local groups = YRP_SQL_SELECT(DATABASE_NAME, "string_name, uniqueID", nil)
		local usergroups = YRP_SQL_SELECT("yrp_usergroups", "*", nil)
		net.Start("nws_yrp_settings_subscribe_group")
		net.WriteTable(group)
		net.WriteTable(groups)
		net.WriteTable(usergroups)
		net.Send(ply)
	end
)

util.AddNetworkString("nws_yrp_settings_unsubscribe_group")
net.Receive(
	"nws_yrp_settings_unsubscribe_group",
	function(len, ply)
		if not ply:CanAccess("bool_groupsandroles") then return end
		local uid = tonumber(net.ReadString())
		UnsubscribeGroup(ply, uid)
	end
)

util.AddNetworkString("nws_yrp_settings_unsubscribe_grouplist")
net.Receive(
	"nws_yrp_settings_unsubscribe_grouplist",
	function(len, ply)
		if not ply:CanAccess("bool_groupsandroles") then return end
		local uid = tonumber(net.ReadString())
		UnsubscribeGroupList(ply, uid)
	end
)

function RemoveUnusedGroups()
	local count = 0
	local all_groups = YRP_SQL_SELECT("yrp_ply_groups", "*", nil)
	for i, grp in pairs(all_groups) do
		grp.int_parentgroup = tonumber(grp.int_parentgroup)
		if grp.int_parentgroup > 0 then
			local parentgroup = YRP_SQL_SELECT("yrp_ply_groups", "*", "uniqueID = '" .. grp.int_parentgroup .. "'")
			if parentgroup == nil then
				count = count + 1
				YRP_SQL_DELETE_FROM("yrp_ply_groups", "uniqueID = '" .. grp.uniqueID .. "'")
			end
		end
	end

	if count > 0 then
		RemoveUnusedGroups()
	end
end

function RemoveUnusedRoles()
	local count = 0
	local all_roles = YRP_SQL_SELECT("yrp_ply_roles", "*", nil)
	if all_roles then
		for i, rol in pairs(all_roles) do
			rol.int_groupID = tonumber(rol.int_groupID)
			if rol.int_groupID > 0 then
				local group = YRP_SQL_SELECT("yrp_ply_groups", "*", "uniqueID = '" .. rol.int_groupID .. "'")
				if group == nil then
					count = count + 1
					YRP_SQL_DELETE_FROM("yrp_ply_roles", "uniqueID = '" .. rol.uniqueID .. "'")
				end
			end
		end
	end

	if count > 0 then
		RemoveUnusedRoles()
	end
end

function DeleteGroup(guid, recursive)
	if guid == nil then return false end
	local group = YRP_SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '" .. guid .. "'")
	if IsNotNilAndNotFalse(group) then
		group = group[1]
		YRP_SQL_DELETE_FROM(DATABASE_NAME, "uniqueID = '" .. guid .. "'")
		if recursive then
			-- Delete Groups Recursive
			RemoveUnusedGroups()
			-- Delete Roles Recursive
			RemoveUnusedRoles()
		else
			-- Position richtig anordnen
			local siblings = YRP_SQL_SELECT(DATABASE_NAME, "*", "int_parentgroup = '" .. group.int_parentgroup .. "'")
			if IsNotNilAndNotFalse(siblings) then
				for i, sibling in pairs(siblings) do
					sibling.int_position = tonumber(sibling.int_position)
				end

				local count = 0
				for i, sibling in SortedPairsByMemberValue(siblings, "int_position", false) do
					count = count + 1
					YRP_SQL_UPDATE(
						DATABASE_NAME,
						{
							["int_position"] = count
						}, "uniqueID = '" .. sibling.uniqueID .. "'"
					)
				end
			end
		end

		MoveUnusedGroups()
		MoveUnusedRolesToDefault()
		group.int_parentgroup = tonumber(group.int_parentgroup) or 1
		SendGroupList(group.int_parentgroup)
	end
end

util.AddNetworkString("nws_yrp_settings_delete_group")
net.Receive(
	"nws_yrp_settings_delete_group",
	function(len, ply)
		if not ply:CanAccess("bool_groupsandroles") then return end
		local guid = tonumber(net.ReadString())
		local recursive = net.ReadBool()
		if guid then
			DeleteGroup(guid, recursive)
		end
	end
)

util.AddNetworkString("nws_yrp_rolesmenu_get_groups")
net.Receive(
	"nws_yrp_rolesmenu_get_groups",
	function(len, ply)
		local _uid = tonumber(net.ReadString())
		local _get_grps = YRP_SQL_SELECT("yrp_ply_groups", "*", "int_parentgroup = " .. _uid)
		if IsNotNilAndNotFalse(_get_grps) then
			net.Start("nws_yrp_rolesmenu_get_groups")
			net.WriteTable(_get_grps)
			net.Send(ply)
		end
	end
)

function GetGroupTable(gid)
	local result = YRP_SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '" .. gid .. "'")
	if IsNotNilAndNotFalse(result) then
		result = result[1]
	end

	return result
end

-- Faction Selection
util.AddNetworkString("nws_yrp_factionselection_getfactions")
net.Receive(
	"nws_yrp_factionselection_getfactions",
	function(len, ply)
		local dbtab2 = YRP_SQL_SELECT(DATABASE_NAME, "uniqueID, string_icon, string_name, string_description, bool_visible_cc, bool_visible_rm", "int_parentgroup = '0'")
		local nettab = {}
		if IsNotNilAndNotFalse(dbtab2) then
			nettab = dbtab2
		end

		net.Start("nws_yrp_factionselection_getfactions")
		net.WriteTable(nettab)
		net.Send(ply)
	end
)

util.AddNetworkString("nws_yrp_roleselection_getgroups")
net.Receive(
	"nws_yrp_roleselection_getgroups",
	function(len, ply)
		local fuid = net.ReadString()
		local dbtab2 = YRP_SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '" .. fuid .. "'")
		local nettab = {}
		if IsNotNilAndNotFalse(dbtab2) then
			nettab = dbtab2
		end

		local factioncount = 0
		local fatab = YRP_SQL_SELECT(DATABASE_NAME, "*", "int_parentgroup = '" .. 0 .. "'")
		if IsNotNilAndNotFalse(fatab) then
			for i, v in pairs(fatab) do
				factioncount = factioncount + 1
			end
		end

		net.Start("nws_yrp_roleselection_getgroups")
		net.WriteTable(nettab)
		net.WriteString(factioncount)
		net.Send(ply)
	end
)

util.AddNetworkString("nws_yrp_roleselection_getcontent")
util.AddNetworkString("nws_yrp_roleselection_getcontent_role")
util.AddNetworkString("nws_yrp_roleselection_getcontent_group")
net.Receive(
	"nws_yrp_roleselection_getcontent",
	function(len, ply)
		local guid = net.ReadString()
		local roltab = YRP_SQL_SELECT("yrp_ply_roles", "*", "int_groupID = '" .. guid .. "'")
		local grptab = YRP_SQL_SELECT(DATABASE_NAME, "*", "int_parentgroup = '" .. guid .. "'")
		if IsNotNilAndNotFalse(roltab) then
			for i, v in pairs(roltab) do
				v.pms = GetPlayermodelsOfRole(v.uniqueID)
				YRPUpdateRoleUses(v.uniqueID)
			end
		end

		if IsNotNilAndNotFalse(roltab) then
			for i, rol in pairs(roltab) do
				if rol then
					net.Start("nws_yrp_roleselection_getcontent_role")
					net.WriteTable(rol)
					net.Send(ply)
				end
			end
		end

		if IsNotNilAndNotFalse(grptab) then
			for i, grp in pairs(grptab) do
				if grp then
					net.Start("nws_yrp_roleselection_getcontent_group")
					net.WriteTable(grp)
					net.Send(ply)
				end
			end
		end
	end
)

util.AddNetworkString("nws_yrp_roleselection_getrole")
net.Receive(
	"nws_yrp_roleselection_getrole",
	function(len, ply)
		local ruid = net.ReadString()
		local roltab = YRP_SQL_SELECT("yrp_ply_roles", "*", "uniqueID = '" .. ruid .. "'")
		if IsNotNilAndNotFalse(roltab) then
			for i, v in pairs(roltab) do
				v.pms = GetPlayermodelsOfRole(v.uniqueID)
			end

			roltab = roltab[1]
			net.Start("nws_yrp_roleselection_getrole")
			net.WriteTable(roltab)
			net.Send(ply)
		else
			YRP.msg("note", "[nws_yrp_roleselection_getrole] Role-UID is no valid one: " .. tostring(ruid))
		end
	end
)

util.AddNetworkString("nws_yrp_char_getrole")
net.Receive(
	"nws_yrp_char_getrole",
	function(len, ply)
		local ruid = net.ReadString()
		local roltab = YRP_SQL_SELECT("yrp_ply_roles", "*", "uniqueID = '" .. ruid .. "'")
		if IsNotNilAndNotFalse(roltab) then
			for i, v in pairs(roltab) do
				v.pms = GetPlayermodelsOfRole(v.uniqueID)
			end

			roltab = roltab[1]
			net.Start("nws_yrp_char_getrole")
			net.WriteTable(roltab)
			net.Send(ply)
		else
			YRP.msg("error", "[yrp_char_getrole] ruid not valid: " .. tostring(ruid))
		end
	end
)

-- SWEPS
function GetGroup(uid)
	local group = YRP_SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '" .. uid .. "'")
	if IsNotNilAndNotFalse(group) then return group[1] end

	return nil
end

function SendSwepsGroup(uid)
	local group = GetGroup(uid)
	if IsNotNilAndNotFalse(group) then
		local nettab = {}
		local sweps = string.Explode(",", group.string_sweps)
		for i, swep in pairs(sweps) do
			if not strEmpty(swep) then
				table.insert(nettab, swep)
			end
		end

		if HANDLER_GROUPSANDROLES["groups"][uid] == nil then
			HANDLER_GROUPSANDROLES["groups"][uid] = {}
		end

		for i, pl in pairs(HANDLER_GROUPSANDROLES["groups"][uid]) do
			net.Start("nws_yrp_settings_get_sweps")
			net.WriteTable(nettab)
			net.Send(pl)
		end
	end
end

util.AddNetworkString("nws_yrp_settings_get_sweps")
net.Receive(
	"nws_yrp_settings_get_sweps",
	function(len, ply)
		if not ply:CanAccess("bool_groupsandroles") then return end
		local uid = net.ReadInt(32)
		SendSwepsGroup(uid)
	end
)

function AddSwepToGroup(guid, swepcn)
	local group = GetGroup(guid)
	if IsNotNilAndNotFalse(group) then
		local sweps = string.Explode(",", group.string_sweps)
		if not table.HasValue(sweps, tostring(swepcn)) then
			local oldsweps = {}
			for i, v in pairs(sweps) do
				if not strEmpty(v) then
					table.insert(oldsweps, v)
				end
			end

			local newsweps = oldsweps
			table.insert(newsweps, tostring(swepcn))
			newsweps = string.Implode(",", newsweps)
			YRP_SQL_UPDATE(
				DATABASE_NAME,
				{
					["string_sweps"] = newsweps
				}, "uniqueID = '" .. guid .. "'"
			)

			SendSwepsGroup(guid)
		end
	end
end

util.AddNetworkString("nws_yrp_settings_add_sweps")
net.Receive(
	"nws_yrp_settings_add_sweps",
	function(len, ply)
		if not ply:CanAccess("bool_groupsandroles") then return end
		local guid = net.ReadInt(32)
		local swepcn = net.ReadString()
		AddSwepToGroup(guid, swepcn)
	end
)

function RemSwepFromGroup(guid, swepcn)
	local group = GetGroup(guid)
	if IsNotNilAndNotFalse(group) then
		local sweps = string.Explode(",", group.string_sweps)
		local oldsweps = {}
		for i, v in pairs(sweps) do
			if not strEmpty(v) then
				table.insert(oldsweps, v)
			end
		end

		local newsweps = oldsweps
		table.RemoveByValue(newsweps, tostring(swepcn))
		newsweps = string.Implode(",", newsweps)
		YRP_SQL_UPDATE(
			DATABASE_NAME,
			{
				["string_sweps"] = newsweps
			}, "uniqueID = '" .. guid .. "'"
		)

		SendSwepsGroup(guid)
	else
		YRP.msg("note", "[RemSwepFromGroup] Group not exists anymore?")
	end
end

util.AddNetworkString("nws_yrp_settings_rem_sweps")
net.Receive(
	"nws_yrp_settings_rem_sweps",
	function(len, ply)
		if not ply:CanAccess("bool_groupsandroles") then return end
		local guid = net.ReadInt(32)
		local swepcn = net.ReadString()
		RemSwepFromGroup(guid, swepcn)
	end
)

function YRPSendGroupMembers(ply)
	local members = YRP_SQL_SELECT("yrp_characters", "uniqueID, rpname, groupID", "groupID = '" .. ply:GetGroupUID() .. "'")
	if members then
		net.Start("nws_yrp_group_getmembers")
		net.WriteTable(members)
		net.Send(ply)
	end
end

function YRPUpdateGroupMemberLists()
	for i, v in pairs(player.GetAll()) do
		YRPSendGroupMembers(v)
	end
end

util.AddNetworkString("nws_yrp_group_getmembers")
net.Receive(
	"nws_yrp_group_getmembers",
	function(len, ply)
		if not ply:GetYRPBool("isInstructor") then return end
		YRPSendGroupMembers(ply)
	end
)

function YRPGetRoleNameByID(id)
	if id == nil then return "NO ID" end
	local role = YRP_SQL_SELECT("yrp_ply_roles", "uniqueID, string_name", "uniqueID = '" .. id .. "'")
	if role and role[1] then
		role = role[1]

		return role.string_name
	end

	return "NOT FOUND"
end

function YRPGetGroupNameByID(id)
	if id == nil then return "NO ID" end
	local group = YRP_SQL_SELECT("yrp_ply_groups", "uniqueID, string_name", "uniqueID = '" .. id .. "'")
	if group and group[1] then
		group = group[1]

		return group.string_name
	end

	return "NOT FOUND"
end

function YRPGetNextRankByID(id)
	local role = YRP_SQL_SELECT("yrp_ply_roles", "*", "int_prerole = '" .. id .. "'")
	if role and role[1] then return role[1] end

	return nil
end

function YRPGetPrevRankByID(id)
	local trole = YRP_SQL_SELECT("yrp_ply_roles", "int_prerole", "uniqueID = '" .. id .. "'")
	if trole and trole[1] then
		trole = trole[1]
		local role = YRP_SQL_SELECT("yrp_ply_roles", "*", "uniqueID = '" .. trole.int_prerole .. "'")
		if role and role[1] then return role[1] end
	end

	return nil
end

function YRPSendGroupMember(ply, uid)
	local char = YRP_SQL_SELECT("yrp_characters", "uniqueID, rpname, roleID, groupID", "uniqueID = '" .. uid .. "'")
	if char then
		char = char[1]
		char.uniqueID = tonumber(char.uniqueID)
		char.roleID = tonumber(char.roleID)
		char.groupID = tonumber(char.groupID)
		local nextrank = YRPGetNextRankByID(char.roleID)
		local prevrank = YRPGetPrevRankByID(char.roleID)
		local canpromote = false
		if nextrank then
			nextrank.uniqueID = tonumber(nextrank.uniqueID)
			canpromote = nextrank.uniqueID ~= ply:GetRoleUID()
		end

		local candemote = false
		if prevrank then
			candemote = true
		end

		local isinstructor = tobool(ply:YRPGetRoleTable().bool_instructor)
		local nettab = {}
		nettab.uniqueID = char.uniqueID
		nettab.name = char.rpname
		nettab.roleID = char.roleID
		nettab.roleName = YRPGetRoleNameByID(char.roleID)
		nettab.groupID = char.groupID
		nettab.groupName = YRPGetGroupNameByID(char.groupID)
		nettab.canpromote = isinstructor and canpromote
		nettab.candemote = isinstructor and candemote
		nettab.canspecs = isinstructor
		nettab.specs = YRPGetSpecNames(char.uniqueID)
		net.Start("nws_yrp_group_getmember")
		net.WriteTable(nettab)
		net.Send(ply)
	end
end

util.AddNetworkString("nws_yrp_group_getmember")
net.Receive(
	"nws_yrp_group_getmember",
	function(len, ply)
		if not ply:GetYRPBool("isInstructor") then return end
		local uid = net.ReadUInt(24)
		YRPSendGroupMember(ply, uid)
	end
)

util.AddNetworkString("nws_yrp_group_delmember")
net.Receive(
	"nws_yrp_group_delmember",
	function(len, ply)
		if not ply:GetYRPBool("isInstructor") then return end
		local uid = net.ReadUInt(24)
		YRP_SQL_UPDATE(
			"yrp_characters",
			{
				["roleID"] = 1,
				["groupID"] = 1
			}, "uniqueID = '" .. uid .. "'"
		)

		local target = YRPGetPlayerByCharID(uid)
		if IsValid(target) then
			YRPSetRole(target, 1, force)
		end

		YRPSendGroupMember(ply, uid)
		YRPSendGroupMembers(ply)
	end
)
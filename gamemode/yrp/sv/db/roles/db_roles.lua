--Copyright (C) 2017-2019 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

-- DO NOT TOUCH THE DATABASE FILES! If you have errors, report them here:
-- https://discord.gg/sEgNZxg

local DATABASE_NAME = "yrp_ply_roles"

SQL_ADD_COLUMN(DATABASE_NAME, "string_name", "TEXT DEFAULT 'NewRole'")
SQL_ADD_COLUMN(DATABASE_NAME, "string_idstructure", "TEXT DEFAULT '!D!D!D!D-!D!D!D!D-!D!D!D!D'")
SQL_ADD_COLUMN(DATABASE_NAME, "string_icon", "TEXT DEFAULT 'http://www.famfamfam.com/lab/icons/silk/icons/user.png'")
SQL_ADD_COLUMN(DATABASE_NAME, "string_usergroups", "TEXT DEFAULT 'ALL'")
SQL_ADD_COLUMN(DATABASE_NAME, "string_description", "TEXT DEFAULT '-'")
SQL_ADD_COLUMN(DATABASE_NAME, "string_playermodels", "TEXT DEFAULT ' '")
SQL_ADD_COLUMN(DATABASE_NAME, "int_salary", "INTEGER DEFAULT 50")
SQL_ADD_COLUMN(DATABASE_NAME, "int_groupID", "INTEGER DEFAULT 1")
SQL_ADD_COLUMN(DATABASE_NAME, "string_color", "TEXT DEFAULT '0,0,0'")
SQL_ADD_COLUMN(DATABASE_NAME, "string_sweps", "TEXT DEFAULT ' '")
SQL_ADD_COLUMN(DATABASE_NAME, "string_ndsweps", "TEXT DEFAULT ' '")
SQL_ADD_COLUMN(DATABASE_NAME, "string_ammunation", "TEXT DEFAULT ' '")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_voteable", "INTEGER DEFAULT 0")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_adminonly", "INTEGER DEFAULT 0")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_whitelist", "INTEGER DEFAULT 0")
SQL_ADD_COLUMN(DATABASE_NAME, "int_maxamount", "INTEGER DEFAULT 0")
SQL_ADD_COLUMN(DATABASE_NAME, "int_amountpercentage", "INTEGER DEFAULT 100")
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
SQL_ADD_COLUMN(DATABASE_NAME, "int_roleondeath", "INTEGER DEFAULT 0")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_instructor", "INTEGER DEFAULT 0")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_removeable", "INTEGER DEFAULT 1")
SQL_ADD_COLUMN(DATABASE_NAME, "int_uses", "INTEGER DEFAULT 0")
SQL_ADD_COLUMN(DATABASE_NAME, "int_salarytime", "INTEGER DEFAULT 120")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_voiceglobal", "INTEGER DEFAULT 0")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_voicefaction", "INTEGER DEFAULT 1")
SQL_ADD_COLUMN(DATABASE_NAME, "int_requireslevel", "INTEGER DEFAULT 1")
SQL_ADD_COLUMN(DATABASE_NAME, "int_securitylevel", "INTEGER DEFAULT 0")

SQL_ADD_COLUMN(DATABASE_NAME, "bool_canbeagent", "INTEGER DEFAULT 0")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_visible", "INTEGER DEFAULT 1")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_locked", "INTEGER DEFAULT 0")

SQL_ADD_COLUMN(DATABASE_NAME, "string_licenses", "TEXT DEFAULT ' '")

SQL_ADD_COLUMN(DATABASE_NAME, "string_customflags", "TEXT DEFAULT ' '")

SQL_ADD_COLUMN(DATABASE_NAME, "int_cooldown", "INTEGER DEFAULT 1")

SQL_ADD_COLUMN(DATABASE_NAME, "int_position", "INTEGER DEFAULT 1")

if SQL_SELECT(DATABASE_NAME, "*", "uniqueID = 1") == nil then
	printGM("note", DATABASE_NAME .. " has not the default role")
	local _result = SQL_INSERT_INTO(DATABASE_NAME, "uniqueID, string_name, string_color, int_groupID, bool_removeable", "1, 'Civilian', '0,0,255', 1, 0")
end

--[[local yrp_ply_roles =  SQL_SELECT(DATABASE_NAME, "*", nil)
if wk(yrp_ply_roles) then
	for i, v in pairs(yrp_ply_roles) do
		local rid = v.uniqueID
		local idstructure = v.string_idstructure
		if idstructure == "%%%%-%%%%-%%%%" or strEmpty(idstructure) then
			SQL_UPDATE("yrp_ply_roles", "string_idstructure = '" .. "!D!D!D!D-!D!D!D!D-!D!D!D!D" .. "'", "uniqueID = '" .. rid .. "'")
		end
	end
end]]

SQL_UPDATE(DATABASE_NAME, "uses = 0", nil)

function MoveUnusedGroups()
	local count = 0
	local all_groups = SQL_SELECT("yrp_ply_groups", "*", nil)
	for i, group in pairs(all_groups) do
		group.int_parentgroup = tonumber(group.int_parentgroup)
		if group.int_parentgroup > 0 then
			local parentgroup = SQL_SELECT("yrp_ply_groups", "*", "uniqueID = '" .. group.int_parentgroup .. "'")
			if parentgroup == nil then
				count = count + 1
				YRP.msg("note", "Group is out of space: " .. group.string_name)
				SQL_UPDATE("yrp_ply_groups", "int_parentgroup = '" .. "1" .. "'", "uniqueID = '" .. group.uniqueID .. "'")
			end
		end
	end
	if count > 0 then
		MoveUnusedGroups()
	end
end

function MoveUnusedRolesToDefault()
	printGM("note", "Move unused roles to default group")
	local allroles = SQL_SELECT("yrp_ply_roles", "*", nil)
	if wk(allroles) then
		for i, role in pairs(allroles) do
			-- If prerole not exists remove the prerole
			local prerole = SQL_SELECT("yrp_ply_roles", "*", "uniqueID = '" .. role.int_prerole .. "'")
			if !wk(prerole) then
				SQL_UPDATE(DATABASE_NAME, "int_prerole = '0'", "uniqueID = '" .. role.uniqueID .. "'")
			end

			MoveUnusedGroups()
			-- if group not exists move it to default group
			local group = SQL_SELECT("yrp_ply_groups", "*", "uniqueID = '" .. role.int_groupID .. "'")
			if !wk(group) then
				SQL_UPDATE(DATABASE_NAME, "int_groupID = '1', int_prerole = '0'", "uniqueID = '" .. role.uniqueID .. "'")
			end
		end
	end
end
MoveUnusedRolesToDefault()

-- CONVERTING OLD roles
if wk(SQL_SELECT("yrp_roles", "*", nil)) then
	printGM("note", "Converting OLD Roles into NEW Roles")
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
			vals = vals .. "'" .. role.salarytime ..	"', "
			vals = vals .. "'" .. role.licenseIDs .. "' "

			SQL_INSERT_INTO(DATABASE_NAME, cols, vals)
			SQL_DELETE_FROM("yrp_roles", "uniqueID = '" .. role.uniqueID .. "'")
		end
	end
	SQL_DROP_TABLE("yrp_roles")
end
-- CONVERTING OLD roles



-- CONVERTING
local wrongprerole = SQL_SELECT(DATABASE_NAME, "*", "int_prerole = '-1'")
if wk(wrongprerole) then
	for i, role in pairs(wrongprerole) do
		SQL_UPDATE(DATABASE_NAME, "int_prerole = '0'", "uniqueID = '" .. role.uniqueID .. "'")
	end
end

local wrongmaxamount = SQL_SELECT(DATABASE_NAME, "*", "int_maxamount = -1")
if wk(wrongmaxamount) then
	for i, role in pairs(wrongmaxamount) do
		SQL_UPDATE(DATABASE_NAME, "int_maxamount = 0", "uniqueID = '" .. role.uniqueID .. "'")
	end
end

local wrongpercentage = SQL_SELECT(DATABASE_NAME, "*", "int_amountpercentage > 100")
if wk(wrongpercentage) then
	for i, role in pairs(wrongpercentage) do
		SQL_UPDATE(DATABASE_NAME, "int_amountpercentage = '100'", "uniqueID = '" .. role.uniqueID .. "'")
	end
end

local wrongmainrole = SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '1'")
if wk(wrongmainrole) then
	SQL_UPDATE(DATABASE_NAME, "string_usergroups = 'ALL'", "uniqueID = '1'")
	SQL_UPDATE(DATABASE_NAME, "int_maxamount = '0'", "uniqueID = '1'")
	SQL_UPDATE(DATABASE_NAME, "int_amountpercentage = '100'", "uniqueID = '1'")
	SQL_UPDATE(DATABASE_NAME, "int_groupID = '1'", "uniqueID = '1'")
	SQL_UPDATE(DATABASE_NAME, "int_prerole = '0'", "uniqueID = '1'")
	SQL_UPDATE(DATABASE_NAME, "bool_visible = '1'", "uniqueID = '1'")
	SQL_UPDATE(DATABASE_NAME, "bool_locked = '0'", "uniqueID = '1'")
	SQL_UPDATE(DATABASE_NAME, "bool_whitelist = '0'", "uniqueID = '1'")
end
-- CONVERTING

-- darkrp
function ConvertToDarkRPJob(tab)
	local _job = {}

	_job.name = tab.string_name
	local _pms = string.Explode(",", "")
	_job.model = _pms
	_job.description = tab.string_description
	local _weapons = string.Explode(",", "")
	_job.weapons = _weapons
	_job.max = tonumber(tab.int_maxamount)
	_job.salary = tonumber(tab.int_salary)
	_job.admin = tonumber(tab.bool_adminonly) or 0
	_job.vote = tobool(tab.bool_voteable) or false
	if tab.string_licenses != "" then
		_job.hasLicense = true
	else
		_job.hasLicense = false
	end
	_job.candemote =	tobool(tab.bool_instructor) or false
	local gname = SQL_SELECT("yrp_ply_groups", "*", "uniqueID = '" .. tab.int_groupID .. "'")
	if wk(gname) then
		gname = gname[1].string_name
	end
	_job.category = gname or "invalid group"
	_job.command = ConvertToDarkRPJobName(tab.string_name)

	return _job
end

local drp_allroles = SQL_SELECT(DATABASE_NAME, "*", nil)
local TEAMS = {}
if wk(drp_allroles) then
	for i, role in pairs(drp_allroles) do
		local teamname = ConvertToDarkRPJobName(role.string_name)
		TEAMS[teamname] = ConvertToDarkRPJob(role)
		_G[teamname] = TEAMS["TEAM_" .. role.string_name]
	end
end

util.AddNetworkString("send_team")
local Player = FindMetaTable("Player")
function Player:SendTeamsToPlayer()
	for i, role in pairs(TEAMS) do
		net.Start("send_team")
			net.WriteString(i)
			net.WriteTable(role)
		net.Send(self)
	end
end
-- darkrp

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
			if tab.netstr == "update_role_int_prerole" then
				if wk(cur) then
					cur = cur[1]
					SendRoleList(nil, tonumber(cur.int_groupID), tonumber(cur.int_prerole))
				end
				SendRoleList(nil, tonumber(cur.int_groupID), 0)
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
			if tab.netstr == "update_role_int_prerole" then
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
			if tab.netstr == "update_role_int_prerole" then
				if wk(cur) then
					cur = cur[1]
					SendGroupList(tonumber(cur.int_parentrole))
				end
				SendGroupList(int)
			end
		end)
	end
end

function SubscribeRoleList(ply, gro, pre)
	if HANDLER_GROUPSANDROLES["roleslist"][gro] == nil then
		HANDLER_GROUPSANDROLES["roleslist"][gro] = {}
	end
	if HANDLER_GROUPSANDROLES["roleslist"][gro][pre] == nil then
		HANDLER_GROUPSANDROLES["roleslist"][gro][pre] = {}
	end
	if !table.HasValue(HANDLER_GROUPSANDROLES["roleslist"][gro][pre], ply) then
		table.insert(HANDLER_GROUPSANDROLES["roleslist"][gro][pre], ply)
		printGM("gm", ply:YRPName() .. " subscribed to RoleList " .. gro .. " pre: " .. pre)
	else
		printGM("gm", ply:YRPName() .. " already subscribed to RoleList " .. gro .. " pre: " .. pre)
	end
end

function UnsubscribeRoleList(ply, gro, pre)
	if HANDLER_GROUPSANDROLES["roleslist"][gro] == nil then
		HANDLER_GROUPSANDROLES["roleslist"][gro] = {}
	end
	if HANDLER_GROUPSANDROLES["roleslist"][gro][pre] == nil then
		HANDLER_GROUPSANDROLES["roleslist"][gro][pre] = {}
	end
	if table.HasValue(HANDLER_GROUPSANDROLES["roleslist"][gro][pre], ply) then
		table.RemoveByValue(HANDLER_GROUPSANDROLES["roleslist"][gro][pre], ply)
		printGM("gm", ply:YRPName() .. " unsubscribed from RoleList " .. gro .. " pre: " .. pre)
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

function SortRoles(gro, pre)
	local siblings = SQL_SELECT(DATABASE_NAME, "*", "int_groupID = '" .. gro .. "' AND int_prerole = '" .. pre .. "'")

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

function SendRoleList(ply, gro, pre)
	gro = tonumber(gro)
	pre = tonumber(pre)
	if gro != nil and pre != nil then
		SortRoles(gro, pre)

		local tbl_roles = SQL_SELECT(DATABASE_NAME, "*", "int_groupID = '" .. gro .. "' AND int_prerole = '" .. pre .. "'")
		if !wk(tbl_roles) then
			tbl_roles = {}
		end

		local headername = "NOT FOUND"
		if pre > 0 then
			headername = SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '" .. pre .. "'")
			if worked(headername) then
				headername = headername[1].string_name
			end
		else
			headername = SQL_SELECT("yrp_ply_groups", "*", "uniqueID = '" .. gro .. "'")
			if worked(headername) then
				headername = headername[1].string_name
			end
		end
		if wk(headername) then
			if ply != nil then
				net.Start("settings_subscribe_rolelist")
					net.WriteTable(tbl_roles)
					net.WriteString(headername)
					net.WriteString(gro)
					net.WriteString(pre)
				net.Send(ply)
			else
				local tbl_bc = HANDLER_GROUPSANDROLES["roleslist"][gro][pre] or {}
				for i, pl in pairs(tbl_bc) do
					net.Start("settings_subscribe_rolelist")
						net.WriteTable(tbl_roles)
						net.WriteString(headername)
						net.WriteString(gro)
						net.WriteString(pre)
					net.Send(pl)
				end
			end
		else
			YRP.msg("note", "headername: " .. tostring(headername))
		end
	else
		YRP.msg("error", "SendRoleList(" .. tostring(gro) .. ", " .. tostring(pre) .. ")")
	end
end

-- Duplicate
function DuplicateRole(ruid)
	ruid = ruid or "-1"
	ruid = tonumber(ruid)
	if ruid > -1 then
		local role = SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '" .. ruid .. "'")
		if wk(role) then
			role = role[1]

			guid = guid or role.int_groupID
			guid = tonumber(guid)

			local cols = {}
			local vals = {}
			for name, value in pairs(role) do
				if name != "uniqueID" and name != "int_removeable" then
					if name == "int_groupID" then
						value = guid
					end
					table.insert(cols, name)
					table.insert(vals, "'" .. value .. "'")
				end
			end

			cols = table.concat(cols, ", ")
			vals = table.concat(vals, ", ")

			SQL_INSERT_INTO(DATABASE_NAME, cols, vals)

			SendRoleList(nil, guid, role.int_prerole)
		else
			printGM("note", "Role [" .. ruid .. "] was deleted.")
		end
	end
end

util.AddNetworkString("duplicated_role")
net.Receive("duplicated_role", function(len, ply)
	local ruid = tonumber(net.ReadString())
	DuplicateRole(ruid)
end)

-- Role menu
util.AddNetworkString("get_grp_roles")
net.Receive("get_grp_roles", function(len, ply)
	local _uid = net.ReadString()
	local _roles = SQL_SELECT(DATABASE_NAME, "*", "int_groupID = '" .. _uid .. "'")
	if wk(_roles) then
		for i, ro in pairs(_roles) do
			updateRoleUses(ro.uniqueID)
			ro.pms = GetPMTableOfRole(ro.uniqueID)
		end
		net.Start("get_grp_roles")
			net.WriteTable(_roles)
		net.Send(ply)
	else
		printGM("note", "Group [" .. _uid .. "] has no roles.")
	end
end)

util.AddNetworkString("get_rol_prerole")
net.Receive("get_rol_prerole", function(len, ply)
	local _uid = net.ReadString()
	local _roles = SQL_SELECT(DATABASE_NAME, "*", "int_prerole = '" .. _uid .. "'")

	if wk(_roles) then
		for i, ro in pairs(_roles) do
			ro.pms = GetPMTableOfRole(ro.uniqueID)
		end
		_roles = _roles[1]

		net.Start("get_rol_prerole")
			net.WriteTable(_roles)
		net.Send(ply)
	end
end)

-- Role Settings
util.AddNetworkString("settings_subscribe_rolelist")
net.Receive("settings_subscribe_rolelist", function(len, ply)
	local gro = tonumber(net.ReadString())
	local pre = tonumber(net.ReadString())

	SubscribeRoleList(ply, gro, pre)
	SendRoleList(ply, gro, pre)
end)

util.AddNetworkString("settings_subscribe_prerolelist")
net.Receive("settings_subscribe_prerolelist", function(len, ply)
	local gro = tonumber(net.ReadString())
	local pre = tonumber(net.ReadString())

	pre = SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '" .. pre .. "'")
	pre = tonumber(pre[1].int_prerole)
	SubscribeRoleList(ply, gro, pre)
	SendRoleList(ply, gro, pre)
end)

util.AddNetworkString("settings_add_role")
net.Receive("settings_add_role", function(len, ply)
	local gro = tonumber(net.ReadString())
	local pre = tonumber(net.ReadString())

	local prerole = SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '" .. pre .. "'")
	local has_prerole = false
	if pre > 0 then
		-- Has Prerole
		has_prerole = true
	end

	SQL_INSERT_INTO(DATABASE_NAME, "int_groupID, int_prerole", "'" .. gro .. "', '" .. pre .. "'")

	local roles = SQL_SELECT(DATABASE_NAME, "*", "int_groupID = '" .. gro .. "' AND int_prerole = '" .. pre .. "'")

	local count = tonumber(table.Count(roles))
	local new_role = roles[count]
	if has_prerole then
		prerole = prerole[1]
		for name, value in pairs(prerole) do
			local except = {"uniqueID", "int_prerole", "int_position", "int_groupID"}
			if !table.HasValue(except, name) then
				SQL_UPDATE(DATABASE_NAME, name .. " = '" .. value .. "'", "uniqueID = '" .. new_role.uniqueID .. "'")
			end
		end
	--else
		--SQL_UPDATE(DATABASE_NAME, "string_idstructure = '" .. "!D!D!D!D-!D!D!D!D-!D!D!D!D" .. "'", "uniqueID = '" .. new_role.uniqueID .. "'")
	end

	local up = roles[count - 1]
	if count == 1 then
		SQL_UPDATE(DATABASE_NAME, "int_position = '" .. count .. "', ", "uniqueID = '" .. new_role.uniqueID .. "'")
	else
		SQL_UPDATE(DATABASE_NAME, "int_position = '" .. count .. "'", "uniqueID = '" .. new_role.uniqueID .. "'")
		--SQL_UPDATE(DATABASE_NAME, "int_dn = '" .. new_role.uniqueID .. "'", "uniqueID = '" .. up.uniqueID .. "'")
	end

	printGM("db", "Added new role: " .. new_role.uniqueID)

	SendRoleList(nil, gro, pre)
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
	role.int_prerole = tonumber(role.int_prerole)
	SendRoleList(nil, role.int_groupID, role.int_prerole)
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
	role.int_prerole = tonumber(role.int_prerole)
	SendRoleList(nil, role.int_groupID, role.int_prerole)
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

	local roles = SQL_SELECT(DATABASE_NAME, "string_name, uniqueID, int_groupID", nil)
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
	local gro = tonumber(net.ReadString())
	local pre = tonumber(net.ReadString())
	UnsubscribeRoleList(ply, gro, pre)
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
		role.int_prerole = tonumber(role.int_prerole)
		SendRoleList(nil, role.int_groupID, role.int_prerole)
	end
end)

util.AddNetworkString("getScoreboardGroups")
net.Receive("getScoreboardGroups", function(len, ply)
	local _tmpGroups = SQL_SELECT("yrp_ply_groups", "*", nil)
	if wk(_tmpGroups) then
		net.Start("getScoreboardGroups")
			net.WriteTable(_tmpGroups)
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
	local role = GetRole(ruid)

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
	local role = GetRole(ruid)

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
			local pms = SQL_SELECT("yrp_playermodels", "*", "uniqueID = '" .. val .. "'")
			if wk(pms) then
				pms = pms[1]
				local entry = {}
				entry.uniqueID = pms.uniqueID
				local name = pms.string_name
				if name == "" or	name == " " then
					name = pms.string_models
				end
				entry.string_name = SQL_STR_OUT(name)
				entry.string_models = SQL_STR_OUT(pms.string_models)
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
	for x, pm in pairs(allpms) do
		pm.string_models = SQL_STR_OUT(pm.string_models)
	end

	net.Start("get_all_playermodels")
		net.WriteTable(allpms)
	net.Send(ply)
end)

function AddPlayermodelToRole(ruid, muid)
	local role = GetRole(ruid)
	local pms = string.Explode(",", role.string_playermodels)
	if !table.HasValue(pms, tostring(muid)) then
		local oldpms = {}
		for i, pm in pairs(pms) do
			if !strEmpty(pm) then
				table.insert(oldpms, pm)
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

util.AddNetworkString("add_playermodels")
net.Receive("add_playermodels", function(len, ply)
	local ruid = net.ReadInt(32)
	local pms = net.ReadTable()
	local name = net.ReadString()
	local min = net.ReadString()
	local max = net.ReadString()
	pms = SQL_STR_IN(table.concat(pms, ","))
	SQL_INSERT_INTO("yrp_playermodels", "string_models, string_name, float_size_min, float_size_max", "'" .. pms .. "', '" .. name .. "', '" .. min .. "', '" .. max .. "'")

	local lastentry = SQL_SELECT("yrp_playermodels", "*", nil)
	lastentry = lastentry[table.Count(lastentry)]
	AddPlayermodelToRole(ruid, lastentry.uniqueID)
end)

function RemPlayermodelFromRole(ruid, muid)
	local role = GetRole(ruid)
	local pms = string.Explode(",", role.string_playermodels)
	local oldpms = {}
	for i, v in pairs(pms) do
		if !strEmpty(v) then
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
			if !strEmpty(swep) then
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
	local role = GetRole(ruid)
	local sweps = string.Explode(",", role.string_sweps)
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
	local role = GetRole(ruid)
	local sweps = string.Explode(",", role.string_sweps)
	local oldsweps = {}
	for i, v in pairs(sweps) do
		if !strEmpty(v) then
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

--not droppable sweps
function SendNDSweps(uid)
	local role = GetRole(uid)
	if wk(role) then
		local nettab = {}
		local ndsweps = string.Explode(",", role.string_ndsweps)
		for i, ndswep in pairs(ndsweps) do
			if !strEmpty(ndswep) then
				table.insert(nettab, ndswep)
			end
		end

		for i, pl in pairs(HANDLER_GROUPSANDROLES["roles"][uid]) do
			net.Start("get_role_ndsweps")
				net.WriteTable(nettab)
			net.Send(pl)
		end
	end
end

util.AddNetworkString("get_role_ndsweps")
net.Receive("get_role_ndsweps", function(len, ply)
	local uid = net.ReadInt(32)
	SendNDSweps(uid)
end)

function AddNDSwepToRole(ruid, ndswepcn)
	local role = GetRole(ruid)
	local ndsweps = string.Explode(",", role.string_ndsweps)
	if !table.HasValue(ndsweps, tostring(ndswepcn)) then
		local oldndsweps = {}
		for i, v in pairs(ndsweps) do
			if !strEmpty(v) then
				table.insert(oldndsweps, v)
			end
		end

		local newndsweps = oldndsweps
		table.insert(newndsweps, tostring(ndswepcn))
		newndsweps = string.Implode(",", newndsweps)

		SQL_UPDATE(DATABASE_NAME, "string_ndsweps = '" .. newndsweps .. "'", "uniqueID = '" .. ruid .. "'")
		SendNDSweps(ruid)
	end
end

util.AddNetworkString("add_role_ndswep")
net.Receive("add_role_ndswep", function(len, ply)
	local ruid = net.ReadInt(32)
	local ndswepcn = net.ReadString()

	AddNDSwepToRole(ruid, ndswepcn)
end)

function RemNDSwepFromRole(ruid, ndswepcn)
	local role = GetRole(ruid)
	local ndsweps = string.Explode(",", role.string_ndsweps)
	local oldndsweps = {}
	for i, v in pairs(ndsweps) do
		if !strEmpty(v) then
			table.insert(oldndsweps, v)
		end
	end

	local newndsweps = oldndsweps
	table.RemoveByValue(newndsweps, tostring(ndswepcn))
	newndsweps = string.Implode(",", newndsweps)

	SQL_UPDATE(DATABASE_NAME, "string_ndsweps = '" .. newndsweps .. "'", "uniqueID = '" .. ruid .. "'")
	SendNDSweps(ruid)
end

util.AddNetworkString("rem_role_ndswep")
net.Receive("rem_role_ndswep", function(len, ply)
	local ruid = net.ReadInt(32)
	local ndswepcn = net.ReadString()

	RemNDSwepFromRole(ruid, ndswepcn)
end)

--licenses
function SendLicenses(ruid)
	local role = GetRole(ruid)
	if wk(role) then
		local nettab = {}
		local licenses = string.Explode(",", role.string_licenses)
		for i, val in pairs(licenses) do
			local li = SQL_SELECT("yrp_licenses", "*", "uniqueID = '" .. val .. "'")
			if wk(li) then
				li = li[1]
				local entry = {}
				entry.uniqueID = li.uniqueID
				local name = li.name
				entry.string_name = name
				table.insert(nettab, entry)
			end
		end

		for i, pl in pairs(HANDLER_GROUPSANDROLES["roles"][ruid]) do
			net.Start("get_role_licenses")
				net.WriteTable(nettab)
			net.Send(pl)
		end
	end
end

function RemLicenseFromRole(ruid, muid)
	local role = GetRole(ruid)
	local lis = string.Explode(",", role.string_licenses)
	local oldlis = {}
	for i, v in pairs(lis) do
		if !strEmpty(v) then
			table.insert(oldlis, v)
		end
	end

	local newlis = oldlis
	table.RemoveByValue(newlis, tostring(muid))
	newlis = string.Implode(",", newlis)

	SQL_UPDATE(DATABASE_NAME, "string_licenses = '" .. newlis .. "'", "uniqueID = '" .. ruid .. "'")
	SendLicenses(ruid)
end

function CleanUpLicenses(ruid)
	local role = GetRole(ruid)
	local lis = string.Explode(",", role.string_licenses)

	for i, li in pairs(lis) do
		if li != "" then
			local found = SQL_SELECT("yrp_licenses", "*", "uniqueID = '" .. li .. "'")
			if !wk(found) then
				RemLicenseFromRole(ruid, li)
			end
		end
	end
end

util.AddNetworkString("get_role_licenses")
net.Receive("get_role_licenses", function(len, ply)
	local uid = net.ReadInt(32)
	CleanUpLicenses(uid)
	SendLicenses(uid)
end)

util.AddNetworkString("get_all_licenses")
net.Receive("get_all_licenses", function(len, ply)
	local alllis = SQL_SELECT("yrp_licenses", "*", nil)
	if !wk(alllis) then
		alllis = {}
	end
	net.Start("get_all_licenses")
		net.WriteTable(alllis)
	net.Send(ply)
end)

function AddLicenseToRole(ruid, muid)
	local role = GetRole(ruid)
	local lis = string.Explode(",", role.string_licenses)
	if !table.HasValue(lis, tostring(muid)) then
		local oldlis = {}
		for i, v in pairs(lis) do
			if !strEmpty(v) then
				table.insert(oldlis, v)
			end
		end

		local newlis = oldlis
		table.insert(newlis, tostring(muid))
		newlis = string.Implode(",", newlis)

		SQL_UPDATE(DATABASE_NAME, "string_licenses = '" .. newlis .. "'", "uniqueID = '" .. ruid .. "'")
		SendLicenses(ruid)
	end
end

util.AddNetworkString("add_role_license")
net.Receive("add_role_license", function(len, ply)
	local ruid = net.ReadInt(32)
	local muid = tonumber(net.ReadString())

	AddLicenseToRole(ruid, muid)
end)

util.AddNetworkString("add_license")
net.Receive("add_license", function(len, ply)
	local ruid = net.ReadInt(32)
	local WorldModel = net.ReadString()
	local name = net.ReadString()
	SQL_INSERT_INTO("yrp_licenses", "string_model, string_name", "'" .. WorldModel .. "', '" .. name .. "'")

	local lastentry = SQL_SELECT("yrp_licenses", "*", nil)
	lastentry = lastentry[table.Count(lastentry)]
	AddLicenseToRole(ruid, lastentry.uniqueID)
end)

util.AddNetworkString("rem_role_license")
net.Receive("rem_role_license", function(len, ply)
	local ruid = net.ReadInt(32)
	local muid = tonumber(net.ReadString())

	RemLicenseFromRole(ruid, muid)
end)

util.AddNetworkString("openInteractMenu")
net.Receive("openInteractMenu", function(len, ply)
	local tmpTargetSteamID = net.ReadString()

	local tmpTarget = nil
	for k, v in pairs(player.GetAll()) do
		if v:SteamID() == tmpTargetSteamID then
			tmpTarget = v
		end
	end
	if ea(tmpTarget) and tmpTarget:IsPlayer() then
		local idcard = SQL_SELECT("yrp_general", "*", nil)
		idcard = tobool(idcard[1].bool_identity_card)

		local tmpTargetChaTab = tmpTarget:GetChaTab()
		if wk(tmpTargetChaTab) then
			local tmpTargetRole = SQL_SELECT("yrp_ply_roles", "*", "uniqueID = " .. tmpTargetChaTab.roleID)

			local tmpT = ply:GetChaTab()
			local tmpTable = ply:GetRolTab()
			if wk(tmpT) and wk(tmpTable) then
				local isInstructor = false

				local tmpPromote = false
				local tmpPromoteName = ""

				local tmpDemote = false
				local tmpDemoteName = ""

				if tonumber(tmpTable.bool_instructor) == 1 then
					isInstructor = true

					local tmpSearch = true	--tmpTargetSteamID
					local tmpTableSearch = SQL_SELECT("yrp_ply_roles", "*", "uniqueID = " .. tmpTable.int_prerole)
					if wk(tmpTableSearch) then
						local tmpSearchUniqueID = tmpTableSearch[1].int_prerole

						local tmpCounter = 0
						while (tmpSearch) do
							if wk(tmpTableSearch) then
								tmpSearchUniqueID = tonumber(tmpTableSearch[1].int_prerole)

								if tonumber(tmpTargetRole[1].int_prerole) != 0 and tmpTableSearch[1].uniqueID == tmpTargetRole[1].uniqueID then
									tmpDemote = true
									local tmp = SQL_SELECT("yrp_ply_roles", "*", "uniqueID = " .. tmpTargetRole[1].int_prerole)
									tmpDemoteName = tmp[1].string_name
								end

								if tonumber(tmpSearchUniqueID) == tonumber(tmpTargetRole[1].uniqueID) then
									tmpPromote = true
									tmpPromoteName = tmpTableSearch[1].string_name
								end

								if tmpSearchUniqueID == 0 or tmpPromote and tmpDemote then
									if !tmpDemote and tonumber(tmpTargetRole[1].uniqueID) != 1 then
										tmpDemote = true
										local tmp = SQL_SELECT("yrp_ply_roles", "*", "uniqueID = '1'")
										tmpDemoteName = tmp[1].string_name
									end
									if !tmpPromote and tonumber(tmpTargetRole[1].uniqueID) == 1 then
										-- von CIV to First Role
										tmpPromote = true
										tmpPromoteName = tmpTableSearch[1].string_name
									end
									tmpSearch = false
								end
							end
							tmpTableSearch = SQL_SELECT("yrp_ply_roles", "*", "uniqueID = " .. tmpSearchUniqueID)

							--Only look for 30 preroles
							tmpCounter = tmpCounter + 1
							if tmpCounter >= 30 then
								printGM("note", "You have a loop in your preroles!")
								tmpSearch = false
							end
						end
					end
				end

				net.Start("openInteractMenu")
					net.WriteEntity(tmpTarget)

					net.WriteBool(idcard)

					net.WriteBool(isInstructor)

					net.WriteBool(tmpPromote)
					net.WriteString(tmpPromoteName)

					net.WriteBool(tmpDemote)
					net.WriteString(tmpDemoteName)
				net.Send(ply)
			end
		end
	end
end)

util.AddNetworkString("isidcardenabled")
net.Receive("isidcardenabled", function(len, ply)
	local idcard = SQL_SELECT("yrp_general", "*", nil)
	idcard = tobool(idcard[1].bool_identity_card)

	net.Start("isidcardenabled")
		net.WriteBool(idcard)
	net.Send(ply)
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

util.AddNetworkString("promotePlayer")
net.Receive("promotePlayer", function(len, ply)
	local tmpTargetSteamID = net.ReadString()

	local tmpTarget = nil
	for k, v in pairs( player.GetAll() ) do
		if v:SteamID() == tmpTargetSteamID then
			tmpTarget = v
		end
	end

	local tmpTableInstructorRole = ply:GetRolTab() --SQL_SELECT( "yrp_ply_roles", "*", "uniqueID = " .. tmpTableInstructor.roleID )

	local tmpTargetChaTab = tmpTarget:GetChaTab()

	if tonumber( tmpTableInstructorRole.bool_instructor ) == 1 then
		local tmpTableTargetRole = SQL_SELECT( "yrp_ply_roles", "*", "uniqueID = " .. tmpTargetChaTab.roleID )
		local tmpTableTargetPromoteRole = SQL_SELECT( "yrp_ply_roles", "*", "int_prerole = '" .. tmpTableTargetRole[1].uniqueID .. "' AND int_groupID = '" .. tmpTableInstructorRole.int_groupID .. "'" )
		local tmpTableTargetGroup = nil
		if tmpTableTargetPromoteRole != nil then
			tmpTableTargetGroup = SQL_SELECT( "yrp_ply_groups", "*", "uniqueID = " .. tmpTableTargetPromoteRole[1].int_groupID )
		else
			tmpTableTargetPromoteRole = SQL_SELECT( "yrp_ply_roles", "*", "int_prerole = '" .. 0 .. "' AND int_groupID = '" .. tmpTableInstructorRole.int_groupID .. "'" )
			tmpTableTargetGroup = SQL_SELECT( "yrp_ply_groups", "*", "uniqueID = " .. tmpTableTargetPromoteRole[1].int_groupID )
		end

		tmpTableTargetPromoteRole = tmpTableTargetPromoteRole[1]
		tmpTableTargetGroup = tmpTableTargetGroup[1]

		for k, v in pairs(player.GetAll()) do
			if tostring( v:SteamID() ) == tostring( tmpTargetSteamID ) then
				addToWhitelist( tmpTarget:SteamID(), tmpTableTargetPromoteRole.uniqueID, tmpTableTargetGroup.uniqueID, v:Nick() )
				break
			end
		end

		SetRole( tmpTarget, tmpTableTargetPromoteRole.uniqueID, true )

		printGM( "note", ply:Nick() .. " promoted " .. tmpTarget:Nick() .. " to " .. tmpTableTargetPromoteRole.uniqueID )
	elseif tonumber( tmpTableInstructorRole.bool_instructor ) == 0 then
		printGM( "error", "Player: " .. ply:Nick() .. " (" .. ply:SteamID() .. ") tried to use promote function! He is not an instructor!" )
	else
		printGM( "error", "ELSE promote: " .. tostring( tmpTableInstructorRole.bool_instructor ) )
	end
end)

util.AddNetworkString("demotePlayer")
net.Receive( "demotePlayer", function( len, ply )
	local tmpTargetSteamID = net.ReadString()

	local tmpTarget = nil
	for k, v in pairs( player.GetAll() ) do
		if v:SteamID() == tmpTargetSteamID then
			tmpTarget = v
		end
	end

	local tmpTableInstructorRole = ply:GetRolTab()

	local tmpTargetChaTab = tmpTarget:GetChaTab()

	if tonumber( tmpTableInstructorRole.bool_instructor ) == 1 then
		local tmpTableTargetRole = SQL_SELECT( "yrp_ply_roles", "*", "uniqueID = " .. tmpTargetChaTab.roleID )
		local tmpTableTargetDemoteRole = SQL_SELECT( "yrp_ply_roles", "*", "uniqueID = " .. tmpTableTargetRole[1].int_prerole )
		local tmpTableTargetGroup = nil
		if tmpTableTargetDemoteRole != nil then
			tmpTableTargetGroup = SQL_SELECT( "yrp_ply_groups", "*", "uniqueID = " .. tmpTableTargetDemoteRole[1].int_groupID )
		else
			tmpTableTargetDemoteRole = SQL_SELECT("yrp_ply_roles", "*", "uniqueID = '1'")
			tmpTableTargetGroup = SQL_SELECT("yrp_ply_groups", "*", "uniqueID = '1'")
		end
		tmpTableTargetDemoteRole = tmpTableTargetDemoteRole[1]
		tmpTableTargetGroup = tmpTableTargetGroup[1]

		removeFromWhitelist( tmpTarget:SteamID(), tmpTableTargetRole[1].uniqueID )
		SetRole( tmpTarget, tmpTableTargetDemoteRole.uniqueID )

		printGM( "note", ply:Nick() .. " demoted " .. tmpTarget:Nick() .. " to " .. tmpTableTargetDemoteRole.uniqueID )
	elseif tonumber( tmpTableInstructorRole.bool_instructor ) == 0 then
		printGM( "error", "Player: " .. ply:Nick() .. " (" .. ply:SteamID() .. ") tried to use demote function! He is not an instructor!" )
	else
		printGM( "error", "ELSE demote: " .. tostring( tmpTableInstructorRole.bool_instructor ) )
	end
end)

-- Role Reset
function CheckIfRoleExists(ply, ruid)
	local tab = {}
	tab.table = DATABASE_NAME
	tab.cols = {}
	tab.cols[1] = "*"
	tab.where = "uniqueID = '" .. ruid .. "'"
	local result = SQL.SELECT(tab)

	if result == nil then
		YRP.msg("note", "Role not exists anymore! Change back to default role!")

		local utab = {}
		utab.table = "yrp_characters"
		utab.sets = {}
		utab.sets["roleID"] = 1
		utab.sets["groupID"] = 1
		utab.where = "roleID = '" .. ruid .. "'"
		SQL.UPDATE(utab)

		ply:KillSilent()
	end
end

function GetRoleTable(rid)
	local result = SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '" .. rid .. "'")
	if wk(result) then
		result = result[1]
	end
	return result
end
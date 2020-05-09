--Copyright (C) 2017-2020 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

-- DO NOT TOUCH THE DATABASE FILES! If you have errors, report them here:
-- https://discord.gg/sEgNZxg

local DATABASE_NAME = "yrp_usergroups"

SQL_ADD_COLUMN(DATABASE_NAME, "bool_removeable", "INT DEFAULT 1")

SQL_ADD_COLUMN(DATABASE_NAME, "string_name", "TEXT DEFAULT 'unnamed usergroup'")
SQL_ADD_COLUMN(DATABASE_NAME, "string_color", "TEXT DEFAULT '0,0,0,255'")
SQL_ADD_COLUMN(DATABASE_NAME, "string_icon", "TEXT DEFAULT 'http://www.famfamfam.com/lab/icons/silk/icons/shield.png'")
SQL_ADD_COLUMN(DATABASE_NAME, "string_sweps", "TEXT DEFAULT ''")
SQL_ADD_COLUMN(DATABASE_NAME, "string_nonesweps", "TEXT DEFAULT ''")
SQL_ADD_COLUMN(DATABASE_NAME, "string_sents", "TEXT DEFAULT ''")
SQL_ADD_COLUMN(DATABASE_NAME, "string_licenses", "TEXT DEFAULT ''")

SQL_ADD_COLUMN(DATABASE_NAME, "int_position", "INT DEFAULT 1")

SQL_ADD_COLUMN(DATABASE_NAME, "int_characters_max", "INT DEFAULT 1")

SQL_ADD_COLUMN(DATABASE_NAME, "bool_adminaccess", "INT DEFAULT 0")

SQL_ADD_COLUMN(DATABASE_NAME, "bool_ac_database", "INT DEFAULT 0")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_console", "INT DEFAULT 0")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_status", "INT DEFAULT 0")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_yourrp_addons", "INT DEFAULT 0")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_levelsystem", "INT DEFAULT 0")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_design", "INT DEFAULT 0")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_general", "INT DEFAULT 0")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_realistic", "INT DEFAULT 0")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_groupsandroles", "INT DEFAULT 0")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_players", "INT DEFAULT 0")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_whitelist", "INT DEFAULT 0")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_money", "INT DEFAULT 0")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_licenses", "INT DEFAULT 0")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_shops", "INT DEFAULT 0")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_map", "INT DEFAULT 0")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_whitelist", "INT DEFAULT 0")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_feedback", "INT DEFAULT 0")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_usergroups", "INT DEFAULT 0")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_logs", "INT DEFAULT 0")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_blacklist", "INT DEFAULT 0")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_scale", "INT DEFAULT 0")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_darkrp", "INT DEFAULT 0")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_permaprops", "INT DEFAULT 0")

SQL_ADD_COLUMN(DATABASE_NAME, "bool_vehicles", "INT DEFAULT 0")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_weapons", "INT DEFAULT 0")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_entities", "INT DEFAULT 0")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_effects", "INT DEFAULT 0")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_npcs", "INT DEFAULT 0")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_props", "INT DEFAULT 0")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_ragdolls", "INT DEFAULT 0")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_noclip", "INT DEFAULT 0")

SQL_ADD_COLUMN(DATABASE_NAME, "bool_removetool", "INT DEFAULT 0")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_dynamitetool", "INT DEFAULT 0")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_creatortool", "INT DEFAULT 0")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_customfunctions", "INT DEFAULT 0")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_ignite", "INT DEFAULT 0")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_drive", "INT DEFAULT 0")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_flashlight", "INT DEFAULT 0")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_collision", "INT DEFAULT 0")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_gravity", "INT DEFAULT 0")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_keepupright", "INT DEFAULT 0")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_bodygroups", "INT DEFAULT 0")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_physgunpickup", "INT DEFAULT 0")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_physgunpickupplayer", "INT DEFAULT 0")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_physgunpickupworld", "INT DEFAULT 0")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_physgunpickupotherowner", "INT DEFAULT 0")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_canseeteammatesonmap", "INT DEFAULT 0")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_canseeenemiesonmap", "INT DEFAULT 0")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_canuseesp", "INT DEFAULT 0")

SQL_ADD_COLUMN(DATABASE_NAME, "bool_canusecontextmenu", "INT DEFAULT 1")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_canusespawnmenu", "INT DEFAULT 1")

--SQL_DROP_TABLE(DATABASE_NAME)
--db_is_empty(DATABASE_NAME)

local yrp_usergroups = SQL_SELECT(DATABASE_NAME, "*", nil)
if wk(yrp_usergroups) then
	for _i, _ug in pairs(yrp_usergroups) do
		_ug.string_name = _ug.string_name or "failed"
		_ug.string_name = string.lower(_ug.string_name)
		SQL_UPDATE(DATABASE_NAME, "string_name = '" .. _ug.string_name .. "'", "uniqueID = '" .. _ug.uniqueID .. "'")
	end
end
yrp_usergroups = SQL_SELECT(DATABASE_NAME, "*", nil)
if wk(yrp_usergroups) then
	for _i, _ug in pairs(yrp_usergroups) do
		local tmp = SQL_SELECT(DATABASE_NAME, "*", "string_name = '" .. _ug.string_name .. "'")
		if wk(tmp) and #tmp > 1 then
			for i, ug in pairs(tmp) do
				if i > 1 then
					SQL_DELETE_FROM(DATABASE_NAME, "uniqueID = '" .. ug.uniqueID .. "'")
				end
			end
		end
	end
end

if SQL_SELECT(DATABASE_NAME, "*", "string_name = 'superadmin'") == nil then
	local _str = "string_name, "
	_str = _str .. "bool_vehicles, "
	_str = _str .. "bool_weapons, "
	_str = _str .. "bool_entities, "
	_str = _str .. "bool_effects, "
	_str = _str .. "bool_npcs, "
	_str = _str .. "bool_props, "
	_str = _str .. "bool_ragdolls, "
	_str = _str .. "bool_noclip, "
	_str = _str .. "bool_removetool, "
	_str = _str .. "bool_dynamitetool, "
	_str = _str .. "bool_creatortool, "
	_str = _str .. "bool_customfunctions, "
	_str = _str .. "bool_ignite, "
	_str = _str .. "bool_drive, "
	_str = _str .. "bool_flashlight, "
	_str = _str .. "bool_collision, "
	_str = _str .. "bool_gravity, "
	_str = _str .. "bool_keepupright, "
	_str = _str .. "bool_bodygroups, "
	_str = _str .. "bool_physgunpickup, "
	_str = _str .. "bool_physgunpickupplayer, "
	_str = _str .. "bool_physgunpickupworld, "
	_str = _str .. "bool_adminaccess, "
	_str = _str .. "bool_design, "
	_str = _str .. "bool_general, "
	_str = _str .. "bool_realistic, "
	_str = _str .. "bool_groupsandroles, "
	_str = _str .. "bool_players, "
	_str = _str .. "bool_money, "
	_str = _str .. "bool_licenses, "
	_str = _str .. "bool_shops, "
	_str = _str .. "bool_map, "
	_str = _str .. "bool_whitelist, "
	_str = _str .. "bool_feedback, "
	_str = _str .. "bool_usergroups, "
	_str = _str .. "bool_ac_database, "
	_str = _str .. "bool_status, "
	_str = _str .. "bool_yourrp_addons, "
	_str = _str .. "int_position"

	local _str2 = "'superadmin', "
	_str2 = _str2 .. "1, 1, 1, 1, 1, 1, 1, 1"
	_str2 = _str2 .. ", 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1"
	_str2 = _str2 .. ", 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1"

	SQL_INSERT_INTO(DATABASE_NAME, _str , _str2)
end

if SQL_SELECT(DATABASE_NAME, "*", "string_name = 'admin'") == nil then
	local _str = "string_name"

	local _str2 = "'admin'"

	SQL_INSERT_INTO(DATABASE_NAME, _str , _str2)
end

if SQL_SELECT(DATABASE_NAME, "*", "string_name = 'user'") == nil then
	local _str = "string_name"

	local _str2 = "'user'"

	SQL_INSERT_INTO(DATABASE_NAME, _str , _str2)
end

SQL_DELETE_FROM(DATABASE_NAME, "string_name = 'yrp_usergroups'")
local unremoveable = SQL_SELECT(DATABASE_NAME, "*", "string_name = 'yrp_usergroups'")
if unremoveable == nil then
	local _str = "string_name, "
	_str = _str .. "bool_vehicles, "
	_str = _str .. "bool_weapons, "
	_str = _str .. "bool_entities, "
	_str = _str .. "bool_effects, "
	_str = _str .. "bool_npcs, "
	_str = _str .. "bool_props, "
	_str = _str .. "bool_ragdolls, "
	_str = _str .. "bool_noclip, "
	_str = _str .. "bool_removetool, "
	_str = _str .. "bool_dynamitetool, "
	_str = _str .. "bool_creatortool, "
	_str = _str .. "bool_customfunctions, "
	_str = _str .. "bool_ignite, "
	_str = _str .. "bool_drive, "
	_str = _str .. "bool_flashlight, "
	_str = _str .. "bool_collision, "
	_str = _str .. "bool_gravity, "
	_str = _str .. "bool_keepupright, "
	_str = _str .. "bool_bodygroups, "
	_str = _str .. "bool_physgunpickup, "
	_str = _str .. "bool_physgunpickupplayer, "
	_str = _str .. "bool_physgunpickupworld, "
	_str = _str .. "bool_adminaccess, "
	_str = _str .. "bool_design, "
	_str = _str .. "bool_general, "
	_str = _str .. "bool_realistic, "
	_str = _str .. "bool_groupsandroles, "
	_str = _str .. "bool_players, "
	_str = _str .. "bool_money, "
	_str = _str .. "bool_licenses, "
	_str = _str .. "bool_shops, "
	_str = _str .. "bool_map, "
	_str = _str .. "bool_whitelist, "
	_str = _str .. "bool_feedback, "
	_str = _str .. "bool_usergroups, "
	_str = _str .. "bool_ac_database, "
	_str = _str .. "bool_status, "
	_str = _str .. "bool_yourrp_addons, "
	_str = _str .. "bool_removeable, "
	_str = _str .. "int_position"

	local _str2 = "'yrp_usergroups', 1, 1, 1, 1, 1, 1, 1, 1"
	_str2 = _str2 .. ", 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1"
	_str2 = _str2 .. ", 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1"
	_str2 = _str2 .. ", 0, 0"

	SQL_INSERT_INTO(DATABASE_NAME, _str, _str2)
end

function SortUserGroups()
	local siblings = SQL_SELECT(DATABASE_NAME, "*", "string_name != 'yrp_usergroups'")

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
SortUserGroups()

--[[ Global Handler ]]--
local HANDLER_USERGROUPS = {}

function RemFromHandler_UserGroups(ply)
	table.RemoveByValue(HANDLER_USERGROUPS, ply)
	printGM("gm", ply:YRPName() .. " disconnected from UserGroups")
end

function AddToHandler_UserGroups(ply)
	if !table.HasValue(HANDLER_USERGROUPS, ply) then
		table.insert(HANDLER_USERGROUPS, ply)
		printGM("gm", ply:YRPName() .. " connected to UserGroups")
	else
		printGM("gm", ply:YRPName() .. " already connected to UserGroups")
	end
end

util.AddNetworkString("Disconnect_Settings_UserGroups")
net.Receive("Disconnect_Settings_UserGroups", function(len, ply)
	RemFromHandler_UserGroups(ply)
end)

local function ConvertToMains(tab)
	local res = {}

	for i, v in pairs(tab) do
		if !strEmpty(v) and !string.StartWith(v, "\t") and !string.find(v, "{") and !string.find(v, "}") then
			local ug = string.Replace(v, "\"", "")
			ug = string.Replace(ug, "\t", "")
			table.insert(res, string.lower(ug))
		end
	end

	return res
end

function GetULXUserGroups()
	local f = file.Read("ulib/groups.txt", "DATA")

	if !wk(f) then return end

	f = string.Explode("\n", f)
	f = ConvertToMains(f)
	for i, v in pairs(f) do
		local dbug = SQL_SELECT("yrp_usergroups", "*", "string_name = '" .. v .. "'")
		if dbug == nil then
			SQL_INSERT_INTO("yrp_usergroups", "string_name", "'" .. v .. "'")
		end
	end
end

util.AddNetworkString("Connect_Settings_UserGroups")
net.Receive("Connect_Settings_UserGroups", function(len, ply)
	GetULXUserGroups()

	printGM("gm", "Connect_Settings_UserGroups => " .. ply:YRPName())
	if ply:CanAccess("bool_usergroups") then
		AddToHandler_UserGroups(ply)
		local _usergroups = {}
		for k, v in pairs(player.GetAll()) do
			local _ug = string.lower(v:GetUserGroup())
			if SQL_SELECT(DATABASE_NAME, "*", "string_name = '" .. _ug .. "'") == nil then
				printGM("note", "usergroup: " .. _ug .. " not found, adding to db")
				SQL_INSERT_INTO(DATABASE_NAME, "string_name", "'" .. _ug .. "'")
			end
		end

		local _tmp = SQL_SELECT(DATABASE_NAME, "*", "string_name != 'yrp_usergroups'")
		local _ugs = {}
		for i, ug in pairs(_tmp) do
			_ugs[tonumber(ug.uniqueID)] = ug
		end
		net.Start("Connect_Settings_UserGroups")
			if _tmp != nil then
				net.WriteTable(_tmp)
			else
				net.WriteTable({})
			end
		net.Send(ply)
	end
end)

--[[ Usergroup Handler ]]--
local HANDLER_USERGROUP = {}

function RemFromHandler_UserGroup(ply, uid)
	HANDLER_USERGROUP[uid] = HANDLER_USERGROUP[uid] or {}
	if table.HasValue(HANDLER_USERGROUP[uid], ply) then
		table.RemoveByValue(HANDLER_USERGROUP[uid], ply)
		printGM("gm", ply:YRPName() .. " disconnected from UserGroup (" .. uid .. ")")
	else
		printGM("gm", ply:YRPName() .. " not connected to UserGroup (" .. uid .. ")")
	end
end

function AddToHandler_UserGroup(ply, uid)
	HANDLER_USERGROUP[uid] = HANDLER_USERGROUP[uid] or {}
	if !table.HasValue(HANDLER_USERGROUP[uid], ply) then
		table.insert(HANDLER_USERGROUP[uid], ply)
		printGM("gm", ply:YRPName() .. " connected to UserGroup (" .. uid .. ")")
	else
		printGM("gm", ply:YRPName() .. " already connected to UserGroup (" .. uid .. ")")
	end
end

util.AddNetworkString("Disconnect_Settings_UserGroup")
net.Receive("Disconnect_Settings_UserGroup", function(len, ply)
	local uid = tonumber(net.ReadString())
	RemFromHandler_UserGroup(ply, uid)
end)

util.AddNetworkString("Connect_Settings_UserGroup")
net.Receive("Connect_Settings_UserGroup", function(len, ply)
	local uid = tonumber(net.ReadString())
	AddToHandler_UserGroup(ply, uid)

	local _tmp = SQL_SELECT(DATABASE_NAME, "*", "uniqueID = " .. uid)
	if wk(_tmp) then
		_tmp = _tmp[1]
	end

	net.Start("Connect_Settings_UserGroup")
		if _tmp != nil then
			net.WriteTable(_tmp)
		else
			net.WriteTable({})
		end
	net.Send(ply)
end)

util.AddNetworkString("usergroup_add")
net.Receive("usergroup_add", function(len, ply)
	SQL_INSERT_INTO_DEFAULTVALUES(DATABASE_NAME)
	printGM("gm", ply:YRPName() .. " added a new UserGroup")

	SortUserGroups()

	local _tmp = SQL_SELECT(DATABASE_NAME, "*", "string_name != 'yrp_usergroups'")
	local _ugs = {}
	for i, ug in pairs(_tmp) do
		_ugs[tonumber(ug.uniqueID)] = ug
	end
	for i, pl in pairs(HANDLER_USERGROUPS) do
		net.Start("usergroup_add")
			net.WriteTable(_ugs)
		net.Send(pl)
	end
end)

util.AddNetworkString("usergroup_rem")
net.Receive("usergroup_rem", function(len, ply)
	local uid = tonumber(net.ReadString())
	SQL_DELETE_FROM(DATABASE_NAME, "uniqueID = '" .. uid .. "'")

	SortUserGroups()

	printGM("gm", ply:YRPName() .. " removed UserGroup (" .. uid .. ")")

	for i, pl in pairs(HANDLER_USERGROUPS) do
		net.Start("usergroup_rem")
			net.WriteString(uid)
		net.Send(pl)
	end
end)

--[[ Access Functions ]]--

local Player = FindMetaTable("Player")

function Player:NoAccess(site, usergroups)
	usergroups = usergroups or "yrp_usergroups"
	net.Start("setting_hasnoaccess")
		net.WriteString(site)
		net.WriteString(usergroups or "yrp_usergroups")
	net.Send(self)
end

util.AddNetworkString("setting_hasnoaccess")
function Player:CanAccess(site)
	local lsite = string.Replace(site, "bool_", "")
	local usergroups = ""

	local _ug = self:GetUserGroup() or "failed"
	_ug = string.lower(_ug)
	local _b = SQL_SELECT(DATABASE_NAME, site, "string_name = '" .. _ug .. "'")
	if wk(_b) then
		_b = tobool(_b[1][site])
		if !_b then
			local _ugs = SQL_SELECT(DATABASE_NAME, "string_name", "bool_usergroups = '1'")
			if wk(_ugs) then
				for i, ug in pairs(_ugs) do
					if usergroups == "" then
						usergroups = usergroups .. string.lower(ug.string_name)
					else
						usergroups = usergroups .. ", " .. string.lower(ug.string_name)
					end
				end
			end
			self:NoAccess(lsite, usergroups)
			printGM("note", self:YRPName() .. " can NOT access " .. lsite .. "")
		elseif _b then
			printGM("db", self:YRPName() .. " can access " .. lsite .. "")
		end
		return tobool(_b)
	end
	printGM("note", self:YRPName() .. " can NOT access " .. lsite .. "")
	self:NoAccess(lsite)
	return false
end

--[[ Usergroup Edit ]]--
util.AddNetworkString("usergroup_update_string_name")
net.Receive("usergroup_update_string_name", function(len, ply)
	local uid = tonumber(net.ReadString())
	local string_name = string.lower(net.ReadString())
	SQL_UPDATE(DATABASE_NAME, "string_name = '" .. string_name .. "'", "uniqueID = '" .. uid .. "'")

	printGM("db", ply:YRPName() .. " updated name of usergroup (" .. uid .. ") to [" .. string_name .. "]")

	for i, pl in pairs(HANDLER_USERGROUP[uid]) do
		if pl != ply then
			net.Start("usergroup_update_string_name")
				net.WriteString(string_name)
			net.Send(pl)
		end
	end
end)

util.AddNetworkString("usergroup_update_string_color")
net.Receive("usergroup_update_string_color", function(len, ply)
	local uid = tonumber(net.ReadString())
	local string_color = net.ReadString()
	SQL_UPDATE(DATABASE_NAME, "string_color = '" .. string_color .. "'", "uniqueID = '" .. uid .. "'")

	printGM("db", ply:YRPName() .. " updated color of usergroup (" .. uid .. ") to [" .. string_color .. "]")

	for i, pl in pairs(HANDLER_USERGROUP[uid]) do
		if pl != ply then
			net.Start("usergroup_update_string_color")
				net.WriteString(string_color)
			net.Send(pl)
		end
	end
end)

util.AddNetworkString("usergroup_update_icon")
net.Receive("usergroup_update_icon", function(len, ply)
	local uid = tonumber(net.ReadString())
	local string_icon = net.ReadString()
	SQL_UPDATE(DATABASE_NAME, "string_icon = '" .. string_icon .. "'", "uniqueID = '" .. uid .. "'")

	printGM("db", ply:YRPName() .. " updated string_icon of usergroup (" .. uid .. ") to [" .. string_icon .. "]")

	for i, pl in pairs(HANDLER_USERGROUP[uid]) do
		if pl != ply then
			net.Start("usergroup_update_icon")
				net.WriteString(string_icon)
			net.Send(pl)
		end
	end
end)

util.AddNetworkString("usergroup_update_string_sweps")
net.Receive("usergroup_update_string_sweps", function(len, ply)
	local uid = tonumber(net.ReadString())
	local string_sweps = net.ReadString()
	SQL_UPDATE(DATABASE_NAME, "string_sweps = '" .. string_sweps .. "'", "uniqueID = '" .. uid .. "'")

	printGM("db", ply:YRPName() .. " updated string_sweps of usergroup (" .. uid .. ") to [" .. string_sweps .. "]")

	for i, pl in pairs(HANDLER_USERGROUP[uid]) do
		net.Start("usergroup_update_string_sweps")
			net.WriteString(string_sweps)
		net.Send(pl)
	end
end)

util.AddNetworkString("usergroup_update_string_nonesweps")
net.Receive("usergroup_update_string_nonesweps", function(len, ply)
	local uid = tonumber(net.ReadString())
	local string_nonesweps = net.ReadString()
	SQL_UPDATE(DATABASE_NAME, "string_nonesweps = '" .. string_nonesweps .. "'", "uniqueID = '" .. uid .. "'")

	printGM("db", ply:YRPName() .. " updated string_nonesweps of usergroup (" .. uid .. ") to [" .. string_nonesweps .. "]")

	for i, pl in pairs(HANDLER_USERGROUP[uid]) do
		net.Start("usergroup_update_string_nonesweps")
			net.WriteString(string_nonesweps)
		net.Send(pl)
	end
end)

util.AddNetworkString("usergroup_update_entities")
net.Receive("usergroup_update_entities", function(len, ply)
	local uid = tonumber(net.ReadString())
	local string_entities = net.ReadString()
	SQL_UPDATE(DATABASE_NAME, "string_entities = '" .. string_entities .. "'", "uniqueID = '" .. uid .. "'")

	printGM("db", ply:YRPName() .. " updated string_entities of usergroup (" .. uid .. ") to [" .. string_entities .. "]")

	for i, pl in pairs(HANDLER_USERGROUP[uid]) do
		net.Start("usergroup_update_entities")
			net.WriteString(string_entities)
		net.Send(pl)
	end
end)

function AddSENTToSENTS(tbl, sent)
	local tmp = string.Explode(",", sent)
	tbl[tmp[2]] = tmp[1]
	return tbl
end

function RemSENTFromSENTS(tbl, sent)
	tbl[sent] = nil
	return tbl
end

util.AddNetworkString("usergroup_add_sent")
net.Receive("usergroup_add_sent", function(len, ply)
	local uid = tonumber(net.ReadString())
	local sent = "1," .. net.ReadString()

	local sents = SQL_SELECT(DATABASE_NAME, "sents", "uniqueID = '" .. uid .. "'")
	if wk(sents) then
		sents = sents[1].sents
	else
		sents = ""
	end

	sents = SENTSTable(sents)
	sents = AddSENTToSENTS(sents, sent)
	sents = SENTSString(sents)

	SQL_UPDATE(DATABASE_NAME, "sents = '" .. sents .. "'", "uniqueID = '" .. uid .. "'")

	printGM("db", ply:YRPName() .. " added sent [ " .. sent .. " ] for usergroup (" .. uid .. ")")

	for i, pl in pairs(HANDLER_USERGROUP[uid]) do
		net.Start("usergroup_add_sent")
			net.WriteString(sents)
		net.Send(pl)
	end
end)

util.AddNetworkString("usergroup_rem_sent")
net.Receive("usergroup_rem_sent", function(len, ply)
	local uid = tonumber(net.ReadString())
	local sent = net.ReadString()

	local sents = SQL_SELECT(DATABASE_NAME, "sents", "uniqueID = '" .. uid .. "'")
	if wk(sents) then
		sents = sents[1].sents
	else
		sents = ""
	end

	sents = SENTSTable(sents)
	sents = RemSENTFromSENTS(sents, sent)
	sents = SENTSString(sents)

	SQL_UPDATE(DATABASE_NAME, "sents = '" .. sents .. "'", "uniqueID = '" .. uid .. "'")

	printGM("db", ply:YRPName() .. " removed sent [ " .. sent .. " ] for usergroup (" .. uid .. ")")

	for i, pl in pairs(HANDLER_USERGROUP[uid]) do
		net.Start("usergroup_rem_sent")
			net.WriteString(sent)
		net.Send(pl)
	end
end)

util.AddNetworkString("usergroup_sent_up")
net.Receive("usergroup_sent_up", function(len, ply)
	local uid = tonumber(net.ReadString())
	local sent = net.ReadString()

	local sents = SQL_SELECT(DATABASE_NAME, "sents", "uniqueID = '" .. uid .. "'")
	if wk(sents) then
		sents = sents[1].sents
	else
		sents = ""
	end

	sents = SENTSTable(sents)
	sents[sent] = tonumber(sents[sent]) + 1
	sents = SENTSString(sents)

	SQL_UPDATE(DATABASE_NAME, "sents = '" .. sents .. "'", "uniqueID = '" .. uid .. "'")

	for i, pl in pairs(HANDLER_USERGROUP[uid]) do
		net.Start("usergroup_sent_up")
			net.WriteString(sents)
		net.Send(pl)
	end
end)

util.AddNetworkString("usergroup_sent_dn")
net.Receive("usergroup_sent_dn", function(len, ply)
	local uid = tonumber(net.ReadString())
	local sent = net.ReadString()

	local sents = SQL_SELECT(DATABASE_NAME, "sents", "uniqueID = '" .. uid .. "'")
	if wk(sents) then
		sents = sents[1].sents
	else
		sents = ""
	end

	sents = SENTSTable(sents)
	sents[sent] = tonumber(sents[sent]) - 1
	sents = SENTSString(sents)

	SQL_UPDATE(DATABASE_NAME, "sents = '" .. sents .. "'", "uniqueID = '" .. uid .. "'")

	for i, pl in pairs(HANDLER_USERGROUP[uid]) do
		net.Start("usergroup_sent_dn")
			net.WriteString(sents)
		net.Send(pl)
	end
end)

function UGUpdateInt(ply, uid, name, value)
	name = name or "UNNAMED"
	name = string.lower(name)
	SQL_UPDATE(DATABASE_NAME, name .. " = '" .. value .. "'", "uniqueID = '" .. uid .. "'")

	printGM("db", ply:YRPName() .. " updated " .. name .. " of usergroup (" .. uid .. ") to [" .. value .. "]")

	for i, pl in pairs(HANDLER_USERGROUP[uid]) do
		net.Start("usergroup_update_" .. name)
			net.WriteString(value)
		net.Send(pl)
	end

	local ug = SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '" .. uid .. "'")
	if wk(ug) then
		ug = ug[1]
		ug.string_name = string.lower(ug.string_name)
		for i, pl in pairs(player.GetAll()) do
			if string.lower(pl:GetUserGroup()) == ug.string_name then
				pl:SetDInt(name, value)
			end
		end
	end
end

function UGCheckBox(ply, uid, name, value)
	name = name or "UNNAMED"
	name = string.lower(name)
	SQL_UPDATE(DATABASE_NAME, name .. " = '" .. value .. "'", "uniqueID = '" .. uid .. "'")

	printGM("db", ply:YRPName() .. " updated " .. name .. " of usergroup (" .. uid .. ") to [" .. value .. "]")

	for i, pl in pairs(HANDLER_USERGROUP[uid]) do
		net.Start("usergroup_update_" .. name)
			net.WriteString(value)
		net.Send(pl)
	end

	local ug = SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '" .. uid .. "'")
	if wk(ug) then
		ug = ug[1]
		ug.string_name = string.lower(ug.string_name)
		for i, pl in pairs(player.GetAll()) do
			if string.lower(pl:GetUserGroup()) == ug.string_name then
				pl:SetDBool(name, tobool(value))
			end
		end
	end
end

util.AddNetworkString("usergroup_update_bool_ac_database")
net.Receive("usergroup_update_bool_ac_database", function(len, ply)
	local uid = tonumber(net.ReadString())
	local bool_ac_database = net.ReadString()
	UGCheckBox(ply, uid, "bool_ac_database", bool_ac_database)
end)

util.AddNetworkString("usergroup_update_bool_darkrp")
net.Receive("usergroup_update_bool_darkrp", function(len, ply)
	local uid = tonumber(net.ReadString())
	local bool_darkrp = net.ReadString()
	UGCheckBox(ply, uid, "bool_darkrp", bool_darkrp)
end)

util.AddNetworkString("usergroup_update_bool_permaprops")
net.Receive("usergroup_update_bool_permaprops", function(len, ply)
	local uid = tonumber(net.ReadString())
	local bool_permaprops = net.ReadString()
	UGCheckBox(ply, uid, "bool_permaprops", bool_permaprops)
end)

util.AddNetworkString("usergroup_update_bool_console")
net.Receive("usergroup_update_bool_console", function(len, ply)
	local uid = tonumber(net.ReadString())
	local bool_console = net.ReadString()
	UGCheckBox(ply, uid, "bool_console", bool_console)
end)

util.AddNetworkString("usergroup_update_bool_status")
net.Receive("usergroup_update_bool_status", function(len, ply)
	local uid = tonumber(net.ReadString())
	local bool_status = net.ReadString()
	UGCheckBox(ply, uid, "bool_status", bool_status)
end)

util.AddNetworkString("usergroup_update_bool_yourrp_addons")
net.Receive("usergroup_update_bool_yourrp_addons", function(len, ply)
	local uid = tonumber(net.ReadString())
	local bool_yourrp_addons = net.ReadString()
	UGCheckBox(ply, uid, "bool_yourrp_addons", bool_yourrp_addons)
end)

util.AddNetworkString("usergroup_update_bool_adminaccess")
net.Receive("usergroup_update_bool_adminaccess", function(len, ply)
	local uid = tonumber(net.ReadString())
	local bool_adminaccess = net.ReadString()
	UGCheckBox(ply, uid, "bool_adminaccess", bool_adminaccess)
end)

util.AddNetworkString("usergroup_update_bool_general")
net.Receive("usergroup_update_bool_general", function(len, ply)
	local uid = tonumber(net.ReadString())
	local bool_general = net.ReadString()
	UGCheckBox(ply, uid, "bool_general", bool_general)
end)

util.AddNetworkString("usergroup_update_bool_levelsystem")
net.Receive("usergroup_update_bool_levelsystem", function(len, ply)
	local uid = tonumber(net.ReadString())
	local bool_levelsystem = net.ReadString()
	UGCheckBox(ply, uid, "bool_levelsystem", bool_levelsystem)
end)

util.AddNetworkString("usergroup_update_bool_design")
net.Receive("usergroup_update_bool_design", function(len, ply)
	local uid = tonumber(net.ReadString())
	local bool_design = net.ReadString()
	UGCheckBox(ply, uid, "bool_design", bool_design)
end)

util.AddNetworkString("usergroup_update_bool_realistic")
net.Receive("usergroup_update_bool_realistic", function(len, ply)
	local uid = tonumber(net.ReadString())
	local bool_realistic = net.ReadString()
	UGCheckBox(ply, uid, "bool_realistic", bool_realistic)
end)

util.AddNetworkString("usergroup_update_bool_money")
net.Receive("usergroup_update_bool_money", function(len, ply)
	local uid = tonumber(net.ReadString())
	local bool_money = net.ReadString()
	UGCheckBox(ply, uid, "bool_money", bool_money)
end)

util.AddNetworkString("usergroup_update_bool_licenses")
net.Receive("usergroup_update_bool_licenses", function(len, ply)
	local uid = tonumber(net.ReadString())
	local bool_licenses = net.ReadString()
	UGCheckBox(ply, uid, "bool_licenses", bool_licenses)
end)

util.AddNetworkString("usergroup_update_bool_shops")
net.Receive("usergroup_update_bool_shops", function(len, ply)
	local uid = tonumber(net.ReadString())
	local bool_shops = net.ReadString()
	UGCheckBox(ply, uid, "bool_shops", bool_shops)
end)

util.AddNetworkString("usergroup_update_bool_map")
net.Receive("usergroup_update_bool_map", function(len, ply)
	local uid = tonumber(net.ReadString())
	local bool_map = net.ReadString()
	UGCheckBox(ply, uid, "bool_map", bool_map)
end)

util.AddNetworkString("usergroup_update_bool_feedback")
net.Receive("usergroup_update_bool_feedback", function(len, ply)
	local uid = tonumber(net.ReadString())
	local bool_feedback = net.ReadString()
	UGCheckBox(ply, uid, "bool_feedback", bool_feedback)
end)

util.AddNetworkString("usergroup_update_bool_usergroups")
net.Receive("usergroup_update_bool_usergroups", function(len, ply)
	local uid = tonumber(net.ReadString())
	local bool_usergroups = net.ReadString()
	UGCheckBox(ply, uid, "bool_usergroups", bool_usergroups)
end)

util.AddNetworkString("usergroup_update_bool_logs")
net.Receive("usergroup_update_bool_logs", function(len, ply)
	local uid = tonumber(net.ReadString())
	local bool_logs = net.ReadString()
	UGCheckBox(ply, uid, "bool_logs", bool_logs)
end)

util.AddNetworkString("usergroup_update_bool_blacklist")
net.Receive("usergroup_update_bool_blacklist", function(len, ply)
	local uid = tonumber(net.ReadString())
	local bool_blacklist = net.ReadString()
	UGCheckBox(ply, uid, "bool_blacklist", bool_blacklist)
end)

util.AddNetworkString("usergroup_update_bool_scale")
net.Receive("usergroup_update_bool_scale", function(len, ply)
	local uid = tonumber(net.ReadString())
	local bool_scale = net.ReadString()
	UGCheckBox(ply, uid, "bool_scale", bool_scale)
end)

util.AddNetworkString("usergroup_update_bool_groupsandroles")
net.Receive("usergroup_update_bool_groupsandroles", function(len, ply)
	local uid = tonumber(net.ReadString())
	local bool_groupsandroles = net.ReadString()
	UGCheckBox(ply, uid, "bool_groupsandroles", bool_groupsandroles)
end)

util.AddNetworkString("usergroup_update_bool_players")
net.Receive("usergroup_update_bool_players", function(len, ply)
	local uid = tonumber(net.ReadString())
	local bool_players = net.ReadString()
	UGCheckBox(ply, uid, "bool_players", bool_players)
end)

util.AddNetworkString("usergroup_update_bool_whitelist")
net.Receive("usergroup_update_bool_whitelist", function(len, ply)
	local uid = tonumber(net.ReadString())
	local bool_whitelist = net.ReadString()
	UGCheckBox(ply, uid, "bool_whitelist", bool_whitelist)
end)

util.AddNetworkString("usergroup_update_bool_vehicles")
net.Receive("usergroup_update_bool_vehicles", function(len, ply)
	local uid = tonumber(net.ReadString())
	local bool_vehicles = net.ReadString()
	UGCheckBox(ply, uid, "bool_vehicles", bool_vehicles)
end)

util.AddNetworkString("usergroup_update_bool_weapons")
net.Receive("usergroup_update_bool_weapons", function(len, ply)
	local uid = tonumber(net.ReadString())
	local bool_weapons = net.ReadString()
	UGCheckBox(ply, uid, "bool_weapons", bool_weapons)
end)

util.AddNetworkString("usergroup_update_bool_entities")
net.Receive("usergroup_update_bool_entities", function(len, ply)
	local uid = tonumber(net.ReadString())
	local bool_entities = net.ReadString()
	UGCheckBox(ply, uid, "bool_entities", bool_entities)
end)

util.AddNetworkString("usergroup_update_bool_effects")
net.Receive("usergroup_update_bool_effects", function(len, ply)
	local uid = tonumber(net.ReadString())
	local bool_effects = net.ReadString()
	UGCheckBox(ply, uid, "bool_effects", bool_effects)
end)

util.AddNetworkString("usergroup_update_bool_npcs")
net.Receive("usergroup_update_bool_npcs", function(len, ply)
	local uid = tonumber(net.ReadString())
	local bool_npcs = net.ReadString()
	UGCheckBox(ply, uid, "bool_npcs", bool_npcs)
end)

util.AddNetworkString("usergroup_update_bool_props")
net.Receive("usergroup_update_bool_props", function(len, ply)
	local uid = tonumber(net.ReadString())
	local bool_props = net.ReadString()
	UGCheckBox(ply, uid, "bool_props", bool_props)
end)

util.AddNetworkString("usergroup_update_bool_ragdolls")
net.Receive("usergroup_update_bool_ragdolls", function(len, ply)
	local uid = tonumber(net.ReadString())
	local bool_ragdolls = net.ReadString()
	UGCheckBox(ply, uid, "bool_ragdolls", bool_ragdolls)
end)

util.AddNetworkString("usergroup_update_bool_noclip")
net.Receive("usergroup_update_bool_noclip", function(len, ply)
	local uid = tonumber(net.ReadString())
	local bool_noclip = net.ReadString()
	UGCheckBox(ply, uid, "bool_noclip", bool_noclip)
end)

util.AddNetworkString("usergroup_update_bool_removetool")
net.Receive("usergroup_update_bool_removetool", function(len, ply)
	local uid = tonumber(net.ReadString())
	local bool_removetool = net.ReadString()
	UGCheckBox(ply, uid, "bool_removetool", bool_removetool)
end)

util.AddNetworkString("usergroup_update_bool_dynamitetool")
net.Receive("usergroup_update_bool_dynamitetool", function(len, ply)
	local uid = tonumber(net.ReadString())
	local bool_dynamitetool = net.ReadString()
	UGCheckBox(ply, uid, "bool_dynamitetool", bool_dynamitetool)
end)

util.AddNetworkString("usergroup_update_bool_creatortool")
net.Receive("usergroup_update_bool_creatortool", function(len, ply)
	local uid = tonumber(net.ReadString())
	local bool_creatortool = net.ReadString()
	UGCheckBox(ply, uid, "bool_creatortool", bool_creatortool)
end)

util.AddNetworkString("usergroup_update_bool_customfunctions")
net.Receive("usergroup_update_bool_customfunctions", function(len, ply)
	local uid = tonumber(net.ReadString())
	local bool_customfunctions = net.ReadString()
	UGCheckBox(ply, uid, "bool_customfunctions", bool_customfunctions)
end)

util.AddNetworkString("usergroup_update_bool_ignite")
net.Receive("usergroup_update_bool_ignite", function(len, ply)
	local uid = tonumber(net.ReadString())
	local bool_ignite = net.ReadString()
	UGCheckBox(ply, uid, "bool_ignite", bool_ignite)
end)

util.AddNetworkString("usergroup_update_bool_drive")
net.Receive("usergroup_update_bool_drive", function(len, ply)
	local uid = tonumber(net.ReadString())
	local bool_drive = net.ReadString()
	UGCheckBox(ply, uid, "bool_drive", bool_drive)
end)

util.AddNetworkString("usergroup_update_bool_flashlight")
net.Receive("usergroup_update_bool_flashlight", function(len, ply)
	local uid = tonumber(net.ReadString())
	local bool_flashlight = net.ReadString()
	UGCheckBox(ply, uid, "bool_flashlight", bool_flashlight)
end)

util.AddNetworkString("usergroup_update_bool_collision")
net.Receive("usergroup_update_bool_collision", function(len, ply)
	local uid = tonumber(net.ReadString())
	local bool_collision = net.ReadString()
	UGCheckBox(ply, uid, "bool_collision", bool_collision)
end)

util.AddNetworkString("usergroup_update_bool_gravity")
net.Receive("usergroup_update_bool_gravity", function(len, ply)
	local uid = tonumber(net.ReadString())
	local bool_gravity = net.ReadString()
	UGCheckBox(ply, uid, "bool_gravity", bool_gravity)
end)

util.AddNetworkString("usergroup_update_bool_keepupright")
net.Receive("usergroup_update_bool_keepupright", function(len, ply)
	local uid = tonumber(net.ReadString())
	local bool_keepupright = net.ReadString()
	UGCheckBox(ply, uid, "bool_keepupright", bool_keepupright)
end)

util.AddNetworkString("usergroup_update_bool_bodygroups")
net.Receive("usergroup_update_bool_bodygroups", function(len, ply)
	local uid = tonumber(net.ReadString())
	local bool_bodygroups = net.ReadString()
	UGCheckBox(ply, uid, "bool_bodygroups", bool_bodygroups)
end)

util.AddNetworkString("usergroup_update_bool_physgunpickup")
net.Receive("usergroup_update_bool_physgunpickup", function(len, ply)
	local uid = tonumber(net.ReadString())
	local bool_physgunpickup = net.ReadString()
	UGCheckBox(ply, uid, "bool_physgunpickup", bool_physgunpickup)
end)

util.AddNetworkString("usergroup_update_bool_physgunpickupplayer")
net.Receive("usergroup_update_bool_physgunpickupplayer", function(len, ply)
	local uid = tonumber(net.ReadString())
	local bool_physgunpickupplayer = net.ReadString()
	UGCheckBox(ply, uid, "bool_physgunpickupplayer", bool_physgunpickupplayer)
end)

util.AddNetworkString("usergroup_update_bool_physgunpickupworld")
net.Receive("usergroup_update_bool_physgunpickupworld", function(len, ply)
	local uid = tonumber(net.ReadString())
	local bool_physgunpickupworld = net.ReadString()
	UGCheckBox(ply, uid, "bool_physgunpickupworld", bool_physgunpickupworld)
end)

util.AddNetworkString("usergroup_update_bool_physgunpickupotherowner")
net.Receive("usergroup_update_bool_physgunpickupotherowner", function(len, ply)
	local uid = tonumber(net.ReadString())
	local bool_physgunpickupotherowner = net.ReadString()
	UGCheckBox(ply, uid, "bool_physgunpickupotherowner", bool_physgunpickupotherowner)
end)



util.AddNetworkString("usergroup_update_bool_canseeteammatesonmap")
net.Receive("usergroup_update_bool_canseeteammatesonmap", function(len, ply)
	local uid = tonumber(net.ReadString())
	local bool_canseeteammatesonmap = net.ReadString()
	UGCheckBox(ply, uid, "bool_canseeteammatesonmap", bool_canseeteammatesonmap)
end)

util.AddNetworkString("usergroup_update_bool_canseeenemiesonmap")
net.Receive("usergroup_update_bool_canseeenemiesonmap", function(len, ply)
	local uid = tonumber(net.ReadString())
	local bool_canseeenemiesonmap = net.ReadString()
	UGCheckBox(ply, uid, "bool_canseeenemiesonmap", bool_canseeenemiesonmap)
end)

util.AddNetworkString("usergroup_update_bool_canuseesp")
net.Receive("usergroup_update_bool_canuseesp", function(len, ply)
	local uid = tonumber(net.ReadString())
	local bool_canuseesp = net.ReadString()
	UGCheckBox(ply, uid, "bool_canuseesp", bool_canuseesp)
end)

util.AddNetworkString("usergroup_update_bool_canusecontextmenu")
net.Receive("usergroup_update_bool_canusecontextmenu", function(len, ply)
	local uid = tonumber(net.ReadString())
	local bool_canusecontextmenu = net.ReadString()
	UGCheckBox(ply, uid, "bool_canusecontextmenu", bool_canusecontextmenu)
end)

util.AddNetworkString("usergroup_update_bool_canusespawnmenu")
net.Receive("usergroup_update_bool_canusespawnmenu", function(len, ply)
	local uid = tonumber(net.ReadString())
	local bool_canusespawnmenu = net.ReadString()
	UGCheckBox(ply, uid, "bool_canusespawnmenu", bool_canusespawnmenu)
end)



util.AddNetworkString("usergroup_update_int_characters_max")
net.Receive("usergroup_update_int_characters_max", function(len, ply)
	local uid = tonumber(net.ReadString())
	local int_characters_max = net.ReadString()
	UGUpdateInt(ply, uid, "int_characters_max", int_characters_max)
end)



-- Functions
hook.Add("PlayerSpawnVehicle", "yrp_vehicles_restriction", function(pl, model, name, tab)
	if ea(pl) then
		local _tmp = SQL_SELECT(DATABASE_NAME, "bool_vehicles", "string_name = '" .. string.lower(pl:GetUserGroup()) .. "'")
		if worked(_tmp, "PlayerSpawnVehicle failed") then
			_tmp = _tmp[1]
			if tobool(_tmp.bool_vehicles) then
				return true
			else
				printGM("note", pl:Nick() .. " [" .. string.lower(pl:GetUserGroup()) .. "] tried to spawn a vehicle.")

				net.Start("yrp_info")
					net.WriteString("vehicles")
				net.Send(pl)

				return false
			end
		end
	end
end)

hook.Add("PlayerGiveSWEP", "yrp_weapons_restriction", function(pl)
	if ea(pl) then
		local _tmp = SQL_SELECT(DATABASE_NAME, "bool_weapons", "string_name = '" .. string.lower(pl:GetUserGroup()) .. "'")
		if worked(_tmp, "PlayerGiveSWEP failed") then
			_tmp = _tmp[1]
			if tobool(_tmp.bool_weapons) then
				return true
			else
				printGM("note", pl:Nick() .. " [" .. string.lower(pl:GetUserGroup()) .. "] tried to spawn a weapon.")

				net.Start("yrp_info")
					net.WriteString("weapon")
				net.Send(pl)

				return false
			end
		end
	end
end)

local Entity = FindMetaTable("Entity")
function Entity:YRPSetOwner(ply)
	self:SetDEntity("yrp_owner", ply)
end

function Entity:YRPRemoveOwner()
	self:SetDEntity("yrp_owner", NULL)
end

function HasUseFunction(ent)
	if IsEntity(ent) then
		if ent.Use != nil then
			ent:SetDBool("yrp_has_use", true)
		end
	end
end

hook.Add("PlayerSpawnedVehicle", "yrp_vehicles_spawned", function(pl, ent)
	ent:YRPSetOwner(pl)
	HasUseFunction(ent)

	SQL_INSERT_INTO("yrp_logs",	"string_timestamp, string_typ, string_source_steamid, string_value", "'" .. os.time() .. "' ,'LID_spawns', '" .. pl:SteamID64() .. "', 'Vehicle: " .. ent:GetClass() .. "'")
end)

hook.Add("PlayerSpawnedSWEP", "yrp_entities_spawned", function(pl, ent)
	ent:YRPSetOwner(pl)
	HasUseFunction(ent)

	SQL_INSERT_INTO("yrp_logs",	"string_timestamp, string_typ, string_source_steamid, string_value", "'" .. os.time() .. "' ,'LID_spawns', '" .. pl:SteamID64() .. "', 'Weapon: " .. ent:GetClass() .. "'")
end)

hook.Add("PlayerSpawnedSENT", "yrp_entities_spawned", function(pl, ent)
	ent:YRPSetOwner(pl)
	HasUseFunction(ent)

	SQL_INSERT_INTO("yrp_logs",	"string_timestamp, string_typ, string_source_steamid, string_value", "'" .. os.time() .. "' ,'LID_spawns', '" .. pl:SteamID64() .. "', 'Entity: " .. ent:GetClass() .. "'")
end)

hook.Add("PlayerSpawnedEffect", "yrp_effects_spawned", function(pl, model, ent)
	ent:YRPSetOwner(pl)
	HasUseFunction(ent)

	SQL_INSERT_INTO("yrp_logs",	"string_timestamp, string_typ, string_source_steamid, string_value", "'" .. os.time() .. "' ,'LID_spawns', '" .. pl:SteamID64() .. "', 'Effect: " .. ent:GetClass() .. "'")
end)

hook.Add("PlayerSpawnedNPC", "yrp_npcs_spawned", function(pl, ent)
	ent:YRPSetOwner(pl)
	HasUseFunction(ent)

	SQL_INSERT_INTO("yrp_logs",	"string_timestamp, string_typ, string_source_steamid, string_value", "'" .. os.time() .. "' ,'LID_spawns', '" .. pl:SteamID64() .. "', 'NPC: " .. ent:GetClass() .. "'")
end)

hook.Add("PlayerSpawnedProp", "yrp_props_spawned", function(pl, model, ent)
	ent:YRPSetOwner(pl)
	HasUseFunction(ent)

	SQL_INSERT_INTO("yrp_logs",	"string_timestamp, string_typ, string_source_steamid, string_value", "'" .. os.time() .. "' ,'LID_spawns', '" .. pl:SteamID64() .. "', 'PROP: " .. ent:GetClass() .. "'")
end)

hook.Add("PlayerSpawnedRagdoll", "yrp_ragdolls_spawned", function(pl, model, ent)
	ent:YRPSetOwner(pl)
	HasUseFunction(ent)

	SQL_INSERT_INTO("yrp_logs",	"string_timestamp, string_typ, string_source_steamid, string_value", "'" .. os.time() .. "' ,'LID_spawns', '" .. pl:SteamID64() .. "', 'Ragdoll: " .. ent:GetClass() .. "'")
end)

hook.Add("PlayerSpawnSENT", "yrp_entities_restriction", function(pl)
	if ea(pl) then
		local _tmp = SQL_SELECT(DATABASE_NAME, "bool_entities", "string_name = '" .. string.lower(pl:GetUserGroup()) .. "'")
		if worked(_tmp, "PlayerSpawnSENT failed") then
			_tmp = _tmp[1]
			if tobool(_tmp.bool_entities) then
				return true
			else
				printGM("note", pl:Nick() .. " [" .. string.lower(pl:GetUserGroup()) .. "] tried to spawn an entity.")

				net.Start("yrp_info")
					net.WriteString("entities")
				net.Send(pl)

				return false
			end
		end
	end
end)

hook.Add("PlayerSpawnEffect", "yrp_effects_restriction", function(pl)
	if ea(pl) then
		local _tmp = SQL_SELECT(DATABASE_NAME, "bool_effects", "string_name = '" .. string.lower(pl:GetUserGroup()) .. "'")
		if worked(_tmp, "PlayerSpawnEffect failed") then
			_tmp = _tmp[1]
			if tobool(_tmp.bool_effects) then
				return true
			else
				printGM("note", pl:Nick() .. " [" .. string.lower(pl:GetUserGroup()) .. "] tried to spawn an effect.")

				net.Start("yrp_info")
					net.WriteString("effects")
				net.Send(pl)

				return false
			end
		end
	end
end)

hook.Add("PlayerSpawnNPC", "yrp_npcs_restriction", function(pl)
	if ea(pl) then
		local _tmp = SQL_SELECT(DATABASE_NAME, "bool_npcs", "string_name = '" .. string.lower(pl:GetUserGroup()) .. "'")
		if worked(_tmp, "PlayerSpawnNPC failed") then
			_tmp = _tmp[1]
			if tobool(_tmp.bool_npcs) then
				return true
			else
				printGM("note", pl:Nick() .. " [" .. string.lower(pl:GetUserGroup()) .. "] tried to spawn a npc.")

				net.Start("yrp_info")
					net.WriteString("npcs")
				net.Send(pl)

				return false
			end
		end
	end
end)

hook.Add("PlayerSpawnProp", "yrp_props_restriction", function(pl)
	if ea(pl) then
		local _tmp = SQL_SELECT(DATABASE_NAME, "bool_props", "string_name = '" .. string.lower(pl:GetUserGroup()) .. "'")
		if wk(_tmp, "PlayerSpawnProp failed") then
			_tmp = _tmp[1]
			if tobool(_tmp.bool_props) then
				return true
			else
				printGM("note", pl:Nick() .. " [" .. string.lower(pl:GetUserGroup()) .. "] tried to spawn a prop.")

				net.Start("yrp_info")
					net.WriteString("props")
				net.Send(pl)
				return false
			end
		else
			printGM("db", "[PlayerSpawnProp] failed! UserGroup not found in database.")
			return false
		end
	end
end)

hook.Add("PlayerSpawnRagdoll", "yrp_ragdolls_restriction", function(pl, model)
	if ea(pl) then
		local _tmp = SQL_SELECT(DATABASE_NAME, "bool_ragdolls", "string_name = '" .. tostring(string.lower(pl:GetUserGroup())) .. "'")
		if wk(_tmp) then
			_tmp = _tmp[1]
			if tobool(_tmp.bool_ragdolls) then
				return true
			else
				printGM("note", pl:Nick() .. " [" .. string.lower(pl:GetUserGroup()) .. "] tried to spawn a ragdoll.")

				net.Start("yrp_info")
					net.WriteString("ragdolls")
				net.Send(pl)

				return false
			end
		else
			printGM("db", "[PlayerSpawnRagdoll] failed! UserGroup not found in database.")
		end
	end
end)

function RenderEquipment(ply, name, mode, color)
	local _eq = ply:GetDEntity(name)
	if ea(_eq) then
		_eq:SetRenderMode(mode)
		_eq:SetColor(color)
		_eq:SetDInt(name .. "mode", mode)
		_eq:SetDString(name .. "color", color.r .. "," .. color.g .. "," .. color.b .. "," .. color.a)
	end
end

function RenderEquipments(ply, mode, color)
	RenderEquipment(ply, "backpack", mode, color)

	RenderEquipment(ply, "weaponprimary1", mode, color)
	RenderEquipment(ply, "weaponprimary2", mode, color)
	RenderEquipment(ply, "weaponsecondary1", mode, color)
	RenderEquipment(ply, "weaponsecondary2", mode, color)
	RenderEquipment(ply, "weapongadget", mode, color)
end

function RenderCloaked(ply)
	if ea(ply) then
		local _alpha = 0
		ply:SetRenderMode(RENDERMODE_TRANSALPHA)
		ply:SetColor(Color(255, 255, 255, _alpha))
		for i, wp in pairs(ply:GetWeapons()) do
			wp:SetRenderMode(RENDERMODE_TRANSALPHA)
			wp:SetColor(Color(255, 255, 255, _alpha))
		end
		RenderEquipments(ply, RENDERMODE_TRANSALPHA, Color(255, 255, 255, _alpha))
	end
end

function RenderNoClip(ply, alpha)
	if ea(ply) then
		if ply:GetDBool("cloaked", false) then
			RenderCloaked(ply)
		else
			local _alpha = 255
			if IsNoClipEffectEnabled() then
				if IsNoClipStealthEnabled() then
					_alpha = 0
				else
					_alpha = 120
				end
			end

			ply:SetRenderMode(RENDERMODE_TRANSALPHA)
			ply:SetColor(Color(255, 255, 255, _alpha))
			for i, wp in pairs(ply:GetWeapons()) do
				wp:SetRenderMode(RENDERMODE_TRANSALPHA)
				wp:SetColor(Color(255, 255, 255, _alpha))
			end
			RenderEquipments(ply, RENDERMODE_TRANSALPHA, Color(255, 255, 255, _alpha))
		end

		--local model = GetGlobalDString("text_noclip_mdl", "")
		--if !strEmpty(model) then
			--ply:SetModel(model)
		--end
	end
end

function RenderFrozen(ply)
	if ea(ply) then
		if ply:GetDBool("cloaked", false) then
			RenderCloaked(ply)
		else
			ply:SetRenderMode(RENDERMODE_NORMAL)
			ply:SetColor(Color(0, 0, 255))
			for i, wp in pairs(ply:GetWeapons()) do
				wp:SetRenderMode(RENDERMODE_TRANSALPHA)
				wp:SetColor(Color(0, 0, 255))
			end
			RenderEquipments(ply, RENDERMODE_TRANSALPHA, Color(0, 0, 255))
		end
	end
end

function RenderNormal(ply)
	if ea(ply) then
		if ply:GetDBool("cloaked", false) then
			RenderCloaked(ply)
		elseif ply:IsFlagSet(FL_FROZEN) then
			RenderFrozen(ply)
		else
			setPlayerModel(ply)
			ply:SetRenderMode(RENDERMODE_NORMAL)
			ply:SetColor(Color(255, 255, 255, 255))
			for i, wp in pairs(ply:GetWeapons()) do
				wp:SetRenderMode(RENDERMODE_NORMAL)
				wp:SetColor(Color(255, 255, 255, 255))
			end
			RenderEquipments(ply, RENDERMODE_NORMAL, Color(255, 255, 255, 255))
		end
	end
end

hook.Add("PlayerNoClip", "yrp_noclip_restriction", function(pl, bool)
	if ea(pl) then
		if !bool then
			-- TURNED OFF
			RenderNormal(pl)

			local _pos = pl:GetPos()

			-- Stuck?
			local tr = {
				start = _pos,
				endpos = _pos,
				mins = pl:OBBMins(),
				maxs = pl:OBBMaxs(),
				filter = pl
			}
			local _t = util.TraceHull(tr)

			if _t.Hit then
				-- Up
				local trup = {
					start = _pos + Vector(0,0,100),
					endpos = _pos,
					mins = Vector(1,1,0),
					maxs = Vector(-1,-1,0),
					filter = pl
				}
				local _tup = util.TraceHull(trup)

				-- Down
				local trdn = {
					start = _pos,
					endpos = _pos + Vector(0,0,100),
					mins = Vector(1,1,0),
					maxs = Vector(-1,-1,0),
					filter = pl
				}
				local _tdn = util.TraceHull(trdn)

				timer.Simple(0.001, function()
					if !_tup.StartSolid and _tdn.StartSolid then
						pl:SetPos(_tup.HitPos + Vector(0, 0, 6))
					elseif _tup.StartSolid and !_tdn.StartSolid then
						pl:SetPos(_tdn.HitPos - Vector(0, 0, 72 + 6))
					elseif !_tup.StartSolid and !_tdn.StartSolid then
						_pos = _pos + Vector(0, 0, 36) -- Mid of Player
						if _pos:Distance(_tup.HitPos) < _pos:Distance(_tdn.HitPos) then
							pl:SetPos(_tup.HitPos + Vector(0, 0, 6))
						elseif _pos:Distance(_tup.HitPos) > _pos:Distance(_tdn.HitPos) then
							pl:SetPos(_tdn.HitPos - Vector(0, 0, 72 + 6))
						end
					end
				end)
			end
		else
			-- TURNED ON
			local _tmp = SQL_SELECT(DATABASE_NAME, "bool_noclip", "string_name = '" .. string.lower(pl:GetUserGroup()) .. "'")
			if wk(_tmp) then
				_tmp = _tmp[1]
				if tobool(_tmp.bool_noclip) then

					if IsNoClipModelEnabled() then
						local mdl = GetGlobalDString("text_noclip_mdl", "")
						if !strEmpty(mdl) then
							pl:SetModel(mdl)
						end
					end

					RenderNoClip(pl)
					return true
				else
					printGM("note", pl:Nick() .. " [" .. string.lower(pl:GetUserGroup()) .. "] tried to noclip.")

					net.Start("yrp_info")
						net.WriteString("noclip")
					net.Send(pl)

					return false
				end
			else
				printGM("db", "[noclip] failed! UserGroup not found in database.")
				return false
			end
		end
	end
end)

function GM:PhysgunPickup(pl, ent)
	if ent:IsDealer() then
		return false
	end
	local tabUsergroup = SQL_SELECT(DATABASE_NAME, "bool_physgunpickup, bool_physgunpickupworld, bool_physgunpickupplayer", "string_name = '" .. string.lower(pl:GetUserGroup()) .. "'")
	if wk(tabUsergroup) then
		tabUsergroup = tabUsergroup[1]
		if tobool(tabUsergroup.bool_physgunpickup) then
			if ent:IsPlayer() then
				if tobool(tabUsergroup.bool_physgunpickupplayer) then
					if ent:GetDInt("int_position", 0) >= pl:GetDInt("int_position", 0) then -- ent (target) > position as pl
						return true
					end
				else
					net.Start("yrp_info")
						net.WriteString("physgunpickupplayer")
					net.Send(pl)
					return false
				end
			elseif ent:CreatedByMap() then
				if tobool(tabUsergroup.bool_physgunpickupworld) then
					return true
				else
					return false
				end
			elseif ent:GetRPOwner() == pl or tobool(tabUsergroup.bool_physgunpickupotherowner) then
				return true
			elseif pl:HasAccess() then
				return true
			else
				return false
			end
		elseif ent:GetRPOwner() == pl then
			return true
		else
			net.Start("yrp_info")
				net.WriteString("physgunpickup")
			net.Send(pl)
			return false
		end
	else
		printGM("db", "[PhysgunPickup] failed! UserGroup not found in database.")
		return false
	end
	return false
end

hook.Add("CanTool", "yrp_can_tool", function(pl, tr, tool)
	if ea(pl) then
		local owner = tr.Entity:GetOwner()
		if owner == NULL then
			owner = tr.Entity:GetRPOwner()
		end
		if tool == "remover" then
			local _tmp = SQL_SELECT(DATABASE_NAME, "bool_removetool", "string_name = '" .. string.lower(pl:GetUserGroup()) .. "'")
			if wk(_tmp) then
				_tmp = _tmp[1]

				if tobool(_tmp.bool_removetool) and (pl:HasAccess() or (owner == pl or owner == NULL)) then
					return true
				else
					net.Start("yrp_info")
						net.WriteString("removetool")
					net.Send(pl)
					return false
				end
			else
				YRP.msg("note", "[CanTool] [remover] failed! UserGroup not found in database.")
				return false
			end
		elseif tool == "dynamite" then
			local _tmp = SQL_SELECT(DATABASE_NAME, "bool_dynamitetool", "string_name = '" .. string.lower(pl:GetUserGroup()) .. "'")
			if _tmp != nil and _tmp != false then
				_tmp = _tmp[1]
				if tobool(_tmp.bool_dynamitetool) then
					return true
				else
					net.Start("yrp_info")
						net.WriteString("bool_dynamitetool")
					net.Send(pl)
					return false
				end
			else
				YRP.msg("note", "[CanTool] [dynamite] failed! UserGroup not found in database.")
				return false
			end
		elseif tool == "creator" then
			local _tmp = SQL_SELECT(DATABASE_NAME, "bool_creatortool", "string_name = '" .. string.lower(pl:GetUserGroup()) .. "'")
			if _tmp != nil and _tmp != false then
				_tmp = _tmp[1]
				if tobool(_tmp.bool_creatortool) then
					return true
				else
					net.Start("yrp_info")
						net.WriteString("bool_creatortool")
					net.Send(pl)
					return false
				end
			else
				YRP.msg("note", "[CanTool] [customfunctions] failed! UserGroup not found in database.")
				return false
			end
		else
			local _tmp = SQL_SELECT(DATABASE_NAME, "bool_customfunctions", "string_name = '" .. string.lower(pl:GetUserGroup()) .. "'")
			if _tmp != nil and _tmp != false then
				_tmp = _tmp[1]
				if tobool(_tmp.bool_customfunctions) then
					return true
				else
					net.Start("yrp_info")
						net.WriteString("bool_customfunctions")
					net.Send(pl)
					return false
				end
			else
				YRP.msg("note", "[CanTool] [customfunctions] failed! UserGroup not found in database.")
				return false
			end
		end
	else
		YRP.msg("note", "[CanTool] Player is not valid!")
	end
end)

hook.Add("CanProperty", "yrp_canproperty", function(pl, property, ent)
	if ea(pl) then
		printGM("gm", "CanProperty: " .. property)
		if property == "ignite" or property == "extinguish" then
			local _tmp = SQL_SELECT(DATABASE_NAME, "bool_ignite", "string_name = '" .. string.lower(pl:GetUserGroup()) .. "'")
			if _tmp != nil and _tmp != false then
				_tmp = _tmp[1]
				if tobool(_tmp.bool_ignite) then
					return true
				else
					net.Start("yrp_info")
						net.WriteString("ignite")
					net.Send(pl)
					return false
				end
			else
				printGM("db", "[ignite] failed! UserGroup not found in database.")
				return false
			end
		elseif property == "remover" then
			local _tmp = SQL_SELECT(DATABASE_NAME, "bool_removetool", "string_name = '" .. string.lower(pl:GetUserGroup()) .. "'")
			if _tmp != nil and _tmp != false then
				_tmp = _tmp[1]
				if tobool(_tmp.bool_removetool) then
					return true
				else
					net.Start("yrp_info")
						net.WriteString("removetool")
					net.Send(pl)
					return false
				end
			else
				printGM("db", "[remover] failed! UserGroup not found in database.")
				return false
			end
		elseif property == "drive" then
			local _tmp = SQL_SELECT(DATABASE_NAME, "bool_drive", "string_name = '" .. string.lower(pl:GetUserGroup()) .. "'")
			if _tmp != nil and _tmp != false then
				_tmp = _tmp[1]
				if tobool(_tmp.bool_drive) then
					return true
				else
					net.Start("yrp_info")
						net.WriteString("drive")
					net.Send(pl)
					return false
				end
			else
				printGM("db", "[drive] failed! UserGroup not found in database.")
				return false
			end
		elseif property == "collision" then
			local _tmp = SQL_SELECT(DATABASE_NAME, "bool_collision", "string_name = '" .. string.lower(pl:GetUserGroup()) .. "'")
			if _tmp != nil and _tmp != false then
				_tmp = _tmp[1]
				if tobool(_tmp.bool_collision) then
					return true
				else
					net.Start("yrp_info")
						net.WriteString("collision")
					net.Send(pl)
					return false
				end
			else
				printGM("db", "[collision] failed! UserGroup not found in database.")
				return false
			end
		elseif property == "keepupright" then
			local _tmp = SQL_SELECT(DATABASE_NAME, "bool_keepupright", "string_name = '" .. string.lower(pl:GetUserGroup()) .. "'")
			if _tmp != nil and _tmp != false then
				_tmp = _tmp[1]
				if tobool(_tmp.bool_keepupright) then
					return true
				else
					net.Start("yrp_info")
						net.WriteString("keepupright")
					net.Send(pl)
					return false
				end
			else
				printGM("db", "[keepupright] failed! UserGroup not found in database.")
				return false
			end
		elseif property == "bodygroups" then
			local _tmp = SQL_SELECT(DATABASE_NAME, "bool_bodygroups", "string_name = '" .. string.lower(pl:GetUserGroup()) .. "'")
			if _tmp != nil and _tmp != false then
				_tmp = _tmp[1]
				if tobool(_tmp.bool_bodygroups) then
					return true
				else
					net.Start("yrp_info")
						net.WriteString("bodygroups")
					net.Send(pl)
					return false
				end
			else
				printGM("db", "[bodygroups] failed! UserGroup not found in database.")
				return false
			end
		elseif property == "gravity" then
			local _tmp = SQL_SELECT(DATABASE_NAME, "bool_gravity", "string_name = '" .. string.lower(pl:GetUserGroup()) .. "'")
			if _tmp != nil and _tmp != false then
				_tmp = _tmp[1]
				if tobool(_tmp.bool_gravity) then
					return true
				else
					net.Start("yrp_info")
						net.WriteString("gravity")
					net.Send(pl)
					return false
				end
			else
				printGM("db", "[gravity] failed! UserGroup not found in database.")
				return false
			end
		elseif property == "persist" then
			if pl:HasAccess() then
				return true
			else
				net.Start("yrp_info")
					net.WriteString("persist")
				net.Send(pl)
				return false
			end
		else
			YRP.msg("note", "Missing permissions => Property: " .. property)
		end
	end
end)

function Player:UserGroupLoadout()
	--printGM("gm", self:SteamName() .. " UserGroupLoadout")
	local UG = SQL_SELECT(DATABASE_NAME, "*", "string_name = '" .. string.lower(self:GetUserGroup()) .. "'")
	if wk(UG) then
		UG = UG[1]
		self:SetDString("usergroup_sweps", UG.string_sweps)
		local SWEPS = string.Explode(",", UG.string_sweps)
		for i, swep in pairs(SWEPS) do
			self:Give(swep)
		end
		self:SetDString("usergroupColor", UG.string_color)
		self:SetDInt("int_position", UG.int_position)
		self:SetDInt("int_characters_max", UG.int_characters_max)

		for i, v in pairs(UG) do
			if string.StartWith(i, "bool_") then
				self:SetDBool(i, tobool(v))
			end
		end

		local _licenseIDs = string.Explode(",", UG.string_licenses)
		for i, lic in pairs(_licenseIDs) do
			if tonumber(lic) != nil then
				self:AddLicense(lic)
			end
		end
	end
end

util.AddNetworkString("yrp_restartserver")
net.Receive("yrp_restartserver", function(len, ply)
	if ply:HasAccess() then
		RestartServer()
	end
end)

util.AddNetworkString("UpdateUsergroupsList")
function ReloadUsergroupsList()
	SortUserGroups()
	
	local ugs = SQL_SELECT(DATABASE_NAME, "*", "string_name != 'yrp_usergroups'")
	for i, pl in pairs(HANDLER_USERGROUPS) do
		net.Start("UpdateUsergroupsList")
			net.WriteTable(ugs)
		net.Send(pl)
	end
end

util.AddNetworkString("settings_usergroup_position_up")
net.Receive("settings_usergroup_position_up", function(len, ply)
	local uid = tonumber(net.ReadString())
	local usergroup = SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '" .. uid .. "'")
	usergroup = usergroup[1]

	usergroup.int_position = tonumber(usergroup.int_position)

	local siblings = SQL_SELECT(DATABASE_NAME, "*", "string_name != 'yrp_usergroups'")

	for i, sibling in pairs(siblings) do
		sibling.int_position = tonumber(sibling.int_position)
	end

	local count = 0
	for i, sibling in SortedPairsByMemberValue(siblings, "int_position", false) do
		count = count + 1
		if tonumber(sibling.int_position) == usergroup.int_position - 1 then
			SQL_UPDATE(DATABASE_NAME, "int_position = '" .. usergroup.int_position .. "'", "uniqueID = '" .. sibling.uniqueID .. "'")
			SQL_UPDATE(DATABASE_NAME, "int_position = '" .. sibling.int_position .. "'", "uniqueID = '" .. uid .. "'")
		end
	end
	ReloadUsergroupsList()
end)

util.AddNetworkString("settings_usergroup_position_dn")
net.Receive("settings_usergroup_position_dn", function(len, ply)
	local uid = tonumber(net.ReadString())
	local group = SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '" .. uid .. "'")
	group = group[1]

	group.int_position = tonumber(group.int_position)

	local siblings = SQL_SELECT(DATABASE_NAME, "*", "string_name != 'yrp_usergroups'")

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
	ReloadUsergroupsList()
end)

util.AddNetworkString("get_perma_props")
net.Receive("get_perma_props", function(len, ply)
	local tab = SQL_SELECT("permaprops", "*", nil)

	ply.ppid = ply.ppid or 0

	if wk(tab) then
		ply.ppid = ply.ppid + 1
		local ppid = ply.ppid
		local sortedtab = {}
		local c = 0
		for i, v in pairs(tab) do
			if v.map == game.GetMap() then
				v.content = util.JSONToTable(v.content)

				sortedtab[c] = {}
				sortedtab[c].id = v.id
				sortedtab[c].model = v.content.Model
				sortedtab[c].class = v.content.Class

				c = c + 1
			end
		end

		local c = 0
		for i, v in pairs(sortedtab) do --SortedPairsByMemberValue(sortedtab, "model") do
			if ply.ppid != ppid then
				break
			end
			timer.Simple(c * 0.01, function()
				if IsValid(ply) then
					if ply.ppid != ppid then
						return
					end
					v.max = table.Count(sortedtab)
					net.Start("get_perma_props")
						net.WriteString(c)
						net.WriteTable(v)
					net.Send(ply)
				end
			end)
			c = c + 1
		end
	end
end)

util.AddNetworkString("yrp_pp_remove")
net.Receive("yrp_pp_remove", function(len, ply)
	local ppid = net.ReadString()

	SQL_DELETE_FROM("permaprops", "id = '" .. ppid .. "'")
end)

util.AddNetworkString("yrp_pp_close")
net.Receive("yrp_pp_close", function(len, ply)
	ply.ppid = ply.ppid or 0
	ply.ppid = ply.ppid + 1
end)

util.AddNetworkString("yrp_pp_teleport")
net.Receive("yrp_pp_teleport", function(len, ply)
	local ppid = net.ReadString()

	local tab = SQL_SELECT("permaprops", "*", "id = '" .. ppid .. "'")
	if wk(tab) then
		tab = tab[1]

		tab.content = util.JSONToTable(tab.content)

		ply:SetPos(tab.content.Pos)
	end
end)

util.AddNetworkString("get_usergroup_licenses")
net.Receive("get_usergroup_licenses", function(len, ply)
	local licenses = SQL_SELECT("yrp_licenses", "*", nil)

	if wk(licenses) then
		net.Start("get_usergroup_licenses")
			net.WriteTable(licenses)
		net.Send(ply)
	end
end)

util.AddNetworkString("usergroup_update_string_licenses")
net.Receive("usergroup_update_string_licenses", function(len, ply)
	local uid = tonumber(net.ReadString())
	local string_licenses = string.lower(net.ReadString())
	SQL_UPDATE(DATABASE_NAME, "string_licenses = '" .. string_licenses .. "'", "uniqueID = '" .. uid .. "'")

	printGM("db", ply:YRPName() .. " updated licenses of usergroup (" .. uid .. ") to [" .. string_licenses .. "]")
end)

hook.Add("Think", "yrp_usergroup_haschanged", function()
	for i, ply in pairs(player.GetAll()) do
		ply.yrp_ug = ply.yrp_ug or ply:GetUserGroup()
		if ply:GetUserGroup() != ply.yrp_ug then
			ply.yrp_ug = ply:GetUserGroup()
			timer.Simple(0, function()
				if IsValid(ply) then
					YRP.msg("note", ply:RPName() .. " has a new usergroup, respawning...")
					ply:Kill()
				end
			end)
		end
	end
end)
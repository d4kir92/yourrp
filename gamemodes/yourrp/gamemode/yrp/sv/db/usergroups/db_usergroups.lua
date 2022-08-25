--Copyright (C) 2017-2022 D4KiR (https://www.gnu.org/licenses/gpl.txt)

-- DO NOT TOUCH THE DATABASE FILES! If you have errors, report them here:
-- https://discord.gg/sEgNZxg

local DATABASE_NAME = "yrp_usergroups"

local sts = {
	["string_ammos"] = '',
	["string_color"] = '0,0,0,255',
	["string_displayname"] = '',
	["string_icon"] = 'http://www.famfamfam.com/lab/icons/silk/icons/shield.png',
	["string_licenses"] = '',
	["string_name"] = 'unnamed usergroup',
	["string_nonesweps"] = '',
	["string_sents"] = '',
	["string_sweps"] = '',
	["string_tools"] = '',
}

local bos = {
	["bool_ac_database"] = '0',
	["bool_adminaccess"] = '0',
	["bool_blacklist"] = '0',
	["bool_bodygroups"] = '0',
	["bool_canseeenemiesonmap"] = '0',
	["bool_canseeteammatesonmap"] = '0',
	["bool_canusecontextmenu"] = '0',
	["bool_canusespawnmenu"] = '0',
	["bool_canusewarnsystem"] = '0',
	["bool_chat"] = '1',
	["bool_collision"] = '0',
	["bool_darkrp"] = '0',
	["bool_design"] = '0',
	["bool_drive"] = '0',
	["bool_dupes"] = '0',
	["bool_effects"] = '0',
	["bool_entities"] = '0',
	["bool_events"] = '0',
	["bool_feedback"] = '0',
	["bool_flashlight"] = '0',
	["bool_general"] = '0',
	["bool_gravgunpunt"] = '0',
	["bool_gravity"] = '0',
	["bool_groupsandroles"] = '0',
	["bool_ignite"] = '0',
	["bool_keepupright"] = '0',
	["bool_levelsystem"] = '0',
	["bool_licenses"] = '0',
	["bool_logs"] = '0',
	["bool_map"] = '0',
	["bool_money"] = '0',
	["bool_npcs"] = '0',
	["bool_permaprops"] = '0',
	["bool_physgunpickup"] = '0',
	["bool_physgunpickupignoreblacklist"] = '0',
	["bool_physgunpickupotherowner"] = '0',
	["bool_physgunpickupplayer"] = '0',
	["bool_physgunpickupworld"] = '0',
	["bool_players"] = '0',
	["bool_postprocess"] = '0',
	["bool_props"] = '0',
	["bool_ragdolls"] = '0',
	["bool_realistic"] = '0',
	["bool_removeable"] = '1',
	["bool_saves"] = '0',
	["bool_scale"] = '0',
	["bool_shops"] = '0',
	["bool_specializations"] = '0',
	["bool_status"] = '0',
	["bool_usergroups"] = '0',
	["bool_vehicles"] = '0',
	["bool_weapons"] = '0',
	["bool_weaponsystem"] = '0',
	["bool_whitelist"] = '0',
	["bool_import_darkrp"] = '0',
	["bool_yourrp_addons"] = '0',
}

local ins = {
	["int_characters_max"] = '1',
	["int_charactersevent_max"] = '1',
	["int_position"] = '1',
}

for i, v in SortedPairs( sts ) do
	YRP_SQL_ADD_COLUMN(DATABASE_NAME, i, "TEXT DEFAULT '" .. v .. "'" )
end

for i, v in SortedPairs( bos ) do
	YRP_SQL_ADD_COLUMN(DATABASE_NAME, i, "INT DEFAULT " .. v .. "" )
end

for i, v in SortedPairs( ins ) do
	YRP_SQL_ADD_COLUMN(DATABASE_NAME, i, "INT DEFAULT " .. v .."" )
end

--YRP_SQL_DROP_TABLE(DATABASE_NAME)
--db_is_empty(DATABASE_NAME)

timer.Simple( 1, function()
	local yrp_usergroups = YRP_SQL_SELECT(DATABASE_NAME, "*", nil)
	if wk(yrp_usergroups) then
		for _i, _ug in pairs(yrp_usergroups) do
			_ug.string_name = _ug.string_name or "failed"
			_ug.string_name = string.lower(_ug.string_name)
			YRP_SQL_UPDATE(DATABASE_NAME, {["string_name"] = _ug.string_name}, "uniqueID = '" .. _ug.uniqueID .. "'" )
		end
	end
	yrp_usergroups = YRP_SQL_SELECT(DATABASE_NAME, "*", nil)
	if wk(yrp_usergroups) then
		for _i, _ug in pairs(yrp_usergroups) do
			local tmp = YRP_SQL_SELECT(DATABASE_NAME, "*", "string_name = '" .. _ug.string_name .. "'" )
			if wk(tmp) and #tmp > 1 then
				for i, ug in pairs(tmp) do
					if i > 1 then
						YRP_SQL_DELETE_FROM(DATABASE_NAME, "uniqueID = '" .. ug.uniqueID .. "'" )
					end
				end
			end
		end
	end

	if YRP_SQL_SELECT(DATABASE_NAME, "*", "string_name = 'superadmin'" ) == nil then
		local cols = {}
		local vals = {}

		table.insert( cols, "string_name" )
		table.insert( vals, "'superadmin'" )

		table.insert( cols, "string_tools" )
		table.insert( vals, "'all'" )

		table.insert( cols, "int_position" )
		table.insert( vals, 2 )

		for i, v in pairs( bos ) do
			if i == "bool_removeable" then
				table.insert( cols, i )
				table.insert( vals, 0 )
			else
				table.insert( cols, i )
				table.insert( vals, 1 )
			end
		end

		YRP_SQL_INSERT_INTO(DATABASE_NAME, table.concat( cols, "," ), table.concat( vals, "," ) )
	else
		local tab = YRP_SQL_SELECT(DATABASE_NAME, "*", "string_name = 'superadmin'" )
		if tab and tab[1] then
			tab = tab[1]

			local vals = {}

			vals["string_name"] = "superadmin"

			vals["string_tools"] = "all"

			vals["int_position"] = 2

			for i, v in pairs( bos ) do
				if i == "bool_removeable" then
					vals[i] = 0
				else
					vals[i] = 1
				end
			end

			YRP_SQL_UPDATE( DATABASE_NAME, vals, "uniqueID = '" .. tab.uniqueID .. "'" )
		else
			YRP.msg( "error", "superadmin is missing" )
		end
	end

	if YRP_SQL_SELECT(DATABASE_NAME, "*", "string_name = 'admin'" ) == nil then
		local _str = "string_name"

		local _str2 = "'admin'"

		YRP_SQL_INSERT_INTO(DATABASE_NAME, _str , _str2)
	end

	if YRP_SQL_SELECT(DATABASE_NAME, "*", "string_name = 'user'" ) == nil then
		local _str = "string_name"

		local _str2 = "'user'"

		YRP_SQL_INSERT_INTO(DATABASE_NAME, _str , _str2)
	end
end )

function SortUserGroups()
	local siblings = YRP_SQL_SELECT(DATABASE_NAME, "*", nil)
	if wk(siblings) then
		for i, sibling in pairs(siblings) do
			if sibling.string_name == "yrp_usergroups" then
				table.remove( siblings, i )
			elseif sibling.string_name == "superadmin" then
				table.remove( siblings, i )
			end
		end

		for i, sibling in pairs(siblings) do
			sibling.int_position = tonumber(sibling.int_position)
		end

		local count = 2
		for i, sibling in SortedPairsByMemberValue(siblings, "int_position", false) do
			count = count + 1
			YRP_SQL_UPDATE(DATABASE_NAME, {["int_position"] = count}, "uniqueID = '" .. sibling.uniqueID .. "'" )
		end
	end
end
timer.Simple( 1, SortUserGroups )

timer.Simple( 3, function()
	YRP_SQL_DELETE_FROM(DATABASE_NAME, "string_name = 'yrp_usergroups'" )
	local unremoveable = YRP_SQL_SELECT(DATABASE_NAME, "*", "string_name = 'yrp_usergroups'" )
	if unremoveable == nil then
		local cols = {}
		local vals = {}

		table.insert( cols, "string_name" )
		table.insert( vals, "'yrp_usergroups'" )

		table.insert( cols, "string_tools" )
		table.insert( vals, "'all'" )

		table.insert( cols, "int_position" )
		table.insert( vals, 1 )

		for i, v in pairs( bos ) do
			if i == "bool_removeable" then
				table.insert( cols, i )
				table.insert( vals, 0 )
			else
				table.insert( cols, i )
				table.insert( vals, 1 )
			end
		end

		YRP_SQL_INSERT_INTO(DATABASE_NAME, table.concat( cols, "," ), table.concat( vals, "," ) )

		SortUserGroups()
	end
end )

--[[ Global Handler ]]--
local HANDLER_USERGROUPS = {}

function RemFromHandler_UserGroups(ply)
	table.RemoveByValue(HANDLER_USERGROUPS, ply)
end

function AddToHandler_UserGroups(ply)
	if !table.HasValue(HANDLER_USERGROUPS, ply) then
		table.insert(HANDLER_USERGROUPS, ply)
	end
end

util.AddNetworkString( "Disconnect_Settings_UserGroups" )
net.Receive( "Disconnect_Settings_UserGroups", function(len, ply)
	RemFromHandler_UserGroups(ply)
end)

local function ConvertToMains(tab)
	local res = {}

	for i, v in pairs(tab) do
		if !strEmpty( v) and !string.StartWith( v, "\t" ) and !string.find( v, "{" ) and !string.find( v, "}" ) then
			local ug = string.Replace( v, "\"", "" )
			ug = string.Replace(ug, "\t", "" )
			table.insert(res, string.lower(ug) )
		end
	end

	return res
end

function GetULXUserGroups()
	-- DAM
	if DAMVERSION then
		local tab = YRP_SQL_SELECT( "DAM_UGS", "*", nil )

		if tab then
			for i, v in pairs( tab ) do
				local ug = YRP_SQL_SELECT( "yrp_usergroups", "*", "string_name = '" .. string.lower( v.name ) .. "'" )
				if ug == nil then
					YRP_SQL_INSERT_INTO( "yrp_usergroups", "string_name", "'" .. string.lower( v.name ) .. "'" )
					SortUserGroups()
				end
			end
		end
	end




	-- ULX
	local f = file.Read( "ulib/groups.txt", "DATA" )

	if !wk(f) then return end

	f = string.Explode( "\n", f)
	f = ConvertToMains(f)
	for i, v in pairs(f) do
		local dbug = YRP_SQL_SELECT( "yrp_usergroups", "*", "string_name = '" .. v .. "'" )
		if dbug == nil then
			YRP_SQL_INSERT_INTO( "yrp_usergroups", "string_name", "'" .. v .. "'" )
			SortUserGroups()
		end
	end
end
timer.Simple( 1, GetULXUserGroups )

util.AddNetworkString( "Connect_Settings_UserGroups" )
net.Receive( "Connect_Settings_UserGroups", function(len, ply)
	GetULXUserGroups()

	if ply:CanAccess( "bool_usergroups" ) then
		AddToHandler_UserGroups(ply)
		local _usergroups = {}
		for k, v in pairs(player.GetAll() ) do
			local _ug = string.lower( v:GetUserGroup() )
			if YRP_SQL_SELECT(DATABASE_NAME, "*", "string_name = '" .. _ug .. "'" ) == nil then
				YRP.msg( "note", "usergroup: " .. _ug .. " not found, adding to db" )
				YRP_SQL_INSERT_INTO(DATABASE_NAME, "string_name", "'" .. _ug .. "'" )
			end
		end

		local _tmp = YRP_SQL_SELECT(DATABASE_NAME, "uniqueID, string_name, string_color, string_icon, bool_removeable, int_position", nil)
		local _ugs = {}
		for i, ug in pairs(_tmp) do
			_ugs[tonumber(ug.uniqueID)] = ug
		end

		if _tmp and _tmp[1] then
			for i, v in pairs( _tmp ) do
				net.Start( "Connect_Settings_UserGroups" )
					net.WriteBool(i == 1)					
					net.WriteUInt( v.uniqueID, 16 )
					net.WriteString( v.string_name )
					net.WriteString( v.string_color )
					net.WriteString( v.string_icon )
					net.WriteBool( tobool( v.bool_removeable ) )
					net.WriteUInt( v.int_position, 8 )
					net.WriteBool( i == #_tmp )
				net.Send( ply )
			end
		end
	end
end)

--[[ Usergroup Handler ]]--
local HANDLER_USERGROUP = {}

function RemFromHandler_UserGroup(ply, uid)
	HANDLER_USERGROUP[uid] = HANDLER_USERGROUP[uid] or {}
	if table.HasValue(HANDLER_USERGROUP[uid], ply) then
		table.RemoveByValue(HANDLER_USERGROUP[uid], ply)
	end
end

function AddToHandler_UserGroup(ply, uid)
	HANDLER_USERGROUP[uid] = HANDLER_USERGROUP[uid] or {}
	if !table.HasValue(HANDLER_USERGROUP[uid], ply) then
		table.insert(HANDLER_USERGROUP[uid], ply)
	end
end

util.AddNetworkString( "Disconnect_Settings_UserGroup" )
net.Receive( "Disconnect_Settings_UserGroup", function(len, ply)
	local uid = tonumber(net.ReadString() )
	RemFromHandler_UserGroup(ply, uid)
end)

util.AddNetworkString( "Connect_Settings_UserGroup" )
net.Receive( "Connect_Settings_UserGroup", function(len, ply)
	local uid = tonumber(net.ReadString() )
	AddToHandler_UserGroup(ply, uid)

	local _tmp = YRP_SQL_SELECT(DATABASE_NAME, "*", "uniqueID = " .. uid)
	if wk(_tmp) then
		_tmp = _tmp[1]
	end

	net.Start( "Connect_Settings_UserGroup" )
		if _tmp != nil then
			net.WriteTable(_tmp)
		else
			net.WriteTable({})
		end
	net.Send(ply)
end)

util.AddNetworkString( "usergroup_add" )
net.Receive( "usergroup_add", function(len, ply)
	YRP_SQL_INSERT_INTO_DEFAULTVALUES(DATABASE_NAME)
	YRP.msg( "gm", ply:YRPName() .. " added a new UserGroup" )

	ReloadUsergroupsList()
end)

util.AddNetworkString( "usergroup_rem" )
net.Receive( "usergroup_rem", function(len, ply)
	local uid = tonumber(net.ReadString() )
	YRP_SQL_DELETE_FROM(DATABASE_NAME, "uniqueID = '" .. uid .. "'" )
	YRP.msg( "gm", ply:YRPName() .. " removed UserGroup ( " .. uid .. " )" )

	ReloadUsergroupsList()
end)

--[[ Access Functions ]]--

local Player = FindMetaTable( "Player" )

function Player:NoAccess(site, usergroups)
	usergroups = usergroups or "yrp_usergroups"
	net.Start( "setting_hasnoaccess" )
		net.WriteString(site)
		net.WriteString(usergroups or "yrp_usergroups" )
	net.Send(self)
end

util.AddNetworkString( "setting_hasnoaccess" )
function Player:CanAccess(site)
	local lsite = string.Replace(site, "bool_", "" )
	local usergroups = ""

	local _ug = self:GetUserGroup() or "failed"
	_ug = string.lower(_ug)
	local _b = YRP_SQL_SELECT(DATABASE_NAME, site, "string_name = '" .. _ug .. "'" )
	if wk(_b) then
		_b = tobool(_b[1][site])
		if !_b then
			local _ugs = YRP_SQL_SELECT(DATABASE_NAME, "string_name", "bool_usergroups = '1'" )
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
			YRP.msg( "note", self:YRPName() .. " can NOT access " .. lsite .. "" )
		elseif _b then
			--YRP.msg( "db", self:YRPName() .. " can access " .. lsite .. "" )
		end
		return tobool(_b)
	end
	YRP.msg( "note", self:YRPName() .. " can NOT access " .. lsite .. "" )
	self:NoAccess(lsite)
	return false
end

--[[ Usergroup Edit ]]--
util.AddNetworkString( "usergroup_update_string_name" )
net.Receive( "usergroup_update_string_name", function(len, ply)
	local uid = tonumber(net.ReadString() )
	local string_name = string.lower(net.ReadString() )
	YRP_SQL_UPDATE(DATABASE_NAME, {["string_name"] = string_name}, "uniqueID = '" .. uid .. "'" )

	YRP.msg( "db", ply:YRPName() .. " updated name of usergroup ( " .. uid .. " ) to [" .. string_name .. "]" )

	for i, pl in pairs(HANDLER_USERGROUP[uid]) do
		if pl != ply then
			net.Start( "usergroup_update_string_name" )
				net.WriteString(string_name)
			net.Send(pl)
		end
	end
end)

util.AddNetworkString( "usergroup_update_string_displayname" )
net.Receive( "usergroup_update_string_displayname", function(len, ply)
	local uid = tonumber(net.ReadString() )
	local string_displayname = net.ReadString()
	YRP_SQL_UPDATE(DATABASE_NAME, {["string_displayname"] = string_displayname}, "uniqueID = '" .. uid .. "'" )

	YRP.msg( "db", ply:YRPName() .. " updated display of usergroup ( " .. uid .. " ) to [" .. string_displayname .. "]" )

	for i, pl in pairs(HANDLER_USERGROUP[uid]) do
		if pl != ply then
			net.Start( "usergroup_update_string_displayname" )
				net.WriteString(string_displayname)
			net.Send(pl)
		end
	end
end)

util.AddNetworkString( "usergroup_update_string_color" )
net.Receive( "usergroup_update_string_color", function(len, ply)
	local uid = tonumber(net.ReadString() )
	local string_color = net.ReadString()
	YRP_SQL_UPDATE(DATABASE_NAME, {["string_color"] = string_color}, "uniqueID = '" .. uid .. "'" )

	YRP.msg( "db", ply:YRPName() .. " updated color of usergroup ( " .. uid .. " ) to [" .. string_color .. "]" )

	for i, pl in pairs(HANDLER_USERGROUP[uid]) do
		if pl != ply then
			net.Start( "usergroup_update_string_color" )
				net.WriteString(string_color)
			net.Send(pl)
		end
	end
end)

util.AddNetworkString( "usergroup_update_icon" )
net.Receive( "usergroup_update_icon", function(len, ply)
	local uid = tonumber(net.ReadString() )
	local string_icon = net.ReadString()
	YRP_SQL_UPDATE(DATABASE_NAME, {["string_icon"] = string_icon}, "uniqueID = '" .. uid .. "'" )

	YRP.msg( "db", ply:YRPName() .. " updated string_icon of usergroup ( " .. uid .. " ) to [" .. string_icon .. "]" )

	for i, pl in pairs(HANDLER_USERGROUP[uid]) do
		if pl != ply then
			net.Start( "usergroup_update_icon" )
				net.WriteString(string_icon)
			net.Send(pl)
		end
	end
end)

util.AddNetworkString( "usergroup_update_string_sweps" )
net.Receive( "usergroup_update_string_sweps", function(len, ply)
	local uid = tonumber(net.ReadString() )
	local sweps = net.ReadTable()
	local string_sweps = table.concat( sweps, "," )
	YRP_SQL_UPDATE(DATABASE_NAME, {["string_sweps"] = string_sweps}, "uniqueID = '" .. uid .. "'" )

	YRP.msg( "db", ply:YRPName() .. " updated string_sweps of usergroup ( " .. uid .. " ) to [" .. string_sweps .. "]" )

	for i, pl in pairs(HANDLER_USERGROUP[uid]) do
		net.Start( "usergroup_update_string_sweps" )
			net.WriteString(string_sweps)
		net.Send(pl)
	end
end)

util.AddNetworkString( "usergroup_update_string_nonesweps" )
net.Receive( "usergroup_update_string_nonesweps", function(len, ply)
	local uid = tonumber(net.ReadString() )
	local sweps = net.ReadTable()

	local string_nonesweps = table.concat( sweps, "," )
	YRP_SQL_UPDATE(DATABASE_NAME, {["string_nonesweps"] = string_nonesweps}, "uniqueID = '" .. uid .. "'" )

	YRP.msg( "db", ply:YRPName() .. " updated string_nonesweps of usergroup ( " .. uid .. " ) to [" .. string_nonesweps .. "]" )

	for i, pl in pairs(HANDLER_USERGROUP[uid]) do
		net.Start( "usergroup_update_string_nonesweps" )
			net.WriteString(string_nonesweps)
		net.Send(pl)
	end
end)

util.AddNetworkString( "usergroup_update_string_ammos" )
net.Receive( "usergroup_update_string_ammos", function(len, ply)
	local uid = tonumber(net.ReadString() )
	local string_ammos = net.ReadString()
	YRP_SQL_UPDATE(DATABASE_NAME, {["string_ammos"] = string_ammos}, "uniqueID = '" .. uid .. "'" )

	YRP.msg( "db", ply:YRPName() .. " updated string_ammos of usergroup ( " .. uid .. " ) to [" .. string_ammos .. "]" )

	for i, pl in pairs(HANDLER_USERGROUP[uid]) do
		net.Start( "usergroup_update_string_ammos" )
			net.WriteString(string_ammos)
		net.Send(pl)
	end
end)

function UGUpdateInt(ply, uid, name, value)
	name = name or "UNNAMED"
	name = string.lower(name)
	YRP_SQL_UPDATE(DATABASE_NAME, {[name] = value}, "uniqueID = '" .. uid .. "'" )

	YRP.msg( "db", ply:YRPName() .. " updated " .. name .. " of usergroup ( " .. uid .. " ) to [" .. value .. "]" )

	for i, pl in pairs(HANDLER_USERGROUP[uid]) do
		net.Start( "usergroup_update_" .. name)
			net.WriteString( value)
		net.Send(pl)
	end

	local ug = YRP_SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '" .. uid .. "'" )
	if wk(ug) then
		ug = ug[1]
		ug.string_name = string.lower(ug.string_name)
		for i, pl in pairs(player.GetAll() ) do
			if string.lower(pl:GetUserGroup() ) == ug.string_name then
				pl:SetYRPInt(name, value)
			end
		end
	end
end

function UGCheckBox(ply, uid, name, value)
	name = name or "UNNAMED"
	name = string.lower(name)
	YRP_SQL_UPDATE(DATABASE_NAME, {[name] = value}, "uniqueID = '" .. uid .. "'" )

	YRP.msg( "db", ply:YRPName() .. " updated " .. name .. " of usergroup ( " .. uid .. " ) to [" .. value .. "]" )

	if wk(HANDLER_USERGROUP[uid]) then
		for i, pl in pairs(HANDLER_USERGROUP[uid]) do
			net.Start( "usergroup_update_" .. name)
				net.WriteString( value)
			net.Send(pl)
		end
	end

	local ug = YRP_SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '" .. uid .. "'" )
	if wk(ug) then
		ug = ug[1]
		ug.string_name = string.lower(ug.string_name)
		for i, pl in pairs(player.GetAll() ) do
			if string.lower(pl:GetUserGroup() ) == ug.string_name then
				pl:SetYRPBool(name, tobool( value) )
			end
		end
	end
end

util.AddNetworkString( "usergroup_update_bool_ac_database" )
net.Receive( "usergroup_update_bool_ac_database", function(len, ply)
	local uid = tonumber(net.ReadString() )
	local bool_ac_database = net.ReadString()
	UGCheckBox(ply, uid, "bool_ac_database", bool_ac_database)
end)

util.AddNetworkString( "usergroup_update_bool_chat" )
net.Receive( "usergroup_update_bool_chat", function(len, ply)
	local uid = tonumber(net.ReadString() )
	local bool_chat = net.ReadString()
	UGCheckBox(ply, uid, "bool_chat", bool_chat)
end)

util.AddNetworkString( "usergroup_update_bool_darkrp" )
net.Receive( "usergroup_update_bool_darkrp", function(len, ply)
	local uid = tonumber(net.ReadString() )
	local bool_darkrp = net.ReadString()
	UGCheckBox(ply, uid, "bool_darkrp", bool_darkrp)
end)

util.AddNetworkString( "usergroup_update_bool_permaprops" )
net.Receive( "usergroup_update_bool_permaprops", function(len, ply)
	local uid = tonumber(net.ReadString() )
	local bool_permaprops = net.ReadString()
	UGCheckBox(ply, uid, "bool_permaprops", bool_permaprops)
end)

util.AddNetworkString( "usergroup_update_bool_status" )
net.Receive( "usergroup_update_bool_status", function(len, ply)
	local uid = tonumber(net.ReadString() )
	local bool_status = net.ReadString()
	UGCheckBox(ply, uid, "bool_status", bool_status)
end)

util.AddNetworkString( "usergroup_update_bool_import_darkrp" )
net.Receive( "usergroup_update_bool_import_darkrp", function(len, ply)
	local uid = tonumber(net.ReadString() )
	local bool_import_darkrp = net.ReadString()
	UGCheckBox(ply, uid, "bool_import_darkrp", bool_import_darkrp)
end)

util.AddNetworkString( "usergroup_update_bool_yourrp_addons" )
net.Receive( "usergroup_update_bool_yourrp_addons", function(len, ply)
	local uid = tonumber(net.ReadString() )
	local bool_yourrp_addons = net.ReadString()
	UGCheckBox(ply, uid, "bool_yourrp_addons", bool_yourrp_addons)
end)

util.AddNetworkString( "usergroup_update_bool_adminaccess" )
net.Receive( "usergroup_update_bool_adminaccess", function(len, ply)
	local uid = tonumber(net.ReadString() )
	local bool_adminaccess = net.ReadString()
	UGCheckBox(ply, uid, "bool_adminaccess", bool_adminaccess)
end)

util.AddNetworkString( "usergroup_update_bool_general" )
net.Receive( "usergroup_update_bool_general", function(len, ply)
	local uid = tonumber(net.ReadString() )
	local bool_general = net.ReadString()
	UGCheckBox(ply, uid, "bool_general", bool_general)
end)

util.AddNetworkString( "usergroup_update_bool_levelsystem" )
net.Receive( "usergroup_update_bool_levelsystem", function(len, ply)
	local uid = tonumber(net.ReadString() )
	local bool_levelsystem = net.ReadString()
	UGCheckBox(ply, uid, "bool_levelsystem", bool_levelsystem)
end)

util.AddNetworkString( "usergroup_update_bool_design" )
net.Receive( "usergroup_update_bool_design", function(len, ply)
	local uid = tonumber(net.ReadString() )
	local bool_design = net.ReadString()
	UGCheckBox(ply, uid, "bool_design", bool_design)
end)

util.AddNetworkString( "usergroup_update_bool_realistic" )
net.Receive( "usergroup_update_bool_realistic", function(len, ply)
	local uid = tonumber(net.ReadString() )
	local bool_realistic = net.ReadString()
	UGCheckBox(ply, uid, "bool_realistic", bool_realistic)
end)

util.AddNetworkString( "usergroup_update_bool_money" )
net.Receive( "usergroup_update_bool_money", function(len, ply)
	local uid = tonumber(net.ReadString() )
	local bool_money = net.ReadString()
	UGCheckBox(ply, uid, "bool_money", bool_money)
end)

util.AddNetworkString( "usergroup_update_bool_licenses" )
net.Receive( "usergroup_update_bool_licenses", function(len, ply)
	local uid = tonumber(net.ReadString() )
	local bool_licenses = net.ReadString()
	UGCheckBox(ply, uid, "bool_licenses", bool_licenses)
end)

util.AddNetworkString( "usergroup_update_bool_specializations" )
net.Receive( "usergroup_update_bool_specializations", function(len, ply)
	local uid = tonumber(net.ReadString() )
	local bool_specializations = net.ReadString()
	UGCheckBox(ply, uid, "bool_specializations", bool_specializations)
end)

util.AddNetworkString( "usergroup_update_bool_weaponsystem" )
net.Receive( "usergroup_update_bool_weaponsystem", function(len, ply)
	local uid = tonumber(net.ReadString() )
	local bool_weaponsystem = net.ReadString()
	UGCheckBox(ply, uid, "bool_weaponsystem", bool_weaponsystem)
end)

util.AddNetworkString( "usergroup_update_bool_shops" )
net.Receive( "usergroup_update_bool_shops", function(len, ply)
	local uid = tonumber(net.ReadString() )
	local bool_shops = net.ReadString()
	UGCheckBox(ply, uid, "bool_shops", bool_shops)
end)

util.AddNetworkString( "usergroup_update_bool_map" )
net.Receive( "usergroup_update_bool_map", function(len, ply)
	local uid = tonumber(net.ReadString() )
	local bool_map = net.ReadString()
	UGCheckBox(ply, uid, "bool_map", bool_map)
end)

util.AddNetworkString( "usergroup_update_bool_feedback" )
net.Receive( "usergroup_update_bool_feedback", function(len, ply)
	local uid = tonumber(net.ReadString() )
	local bool_feedback = net.ReadString()
	UGCheckBox(ply, uid, "bool_feedback", bool_feedback)
end)

util.AddNetworkString( "usergroup_update_bool_usergroups" )
net.Receive( "usergroup_update_bool_usergroups", function(len, ply)
	local uid = tonumber(net.ReadString() )
	local bool_usergroups = net.ReadString()
	UGCheckBox(ply, uid, "bool_usergroups", bool_usergroups)
end)

util.AddNetworkString( "usergroup_update_bool_logs" )
net.Receive( "usergroup_update_bool_logs", function(len, ply)
	local uid = tonumber(net.ReadString() )
	local bool_logs = net.ReadString()
	UGCheckBox(ply, uid, "bool_logs", bool_logs)
end)

util.AddNetworkString( "usergroup_update_bool_blacklist" )
net.Receive( "usergroup_update_bool_blacklist", function(len, ply)
	local uid = tonumber(net.ReadString() )
	local bool_blacklist = net.ReadString()
	UGCheckBox(ply, uid, "bool_blacklist", bool_blacklist)
end)

util.AddNetworkString( "usergroup_update_bool_scale" )
net.Receive( "usergroup_update_bool_scale", function(len, ply)
	local uid = tonumber(net.ReadString() )
	local bool_scale = net.ReadString()
	UGCheckBox(ply, uid, "bool_scale", bool_scale)
end)

util.AddNetworkString( "usergroup_update_bool_groupsandroles" )
net.Receive( "usergroup_update_bool_groupsandroles", function(len, ply)
	local uid = tonumber(net.ReadString() )
	local bool_groupsandroles = net.ReadString()
	UGCheckBox(ply, uid, "bool_groupsandroles", bool_groupsandroles)
end)

util.AddNetworkString( "usergroup_update_bool_players" )
net.Receive( "usergroup_update_bool_players", function(len, ply)
	local uid = tonumber(net.ReadString() )
	local bool_players = net.ReadString()
	UGCheckBox(ply, uid, "bool_players", bool_players)
end)

util.AddNetworkString( "usergroup_update_bool_events" )
net.Receive( "usergroup_update_bool_events", function(len, ply)
	local uid = tonumber(net.ReadString() )
	local bool_events = net.ReadString()
	UGCheckBox(ply, uid, "bool_events", bool_events)
end)

util.AddNetworkString( "usergroup_update_bool_whitelist" )
net.Receive( "usergroup_update_bool_whitelist", function(len, ply)
	local uid = tonumber(net.ReadString() )
	local bool_whitelist = net.ReadString()
	UGCheckBox(ply, uid, "bool_whitelist", bool_whitelist)
end)

util.AddNetworkString( "usergroup_update_bool_vehicles" )
net.Receive( "usergroup_update_bool_vehicles", function(len, ply)
	local uid = tonumber(net.ReadString() )
	local bool_vehicles = net.ReadString()
	UGCheckBox(ply, uid, "bool_vehicles", bool_vehicles)
end)

util.AddNetworkString( "usergroup_update_bool_weapons" )
net.Receive( "usergroup_update_bool_weapons", function(len, ply)
	local uid = tonumber(net.ReadString() )
	local bool_weapons = net.ReadString()
	UGCheckBox(ply, uid, "bool_weapons", bool_weapons)
end)

util.AddNetworkString( "usergroup_update_bool_entities" )
net.Receive( "usergroup_update_bool_entities", function(len, ply)
	local uid = tonumber(net.ReadString() )
	local bool_entities = net.ReadString()
	UGCheckBox(ply, uid, "bool_entities", bool_entities)
end)

util.AddNetworkString( "usergroup_update_bool_effects" )
net.Receive( "usergroup_update_bool_effects", function(len, ply)
	local uid = tonumber(net.ReadString() )
	local bool_effects = net.ReadString()
	UGCheckBox(ply, uid, "bool_effects", bool_effects)
end)

util.AddNetworkString( "usergroup_update_bool_npcs" )
net.Receive( "usergroup_update_bool_npcs", function(len, ply)
	local uid = tonumber(net.ReadString() )
	local bool_npcs = net.ReadString()
	UGCheckBox(ply, uid, "bool_npcs", bool_npcs)
end)

util.AddNetworkString( "usergroup_update_bool_props" )
net.Receive( "usergroup_update_bool_props", function(len, ply)
	local uid = tonumber(net.ReadString() )
	local bool_props = net.ReadString()
	UGCheckBox(ply, uid, "bool_props", bool_props)
end)

util.AddNetworkString( "usergroup_update_bool_ragdolls" )
net.Receive( "usergroup_update_bool_ragdolls", function(len, ply)
	local uid = tonumber(net.ReadString() )
	local bool_ragdolls = net.ReadString()
	UGCheckBox(ply, uid, "bool_ragdolls", bool_ragdolls)
end)

util.AddNetworkString( "usergroup_update_bool_postprocess" )
net.Receive( "usergroup_update_bool_postprocess", function(len, ply)
	local uid = tonumber(net.ReadString() )
	local bool_postprocess = net.ReadString()
	UGCheckBox(ply, uid, "bool_postprocess", bool_postprocess)
end)

util.AddNetworkString( "usergroup_update_bool_dupes" )
net.Receive( "usergroup_update_bool_dupes", function(len, ply)
	local uid = tonumber(net.ReadString() )
	local bool_dupes = net.ReadString()
	UGCheckBox(ply, uid, "bool_dupes", bool_dupes)
end)

util.AddNetworkString( "usergroup_update_bool_saves" )
net.Receive( "usergroup_update_bool_saves", function(len, ply)
	local uid = tonumber(net.ReadString() )
	local bool_saves = net.ReadString()
	UGCheckBox(ply, uid, "bool_saves", bool_saves)
end)

util.AddNetworkString( "usergroup_update_bool_ignite" )
net.Receive( "usergroup_update_bool_ignite", function(len, ply)
	local uid = tonumber(net.ReadString() )
	local bool_ignite = net.ReadString()
	UGCheckBox(ply, uid, "bool_ignite", bool_ignite)
end)

util.AddNetworkString( "usergroup_update_bool_drive" )
net.Receive( "usergroup_update_bool_drive", function(len, ply)
	local uid = tonumber(net.ReadString() )
	local bool_drive = net.ReadString()
	UGCheckBox(ply, uid, "bool_drive", bool_drive)
end)

util.AddNetworkString( "usergroup_update_bool_flashlight" )
net.Receive( "usergroup_update_bool_flashlight", function(len, ply)
	local uid = tonumber(net.ReadString() )
	local bool_flashlight = net.ReadString()
	UGCheckBox(ply, uid, "bool_flashlight", bool_flashlight)
end)

util.AddNetworkString( "usergroup_update_bool_collision" )
net.Receive( "usergroup_update_bool_collision", function(len, ply)
	local uid = tonumber(net.ReadString() )
	local bool_collision = net.ReadString()
	UGCheckBox(ply, uid, "bool_collision", bool_collision)
end)

util.AddNetworkString( "usergroup_update_bool_gravity" )
net.Receive( "usergroup_update_bool_gravity", function(len, ply)
	local uid = tonumber(net.ReadString() )
	local bool_gravity = net.ReadString()
	UGCheckBox(ply, uid, "bool_gravity", bool_gravity)
end)

util.AddNetworkString( "usergroup_update_bool_keepupright" )
net.Receive( "usergroup_update_bool_keepupright", function(len, ply)
	local uid = tonumber(net.ReadString() )
	local bool_keepupright = net.ReadString()
	UGCheckBox(ply, uid, "bool_keepupright", bool_keepupright)
end)

util.AddNetworkString( "usergroup_update_bool_bodygroups" )
net.Receive( "usergroup_update_bool_bodygroups", function(len, ply)
	local uid = tonumber(net.ReadString() )
	local bool_bodygroups = net.ReadString()
	UGCheckBox(ply, uid, "bool_bodygroups", bool_bodygroups)
end)

util.AddNetworkString( "usergroup_update_bool_physgunpickup" )
net.Receive( "usergroup_update_bool_physgunpickup", function(len, ply)
	local uid = tonumber(net.ReadString() )
	local bool_physgunpickup = net.ReadString()
	UGCheckBox(ply, uid, "bool_physgunpickup", bool_physgunpickup)
end)

util.AddNetworkString( "usergroup_update_bool_physgunpickupplayer" )
net.Receive( "usergroup_update_bool_physgunpickupplayer", function(len, ply)
	local uid = tonumber(net.ReadString() )
	local bool_physgunpickupplayer = net.ReadString()
	UGCheckBox(ply, uid, "bool_physgunpickupplayer", bool_physgunpickupplayer)
end)

util.AddNetworkString( "usergroup_update_bool_physgunpickupworld" )
net.Receive( "usergroup_update_bool_physgunpickupworld", function(len, ply)
	local uid = tonumber(net.ReadString() )
	local bool_physgunpickupworld = net.ReadString()
	UGCheckBox(ply, uid, "bool_physgunpickupworld", bool_physgunpickupworld)
end)

util.AddNetworkString( "usergroup_update_bool_physgunpickupotherowner" )
net.Receive( "usergroup_update_bool_physgunpickupotherowner", function(len, ply)
	local uid = tonumber(net.ReadString() )
	local bool_physgunpickupotherowner = net.ReadString()
	UGCheckBox(ply, uid, "bool_physgunpickupotherowner", bool_physgunpickupotherowner)
end)

util.AddNetworkString( "usergroup_update_bool_physgunpickupignoreblacklist" )
net.Receive( "usergroup_update_bool_physgunpickupignoreblacklist", function(len, ply)
	local uid = tonumber(net.ReadString() )
	local bool_physgunpickupignoreblacklist = net.ReadString()
	UGCheckBox(ply, uid, "bool_physgunpickupignoreblacklist", bool_physgunpickupignoreblacklist)
end)

util.AddNetworkString( "usergroup_update_bool_gravgunpunt" )
net.Receive( "usergroup_update_bool_gravgunpunt", function(len, ply)
	local uid = tonumber(net.ReadString() )
	local bool_gravgunpunt = net.ReadString()
	UGCheckBox(ply, uid, "bool_gravgunpunt", bool_gravgunpunt)
end)



util.AddNetworkString( "usergroup_update_bool_canseeteammatesonmap" )
net.Receive( "usergroup_update_bool_canseeteammatesonmap", function(len, ply)
	local uid = tonumber(net.ReadString() )
	local bool_canseeteammatesonmap = net.ReadString()
	UGCheckBox(ply, uid, "bool_canseeteammatesonmap", bool_canseeteammatesonmap)
end)

util.AddNetworkString( "usergroup_update_bool_canseeenemiesonmap" )
net.Receive( "usergroup_update_bool_canseeenemiesonmap", function(len, ply)
	local uid = tonumber(net.ReadString() )
	local bool_canseeenemiesonmap = net.ReadString()
	UGCheckBox(ply, uid, "bool_canseeenemiesonmap", bool_canseeenemiesonmap)
end)

util.AddNetworkString( "usergroup_update_bool_canusewarnsystem" )
net.Receive( "usergroup_update_bool_canusewarnsystem", function(len, ply)
	local uid = tonumber(net.ReadString() )
	local bool_canusewarnsystem = net.ReadString()
	UGCheckBox(ply, uid, "bool_canusewarnsystem", bool_canusewarnsystem)
end)

util.AddNetworkString( "usergroup_update_bool_canusecontextmenu" )
net.Receive( "usergroup_update_bool_canusecontextmenu", function(len, ply)
	local uid = tonumber(net.ReadString() )
	local bool_canusecontextmenu = net.ReadString()
	UGCheckBox(ply, uid, "bool_canusecontextmenu", bool_canusecontextmenu)
end)

util.AddNetworkString( "usergroup_update_bool_canusespawnmenu" )
net.Receive( "usergroup_update_bool_canusespawnmenu", function(len, ply)
	local uid = tonumber(net.ReadString() )
	local bool_canusespawnmenu = net.ReadString()
	UGCheckBox(ply, uid, "bool_canusespawnmenu", bool_canusespawnmenu)
end)



util.AddNetworkString( "usergroup_update_int_characters_max" )
net.Receive( "usergroup_update_int_characters_max", function(len, ply)
	local uid = tonumber(net.ReadString() )
	local int_characters_max = net.ReadString()
	UGUpdateInt(ply, uid, "int_characters_max", int_characters_max)
end)

util.AddNetworkString( "usergroup_update_int_charactersevent_max" )
net.Receive( "usergroup_update_int_charactersevent_max", function(len, ply)
	local uid = tonumber(net.ReadString() )
	local int_charactersevent_max = net.ReadString()
	UGUpdateInt(ply, uid, "int_charactersevent_max", int_charactersevent_max)
end)

local antinoti1spam = {}
util.AddNetworkString( "yrp_info" )
function YRPNotiToPlyDisallowed(ply, msg)
	if not table.HasValue( antinoti1spam, ply) then
		table.insert( antinoti1spam, ply)

		net.Start( "yrp_info" )
			net.WriteString(msg)
		net.Send(ply)

		timer.Simple(5, function()
			table.RemoveByValue( antinoti1spam, ply)
		end)
	end
end

local antinoti2spam = {}
util.AddNetworkString( "yrp_info2" )
function YRPNotiToPly(msg, ply)
	if not table.HasValue( antinoti2spam, ply) then
		table.insert( antinoti2spam, ply)

		net.Start( "yrp_info2" )
			net.WriteString(msg)
		if ply then
			net.Send(ply)
		else
			net.Broadcast()
		end

		timer.Simple(5, function()
			table.RemoveByValue( antinoti2spam, ply)
		end)
	end
end

-- Functions
hook.Add( "PlayerSpawnVehicle", "yrp_vehicles_restriction", function(pl, model, name, tab)
	if ea(pl) then
		local _tmp = YRP_SQL_SELECT(DATABASE_NAME, "bool_vehicles", "string_name = '" .. string.lower(pl:GetUserGroup() ) .. "'" )
		if worked(_tmp, "PlayerSpawnVehicle failed" ) then
			_tmp = _tmp[1]
			if tobool(_tmp.bool_vehicles) then
				return true
			else
				YRP.msg( "note", pl:Nick() .. " [" .. string.lower(pl:GetUserGroup() ) .. "] tried to spawn a vehicle." )

				YRPNotiToPlyDisallowed(pl, "vehicles" )

				return false
			end
		end
	end
end)

hook.Add( "PlayerGiveSWEP", "yrp_weapons_restriction", function(pl)
	if ea(pl) then
		local _tmp = YRP_SQL_SELECT(DATABASE_NAME, "bool_weapons", "string_name = '" .. string.lower(pl:GetUserGroup() ) .. "'" )
		if worked(_tmp, "PlayerGiveSWEP failed" ) then
			_tmp = _tmp[1]
			if tobool(_tmp.bool_weapons) then
				return true
			else
				YRP.msg( "note", pl:Nick() .. " [" .. string.lower(pl:GetUserGroup() ) .. "] tried to spawn a weapon." )

				YRPNotiToPlyDisallowed(pl, "weapon" )

				return false
			end
		end
	end
end)

local Entity = FindMetaTable( "Entity" )
function Entity:YRPSetOwner(ply)
	self:SetYRPEntity( "yrp_owner", ply)
	--self:SetOwner(ply) -- Breaks Collision somehow
end

function Entity:YRPRemoveOwner()
	self:SetYRPEntity( "yrp_owner", NULL)
end

function HasUseFunction(ent)
	if IsEntity(ent) then
		if ent.Use != nil then
			ent:SetYRPBool( "yrp_has_use", true)
		end
	end
end

hook.Add( "PlayerSpawnedVehicle", "yrp_vehicles_spawned", function(pl, ent)
	ent:YRPSetOwner(pl)
	HasUseFunction(ent)

	YRP_SQL_INSERT_INTO( "yrp_logs",	"string_timestamp, string_typ, string_source_steamid, string_value", "'" .. os.time() .. "' ,'LID_spawns', '" .. pl:SteamID() .. "', 'Vehicle: " .. ent:GetClass() .. "'" )
end)

hook.Add( "PlayerSpawnedSWEP", "yrp_entities_spawned", function(pl, ent)
	ent:YRPSetOwner(pl)
	HasUseFunction(ent)

	YRP_SQL_INSERT_INTO( "yrp_logs",	"string_timestamp, string_typ, string_source_steamid, string_value", "'" .. os.time() .. "' ,'LID_spawns', '" .. pl:SteamID() .. "', 'Weapon: " .. ent:GetClass() .. "'" )
end)

hook.Add( "PlayerSpawnedSENT", "yrp_entities_spawned", function(pl, ent)
	ent:YRPSetOwner(pl)
	HasUseFunction(ent)

	YRP_SQL_INSERT_INTO( "yrp_logs",	"string_timestamp, string_typ, string_source_steamid, string_value", "'" .. os.time() .. "' ,'LID_spawns', '" .. pl:SteamID() .. "', 'Entity: " .. ent:GetClass() .. "'" )
end)

hook.Add( "PlayerSpawnedEffect", "yrp_effects_spawned", function(pl, model, ent)
	ent:YRPSetOwner(pl)
	HasUseFunction(ent)

	YRP_SQL_INSERT_INTO( "yrp_logs",	"string_timestamp, string_typ, string_source_steamid, string_value", "'" .. os.time() .. "' ,'LID_spawns', '" .. pl:SteamID() .. "', 'Effect: " .. ent:GetClass() .. "'" )
end)

hook.Add( "PlayerSpawnedNPC", "yrp_npcs_spawned", function(pl, ent)
	ent:YRPSetOwner(pl)
	HasUseFunction(ent)

	YRP_SQL_INSERT_INTO( "yrp_logs",	"string_timestamp, string_typ, string_source_steamid, string_value", "'" .. os.time() .. "' ,'LID_spawns', '" .. pl:SteamID() .. "', 'NPC: " .. ent:GetClass() .. "'" )
end)

hook.Add( "PlayerSpawnedProp", "yrp_props_spawned", function(pl, model, ent)
	ent:YRPSetOwner(pl)
	HasUseFunction(ent)

	YRP_SQL_INSERT_INTO( "yrp_logs",	"string_timestamp, string_typ, string_source_steamid, string_value", "'" .. os.time() .. "' ,'LID_spawns', '" .. pl:SteamID() .. "', 'PROP: " .. ent:GetClass() .. "'" )
end)

hook.Add( "PlayerSpawnedRagdoll", "yrp_ragdolls_spawned", function(pl, model, ent)
	ent:YRPSetOwner(pl)
	HasUseFunction(ent)

	YRP_SQL_INSERT_INTO( "yrp_logs",	"string_timestamp, string_typ, string_source_steamid, string_value", "'" .. os.time() .. "' ,'LID_spawns', '" .. pl:SteamID() .. "', 'Ragdoll: " .. ent:GetClass() .. "'" )
end)

util.AddNetworkString( "yrp_notification" )
function YRPSendNotification(ply, msg)
	net.Start( "yrp_notification" )
		net.WriteString(msg)
	net.Send(ply)
end

hook.Add( "PlayerSpawnSWEP", "yrp_weapons_restriction", function(pl)
	if ea(pl) then
		local _tmp = YRP_SQL_SELECT(DATABASE_NAME, "bool_weapons", "string_name = '" .. string.lower( pl:GetUserGroup() ) .. "'" )

		if wk(_tmp) then
			_tmp = _tmp[1]
			if tobool(_tmp.bool_weapons) then
				return true
			else
				YRP.msg( "note", pl:Nick() .. " [" .. string.lower(pl:GetUserGroup() ) .. "] tried to spawn an weapon." )

				YRPNotiToPlyDisallowed(pl, "weapons" )

				return false
			end
		else
			YRP.msg( "note", "[PlayerSpawnSWEP] Usergroup not Found" )
			YRPSendNotification(pl, "[PlayerSpawnSWEP] Usergroup not found" )
		end
	end
end)

hook.Add( "PlayerSpawnSENT", "yrp_entities_restriction", function(pl)
	if ea(pl) then
		local _tmp = YRP_SQL_SELECT(DATABASE_NAME, "bool_entities", "string_name = '" .. string.lower(pl:GetUserGroup() ) .. "'" )

		if wk(_tmp) then
			_tmp = _tmp[1]
			if tobool(_tmp.bool_entities) then
				return true
			else
				YRP.msg( "note", pl:Nick() .. " [" .. string.lower(pl:GetUserGroup() ) .. "] tried to spawn an entity." )

				YRPNotiToPlyDisallowed(pl, "entities" )

				return false
			end
		else
			YRP.msg( "note", "[PlayerSpawnSENT] Usergroup not Found" )
			YRPSendNotification(pl, "[PlayerSpawnSENT] Usergroup not found" )
		end
	end
end)

hook.Add( "PlayerSpawnEffect", "yrp_effects_restriction", function(pl)
	if ea(pl) then
		local _tmp = YRP_SQL_SELECT(DATABASE_NAME, "bool_effects", "string_name = '" .. string.lower(pl:GetUserGroup() ) .. "'" )
		if worked(_tmp, "PlayerSpawnEffect failed" ) then
			_tmp = _tmp[1]
			if tobool(_tmp.bool_effects) then
				return true
			else
				YRP.msg( "note", pl:Nick() .. " [" .. string.lower(pl:GetUserGroup() ) .. "] tried to spawn an effect." )

				YRPNotiToPlyDisallowed(pl, "effects" )

				return false
			end
		end
	end
end)

hook.Add( "PlayerSpawnNPC", "yrp_npcs_restriction", function(pl)
	if ea(pl) then
		local _tmp = YRP_SQL_SELECT(DATABASE_NAME, "bool_npcs", "string_name = '" .. string.lower(pl:GetUserGroup() ) .. "'" )
		if worked(_tmp, "PlayerSpawnNPC failed" ) then
			_tmp = _tmp[1]
			if tobool(_tmp.bool_npcs) then
				return true
			else
				YRP.msg( "note", pl:Nick() .. " [" .. string.lower(pl:GetUserGroup() ) .. "] tried to spawn a npc." )

				YRPNotiToPlyDisallowed(pl, "npcs" )

				return false
			end
		end
	end
end)

hook.Add( "PlayerSpawnProp", "yrp_props_restriction", function(pl)
	if ea(pl) then
		local _tmp = YRP_SQL_SELECT(DATABASE_NAME, "bool_props", "string_name = '" .. string.lower(pl:GetUserGroup() ) .. "'" )
		if wk(_tmp, "PlayerSpawnProp failed" ) then
			_tmp = _tmp[1]
			if tobool(_tmp.bool_props) then
				return true
			else
				YRP.msg( "note", pl:Nick() .. " [" .. string.lower(pl:GetUserGroup() ) .. "] tried to spawn a prop." )

				YRPNotiToPlyDisallowed(pl, "props" )

				return false
			end
		else
			YRP.msg( "db", "[PlayerSpawnProp] failed! UserGroup not found in database." )
			return false
		end
	end
end)

hook.Add( "PlayerSpawnRagdoll", "yrp_ragdolls_restriction", function(pl, model)
	if ea(pl) then
		local _tmp = YRP_SQL_SELECT(DATABASE_NAME, "bool_ragdolls", "string_name = '" .. tostring(string.lower(pl:GetUserGroup() )) .. "'" )
		if wk(_tmp) then
			_tmp = _tmp[1]
			if tobool(_tmp.bool_ragdolls) then
				return true
			else
				YRP.msg( "note", pl:Nick() .. " [" .. string.lower(pl:GetUserGroup() ) .. "] tried to spawn a ragdoll." )

				YRPNotiToPlyDisallowed(pl, "ragdolls" )

				return false
			end
		else
			YRP.msg( "db", "[PlayerSpawnRagdoll] failed! UserGroup not found in database." )
		end
	end
end)

function YRPRenderEquipment(ply, name, mode, color)
	local _eq = ply:GetYRPEntity(name)
	if ea(_eq) then
		_eq:SetRenderMode(mode)
		_eq:SetColor( color)
		_eq:SetYRPInt(name .. "mode", mode)
		_eq:SetYRPString(name .. "color", color.r .. "," .. color.g .. "," .. color.b .. "," .. color.a)
	end
end

function YRPRenderEquipments(ply, mode, color)
	YRPRenderEquipment(ply, "backpack", mode, color)
end

function YRPRenderCloaked(ply)
	if IsValid(ply) and ply:IsPlayer() and ply:Alive() and ply:GetWeapons() then
		local _alpha = 0
		ply:SetRenderMode(RENDERMODE_TRANSCOLOR)
		ply:SetColor(Color( 255, 255, 255, _alpha) )
		for i, wp in pairs(ply:GetWeapons() ) do
			wp:SetRenderMode(RENDERMODE_TRANSCOLOR)
			wp:SetColor(Color( 255, 255, 255, _alpha) )
		end
		--YRPRenderEquipments(ply, RENDERMODE_TRANSCOLOR, Color( 255, 255, 255, _alpha) )
	end
end

function YRPRenderFrozen(ply)
	if ea(ply) then
		if ply:GetYRPBool( "cloaked", false) then
			YRPRenderCloaked(ply)
		else
			ply:SetRenderMode(RENDERMODE_NORMAL)
			ply:SetColor( YRPColBlue() )
			for i, wp in pairs(ply:GetWeapons() ) do
				wp:SetRenderMode(RENDERMODE_TRANSCOLOR)
				wp:SetColor( YRPColBlue() )
			end
			--YRPRenderEquipments(ply, RENDERMODE_TRANSCOLOR, YRPColBlue() )
		end
	end
end

function YRPRenderNormal(ply)
	if ea(ply) then
		if ply:GetYRPBool( "cloaked", false) then
			YRPRenderCloaked(ply)
		elseif ply:IsFlagSet(FL_FROZEN) then
			YRPRenderFrozen(ply)
		else
			setPlayerModel(ply)
			ply:SetRenderMode(RENDERMODE_NORMAL)
			ply:SetColor(Color( 255, 255, 255, 255 ) )
			for i, wp in pairs(ply:GetWeapons() ) do
				wp:SetRenderMode(RENDERMODE_NORMAL)
				wp:SetColor(Color( 255, 255, 255, 255 ) )
			end
			--YRPRenderEquipments(ply, RENDERMODE_NORMAL, Color( 255, 255, 255, 255 ) )
		end
	end
end

function EntBlacklisted(ent)
	local blacklist = GetGlobalYRPTable( "yrp_blacklist_entities", {})

	for i, black in pairs( blacklist) do
		if string.find(ent:GetClass(), black.value) or string.find(ent:GetModel(), black.value) then
			return true
		end
	end

	return false
end

function GM:PhysgunPickup(pl, ent)
	if ent:IsDealer() then
		return false
	end
	local tabUsergroup = YRP_SQL_SELECT(DATABASE_NAME, "bool_physgunpickup, bool_physgunpickupworld, bool_physgunpickupplayer, bool_physgunpickupignoreblacklist", "string_name = '" .. string.lower(pl:GetUserGroup() ) .. "'" )
	if wk(tabUsergroup) then
		tabUsergroup = tabUsergroup[1]
		if tobool(tabUsergroup.bool_physgunpickup) then
			if EntBlacklisted(ent) and !tobool(tabUsergroup.bool_physgunpickupignoreblacklist) then
				return false
			elseif ent:IsPlayer() then
				if tobool(tabUsergroup.bool_physgunpickupplayer) then
					if ent:GetYRPInt( "int_position", 0) >= pl:GetYRPInt( "int_position", 0) then -- ent (target) > position as pl
						return true
					end
				else
					YRPNotiToPlyDisallowed(pl, "physgunpickupplayer" )

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
			YRPNotiToPlyDisallowed(pl, "physgunpickup" )

			return false
		end
	else
		YRP.msg( "db", "[PhysgunPickup] failed! UserGroup not found in database." )
		return false
	end
	return false
end

function GM:GravGunPunt(pl, ent)
	local tabUsergroup = YRP_SQL_SELECT(DATABASE_NAME, "bool_gravgunpunt", "string_name = '" .. string.lower(pl:GetUserGroup() ) .. "'" )
	if wk(tabUsergroup) then
		tabUsergroup = tabUsergroup[1]
		if tobool(tabUsergroup.bool_gravgunpunt) then
			return true
		else
			YRPNotiToPlyDisallowed(pl, "gravgunpunt" )

			return false
		end
	else
		YRP.msg( "db", "[GravGunPunt] failed! UserGroup not found in database." )
		return false
	end
	return false
end

local toolantispam = {}
hook.Add( "CanTool", "yrp_can_tool", function(pl, tr, tool)
	if ea(pl) and wk(tool) then
		--YRP.msg( "gm", "CanTool: " .. tool)
		local tools = {}
		local tab = YRP_SQL_SELECT(DATABASE_NAME, "string_tools", "string_name = '" .. string.lower(pl:GetUserGroup() ) .. "'" )
		if wk(tab) then
			tab = tab[1]
			tools = string.Explode( ",", tab.string_tools)
		end

		local hasright = false
		if table.HasValue(tools, "all" ) then
			hasright = true
		elseif table.HasValue(tools, string.lower(tool) ) then
			hasright = true
		end

		if hasright then
			if tr then
				if tr.Entity and IsValid(tr.Entity) and tr.Entity:GetRPOwner() then
					local Owner = tr.Entity:GetRPOwner()
					if Owner == pl or pl:HasAccess() or !ea(Owner) then
						return true
					else
						if !table.HasValue(toolantispam, pl) then
							table.insert(toolantispam, pl)

							if ea(Owner) then
								YRP.msg( "note", "[CanTool] " .. pl:RPName() .. " tried to modify entity from: " .. Owner:RPName() )

								YRPNotiToPlyDisallowed(pl, "You are not the owner!" )
							end
								--[[elseif tr.Entity:CreatedByMap() then
								YRP.msg( "note", "[CanTool] " .. pl:RPName() .. " tried to modify entity from: " .. "MAP-Entity" )
								YRP.msg( "note", "[CanTool] " .. pl:GetUserGroup() .. " has no right to modify it." )

								YRPNotiToPlyDisallowed(pl, "Map Entities!" )
							end]]

							timer.Simple(2, function()
								if ea(pl) then
									table.RemoveByValue(toolantispam, pl)
								end
							end)
						end

						return false
					end
				end
			end
			return true
		else
			YRPNotiToPlyDisallowed(pl, "NO RIGHTS - Tool: " .. tostring(tool) .. " >>> " .. "menu_settings" .. " -> " .. "LID_management" .. " -> " .. "LID_usergroups" .. " -> " .. "LID_tools" )
			YRP.msg( "note", "[CanTool] " .. "NO RIGHTS - Tool: " .. tostring(tool) )
			return false
		end
		YRPNotiToPlyDisallowed(pl, "FAIL FOR TOOL: " .. tostring(tool) )
		YRP.msg( "note", "[CanTool] " .. "FAIL FOR TOOL: " .. tostring(tool) )
		return false
	else
		YRP.msg( "error", "[CanTool] Player is not valid!" )
	end
end)

hook.Add( "CanProperty", "yrp_canproperty", function(pl, property, ent)
	if ea(pl) and wk(property) and pl.GetUserGroup != nil then
		--YRP.msg( "gm", "CanProperty: " .. property)
		local tools = {}
		local tab = YRP_SQL_SELECT(DATABASE_NAME, "string_tools", "string_name = '" .. string.lower(pl:GetUserGroup() ) .. "'" )
		if wk(tab) then
			tab = tab[1]
			tools = string.Explode( ",", tab.string_tools)
		end

		if table.HasValue(tools, "all" ) then
			return true
		elseif table.HasValue(tools, property) then
			return true
		else
			YRPNotiToPlyDisallowed(pl, "TOOL: " .. tostring(property) )
		end
		YRP.msg( "note", "[CanProperty] " .. "FAIL FOR Property: " .. property)
		return false
	else
		YRP.msg( "note", "[CanProperty] Player is not valid!" )
	end
end)

function Player:UserGroupLoadout()
	--YRP.msg( "gm", self:SteamName() .. " UserGroupLoadout" )
	local UG = YRP_SQL_SELECT(DATABASE_NAME, "*", "string_name = '" .. string.lower( self:GetUserGroup() ) .. "'" )
	if wk(UG) then
		UG = UG[1]

		self:SetYRPString( "usergroupDisplayname", UG.string_displayname)
		self:SetYRPString( "usergroupColor", UG.string_color)
		self:SetYRPBool( "ugchat", tobool( UG.bool_chat ) )
		self:SetYRPInt( "int_position", tonumber( UG.int_position ) )
		self:SetYRPInt( "int_characters_max", tonumber( UG.int_characters_max ) )
		self:SetYRPInt( "int_charactersevent_max", tonumber( UG.int_charactersevent_max ) )



		-- sweps
		local SWEPS = UG.string_sweps
		self:SetYRPString( "usergroup_sweps", UG.string_sweps)
		if SWEPS then
			SWEPS = string.Explode( ",", SWEPS)
			for i, swep in pairs(SWEPS) do
				self:Give(swep)
			end
		end



		-- ammos
		local tammos = UG.string_ammos or ""
		tammos = string.Explode( ";", tammos)
		local ammos = {}
		for i, v in pairs(tammos) do
			local t = string.Split( v, ":" )
			ammos[t[1]] = t[2]
		end
		for name, amount in pairs( ammos) do
			local ammo = self:GetAmmoCount(name)
			self:SetAmmo( ammo + amount, name)
		end



		for i, v in pairs(UG) do
			if string.StartWith(i, "bool_" ) then
				self:SetYRPBool(i, tobool( v) )
			end
		end

		
		local _licenseIDs = UG.string_licenses
		if _licenseIDs then
			_licenseIDs = string.Explode( ",", UG.string_licenses)
			for i, lic in pairs(_licenseIDs) do
				if tonumber(lic) != nil then
					self:AddLicense(lic)
				end
			end
			self:SetYRPInt( "licenseIDsVersion", self:GetYRPInt( "licenseIDsVersion", 0 ) + 1 )
		end

		--YRP.msg( "gm", tostring( self:SteamName() ) .. " got his usergroup loadout ( " .. tostring( self:GetUserGroup() ) .. " )" )
	else
		YRP.msg( "note", "USERGROUP NOT FOUND, ADD THE USERGROUP!" )
	end

	YRPCountActiveChannels(self)
	YRPCountPassiveChannels(self)
end

util.AddNetworkString( "yrp_restartserver" )
net.Receive( "yrp_restartserver", function(len, ply)
	if ply:HasAccess() then
		YRPRestartServer()
	end
end)

util.AddNetworkString( "UpdateUsergroupsList" )
function ReloadUsergroupsList()
	SortUserGroups()
	
	timer.Simple( 0.1, function()
		local ugs = YRP_SQL_SELECT(DATABASE_NAME, "*", nil)
		for ip, pl in pairs(HANDLER_USERGROUPS) do
			if IsValid( pl ) then
				if ugs and ugs[1] then
					for i, v in pairs( ugs ) do
						net.Start( "UpdateUsergroupsList" )
							net.WriteBool(i == 1)					
							net.WriteUInt( v.uniqueID, 16 )
							net.WriteString( v.string_name )
							net.WriteString( v.string_color )
							net.WriteString( v.string_icon )
							net.WriteBool( tobool( v.bool_removeable ) )
							net.WriteUInt( v.int_position, 8 )
							net.WriteBool( i == #ugs )
						net.Send(pl)
					end
				end
			end
		end
	end )
end

util.AddNetworkString( "settings_usergroup_position_up" )
net.Receive( "settings_usergroup_position_up", function(len, ply)
	local uid = tonumber(net.ReadString() )
	local usergroup = YRP_SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '" .. uid .. "'" )
	usergroup = usergroup[1]

	usergroup.int_position = tonumber(usergroup.int_position)

	local siblings = YRP_SQL_SELECT(DATABASE_NAME, "*", nil)

	for i, sibling in pairs(siblings) do
		sibling.int_position = tonumber(sibling.int_position)
	end

	local count = 0
	for i, sibling in SortedPairsByMemberValue(siblings, "int_position", false) do
		count = count + 1
		if tonumber(sibling.int_position) == usergroup.int_position - 1 then
			YRP_SQL_UPDATE(DATABASE_NAME, {["int_position"] = usergroup.int_position}, "uniqueID = '" .. sibling.uniqueID .. "'" )
			YRP_SQL_UPDATE(DATABASE_NAME, {["int_position"] = sibling.int_position}, "uniqueID = '" .. uid .. "'" )
		end
	end
	ReloadUsergroupsList()
end)

util.AddNetworkString( "settings_usergroup_position_dn" )
net.Receive( "settings_usergroup_position_dn", function(len, ply)
	local uid = tonumber(net.ReadString() )
	local group = YRP_SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '" .. uid .. "'" )
	group = group[1]

	group.int_position = tonumber(group.int_position)

	local siblings = YRP_SQL_SELECT(DATABASE_NAME, "*", nil)

	for i, sibling in pairs(siblings) do
		sibling.int_position = tonumber(sibling.int_position)
	end

	local count = 0
	for i, sibling in SortedPairsByMemberValue(siblings, "int_position", false) do
		count = count + 1
		if tonumber(sibling.int_position) == group.int_position + 1 then
			YRP_SQL_UPDATE(DATABASE_NAME, {["int_position"] = group.int_position}, "uniqueID = '" .. sibling.uniqueID .. "'" )
			YRP_SQL_UPDATE(DATABASE_NAME, {["int_position"] = sibling.int_position}, "uniqueID = '" .. uid .. "'" )
		end
	end
	ReloadUsergroupsList()
end)

util.AddNetworkString( "get_perma_props" )
net.Receive( "get_perma_props", function(len, ply)
	local tab = {}
	if YRP_SQL_TABLE_EXISTS( "permaprops" ) then
		tab = YRP_SQL_SELECT( "permaprops", "*", nil)
	end

	ply.ppid = ply.ppid or 0

	if wk(tab) then
		ply.ppid = ply.ppid + 1
		local ppid = ply.ppid
		local sortedtab = {}
		local c = 0
		for i, v in pairs(tab) do
			if v.map == game.GetMap() then
				if v.content then
					v.content = util.JSONToTable( v.content)
				else
					v.content = util.JSONToTable( v.data)
				end
				if v.content != nil then
					sortedtab[c] = {}
					sortedtab[c].id = v.id
					sortedtab[c].model = v.content.Model or v.model
					sortedtab[c].class = v.content.Class or v.class
				end

				c = c + 1
			end
		end

		local c = 0
		for i, v in pairs(sortedtab) do --SortedPairsByMemberValue(sortedtab, "model" ) do
			if ply.ppid != ppid then
				break
			end
			timer.Simple( c * 0.01, function()
				if IsValid(ply) then
					if ply.ppid != ppid then
						return
					end
					v.max = table.Count(sortedtab)
					net.Start( "get_perma_props" )
						net.WriteString( c)
						net.WriteTable( v)
					net.Send(ply)
				end
			end)
			c = c + 1
		end
	end
end)

util.AddNetworkString( "yrp_pp_remove" )
net.Receive( "yrp_pp_remove", function(len, ply)
	local ppid = net.ReadString()

	if YRP_SQL_TABLE_EXISTS( "permaprops" ) then
		YRP_SQL_DELETE_FROM( "permaprops", "id = '" .. ppid .. "'" )
	end
end)

util.AddNetworkString( "yrp_pp_close" )
net.Receive( "yrp_pp_close", function(len, ply)
	ply.ppid = ply.ppid or 0
	ply.ppid = ply.ppid + 1
end)

util.AddNetworkString( "yrp_pp_teleport" )
net.Receive( "yrp_pp_teleport", function(len, ply)
	local ppid = net.ReadString()

	if YRP_SQL_TABLE_EXISTS( "permaprops" ) then
		local tab = YRP_SQL_SELECT( "permaprops", "*", "id = '" .. ppid .. "'" )
		if wk(tab) then
			tab = tab[1]

			tab.content = util.JSONToTable(tab.content)

			ply:SetPos(tab.content.Pos)
		end
	end
end)

util.AddNetworkString( "get_perma_props2" )
net.Receive( "get_perma_props2", function(len, ply)
	local tab = {}
	if YRP_SQL_TABLE_EXISTS( "permaprops_system" ) then
		tab = YRP_SQL_SELECT( "permaprops_system", "*", nil)
	end

	ply.ppid = ply.ppid or 0

	if wk(tab) then
		ply.ppid = ply.ppid + 1
		local ppid = ply.ppid
		local sortedtab = {}
		local c = 0
		for i, v in pairs(tab) do
			if v.map == game.GetMap() then
				if v.content then
					v.content = util.JSONToTable( v.content)
				else
					v.content = util.JSONToTable( v.data)
				end
				if v.content != nil then
					sortedtab[c] = {}
					sortedtab[c].id = v.id
					sortedtab[c].model = v.content.Model or v.model
					sortedtab[c].class = v.content.Class or v.class
				end

				c = c + 1
			end
		end

		local c = 0
		for i, v in pairs(sortedtab) do --SortedPairsByMemberValue(sortedtab, "model" ) do
			if ply.ppid != ppid then
				break
			end
			timer.Simple( c * 0.01, function()
				if IsValid(ply) then
					if ply.ppid != ppid then
						return
					end
					v.max = table.Count(sortedtab)

					net.Start( "get_perma_props2" )
						net.WriteString( c)
						net.WriteTable( v)
					net.Send(ply)
				end
			end)
			c = c + 1
		end
	end
end)

util.AddNetworkString( "yrp_pp_remove2" )
net.Receive( "yrp_pp_remove2", function(len, ply)
	local ppid = net.ReadString()

	if YRP_SQL_TABLE_EXISTS( "permaprops_system" ) then
		YRP_SQL_DELETE_FROM( "permaprops_system", "id = '" .. ppid .. "'" )
	end
end)

util.AddNetworkString( "yrp_pp_close2" )
net.Receive( "yrp_pp_close2", function(len, ply)
	ply.ppid = ply.ppid or 0
	ply.ppid = ply.ppid + 1
end)

util.AddNetworkString( "yrp_pp_teleport2" )
net.Receive( "yrp_pp_teleport2", function(len, ply)
	local ppid = net.ReadString()

	if YRP_SQL_TABLE_EXISTS( "permaprops_system" ) then
		local tab = YRP_SQL_SELECT( "permaprops_system", "*", "id = '" .. ppid .. "'" )
		if wk(tab) then
			tab = tab[1]

			tab.data = util.JSONToTable(tab.data)

			ply:SetPos(tab.data.pos)
		end
	end
end)

util.AddNetworkString( "get_usergroup_licenses" )
net.Receive( "get_usergroup_licenses", function(len, ply)
	local licenses = YRP_SQL_SELECT( "yrp_licenses", "*", nil)

	if wk(licenses) then
		net.Start( "get_usergroup_licenses" )
			net.WriteTable(licenses)
		net.Send(ply)
	end
end)

util.AddNetworkString( "usergroup_update_string_licenses" )
net.Receive( "usergroup_update_string_licenses", function(len, ply)
	local uid = tonumber(net.ReadString() )
	local string_licenses = string.lower(net.ReadString() )
	YRP_SQL_UPDATE(DATABASE_NAME, {["string_licenses"] = string_licenses}, "uniqueID = '" .. uid .. "'" )

	YRP.msg( "db", ply:YRPName() .. " updated licenses of usergroup ( " .. uid .. " ) to [" .. string_licenses .. "]" )
end)

util.AddNetworkString( "usergroup_update_string_tools" )
net.Receive( "usergroup_update_string_tools", function(len, ply)
	local uid = tonumber(net.ReadString() )
	local string_tools = net.ReadString()
	YRP_SQL_UPDATE(DATABASE_NAME, {["string_tools"] = string_tools}, "uniqueID = '" .. uid .. "'" )

	YRP.msg( "db", ply:YRPName() .. " updated tools of usergroup ( " .. uid .. " ) to [" .. string_tools .. "]" )
end)

util.AddNetworkString( "usergroup_update_string_ammos" )
net.Receive( "usergroup_update_string_ammos", function(len, ply)
	local uid = tonumber(net.ReadString() )
	local string_ammos = net.ReadString()
	YRP_SQL_UPDATE(DATABASE_NAME, {["string_ammos"] = string_ammos}, "uniqueID = '" .. uid .. "'" )

	YRP.msg( "db", ply:YRPName() .. " updated ammos of usergroup ( " .. uid .. " ) to [" .. string_ammos .. "]" )
end)

local function YRPCheckUGChanged()
	for i, ply in pairs( player.GetAll() ) do
		ply.yrp_ug = ply.yrp_ug or ply:GetUserGroup()
		if ply.yrpauthed then
			if ply:GetUserGroup() != ply.yrp_ug then
				ply.yrp_ug = ply:GetUserGroup()

				timer.Simple(0, function()
					if IsValid(ply) then
						YRP.msg( "note", ply:RPName() .. " has a new usergroup, respawning..." )
						ply:OldKillSilent()
					end
				end)
			end
		else
			ply.yrp_ug = ply:GetUserGroup()
		end
	end
end

local function YRPCheckUGChangedLoop()
	local succ, err = pcall(YRPCheckUGChanged)
	if err then
		YRPMsg(err)
	end

	timer.Simple( 0.1, YRPCheckUGChangedLoop )
end
YRPCheckUGChangedLoop()

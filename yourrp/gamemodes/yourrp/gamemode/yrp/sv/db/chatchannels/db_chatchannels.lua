--Copyright (C) 2017-2021 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

-- DO NOT TOUCH THE DATABASE FILES! If you have errors, report them here:
-- https://discord.gg/sEgNZxg

-- CHAT CHANNELS
local DATABASE_NAME = "yrp_chat_channels"

SQL_ADD_COLUMN(DATABASE_NAME, "string_name", "TEXT DEFAULT 'Unnamed'")

SQL_ADD_COLUMN(DATABASE_NAME, "string_structure", "TEXT DEFAULT '%TEXT%'")

SQL_ADD_COLUMN(DATABASE_NAME, "int_mode", "TEXT DEFAULT '0'") -- 0 = GLOBAL, 1 = LOKAL, 2 = FACTION, 3 = GROUP, 4 = ROLE, 5 = UserGroup, 9 = CUSTOM

SQL_ADD_COLUMN(DATABASE_NAME, "string_active_usergroups", "TEXT DEFAULT 'superadmin,user'")
SQL_ADD_COLUMN(DATABASE_NAME, "string_active_groups", "TEXT DEFAULT '1'")
SQL_ADD_COLUMN(DATABASE_NAME, "string_active_roles", "TEXT DEFAULT '1'")

SQL_ADD_COLUMN(DATABASE_NAME, "string_passive_usergroups", "TEXT DEFAULT 'superadmin,user'")
SQL_ADD_COLUMN(DATABASE_NAME, "string_passive_groups", "TEXT DEFAULT '1'")
SQL_ADD_COLUMN(DATABASE_NAME, "string_passive_roles", "TEXT DEFAULT '1'")

SQL_ADD_COLUMN(DATABASE_NAME, "bool_removeable", "TEXT DEFAULT '1'")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_enabled", "TEXT DEFAULT '1'")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_canbedisabled", "TEXT DEFAULT '1'")

--SQL_DROP_TABLE(DATABASE_NAME)

local yrp_chat_channels = {}
if SQL_SELECT(DATABASE_NAME, "*", "string_name = '" .. "OOC" .. "'") == nil then
	SQL_INSERT_INTO(DATABASE_NAME, "string_name, string_structure, int_mode, bool_removeable", "'OOC', 'Color(100, 255, 100)[OOC] %STEAMNAME%: Color(255, 255, 255)%TEXT%', 0, 0")
end
if SQL_SELECT(DATABASE_NAME, "*", "string_name = '" .. SQL_STR_IN("/") .. "'") == nil then
	SQL_INSERT_INTO(DATABASE_NAME, "string_name, string_structure, int_mode, bool_removeable", "'" .. SQL_STR_IN("/") .. "', 'Color(100, 255, 100)[OOC] %STEAMNAME%: Color(255, 255, 255)%TEXT%', 0, 0")
end
if SQL_SELECT(DATABASE_NAME, "*", "string_name = '" .. "LOOC" .. "'") == nil then
	SQL_INSERT_INTO(DATABASE_NAME, "string_name, string_structure, int_mode, bool_removeable", "'LOOC', 'Color(100, 255, 100)[LOOC] %RPNAME%: Color(255, 255, 255)%TEXT%', 1, 0")
end
if SQL_SELECT(DATABASE_NAME, "*", "string_name = '" .. "SAY" .. "'") == nil then
	SQL_INSERT_INTO(DATABASE_NAME, "string_name, string_structure, int_mode, bool_removeable, bool_canbedisabled", "'SAY', 'Color(100, 255, 100)%RPNAME%: Color(255, 255, 255)%TEXT%', 1, 0, 0")
end
if SQL_SELECT(DATABASE_NAME, "*", "string_name = '" .. "ADVERT" .. "'") == nil then
	SQL_INSERT_INTO(DATABASE_NAME, "string_name, string_structure, int_mode, bool_removeable", "'ADVERT', 'Color(255, 255, 0)[ADVERT] %RPNAME%: %TEXT%', 0, 0")
end
if SQL_SELECT(DATABASE_NAME, "*", "string_name = '" .. "ROLL" .. "'") == nil then
	SQL_INSERT_INTO(DATABASE_NAME, "string_name, string_structure, int_mode, bool_removeable", "'ROLL', 'Color(100, 100, 255)%RPNAME% rolled a RN(0,100)', 1, 0")
end
if SQL_SELECT(DATABASE_NAME, "*", "string_name = '" .. "EVENT" .. "'") == nil then
	SQL_INSERT_INTO(DATABASE_NAME, "string_name, string_structure, int_mode, bool_removeable", "'EVENT', 'Color(255, 255, 100)[EVENT] %RPNAME%: Color(255, 255, 100)%TEXT%', 0, 0")
end
if SQL_SELECT(DATABASE_NAME, "*", "string_name = '" .. "ROLE" .. "'") == nil then
	SQL_INSERT_INTO(DATABASE_NAME, "string_name, string_structure, int_mode, bool_removeable", "'ROLE', 'Color(0, 255, 0)[ROLE] %RPNAME%: Color(255, 255, 255)%TEXT%', 4, 0")
end
if SQL_SELECT(DATABASE_NAME, "*", "string_name = '" .. "GROUP" .. "'") == nil then
	SQL_INSERT_INTO(DATABASE_NAME, "string_name, string_structure, int_mode, bool_removeable", "'GROUP', 'Color(160, 160, 255)[GROUP] %RPNAME%: Color(255, 255, 255)%TEXT%', 3, 0")
end
if SQL_SELECT(DATABASE_NAME, "*", "string_name = '" .. "FACTION" .. "'") == nil then
	SQL_INSERT_INTO(DATABASE_NAME, "string_name, string_structure, int_mode, bool_removeable", "'FACTION', 'Color(100, 100, 255)[FACTION] %RPNAME%: Color(255, 255, 255)%TEXT%', 2, 0")
end
if SQL_SELECT(DATABASE_NAME, "*", "string_name = '" .. "ME" .. "'") == nil then
	SQL_INSERT_INTO(DATABASE_NAME, "string_name, string_structure, int_mode, bool_removeable", "'ME', 'Color(0, 255, 0)%RPNAME% %TEXT%', 1, 0")
end
if SQL_SELECT(DATABASE_NAME, "*", "string_name = '" .. "IT" .. "'") == nil then
	SQL_INSERT_INTO(DATABASE_NAME, "string_name, string_structure, int_mode, bool_removeable", "'IT', 'Color(255, 255, 255)*** %TEXT%', 1, 0")
end
if SQL_SELECT(DATABASE_NAME, "*", "string_name = '" .. "ID" .. "'") == nil then
	SQL_INSERT_INTO(DATABASE_NAME, "string_name, string_structure, int_mode, bool_removeable", "'ID', 'Color(255, 0, 0)%RPNAME% Color(255, 255, 255)shows his ID, it says: Color(255, 0, 0)%IDCARDID%', 1, 0")
end

function GenerateChatTable()
	yrp_chat_channels = {}
	local channels = SQL_SELECT(DATABASE_NAME, "*")
	if wk(channels) then
		for i, channel in pairs(channels) do
			yrp_chat_channels[tonumber(channel.uniqueID)] = {}
			yrp_chat_channels[tonumber(channel.uniqueID)].uniqueID = tonumber(channel.uniqueID)

			-- NAME
			yrp_chat_channels[tonumber(channel.uniqueID)]["string_name"] = string.upper(SQL_STR_OUT(channel.string_name))
		
			-- MODE
			yrp_chat_channels[tonumber(channel.uniqueID)]["int_mode"] = tonumber(channel.int_mode)

			-- STRUCTURE
			yrp_chat_channels[tonumber(channel.uniqueID)]["string_structure"] = SQL_STR_OUT(channel.string_structure)

			-- REMOVEABLE
			yrp_chat_channels[tonumber(channel.uniqueID)]["bool_removeable"] = tobool(channel.bool_removeable)

			-- ENABLED
			yrp_chat_channels[tonumber(channel.uniqueID)]["bool_enabled"] = tonumber(channel.bool_enabled)

			-- ACTIVE
			local augs = {}
			if channel.string_active_usergroups then
				augs = string.Explode(",", channel.string_active_usergroups)
			end
			yrp_chat_channels[tonumber(channel.uniqueID)]["string_active_usergroups"] = {}
			for _, ug in pairs(augs) do
				if !strEmpty(ug) then
					yrp_chat_channels[tonumber(channel.uniqueID)]["string_active_usergroups"][ug] = true
				end
			end


			local agrps = {}
			if channel.string_active_groups then
				agrps = string.Explode(",", channel.string_active_groups)
			end
			yrp_chat_channels[tonumber(channel.uniqueID)]["string_active_groups"] = {}
			for _, grp in pairs(agrps) do
				if !strEmpty(grp) then
					yrp_chat_channels[tonumber(channel.uniqueID)]["string_active_groups"][tonumber(grp)] = true
				end
			end

			local arols = {}
			if channel.string_active_roles then
				arols = string.Explode(",", channel.string_active_roles)
			end
			yrp_chat_channels[tonumber(channel.uniqueID)]["string_active_roles"] = {}
			for _, rol in pairs(arols) do
				if !strEmpty(rol) then
					yrp_chat_channels[tonumber(channel.uniqueID)]["string_active_roles"][tonumber(rol)] = true
				end
			end

			-- PASSIVE
			local pugs = {}
			if channel.string_passive_usergroups then
				pugs = string.Explode(",", channel.string_passive_usergroups)
			end
			yrp_chat_channels[tonumber(channel.uniqueID)]["string_passive_usergroups"] = {}
			for _, ug in pairs(pugs) do
				if !strEmpty(ug) then
					yrp_chat_channels[tonumber(channel.uniqueID)]["string_passive_usergroups"][ug] = true
				end
			end

			local pgrps = {}
			if channel.string_passive_groups then
				pgrps = string.Explode(",", channel.string_passive_groups)
			end
			yrp_chat_channels[tonumber(channel.uniqueID)]["string_passive_groups"] = {}
			for _, grp in pairs(pgrps) do
				if !strEmpty(grp) then
					yrp_chat_channels[tonumber(channel.uniqueID)]["string_passive_groups"][tonumber(grp)] = true
				end
			end

			local prols = {}
			if channel.string_passive_roles then
				prols = string.Explode(",", channel.string_passive_roles)
			end
			yrp_chat_channels[tonumber(channel.uniqueID)]["string_passive_roles"] = {}
			for _, rol in pairs(prols) do
				if !strEmpty(rol) then
					yrp_chat_channels[tonumber(channel.uniqueID)]["string_passive_roles"][tonumber(rol)] = true
				end
			end
		end
	else
		yrp_chat_channels = {}
	end

	SetGlobalTable("yrp_chat_channels", yrp_chat_channels)
end
GenerateChatTable()

util.AddNetworkString("yrp_cm_get_active_usergroups")
net.Receive("yrp_cm_get_active_usergroups", function(len, ply)
	local ugs = SQL_SELECT("yrp_usergroups", "uniqueID, string_name", nil)
	if wk(ugs) then
		net.Start("yrp_cm_get_active_usergroups")
			net.WriteTable(ugs)
		net.Send(ply)
	end
end)

util.AddNetworkString("yrp_cm_get_active_groups")
net.Receive("yrp_cm_get_active_groups", function(len, ply)
	local grps = SQL_SELECT("yrp_ply_groups", "uniqueID, string_name", nil)
	if wk(grps) then
		net.Start("yrp_cm_get_active_groups")
			net.WriteTable(grps)
		net.Send(ply)
	end
end)

util.AddNetworkString("yrp_cm_get_active_roles")
net.Receive("yrp_cm_get_active_roles", function(len, ply)
	local rols = SQL_SELECT("yrp_ply_roles", "uniqueID, string_name", nil)
	if wk(rols) then
		net.Start("yrp_cm_get_active_roles")
			net.WriteTable(rols)
		net.Send(ply)
	end
end)

util.AddNetworkString("yrp_cm_get_passive_usergroups")
net.Receive("yrp_cm_get_passive_usergroups", function(len, ply)
	local ugs = SQL_SELECT("yrp_usergroups", "uniqueID, string_name", nil)
	if wk(ugs) then
		net.Start("yrp_cm_get_passive_usergroups")
			net.WriteTable(ugs)
		net.Send(ply)
	end
end)

util.AddNetworkString("yrp_cm_get_passive_groups")
net.Receive("yrp_cm_get_passive_groups", function(len, ply)
	local grps = SQL_SELECT("yrp_ply_groups", "uniqueID, string_name", nil)
	if wk(grps) then
		net.Start("yrp_cm_get_passive_groups")
			net.WriteTable(grps)
		net.Send(ply)
	end
end)

util.AddNetworkString("yrp_cm_get_passive_roles")
net.Receive("yrp_cm_get_passive_roles", function(len, ply)
	local rols = SQL_SELECT("yrp_ply_roles", "uniqueID, string_name", nil)
	if wk(rols) then
		net.Start("yrp_cm_get_passive_roles")
			net.WriteTable(rols)
		net.Send(ply)
	end
end)

util.AddNetworkString("yrp_chat_channel_add")
net.Receive("yrp_chat_channel_add", function(len, ply)
	local name = string.upper(SQL_STR_IN(net.ReadString()))
	local mode = net.ReadString()
	local structure = SQL_STR_IN(net.ReadString())

	local enabled = tonumber(net.ReadString())

	local augs = table.concat(net.ReadTable(), ",")
	local agrps = table.concat(net.ReadTable(), ",")
	local arols = table.concat(net.ReadTable(), ",")

	local pugs = table.concat(net.ReadTable(), ",")
	local pgrps = table.concat(net.ReadTable(), ",")
	local prols = table.concat(net.ReadTable(), ",")

	SQL_INSERT_INTO(
		DATABASE_NAME,
		"string_name, int_mode, string_structure, bool_enabled, string_active_usergroups, string_active_groups, string_active_roles, string_passive_usergroups, string_passive_groups, string_passive_roles",
		"'" .. name .. "', '" .. mode .. "', '" .. structure .. "', '" .. enabled .. "', '" .. augs .. "', '" .. agrps .. "', '" .. arols .. "', '" .. pugs .. "', '" .. pgrps .. "', '" .. prols	.. "'"
	)

	GenerateChatTable()
end)

util.AddNetworkString("yrp_chat_channel_save")
net.Receive("yrp_chat_channel_save", function(len, ply)
	local name = string.upper(SQL_STR_IN(net.ReadString()))
	local mode = net.ReadString()
	local structure = SQL_STR_IN(net.ReadString())

	local enabled = tonumber(net.ReadString())

	local augs = table.concat(net.ReadTable(), ",")
	local agrps = table.concat(net.ReadTable(), ",")
	local arols = table.concat(net.ReadTable(), ",")

	local pugs = table.concat(net.ReadTable(), ",")
	local pgrps = table.concat(net.ReadTable(), ",")
	local prols = table.concat(net.ReadTable(), ",")

	local uid = net.ReadString()
	
	SQL_UPDATE(
		DATABASE_NAME,
		"string_name = '" .. name .. "', int_mode = '" .. mode .. "', string_structure = '" .. structure .. "', bool_enabled = '" .. enabled .. "',string_active_usergroups = '" .. augs .. "', string_active_groups = '" .. agrps .. "', string_active_roles = '" .. arols .. "', string_passive_usergroups = '" .. pugs .. "', string_passive_groups = '" .. pgrps .. "', string_passive_roles = '" .. prols .. "'",
		"uniqueID = '" .. uid .. "'"
	)

	GenerateChatTable()
end)

util.AddNetworkString("yrp_chat_channel_rem")
net.Receive("yrp_chat_channel_rem", function(len, ply)
	local uid = net.ReadString()

	SQL_DELETE_FROM(DATABASE_NAME, "uniqueID = '" .. uid .. "'")

	GenerateChatTable()
end)

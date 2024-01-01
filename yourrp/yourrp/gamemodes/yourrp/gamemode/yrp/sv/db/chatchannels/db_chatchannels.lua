--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
-- DO NOT TOUCH THE DATABASE FILES! If you have errors, report them here:
-- https://discord.gg/sEgNZxg
-- CHAT CHANNELS
local DATABASE_NAME = "yrp_chat_channels"
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "string_name", "TEXT DEFAULT 'Unnamed'")
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "string_structure", "TEXT DEFAULT '%TEXT%'")
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "string_structure2", "TEXT DEFAULT '%TEXT%'")
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "int_mode", "TEXT DEFAULT '0'") -- 0 = GLOBAL, 1 = LOKAL, 2 = FACTION, 3 = GROUP, 4 = ROLE, 5 = UserGroup, 6 = WHISPER, 9 = CUSTOM
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "string_active_usergroups", "TEXT DEFAULT 'superadmin,user'")
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "string_active_groups", "TEXT DEFAULT '1'")
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "string_active_roles", "TEXT DEFAULT '1'")
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "string_passive_usergroups", "TEXT DEFAULT 'superadmin,user'")
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "string_passive_groups", "TEXT DEFAULT '1'")
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "string_passive_roles", "TEXT DEFAULT '1'")
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_removeable", "TEXT DEFAULT '1'")
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_enabled", "TEXT DEFAULT '1'")
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_canbedisabled", "TEXT DEFAULT '1'")
--YRP_SQL_DROP_TABLE(DATABASE_NAME)
local all = YRP_SQL_SELECT(DATABASE_NAME, "*", nil)
if IsNotNilAndNotFalse(all) then
	local tab = {}
	for i, v in pairs(all) do
		if not table.HasValue(tab, v.string_name) then
			table.insert(tab, v.string_name) -- INSERT UNIQUE
		else
			YRP_SQL_DELETE_FROM(DATABASE_NAME, "uniqueID = '" .. v.uniqueID .. "'") -- DELETE DOUBLE ONCES
		end
	end
end

local yrp_chat_channels = {}
-- CREATE DEFAULT CHANNELS
if YRP_SQL_SELECT(DATABASE_NAME, "*", "string_name = '" .. "OOC" .. "'") == nil then
	YRP_SQL_INSERT_INTO(DATABASE_NAME, "string_name, string_structure, int_mode, bool_removeable", "'OOC', 'Color( 100, 255, 100 )[OOC] %STEAMNAME%: Color( 255, 255, 255, 255 )%TEXT%', 0, 0")
end

if YRP_SQL_SELECT(DATABASE_NAME, "*", "string_name = '" .. "/" .. "'") == nil then
	YRP_SQL_INSERT_INTO(DATABASE_NAME, "string_name, string_structure, int_mode, bool_removeable", "'" .. "/" .. "', 'Color( 100, 255, 100 )[OOC] %STEAMNAME%: Color( 255, 255, 255, 255 )%TEXT%', 0, 0")
end

if YRP_SQL_SELECT(DATABASE_NAME, "*", "string_name = '" .. "LOOC" .. "'") == nil then
	YRP_SQL_INSERT_INTO(DATABASE_NAME, "string_name, string_structure, int_mode, bool_removeable", "'LOOC', 'Color( 100, 255, 100 )[LOOC] %STEAMNAME%: Color( 255, 255, 255, 255 )%TEXT%', 1, 0")
end

if YRP_SQL_SELECT(DATABASE_NAME, "*", "string_name = '" .. "SAY" .. "'") == nil then
	YRP_SQL_INSERT_INTO(DATABASE_NAME, "string_name, string_structure, int_mode, bool_removeable, bool_canbedisabled", "'SAY', 'Color( 100, 255, 100 )%RPNAME%: Color( 255, 255, 255, 255 )%TEXT%', 1, 0, 0")
end

if YRP_SQL_SELECT(DATABASE_NAME, "*", "string_name = '" .. "ADVERT" .. "'") == nil then
	YRP_SQL_INSERT_INTO(DATABASE_NAME, "string_name, string_structure, int_mode, bool_removeable", "'ADVERT', 'Color( 255, 255, 0 )[ADVERT] %RPNAME%: %TEXT%', 0, 0")
end

if YRP_SQL_SELECT(DATABASE_NAME, "*", "string_name = '" .. "ROLL" .. "'") == nil then
	YRP_SQL_INSERT_INTO(DATABASE_NAME, "string_name, string_structure, int_mode, bool_removeable", "'ROLL', 'Color( 100, 100, 255 )%RPNAME% rolled a RN(0,100)', 1, 0")
end

if YRP_SQL_SELECT(DATABASE_NAME, "*", "string_name = '" .. "EVENT" .. "'") == nil then
	YRP_SQL_INSERT_INTO(DATABASE_NAME, "string_name, string_structure, int_mode, bool_removeable", "'EVENT', 'Color( 255, 255, 100 )[EVENT] %RPNAME%: Color( 255, 255, 100 )%TEXT%', 0, 0")
end

if YRP_SQL_SELECT(DATABASE_NAME, "*", "string_name = '" .. "ROLE" .. "'") == nil then
	YRP_SQL_INSERT_INTO(DATABASE_NAME, "string_name, string_structure, int_mode, bool_removeable", "'ROLE', 'Color( 0, 255, 0 )[ROLE] %RPNAME%: Color( 255, 255, 255, 255 )%TEXT%', 4, 0")
end

if YRP_SQL_SELECT(DATABASE_NAME, "*", "string_name = '" .. "GROUP" .. "'") == nil then
	YRP_SQL_INSERT_INTO(DATABASE_NAME, "string_name, string_structure, int_mode, bool_removeable", "'GROUP', 'Color( 160, 160, 255 )[GROUP] %RPNAME%: Color( 255, 255, 255, 255 )%TEXT%', 3, 0")
end

if YRP_SQL_SELECT(DATABASE_NAME, "*", "string_name = '" .. "FACTION" .. "'") == nil then
	YRP_SQL_INSERT_INTO(DATABASE_NAME, "string_name, string_structure, int_mode, bool_removeable", "'FACTION', 'Color( 100, 100, 255 )[FACTION] %RPNAME%: Color( 255, 255, 255, 255 )%TEXT%', 2, 0")
end

if YRP_SQL_SELECT(DATABASE_NAME, "*", "string_name = '" .. "ME" .. "'") == nil then
	YRP_SQL_INSERT_INTO(DATABASE_NAME, "string_name, string_structure, int_mode, bool_removeable", "'ME', 'Color( 0, 255, 0 )%RPNAME% %TEXT%', 1, 0")
end

if YRP_SQL_SELECT(DATABASE_NAME, "*", "string_name = '" .. "IT" .. "'") == nil then
	YRP_SQL_INSERT_INTO(DATABASE_NAME, "string_name, string_structure, int_mode, bool_removeable", "'IT', 'Color( 255, 255, 255, 255 )*** %TEXT%', 1, 0")
end

if YRP_SQL_SELECT(DATABASE_NAME, "*", "string_name = '" .. "ID" .. "'") == nil then
	YRP_SQL_INSERT_INTO(DATABASE_NAME, "string_name, string_structure, int_mode, bool_removeable", "'ID', 'Color( 0, 255, 0 )%RPNAME% Color( 255, 255, 255, 255 )shows his ID, it says: Color( 0, 255, 0 )%IDCARDID%', 1, 0")
end

if YRP_SQL_SELECT(DATABASE_NAME, "*", "string_name = '" .. "W" .. "'") == nil then
	YRP_SQL_INSERT_INTO(DATABASE_NAME, "string_name, string_structure, string_structure2, int_mode, bool_removeable", "'W', 'Color( 255, 100, 255 )von %RPNAME%: %TEXT%', 'Color( 255, 100, 255 )zu %TARGET%: %TEXT%', 6, 0")
else
	YRP_SQL_UPDATE(
		DATABASE_NAME,
		{
			["int_mode"] = 6
		}, "string_name = 'W'"
	)
end

if YRP_SQL_SELECT(DATABASE_NAME, "*", "string_name = '" .. "PM" .. "'") == nil then
	YRP_SQL_INSERT_INTO(DATABASE_NAME, "string_name, string_structure, string_structure2, int_mode, bool_removeable", "'PM', 'Color( 255, 100, 255 )von %RPNAME%: %TEXT%', 'Color( 255, 100, 255 )zu %TARGET%: %TEXT%', 6, 0")
else
	YRP_SQL_UPDATE(
		DATABASE_NAME,
		{
			["int_mode"] = 6
		}, "string_name = 'PM'"
	)
end

local dbChannels = YRP_SQL_SELECT(DATABASE_NAME, "uniqueID, string_structure", nil)
if dbChannels then
	for i, v in pairs(dbChannels) do
		local string_structure = string.Replace(v.string_structure, "Color( 0, 255, 0 )", "Color( 0, 255, 0 )")
		YRP_SQL_UPDATE(
			DATABASE_NAME,
			{
				["string_structure"] = string_structure
			}, "uniqueID = '" .. v.uniqueID .. "'"
		)
	end
end

function GenerateChatTable()
	yrp_chat_channels = {}
	local channels = YRP_SQL_SELECT(DATABASE_NAME, "*")
	if IsNotNilAndNotFalse(channels) then
		for i, channel in pairs(channels) do
			yrp_chat_channels[tonumber(channel.uniqueID)] = {}
			yrp_chat_channels[tonumber(channel.uniqueID)].uniqueID = tonumber(channel.uniqueID)
			-- NAME
			yrp_chat_channels[tonumber(channel.uniqueID)]["string_name"] = string.upper(channel.string_name)
			-- MODE
			yrp_chat_channels[tonumber(channel.uniqueID)]["int_mode"] = tonumber(channel.int_mode)
			-- STRUCTURE
			yrp_chat_channels[tonumber(channel.uniqueID)]["string_structure"] = channel.string_structure
			-- STRUCTURE2
			yrp_chat_channels[tonumber(channel.uniqueID)]["string_structure2"] = channel.string_structure2
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
				if not strEmpty(ug) then
					yrp_chat_channels[tonumber(channel.uniqueID)]["string_active_usergroups"][ug] = true
				end
			end

			local agrps = {}
			if channel.string_active_groups then
				agrps = string.Explode(",", channel.string_active_groups)
			end

			yrp_chat_channels[tonumber(channel.uniqueID)]["string_active_groups"] = {}
			for _, grp in pairs(agrps) do
				if not strEmpty(grp) then
					yrp_chat_channels[tonumber(channel.uniqueID)]["string_active_groups"][tonumber(grp)] = true
				end
			end

			local arols = {}
			if channel.string_active_roles then
				arols = string.Explode(",", channel.string_active_roles)
			end

			yrp_chat_channels[tonumber(channel.uniqueID)]["string_active_roles"] = {}
			for _, rol in pairs(arols) do
				if not strEmpty(rol) then
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
				if not strEmpty(ug) then
					yrp_chat_channels[tonumber(channel.uniqueID)]["string_passive_usergroups"][ug] = true
				end
			end

			local pgrps = {}
			if channel.string_passive_groups then
				pgrps = string.Explode(",", channel.string_passive_groups)
			end

			yrp_chat_channels[tonumber(channel.uniqueID)]["string_passive_groups"] = {}
			for _, grp in pairs(pgrps) do
				if not strEmpty(grp) then
					yrp_chat_channels[tonumber(channel.uniqueID)]["string_passive_groups"][tonumber(grp)] = true
				end
			end

			local prols = {}
			if channel.string_passive_roles then
				prols = string.Explode(",", channel.string_passive_roles)
			end

			yrp_chat_channels[tonumber(channel.uniqueID)]["string_passive_roles"] = {}
			for _, rol in pairs(prols) do
				if not strEmpty(rol) then
					yrp_chat_channels[tonumber(channel.uniqueID)]["string_passive_roles"][tonumber(rol)] = true
				end
			end
		end
	else
		yrp_chat_channels = {}
	end

	SetGlobalYRPTable("yrp_chat_channels", yrp_chat_channels)
end

GenerateChatTable()
util.AddNetworkString("nws_yrp_cm_get_active_usergroups")
net.Receive(
	"nws_yrp_cm_get_active_usergroups",
	function(len, ply)
		local ugs = YRP_SQL_SELECT("yrp_usergroups", "uniqueID, string_name", nil)
		if IsNotNilAndNotFalse(ugs) then
			net.Start("nws_yrp_cm_get_active_usergroups")
			net.WriteTable(ugs)
			net.Send(ply)
		end
	end
)

util.AddNetworkString("nws_yrp_cm_get_active_groups")
net.Receive(
	"nws_yrp_cm_get_active_groups",
	function(len, ply)
		local grps = YRP_SQL_SELECT("yrp_ply_groups", "uniqueID, string_name", nil)
		if IsNotNilAndNotFalse(grps) then
			net.Start("nws_yrp_cm_get_active_groups")
			net.WriteTable(grps)
			net.Send(ply)
		end
	end
)

util.AddNetworkString("nws_yrp_cm_get_active_roles")
net.Receive(
	"nws_yrp_cm_get_active_roles",
	function(len, ply)
		local rols = YRP_SQL_SELECT("yrp_ply_roles", "uniqueID, string_name", nil)
		if IsNotNilAndNotFalse(rols) then
			net.Start("nws_yrp_cm_get_active_roles")
			net.WriteTable(rols)
			net.Send(ply)
		end
	end
)

util.AddNetworkString("nws_yrp_cm_get_passive_usergroups")
net.Receive(
	"nws_yrp_cm_get_passive_usergroups",
	function(len, ply)
		local ugs = YRP_SQL_SELECT("yrp_usergroups", "uniqueID, string_name", nil)
		if IsNotNilAndNotFalse(ugs) then
			net.Start("nws_yrp_cm_get_passive_usergroups")
			net.WriteTable(ugs)
			net.Send(ply)
		end
	end
)

util.AddNetworkString("nws_yrp_cm_get_passive_groups")
net.Receive(
	"nws_yrp_cm_get_passive_groups",
	function(len, ply)
		local grps = YRP_SQL_SELECT("yrp_ply_groups", "uniqueID, string_name", nil)
		if IsNotNilAndNotFalse(grps) then
			net.Start("nws_yrp_cm_get_passive_groups")
			net.WriteTable(grps)
			net.Send(ply)
		end
	end
)

util.AddNetworkString("nws_yrp_cm_get_passive_roles")
net.Receive(
	"nws_yrp_cm_get_passive_roles",
	function(len, ply)
		local rols = YRP_SQL_SELECT("yrp_ply_roles", "uniqueID, string_name", nil)
		if IsNotNilAndNotFalse(rols) then
			net.Start("nws_yrp_cm_get_passive_roles")
			net.WriteTable(rols)
			net.Send(ply)
		end
	end
)

util.AddNetworkString("nws_yrp_chat_channel_add")
net.Receive(
	"nws_yrp_chat_channel_add",
	function(len, ply)
		local name = string.upper(net.ReadString())
		local mode = net.ReadString()
		local structure = net.ReadString()
		local structure2 = net.ReadString()
		local enabled = tonumber(net.ReadString())
		local augs = table.concat(net.ReadTable(), ",")
		local agrps = table.concat(net.ReadTable(), ",")
		local arols = table.concat(net.ReadTable(), ",")
		local pugs = table.concat(net.ReadTable(), ",")
		local pgrps = table.concat(net.ReadTable(), ",")
		local prols = table.concat(net.ReadTable(), ",")
		YRP_SQL_INSERT_INTO(DATABASE_NAME, "string_name, int_mode, string_structure, string_structure2, bool_enabled, string_active_usergroups, string_active_groups, string_active_roles, string_passive_usergroups, string_passive_groups, string_passive_roles", "'" .. name .. "', '" .. mode .. "', '" .. structure .. "', '" .. structure2 .. "', '" .. enabled .. "', '" .. augs .. "', '" .. agrps .. "', '" .. arols .. "', '" .. pugs .. "', '" .. pgrps .. "', '" .. prols .. "'")
		GenerateChatTable()
	end
)

util.AddNetworkString("nws_yrp_chat_channel_save")
net.Receive(
	"nws_yrp_chat_channel_save",
	function(len, ply)
		local name = string.upper(net.ReadString())
		local mode = net.ReadString()
		local structure = net.ReadString()
		local structure2 = net.ReadString()
		local enabled = tonumber(net.ReadString())
		local augs = table.concat(net.ReadTable(), ",")
		local agrps = table.concat(net.ReadTable(), ",")
		local arols = table.concat(net.ReadTable(), ",")
		local pugs = table.concat(net.ReadTable(), ",")
		local pgrps = table.concat(net.ReadTable(), ",")
		local prols = table.concat(net.ReadTable(), ",")
		local uid = net.ReadString()
		YRP_SQL_UPDATE(
			DATABASE_NAME,
			{
				["string_name"] = name,
				["int_mode"] = mode,
				["string_structure"] = structure,
				["string_structure2"] = structure2,
				["bool_enabled"] = enabled,
				["string_active_usergroups"] = augs,
				["string_active_groups"] = agrps,
				["string_active_roles"] = arols,
				["string_passive_usergroups"] = pugs,
				["string_passive_groups"] = pgrps,
				["string_passive_roles"] = prols
			}, "uniqueID = '" .. uid .. "'"
		)

		GenerateChatTable()
	end
)

util.AddNetworkString("nws_yrp_chat_channel_rem")
net.Receive(
	"nws_yrp_chat_channel_rem",
	function(len, ply)
		local uid = net.ReadString()
		YRP_SQL_DELETE_FROM(DATABASE_NAME, "uniqueID = '" .. uid .. "'")
		GenerateChatTable()
	end
)
--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
-- DO NOT TOUCH THE DATABASE FILES! If you have errors, report them here:
-- https://discord.gg/sEgNZxg
-- #BLACKLIST
local DATABASE_NAME = "yrp_blacklist"
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "name", "TEXT DEFAULT ''")
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "value", "TEXT DEFAULT ''")
if YRP_SQL_SELECT(DATABASE_NAME, "*", "value = 'yrp_teleporter'") == nil then
	YRP_SQL_INSERT_INTO(DATABASE_NAME, "name, value", "'inventory', 'yrp_teleporter'")
end

function LoadBlacklist()
	local tabChat = YRP_SQL_SELECT(DATABASE_NAME, "*", "name = '" .. "chat" .. "'")
	local tabInventory = YRP_SQL_SELECT(DATABASE_NAME, "*", "name = '" .. "inventory" .. "'")
	local tabEntities = YRP_SQL_SELECT(DATABASE_NAME, "*", "name = '" .. "entities" .. "'")
	local tabProps = YRP_SQL_SELECT(DATABASE_NAME, "*", "name = '" .. "props" .. "'")
	if IsNotNilAndNotFalse(tabChat) then
		SetGlobalYRPTable("yrp_blacklist_chat", tabChat)
	end

	if IsNotNilAndNotFalse(tabInventory) then
		SetGlobalYRPTable("yrp_blacklist_inventory", tabInventory)
	end

	if IsNotNilAndNotFalse(tabEntities) then
		SetGlobalYRPTable("yrp_blacklist_entities", tabEntities)
	end

	if IsNotNilAndNotFalse(tabProps) then
		SetGlobalYRPTable("yrp_blacklist_props", tabProps)
	end
end

LoadBlacklist()
util.AddNetworkString("nws_yrp_blacklist_get")
net.Receive(
	"nws_yrp_blacklist_get",
	function(len, ply)
		local site = net.ReadString()
		local tab = YRP_SQL_SELECT(DATABASE_NAME, "*", nil)
		if not IsNotNilAndNotFalse(tab) then
			tab = {}
		end

		if strEmpty(site) then
			site = "LID_all"
		end

		net.Start("nws_yrp_blacklist_get")
		net.WriteTable(tab)
		net.WriteString(site)
		net.Send(ply)
	end
)

util.AddNetworkString("nws_yrp_blacklist_add")
net.Receive(
	"nws_yrp_blacklist_add",
	function(len, ply)
		local name = net.ReadString()
		local value = net.ReadString()
		if IsNotNilAndNotFalse(name) and IsNotNilAndNotFalse(value) then
			YRP.msg("db", "Added blacklist entry: " .. value)
			YRP_SQL_INSERT_INTO(DATABASE_NAME, "name, value", "'" .. name .. "', '" .. value .. "'")
		end

		LoadBlacklist()
	end
)

util.AddNetworkString("nws_yrp_blacklist_remove")
net.Receive(
	"nws_yrp_blacklist_remove",
	function(len, ply)
		local uid = net.ReadString()
		if IsNotNilAndNotFalse(uid) then
			YRP.msg("db", "Removed blacklist entry")
			YRP_SQL_DELETE_FROM(DATABASE_NAME, "uniqueID = '" .. uid .. "'")
		end

		LoadBlacklist()
	end
)
--Copyright (C) 2017-2021 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

-- DO NOT TOUCH THE DATABASE FILES! If you have errors, report them here:
-- https://discord.gg/sEgNZxg

-- #BLACKLIST

local DATABASE_NAME = "yrp_blacklist"

SQL_ADD_COLUMN(DATABASE_NAME, "name", "TEXT DEFAULT ''")
SQL_ADD_COLUMN(DATABASE_NAME, "value", "TEXT DEFAULT ''")

--db_drop_table(DATABASE_NAME)
--db_is_empty(DATABASE_NAME)

--[[
name		value
chat		Hammerfall
inventory	yrp_holo
]]
--"yrp_blacklist_chat"

if SQL_SELECT(DATABASE_NAME, "*", "value = 'yrp_teleporter'") == nil then
	SQL_INSERT_INTO(DATABASE_NAME, "name, value", "'inventory', 'yrp_teleporter'")
end

function LoadBlacklist()
	local tabChat = SQL_SELECT(DATABASE_NAME, "*", "name = '" .. "chat" .. "'")
	local tabInventory = SQL_SELECT(DATABASE_NAME, "*", "name = '" .. "inventory" .. "'")
	local tabEntities = SQL_SELECT(DATABASE_NAME, "*", "name = '" .. "entities" .. "'")
	if wk(tabChat) then
		SetGlobalTable("yrp_blacklist_chat", tabChat)
	end
	if wk(tabInventory) then
		SetGlobalTable("yrp_blacklist_inventory", tabInventory)
	end
	if wk(tabEntities) then
		SetGlobalTable("yrp_blacklist_entities", tabEntities)
	end
end
LoadBlacklist()

util.AddNetworkString("yrp_blacklist_get")
net.Receive("yrp_blacklist_get", function(len, ply)
	local site = net.ReadString()

	local tab = SQL_SELECT(DATABASE_NAME, "*", nil)

	if !wk(tab) then
		tab = {}
	end
	
	if strEmpty(site) then
		site = "LID_all"
	end

	net.Start("yrp_blacklist_get")
		net.WriteTable(tab)
		net.WriteString(site)
	net.Send(ply)
end)

util.AddNetworkString("yrp_blacklist_add")
net.Receive("yrp_blacklist_add", function(len, ply)
	local name = net.ReadString()
	local value = net.ReadString()

	if wk(name) and wk(value) then
		YRP.msg("db", "Added blacklist entry: " .. value)
		SQL_INSERT_INTO(DATABASE_NAME, "name, value", "'" .. name .. "', '" .. value .. "'")
	end

	LoadBlacklist()
end)

util.AddNetworkString("yrp_blacklist_remove")
net.Receive("yrp_blacklist_remove", function(len, ply)
	local uid = net.ReadString()
	
	if wk(uid) then
		YRP.msg("db", "Removed blacklist entry")
		SQL_DELETE_FROM(DATABASE_NAME, "uniqueID = '" .. uid .. "'")
	end

	LoadBlacklist()
end)

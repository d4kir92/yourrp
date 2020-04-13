--Copyright (C) 2017-2020 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

-- DO NOT TOUCH THE DATABASE FILES! If you have errors, report them here:
-- https://discord.gg/sEgNZxg

local DATABASE_NAME = "yrp_laws"

--SQL_DROP_TABLE(DATABASE_NAME)

SQL_ADD_COLUMN(DATABASE_NAME, "string_lawsymbol", "TEXT DEFAULT '§'")
SQL_ADD_COLUMN(DATABASE_NAME, "string_laws", "TEXT DEFAULT ' '")

if SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '1'") == nil then
	SQL_INSERT_INTO(DATABASE_NAME, "string_lawsymbol, string_laws", "'§', ' '")
end

local laws = SQL_SELECT(DATABASE_NAME, "*")
if wk(laws) then
	laws = laws[1]
	SetGlobalDString("sting_laws", laws.string_laws)
end

util.AddNetworkString("yrp_get_laws")
net.Receive("yrp_get_laws", function(len, ply)
	local laws = SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '1'")
	if wk(laws) then
		laws = laws[1]
		laws.string_lawsymbol = SQL_STR_OUT(laws.string_lawsymbol)
		laws.string_laws = SQL_STR_OUT(laws.string_laws)
		local lockdown = SQL_SELECT("yrp_lockdown", "*", "uniqueID = '1'")
		if wk(lockdown) then
			lockdown = lockdown[1]
			laws.bool_lockdown = lockdown.bool_lockdown
			laws.string_lockdowntext = SQL_STR_OUT(lockdown.string_lockdowntext)
		end

		local buildings = SQL_SELECT("yrp_" .. GetMapNameDB() .. "_buildings", "name, bool_lockdown, uniqueID", "name != 'Building'")
		if !wk(buildings) then
			buildings = {}
		end

		net.Start("yrp_get_laws")
			net.WriteTable(laws)
			net.WriteTable(buildings)
		net.Send(ply)
	end
end)

util.AddNetworkString("set_lawsymbol")
net.Receive("set_lawsymbol", function(len, ply)
	local lawsymbol = net.ReadString()
	lawsymbol = SQL_STR_IN(lawsymbol)
	YRP.msg("db", "Changed lawsymbol to: " .. lawsymbol)
	SQL_UPDATE(DATABASE_NAME, "string_lawsymbol = '" .. lawsymbol .. "'", "uniqueID = '1'")
end)

util.AddNetworkString("set_laws")
net.Receive("set_laws", function(len, ply)
	local laws = net.ReadString()
	laws = SQL_STR_IN(laws)
	YRP.msg("db", "Changed lawsymbol to: " .. laws)
	SQL_UPDATE(DATABASE_NAME, "string_laws = '" .. laws .. "'", "uniqueID = '1'")
end)

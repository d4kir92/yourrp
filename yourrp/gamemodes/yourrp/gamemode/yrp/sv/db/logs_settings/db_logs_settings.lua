--Copyright (C) 2017-2021 D4KiR (https://www.gnu.org/licenses/gpl.txt)

-- DO NOT TOUCH THE DATABASE FILES! If you have errors, report them here:
-- https://discord.gg/sEgNZxg

local DATABASE_NAME = "yrp_logs_settings"

--SQL_DROP_TABLE(DATABASE_NAME)

SQL_ADD_COLUMN(DATABASE_NAME, "string_text", "TEXT DEFAULT 'unknown'")
SQL_ADD_COLUMN(DATABASE_NAME, "string_timestamp", "TEXT DEFAULT ''")

local showafter =	60*60*12
local deleteafter =	60*60*24

local logTab = SQL_SELECT(DATABASE_NAME, "*", nil)
if wk(logTab) then
	for i, t in pairs(logTab) do
		if os.time() - deleteafter > tonumber(t.string_timestamp) then
			SQL_DELETE_FROM(DATABASE_NAME, "uniqueID = '" .. t.uniqueID .. "'")
		end
	end
end

util.AddNetworkString("yrp_get_logs_settings")
net.Receive("yrp_get_logs_settings", function(len, ply)
	local tab = net.ReadString()

	if ply:CanAccess("bool_logs") then
		local dbtab = SQL_SELECT(DATABASE_NAME, "*", nil)
		local nettab = {}
		if wk(dbtab) then
			for i, t in pairs(dbtab) do
				if os.time() - showafter < tonumber(t.string_timestamp) then
					table.insert(nettab, t)
				else
					SQL_DELETE_FROM(DATABASE_NAME, "uniqueID = '" .. t.uniqueID .. "'")
				end
			end
		end

		table.SortByMember(nettab, "string_timestamp")

		net.Start("yrp_get_logs_settings")
			net.WriteTable(nettab)
		net.Send(ply)
	end
end)

function YRP.log( msg )
	YRP.msg( "note", msg )
	SQL_INSERT_INTO("yrp_logs_settings", "string_timestamp, string_text", "'" .. os.time() .. "', " .. SQL_STR_IN( msg ) .. "")
end

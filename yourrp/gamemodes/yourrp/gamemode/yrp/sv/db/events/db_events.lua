--Copyright (C) 2017-2021 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

-- DO NOT TOUCH THE DATABASE FILES! If you have errors, report them here:
-- https://discord.gg/sEgNZxg

local DATABASE_NAME = "yrp_events"

SQL_ADD_COLUMN(DATABASE_NAME, "string_eventname", "TEXT DEFAULT ''")
SQL_ADD_COLUMN(DATABASE_NAME, "string_chars", "TEXT DEFAULT ''")


--db_drop_table(_db_name)
--db_is_empty(_db_name)

util.AddNetworkString("setting_events")
net.Receive("setting_events", function(len, ply)
	if ply:CanAccess("bool_events") then
		net.Start("setting_events")
		net.Send(ply)
	end
end)

function YRPSendEvents(ply)
	local tab = SQL_SELECT(DATABASE_NAME, "*", nil)

	if wk(tab) then
		net.Start("yrp_get_events")
			net.WriteTable(tab)
		net.Send(ply)
	end
end

util.AddNetworkString("yrp_get_events")
net.Receive("yrp_get_events", function(len, ply)
	if ply:CanAccess("bool_events") then
		YRPSendEvents(ply)
	end
end)

util.AddNetworkString("yrp_event_add")
net.Receive("yrp_event_add", function(len, ply)
	if ply:CanAccess("bool_events") then
		local name = net.ReadString()
		print(name)
		if name and name != "" then
			SQL_INSERT_INTO(DATABASE_NAME, "string_eventname", "'" .. name .. "'")
			YRPSendEvents(ply)
		end
	end
end)

util.AddNetworkString("yrp_event_remove")
net.Receive("yrp_event_remove", function(len, ply)
	if ply:CanAccess("bool_events") then
		local uid = net.ReadString()

		if uid and uid != "" then
			SQL_DELETE_FROM(DATABASE_NAME, "uniqueID = '" .. uid .. "'")
			YRPSendEvents(ply)
		end
	end
end)
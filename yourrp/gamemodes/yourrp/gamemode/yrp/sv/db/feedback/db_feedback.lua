--Copyright (C) 2017-2021 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

-- DO NOT TOUCH THE DATABASE FILES! If you have errors, report them here:
-- https://discord.gg/sEgNZxg

-- #FEEDBACKDATABASE

local DATABASE_NAME = "yrp_feedback"

SQL_ADD_COLUMN(DATABASE_NAME, "title", "TEXT DEFAULT 'UNNAMED'")
SQL_ADD_COLUMN(DATABASE_NAME, "feedback", "TEXT DEFAULT 'UNNAMED'")
SQL_ADD_COLUMN(DATABASE_NAME, "contact", "TEXT DEFAULT 'UNNAMED'")
SQL_ADD_COLUMN(DATABASE_NAME, "steamid", "TEXT DEFAULT 'UNNAMED'")
SQL_ADD_COLUMN(DATABASE_NAME, "steamname", "TEXT DEFAULT 'UNNAMED'")
SQL_ADD_COLUMN(DATABASE_NAME, "rpname", "TEXT DEFAULT 'UNNAMED'")
SQL_ADD_COLUMN(DATABASE_NAME, "status", "TEXT DEFAULT 'open'")
SQL_ADD_COLUMN(DATABASE_NAME, "timestamp", "TEXT DEFAULT ''")

--db_drop_table(DATABASE_NAME)
--db_is_empty(DATABASE_NAME)

local showafter =	60*60*12
local deleteafter =	60*60*24

util.AddNetworkString("get_ticket")
net.Receive("get_ticket", function(len, ply)
	if ply:CanAccess("bool_feedback") then
		local _result = SQL_SELECT(DATABASE_NAME, "*", nil)

		if wk(_result) then
			for i, t in pairs(_result) do
				t.string_timestamp = t.string_timestamp or "0"
				t.string_timestamp = tonumber(t.string_timestamp)

				if t.status == "closed" and os.time() - deleteafter > t.string_timestamp then
					SQL_DELETE_FROM(DATABASE_NAME, "uniqueID = '" .. t.uniqueID .. "'")
				end
			end
		end
		
		_result = SQL_SELECT(DATABASE_NAME, "*", nil)

		if _result == nil or _result == false then
			_result = {}
		end

		net.Start("get_ticket")
			net.WriteTable(_result)
		net.Send(ply)
	end
end)

util.AddNetworkString("add_ticket")
net.Receive("add_ticket", function(len, ply)
	local _fb = net.ReadTable()
	local _insert = SQL_INSERT_INTO(DATABASE_NAME, "title, feedback, contact, steamid, steamname, rpname, timestamp", "'" .. SQL_STR_IN(_fb.title) .. "', '" .. SQL_STR_IN(_fb.feedback) .. "', '" .. SQL_STR_IN(_fb.contact) .. "', '" .. SQL_STR_IN(_fb.steamid) .. "', '" .. SQL_STR_IN(_fb.steamname) .. "', '" .. SQL_STR_IN(_fb.rpname) .. "', '" .. os.time() .. "'")
	net.Start("yrp_noti")
		net.WriteString("newfeedback")
		net.WriteString("")
	net.Broadcast()
end)

util.AddNetworkString("fb_movetoopen")
net.Receive("fb_movetowip", function(len, ply)
	local uid = net.ReadString()

	SQL_UPDATE(DATABASE_NAME, "status = 'open'", "uniqueID = '" .. uid .. "'")
end)

util.AddNetworkString("fb_movetowip")
net.Receive("fb_movetowip", function(len, ply)
	local uid = net.ReadString()

	SQL_UPDATE(DATABASE_NAME, "status = 'wip'", "uniqueID = '" .. uid .. "'")
end)

util.AddNetworkString("fb_movetoclosed")
net.Receive("fb_movetoclosed", function(len, ply)
	local uid = net.ReadString()

	SQL_UPDATE(DATABASE_NAME, "status = 'closed'", "uniqueID = '" .. uid .. "'")
end)
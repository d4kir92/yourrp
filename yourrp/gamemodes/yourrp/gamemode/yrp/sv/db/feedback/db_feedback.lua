--Copyright (C) 2017-2021 D4KiR (https://www.gnu.org/licenses/gpl.txt)

-- DO NOT TOUCH THE DATABASE FILES! If you have errors, report them here:
-- https://discord.gg/sEgNZxg

-- #FEEDBACKDATABASE

local DATABASE_NAME = "yrp_feedback"

YRP_SQL_ADD_COLUMN(DATABASE_NAME, "title", "TEXT DEFAULT 'UNNAMED'" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "feedback", "TEXT DEFAULT 'UNNAMED'" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "contact", "TEXT DEFAULT 'UNNAMED'" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "steamid", "TEXT DEFAULT 'UNNAMED'" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "steamname", "TEXT DEFAULT 'UNNAMED'" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "rpname", "TEXT DEFAULT 'UNNAMED'" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "status", "TEXT DEFAULT 'open'" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "timestamp", "TEXT DEFAULT ''" )

local showafter =	60*60*12
local deleteafter =	60*60*24

util.AddNetworkString( "get_ticket" )
net.Receive( "get_ticket", function(len, ply)
	if ply:CanAccess( "bool_feedback" ) then
		local _result = YRP_SQL_SELECT(DATABASE_NAME, "*", nil)

		if wk(_result) then
			for i, t in pairs(_result) do
				t.string_timestamp = t.string_timestamp or "0"
				t.string_timestamp = tonumber(t.string_timestamp)

				if t.status == "closed" and os.time() - deleteafter > t.string_timestamp then
					YRP_SQL_DELETE_FROM(DATABASE_NAME, "uniqueID = '" .. t.uniqueID .. "'" )
				end
			end
		end
		
		_result = YRP_SQL_SELECT(DATABASE_NAME, "*", nil)

		if _result == nil or _result == false then
			_result = {}
		end

		net.Start( "get_ticket" )
			net.WriteTable(_result)
		net.Send(ply)
	end
end)

util.AddNetworkString( "add_ticket" )
net.Receive( "add_ticket", function(len, ply)
	local _fb = net.ReadTable()
	local _insert = YRP_SQL_INSERT_INTO(DATABASE_NAME, "title, feedback, contact, steamid, steamname, rpname, timestamp", "'" .. _fb.title .. "', '" .. _fb.feedback .. "', '" .. _fb.contact .. "', '" .. _fb.steamid .. "', '" .. _fb.steamname .. "', '" .. _fb.rpname .. "', '" .. os.time() .. "'" )
	net.Start( "yrp_noti" )
		net.WriteString( "newfeedback" )
		net.WriteString( "" )
	net.Broadcast()
end)

util.AddNetworkString( "fb_movetoopen" )
net.Receive( "fb_movetowip", function(len, ply)
	local uid = net.ReadString()

	YRP_SQL_UPDATE(DATABASE_NAME, {["status"] = "open"}, "uniqueID = '" .. uid .. "'" )
end)

util.AddNetworkString( "fb_movetowip" )
net.Receive( "fb_movetowip", function(len, ply)
	local uid = net.ReadString()

	YRP_SQL_UPDATE(DATABASE_NAME, {["status"] = "wip"}, "uniqueID = '" .. uid .. "'" )
end)

util.AddNetworkString( "fb_movetoclosed" )
net.Receive( "fb_movetoclosed", function(len, ply)
	local uid = net.ReadString()

	YRP_SQL_UPDATE(DATABASE_NAME, {["status"] = "closed"}, "uniqueID = '" .. uid .. "'" )
end)
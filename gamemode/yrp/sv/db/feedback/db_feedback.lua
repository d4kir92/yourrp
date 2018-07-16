--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

-- DO NOT TOUCH THE DATABASE FILES! If you have errors, report them here:
-- https://discord.gg/sEgNZxg

local _db_name = "yrp_feedback"

SQL_ADD_COLUMN( _db_name, "title", "TEXT DEFAULT 'UNNAMED'" )
SQL_ADD_COLUMN( _db_name, "feedback", "TEXT DEFAULT 'UNNAMED'" )
SQL_ADD_COLUMN( _db_name, "contact", "TEXT DEFAULT 'UNNAMED'" )
SQL_ADD_COLUMN( _db_name, "steamid", "TEXT DEFAULT 'UNNAMED'" )
SQL_ADD_COLUMN( _db_name, "steamname", "TEXT DEFAULT 'UNNAMED'" )

--db_drop_table( _db_name )
--db_is_empty( _db_name )

util.AddNetworkString( "get_feedback" )

net.Receive( "get_feedback", function( len, ply )
	if ply:CanAccess( "feedback" ) then
		local _result = SQL_SELECT( _db_name, "*", nil )
		if _result == nil or _result == false then
			_result = {}
		end

		net.Start( "get_feedback" )
			net.WriteTable( _result )
		net.Send( ply )
	end
end)

util.AddNetworkString( "add_feedback" )

net.Receive( "add_feedback", function( len, ply )
	local _fb = net.ReadTable()
	local _insert = SQL_INSERT_INTO( _db_name, "title, feedback, contact, steamid, steamname", "'" .. SQL_STR_IN(_fb.title) .. "', '" .. SQL_STR_IN(_fb.feedback) .. "', '" .. SQL_STR_IN(_fb.contact) .. "', '" .. SQL_STR_IN(_fb.steamid) .. "', '" .. SQL_STR_IN(_fb.steamname) .. "'" )
	net.Start( "yrp_noti" )
		net.WriteString( "newfeedback" )
		net.WriteString( "" )
	net.Broadcast()
end)

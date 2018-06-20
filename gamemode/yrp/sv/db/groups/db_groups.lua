--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

-- DO NOT TOUCH THE DATABASE FILES! If you have errors, report them here:
-- https://discord.gg/sEgNZxg

local _db_name = "yrp_groups"

SQL_ADD_COLUMN( _db_name, "groupID", "TEXT DEFAULT 'new Group'" )
SQL_ADD_COLUMN( _db_name, "uppergroup", "INTEGER DEFAULT -1" )
SQL_ADD_COLUMN( _db_name, "friendlyfire", "INTEGER DEFAULT 1" )
SQL_ADD_COLUMN( _db_name, "removeable", "INTEGER DEFAULT 1" )
SQL_ADD_COLUMN( _db_name, "color", "TEXT DEFAULT '0,0,0'" )

--db_drop_table( _db_name )
--db_is_empty( _db_name )

if SQL_SELECT( _db_name, "*", "uniqueID = 1" ) == nil then
	printGM( "note", _db_name .. " has not the default group" )
	local _result = SQL_INSERT_INTO( _db_name, "uniqueID, groupID, color, uppergroup, friendlyfire, removeable", "1, 'Civilians', '0,0,255', -1, 1, 0" )
end

util.AddNetworkString( "get_grps" )

net.Receive( "get_grps", function( len, ply )
	local _uid = tonumber( net.ReadString() )

	local _get_grps = SQL_SELECT( _db_name, "*", "uppergroup = " .. _uid )
	if _get_grps != nil then

		net.Start( "get_grps" )
			net.WriteTable( _get_grps )
		net.Send( ply )
	end
end)

--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

--db_players.lua

local dbTable = "yrp_players"

include( "players/db_net.lua" )
include( "players/db_func.lua" )

sqlAddColumn( dbTable, "SteamID", "TEXT" )
sqlAddColumn( dbTable, "SteamID64", "TEXT" )  --not available on disconnect!
sqlAddColumn( dbTable, "SteamName", "TEXT" )
sqlAddColumn( dbTable, "CurrentCharacter", "INT" )
sqlAddColumn( dbTable, "Timestamp", "INT" )

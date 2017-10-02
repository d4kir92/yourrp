--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

--db_map.lua

include( "map/db_net.lua" )
include( "map/db_func.lua" )

local dbTable = "yrp_" .. string.lower( game.GetMap() )

sqlAddColumn( dbTable, "position", "TEXT DEFAULT ''" )
sqlAddColumn( dbTable, "angle", "TEXT DEFAULT ''" )
sqlAddColumn( dbTable, "groupID", "INTEGER DEFAULT -1" )
sqlAddColumn( dbTable, "type", "TEXT DEFAULT ''" )

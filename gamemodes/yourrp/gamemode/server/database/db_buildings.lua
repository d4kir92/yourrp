--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

--db_map.lua

include( "buildings/db_net.lua" )
include( "buildings/db_func.lua" )

local dbTable = "yrp_" .. string.lower( game.GetMap() ) .. "_doors"
sqlAddColumn( dbTable, "buildingID", "INTEGER DEFAULT -1" )
sqlAddColumn( dbTable, "level", "INTEGER DEFAULT 1" )
sqlAddColumn( dbTable, "keynr", "INTEGER DEFAULT -1" )

dbTable = "yrp_" .. string.lower( game.GetMap() ) .. "_buildings"
sqlAddColumn( dbTable, "groupID", "INTEGER DEFAULT -1" )
sqlAddColumn( dbTable, "buildingprice", "TEXT DEFAULT 100" )
sqlAddColumn( dbTable, "ownerCharID", "TEXT DEFAULT ''" )
sqlAddColumn( dbTable, "name", "TEXT DEFAULT 'Building'" )

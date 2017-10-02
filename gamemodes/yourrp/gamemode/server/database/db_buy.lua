--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

--db_buy.lua

include( "buy/db_net.lua" )
include( "buy/db_func.lua" )

local dbName = "yrp_buy"

sqlAddColumn( dbName, "ClassName", "TEXT DEFAULT ''" )
sqlAddColumn( dbName, "PrintName", "TEXT DEFAULT ''" )
sqlAddColumn( dbName, "WorldModel", "TEXT DEFAULT ''" )
sqlAddColumn( dbName, "price", "INTEGER DEFAULT 100" )
sqlAddColumn( dbName, "tab", "TEXT DEFAULT ''")

--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

--db_jail.lua

include( "jail/db_net.lua" )
include( "jail/db_func.lua" )

local dbName = "yrp_jail"

sqlAddColumn( dbName, "SteamID", "TEXT DEFAULT ''" )
sqlAddColumn( dbName, "nick", "TEXT DEFAULT ''" )
sqlAddColumn( dbName, "reason", "TEXT DEFAULT '-'" )
sqlAddColumn( dbName, "time", "TEXT INT 1" )

--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

--db_role_whitelist.lua

include( "whitelist/db_net.lua" )
include( "whitelist/db_func.lua" )

local dbName = "yrp_role_whitelist"

sqlAddColumn( dbName, "SteamID", "TEXT DEFAULT ''" )
sqlAddColumn( dbName, "nick", "TEXT DEFAULT ''" )
sqlAddColumn( dbName, "groupID", "INTEGER DEFAULT -1" )
sqlAddColumn( dbName, "roleID", "INTEGER DEFAULT -1" )

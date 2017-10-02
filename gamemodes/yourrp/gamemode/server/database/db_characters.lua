--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

--db_characters.lua

local dbTable = "yrp_characters"

include( "characters/db_net.lua" )
--include( "players/db_func.lua" )

sqlAddColumn( dbTable, "SteamID", "TEXT" )
sqlAddColumn( dbTable, "SteamID64", "TEXT" )

sqlAddColumn( dbTable, "roleID", "INT     DEFAULT 1" )
sqlAddColumn( dbTable, "groupID", "INT     DEFAULT 1" )

sqlAddColumn( dbTable, "playermodelID", "INT     DEFAULT 1" )

sqlAddColumn( dbTable, "keynrs", "TEXT    DEFAULT ''" )
sqlAddColumn( dbTable, "rpname", "TEXT    DEFAULT 'ID_RPNAME'" )
sqlAddColumn( dbTable, "gender", "TEXT    DEFAULT 'male'" )
sqlAddColumn( dbTable, "money", "INT     DEFAULT 250" )
sqlAddColumn( dbTable, "moneybank", "INT     DEFAULT 500" )
sqlAddColumn( dbTable, "position", "TEXT" )
sqlAddColumn( dbTable, "angle", "TEXT" )
sqlAddColumn( dbTable, "map", "TEXT" )

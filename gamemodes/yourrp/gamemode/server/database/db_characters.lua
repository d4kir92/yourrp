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
sqlAddColumn( dbTable, "skin", "INT     DEFAULT 1" )
sqlAddColumn( dbTable, "bg1", "INT     DEFAULT 0" )
sqlAddColumn( dbTable, "bg2", "INT     DEFAULT 0" )
sqlAddColumn( dbTable, "bg3", "INT     DEFAULT 0" )
sqlAddColumn( dbTable, "bg4", "INT     DEFAULT 0" )

sqlAddColumn( dbTable, "keynrs", "TEXT    DEFAULT ''" )
sqlAddColumn( dbTable, "rpname", "TEXT    DEFAULT 'ID_RPNAME'" )
sqlAddColumn( dbTable, "gender", "TEXT    DEFAULT 'male'" )
sqlAddColumn( dbTable, "money", "TEXT     DEFAULT 250" )
sqlAddColumn( dbTable, "moneybank", "TEXT     DEFAULT 500" )
sqlAddColumn( dbTable, "position", "TEXT" )
sqlAddColumn( dbTable, "angle", "TEXT" )
sqlAddColumn( dbTable, "map", "TEXT" )

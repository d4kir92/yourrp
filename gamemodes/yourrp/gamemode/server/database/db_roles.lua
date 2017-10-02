--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

--db_roles.lua

include( "roles/db_net.lua" )
include( "roles/db_func.lua" )

local dbName = "yrp_roles"

sqlAddColumn( dbName, "roleID", "TEXT DEFAULT ''" )
sqlAddColumn( dbName, "description", "TEXT DEFAULT '-'" )
sqlAddColumn( dbName, "playermodels", "TEXT DEFAULT ''" )
sqlAddColumn( dbName, "playermodelsize", "INTEGER DEFAULT 1" )
sqlAddColumn( dbName, "capital", "INTEGER DEFAULT 0" )
sqlAddColumn( dbName, "groupID", "INTEGER DEFAULT 1" )
sqlAddColumn( dbName, "color", "TEXT DEFAULT '0,0,0'" )
sqlAddColumn( dbName, "sweps", "TEXT DEFAULT ''" )
sqlAddColumn( dbName, "voteable", "INTEGER DEFAULT 0" )
sqlAddColumn( dbName, "adminonly", "INTEGER DEFAULT 0" )
sqlAddColumn( dbName, "whitelist", "INTEGER DEFAULT 0" )
sqlAddColumn( dbName, "maxamount", "INTEGER DEFAULT -1" )
sqlAddColumn( dbName, "hp", "INTEGER DEFAULT 100" )
sqlAddColumn( dbName, "hpmax", "INTEGER DEFAULT 100" )
sqlAddColumn( dbName, "hpreg", "INTEGER DEFAULT 0" )
sqlAddColumn( dbName, "ar", "INTEGER DEFAULT 0" )
sqlAddColumn( dbName, "armax", "INTEGER DEFAULT 100" )
sqlAddColumn( dbName, "arreg", "INTEGER DEFAULT 0" )
sqlAddColumn( dbName, "speedwalk", "INTEGER DEFAULT 150" )
sqlAddColumn( dbName, "speedrun", "INTEGER DEFAULT 240" )
sqlAddColumn( dbName, "powerjump", "INTEGER DEFAULT 200" )
sqlAddColumn( dbName, "prerole", "INTEGER DEFAULT -1" )
sqlAddColumn( dbName, "instructor", "INTEGER DEFAULT 0" )
sqlAddColumn( dbName, "removeable", "INTEGER DEFAULT 1" )
sqlAddColumn( dbName, "uses", "INTEGER DEFAULT 0" )

if dbSelect( dbName, "*", "uniqueID = 1" ) == nil then
  printGM( "note", dbName .. " has not the default role" )
  sql.Query( "INSERT INTO " .. dbName .. "( uniqueID, roleID, color, playermodels, removeable ) VALUES ( 1, 'Civilian', '0,0,0', 'models/player/skeleton.mdl', 0 )" )
end

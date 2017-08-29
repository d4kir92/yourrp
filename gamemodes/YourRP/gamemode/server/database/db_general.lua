--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

//db_general.lua

include( "general/db_net.lua" )
include( "general/db_func.lua" )

local dbName = "yrp_general"

sqlAddColumn( dbName, "name", "TEXT DEFAULT ''" )
sqlAddColumn( dbName, "value", "TEXT DEFAULT ''" )

if dbSelect( dbName, "*", "name = 'gamemodename'" ) == nil then
  dbInsertInto( dbName, "name, value", "'gamemodename', 'YourRP'" )
end
if dbSelect( dbName, "*", "name = 'advert'" ) == nil then
  dbInsertInto( dbName, "name, value", "'advert', 'Advert'" )
end
if dbSelect( dbName, "*", "name = 'restart_time'" ) == nil then
  dbInsertInto( dbName, "name, value", "'restart_time', '10'" )
end
if dbSelect( dbName, "*", "name = 'metabolism'" ) == nil then
  dbInsertInto( dbName, "name, value", "'metabolism', '1'" )
end

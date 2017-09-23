--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

--db_restriction.lua

include( "restriction/db_net.lua" )
include( "restriction/db_func.lua" )

local dbName = "yrp_restrictions"

sqlAddColumn( dbName, "usergroup", "TEXT DEFAULT ''" )
sqlAddColumn( dbName, "vehicles", "INT DEFAULT 0" )
sqlAddColumn( dbName, "weapons", "INT DEFAULT 0" )
sqlAddColumn( dbName, "duplicator", "INT DEFAULT 0" )
sqlAddColumn( dbName, "entities", "INT DEFAULT 0" )
sqlAddColumn( dbName, "effects", "INT DEFAULT 0" )
sqlAddColumn( dbName, "npcs", "INT DEFAULT 0" )
sqlAddColumn( dbName, "props", "INT DEFAULT 0" )
sqlAddColumn( dbName, "ragdolls", "INT DEFAULT 0" )

if dbSelect( dbName, "*", "usergroup = 'superadmin'" ) == nil then
  dbInsertInto( dbName, "usergroup, vehicles, weapons, duplicator, entities, effects, npcs, props, ragdolls", "'superadmin', 1, 1, 1, 1, 1, 1, 1, 1" )
end
if dbSelect( dbName, "*", "usergroup = 'admin'" ) == nil then
  dbInsertInto( dbName, "usergroup, vehicles, weapons, duplicator, entities, effects, npcs, props, ragdolls", "'admin', 1, 1, 1, 1, 1, 1, 1, 1" )
end
if dbSelect( dbName, "*", "usergroup = 'user'" ) == nil then
  dbInsertInto( dbName, "usergroup", "'user'" )
end
if dbSelect( dbName, "*", "usergroup = 'player'" ) == nil then
  dbInsertInto( dbName, "usergroup", "'player'" )
end
if dbSelect( dbName, "*", "usergroup = 'operator'" ) == nil then
  dbInsertInto( dbName, "usergroup", "'operator'" )
end

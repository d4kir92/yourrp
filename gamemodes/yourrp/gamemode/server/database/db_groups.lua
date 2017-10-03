--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )


local dbName = "yrp_groups"

sqlAddColumn( dbName, "groupID", "TEXT DEFAULT 'new Group'" )
sqlAddColumn( dbName, "uppergroup", "INTEGER DEFAULT -1" )
sqlAddColumn( dbName, "friendlyfire", "INTEGER DEFAULT 1" )
sqlAddColumn( dbName, "removeable", "INTEGER DEFAULT 1" )
sqlAddColumn( dbName, "color", "TEXT DEFAULT '0,0,0'" )

if dbSelect( dbName, "*", "uniqueID = 1" ) == nil then
  printGM( "note", dbName .. " has not the default group" )
  local result = dbInsertInto( dbName, "uniqueID, groupID, color, uppergroup, friendlyfire, removeable", "1, 'Civilians', '0,0,255', -1, 1, 0" )
  printGM( "note", result )
end

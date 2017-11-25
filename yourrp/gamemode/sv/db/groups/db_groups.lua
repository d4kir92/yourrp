--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )


local _db_name = "yrp_groups"

sql_add_column( _db_name, "groupID", "TEXT DEFAULT 'new Group'" )
sql_add_column( _db_name, "uppergroup", "INTEGER DEFAULT -1" )
sql_add_column( _db_name, "friendlyfire", "INTEGER DEFAULT 1" )
sql_add_column( _db_name, "removeable", "INTEGER DEFAULT 1" )
sql_add_column( _db_name, "color", "TEXT DEFAULT '0,0,0'" )

--db_drop_table( _db_name )
--db_is_empty( _db_name )

if db_select( _db_name, "*", "uniqueID = 1" ) == nil then
  printGM( "note", _db_name .. " has not the default group" )
  local _result = db_insert_into( _db_name, "uniqueID, groupID, color, uppergroup, friendlyfire, removeable", "1, 'Civilians', '0,0,255', -1, 1, 0" )
  printGM( "note", _result )
end

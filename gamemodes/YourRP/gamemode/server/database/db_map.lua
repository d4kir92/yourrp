--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

//db_map.lua

include( "map/db_net.lua" )
include( "map/db_func.lua" )

function dbMapAddValues( dbTable )
  sqlAddColumn( dbTable, "position", "TEXT DEFAULT ''" )
  sqlAddColumn( dbTable, "angle", "TEXT DEFAULT ''" )
  sqlAddColumn( dbTable, "groupID", "INTEGER DEFAULT -1" )
  sqlAddColumn( dbTable, "type", "TEXT DEFAULT ''" )
end

function dbMapInit()
  local dbName = "yrp_" .. string.lower( game.GetMap() )


  printGMPre( "db", yrp.loaddb .. dbName )
  if sql.TableExists( dbName ) then
    printGM( "db", dbName .. " exists" )
  else
    printGM( "note", dbName .. " not exists" )
    local query = ""
    query = query .. "CREATE TABLE yrp_" .. string.lower( game.GetMap() ) .. " ( "
    query = query .. "uniqueID    INTEGER         PRIMARY KEY autoincrement"
    query = query .. " )"
    sql.Query( query )
		if sql.TableExists( dbName ) then
      printGM( "db", dbName .. yrp.successdb )
      dbMapAddValues( dbName )
		else
			printERROR( "CREATE TABLE " .. dbName .. " fail" )
      retryLoadDatabase()
		end
  end
  printGMPos()
end

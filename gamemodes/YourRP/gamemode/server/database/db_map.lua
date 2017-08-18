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
  //sql.Query( "DROP TABLE yrp_" .. string.lower( game.GetMap() ) )

  if sql.TableExists( "yrp_" .. string.lower( game.GetMap() ) ) then
    printGM( "db", "yrp_" .. string.lower( game.GetMap() ) .. " exists" )
  else
    local query = ""
    query = query .. "CREATE TABLE yrp_" .. string.lower( game.GetMap() ) .. " ( "
    query = query .. "uniqueID    INTEGER         PRIMARY KEY autoincrement"
    query = query .. " )"
    sql.Query( query )
		if sql.TableExists( "yrp_" .. string.lower( game.GetMap() ) ) then
      dbMapAddValues( "yrp_" .. string.lower( game.GetMap() ) )
		else
			printError( "CREATE TABLE yrp_" .. string.lower( game.GetMap() ) .. " fail" )
		end
  end
end

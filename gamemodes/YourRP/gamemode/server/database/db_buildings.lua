//Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

//db_map.lua

include( "buildings/db_net.lua" )
include( "buildings/db_func.lua" )

function dbDoorsAddValues( dbTable )
  sqlAddColumn( dbTable, "buildingID", "INTEGER DEFAULT -1" )
  sqlAddColumn( dbTable, "level", "INTEGER DEFAULT 1" )
  sqlAddColumn( dbTable, "keynr", "INTEGER DEFAULT -1" )
end

function dbBuildingsAddValues( dbTable )
  sqlAddColumn( dbTable, "groupID", "INTEGER DEFAULT -1" )
  sqlAddColumn( dbTable, "price", "INTEGER DEFAULT 100" )
  sqlAddColumn( dbTable, "ownerSteamID", "TEXT DEFAULT ''" )
  sqlAddColumn( dbTable, "name", "TEXT DEFAULT 'Building'" )
end

function dbBuildingsInit()
  //sql.Query( "DROP TABLE yrp_" .. string.lower( game.GetMap() ) .. "_doors" )

  if sql.TableExists( "yrp_" .. string.lower( game.GetMap() ) .. "_doors" ) then
    printGM( "db", "yrp_" .. string.lower( game.GetMap() ) .. "_doors exists" )
  else
    printGM( "db", "CREATING yrp_" .. string.lower( game.GetMap() ) .. "_doors" )
    local query = ""
    query = query .. "CREATE TABLE yrp_" .. string.lower( game.GetMap() ) .. "_doors ( "
    query = query .. "uniqueID    INTEGER         PRIMARY KEY autoincrement"
    query = query .. " )"
    sql.Query( query )
		if sql.TableExists( "yrp_" .. string.lower( game.GetMap() ) .. "_doors" ) then
      printGM( "db", "CREATED yrp_" .. string.lower( game.GetMap() ) .. "_doors SUCCESSFULL" )
      dbDoorsAddValues( "yrp_" .. string.lower( game.GetMap() ) .. "_doors" )
		else
			printError( "CREATE TABLE yrp_" .. string.lower( game.GetMap() ) .. "_doors fail" )
		end
  end

  //sql.Query( "DROP TABLE yrp_" .. string.lower( game.GetMap() ) .. "_buildings" )

  if sql.TableExists( "yrp_" .. string.lower( game.GetMap() ) .. "_buildings" ) then
    printGM( "db", "yrp_" .. string.lower( game.GetMap() ) .. "_buildings exists" )
  else
    printGM( "db", "CREATING yrp_" .. string.lower( game.GetMap() ) .. "_buildings" )
    local query = ""
    query = query .. "CREATE TABLE yrp_" .. string.lower( game.GetMap() ) .. "_buildings ( "
    query = query .. "uniqueID    INTEGER         PRIMARY KEY autoincrement"
    query = query .. " )"
    sql.Query( query )
		if sql.TableExists( "yrp_" .. string.lower( game.GetMap() ) .. "_buildings" ) then
      printGM( "db", "CREATED yrp_" .. string.lower( game.GetMap() ) .. "_buildings SUCCESSFULL" )
      dbBuildingsAddValues( "yrp_" .. string.lower( game.GetMap() ) .. "_buildings" )
		else
			printError( "CREATE TABLE yrp_" .. string.lower( game.GetMap() ) .. "_buildings fail" )
		end
  end
end

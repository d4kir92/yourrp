--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

--db_map.lua

include( "buildings/db_net.lua" )
include( "buildings/db_func.lua" )

function dbBuildingsInit()
  local dbName = "yrp_" .. string.lower( game.GetMap() ) .. "_doors"

  printGMPre( "db", yrp.loaddb .. dbName )
  if sql.TableExists( dbName ) then
    printGM( "db", dbName .. " exists" )
  else
    printGM( "note", dbName .. " not exists" )
    local query = ""
    query = query .. "CREATE TABLE " .. dbName .. " ( "
    query = query .. "uniqueID    INTEGER         PRIMARY KEY autoincrement"
    query = query .. " )"
    sql.Query( query )
		if sql.TableExists( dbName ) then
      printGM( "db", dbName .. yrp.successdb )
		else
			printERROR( "CREATE TABLE " .. dbName .. " fail" )
      retryLoadDatabase()
		end
  end
  printGMPos()

  local dbName2 = "yrp_" .. string.lower( game.GetMap() ) .. "_buildings"

  printGMPre( "db", yrp.loaddb .. dbName2 )
  if sql.TableExists( dbName2 ) then
    printGM( "db", dbName2 .. " exists" )
  else
    printGM( "note", dbName2 .. " not exists" )
    local query = ""
    query = query .. "CREATE TABLE " .. dbName2 .. " ( "
    query = query .. "uniqueID    INTEGER         PRIMARY KEY autoincrement"
    query = query .. " )"
    sql.Query( query )
		if sql.TableExists( dbName2 ) then
      printGM( "db", dbName .. yrp.successdb )
		else
			printERROR( "CREATE TABLE " .. dbName2 .. " fail" )
      retryLoadDatabase()
		end
  end
  printGMPos()
end

local dbTable = "yrp_" .. string.lower( game.GetMap() ) .. "_doors"
sqlAddColumn( dbTable, "buildingID", "INTEGER DEFAULT -1" )
sqlAddColumn( dbTable, "level", "INTEGER DEFAULT 1" )
sqlAddColumn( dbTable, "keynr", "INTEGER DEFAULT -1" )

dbTable = "yrp_" .. string.lower( game.GetMap() ) .. "_buildings"
sqlAddColumn( dbTable, "groupID", "INTEGER DEFAULT -1" )
sqlAddColumn( dbTable, "price", "INTEGER DEFAULT 100" )
sqlAddColumn( dbTable, "ownerCharID", "TEXT DEFAULT ''" )
sqlAddColumn( dbTable, "name", "TEXT DEFAULT 'Building'" )

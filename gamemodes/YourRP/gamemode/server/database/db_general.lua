//Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

//db_general.lua

include( "general/db_net.lua")

//##############################################################################
function dbGeneralInit()
  local dbName = "yrp_general"


  printGMPre( "db", yrp.loaddb .. dbName )
  if sql.TableExists( dbName ) then
    printGM( "db", dbName .. " exists" )
  else
    printGM( "note", dbName .. " not exists" )
    local q = "CREATE TABLE "
    q = q .. "yrp_general ( "
    q = q .. "name TEXT, "
    q = q .. "value TEXT"
    q = q .. " )"
    sql.Query( q )
		if sql.TableExists( dbName ) then
			printGM( "db", dbName .. yrp.successdb )
		else
			printERROR( "CREATE TABLE " .. dbName .. " fail" )
      retryLoadDatabase()
		end
  end

  if dbSelect( dbName, "name", "name = 'advert'" ) == nil then
    dbInsertInto( dbName, "name, value", "'advert', 'ADVERT'" )
  end

  if dbSelect( dbName, "name", "name = 'gamemodename'" ) == nil then
    dbInsertInto( dbName, "name, value", "'gamemodename', 'YourRP'" )
  end

  if dbSelect( dbName, "name", "name = 'restart_time'" ) == nil then
    dbInsertInto( dbName, "name, value", "'restart_time', '10'" )
  end

  local _tmpAdvert = sql.Query( "SELECT * FROM " .. dbName .. " WHERE name = 'advert'")
  if _tmpAdvert != nil then
    _advertname = _tmpAdvert[1].value
  end

  printGMPos()
end
//##############################################################################

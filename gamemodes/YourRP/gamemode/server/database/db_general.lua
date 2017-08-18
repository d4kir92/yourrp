//Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )
//db_general.lua

include( "general/db_net.lua")

//##############################################################################
function dbGeneralInit()
  //sql.Query( "DROP TABLE yrp_general")

  if sql.TableExists( "yrp_general" ) then
    printGM( "db", "Load: yrp_general" )
  else
    local q = "CREATE TABLE "
    q = q .. "yrp_general ( "
    q = q .. "name TEXT, "
    q = q .. "value TEXT"
    q = q .. " )"
    sql.Query( q )
		if sql.TableExists( "yrp_general" ) then
			printGM( "db", "Created yrp_general successfully" )
		else
			printError( "CREATE TABLE yrp_general fail" )
		end
  end

  if dbSelect( "yrp_general", "name", "name = 'advert'" ) == nil then
    dbInsertInto( "yrp_general", "name, value", "'advert', 'ADVERT'" )
  end

  if dbSelect( "yrp_general", "name", "name = 'gamemodename'" ) == nil then
    dbInsertInto( "yrp_general", "name, value", "'gamemodename', 'YourRP'" )
  end

  if dbSelect( "yrp_general", "name", "name = 'restart_time'" ) == nil then
    dbInsertInto( "yrp_general", "name, value", "'restart_time', '10'" )
  end

  local _tmpAdvert = sql.Query( "SELECT * FROM yrp_general WHERE name = 'advert'")
  if _tmpAdvert != nil then
    _advertname = _tmpAdvert[1].value
  end
end
//##############################################################################

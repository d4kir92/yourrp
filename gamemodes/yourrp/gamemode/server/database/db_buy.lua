--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

--db_buy.lua

include( "buy/db_net.lua" )
include( "buy/db_func.lua" )

function dbBuyAddValues( dbTable )
  sqlAddColumn( dbTable, "ClassName", "TEXT DEFAULT ''" )
  sqlAddColumn( dbTable, "PrintName", "TEXT DEFAULT ''" )
  sqlAddColumn( dbTable, "WorldModel", "TEXT DEFAULT ''" )
  sqlAddColumn( dbTable, "price", "INTEGER DEFAULT 100" )
  sqlAddColumn( dbTable, "tab", "TEXT DEFAULT ''")
end

function dbBuyInit()
  local dbName = "yrp_buy"

  printGMPre( "db", yrp.loaddb .. dbName )
  if sql.TableExists( dbName ) then
    printGM( "db", dbName .. " exists" )
  else
    printGM( "note", dbName .. " not exists" )
    local query = ""
    query = query .. "CREATE TABLE yrp_buy ( "
    query = query .. "uniqueID    INTEGER         PRIMARY KEY autoincrement"
    query = query .. " )"
    sql.Query( query )
		if sql.TableExists( "yrp_buy" ) then
      printGM( "db", dbName .. yrp.successdb )
      dbBuyAddValues( "yrp_buy" )
		else
			printERROR( "CREATE TABLE yrp_buy fail" )
      retryLoadDatabase()
		end
  end
  printGMPos()
end

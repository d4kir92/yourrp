--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

--db_money.lua

include( "money/db_net.lua" )
include( "money/db_func.lua" )

function dbMoneyAddValues( dbTable )
  sqlAddColumn( dbTable, "name", "TEXT DEFAULT 'NAME'" )
  sqlAddColumn( dbTable, "value", "TEXT DEFAULT '0'" )
end

function dbMoneyInit()
  local dbName = "yrp_money"


  printGMPre( "db", yrp.loaddb .. dbName )
  if sql.TableExists( dbName ) then
    printGM( "db", dbName .. " exists" )
  else
    printGM( "note", dbName .. " not exists" )
    local query = ""
    query = query .. "CREATE TABLE yrp_money ( "
    query = query .. "uniqueID    INTEGER         PRIMARY KEY autoincrement"
    query = query .. " )"
    sql.Query( query )
		if sql.TableExists( "yrp_money" ) then
      printGM( "db", dbName .. yrp.successdb )
      dbMoneyAddValues( "yrp_money" )
		else
			printERROR( "CREATE TABLE yrp_money fail" )
      retryLoadDatabase()
		end
  end

  if dbSelect( "yrp_money", "*", "name = 'moneypre'" ) == nil then
    dbInsertInto( "yrp_money", "name, value", "'moneypre', '$'" )
  end

  if dbSelect( "yrp_money", "*", "name = 'moneypost'" ) == nil then
    dbInsertInto( "yrp_money", "name, value", "'moneypost', ''" )
  end

  if dbSelect( "yrp_money", "*", "name = 'moneystart'" ) == nil then
    dbInsertInto( "yrp_money", "name, value", "'moneystart', '1000'" )
  end

  printGMPos()
end

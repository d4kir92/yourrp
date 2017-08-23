//Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

//db_role_whitelist.lua

include( "whitelist/db_net.lua" )
include( "whitelist/db_func.lua" )

function dbWhitelistAddValues( dbTable )
  sqlAddColumn( dbTable, "steamID", "TEXT DEFAULT ''" )
  sqlAddColumn( dbTable, "nick", "TEXT DEFAULT ''" )
  sqlAddColumn( dbTable, "groupID", "INTEGER DEFAULT -1" )
  sqlAddColumn( dbTable, "roleID", "INTEGER DEFAULT -1" )
end

function dbRoleWhitelistInit()
  local dbName = "yrp_role_whitelist"


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
      dbWhitelistAddValues( dbName )
		else
			printERROR( "CREATE TABLE " .. dbName .. " fail" )
      retryLoadDatabase()
		end
  end
  printGMPos()
end

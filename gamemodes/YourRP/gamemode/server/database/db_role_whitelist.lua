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
  //sql.Query( "DROP TABLE yrp_role_whitelist" )

  if sql.TableExists( "yrp_role_whitelist" ) then
    printGM( "db", "yrp_role_whitelist exists" )
  else
    local query = ""
    query = query .. "CREATE TABLE yrp_role_whitelist ( "
    query = query .. "uniqueID    INTEGER         PRIMARY KEY autoincrement"
    query = query .. " )"
    sql.Query( query )
		if sql.TableExists( "yrp_role_whitelist" ) then
      dbWhitelistAddValues( "yrp_role_whitelist" )
		else
			printError( "CREATE TABLE yrp_role_whitelist fail" )
		end
  end
end

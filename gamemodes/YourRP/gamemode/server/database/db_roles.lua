//Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )
//db_roles.lua

include( "roles/db_net.lua" )
include( "roles/db_func.lua" )

//##############################################################################
function dbRolesAddValues()
  sqlAddColumn( "yrp_roles", "roleID", "TEXT DEFAULT ''" )
  sqlAddColumn( "yrp_roles", "description", "TEXT DEFAULT '-'" )
  sqlAddColumn( "yrp_roles", "playermodel", "TEXT DEFAULT 'models/player/group01/male_01.mdl'" )
  sqlAddColumn( "yrp_roles", "playermodelsize", "INTEGER DEFAULT 1" )
  sqlAddColumn( "yrp_roles", "capital", "INTEGER DEFAULT 0" )
  sqlAddColumn( "yrp_roles", "groupID", "INTEGER DEFAULT 1" )
  sqlAddColumn( "yrp_roles", "color", "TEXT DEFAULT '0,0,0'" )
  sqlAddColumn( "yrp_roles", "sweps", "TEXT DEFAULT ''" )
  sqlAddColumn( "yrp_roles", "adminonly", "INTEGER DEFAULT 0" )
  sqlAddColumn( "yrp_roles", "whitelist", "INTEGER DEFAULT 0" )
  sqlAddColumn( "yrp_roles", "maxamount", "INTEGER DEFAULT -1" )
  sqlAddColumn( "yrp_roles", "hp", "INTEGER DEFAULT 100" )
  sqlAddColumn( "yrp_roles", "hpmax", "INTEGER DEFAULT 100" )
  sqlAddColumn( "yrp_roles", "hpreg", "INTEGER DEFAULT 0" )
  sqlAddColumn( "yrp_roles", "ar", "INTEGER DEFAULT 0" )
  sqlAddColumn( "yrp_roles", "armax", "INTEGER DEFAULT 100" )
  sqlAddColumn( "yrp_roles", "arreg", "INTEGER DEFAULT 0" )
  sqlAddColumn( "yrp_roles", "speedwalk", "INTEGER DEFAULT 150" )
  sqlAddColumn( "yrp_roles", "speedrun", "INTEGER DEFAULT 240" )
  sqlAddColumn( "yrp_roles", "powerjump", "INTEGER DEFAULT 200" )
  sqlAddColumn( "yrp_roles", "prerole", "INTEGER DEFAULT -1" )
  sqlAddColumn( "yrp_roles", "instructor", "INTEGER DEFAULT 0" )
  sqlAddColumn( "yrp_roles", "removeable", "INTEGER DEFAULT 1" )
  sqlAddColumn( "yrp_roles", "uses", "INTEGER DEFAULT 0" )
end

function dbRolesInit()
  //sql.Query( "DROP TABLE yrp_roles")
  //sql.Query( "DROP TABLE yrp_groups")

  if sql.TableExists( "yrp_groups" ) then
    printGM( "db", "yrp_groups exists" )
  else
    local query = "CREATE TABLE "
    query = query .. "yrp_groups ("
    query = query .. "uniqueID        INTEGER         PRIMARY KEY autoincrement"
    query = query .. ", groupID       TEXT            UNIQUE"
    query = query .. ", color         TEXT            DEFAULT '0,0,0'"
    query = query .. ", uppergroup    INTEGER         DEFAULT -1"
    query = query .. ", friendlyfire  INTEGER         DEFAULT 1"
    query = query .. ", removeable    INTEGER         DEFAULT 1"
    query = query .. ", FOREIGN KEY(uppergroup) REFERENCES yrp_groups(uniqueID)"
    query = query .. ")"
    sql.Query( query )
    if sql.TableExists( "yrp_groups" ) then
			printGM( "db", "CREATE TABLE yrp_groups success" )
      sql.Query( "INSERT INTO yrp_groups( uniqueID, groupID, color, uppergroup, friendlyfire, removeable ) VALUES ( 1, 'Civilians', '0,0,255', -1, 1, 0 )" )
		else
			printError( "CREATE TABLE yrp_groups fail" )
		end
  end

  if sql.TableExists( "yrp_roles" ) then
    printGM( "db", "yrp_roles exists" )
  else
    local query = "CREATE TABLE "
    query = query .. "yrp_roles ("
    query = query .. "uniqueID        INTEGER         PRIMARY KEY autoincrement )"
    sql.Query( query )

    dbRolesAddValues()

		if sql.TableExists( "yrp_roles" ) then
			printGM( "db", "CREATE TABLE yrp_roles success" )
      local result = sql.Query( "INSERT INTO yrp_roles( uniqueID, roleID, color, removeable ) VALUES ( 1, 'Civilians', '0,0,0', 0 )" )
		else
			printError( "CREATE TABLE yrp_roles fail" )
		end
  end

  dbRolesAddValues()
end
//##############################################################################

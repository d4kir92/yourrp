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
  local dbName = "yrp_groups"


  printGMPre( "db", yrp.loaddb .. dbName )
  if sql.TableExists( dbName ) then
    printGM( "db", dbName .. " exists" )
  else
    printGM( "note", dbName .. " not exists" )
    local query = "CREATE TABLE "
    query = query .. dbName .. " ("
    query = query .. "uniqueID        INTEGER         PRIMARY KEY autoincrement"
    query = query .. ", groupID       TEXT            UNIQUE"
    query = query .. ", color         TEXT            DEFAULT '0,0,0'"
    query = query .. ", uppergroup    INTEGER         DEFAULT -1"
    query = query .. ", friendlyfire  INTEGER         DEFAULT 1"
    query = query .. ", removeable    INTEGER         DEFAULT 1"
    query = query .. ", FOREIGN KEY(uppergroup) REFERENCES yrp_groups(uniqueID)"
    query = query .. ")"
    sql.Query( query )
    if sql.TableExists( dbName ) then
			printGM( "db", dbName .. yrp.successdb )
      sql.Query( "INSERT INTO " .. dbName .. "( uniqueID, groupID, color, uppergroup, friendlyfire, removeable ) VALUES ( 1, 'Civilians', '0,0,255', -1, 1, 0 )" )
		else
			printERROR( "CREATE TABLE " .. dbName .. " fail" )
      retryLoadDatabase()
		end
  end
  if dbSelect( dbName, "*", "uniqueID = 1" ) == nil then
    printGM( "note", dbName .. " has not the default group" )
    sql.Query( "INSERT INTO " .. dbName .. "( uniqueID, groupID, color, uppergroup, friendlyfire, removeable ) VALUES ( 1, 'Civilians', '0,0,255', -1, 1, 0 )" )
  end
  printGMPos()

  local dbName2 = "yrp_roles"

  printGMPre( "db", yrp.loaddb .. dbName2 )
  if sql.TableExists( dbName2 ) then
    printGM( "db", dbName2 .. " exists" )
  else
    printGM( "note", dbName2 .. " not exists" )
    local query = "CREATE TABLE "
    query = query .. dbName2 .. " ("
    query = query .. "uniqueID        INTEGER         PRIMARY KEY autoincrement )"
    sql.Query( query )

    dbRolesAddValues()

		if sql.TableExists( dbName2 ) then
			printGM( "db", dbName .. yrp.successdb )
      local result = sql.Query( "INSERT INTO " .. dbName2 .. "( uniqueID, roleID, color, removeable ) VALUES ( 1, 'Civilians', '0,0,0', 0 )" )
		else
			printERROR( "CREATE TABLE " .. dbName2 .. " fail" )
      retryLoadDatabase()
		end
  end

  if dbSelect( dbName2, "*", "uniqueID = 1" ) == nil then
    printGM( "note", dbName2 .. " has not the default role" )
    sql.Query( "INSERT INTO " .. dbName2 .. "( uniqueID, roleID, color, removeable ) VALUES ( 1, 'Civilians', '0,0,0', 0 )" )
  end

  dbRolesAddValues()
  printGMPos()
end
//##############################################################################

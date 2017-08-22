//Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

//db_database.lua

//##############################################################################
//utils
util.AddNetworkString( "dbGetGeneral" )
util.AddNetworkString( "dbGetQuestions" )
util.AddNetworkString( "hardresetdatabase")
//##############################################################################

//##############################################################################
yrp_database = {}
yrp_database.version = 1
//##############################################################################

//##############################################################################
function retryLoadDatabase()
  printGMImp( "db", "retry Load Database in 5sec" )
  if timer.Exists( "retryLoadDatabase" ) then
    timer.Remove( "retryLoadDatabase" )
  end
  timer.Create( "retryLoadDatabase", 5, 1, function()
    dbInitDatabase()
    timer.Remove( "retryLoadDatabase" )
  end)
end
//##############################################################################

//##############################################################################
function resetDatabase()
  printGMImp( "db", "reset Database" )
  local _dbs = {}
  table.insert( _dbs, "yrp_general" )
  table.insert( _dbs, "yrp_questions" )
  table.insert( _dbs, "yrp_roles" )
  table.insert( _dbs, "yrp_groups" )
  table.insert( _dbs, "yrp_money" )
  table.insert( _dbs, "yrp_players" )
  table.insert( _dbs, "yrp_" .. string.lower( game.GetMap() ) )
  table.insert( _dbs, "yrp_" .. string.lower( game.GetMap() ) .. "_doors" )
  table.insert( _dbs, "yrp_" .. string.lower( game.GetMap() ) .. "_buildings" )
  table.insert( _dbs, "yrp_role_whitelist" )
  table.insert( _dbs, "yrp_buy" )

  for k, v in pairs( _dbs ) do
    sql.Query( "DROP TABLE " .. v )
  end
  printGMImp( "db", "DONE reset Database" )
end

net.Receive( "hardresetdatabase", function( len, ply )
  if ply:IsSuperAdmin() or ply:IsAdmin() then
    printGMImp( "note", ply:Nick() .. " hard reseted the DATABASE!" )
    printGMImp( "note", ply:Nick() .. " hard reseted the DATABASE!" )
    printGMImp( "note", ply:Nick() .. " hard reseted the DATABASE!" )
    printGMImp( "note", ply:Nick() .. " hard reseted the DATABASE!" )

    PrintMessage( HUD_PRINTCENTER, "Hard RESET by " .. ply:Nick() .. " in 10sec changelevel")

    resetDatabase()

    timer.Simple( 1, function()
      dbInitDatabase()
    end)

    timer.Simple( 5, function()
      PrintMessage( HUD_PRINTCENTER, "Hard RESET by " .. ply:Nick() .. " in 5sec changelevel")
    end)

    timer.Simple( 10, function()
      PrintMessage( HUD_PRINTCENTER, "Hard RESET by " .. ply:Nick())
      game.ConsoleCommand( "changelevel " .. string.lower( game.GetMap() ) .. "\n" )
    end)
  end
end)
//##############################################################################

function dbTableExists( dbTable )
  if sql.TableExists( dbTable ) then
    return true
  else
    printGM( "note", dbTable .. " is not existing.")
    return false
  end
end

function dbSelect( dbTable, dbColumns, dbWhere )
  if dbTableExists( dbTable ) then
    local q = "SELECT "
    q = q .. dbColumns
    q = q .. " FROM "
    q = q .. dbTable
    if dbWhere != nil then
      q = q .. " WHERE "
      q = q .. dbWhere
    end
    local _result = sql.Query( q )
    if _result == nil then
      printGM( "note", dbTable .. ": " .. q .." | NO DATA - can be ignored" )
      return _result
    elseif _result == false then
      printERROR( dbTable .. ": " .. q .. " FALSE" )
      retryLoadDatabase()
      return _result
    else
      return _result
    end
  end
end


function dbInsertIntoDEFAULTVALUES( dbTable )
  if dbTableExists( dbTable ) then
    local q = "INSERT INTO "
    q = q .. dbTable
    q = q .. " DEFAULT VALUES"
    local result = sql.Query( q )
    if result != nil then
      printError( "dbInsertIntoDEFAULTVALUES: " .. q .. " has failed!")
    end
  end
end

function dbInsertInto( dbTable, dbColumns, dbValues )
  if dbTableExists( dbTable ) then
    local q = "INSERT INTO "
    q = q .. dbTable
    q = q .. " ( "
    q = q .. dbColumns
    q = q .. " ) VALUES ( "
    q = q .. dbValues
    q = q .. " )"
    local result = sql.Query( q )
    if result != nil then
      printError( "dbInsertInto: has failed!")
    end
  end
end

function dbDeleteFrom( dbTable, dbWhere )
  if dbTableExists( dbTable ) then
    local q = "DELETE FROM "
    q = q .. dbTable
    if dbWhere != nil then
      q = q .. " WHERE "
      q = q .. dbWhere
    end
    local _result = sql.Query( q )
  end
end

function dbUpdate( dbTable, dbSets, dbWhere )
  if dbTableExists( dbTable ) then
    local q = "UPDATE "
    q = q .. dbTable
    q = q .. " SET "
    q = q .. dbSets
    if dbWhere != nil then
      q = q .. " WHERE "
      q = q .. dbWhere
    end
    local _result = sql.Query( q )
  end
end

function sqlCheckIfColumnExists( tableName, columnName )
  local q = "SELECT " .. columnName .. " FROM " .. tableName .. ""
  local result = sql.Query( q )
  if tostring( result ) == "false" then
    return false
  else
    return true
  end
end

function sqlAddColumn( tableName, columnName, datatype )
  local result = sqlCheckIfColumnExists( tableName, columnName )
  if result == false then
    local q = "ALTER TABLE " .. tableName .. " ADD " .. columnName .. " " .. datatype .. ""
    local _result = sql.Query( q )
  else
    //printGM( "db", columnName .. " vorhanden" )
  end
end

//##############################################################################
//includes
include( "database/db_general.lua" )
include( "database/db_questions.lua" )
include( "database/db_players.lua" )
include( "database/db_roles.lua" )
include( "database/db_map.lua" )
include( "database/db_money.lua" )
include( "database/db_buildings.lua" )
include( "database/db_role_whitelist.lua" )
include( "database/db_buy.lua" )
//##############################################################################

//##############################################################################
function dbInitDatabase()
  printGMImp( "db", "LOAD DATABASES" )

  dbGeneralInit()
  dbQuestionsInit()
  dbRolesInit()
  dbMoneyInit()
  dbMapInit()
  dbBuildingsInit()
  dbRoleWhitelistInit()
  dbBuyInit()

  dbPlayersInit()

  printGMImp( "db", "DONE Loading DATABASES" )
end
dbInitDatabase()
//##############################################################################

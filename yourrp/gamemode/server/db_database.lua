--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

--db_database.lua

--##############################################################################
--utils
util.AddNetworkString( "dbGetGeneral" )
util.AddNetworkString( "dbGetQuestions" )
util.AddNetworkString( "hardresetdatabase")
--##############################################################################

--##############################################################################
yrp_database = {}
yrp_database.version = 1
--##############################################################################

--##############################################################################
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
--##############################################################################

--##############################################################################
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
  table.insert( _dbs, "yrp_restrictions" )
  table.insert( _dbs, "yrp_characters" )

  for k, v in pairs( _dbs ) do
    sql.Query( "DROP TABLE " .. v )
  end
  printGMImp( "db", "DONE reset Database" )
end

net.Receive( "hardresetdatabase", function( len, ply )
  if ply:IsSuperAdmin() then
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
--##############################################################################

--##############################################################################
function dbInitDatabase()
  printGMImp( "db", "LOAD DATABASES" )

  initDatabase( "yrp_general" )
  initDatabase( "yrp_roles" )
  initDatabase( "yrp_groups" )
  initDatabase( "yrp_money" )
  initDatabase( "yrp_" .. string.lower( game.GetMap() ) )
  initDatabase( "yrp_" .. string.lower( game.GetMap() ) .. "_buildings" )
  initDatabase( "yrp_" .. string.lower( game.GetMap() ) .. "_doors" )
  initDatabase( "yrp_role_whitelist" )
  initDatabase( "yrp_buy" )
  initDatabase( "yrp_restrictions" )
  initDatabase( "yrp_jail" )
  initDatabase( "yrp_characters" )
  initDatabase( "yrp_players" )

  initDatabase( "yrp_vehicles" )

  printGMImp( "db", "DONE Loading DATABASES" )
end
dbInitDatabase()
--##############################################################################

--##############################################################################
--includes
include( "database/db_resources.lua" )

include( "database/db_general.lua" )
include( "database/db_questions.lua" )
include( "database/db_players.lua" )
include( "database/db_groups.lua" )
include( "database/db_roles.lua" )
include( "database/db_map.lua" )
include( "database/db_money.lua" )
include( "database/db_buildings.lua" )
include( "database/db_role_whitelist.lua" )
include( "database/db_buy.lua" )
include( "database/db_restriction.lua" )
include( "database/db_characters.lua" )
include( "database/db_vehicles.lua" )

include( "database/db_jail.lua" )
--##############################################################################

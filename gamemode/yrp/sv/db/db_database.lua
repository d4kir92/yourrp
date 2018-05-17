--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

util.AddNetworkString( "dbGetGeneral" )
util.AddNetworkString( "dbGetQuestions" )
util.AddNetworkString( "hardresetdatabase")

local yrp_db = {}
yrp_db.version = 1
yrp_db.loaded = false

function retry_load_database()
  printGM( "db", "retry Load Database in 10sec" )

  if timer.Exists( "retryLoadDatabase" ) then
    timer.Remove( "retryLoadDatabase" )
  end

  timer.Create( "retryLoadDatabase", 10, 1, function()
    db_init_database()
    timer.Remove( "retryLoadDatabase" )
  end)
end

local _db_reseted = false
function reset_database()
  printGM( "db", "reset Database" )

  _db_reseted = true

  local _dbs = {}
  table.insert( _dbs, "yrp_usergroups" )
  table.insert( _dbs, "yrp_general" )
  table.insert( _dbs, "yrp_roles" )
  table.insert( _dbs, "yrp_groups" )
  table.insert( _dbs, "yrp_money" )
  table.insert( _dbs, "yrp_players" )
  table.insert( _dbs, "yrp_" .. GetMapNameDB() )
  table.insert( _dbs, "yrp_" .. GetMapNameDB() .. "_doors" )
  table.insert( _dbs, "yrp_" .. GetMapNameDB() .. "_buildings" )
  table.insert( _dbs, "yrp_role_whitelist" )
  table.insert( _dbs, "yrp_restrictions" )
  table.insert( _dbs, "yrp_characters" )
  table.insert( _dbs, "yrp_vehicles" )
  table.insert( _dbs, "yrp_items" )
  table.insert( _dbs, "yrp_storages" )
  table.insert( _dbs, "yrp_realistic" )
  table.insert( _dbs, "yrp_agents" )
  table.insert( _dbs, "yrp_licenses" )
  table.insert( _dbs, "yrp_shops" )
  table.insert( _dbs, "yrp_shop_items" )
  table.insert( _dbs, "yrp_shop_categories" )
  table.insert( _dbs, "yrp_dealers" )
  table.insert( _dbs, "yrp_interface" )

  for k, v in pairs( _dbs ) do
    db_drop_table( v )
  end
  printGM( "db", "DONE reset Database" )
end
--reset_database()

net.Receive( "hardresetdatabase", function( len, ply )
  if string.lower( ply:GetUserGroup() ) == "superadmin" then
    printGM( "note", "[" .. ply:Nick() .. "] hard reseted the DATABASE!" )
    printGM( "note", "[" .. ply:Nick() .. "] hard reseted the DATABASE!" )
    printGM( "note", "[" .. ply:Nick() .. "] hard reseted the DATABASE!" )
    printGM( "note", "[" .. ply:Nick() .. "] hard reseted the DATABASE!" )

    PrintMessage( HUD_PRINTCENTER, "Hard RESET by [" .. ply:Nick() .. "] in 10sec changelevel" )

    reset_database()

    timer.Simple( 1, function()
      db_init_database()
    end)

    timer.Simple( 5, function()
      PrintMessage( HUD_PRINTCENTER, "Hard RESET by [" .. ply:Nick() .. "] in 5sec changelevel" )
    end)

    timer.Simple( 10, function()
      PrintMessage( HUD_PRINTCENTER, "Hard RESET by [" .. ply:Nick() .. "]" )
      game.ConsoleCommand( "changelevel " .. string.lower( GetMapName() ) .. "\n" )
    end)
  end
end)

function yrp_db_loaded()
  return yrp_db.loaded
end

function db_init_database()
  hr_pre()
  printGM( "db", "LOAD DATABASES" )

  SQL_INIT_DATABASE( "yrp_usergroups" )
  SQL_INIT_DATABASE( "yrp_general" )
  SQL_INIT_DATABASE( "yrp_roles" )
  SQL_INIT_DATABASE( "yrp_groups" )
  SQL_INIT_DATABASE( "yrp_money" )
  SQL_INIT_DATABASE( "yrp_" .. GetMapNameDB() )
  SQL_INIT_DATABASE( "yrp_" .. GetMapNameDB() .. "_buildings" )
  SQL_INIT_DATABASE( "yrp_" .. GetMapNameDB() .. "_doors" )
  SQL_INIT_DATABASE( "yrp_role_whitelist" )
  SQL_INIT_DATABASE( "yrp_restrictions" )
  SQL_INIT_DATABASE( "yrp_jail" )
  SQL_INIT_DATABASE( "yrp_characters" )
  SQL_INIT_DATABASE( "yrp_players" )
  SQL_INIT_DATABASE( "yrp_vehicles" )
  SQL_INIT_DATABASE( "yrp_items" )
  SQL_INIT_DATABASE( "yrp_storages" )
  SQL_INIT_DATABASE( "yrp_realistic" )
  SQL_INIT_DATABASE( "yrp_agents" )
  SQL_INIT_DATABASE( "yrp_licenses" )
  SQL_INIT_DATABASE( "yrp_shops" )
  SQL_INIT_DATABASE( "yrp_shop_items" )
  SQL_INIT_DATABASE( "yrp_shop_categories" )
  SQL_INIT_DATABASE( "yrp_dealers" )
  SQL_INIT_DATABASE( "yrp_feedback" )
  SQL_INIT_DATABASE( "yrp_interface" )

  yrp_db.loaded = true

  printGM( "db", "DONE Loading DATABASES" )
  hr_pos()
end
db_init_database()

include( "resources/db_resources.lua" )

include( "sql/db_sql.lua" )

include( "general/db_general.lua" )
include( "players/db_players.lua" )
include( "characters/db_characters.lua" )
include( "groups/db_groups.lua" )
include( "roles/db_roles.lua" )
include( "map/db_map.lua" )
include( "money/db_money.lua" )
include( "buildings/db_buildings.lua" )
include( "whitelist/db_role_whitelist.lua" )
include( "restriction/db_restriction.lua" )
include( "vehicles/db_vehicles.lua" )
include( "jail/db_jail.lua" )
include( "items/db_give.lua" )
include( "items/db_items.lua" )
include( "items/db_storages.lua" )
include( "realistic/db_realistic.lua" )
include( "agents/db_agents.lua" )
include( "licenses/db_licenses.lua" )
include( "shops/db_shops.lua" )
include( "shops/db_shop_items.lua" )
include( "shops/db_shop_categories.lua" )
include( "dealers/db_dealers.lua" )
include( "feedback/db_feedback.lua" )
include( "interface/db_interface.lua" )

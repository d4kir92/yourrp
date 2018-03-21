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
  table.insert( _dbs, "yrp_general" )
  table.insert( _dbs, "yrp_roles" )
  table.insert( _dbs, "yrp_groups" )
  table.insert( _dbs, "yrp_money" )
  table.insert( _dbs, "yrp_players" )
  table.insert( _dbs, "yrp_" .. db_sql_str2( string.lower( game.GetMap() ) ) )
  table.insert( _dbs, "yrp_" .. db_sql_str2( string.lower( game.GetMap() ) ) .. "_doors" )
  table.insert( _dbs, "yrp_" .. db_sql_str2( string.lower( game.GetMap() ) ) .. "_buildings" )
  table.insert( _dbs, "yrp_role_whitelist" )
  table.insert( _dbs, "yrp_restrictions" )
  table.insert( _dbs, "yrp_characters" )
  table.insert( _dbs, "yrp_vehicles" )
  table.insert( _dbs, "yrp_inventory" )
  table.insert( _dbs, "yrp_item" )
  table.insert( _dbs, "yrp_realistic" )
  table.insert( _dbs, "yrp_agents" )
  table.insert( _dbs, "yrp_licenses" )
  table.insert( _dbs, "yrp_shops" )
  table.insert( _dbs, "yrp_shop_items" )
  table.insert( _dbs, "yrp_shop_categories" )
  table.insert( _dbs, "yrp_dealers" )

  for k, v in pairs( _dbs ) do
    db_drop_table( v )
  end
  printGM( "db", "DONE reset Database" )
end
--reset_database()

net.Receive( "hardresetdatabase", function( len, ply )
  if string.lower( ply:GetUserGroup() ) == "owner" then
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
      game.ConsoleCommand( "changelevel " .. string.lower( game.GetMap() ) .. "\n" )
    end)
  end
end)

function yrp_db_loaded()
  return yrp_db.loaded
end

function db_init_database()
  hr_pre()
  printGM( "db", "LOAD DATABASES" )

  init_database( "yrp_general" )
  init_database( "yrp_roles" )
  init_database( "yrp_groups" )
  init_database( "yrp_money" )
  init_database( "yrp_" .. db_sql_str2( string.lower( game.GetMap() ) ) )
  init_database( "yrp_" .. db_sql_str2( string.lower( game.GetMap() ) ) .. "_buildings" )
  init_database( "yrp_" .. db_sql_str2( string.lower( game.GetMap() ) ) .. "_doors" )
  init_database( "yrp_role_whitelist" )
  init_database( "yrp_restrictions" )
  init_database( "yrp_jail" )
  init_database( "yrp_characters" )
  init_database( "yrp_players" )
  init_database( "yrp_vehicles" )
  init_database( "yrp_item" )
  init_database( "yrp_inventory" )
  init_database( "yrp_realistic" )
  init_database( "yrp_agents" )
  init_database( "yrp_licenses" )
  init_database( "yrp_shops" )
  init_database( "yrp_shop_items" )
  init_database( "yrp_shop_categories" )
  init_database( "yrp_dealers" )

  yrp_db.loaded = true

  printGM( "db", "DONE Loading DATABASES" )
  hr_pos()
end
db_init_database()

include( "resources/db_resources.lua" )

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
include( "items/db_item.lua" )
include( "items/db_give.lua" )
include( "items/db_inventory.lua" )
include( "realistic/db_realistic.lua" )
include( "agents/db_agents.lua" )
include( "licenses/db_licenses.lua" )
include( "shops/db_shops.lua" )
include( "shops/db_shop_items.lua" )
include( "shops/db_shop_categories.lua" )
include( "dealers/db_dealers.lua" )

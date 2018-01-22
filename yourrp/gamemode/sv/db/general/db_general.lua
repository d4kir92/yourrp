--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

-- DO NOT TOUCH THE DATABASE FILES! If you have errors, report them here:
-- https://discord.gg/sEgNZxg

util.AddNetworkString( "db_update_hunger" )
util.AddNetworkString( "db_update_thirst" )
util.AddNetworkString( "db_update_stamina" )
util.AddNetworkString( "db_update_hud" )
util.AddNetworkString( "db_update_inventory" )
util.AddNetworkString( "db_update_clearinventoryondead" )
util.AddNetworkString( "db_update_graffiti" )
util.AddNetworkString( "dbUpdateNWBool2" )
util.AddNetworkString( "db_update_view_distance" )
util.AddNetworkString( "db_update_realistic_damage" )
util.AddNetworkString( "db_update_realistic_falldamage" )

local _db_name = "yrp_general"

sql_add_column( _db_name, "name_gamemode", "TEXT DEFAULT 'YourRP'" )
sql_add_column( _db_name, "name_advert", "TEXT DEFAULT 'Advert'" )
sql_add_column( _db_name, "time_restart", "TEXT DEFAULT '10'" )
sql_add_column( _db_name, "access_jail", "TEXT DEFAULT -1" )

sql_add_column( _db_name, "toggle_metabolism", "INT DEFAULT 1" )
sql_add_column( _db_name, "toggle_building", "INT DEFAULT 1" )
sql_add_column( _db_name, "toggle_hunger", "INT DEFAULT 1" )
sql_add_column( _db_name, "toggle_thirst", "INT DEFAULT 1" )
sql_add_column( _db_name, "toggle_stamina", "INT DEFAULT 1" )
sql_add_column( _db_name, "toggle_hud", "INT DEFAULT 1" )
sql_add_column( _db_name, "toggle_inventory", "INT DEFAULT 1" )
sql_add_column( _db_name, "toggle_clearinventoryondead", "INT DEFAULT 1" )
sql_add_column( _db_name, "toggle_graffiti", "INT DEFAULT 0" )
sql_add_column( _db_name, "view_distance", "INT DEFAULT 200" )
sql_add_column( _db_name, "toggle_realistic_damage", "INT DEFAULT 1" )
sql_add_column( _db_name, "toggle_realistic_falldamage", "INT DEFAULT 1" )

function add_first_entry( retries )
  local _check_general = db_select( _db_name, "*", "uniqueID = 1" )
  if _check_general == nil then
    printGM( "note", "INSERT DEFAULT VALUES for yrp_general")
    db_insert_into_DEFAULTVALUES( _db_name )
  else
    return true
  end
  _check_general = db_select( _db_name, "*", "uniqueID = 1" )
  if _check_general == nil then
    printGM( "error", "add_first_entry failed @yrp_general, retry ( " .. tostring( retries ) .. " )" )
    if retries < 10 then
      timer.Simple( 1, function()
        add_first_entry( retries + 1 )
      end)
    end
  end
end
add_first_entry( 0 )

--db_drop_table( "yrp_general")
--db_is_empty( _db_name )

local _name_advert = ""
function get_advert_name()
  local _tmp = db_select( _db_name, "name_advert", nil )
  if worked( _tmp, "get_advert_name failed" ) then
    _tmp = _tmp[1]
    _name_advert = _tmp.value
  end
end
get_advert_name()

local yrp_general = {}

local _init_general = db_select( _db_name, "*", nil )
if _init_general != false and _init_general != nil then
  yrp_general = _init_general[1]
end

function IsRealisticFallDamage()
  return tobool( yrp_general.toggle_realistic_falldamage )
end

function IsRealisticDamage()
  return tobool( yrp_general.toggle_realistic_damage )
end

net.Receive( "db_update_realistic_damage", function( len, ply )
  local _nw = tonumber( net.ReadInt( 4 ) )
  if isnumber( _nw ) then
    db_update( "yrp_general", "toggle_realistic_damage = " .. _nw, "uniqueID = 1" )
    yrp_general.toggle_realistic_damage = _nw
  end
end)

net.Receive( "db_update_realistic_falldamage", function( len, ply )
  local _nw = tonumber( net.ReadInt( 4 ) )
  if isnumber( _nw ) then
    db_update( "yrp_general", "toggle_realistic_falldamage = " .. _nw, "uniqueID = 1" )
    yrp_general.toggle_realistic_falldamage = _nw
  end
end)

net.Receive( "db_update_graffiti", function( len, ply )
  local _nw_bool = tonumber( net.ReadInt( 4 ) )
  db_update( "yrp_general", "toggle_graffiti = " .. _nw_bool, nil )

  for k, v in pairs( player.GetAll() ) do
    v:SetNWBool( "toggle_graffiti", tobool( _nw_bool ) )
  end
end)

net.Receive( "db_update_clearinventoryondead", function( len, ply )
  local _nw_bool = tonumber( net.ReadInt( 4 ) )
  db_update( "yrp_general", "toggle_clearinventoryondead = " .. _nw_bool, nil )

  for k, v in pairs( player.GetAll() ) do
    v:SetNWBool( "toggle_clearinventoryondead", tobool( _nw_bool ) )
  end
end)

net.Receive( "db_update_inventory", function( len, ply )
  local _nw_bool = tonumber( net.ReadInt( 4 ) )
  db_update( "yrp_general", "toggle_inventory = " .. 0, nil ) -- LATER _nw_bool, nil )

  for k, v in pairs( player.GetAll() ) do
    v:SetNWBool( "toggle_inventory", tobool( false ) ) -- LATER _nw_bool ) )
  end
end)

net.Receive( "db_update_hunger", function( len, ply )
  local _nw_bool = tonumber( net.ReadInt( 4 ) )
  db_update( "yrp_general", "toggle_hunger = " .. _nw_bool, nil )
  printGM( "note", ply:SteamName() .. " SETS " .. _nw_bool )

  for k, v in pairs( player.GetAll() ) do
    v:SetNWBool( "toggle_hunger", tobool( _nw_bool ) )
  end
end)

net.Receive( "db_update_thirst", function( len, ply )
  local _nw_bool = tonumber( net.ReadInt( 4 ) )
  db_update( "yrp_general", "toggle_thirst = " .. _nw_bool, nil )
  printGM( "note", ply:SteamName() .. " SETS " .. _nw_bool )

  for k, v in pairs( player.GetAll() ) do
    v:SetNWBool( "toggle_thirst", tobool( _nw_bool ) )
  end
end)

net.Receive( "db_update_stamina", function( len, ply )
  local _nw_bool = tonumber( net.ReadInt( 4 ) )
  db_update( "yrp_general", "toggle_stamina = " .. _nw_bool, nil )
  printGM( "note", ply:SteamName() .. " SETS " .. _nw_bool )

  for k, v in pairs( player.GetAll() ) do
    v:SetNWBool( "toggle_stamina", tobool( _nw_bool ) )
  end
end)

net.Receive( "db_update_hud", function( len, ply )
  local _nw_bool = tonumber( net.ReadInt( 4 ) )
  db_update( "yrp_general", "toggle_hud = " .. _nw_bool, nil )
  printGM( "note", ply:SteamName() .. " SETS " .. _nw_bool )

  for k, v in pairs( player.GetAll() ) do
    v:SetNWBool( "toggle_hud", tobool( _nw_bool ) )
  end
end)

net.Receive( "dbUpdateNWBool2", function( len, ply )
  local _nw_bool = tonumber( net.ReadInt( 4 ) )
  db_update( "yrp_general", "toggle_building = " .. _nw_bool, nil )
  printGM( "note", ply:SteamName() .. " SETS " .. _nw_bool )

  for k, v in pairs( player.GetAll() ) do
    v:SetNWBool( "toggle_building", tobool( _nw_bool ) )
  end
end)

net.Receive( "db_update_view_distance", function( len, ply )
  local _nw_int = tonumber( net.ReadInt( 16 ) )
  db_update( "yrp_general", "view_distance = " .. _nw_int, nil )
  printGM( "note", ply:SteamName() .. " SETS " .. tostring( _nw_int ) )

  for k, v in pairs( player.GetAll() ) do
    v:SetNWInt( "view_distance", _nw_int )
  end
end)

concommand.Add( "yrp_restart", function( ply, cmd, args )
	if ply:IsPlayer() then
		if ply:IsSuperAdmin() then
	    printGM( "note", "RESTARTING SERVER by " .. ply:Nick() )
      game.ConsoleCommand( "changelevel " .. db_sql_str2( string.lower( game.GetMap() ) ) .. "\n" )
		else
	    printGM( "note", ply:Nick() .. " tried to restart server!" )
	  end
	else
    printGM( "note", "RESTARTING SERVER by [CONSOLE]" )
    game.ConsoleCommand( "changelevel " .. db_sql_str2( string.lower( game.GetMap() ) ) .. "\n" )
  end
end )

util.AddNetworkString( "updateGeneral" )
util.AddNetworkString( "updateAdvert" )

net.Receive( "updateAdvert", function( len, ply )
  _name_advert = net.ReadString()
  db_update( "yrp_general", "name_advert = '" .. _name_advert .. "'", nil )
end)

net.Receive( "getGamemodename", function( len, ply )
  net.Start( "getGamemodename" )
    net.WriteString( GAMEMODE.Name )
  net.Send( ply )
end)

net.Receive( "dbGetGeneral", function( len, ply )
  local _tmp = db_select( "yrp_general", "*", nil )
  if worked( _tmp, "yrp_general failed @1" ) then
    _tmp = _tmp[1]
    net.Start( "dbGetGeneral" )
      net.WriteTable( _tmp )
    net.Send( ply )
  end
end)

net.Receive( "updateGeneral", function( len, ply )
  local _str = net.ReadString()

  local _result = db_update( "yrp_general", "time_restart = '" .. _str .. "'", nil )
end)

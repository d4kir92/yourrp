--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

-- DO NOT TOUCH THE DATABASE FILES! If you have errors, report them here:
-- https://discord.gg/sEgNZxg

util.AddNetworkString( "get_yrp_realistic" )

util.AddNetworkString( "yrp_bonefracturing" )
util.AddNetworkString( "yrp_bleeding" )

util.AddNetworkString( "yrp_headdeadly" )
util.AddNetworkString( "yrp_hithead" )
util.AddNetworkString( "yrp_hitches" )
util.AddNetworkString( "yrp_hitstom" )
util.AddNetworkString( "yrp_hitarms" )
util.AddNetworkString( "yrp_hitlegs" )

util.AddNetworkString( "yrp_headdeadly_npc" )
util.AddNetworkString( "yrp_hithead_npc" )
util.AddNetworkString( "yrp_hitches_npc" )
util.AddNetworkString( "yrp_hitstom_npc" )
util.AddNetworkString( "yrp_hitarms_npc" )
util.AddNetworkString( "yrp_hitlegs_npc" )

local _db_name = "yrp_realistic"

sql_add_column( _db_name, "bonefracturing", "INT DEFAULT 1" )
sql_add_column( _db_name, "bleeding", "INT DEFAULT 1" )

sql_add_column( _db_name, "headshotdeadly_player", "INT DEFAULT 1" )
sql_add_column( _db_name, "hitfactor_player_head", "INT DEFAULT 10" )
sql_add_column( _db_name, "hitfactor_player_ches", "INT DEFAULT 1.5" )
sql_add_column( _db_name, "hitfactor_player_stom", "INT DEFAULT 1" )
sql_add_column( _db_name, "hitfactor_player_arms", "INT DEFAULT 0.6" )
sql_add_column( _db_name, "hitfactor_player_legs", "INT DEFAULT 0.6" )

sql_add_column( _db_name, "headshotdeadly_npc", "INT DEFAULT 1" )
sql_add_column( _db_name, "hitfactor_npc_head", "INT DEFAULT 10" )
sql_add_column( _db_name, "hitfactor_npc_ches", "INT DEFAULT 1.5" )
sql_add_column( _db_name, "hitfactor_npc_stom", "INT DEFAULT 1" )
sql_add_column( _db_name, "hitfactor_npc_arms", "INT DEFAULT 0.6" )
sql_add_column( _db_name, "hitfactor_npc_legs", "INT DEFAULT 0.6" )

--db_drop_table( _db_name )
--db_is_empty( _db_name )

if db_select( _db_name, "*", "uniqueID = 1" ) == nil then
  printGM( "note", _db_name .. " has not the default values, adding them" )
  local _result = db_insert_into_DEFAULTVALUES( _db_name )
  printGM( "note", _result )
end

net.Receive( "get_yrp_realistic", function( len, ply )
  local _tab = db_select( _db_name, "*", nil )
  if _tab != nil then
    _tab = _tab[1]
    printTab( _tab )
    net.Start( "get_yrp_realistic" )
      net.WriteTable( _tab )
    net.Send( ply )
  end
end)

local yrp_realistic = {}

local _init_realistic = db_select( _db_name, "*", nil )
if _init_realistic != false and _init_realistic != nil then
  yrp_realistic = _init_realistic[1]
end

function IsHeadshotDeadlyPlayer()
  return tobool( yrp_realistic.headshotdeadly_player )
end

function GetHitFactorPlayerHead()
  return tonumber( yrp_realistic.hitfactor_player_head )
end

function GetHitFactorPlayerChes()
  return tonumber( yrp_realistic.hitfactor_player_ches )
end

function GetHitFactorPlayerStom()
  return tonumber( yrp_realistic.hitfactor_player_stom )
end

function GetHitFactorPlayerArms()
  return tonumber( yrp_realistic.hitfactor_player_arms )
end

function GetHitFactorPlayerLegs()
  return tonumber( yrp_realistic.hitfactor_player_legs )
end

function IsHeadshotDeadlyNpc()
  return tobool( yrp_realistic.headshotdeadly_npc )
end

function GetHitFactorNpcHead()
  return tonumber( yrp_realistic.hitfactor_npc_head )
end

function GetHitFactorNpcChes()
  return tonumber( yrp_realistic.hitfactor_npc_ches )
end

function GetHitFactorNpcStom()
  return tonumber( yrp_realistic.hitfactor_npc_stom )
end

function GetHitFactorNpcArms()
  return tonumber( yrp_realistic.hitfactor_npc_arms )
end

function GetHitFactorNpcLegs()
  return tonumber( yrp_realistic.hitfactor_npc_legs )
end

net.Receive( "yrp_bonefracturing", function( len, ply )
  local _nw = tonumber( net.ReadInt( 4 ) )
  if isnumber( _nw ) then
    db_update( _db_name, "bonefracturing = " .. _nw, nil )
  end
end)

net.Receive( "yrp_bleeding", function( len, ply )
  local _nw = tonumber( net.ReadInt( 4 ) )
  if isnumber( _nw ) then
    db_update( _db_name, "bleeding = " .. _nw, nil )
  end
end)

--[[ Player ]]--
net.Receive( "yrp_headdeadly", function( len, ply )
  local _nw = tonumber( net.ReadInt( 4 ) )
  if isnumber( _nw ) then
    db_update( _db_name, "headshotdeadly_player = " .. _nw, nil )
  end
end)

net.Receive( "yrp_hithead", function( len, ply )
  local _nw = tonumber( net.ReadFloat() )
  if isnumber( _nw ) then
    db_update( _db_name, "hitfactor_player_head = " .. _nw, nil )
  end
end)

net.Receive( "yrp_hitches", function( len, ply )
  local _nw = tonumber( net.ReadFloat() )
  if isnumber( _nw ) then
    db_update( _db_name, "hitfactor_player_ches = " .. _nw, nil )
  end
end)

net.Receive( "yrp_hitstom", function( len, ply )
  local _nw = tonumber( net.ReadFloat() )
  if isnumber( _nw ) then
    db_update( _db_name, "hitfactor_player_stom = " .. _nw, nil )
  end
end)

net.Receive( "yrp_hitarms", function( len, ply )
  local _nw = tonumber( net.ReadFloat() )
  if isnumber( _nw ) then
    db_update( _db_name, "hitfactor_player_arms = " .. _nw, nil )
  end
end)

net.Receive( "yrp_hitlegs", function( len, ply )
  local _nw = tonumber( net.ReadFloat() )
  if isnumber( _nw ) then
    db_update( _db_name, "hitfactor_player_legs = " .. _nw, nil )
  end
end)

--[[ Npcs ]]--
net.Receive( "yrp_headdeadly_npc", function( len, ply )
  local _nw = tonumber( net.ReadInt( 4 ) )
  if isnumber( _nw ) then
    db_update( _db_name, "headshotdeadly_npc = " .. _nw, nil )
  end
end)

net.Receive( "yrp_hithead_npc", function( len, ply )
  local _nw = tonumber( net.ReadFloat() )
  if isnumber( _nw ) then
    db_update( _db_name, "hitfactor_npc_head = " .. _nw, nil )
  end
end)

net.Receive( "yrp_hitches_npc", function( len, ply )
  local _nw = tonumber( net.ReadFloat() )
  if isnumber( _nw ) then
    db_update( _db_name, "hitfactor_npc_ches = " .. _nw, nil )
  end
end)

net.Receive( "yrp_hitstom_npc", function( len, ply )
  local _nw = tonumber( net.ReadFloat() )
  if isnumber( _nw ) then
    db_update( _db_name, "hitfactor_npc_stom = " .. _nw, nil )
  end
end)

net.Receive( "yrp_hitarms_npc", function( len, ply )
  local _nw = tonumber( net.ReadFloat() )
  if isnumber( _nw ) then
    db_update( _db_name, "hitfactor_npc_arms = " .. _nw, nil )
  end
end)

net.Receive( "yrp_hitlegs_npc", function( len, ply )
  local _nw = tonumber( net.ReadFloat() )
  if isnumber( _nw ) then
    db_update( _db_name, "hitfactor_npc_legs = " .. _nw, nil )
  end
end)

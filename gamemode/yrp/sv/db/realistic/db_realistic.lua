--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

-- DO NOT TOUCH THE DATABASE FILES! If you have errors, report them here:
-- https://discord.gg/sEgNZxg

local DATABASE_NAME = "yrp_realistic"

--db_drop_table( DATABASE_NAME )
--db_is_empty( DATABASE_NAME )

SQL_ADD_COLUMN( DATABASE_NAME, "bool_bonefracturing", "INT DEFAULT 1" )
SQL_ADD_COLUMN( DATABASE_NAME, "bool_bleeding", "INT DEFAULT 1" )

SQL_ADD_COLUMN( DATABASE_NAME, "float_bleedingchance", "INT DEFAULT 20" )

SQL_ADD_COLUMN( DATABASE_NAME, "float_bonechance_legs", "INT DEFAULT 15" )
SQL_ADD_COLUMN( DATABASE_NAME, "float_bonechance_arms", "INT DEFAULT 15" )

SQL_ADD_COLUMN( DATABASE_NAME, "bool_headshotdeadly_player", "INT DEFAULT 1" )
SQL_ADD_COLUMN( DATABASE_NAME, "float_hitfactor_player_head", "INT DEFAULT 10" )
SQL_ADD_COLUMN( DATABASE_NAME, "float_hitfactor_player_ches", "INT DEFAULT 1.5" )
SQL_ADD_COLUMN( DATABASE_NAME, "float_hitfactor_player_stom", "INT DEFAULT 1" )
SQL_ADD_COLUMN( DATABASE_NAME, "float_hitfactor_player_arms", "INT DEFAULT 0.6" )
SQL_ADD_COLUMN( DATABASE_NAME, "float_hitfactor_player_legs", "INT DEFAULT 0.6" )

SQL_ADD_COLUMN( DATABASE_NAME, "bool_headshotdeadly_npc", "INT DEFAULT 1" )
SQL_ADD_COLUMN( DATABASE_NAME, "float_hitfactor_npc_head", "INT DEFAULT 10" )
SQL_ADD_COLUMN( DATABASE_NAME, "float_hitfactor_npc_ches", "INT DEFAULT 1.5" )
SQL_ADD_COLUMN( DATABASE_NAME, "float_hitfactor_npc_stom", "INT DEFAULT 1" )
SQL_ADD_COLUMN( DATABASE_NAME, "float_hitfactor_npc_arms", "INT DEFAULT 0.6" )
SQL_ADD_COLUMN( DATABASE_NAME, "float_hitfactor_npc_legs", "INT DEFAULT 0.6" )

SQL_ADD_COLUMN( DATABASE_NAME, "float_hitfactor_entity", "INT DEFAULT 1" )
SQL_ADD_COLUMN( DATABASE_NAME, "float_hitfactor_vehicle", "INT DEFAULT 1" )

local HANDLER_REALISTIC = {}

function RemFromHandler_Realistic( ply )
	table.RemoveByValue( HANDLER_REALISTIC, ply )
	printGM( "gm", ply:YRPName() .. " disconnected from Realistic" )
end

function AddToHandler_Realistic( ply )
	if !table.HasValue( HANDLER_REALISTIC, ply ) then
		table.insert( HANDLER_REALISTIC, ply )
		printGM( "gm", ply:YRPName() .. " connected to Realistic" )
	else
		printGM( "gm", ply:YRPName() .. " already connected to Realistic" )
	end
end

util.AddNetworkString( "Connect_Settings_Realistic" )
net.Receive( "Connect_Settings_Realistic", function( len, ply )
	if ply:CanAccess( "realistic" ) then
		AddToHandler_Realistic( ply )

		local _yrp_realistic = SQL_SELECT( DATABASE_NAME, "*", nil )
		if wk( _yrp_realistic ) then
			_yrp_realistic = _yrp_realistic[1]
		else
			_yrp_realistic = {}
		end
		net.Start( "Connect_Settings_Realistic" )
			net.WriteTable( _yrp_realistic )
		net.Send( ply )
	end
end)

util.AddNetworkString( "Disconnect_Settings_Realistic" )
net.Receive( "Disconnect_Settings_Realistic", function( len, ply )
	RemFromHandler_Realistic( ply )
end)

if SQL_SELECT( DATABASE_NAME, "*", "uniqueID = 1" ) == nil then
	printGM( "note", DATABASE_NAME .. " has not the default values, adding them" )
	local _result = SQL_INSERT_INTO_DEFAULTVALUES( DATABASE_NAME )
	printGM( "note", _result )
end

local yrp_realistic = {}

local _init_realistic = SQL_SELECT( DATABASE_NAME, "*", nil )
if _init_realistic != false and _init_realistic != nil then
	yrp_realistic = _init_realistic[1]
end

function IsCustomFalldamageEnabled()
	return tobool( yrp_realistic.bool_custom_falldamage )
end

function IsBleedingEnabled()
	return tobool( yrp_realistic.bool_bleeding )
end

function IsBonefracturingEnabled()
	return tobool( yrp_realistic.bool_bonefracturing )
end

function IsHeadshotDeadlyPlayer()
	return tobool( yrp_realistic.bool_headshotdeadly_player )
end

function GetHitFactorPlayerHead()
	return tonumber( yrp_realistic.float_hitfactor_player_head )
end

function GetHitFactorPlayerChes()
	return tonumber( yrp_realistic.float_hitfactor_player_ches )
end

function GetHitFactorPlayerStom()
	return tonumber( yrp_realistic.float_hitfactor_player_stom )
end

function GetHitFactorPlayerArms()
	return tonumber( yrp_realistic.float_hitfactor_player_arms )
end

function GetHitFactorPlayerLegs()
	return tonumber( yrp_realistic.float_hitfactor_player_legs )
end

function IsHeadshotDeadlyNpc()
	return tobool( yrp_realistic.bool_headshotdeadly_npc )
end

function GetHitFactorNpcHead()
	return tonumber( yrp_realistic.float_hitfactor_npc_head )
end

function GetHitFactorNpcChes()
	return tonumber( yrp_realistic.float_hitfactor_npc_ches )
end

function GetHitFactorNpcStom()
	return tonumber( yrp_realistic.float_hitfactor_npc_stom )
end

function GetHitFactorNpcArms()
	return tonumber( yrp_realistic.float_hitfactor_npc_arms )
end

function GetHitFactorNpcLegs()
	return tonumber( yrp_realistic.float_hitfactor_npc_legs )
end

function GetHitFactorEntity()
	return tonumber( yrp_realistic.float_hitfactor_entity )
end

function GetHitFactorVehicle()
	return tonumber( yrp_realistic.float_hitfactor_vehicle )
end

function GetBrokeChanceLegs()
	return tonumber( yrp_realistic.float_bonechance_legs )
end

function GetBrokeChanceArms()
	return tonumber( yrp_realistic.float_bonechance_arms )
end

function GetBleedingChance()
	return tonumber( yrp_realistic.float_bleedingchance )
end

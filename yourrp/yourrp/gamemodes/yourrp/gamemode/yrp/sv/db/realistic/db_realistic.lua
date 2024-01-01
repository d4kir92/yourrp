--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
-- DO NOT TOUCH THE DATABASE FILES! If you have errors, report them here:
-- https://discord.gg/sEgNZxg
local DATABASE_NAME = "yrp_realistic"
--YRP_SQL_DROP_TABLE(DATABASE_NAME)
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_bonefracturing", "INT DEFAULT 1")
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "float_bonechance_legs", "TEXT DEFAULT '15'")
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "float_bonechance_arms", "TEXT DEFAULT '15'")
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_bleeding", "INT DEFAULT 1")
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "float_bleedingchance", "TEXT DEFAULT '20'")
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_slowing", "INT DEFAULT 0")
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "float_slowingfactor", "TEXT DEFAULT '0.4'")
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "float_slowingtime", "TEXT DEFAULT '1'")
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_custom_falldamage", "INT DEFAULT 1")
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_custom_falldamage_percentage", "INT DEFAULT 1")
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "float_custom_falldamage_muliplier", "TEXT DEFAULT '0.125'")
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_headshotdeadly_player", "INT DEFAULT 1")
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "float_hitfactor_player_head", "TEXT DEFAULT '10'")
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "float_hitfactor_player_ches", "TEXT DEFAULT '1.5'")
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "float_hitfactor_player_stom", "TEXT DEFAULT '1'")
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "float_hitfactor_player_arms", "TEXT DEFAULT '0.6'")
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "float_hitfactor_player_legs", "TEXT DEFAULT '0.6'")
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_headshotdeadly_npc", "INT DEFAULT 1")
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "float_hitfactor_npc_head", "TEXT DEFAULT '10'")
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "float_hitfactor_npc_ches", "TEXT DEFAULT '1.5'")
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "float_hitfactor_npc_stom", "TEXT DEFAULT '1'")
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "float_hitfactor_npc_arms", "TEXT DEFAULT '0.6'")
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "float_hitfactor_npc_legs", "TEXT DEFAULT '0.6'")
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "float_hitfactor_entities", "TEXT DEFAULT '1'")
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "float_hitfactor_vehicles", "TEXT DEFAULT '1'")
local HANDLER_REALISTIC = {}
function RemFromHandler_Realistic(ply)
	table.RemoveByValue(HANDLER_REALISTIC, ply)
end

function AddToHandler_Realistic(ply)
	if not table.HasValue(HANDLER_REALISTIC, ply) then
		table.insert(HANDLER_REALISTIC, ply)
	end
end

util.AddNetworkString("nws_yrp_connect_Settings_Realistic")
net.Receive(
	"nws_yrp_connect_Settings_Realistic",
	function(len, ply)
		if ply:CanAccess("bool_realistic") then
			AddToHandler_Realistic(ply)
			local _yrp_realistic = YRP_SQL_SELECT(DATABASE_NAME, "*", nil)
			if IsNotNilAndNotFalse(_yrp_realistic) then
				_yrp_realistic = _yrp_realistic[1]
			else
				_yrp_realistic = {}
			end

			net.Start("nws_yrp_connect_Settings_Realistic")
			net.WriteTable(_yrp_realistic)
			net.Send(ply)
		end
	end
)

util.AddNetworkString("nws_yrp_disconnect_Settings_Realistic")
net.Receive(
	"nws_yrp_disconnect_Settings_Realistic",
	function(len, ply)
		RemFromHandler_Realistic(ply)
	end
)

if YRP_SQL_SELECT(DATABASE_NAME, "*", "uniqueID = 1") == nil then
	YRP.msg("note", DATABASE_NAME .. " has not the default values, adding them")
	local _result = YRP_SQL_INSERT_INTO_DEFAULTVALUES(DATABASE_NAME)
	YRP.msg("note", tostring(_result))
end

local yrp_realistic = {}
local _init_realistic = YRP_SQL_SELECT(DATABASE_NAME, "*", nil)
if _init_realistic ~= false and _init_realistic ~= nil then
	yrp_realistic = _init_realistic[1]
end

function YRPSendToOthers(handler, ply, netstr, str)
	for i, pl in pairs(handler) do
		if ply ~= pl then
			net.Start(netstr)
			net.WriteString(str)
			net.Send(pl)
		end
	end
end

function YRPUpdateValue(handler, db_name, ply, netstr, str, l_db, value)
	l_db[str] = value
	YRP_SQL_UPDATE(
		db_name,
		{
			[str] = l_db[str]
		}, "uniqueID = '1'"
	)

	YRPSendToOthers(handler, ply, netstr, l_db[str])
end

function YRPUpdateBool(handler, db_name, ply, netstr, str, l_db, value)
	YRP.msg("db", ply:YRPName() .. " updated bool " .. str .. " to: " .. tostring(tobool(value)))
	YRPUpdateValue(handler, db_name, ply, netstr, str, l_db, value)
	for i, pl in pairs(player.GetAll()) do
		pl:SetYRPBool(str, tobool(value))
	end
end

function YRPUpdateFloat(handler, db_name, ply, netstr, str, l_db, value)
	YRP.msg("db", ply:YRPName() .. " updated float " .. str .. " to: " .. tostring(value))
	YRPUpdateValue(handler, db_name, ply, netstr, str, l_db, value)
	for i, pl in pairs(player.GetAll()) do
		pl:SetYRPFloat(str, value)
	end
end

for str, val in pairs(yrp_realistic) do
	if string.find(str, "bool_", 1, true) then
		util.AddNetworkString("nws_yrp_update_" .. str)
		net.Receive(
			"nws_yrp_update_" .. str,
			function(len, ply)
				local b = btn(net.ReadBool())
				YRPUpdateBool(HANDLER_REALISTIC, DATABASE_NAME, ply, "nws_yrp_update_" .. str, str, yrp_realistic, b)
			end
		)
	elseif string.find(str, "float_", 1, true) then
		util.AddNetworkString("nws_yrp_update_" .. str)
		net.Receive(
			"nws_yrp_update_" .. str,
			function(len, ply)
				local f = net.ReadFloat()
				YRPUpdateFloat(HANDLER_REALISTIC, DATABASE_NAME, ply, "nws_yrp_update_" .. str, str, yrp_realistic, f)
			end
		)
	end
end

function IsCustomFalldamageEnabled()
	return tobool(yrp_realistic.bool_custom_falldamage)
end

function IsCustomFalldamagePercentageEnabled()
	return tobool(yrp_realistic.bool_custom_falldamage_percentage)
end

function YRPCustomFalldamageMultiplier()
	return yrp_realistic.float_custom_falldamage_muliplier or 0.125
end

function IsSlowingEnabled()
	return tobool(yrp_realistic.bool_slowing)
end

function GetSlowingTime()
	return tonumber(yrp_realistic.float_slowingtime)
end

function GetSlowingFactor()
	return tonumber(yrp_realistic.float_slowingfactor)
end

function IsBleedingEnabled()
	return tobool(yrp_realistic.bool_bleeding)
end

function IsBonefracturingEnabled()
	return tobool(yrp_realistic.bool_bonefracturing)
end

function IsHeadshotDeadlyPlayer()
	return tobool(yrp_realistic.bool_headshotdeadly_player)
end

function GetHitFactorPlayerHead()
	return tonumber(yrp_realistic.float_hitfactor_player_head)
end

function GetHitFactorPlayerChes()
	return tonumber(yrp_realistic.float_hitfactor_player_ches)
end

function GetHitFactorPlayerStom()
	return tonumber(yrp_realistic.float_hitfactor_player_stom)
end

function GetHitFactorPlayerArms()
	return tonumber(yrp_realistic.float_hitfactor_player_arms)
end

function GetHitFactorPlayerLegs()
	return tonumber(yrp_realistic.float_hitfactor_player_legs)
end

function IsHeadshotDeadlyNpc()
	return tobool(yrp_realistic.bool_headshotdeadly_npc)
end

function GetHitFactorNpcHead()
	return tonumber(yrp_realistic.float_hitfactor_npc_head)
end

function GetHitFactorNpcChes()
	return tonumber(yrp_realistic.float_hitfactor_npc_ches)
end

function GetHitFactorNpcStom()
	return tonumber(yrp_realistic.float_hitfactor_npc_stom)
end

function GetHitFactorNpcArms()
	return tonumber(yrp_realistic.float_hitfactor_npc_arms)
end

function GetHitFactorNpcLegs()
	return tonumber(yrp_realistic.float_hitfactor_npc_legs)
end

function GetHitFactorEntities()
	return tonumber(yrp_realistic.float_hitfactor_entities)
end

function GetHitFactorVehicles()
	return tonumber(yrp_realistic.float_hitfactor_vehicles)
end

function GetBrokeChanceLegs()
	return tonumber(yrp_realistic.float_bonechance_legs)
end

function GetBrokeChanceArms()
	return tonumber(yrp_realistic.float_bonechance_arms)
end

function GetBleedingChance()
	return tonumber(yrp_realistic.float_bleedingchance)
end
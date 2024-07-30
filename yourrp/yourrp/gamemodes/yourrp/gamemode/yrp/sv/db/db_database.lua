--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
YRP:AddNetworkString("nws_yrp_dbGetGeneral")
YRP:AddNetworkString("nws_yrp_dbGetQuestions")
YRP:AddNetworkString("nws_yrp_hardresetdatabase")
local yrp_db = {}
yrp_db.version = 1
yrp_db.loaded = false
local YRP_DBS = {}
table.insert(YRP_DBS, "yrp_usergroups")
table.insert(YRP_DBS, "yrp_general")
table.insert(YRP_DBS, "yrp_ply_groups")
table.insert(YRP_DBS, "yrp_ply_roles")
table.insert(YRP_DBS, "yrp_realistic")
table.insert(YRP_DBS, "yrp_feedback")
table.insert(YRP_DBS, "yrp_sql")
table.insert(YRP_DBS, "yrp_flags")
table.insert(YRP_DBS, "yrp_playermodels")
table.insert(YRP_DBS, "yrp_design")
table.insert(YRP_DBS, "yrp_levelsystem")
table.insert(YRP_DBS, "yrp_hud")
table.insert(YRP_DBS, "yrp_laws")
table.insert(YRP_DBS, "yrp_lockdown")
table.insert(YRP_DBS, "yrp_logs")
table.insert(YRP_DBS, "yrp_logs_settings")
table.insert(YRP_DBS, "yrp_keybinds")
table.insert(YRP_DBS, "yrp_profiles_hud")
table.insert(YRP_DBS, "yrp_idcard")
table.insert(YRP_DBS, "yrp_players")
table.insert(YRP_DBS, "yrp_events")
table.insert(YRP_DBS, "yrp_" .. GetMapNameDB())
table.insert(YRP_DBS, "yrp_" .. GetMapNameDB() .. "_doors")
table.insert(YRP_DBS, "yrp_" .. GetMapNameDB() .. "_buildings")
table.insert(YRP_DBS, "yrp_role_whitelist")
table.insert(YRP_DBS, "yrp_blacklist")
table.insert(YRP_DBS, "yrp_characters")
table.insert(YRP_DBS, "yrp_vehicles")
table.insert(YRP_DBS, "yrp_agents")
table.insert(YRP_DBS, "yrp_licenses")
table.insert(YRP_DBS, "yrp_specializations")
table.insert(YRP_DBS, "yrp_shops")
table.insert(YRP_DBS, "yrp_shop_items")
table.insert(YRP_DBS, "yrp_shop_categories")
table.insert(YRP_DBS, "yrp_dealers")
table.insert(YRP_DBS, "yrp_jail")
table.insert(YRP_DBS, "yrp_jail_notes")
table.insert(YRP_DBS, "yrp_interface")
table.insert(YRP_DBS, "yrp_darkrp")
table.insert(YRP_DBS, "yrp_inventory_storages")
table.insert(YRP_DBS, "yrp_inventory_slots")
table.insert(YRP_DBS, "yrp_inventory_items")
table.insert(YRP_DBS, "yrp_macros")
table.insert(YRP_DBS, "yrp_voice_channels")
table.insert(YRP_DBS, "yrp_chat_channels")
table.insert(YRP_DBS, "yrp_weapon_options")
table.insert(YRP_DBS, "yrp_weapon_slots")
function GetDBNames()
	return YRP_DBS
end

local _db_reseted = false
function reset_database()
	YRP:msg("db", "reset Database")
	_db_reseted = true
	for k, v in pairs(YRP_DBS) do
		YRP_SQL_DROP_TABLE(v)
	end

	YRP:msg("db", "DONE reset Database")
end

--reset_database()
net.Receive(
	"nws_yrp_hardresetdatabase",
	function(len, ply)
		if string.lower(ply:GetUserGroup()) == "superadmin" then
			YRP:msg("note", "[" .. ply:Nick() .. "] hard reseted the DATABASE!")
			YRP:msg("note", "[" .. ply:Nick() .. "] hard reseted the DATABASE!")
			YRP:msg("note", "[" .. ply:Nick() .. "] hard reseted the DATABASE!")
			YRP:msg("note", "[" .. ply:Nick() .. "] hard reseted the DATABASE!")
			PrintMessage(HUD_PRINTCENTER, "Hard RESET by [" .. ply:Nick() .. "] in 10sec changelevel")
			reset_database()
			timer.Simple(
				1,
				function()
					db_init_database()
				end
			)

			timer.Simple(
				5,
				function()
					PrintMessage(HUD_PRINTCENTER, "Hard RESET by [" .. ply:Nick() .. "] in 5sec changelevel")
				end
			)

			timer.Simple(
				10,
				function()
					PrintMessage(HUD_PRINTCENTER, "Hard RESET by [" .. ply:Nick() .. "]")
					game.ConsoleCommand("changelevel " .. string.lower(GetMapName()) .. "\n")
				end
			)
		end
	end
)

function yrp_db_loaded()
	return yrp_db.loaded
end

function db_init_database()
	if YRP_SQL_INIT_DATABASE then
		YRP:msg("db", "LOAD DATABASES")
		for i, db in pairs(YRP_DBS) do
			YRP_SQL_INIT_DATABASE(db)
		end

		yrp_db.loaded = true
		YRP:msg("db", "DONE Loading DATABASES")
	else
		YRP:msg("db", "RETRY LOAD DATABASES")
		timer.Simple(0.01, db_init_database)
	end
end

db_init_database()
include("resources/db_resources.lua")
include("sql/db_sql.lua")
include("database/db_database.lua")
include("general/db_general.lua") -- First Database
include("status/db_status.lua")
include("yourrp_addons/db_yourrp_addons.lua")
include("usergroups/db_usergroups.lua")
include("flags/db_flags.lua")
include("playermodels/db_playermodels.lua")
include("levelsystem/db_levelsystem.lua")
include("design/db_design.lua")
include("hud/db_hud.lua")
include("laws/db_laws.lua")
include("lockdown/db_lockdown.lua")
include("logs/db_logs.lua")
include("logs_settings/db_logs_settings.lua")
include("keybinds/db_keybinds.lua")
include("profiles_hud/db_profiles_hud.lua")
include("idcard/db_idcard.lua")
include("players/db_players.lua")
include("events/db_events.lua")
include("characters/db_characters.lua")
include("groups/db_groups.lua")
include("roles/db_roles.lua")
include("map/db_map.lua")
include("buildings/db_buildings.lua")
include("whitelist/db_role_whitelist.lua")
include("blacklist/db_blacklist.lua")
include("vehicles/db_vehicles.lua")
include("jail/db_jail.lua")
include("realistic/db_realistic.lua")
include("agents/db_agents.lua")
include("licenses/db_licenses.lua")
include("shops/db_shops.lua")
include("shops/db_shop_items.lua")
include("shops/db_shop_categories.lua")
include("dealers/db_dealers.lua")
include("feedback/db_feedback.lua")
include("interface/db_interface.lua")
include("inventory/db_inventory_player.lua")
include("inventory/db_inventory_storages.lua")
include("inventory/db_inventory_slots.lua")
include("inventory/db_inventory_items.lua")
include("macros/db_macros.lua")
include("chatchannels/db_chatchannels.lua")
include("weapon/db_weapon.lua")
include("specializations/db_specializations.lua")
-- DarkRP
local DATABASE_NAME = "yrp_darkrp"
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "name", "TEXT DEFAULT ''")
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "value", "TEXT DEFAULT ''")
YRP:AddNetworkString("nws_yrp_darkrp_bool")
net.Receive(
	"nws_yrp_darkrp_bool",
	function(len, ply)
		local name = net.ReadString()
		local b = net.ReadBool()
		if not IsNotNilAndNotFalse(YRP_SQL_SELECT(DATABASE_NAME, "*", "name = '" .. "bool_" .. name .. "'")) then
			YRP_SQL_INSERT_INTO(DATABASE_NAME, "name, value", "" .. YRP_SQL_STR_IN("bool_" .. name) .. ", '" .. tonum(b) .. "'")
		else
			YRP_SQL_UPDATE(
				DATABASE_NAME,
				{
					["value"] = tonum(b)
				}, "name = '" .. "bool_" .. name .. "'"
			)
		end

		UpdateDarkRPTable()
	end
)

YRP:AddNetworkString("nws_yrp_update_yrp_darkrp")
function UpdateDarkRPTable(ply)
	local tab = YRP_SQL_SELECT(DATABASE_NAME, "*", nil)
	if IsNotNilAndNotFalse(tab) then
		local yrp_darkrp = {}
		for i, v in pairs(tab) do
			local name = v.name
			local value = v.value
			if string.StartWith(name, "bool_") then
				yrp_darkrp[name] = tobool(value)
			else
				YRP:msg("db", name .. ": " .. value)
			end
		end

		SetDarkRPTab(yrp_darkrp)
		UpdateDarkRP(DarkRP)
		if ply == nil then
			net.Start("nws_yrp_update_yrp_darkrp")
			net.WriteTable(yrp_darkrp)
			net.Broadcast()
		else
			net.Start("nws_yrp_update_yrp_darkrp")
			net.WriteTable(yrp_darkrp)
			net.Send(ply)
		end
	end
end

timer.Simple(
	4,
	function()
		UpdateDarkRPTable()
	end
)

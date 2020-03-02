--Copyright (C) 2017-2019 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

util.AddNetworkString("dbGetGeneral")
util.AddNetworkString("dbGetQuestions")
util.AddNetworkString("hardresetdatabase")

local yrp_db = {}
yrp_db.version = 1
yrp_db.loaded = false

function retry_load_database()
	printGM("db", "ERROR!!! >> retry Load Database in 10sec <<")
	printGM("db", "ERROR!!! >> Your database is maybe broken! <<")

	if timer.Exists("retryLoadDatabase") then
		timer.Remove("retryLoadDatabase")
	end

	local integrity_check = sql.Query("pragma integrity_check;")
	printGM("db", "Integrity_check: " .. tostring(integrity_check))

	local nodes = sql.Query("reindex nodes;")
	printGM("db", "Nodes: " .. tostring(nodes))

	local pristine = sql.Query("reindex pristine;")
	printGM("db", "Pristine: " .. tostring(pristine))

	timer.Create("retryLoadDatabase", 10, 1, function()
		db_init_database()
		timer.Remove("retryLoadDatabase")
	end)
end

local _dbs = {}
table.insert(_dbs, "yrp_usergroups")
table.insert(_dbs, "yrp_general")
table.insert(_dbs, "yrp_ply_groups")
table.insert(_dbs, "yrp_ply_roles")
table.insert(_dbs, "yrp_realistic")
table.insert(_dbs, "yrp_feedback")
table.insert(_dbs, "yrp_sql")
table.insert(_dbs, "yrp_flags")
table.insert(_dbs, "yrp_playermodels")
table.insert(_dbs, "yrp_design")
table.insert(_dbs, "yrp_levelsystem")
table.insert(_dbs, "yrp_hud")
table.insert(_dbs, "yrp_laws")
table.insert(_dbs, "yrp_lockdown")
table.insert(_dbs, "yrp_logs")
table.insert(_dbs, "yrp_i_storages")
table.insert(_dbs, "yrp_i_items")
table.insert(_dbs, "yrp_keybinds")
table.insert(_dbs, "yrp_profiles_hud")
table.insert(_dbs, "yrp_idcard")

table.insert(_dbs, "yrp_players")
table.insert(_dbs, "yrp_" .. GetMapNameDB())
table.insert(_dbs, "yrp_" .. GetMapNameDB() .. "_doors")
table.insert(_dbs, "yrp_" .. GetMapNameDB() .. "_buildings")
table.insert(_dbs, "yrp_role_whitelist")
table.insert(_dbs, "yrp_characters")
table.insert(_dbs, "yrp_vehicles")
table.insert(_dbs, "yrp_agents")
table.insert(_dbs, "yrp_licenses")
table.insert(_dbs, "yrp_shops")
table.insert(_dbs, "yrp_shop_items")
table.insert(_dbs, "yrp_shop_categories")
table.insert(_dbs, "yrp_dealers")
table.insert(_dbs, "yrp_jail")
table.insert(_dbs, "yrp_jail_notes")
table.insert(_dbs, "yrp_interface")

function GetDBNames()
	return _dbs
end

local _db_reseted = false
function reset_database()
	printGM("db", "reset Database")

	_db_reseted = true

	for k, v in pairs(_dbs) do
		db_drop_table(v)
	end
	printGM("db", "DONE reset Database")
end
--reset_database()

net.Receive("hardresetdatabase", function(len, ply)
	if string.lower(ply:GetUserGroup()) == "superadmin" then
		printGM("note", "[" .. ply:Nick() .. "] hard reseted the DATABASE!")
		printGM("note", "[" .. ply:Nick() .. "] hard reseted the DATABASE!")
		printGM("note", "[" .. ply:Nick() .. "] hard reseted the DATABASE!")
		printGM("note", "[" .. ply:Nick() .. "] hard reseted the DATABASE!")

		PrintMessage(HUD_PRINTCENTER, "Hard RESET by [" .. ply:Nick() .. "] in 10sec changelevel")

		reset_database()

		timer.Simple(1, function()
			db_init_database()
		end)

		timer.Simple(5, function()
			PrintMessage(HUD_PRINTCENTER, "Hard RESET by [" .. ply:Nick() .. "] in 5sec changelevel")
		end)

		timer.Simple(10, function()
			PrintMessage(HUD_PRINTCENTER, "Hard RESET by [" .. ply:Nick() .. "]")
			game.ConsoleCommand("changelevel " .. string.lower(GetMapName()) .. "\n")
		end)
	end
end)

function yrp_db_loaded()
	return yrp_db.loaded
end

function db_init_database()
	hr_pre("db")
	printGM("db", "LOAD DATABASES")

	for i, db in pairs(_dbs) do
		SQL_INIT_DATABASE(db)
	end

	yrp_db.loaded = true

	printGM("db", "DONE Loading DATABASES")
	hr_pos("db")
end
db_init_database()

include("resources/db_resources.lua")

include("sql/db_sql.lua")

include("database/db_database.lua")

include("console/db_console.lua")
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

include("inventory/db_storages.lua")

include("inventory/db_i_storages.lua")
include("inventory/db_i_items.lua")

include("keybinds/db_keybinds.lua")

include("profiles_hud/db_profiles_hud.lua")

include("idcard/db_idcard.lua")

include("general/db_general.lua")
include("players/db_players.lua")
include("characters/db_characters.lua")
include("groups/db_groups.lua")
include("roles/db_roles.lua")
include("map/db_map.lua")
include("buildings/db_buildings.lua")
include("whitelist/db_role_whitelist.lua")
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

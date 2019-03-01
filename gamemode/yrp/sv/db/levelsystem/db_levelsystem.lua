--Copyright (C) 2017-2019 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

-- DO NOT TOUCH THE DATABASE FILES! If you have errors, report them here:
-- https://discord.gg/sEgNZxg

local DATABASE_NAME = "yrp_levelsystem"

SQL_ADD_COLUMN(DATABASE_NAME, "int_level_min", "INT DEFAULT 0")
SQL_ADD_COLUMN(DATABASE_NAME, "int_level_max", "INT DEFAULT 100")
SQL_ADD_COLUMN(DATABASE_NAME, "int_level_start", "INT DEFAULT 1")
SQL_ADD_COLUMN(DATABASE_NAME, "int_xp_for_levelup", "INT DEFAULT 100")
SQL_ADD_COLUMN(DATABASE_NAME, "float_multiplier", "INT DEFAULT 1.5")

SQL_ADD_COLUMN(DATABASE_NAME, "int_xp_per_kill", "INT DEFAULT 20")
SQL_ADD_COLUMN(DATABASE_NAME, "int_xp_per_minute", "INT DEFAULT 10")
SQL_ADD_COLUMN(DATABASE_NAME, "int_xp_per_revive", "INT DEFAULT 30")

if SQL_SELECT(DATABASE_NAME, "*", "uniqueID = 1") == nil then
	SQL_INSERT_INTO(DATABASE_NAME, "uniqueID", "'1'")
end

--[[ LOADOUT ]]--
local Player = FindMetaTable("Player")
function Player:LevelSystemLoadout()

end

util.AddNetworkString("get_levelsystem_settings")
net.Receive("get_levelsystem_settings", function(len, ply)
	if ply:CanAccess("bool_levelsystem") then

		local setting = SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '1'")
		if wk(setting) then
			setting = setting[1]
			net.Start("get_levelsystem_settings")
				net.WriteTable(setting)
			net.Send(ply)
		end
	end
end)

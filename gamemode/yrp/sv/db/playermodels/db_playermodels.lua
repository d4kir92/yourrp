--Copyright (C) 2017-2019 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

-- DO NOT TOUCH THE DATABASE FILES! If you have errors, report them here:
-- https://discord.gg/sEgNZxg

local DATABASE_NAME = "yrp_playermodels"

--SQL_DROP_TABLE(DATABASE_NAME)

SQL_ADD_COLUMN(DATABASE_NAME, "string_name", "TEXT DEFAULT ''")
SQL_ADD_COLUMN(DATABASE_NAME, "string_models", "TEXT DEFAULT ''")
SQL_ADD_COLUMN(DATABASE_NAME, "float_size_min", "INT DEFAULT '1'")
SQL_ADD_COLUMN(DATABASE_NAME, "float_size_max", "INT DEFAULT '1'")

local pms = SQL_SELECT(DATABASE_NAME, "*", nil)
if wk(pms) then
	for i, pm in pairs(pms) do
		if pm.string_model != nil then
			if pm.string_model != "" then
				if pm.string_models == "" then
					SQL_UPDATE(DATABASE_NAME, "string_models = '" .. pm.string_model .. "'", "uniqueID = '" .. pm.uniqueID .. "'")
				end
			end
		end
	end
end

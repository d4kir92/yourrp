--Copyright (C) 2017-2019 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

-- DO NOT TOUCH THE DATABASE FILES! If you have errors, report them here:
-- https://discord.gg/sEgNZxg

local DATABASE_NAME = "yrp_playermodels"

--SQL_DROP_TABLE(DATABASE_NAME)

SQL_ADD_COLUMN(DATABASE_NAME, "string_name", "TEXT DEFAULT ''")
SQL_ADD_COLUMN(DATABASE_NAME, "string_model", "TEXT DEFAULT ''")

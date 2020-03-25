--Copyright (C) 2017-2020 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

-- DO NOT TOUCH THE DATABASE FILES! If you have errors, report them here:
-- https://discord.gg/sEgNZxg

-- #BLACKLIST

local DATABASE_NAME = "yrp_blacklist"

SQL_ADD_COLUMN(DATABASE_NAME, "name", "TEXT DEFAULT ''")
SQL_ADD_COLUMN(DATABASE_NAME, "value", "TEXT DEFAULT ''")

--db_drop_table(DATABASE_NAME)
--db_is_empty(DATABASE_NAME)

--Copyright (C) 2017-2020 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

local DATABASE_NAME = "yrp_i_items"

SQL = SQL or {}

--SQL_DROP_TABLE(DATABASE_NAME)

SQL.ADD_COLUMN(DATABASE_NAME, "text_printname", "TEXT DEFAULT 'Unnamed'")
SQL.ADD_COLUMN(DATABASE_NAME, "text_classname", "TEXT DEFAULT 'yrp_money_printer'")
SQL.ADD_COLUMN(DATABASE_NAME, "text_worldmodel", "TEXT DEFAULT 'models/hunter/blocks/cube025x025x025.mdl'")

SQL.ADD_COLUMN(DATABASE_NAME, "int_storage", "INT DEFAULT '0'")		-- 0 World | > 0 Storage
SQL.ADD_COLUMN(DATABASE_NAME, "int_position", "INT DEFAULT '1'")		-- 0 World | > 0 Storage

SQL.ADD_COLUMN(DATABASE_NAME, "tab_properties", "TEXT DEFAULT ''")

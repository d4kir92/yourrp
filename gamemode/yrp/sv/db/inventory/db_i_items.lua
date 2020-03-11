--Copyright (C) 2017-2020 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

local DATABASE_NAME = "yrp_i_items"

SQL = SQL or {}

--SQL_DROP_TABLE(DATABASE_NAME)

SQL.ADD_COLUMN(DATABASE_NAME, "text_printname", "TEXT DEFAULT 'Unnamed'")
SQL.ADD_COLUMN(DATABASE_NAME, "text_classname", "TEXT DEFAULT 'yrp_money_printer'")
SQL.ADD_COLUMN(DATABASE_NAME, "text_worldmodel", "TEXT DEFAULT 'models/hunter/blocks/cube025x025x025.mdl'")

SQL.ADD_COLUMN(DATABASE_NAME, "text_in_storage", "INT DEFAULT '0'")		-- 0 No Storage | > 0 Storage
SQL.ADD_COLUMN(DATABASE_NAME, "text_has_storage", "INT DEFAULT '0'")
SQL.ADD_COLUMN(DATABASE_NAME, "int_position", "INT DEFAULT '1'")

SQL.ADD_COLUMN(DATABASE_NAME, "tab_properties", "TEXT DEFAULT ''")

function LoadSlotItems(suid)
	local stortab = {}
	stortab.table = DATABASE_NAME
	stortab.cols = {}
	stortab.cols[1] = "*"
	stortab.where = "text_in_storage = '" .. suid .. "'"
	local stor = SQL.SELECT(stortab)
	return stor or {}
end

function CreateBag(bname, storageuid)
	local stortab = {}
	stortab.int_size = 16
	local stor = CreateStorage(stortab)

	local instab = {}
	instab.table = DATABASE_NAME
	instab.cols = {}
	instab.cols["text_in_storage"] = storageuid
	instab.cols["text_classname"] = "yrp_mainbag"
	instab.cols["text_printname"] = "MainBag"
	instab.cols["text_worldmodel"] = "models/props_junk/cardboard_box003a.mdl"
	instab.cols["text_has_storage"] = stor.uniqueID

	SQL.INSERT_INTO(instab)
end

function LoadStorageItems(suid)
	local stortab = {}
	stortab.table = DATABASE_NAME
	stortab.cols = {}
	stortab.cols[1] = "*"
	stortab.where = "text_in_storage = '" .. suid .. "'"
	local stor = SQL.SELECT(stortab)
	return stor or {}
end

--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
-- DO NOT TOUCH THE DATABASE FILES! If you have errors, report them here:
-- https://discord.gg/sEgNZxg
local DATABASE_NAME = "yrp_flags"
--YRP_SQL_DROP_TABLE(DATABASE_NAME)
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "string_name", "TEXT DEFAULT 'iscp'")
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "string_type", "TEXT DEFAULT 'role'")
if YRP_SQL_SELECT(DATABASE_NAME, "*", "uniqueID = 1") == nil then
	YRP_SQL_INSERT_INTO(DATABASE_NAME, "string_name, string_type", "'iscp', 'role'")
end

function AddCustomFlag(name, typ)
	if name ~= nil and typ ~= nil then
		local _found = YRP_SQL_SELECT(DATABASE_NAME, "*", "string_name = '" .. name .. "' AND string_type = '" .. typ .. "'")
		if not _found then
			YRP_SQL_INSERT_INTO(DATABASE_NAME, "string_name, string_type", "'" .. name .. "', '" .. typ .. "'")
			YRP.msg("note", "Custom Flag " .. name .. " ( " .. typ .. " ) added.")
		end
	end
end

AddCustomFlag("iscp", "role")
AddCustomFlag("ismayor", "role")
AddCustomFlag("ismedic", "role")
AddCustomFlag("iscook", "role")
AddCustomFlag("ishobo", "role")
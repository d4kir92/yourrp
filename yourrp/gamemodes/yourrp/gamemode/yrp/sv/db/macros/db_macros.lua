--Copyright (C) 2017-2021 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

-- DO NOT TOUCH THE DATABASE FILES! If you have errors, report them here:
-- https://discord.gg/sEgNZxg

local DATABASE_NAME = "yrp_macros"

SQL_ADD_COLUMN(DATABASE_NAME, "name", "TEXT DEFAULT ''")
SQL_ADD_COLUMN(DATABASE_NAME, "value", "TEXT DEFAULT ''")

--db_drop_table(DATABASE_NAME)
--db_is_empty(DATABASE_NAME)

util.AddNetworkString("yrp_get_macros")
net.Receive("yrp_get_macros", function(len, ply)
	if ply:HasAccess() then
		local tab = SQL_SELECT(DATABASE_NAME, "*")

		if wk(tab) then
			net.Start("yrp_get_macros")
				net.WriteTable(tab)
			net.Send(ply)
		end
	end
end)

if SQL_SELECT(DATABASE_NAME, "*", "name = 'm_1'") == nil then
	local c = 1
	for y = 0, 6 do
		for x = 0, 6 do
			SQL_INSERT_INTO(DATABASE_NAME, "name", "'" .. "m_" .. c .. "'")
			c = c + 1
		end
	end
end

util.AddNetworkString("yrp_update_macro")
net.Receive("yrp_update_macro", function(len, ply)
	local muid = net.ReadString()
	local value = net.ReadString()

	SQL_UPDATE(DATABASE_NAME, "value = '" .. SQL_STR_IN(value) .. "'", "uniqueID = '" .. muid .. "'")
end)
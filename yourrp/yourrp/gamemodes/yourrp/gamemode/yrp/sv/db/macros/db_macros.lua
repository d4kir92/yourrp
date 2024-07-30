--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
-- DO NOT TOUCH THE DATABASE FILES! If you have errors, report them here:
-- https://discord.gg/sEgNZxg
local DATABASE_NAME = "yrp_macros"
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "name", "TEXT DEFAULT ''")
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "value", "TEXT DEFAULT ''")
YRP:AddNetworkString("nws_yrp_get_macros")
net.Receive(
	"nws_yrp_get_macros",
	function(len, ply)
		local tab = YRP_SQL_SELECT(DATABASE_NAME, "*")
		if IsNotNilAndNotFalse and IsNotNilAndNotFalse(tab) then
			net.Start("nws_yrp_get_macros")
			net.WriteTable(tab)
			net.Send(ply)
		end
	end
)

if YRP_SQL_SELECT(DATABASE_NAME, "*", "name = 'm_1'") == nil then
	local c = 1
	for y = 0, 6 do
		for x = 0, 6 do
			YRP_SQL_INSERT_INTO(DATABASE_NAME, "name", "'" .. "m_" .. c .. "'")
			c = c + 1
		end
	end
end

YRP:AddNetworkString("nws_yrp_update_macro")
net.Receive(
	"nws_yrp_update_macro",
	function(len, ply)
		local muid = net.ReadString()
		local value = net.ReadString()
		YRP_SQL_UPDATE(
			DATABASE_NAME,
			{
				["value"] = value
			}, "uniqueID = '" .. muid .. "'"
		)
	end
)

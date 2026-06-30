--Copyright (C) 2017-2025 D4KiR (https://www.gnu.org/licenses/gpl.txt)
-- DO NOT TOUCH THE DATABASE FILES! If you have errors, report them here:
-- https://discord.gg/sEgNZxg
local DATABASE_NAME = "yrp_macros"
hook.Add(
	"YRP_SQLDBREADY_GAMEPLAY_DB",
	"yrp_macros",
	function()
		YRP_SQL_ADD_COLUMN(DATABASE_NAME, "name", "TEXT DEFAULT ''")
		YRP_SQL_ADD_COLUMN(DATABASE_NAME, "value", "TEXT DEFAULT ''")
		YRP_SQL_ADD_COLUMN(DATABASE_NAME, "SteamID", "TEXT DEFAULT ''")
	end
)

function YRPEnsurePlayerMacros(ply)
	local steamid = ply:YRPSteamID()
	local tab = YRP_SQL_SELECT(DATABASE_NAME, "*", "SteamID = '" .. steamid .. "'", "ORDER BY uniqueID ASC")
	if not IsNotNilAndNotFalse(tab) then
		for c = 1, 49 do
			YRP_SQL_INSERT_INTO(DATABASE_NAME, "name, SteamID", YRP_SQL_STR_IN("m_" .. c) .. ", " .. YRP_SQL_STR_IN(steamid))
		end

		tab = YRP_SQL_SELECT(DATABASE_NAME, "*", "SteamID = '" .. steamid .. "'", "ORDER BY uniqueID ASC")
	end

	return tab
end

YRP:AddNetworkString("nws_yrp_get_macros")
net.Receive(
	"nws_yrp_get_macros",
	function(len, ply)
		local tab = YRPEnsurePlayerMacros(ply)
		if IsNotNilAndNotFalse(tab) then
			net.Start("nws_yrp_get_macros")
			net.WriteTable(tab)
			net.Send(ply)
		end
	end
)

YRP:AddNetworkString("nws_yrp_update_macro")
net.Receive(
	"nws_yrp_update_macro",
	function(len, ply)
		local muid = tonumber(net.ReadString())
		local value = net.ReadString()
		if not muid then return end
		YRP_SQL_UPDATE(
			DATABASE_NAME,
			{
				["value"] = value
			}, "uniqueID = " .. muid .. " AND SteamID = '" .. ply:YRPSteamID() .. "'"
		)
	end
)

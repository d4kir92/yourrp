--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
-- DO NOT TOUCH THE DATABASE FILES! If you have errors, report them here:
-- https://discord.gg/sEgNZxg
local DATABASE_NAME = "yrp_logs_settings"
--YRP_SQL_DROP_TABLE(DATABASE_NAME)
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "string_text", "TEXT DEFAULT 'unknown'")
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "string_timestamp", "TEXT DEFAULT ''")
local showafter = 60 * 60 * 2
local deleteafter = 60 * 60 * 12
local logTab = YRP_SQL_SELECT(DATABASE_NAME, "*", nil)
if IsNotNilAndNotFalse(logTab) then
	for i, t in pairs(logTab) do
		if os.time() - deleteafter > tonumber(t.string_timestamp) then
			YRP_SQL_DELETE_FROM(DATABASE_NAME, "uniqueID = '" .. t.uniqueID .. "'")
		end
	end
end

util.AddNetworkString("nws_yrp_get_logs_settings")
net.Receive(
	"nws_yrp_get_logs_settings",
	function(len, ply)
		--local tab = net.ReadString()
		if ply:CanAccess("bool_logs") then
			local dbtab = YRP_SQL_SELECT(DATABASE_NAME, "*", nil)
			local nettab = {}
			if IsNotNilAndNotFalse(dbtab) then
				for i, t in pairs(dbtab) do
					if os.time() - showafter < tonumber(t.string_timestamp) then
						table.insert(nettab, t)
					else
						YRP_SQL_DELETE_FROM(DATABASE_NAME, "uniqueID = '" .. t.uniqueID .. "'")
					end
				end
			end

			table.SortByMember(nettab, "string_timestamp")
			net.Start("nws_yrp_get_logs_settings")
			net.WriteTable(nettab)
			net.Send(ply)
		end
	end
)

function YRP.log(msg)
	YRP.msg("note", msg)
	YRP_SQL_INSERT_INTO("yrp_logs_settings", "string_timestamp, string_text", "'" .. os.time() .. "', " .. YRP_SQL_STR_IN(msg) .. "")
end
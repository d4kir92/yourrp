--Copyright (C) 2017-2025 D4KiR (https://www.gnu.org/licenses/gpl.txt)
-- DO NOT TOUCH THE DATABASE FILES! If you have errors, report them here:
-- https://discord.gg/sEgNZxg
local DATABASE_NAME = "yrp_logs"
local showafter = 60 * 60 * 2
local deleteafter = 60 * 60 * 12
hook.Add(
	"YRP_SQLDBREADY_GENERAL_DB",
	"yrp_logs",
	function()
		--YRP_SQL_DROP_TABLE(DATABASE_NAME)
		YRP_SQL_ADD_COLUMN(DATABASE_NAME, "string_typ", "TEXT DEFAULT 'unknown'")
		YRP_SQL_ADD_COLUMN(DATABASE_NAME, "string_source_steamid", "TEXT DEFAULT ''")
		YRP_SQL_ADD_COLUMN(DATABASE_NAME, "string_target_steamid", "TEXT DEFAULT ''")
		YRP_SQL_ADD_COLUMN(DATABASE_NAME, "string_value", "TEXT DEFAULT ''")
		YRP_SQL_ADD_COLUMN(DATABASE_NAME, "string_timestamp", "TEXT DEFAULT ''")
		YRP_SQL_ADD_COLUMN(DATABASE_NAME, "string_alttarget", "TEXT DEFAULT ''")
	end
)

hook.Add(
	"YRP_SQLDBREADY_GENERAL_UPDATE",
	"yrp_logs",
	function()
		local logTab = YRP_SQL_SELECT(DATABASE_NAME, "*", nil)
		if IsNotNilAndNotFalse(logTab) then
			for i, t in pairs(logTab) do
				if os.time() - deleteafter > tonumber(t.string_timestamp) then
					YRP_SQL_DELETE_FROM(DATABASE_NAME, "uniqueID = '" .. t.uniqueID .. "'")
				end
			end
		end
	end
)

YRP:AddNetworkString("nws_yrp_get_logs")
net.Receive(
	"nws_yrp_get_logs",
	function(len, ply)
		local tab = net.ReadString()
		if ply:CanAccess("bool_logs") then
			local dbtab = YRP_SQL_SELECT(DATABASE_NAME, "*", "string_typ = '" .. tab .. "'")
			local nettab = {}
			local count = 0
			if IsNotNilAndNotFalse(dbtab) then
				for i, t in SortedPairsByMemberValue(dbtab, "string_timestamp", true) do
					if os.time() - showafter < tonumber(t.string_timestamp) then
						if count < 60 then
							table.insert(nettab, t)
							count = count + 1
						end
					else
						YRP_SQL_DELETE_FROM(DATABASE_NAME, "uniqueID = '" .. t.uniqueID .. "'")
					end
				end
			end

			table.SortByMember(nettab, "string_timestamp")
			net.Start("nws_yrp_get_logs")
			net.WriteTable(nettab)
			net.Send(ply)
		end
	end
)

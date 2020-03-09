--Copyright (C) 2017-2019 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

-- DO NOT TOUCH THE DATABASE FILES! If you have errors, report them here:
-- https://discord.gg/sEgNZxg

local DATABASE_NAME = "yrp_logs"

--SQL_DROP_TABLE(DATABASE_NAME)

SQL_ADD_COLUMN(DATABASE_NAME, "string_typ", "TEXT DEFAULT 'unknown'")
SQL_ADD_COLUMN(DATABASE_NAME, "string_source_steamid", "TEXT DEFAULT ''")
SQL_ADD_COLUMN(DATABASE_NAME, "string_target_steamid", "TEXT DEFAULT ''")
SQL_ADD_COLUMN(DATABASE_NAME, "string_value", "TEXT DEFAULT ''")
SQL_ADD_COLUMN(DATABASE_NAME, "string_timestamp", "TEXT DEFAULT ''")

local showafter =	60*60*24
local deleteafter =	60*60*24*2

local logTab = SQL_SELECT(DATABASE_NAME, "*", nil)
if wk(logTab) then
	for i, t in pairs(logTab) do
		if os.time() - deleteafter > tonumber(t.string_timestamp) then
			SQL_DELETE_FROM(DATABASE_NAME, "uniqueID = '" .. t.uniqueID .. "'")
		end
	end
end

util.AddNetworkString("yrp_get_logs")
net.Receive("yrp_get_logs", function(len, ply)
	local tab = net.ReadString()

	if ply:CanAccess("bool_logs") then
		local dbtab = SQL_SELECT(DATABASE_NAME, "*", "string_typ = '" .. tab .. "'")
		local nettab = {}
		if wk(dbtab) then
			for i, t in pairs(dbtab) do
				if os.time() - showafter < tonumber(t.string_timestamp) then
					table.insert(nettab, t)
				else
					SQL_DELETE_FROM(DATABASE_NAME, "uniqueID = '" .. t.uniqueID .. "'")
				end
			end
		end

		table.SortByMember(nettab, "string_timestamp")

		net.Start("yrp_get_logs")
			net.WriteTable(nettab)
		net.Send(ply)
	end
end)

-- %source% killed %target%
-- %source% damaged %target% with %value% dmg
-- %source% wrote: %value%
-- %source% used command: %value%
-- %source% arrested %target%
-- %source% connected/disconnected
-- %source% added %target% into the whitelist
-- %source% spawned %value%

--[[
❎ Kills (Wer wen gekillt hat)
❎ Gesundheit (Wer wen wann womit getroffen hat)
❎ Chat (Wer wann was geschrieben hat)
❎ Commands (ULX, Vermilion, yourrp commands etc)
❎ Arrests (Wer wann wen verhaftet hat)
❎ Connections (wer wann gejoint/geleavt ist)
❎ Whitelist log (wer wen wann eingetragen hat)
❎ Spawn log (Props, Entities, Vehicles)
]]
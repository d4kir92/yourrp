--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
-- DO NOT TOUCH THE DATABASE FILES! If you have errors, report them here:
-- https://discord.gg/sEgNZxg
local DATABASE_NAME = "yrp_laws"
--YRP_SQL_DROP_TABLE(DATABASE_NAME)
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "string_lawsymbol", "TEXT DEFAULT '§'")
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "string_laws", "TEXT DEFAULT ''")
if YRP_SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '1'") == nil then
	YRP_SQL_INSERT_INTO(DATABASE_NAME, "string_lawsymbol, string_laws", "'§', ''")
end

local dblaws = YRP_SQL_SELECT(DATABASE_NAME, "*")
if IsNotNilAndNotFalse(dblaws) then
	dblaws = dblaws[1]
	SetGlobalYRPString("sting_laws", dblaws.string_laws)
end

YRP:AddNetworkString("nws_yrp_get_laws")
net.Receive(
	"nws_yrp_get_laws",
	function(len, ply)
		local laws = YRP_SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '1'")
		if IsNotNilAndNotFalse(laws) then
			laws = laws[1]
			laws.string_lawsymbol = laws.string_lawsymbol
			laws.string_laws = laws.string_laws
			local lockdown = YRP_SQL_SELECT("yrp_lockdown", "*", "uniqueID = '1'")
			if IsNotNilAndNotFalse(lockdown) then
				lockdown = lockdown[1]
				laws.bool_lockdown = lockdown.bool_lockdown
				laws.string_lockdowntext = lockdown.string_lockdowntext
			end

			local buildings = YRP_SQL_SELECT("yrp_" .. GetMapNameDB() .. "_buildings", "name, bool_lockdown, uniqueID", "name != 'Building'")
			if not IsNotNilAndNotFalse(buildings) then
				buildings = {}
			end

			net.Start("nws_yrp_get_laws")
			net.WriteTable(laws)
			net.WriteTable(buildings)
			net.Send(ply)
		end
	end
)

YRP:AddNetworkString("nws_yrp_set_lawsymbol")
net.Receive(
	"nws_yrp_set_lawsymbol",
	function(len, ply)
		local lawsymbol = net.ReadString()
		lawsymbol = lawsymbol
		YRP:msg("db", "Changed lawsymbol to: " .. lawsymbol)
		YRP_SQL_UPDATE(
			DATABASE_NAME,
			{
				["string_lawsymbol"] = lawsymbol
			}, "uniqueID = '1'"
		)
	end
)

YRP:AddNetworkString("nws_yrp_set_laws")
net.Receive(
	"nws_yrp_set_laws",
	function(len, ply)
		local laws = net.ReadString()
		laws = laws
		YRP:msg("db", "Changed lawsymbol to: " .. laws)
		YRP_SQL_UPDATE(
			DATABASE_NAME,
			{
				["string_laws"] = laws
			}, "uniqueID = '1'"
		)
	end
)

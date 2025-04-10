--Copyright (C) 2017-2025 D4KiR (https://www.gnu.org/licenses/gpl.txt)
-- DO NOT TOUCH THE DATABASE FILES! If you have errors, report them here:
-- https://discord.gg/sEgNZxg
-- #PLAYERMODELSDATABASE
local DATABASE_NAME = "yrp_playermodels"
function YRP_CheckAndRemoveUnusedPlayermodels()
	local usedpms = {}
	local roles = YRP_SQL_SELECT("yrp_ply_roles", "string_playermodels, uniqueID", nil)
	if IsNotNilAndNotFalse(roles) then
		for i, role in pairs(roles) do
			if role.string_playermodels then
				local pms = string.Explode(",", role.string_playermodels)
				for j, pm in pairs(pms) do
					if not strEmpty(pm) and not table.HasValue(usedpms, tonumber(pm)) then
						table.insert(usedpms, tonumber(pm))
					end
				end
			end
		end
	end

	local dbpms = YRP_SQL_SELECT(DATABASE_NAME, "*", nil)
	if IsNotNilAndNotFalse(dbpms) then
		for i, pm in pairs(dbpms) do
			pm.uniqueID = tonumber(pm.uniqueID)
			if not table.HasValue(usedpms, pm.uniqueID) then
				YRP_SQL_DELETE_FROM(DATABASE_NAME, "uniqueID = '" .. pm.uniqueID .. "'")
			end
		end
	end
end

hook.Add(
	"YRP_SQLDBREADY_VISUAL_DB",
	"yrp_playermodels",
	function()
		YRP_SQL_ADD_COLUMN(DATABASE_NAME, "string_name", "TEXT DEFAULT ''")
		YRP_SQL_ADD_COLUMN(DATABASE_NAME, "string_models", "TEXT DEFAULT ''")
		YRP_SQL_ADD_COLUMN(DATABASE_NAME, "float_size_min", "TEXT DEFAULT '1'")
		YRP_SQL_ADD_COLUMN(DATABASE_NAME, "float_size_max", "TEXT DEFAULT '1'")
	end
)

hook.Add(
	"YRP_SQLDBREADY_VISUAL_UPDATE",
	"yrp_playermodels",
	function()
		timer.Simple(
			1,
			function()
				YRP_CheckAndRemoveUnusedPlayermodels()
			end
		)
	end
)

YRP:AddNetworkString("nws_yrp_rem_playermodel")
net.Receive(
	"nws_yrp_rem_playermodel",
	function(len, ply)
		local muid = net.ReadInt(32)
		if muid == nil then return end
		local pms = muid
		local test = YRP_SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '" .. muid .. "'")
		if IsNotNilAndNotFalse(test) then
			pms = test[1].string_models
		end

		YRP:log(ply:RPName() .. " removed PUBLIC ENTRY (playermodels: " .. pms .. " )")
		YRP_SQL_DELETE_FROM(DATABASE_NAME, "uniqueID = '" .. muid .. "'")
	end
)

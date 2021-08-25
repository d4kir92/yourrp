--Copyright (C) 2017-2021 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

-- DO NOT TOUCH THE DATABASE FILES! If you have errors, report them here:
-- https://discord.gg/sEgNZxg

-- #PLAYERMODELSDATABASE

local DATABASE_NAME = "yrp_playermodels"

--SQL_DROP_TABLE(DATABASE_NAME)

SQL_ADD_COLUMN(DATABASE_NAME, "string_name", "TEXT DEFAULT ''")
SQL_ADD_COLUMN(DATABASE_NAME, "string_models", "TEXT DEFAULT ''")
SQL_ADD_COLUMN(DATABASE_NAME, "float_size_min", "TEXT DEFAULT '1'")
SQL_ADD_COLUMN(DATABASE_NAME, "float_size_max", "TEXT DEFAULT '1'")

local oldpms = SQL_SELECT(DATABASE_NAME, "*", nil)
if wk(oldpms) then
	for i, pm in pairs(oldpms) do
		if pm.string_model != nil and pm.string_model != "" and pm.string_models == "" then
			SQL_UPDATE(DATABASE_NAME, "string_models = '" .. pm.string_model .. "'", "uniqueID = '" .. pm.uniqueID .. "'")
		end
	end
end

local usedpms = {}
local roles = SQL_SELECT("yrp_ply_roles", "string_playermodels, uniqueID", nil)
if wk(roles) then
	for i, role in pairs(roles) do
		if role.string_playermodels then
			local pms = string.Explode(",", role.string_playermodels)
			for j, pm in pairs(pms) do
				if !strEmpty(pm) and !table.HasValue(usedpms, pm) then
					table.insert(usedpms, pm)
				end
			end
		end
	end
end

local pms = SQL_SELECT(DATABASE_NAME, "*", nil)
if wk(pms) then
	for i, pm in pairs(oldpms) do
		if !table.HasValue(usedpms, pm.uniqueID) then
			SQL_DELETE_FROM(DATABASE_NAME, "uniqueID = '" .. pm.uniqueID .. "'")
		end
	end
end


util.AddNetworkString("rem_playermodel")
net.Receive("rem_playermodel", function(len, ply)
	local muid = net.ReadInt(32)

	if muid == nil then return end

	SQL_DELETE_FROM(DATABASE_NAME, "uniqueID = '" .. muid .. "'")
end)
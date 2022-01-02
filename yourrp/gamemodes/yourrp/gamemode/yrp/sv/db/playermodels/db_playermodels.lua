--Copyright (C) 2017-2022 D4KiR (https://www.gnu.org/licenses/gpl.txt)

-- DO NOT TOUCH THE DATABASE FILES! If you have errors, report them here:
-- https://discord.gg/sEgNZxg

-- #PLAYERMODELSDATABASE

local DATABASE_NAME = "yrp_playermodels"

--YRP_SQL_DROP_TABLE(DATABASE_NAME)

YRP_SQL_ADD_COLUMN(DATABASE_NAME, "string_name", "TEXT DEFAULT ''" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "string_models", "TEXT DEFAULT ''" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "float_size_min", "TEXT DEFAULT '1'" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "float_size_max", "TEXT DEFAULT '1'" )

local oldpms = YRP_SQL_SELECT(DATABASE_NAME, "*", nil)
if wk(oldpms) then
	for i, pm in pairs(oldpms) do
		if pm.string_model != nil and pm.string_model != "" and pm.string_models == "" then
			YRP_SQL_UPDATE(DATABASE_NAME, {["string_models"] = pm.string_model}, "uniqueID = '" .. pm.uniqueID .. "'" )
		end
	end
end

local usedpms = {}
local roles = YRP_SQL_SELECT( "yrp_ply_roles", "string_playermodels, uniqueID", nil)
if wk(roles) then
	for i, role in pairs(roles) do
		if role.string_playermodels then
			local pms = string.Explode( ",", role.string_playermodels)
			for j, pm in pairs(pms) do
				if !strEmpty(pm) and !table.HasValue(usedpms, pm) then
					table.insert(usedpms, pm)
				end
			end
		end
	end
end

local pms = YRP_SQL_SELECT(DATABASE_NAME, "*", nil)
if wk(pms) then
	for i, pm in pairs(oldpms) do
		if !table.HasValue(usedpms, pm.uniqueID) then
			YRP_SQL_DELETE_FROM(DATABASE_NAME, "uniqueID = '" .. pm.uniqueID .. "'" )
		end
	end
end


util.AddNetworkString( "rem_playermodel" )
net.Receive( "rem_playermodel", function(len, ply)
	local muid = net.ReadInt(32)

	if muid == nil then return end

	local pms = muid

	local test = YRP_SQL_SELECT( DATABASE_NAME, "*", "uniqueID = '" .. muid .. "'" )

	if wk(test) then
		pms = test[1].string_models
	end

	YRP.log( ply:RPName() .. " removed PUBLIC ENTRY (playermodels: " .. pms .. " )" )

	--YRP_SQL_DELETE_FROM(DATABASE_NAME, "uniqueID = '" .. muid .. "'" )
end)
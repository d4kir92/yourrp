--Copyright (C) 2017-2019 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

-- DO NOT TOUCH THE DATABASE FILES! If you have errors, report them here:
-- https://discord.gg/sEgNZxg

local DATABASE_NAME = "yrp_idcard"

SQL_ADD_COLUMN(DATABASE_NAME, "name", "TEXT DEFAULT ' '")
SQL_ADD_COLUMN(DATABASE_NAME, "value", "TEXT DEFAULT ' '")

if SQL_SELECT(DATABASE_NAME, "*", "uniqueID = 1") == nil then
	SQL_INSERT_INTO(DATABASE_NAME, "name, value", "'Version', '1'")
end

--SQL_DROP_TABLE(DATABASE_NAME)

local elements = {
	"background",
	"server_name"
}

local names = {
	"bool_ELEMENT_visible",
	"int_ELEMENT_x",
	"int_ELEMENT_y",
	"int_ELEMENT_w",
	"int_ELEMENT_h",
}

-- CONFIG
-- MAX Tries on Server startup
local maxtries = 3
-- CONFIG

local tries = 0
local register = {}
function LoadIDCardSetting(force)
	tries = tries + 1

	local missing = false

	for i, ele in pairs(elements) do
		for j, name in pairs(names) do
			name = string.Replace(name, "ELEMENT", ele)
			local value = SQL_SELECT(DATABASE_NAME, "*", "name = '" .. name .. "'")
			pTab(value)
			if wk(value) then
				-- FOUND DATABASE VALUE
				value = value[1]
				if string.StartWith(name, "bool_") then
					SetGlobalDBool(name, tobool(value.value))
				elseif string.StartWith(name, "int_") then
					SetGlobalDInt(name, value.value)
				end
				register[name] = register[name] or nil
				if register[name] == nil then
					local netstr = "update_idcard_" .. name
					util.AddNetworkString(netstr)
					net.Receive(netstr, function()
						local n = net.ReadString()
						local v = net.ReadString()
						if v == "true" then
							v = 1
						elseif v == "false" then
							v = 0
						end
						print(n, v)
						SQL_UPDATE(DATABASE_NAME, "value = '" .. v .. "'", "name = '" .. n .. "'")
						print("LOADDDD")
						LoadIDCardSetting(true)
					end)
				end
			else
				-- Missed DB Value, add them
				if string.StartWith(name, "bool_") then
					SQL_INSERT_INTO(DATABASE_NAME, "name, value", "'" .. name .. "', 1")
					missing = true
				elseif string.StartWith(name, "int_") then
					SQL_INSERT_INTO(DATABASE_NAME, "name, value", "'" .. name .. "', 100")
					missing = true
				else
					YRP.msg("note", "[LoadIDCardSetting] ELSE " .. name)
				end
			end
		end
	end

	if force then
		print("Updated")
	elseif missing and tries < maxtries then
		-- If something was missing, Reload NW Variables
		LoadIDCardSetting()
	else
		-- BUG, ERROR
		YRP.msg("error", "To much tries in LoadIDCardSetting!")
	end
end
LoadIDCardSetting()

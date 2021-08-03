--Copyright (C) 2017-2021 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

-- DO NOT TOUCH THE DATABASE FILES! If you have errors, report them here:
-- https://discord.gg/sEgNZxg

local DATABASE_NAME = "yrp_idcard"

SQL_ADD_COLUMN(DATABASE_NAME, "name", "TEXT DEFAULT ' '")
SQL_ADD_COLUMN(DATABASE_NAME, "value", "TEXT DEFAULT ' '")

if SQL_SELECT(DATABASE_NAME, "*", "uniqueID = 1") == nil then
	SQL_INSERT_INTO(DATABASE_NAME, "name, value", "'Version', '1'")
end

if SQL_SELECT(DATABASE_NAME, "*", "name = 'int_background_x'") != nil then
	SQL_UPDATE(DATABASE_NAME, "value = '0'", "name = 'int_background_x'")
	SQL_UPDATE(DATABASE_NAME, "value = '0'", "name = 'int_background_y'")
end

--SQL_DROP_TABLE(DATABASE_NAME)

local elements = {
	"background",
	"box1",
	"box2",
	"box3",
	"box4",
	"box5",
	"box6",
	"box7",
	"box8",
	"hostname",
	"role",
	"group",
	"idcardid",
	"faction",
	"rpname",
	"securitylevel",
	--"grouplogo",
	"serverlogo",
	"birthday",
	"bodyheight",
	"weight"
}

local names = {
	"bool_ELEMENT_visible",
	"int_ELEMENT_x",
	"int_ELEMENT_y",
	"int_ELEMENT_w",
	"int_ELEMENT_h",
	"int_ELEMENT_r",
	"int_ELEMENT_g",
	"int_ELEMENT_b",
	"int_ELEMENT_a",
	"int_ELEMENT_ax",
	"int_ELEMENT_ay",
	"int_ELEMENT_colortype",
	"bool_ELEMENT_title"
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
			if wk(value) then
				-- FOUND DATABASE VALUE
				value = value[1]
				if string.StartWith(name, "bool_") then
					SetGlobalBool(name, tobool(value.value))
				elseif string.StartWith(name, "int_") then
					SetGlobalInt(name, tonumber(value.value))
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
						if string.StartWith(n, "bool_") and GetGlobalBool(n, tobool(v)) ~= tobool(v) then
							SetGlobalBool(n, tobool(v))
						elseif string.StartWith(n, "int_") and GetGlobalDInt(n, v) ~= v then
							SetGlobalInt(n, v)
						end
						SQL_UPDATE(DATABASE_NAME, "value = '" .. v .. "'", "name = '" .. n .. "'")
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

	local tab = SQL_SELECT(DATABASE_NAME, "*", "name LIKE '%_ax'")
	if wk(tab) then
		for i, v in pairs(tab) do
			v.value = tonumber(v.value)
			if v.value > 2 then
				SQL_UPDATE(DATABASE_NAME, "value = '" .. 1 .. "'", "name = '" .. v.name .. "'")
			end
		end
	end
	local tab2 = SQL_SELECT(DATABASE_NAME, "*", "name LIKE '%_ay'")
	if wk(tab2) then
		for i, v in pairs(tab2) do
			v.value = tonumber(v.value)
			if v.value > 2 then
				SQL_UPDATE(DATABASE_NAME, "value = '" .. 1 .. "'", "name = '" .. v.name .. "'")
			end
		end
	end
	local tab3 = SQL_SELECT(DATABASE_NAME, "*", "name LIKE '%_colortype'")
	if wk(tab3) then
		for i, v in pairs(tab3) do
			v.value = tonumber(v.value)
			if v.value > 5 then -- 1 CustomColor, 2 FactionColor, 3 GroupColor, 4 RoleColor, 5 UserGroupColor
				SQL_UPDATE(DATABASE_NAME, "value = '" .. 1 .. "'", "name = '" .. v.name .. "'")
			end
		end
	end

	if force then
		-- Updated
	elseif missing and tries < maxtries then
		-- If something was missing, Reload NW Variables
		LoadIDCardSetting()
	end
end
LoadIDCardSetting()

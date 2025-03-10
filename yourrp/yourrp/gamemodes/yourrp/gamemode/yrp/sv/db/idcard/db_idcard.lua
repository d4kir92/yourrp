--Copyright (C) 2017-2025 D4KiR (https://www.gnu.org/licenses/gpl.txt)
-- DO NOT TOUCH THE DATABASE FILES! If you have errors, report them here:
-- https://discord.gg/sEgNZxg
local DATABASE_NAME = "yrp_idcard"
hook.Add(
	"YRP_SQLDBREADY_GENERAL_DB",
	"yrp_idcard",
	function()
		YRP_SQL_ADD_COLUMN(DATABASE_NAME, "name", "TEXT DEFAULT ''")
		YRP_SQL_ADD_COLUMN(DATABASE_NAME, "value", "TEXT DEFAULT ''")
		if YRP_SQL_SELECT(DATABASE_NAME, "*", "uniqueID = 1") == nil then
			YRP_SQL_INSERT_INTO(DATABASE_NAME, "name, value", "'Version', '1'")
		end

		LoadIDCardSettingDB(nil, "INIT")
	end
)

hook.Add(
	"YRP_SQLDBREADY_GENERAL_UPDATE",
	"yrp_idcard",
	function()
		if YRP_SQL_SELECT(DATABASE_NAME, "*", "name = 'int_background_x'") ~= nil then
			YRP_SQL_UPDATE(
				DATABASE_NAME,
				{
					["value"] = 0
				}, "name = 'int_background_x'"
			)

			YRP_SQL_UPDATE(
				DATABASE_NAME,
				{
					["value"] = 0
				}, "name = 'int_background_y'"
			)
		else
			YRP_SQL_INSERT_INTO(DATABASE_NAME, "name, value", "'int_background_x', '0'")
			YRP_SQL_INSERT_INTO(DATABASE_NAME, "name, value", "'int_background_y', '0'")
		end
	end
)

hook.Add(
	"YRP_SQLDBREADY_GENERAL",
	"yrp_idcard",
	function()
		LoadIDCardSetting(nil, "INIT")
	end
)

local elements = {"background", "box1", "box2", "box3", "box4", "box5", "serverlogo", "box6", "box7", "box8", "hostname", "role", "group", "idcardid", "faction", "rpname", "securitylevel", "birthday", "bodyheight", "weight"}
local names = {"bool_ELEMENT_visible", "int_ELEMENT_x", "int_ELEMENT_y", "int_ELEMENT_w", "int_ELEMENT_h", "int_ELEMENT_r", "int_ELEMENT_g", "int_ELEMENT_b", "int_ELEMENT_a", "int_ELEMENT_ax", "int_ELEMENT_ay", "int_ELEMENT_colortype", "bool_ELEMENT_title"}
local maxtries = 3
local tries = 0
function LoadIDCardSettingDB(force, from)
	local missing = false
	local cx = 0
	local cy = 0
	for i, ele in pairs(elements) do
		for j, name in pairs(names) do
			name = string.Replace(name, "ELEMENT", ele)
			local value = YRP_SQL_SELECT(DATABASE_NAME, "*", "name = '" .. name .. "'")
			if not IsNotNilAndNotFalse(value) then
				-- Missed DB Value, add them
				if string.StartWith(name, "bool_") then
					YRP_SQL_INSERT_INTO(DATABASE_NAME, "name, value", "'" .. name .. "', '1'")
					missing = true
				elseif string.StartWith(name, "int_") then
					if string.EndsWith(name, "_r") then
						YRP_SQL_INSERT_INTO(DATABASE_NAME, "name, value", "'" .. name .. "', '255'")
					elseif string.EndsWith(name, "_g") then
						YRP_SQL_INSERT_INTO(DATABASE_NAME, "name, value", "'" .. name .. "', '255'")
					elseif string.EndsWith(name, "_b") then
						YRP_SQL_INSERT_INTO(DATABASE_NAME, "name, value", "'" .. name .. "', '255'")
					elseif string.EndsWith(name, "_a") then
						YRP_SQL_INSERT_INTO(DATABASE_NAME, "name, value", "'" .. name .. "', '255'")
					elseif string.EndsWith(name, "_ax") then
						YRP_SQL_INSERT_INTO(DATABASE_NAME, "name, value", "'" .. name .. "', '1'")
					elseif string.EndsWith(name, "_ay") then
						YRP_SQL_INSERT_INTO(DATABASE_NAME, "name, value", "'" .. name .. "', '1'")
					elseif string.EndsWith(name, "_colortype") then
						YRP_SQL_INSERT_INTO(DATABASE_NAME, "name, value", "'" .. name .. "', '1'")
					elseif string.EndsWith(name, "_x") then
						if i > 1 then
							YRP_SQL_INSERT_INTO(DATABASE_NAME, "name, value", "'" .. name .. "', '" .. cx * 180 .. "'")
							cx = cx + 1
						end
					elseif string.EndsWith(name, "_y") then
						if i > 1 then
							YRP_SQL_INSERT_INTO(DATABASE_NAME, "name, value", "'" .. name .. "', '" .. 600 + cy * 180 .. "'")
							if cx > 9 then
								cx = 0
								cy = cy + 1
							end
						end
					else
						if string.find(name, "background", 1, true) then
							if string.EndsWith(name, "_w") then
								YRP_SQL_INSERT_INTO(DATABASE_NAME, "name, value", "'" .. name .. "', '600'")
							elseif string.EndsWith(name, "_h") then
								YRP_SQL_INSERT_INTO(DATABASE_NAME, "name, value", "'" .. name .. "', '400'")
							else
								YRP_SQL_INSERT_INTO(DATABASE_NAME, "name, value", "'" .. name .. "', '160'")
							end
						else
							YRP_SQL_INSERT_INTO(DATABASE_NAME, "name, value", "'" .. name .. "', '160'")
						end
					end

					missing = true
				else
					YRP:msg("note", "[LoadIDCardSetting] ELSE " .. name)
				end
			end
		end
	end

	if missing and tries < maxtries then
		-- Updated
		-- If something was missing, Reload NW Variables
		LoadIDCardSetting(nil, "MISSING and tries < maxtries")
	end
end

local register = {}
function LoadIDCardSetting(force, from)
	tries = tries + 1
	local tabIdcard = YRP_SQL_SELECT(DATABASE_NAME, "*", nil)
	if tabIdcard then
		for i, ele in pairs(tabIdcard) do
			local name = ele.name
			local value = ele.value
			if string.StartWith(name, "bool_") then
				SetGlobalYRPBool(name, tobool(value.value))
			elseif string.StartWith(name, "int_") then
				SetGlobalYRPInt(name, tonumber(value.value))
			end

			register[name] = register[name] or nil
			if register[name] == nil then
				local netstr = "nws_yrp_update_idcard_" .. name
				YRP:AddNetworkString(netstr)
				net.Receive(
					netstr,
					function()
						local n = net.ReadString()
						local v = net.ReadString()
						if v == "true" then
							v = 1
						elseif v == "false" then
							v = 0
						end

						if string.StartWith(n, "bool_") and GetGlobalYRPBool(n, tobool(v)) ~= tobool(v) then
							SetGlobalYRPBool(n, tobool(v))
						elseif string.StartWith(n, "int_") and GetGlobalYRPInt(n, v) ~= v then
							SetGlobalYRPInt(n, v)
						end

						YRP_SQL_UPDATE(
							DATABASE_NAME,
							{
								["value"] = v
							}, "name = '" .. n .. "'"
						)

						LoadIDCardSetting(true, "UPDATED VARIABLE")
					end
				)
			end
		end
	end

	local tab = YRP_SQL_SELECT(DATABASE_NAME, "*", "name LIKE '%_ax'")
	if IsNotNilAndNotFalse(tab) then
		for i, v in pairs(tab) do
			v.value = tonumber(v.value)
			if v.value > 2 then
				YRP_SQL_UPDATE(
					DATABASE_NAME,
					{
						["value"] = 1
					}, "name = '" .. v.name .. "'"
				)
			end
		end
	end

	local tab2 = YRP_SQL_SELECT(DATABASE_NAME, "*", "name LIKE '%_ay'")
	if IsNotNilAndNotFalse(tab2) then
		for i, v in pairs(tab2) do
			v.value = tonumber(v.value)
			if v.value > 2 then
				YRP_SQL_UPDATE(
					DATABASE_NAME,
					{
						["value"] = 1
					}, "name = '" .. v.name .. "'"
				)
			end
		end
	end

	local tab3 = YRP_SQL_SELECT(DATABASE_NAME, "*", "name LIKE '%_colortype'")
	if IsNotNilAndNotFalse(tab3) then
		for i, v in pairs(tab3) do
			v.value = tonumber(v.value)
			-- 1 CustomColor, 2 FactionColor, 3 GroupColor, 4 RoleColor, 5 UserGroupColor
			if v.value > 5 then
				YRP_SQL_UPDATE(
					DATABASE_NAME,
					{
						["value"] = 1
					}, "name = '" .. v.name .. "'"
				)
			end
		end
	end
end

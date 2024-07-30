--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
function pTab(table, name)
	name = name or ""
	if name ~= "" then
		name = name .. " "
	end

	name = name .. "( " .. tostring(table) .. " )"
	YRP:msg("ptab", name)
	if istable(table) then
		PrintTable(table)
	else
		YRP:msg("ptab", "printTab " .. tostring(table) .. " is not a table!")
	end
end

function pFTab(table, name)
	pTab(table, name)
end

function combineTables(tab1, tab2)
	if istable(tab1) and istable(tab2) then
		for i, item in pairs(tab2) do
			if item ~= nil and item ~= "nil" then
				table.insert(tab1, item)
			else
				YRP:msg("note", "combineTables: i: " .. tostring(i) .. " " .. tostring(item) .. " is nil")
			end
		end

		for i, item in pairs(tab1) do
			table.RemoveByValue(tab1, "")
			table.RemoveByValue(tab1, " ")
		end

		return tab1
	else
		YRP:msg("note", tostring(tab1) .. " and " .. tostring(tab2) .. " are not tables")

		return {}
	end
end

function combineStringTables(str1, str2)
	if str1 ~= nil and str2 ~= nil then
		local _tab1 = string.Explode(",", str1)
		local _tab2 = string.Explode(",", str2)

		return combineTables(_tab1, _tab2)
	else
		local _tab1 = string.Explode(",", tostring(str1))
		local _tab2 = string.Explode(",", tostring(str2))
		YRP:msg("note", "combineStringTables ERROR str1: " .. tostring(str1) .. " str2: " .. tostring(str2))

		return ""
	end
end

local _addons = engine.GetAddons()
local _wsids = {}
for i, add in pairs(_addons) do
	table.insert(_wsids, add.wsid)
end

function GetWorkshopIDs()
	return _wsids
end

function SENTSTable(str)
	local se = string.Explode(";", str)
	local tbl = {}
	for i, senttbl in pairs(se) do
		if senttbl ~= "" then
			senttbl = string.Explode(",", senttbl)
			if senttbl[1] ~= nil and senttbl[2] ~= nil then
				tbl[senttbl[2]] = senttbl[1]
			end
		end
	end

	return tbl
end

function SENTSString(tbl)
	local str = ""
	local count = 0
	for cname, amount in pairs(tbl) do
		if count < 1 then
			str = str .. amount .. "," .. cname
		else
			str = str .. ";" .. amount .. "," .. cname
		end

		count = count + 1
	end

	return str
end

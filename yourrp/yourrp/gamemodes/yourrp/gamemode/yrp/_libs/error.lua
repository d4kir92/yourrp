--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
local _tostring = tostring
local _type = type
local _table = table
local _IsValid = IsValid
-- #ERROR #BUGS
function IsNilOrFalse(obj)
	if obj == nil or obj == false then return true end

	return false
end

function IsNotNilAndNotFalse(obj)
	if obj ~= nil and obj ~= false then return true end

	return false
end

function YRPWORKED(obj, name, _silence)
	if obj ~= nil and obj ~= false then
		return true
	else
		if not _silence then
			YRP:msg("note", "NOT WORKED: " .. _tostring(obj) .. " " .. _tostring(name))
		end

		return false
	end
end

function YRPEntityAlive(obj)
	if obj == nil then return false end
	if _type(obj) == "number" then return false end
	if _type(obj) == "string" then return false end
	if obj == nil or obj == NULL or _tostring(obj) == "[NULL Entity]" then return false end

	return _IsValid(obj)
end

function YRPPanelAlive(obj, from)
	if _type(obj) == "table" then
		YRP:msg("error", "YRPPanelAlive > IS TABLE " .. _tostring(from) .. " " .. _table.ToString(obj, "X", false))
	elseif _type(obj) == "string" then
		YRP:msg("error", "YRPPanelAlive > IS STRING " .. _tostring(from) .. " " .. _tostring(obj))
	elseif _type(obj) == "number" then
		YRP:msg("error", "YRPPanelAlive > IS NUMBER " .. _tostring(from) .. " " .. _tostring(obj))
	elseif _type(obj) == "bool" then
		YRP:msg("error", "YRPPanelAlive > IS BOOL " .. _tostring(from) .. " " .. _tostring(obj))
	end

	if obj == nil or obj == NULL or _tostring(obj) == "[NULL Panel]" then return false end

	return _IsValid(obj)
end

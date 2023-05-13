--Copyright (C) 2017-2023 D4KiR (https://www.gnu.org/licenses/gpl.txt)
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
			YRP.msg("note", "NOT WORKED: " .. tostring(obj) .. " " .. tostring(name))
		end

		return false
	end
end

function YRPEntityAlive(obj)
	if obj == nil then return false end
	if type(obj) == "number" then return false end
	if type(obj) == "string" then return false end
	if obj == nil or obj == NULL or tostring(obj) == "[NULL Entity]" then return false end

	return IsValid(obj)
end

function YRPPanelAlive(obj, from)
	if type(obj) == "table" then
		YRP.msg("error", "YRPPanelAlive > IS TABLE" .. tostring(from) .. " " .. tostring(obj))
	elseif type(obj) == "string" then
		YRP.msg("error", "YRPPanelAlive > IS STRING" .. tostring(from) .. " " .. tostring(obj))
	elseif type(obj) == "number" then
		YRP.msg("error", "YRPPanelAlive > IS NUMBER" .. tostring(from) .. " " .. tostring(obj))
	elseif type(obj) == "bool" then
		YRP.msg("error", "YRPPanelAlive > IS BOOL" .. tostring(from) .. " " .. tostring(obj))
	end

	if obj == nil or obj == NULL or tostring(obj) == "[NULL Panel]" then return false end

	return IsValid(obj)
end
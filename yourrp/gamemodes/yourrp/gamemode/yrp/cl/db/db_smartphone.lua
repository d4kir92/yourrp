--Copyright (C) 2017-2021 D4KiR (https://www.gnu.org/licenses/gpl.txt)

local yrp_smartphone = {}

local DATABASE_NAME = "yrp_smartphone"

function setSpBackColor(color)
	SQL_UPDATE(DATABASE_NAME, {["value"] = color}, "name = '" .. "color_back" .. "'")
end

function getSpBackColor()
	local _color = SQL_SELECT(DATABASE_NAME, "*", "name = 'color_back'")
	if wk(_color) then
		_color = string.Explode(",", _color[1].value)
		return Color(_color[1], _color[2], _color[3], 255)
	else
		return Color(255, 255, 255)
	end
end

function setSpCaseColor(color)
	SQL_UPDATE(DATABASE_NAME, {["value"] = color}, "name = '" .. "color_case" .. "'")
end

function getSpCaseColor()
	local _color = SQL_SELECT(DATABASE_NAME, "*", "name = 'color_case'")
	_color = string.Explode(",", _color[1].value)

	return Color(_color[1], _color[2], _color[3], 255)
end

--db_drop_table(DATABASE_NAME)
function check_yrp_smartphone()
	SQL_INIT_DATABASE(DATABASE_NAME)

	SQL_ADD_COLUMN(DATABASE_NAME, "name", "TEXT DEFAULT 'name'")
	SQL_ADD_COLUMN(DATABASE_NAME, "value", "TEXT DEFAULT 'value'")

	local _sp = SQL_SELECT(DATABASE_NAME, "*", nil)
	if _sp != nil and _sp != false then
		yrp_smartphone = _sp[1]
	end

	if SQL_SELECT(DATABASE_NAME, "*", "name = '" .. "color_case" .. "'") == nil then
		SQL_INSERT_INTO(DATABASE_NAME, "name, value", "'" .. "color_case" .. "', '0,0,0,255'")
	end
	if SQL_SELECT(DATABASE_NAME, "*", "name = '" .. "color_back" .. "'") == nil then
		SQL_INSERT_INTO(DATABASE_NAME, "name, value", "'" .. "color_back" .. "', '0,0,0,255'")
	end

	local _res = SQL_SELECT(DATABASE_NAME, "*", nil)
end
check_yrp_smartphone()

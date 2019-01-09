--Copyright (C) 2017-2019 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

local yrp_smartphone = {}

local _db_name = "yrp_smartphone"

function setSpBackColor(color)
	SQL_UPDATE(_db_name, "value = '" .. color .. "'", "name = '" .. "color_back" .. "'")
end

function getSpBackColor()
	local _color = SQL_SELECT(_db_name, "*", "name = 'color_back'")
	if wk(_color) then
		_color = string.Explode(",", _color[1].value)
		return Color(_color[1], _color[2], _color[3], 255)
	else
		return Color(255, 255, 255)
	end
end

function setSpCaseColor(color)
	SQL_UPDATE(_db_name, "value = '" .. color .. "'", "name = '" .. "color_case" .. "'")
end

function getSpCaseColor()
	local _color = SQL_SELECT(_db_name, "*", "name = 'color_case'")
	_color = string.Explode(",", _color[1].value)

	return Color(_color[1], _color[2], _color[3], 255)
end

--db_drop_table(_db_name)
function check_yrp_smartphone()
	SQL_INIT_DATABASE(_db_name)

	SQL_ADD_COLUMN(_db_name, "name", "TEXT DEFAULT 'name'")
	SQL_ADD_COLUMN(_db_name, "value", "TEXT DEFAULT 'value'")

	local _sp = SQL_SELECT(_db_name, "*", nil)
	if _sp != nil and _sp != false then
		yrp_smartphone = _sp[1]
	end

	if SQL_SELECT(_db_name, "*", "name = '" .. "color_case" .. "'") == nil then
		SQL_INSERT_INTO(_db_name, "name, value", "'" .. "color_case" .. "', '0,0,0,255'")
	end
	if SQL_SELECT(_db_name, "*", "name = '" .. "color_back" .. "'") == nil then
		SQL_INSERT_INTO(_db_name, "name, value", "'" .. "color_back" .. "', '0,0,0,255'")
	end

	local _res = SQL_SELECT(_db_name, "*", nil)
end
check_yrp_smartphone()

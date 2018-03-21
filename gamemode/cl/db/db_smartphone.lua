--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

local yrp_smartphone = {}

local _db_name = "yrp_smartphone"

function setSpBackColor( color )
	db_update( _db_name, "value = '" .. color .. "'", "name = '" .. "color_back" .. "'")
end

function getSpBackColor()
	local _color = db_select( _db_name, "*", "name = 'color_back'" )
	_color = string.Explode( ",", _color[1].value )

	return Color( _color[1], _color[2], _color[3], 255 )
end

function setSpCaseColor( color )
	db_update( _db_name, "value = '" .. color .. "'", "name = '" .. "color_case" .. "'")
end

function getSpCaseColor()
	local _color = db_select( _db_name, "*", "name = 'color_case'" )
	_color = string.Explode( ",", _color[1].value )

	return Color( _color[1], _color[2], _color[3], 255 )
end

--db_drop_table( _db_name )
function check_yrp_smartphone()
  init_database( _db_name )

  sql_add_column( _db_name, "name", "TEXT DEFAULT 'name'" )
  sql_add_column( _db_name, "value", "TEXT DEFAULT 'value'" )

  local _sp = db_select( _db_name, "*", nil )
  if _sp != nil then
    yrp_smartphone = _sp[1]
  end

	if db_select( _db_name, "*", "name = '" .. "color_case" .. "'" ) == nil then
		db_insert_into( _db_name, "name, value", "'" .. "color_case" .. "', '0,0,0,255'" )
	end
	if db_select( _db_name, "*", "name = '" .. "color_back" .. "'" ) == nil then
		db_insert_into( _db_name, "name, value", "'" .. "color_back" .. "', '0,0,0,255'" )
	end

	local _res = db_select( _db_name, "*", nil )
end
check_yrp_smartphone()

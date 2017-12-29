--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

local yrp_keybinds = {}

local _db_name = "yrp_keybinds"

function get_keybind( name )
  return yrp_keybinds[name] or -1
end

function set_keybind( name, value )
  local _result = db_update( _db_name, name .. " = " .. value, "uniqueID = " .. 1 )
  yrp_keybinds[name] = value
end

--db_drop_table( "yrp_keybinds" )
function check_yrp_keybinds()
  init_database( _db_name )

  sql_add_column( _db_name, "menu_character_selection", "INT DEFAULT " .. KEY_F2 )
  sql_add_column( _db_name, "menu_role", "INT DEFAULT " .. KEY_F4 )
  sql_add_column( _db_name, "menu_buy", "INT DEFAULT " .. KEY_F11 )
  sql_add_column( _db_name, "menu_settings", "INT DEFAULT " .. KEY_F8 )
  sql_add_column( _db_name, "toggle_mouse", "INT DEFAULT " .. KEY_F3 )
  sql_add_column( _db_name, "view_zoom_out", "INT DEFAULT " .. KEY_PAD_PLUS )
  sql_add_column( _db_name, "view_zoom_in", "INT DEFAULT " .. KEY_PAD_MINUS )
  sql_add_column( _db_name, "toggle_map", "INT DEFAULT " .. KEY_M )
  sql_add_column( _db_name, "menu_inventory", "INT DEFAULT " .. KEY_I )
  sql_add_column( _db_name, "menu_options_vehicle", "INT DEFAULT " .. KEY_T )
  sql_add_column( _db_name, "menu_options_door", "INT DEFAULT " .. KEY_T )
  sql_add_column( _db_name, "speak_next", "INT DEFAULT " .. KEY_PAGEUP )
  sql_add_column( _db_name, "speak_prev", "INT DEFAULT " .. KEY_PAGEDOWN )

  local _tmp = db_select( _db_name, "*", "uniqueID = 1" )
  if _tmp == nil then
    local _result = db_insert_into_DEFAULTVALUES( _db_name )
    _tmp = db_select( _db_name, "*", "uniqueID = 1" )
    if _tmp == nil or _tmp == false then
      printGM( "error", _db_name .. " has no entries." )
    end
  end

  if !db_is_empty( _db_name ) then
    local _tmp = db_select( _db_name, "*", nil )
    _tmp = _tmp[1]

    yrp_keybinds = _tmp
  end
end
check_yrp_keybinds()

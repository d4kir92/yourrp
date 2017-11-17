--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

local yrp_keybinds = yrp_keybinds or {}

local _db_name = "yrp_keybinds"

function get_keybind( name )
  return yrp_keybinds[name] or -1
end

function set_keybind( name, value )
  local _result = db_update( _db_name, name .. " = " .. value, "uniqueID = " .. 1 )
  yrp_keybinds[name] = value
end

--sql.Query( "DROP TABLE yrp_keybinds")
function check_yrp_keybinds()
  init_database( _db_name )

  sql_add_column( _db_name, "menu_character_selection", "INT DEFAULT " .. KEY_F2 )
  sql_add_column( _db_name, "menu_role", "INT DEFAULT " .. KEY_F3 )
  sql_add_column( _db_name, "menu_buy", "INT DEFAULT " .. KEY_F4 )
  sql_add_column( _db_name, "menu_settings", "INT DEFAULT " .. KEY_F8 )
  sql_add_column( _db_name, "toggle_mouse", "INT DEFAULT " .. KEY_F11 )
  sql_add_column( _db_name, "toggle_view", "INT DEFAULT " .. KEY_B )
  sql_add_column( _db_name, "toggle_map", "INT DEFAULT " .. KEY_M )
  sql_add_column( _db_name, "menu_inventory", "INT DEFAULT " .. KEY_I )
  sql_add_column( _db_name, "menu_options_vehicle", "INT DEFAULT " .. KEY_T )
  sql_add_column( _db_name, "menu_options_door", "INT DEFAULT " .. KEY_T )

  local _tmp = db_select( _db_name, "*", "uniqueID = 1" )
  if _tmp == nil then
    local _result = db_insert_into_DEFAULTVALUES( _db_name )
    if worked( _tmp, "check_yrp_keybinds" ) then
      printGM( "error", _db_name .. " has no entries." )
    end
  end

  _tmp = db_select( _db_name, "*", nil )

  if worked( _tmp, tostring( _db_name ) .. " is empty" ) then
    hr_pre()
    printGM( "db", _db_name )
    PrintTable( _tmp )
    hr_pos()

    _tmp = _tmp[1]
    yrp_keybinds = _tmp
  end
end
check_yrp_keybinds()

print( get_keybind( "menu_character_selection" ) )

--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

local yrp_keybinds = {}
yrp_keybinds.version = 2

local _db_name = "yrp_keybinds"

function get_keybind( name )
  return tonumber( yrp_keybinds[name] ) or -1
end

function set_keybind( name, value )
  local _result = SQL_UPDATE( _db_name, name .. " = " .. value, "uniqueID = " .. 1 )
  yrp_keybinds[name] = value
end

function GetKeybindName( kbname )
  local _kb = kbname
  if !string.StartWith( kbname, "in_" ) then
    _kb = get_keybind( kbname ) or "UNKNOWN"
  end
  if isnumber( tonumber( _kb ) ) then
    _kb = input.GetKeyName( _kb )
  end
  if string.StartWith( kbname, "in_" ) then
    _kb = lang_string( kbname )
  end
  return tostring( _kb )
end

--db_drop_table( "yrp_keybinds" )
function check_yrp_keybinds()
  SQL_INIT_DATABASE( _db_name )

  local _check_version = SQL_SELECT( _db_name, "version", "uniqueID = 1" )
  if _check_version != false and _check_version != nil then
    printGM( "note", "Checking keybinds version" )
    _check_version = _check_version[1]
    if tonumber( _check_version.version ) != tonumber( yrp_keybinds.version ) then

      printGM( "note", "Keybinds OUTDATED!" )
      db_drop_table( _db_name )
      SQL_INIT_DATABASE( _db_name )
    else
      printGM( "note", "Keybinds up to date" )
    end
  end

  SQL_ADD_COLUMN( _db_name, "version", "INT DEFAULT " .. yrp_keybinds.version )
  SQL_ADD_COLUMN( _db_name, "menu_character_selection", "INT DEFAULT " .. KEY_F2 )
  SQL_ADD_COLUMN( _db_name, "menu_role", "INT DEFAULT " .. KEY_F4 )
  SQL_ADD_COLUMN( _db_name, "menu_buy", "INT DEFAULT " .. KEY_F11 )
  SQL_ADD_COLUMN( _db_name, "menu_settings", "INT DEFAULT " .. KEY_F8 )
  SQL_ADD_COLUMN( _db_name, "toggle_mouse", "INT DEFAULT " .. KEY_F3 )
  SQL_ADD_COLUMN( _db_name, "toggle_map", "INT DEFAULT " .. KEY_M )
  SQL_ADD_COLUMN( _db_name, "menu_inventory", "INT DEFAULT " .. KEY_I )
  SQL_ADD_COLUMN( _db_name, "menu_options_vehicle", "INT DEFAULT " .. KEY_B )
  SQL_ADD_COLUMN( _db_name, "menu_options_door", "INT DEFAULT " .. KEY_B )
  SQL_ADD_COLUMN( _db_name, "speak_next", "INT DEFAULT " .. KEY_PAGEUP )
  SQL_ADD_COLUMN( _db_name, "speak_prev", "INT DEFAULT " .. KEY_PAGEDOWN )
  SQL_ADD_COLUMN( _db_name, "drop_item", "INT DEFAULT " .. KEY_G )
  SQL_ADD_COLUMN( _db_name, "weaponlowering", "INT DEFAULT " .. KEY_H )
  SQL_ADD_COLUMN( _db_name, "menu_appearance", "INT DEFAULT " .. KEY_O )
  SQL_ADD_COLUMN( _db_name, "menu_emotes", "INT DEFAULT " .. KEY_N )

  SQL_ADD_COLUMN( _db_name, "view_switch", "INT DEFAULT " .. KEY_T )
  SQL_ADD_COLUMN( _db_name, "view_zoom_out", "INT DEFAULT " .. KEY_PAD_PLUS )
  SQL_ADD_COLUMN( _db_name, "view_zoom_in", "INT DEFAULT " .. KEY_PAD_MINUS )
  SQL_ADD_COLUMN( _db_name, "view_up", "INT DEFAULT " .. KEY_PAD_8 )
  SQL_ADD_COLUMN( _db_name, "view_down", "INT DEFAULT " .. KEY_PAD_5 )
  SQL_ADD_COLUMN( _db_name, "view_right", "INT DEFAULT " .. KEY_PAD_6 )
  SQL_ADD_COLUMN( _db_name, "view_left", "INT DEFAULT " .. KEY_PAD_4 )
  SQL_ADD_COLUMN( _db_name, "view_spin_right", "INT DEFAULT " .. KEY_PAD_9 )
  SQL_ADD_COLUMN( _db_name, "view_spin_left", "INT DEFAULT " .. KEY_PAD_7 )

  SQL_ADD_COLUMN( _db_name, "sp_open", "INT DEFAULT " .. KEY_UP )
  SQL_ADD_COLUMN( _db_name, "sp_close", "INT DEFAULT " .. KEY_DOWN )


  local _tmp = SQL_SELECT( _db_name, "*", "uniqueID = 1" )
  if _tmp == nil then
    local _result = SQL_INSERT_INTO_DEFAULTVALUES( _db_name )
    _tmp = SQL_SELECT( _db_name, "*", "uniqueID = 1" )
    if _tmp == nil or _tmp == false then
      printGM( "error", _db_name .. " has no entries." )
    end
  end

  if !db_is_empty( _db_name ) then
    local _tmp = SQL_SELECT( _db_name, "*", nil )
    _tmp = _tmp[1]

    yrp_keybinds = _tmp
  end
end
check_yrp_keybinds()

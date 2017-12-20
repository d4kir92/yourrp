--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

local yrp_tutorials = {}

local _db_name = "yrp_tutorials"

function done_tutorial( str, time )
  if tobool( get_tutorial( str ) ) then
    if time == nil then
      time = 0
    end
    timer.Simple( time, function()
      yrp_tutorials[str] = 0
      db_update( _db_name, str .. " = " .. "0", "uniqueID = 1" )
    end)
  end
end

function get_tutorial( str )
  return yrp_tutorials[str]
end

--db_drop_table( _db_name )
function check_yrp_tutorials()
  init_database( _db_name )

  sql_add_column( _db_name, "tut_all", "INT DEFAULT 1" )
  sql_add_column( _db_name, "tut_cs", "INT DEFAULT 1" )
  sql_add_column( _db_name, "tut_mr", "INT DEFAULT 1" )
  sql_add_column( _db_name, "tut_mb", "INT DEFAULT 1" )
  sql_add_column( _db_name, "tut_ms", "INT DEFAULT 1" )
  sql_add_column( _db_name, "tut_tmo", "INT DEFAULT 1" )
  sql_add_column( _db_name, "tut_vo", "INT DEFAULT 1" )
  sql_add_column( _db_name, "tut_vi", "INT DEFAULT 1" )
  sql_add_column( _db_name, "tut_tma", "INT DEFAULT 1" )
  sql_add_column( _db_name, "tut_mi", "INT DEFAULT 1" )
  sql_add_column( _db_name, "tut_sn", "INT DEFAULT 1" )
  sql_add_column( _db_name, "tut_sp", "INT DEFAULT 1" )

  local _tmp = db_select( _db_name, "*", "uniqueID = 1" )
  if _tmp == nil then
    local _result = db_insert_into_DEFAULTVALUES( _db_name )
    if _tmp == nil or _tmp == false then
      printGM( "error", _db_name .. " has no entries." )
    end
  end

  local _tuts = db_select( _db_name, "*", nil )
  if _tuts != nil then
    yrp_tutorials = _tuts[1]
  end
end
check_yrp_tutorials()

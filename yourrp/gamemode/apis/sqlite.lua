--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

function db_in_str( str )
  local _res = string.Replace( str, "'", "%" )
  return _res
end

function db_out_str( str )
  local _res = string.Replace( str, "%", "'" )
  return _res
end

function db_int( int )
  local _int = tonumber( int )
  if isnumber( _int ) then
    return _int
  else
    printGM( "error", tostring( int ) .. " is not a number! return -1" )
    return -1
  end
end

function db_drop_table( db_table )
  local _result = sql.Query( "DROP TABLE " .. db_table )
  if _result != nil then
    printGM( "error", "db_drop_table failed!" )
  end
end

function db_sql_str( string )
  if isstring( string ) then
    local _newString = sql.SQLStr( string, true )
    _newString = string.Replace( _newString, "\"", "´´" )
    _newString = string.Replace( _newString, "'", "´" )
    return _newString
  else
    printGM( "error", "db_sql_str: (" .. tostring( string ) .. ") is not a string." )
  end
end

function db_sql_str2( string )
  if isstring( string ) then
    local _newString = sql.SQLStr( string, true )
    _newString = string.Replace( _newString, "\"", "´´" )
    _newString = string.Replace( _newString, "'", "´" )
    _newString = string.Replace( _newString, "-", "_" )
    return _newString
  else
    printGM( "error", "db_sql_str2: (" .. tostring( string ) .. ") is not a string." )
  end
end

function db_table_exists( _db_table )
  local _tbl = db_sql_str2( _db_table )
  if sql.TableExists( _tbl ) then
    return true
  else
    printGM( "note", tostring( _tbl ) .. " is not existing.")
    return false
  end
end

function db_select( db_table, db_columns, db_where )
  if db_table_exists( db_table ) then
    local _q = "SELECT "
    _q = _q .. db_columns
    _q = _q .. " FROM "
    _q = _q .. db_table
    if db_where != nil then
      _q = _q .. " WHERE "
      _q = _q .. db_where
    end
    local _result = sql.Query( _q )
    if _result == nil then
      return _result
    elseif _result == false then
      return _result
    else
      return _result
    end
  end
end

function db_insert_into_DEFAULTVALUES( db_table )
  if db_table_exists( db_table ) then
    local _q = "INSERT INTO "
    _q = _q .. db_table
    _q = _q .. " DEFAULT VALUES"
    local _result = sql.Query( _q )
    if _result != nil then
      printGM( "error", "db_insert_into_DEFAULTVALUES failed! query: " .. tostring( _q ) .. " result: " .. tostring( _result ) .. " lastError: " .. tostring( sql.LastError() ) )
      PrintMessage( HUD_PRINTCENTER, "[YourRP] SERVER-DATABASE: " .. tostring( sql.LastError() ) )
    end
  end
end

function db_insert_into( db_table, db_columns, db_values )
  if db_table_exists( db_table ) then
    local _q = "INSERT INTO "
    _q = _q .. db_table
    _q = _q .. " ( "
    _q = _q .. db_columns
    _q = _q .. " ) VALUES ( "
    _q = _q .. db_values
    _q = _q .. " )"
    local _result = sql.Query( _q )
    if _result != nil then
      printGM( "error", "db_insert_into: has failed! query: " .. tostring( _q ) .. " result: " .. tostring( _result ) .. " lastError: " .. tostring( sql.LastError() ) )
      PrintMessage( HUD_PRINTCENTER, "[YourRP] SERVER-DATABASE: " .. tostring( sql.LastError() ) )
    end
  end
end

function db_delete_from( db_table, db_where )
  if db_table_exists( db_table ) then
    local _q = "DELETE FROM "
    _q = _q .. db_table
    if db_where != nil then
      _q = _q .. " WHERE "
      _q = _q .. db_where
    end
    local _result = sql.Query( _q )
    if _result != nil then
      printGM( "error", "db_delete_from: has failed! query: " .. tostring( _q ) .. " result: " .. tostring(_result) .. " lastError: " .. tostring( sql.LastError() ) )
      PrintMessage( HUD_PRINTCENTER, "[YourRP] SERVER-DATABASE: " .. tostring( sql.LastError() ) )
    end
  end
end

function db_update( db_table, db_sets, db_where )
  if db_table_exists( db_table ) then
    local _q = "UPDATE "
    _q = _q .. db_table
    _q = _q .. " SET "
    _q = _q .. db_sets
    if db_where != nil then
      _q = _q .. " WHERE "
      _q = _q .. db_where
    end
    local _result = sql.Query( _q )
    if _result != nil then
      printGM( "error", "db_update failed! query: " .. tostring( _q ) .. " result: " .. tostring( _result ) .. " lastError: " .. tostring( sql.LastError() ) )
      PrintMessage( HUD_PRINTCENTER, "[YourRP] SERVER-DATABASE: " .. tostring( sql.LastError() ) )
    end
  end
end

function sql_check_if_column_exists( db_name, column_name )
  local _result = db_select( db_name, column_name, nil )
  if _result == false then
    --printGM( "note", "In table " .. table_name .. " column " .. column_name .. " not exists. (" .. tostring( _result ) .. ")" )
    return false
  else
    return true
  end
end

function sql_add_column( table_name, column_name, datatype )
  local _result = sql_check_if_column_exists( table_name, column_name )
  if !_result then
    local _q = "ALTER TABLE " .. table_name .. " ADD " .. column_name .. " " .. datatype .. ""
    local _result = sql.Query( _q )
    if _result != nil then
      printGM( "error", "sql_add_column failed! query: " .. tostring( _q ) .. " result: " .. tostring( _result ) .. " lastError: " .. tostring( sql.LastError() ) )
      PrintMessage( HUD_PRINTCENTER, "[YourRP] SERVER-DATABASE: " .. tostring( sql.LastError() ) )
    end
  end
end

function init_database( db_name )
  printGM( "db", "init_database " .. tostring( db_name ) )
  if db_table_exists( db_name ) then
    --printGM( "db", db_name .. " exists" )
  else
    printGM( "note", db_name .. " not exists" )
    local _query = ""
    _query = _query .. "CREATE TABLE " .. db_sql_str2( db_name ) .. " ( "
    _query = _query .. "uniqueID    INTEGER         PRIMARY KEY autoincrement"
    _query = _query .. " )"
    local _result = sql.Query( _query )
    if _result != nil then
      printGM( "error", "init_database failed! query: " .. tostring( _query ) .. " result: " .. tostring( _result ) .. " lastError: " .. tostring( sql.LastError() ) )
      PrintMessage( HUD_PRINTCENTER, "[YourRP] SERVER-DATABASE: " .. tostring( sql.LastError() ) )
    end
		if sql.TableExists( db_name ) then
      --printGM( "db", db_name .. _yrp.successdb )
		else
			printGM( "error", "CREATE TABLE " .. db_name .. " fail" )
      PrintMessage( HUD_PRINTCENTER, "[YourRP] SERVER-DATABASE: " .. tostring( sql.LastError() ) )
      retry_load_database()
		end
  end
end

local _show_db_if_not_empty = false
function db_is_empty( db_name )
  local _tmp = db_select( db_name, "*", nil )

  if worked( _tmp, db_name .. " is empty!" ) then
    if _show_db_if_not_empty then
      hr_pre()
      printGM( "db", db_name )
      PrintTable( _tmp )
      hr_pos()
    end
    return false
  else
    return true
  end
end

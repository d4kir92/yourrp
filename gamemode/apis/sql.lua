--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

local SQL = {}
SQL.mode = 0

function GetSQLMode()
  return SQL.mode
end

function GetSQLModeName()
  if SQL.mode == 0 then
    return "SQLITE"
  elseif SQL.mode == 1 then
    return "MYSQL"
  end
end

function SetSQLMode( sqlmode )
  SQL.mode = tonumber( sqlmode )
end

if SERVER then
  --[[ Create file if not exists ]]--
  if !file.Exists( "yrp/sv_sql.txt", "DATA" ) then
    if !file.Exists( "yrp", "DATA" ) then
      printGM( "db", "folder yrp does not exist, create it" )
      file.CreateDir( "yrp" )
    end
    printGM( "db", "yrp/sv_sql.txt not exists" )
    file.Write( "yrp/sv_sql.txt", 0 )
  end

  --[[ GET SQL Mode ]]--
  local _sql_mode = file.Read( "yrp/sv_sql.txt", "DATA" )
  SetSQLMode( _sql_mode )
end
printGM( "db", "Current SQL Mode: " .. GetSQLModeName() )

function SQL_table_exists( db_table )
  if SQL.mode == 0 then
    if sql.TableExists( db_table ) then
      return true
    else
      printGM( "note", "SQL Table [" .. tostring( _tbl ) .. "] not exists." )
      return false
    end
  elseif SQL.mode == 1 then

  end
end

function SQL_query( query )
  if SQL.mode == 0 then
    local _result = sql.Query( query )
    if _result == nil then
      print("sql_query NIL")
      return _result
    elseif _result == false then
      print("sql_query FALSE")
      return _result
    else
      return _result
    end
  elseif SQL.mode == 1 then

  end
end

if SERVER then
  timer.Simple( 2, function()
    --SQL_select( "yrp_groups", "*", "uniqueID = 1" )
    --SQL_select( "yrp_groups", "groupID", "uniqueID = 1" )
  end)
end

function SQL_select( db_table, db_columns, db_where )
  printGM( "db", "SQL_select" )
  if SQL.mode == 0 then
    if SQL_table_exists( db_table ) then
      local _q = "SELECT "
      _q = _q .. db_columns
      _q = _q .. " FROM " .. tostring( db_table )
      if db_where != nil then
        _q = _q .. " WHERE "
        _q = _q .. db_where
      end
      print( _q )
      local _result = SQL_query( _q )
      printTab(_result)
    end
  elseif SQL.mode == 1 then

  end
end

--[[ OLD ]]--
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
      printGM( "error", "db_insert_into_DEFAULTVALUES failed! query: " .. tostring( _q ) .. " result: " .. tostring( _result ) .. " lastError: " .. sql_show_last_error() )
      sql_show_last_error()
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
      printGM( "error", "db_insert_into: has failed! query: " .. tostring( _q ) .. " result: " .. tostring( _result ) .. " lastError: " .. sql_show_last_error() )
      sql_show_last_error()
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
      printGM( "error", "db_delete_from: has failed! query: " .. tostring( _q ) .. " result: " .. tostring(_result) .. " lastError: " .. sql_show_last_error() )
      sql_show_last_error()
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
      printGM( "error", "db_update failed! query: " .. tostring( _q ) .. " result: " .. tostring( _result ) .. " lastError: " .. sql_show_last_error() )
      sql_show_last_error()
    end
  end
end

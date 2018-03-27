--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

local SQL = {}
SQL.mode = 1

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
  SQL_update( "yrp_sql", "mode = " .. sqlmode, "uniqueID = 1" )
end

if SERVER then
  require("mysqloo")
  if (mysqloo.VERSION != "9" || !mysqloo.MINOR_VERSION || tonumber(mysqloo.MINOR_VERSION) < 1) then
  	MsgC(Color(255, 0, 0), "You are using an outdated mysqloo version\n")
  	MsgC(Color(255, 0, 0), "Download the latest mysqloo9 from here\n")
  	MsgC(Color(86, 156, 214), "https://github.com/syl0r/MySQLOO/releases")
  	return
  end

  local _sql_settings = sql.Query( "SELECT * FROM yrp_sql" )
  if _sql_settings != nil then
    _sql_settings = _sql_settings[1]
    SQL.mode = tonumber( _sql_settings.mode )
    SQL.database = _sql_settings.database
  end
  if SQL.mode == 1 then
    timer.Simple( 2,function()
      SQL.db = mysqloo.connect( _sql_settings.host, _sql_settings.username, _sql_settings.password, _sql_settings.database, tonumber( _sql_settings.port ) )
      SQL.db.onConnected = function()
        printGM( "db", "Connection worked!" )
        SetSQLMode( 1 )
      end
  	  SQL.db.onConnectionFailed = function()
        printGM( "db", "Connection failed, changing to SQLITE!" )
        SetSQLMode( 0 )
      end
  	  SQL.db:connect()
      timer.Simple( 2, function()
        SQL_create_table( "test2" )
        local test = SQL_select( "test2", "*", nil )
        print(test)
      end)
    end)
  end
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
    print("MYSQL")
    local que = SQL.db:query( query )
    que.onError = function(q,e)
      printGM( "db", "ERROR!" )
      printGM( "db", e )
      q:error()
    end
    que:start()
    return que:getData()
  end
end

function SQL_create_table( db_table )
  printGM( "db", "SQL_create_table" )

  if SQL.mode == 0 then
    local _q = "CREATE TABLE "
    _q = _q .. db_table .. " ( "
    _q = _q .. "uniqueID    INTEGER         PRIMARY KEY autoincrement"
    _q = _q .. " )"
    _q = _q .. ";"
    print( _q )
    if SQL_table_exists( db_table ) then
      local _result = SQL_query( _q )
      printTab(_result)
    end
  elseif SQL.mode == 1 then
    local _q = "CREATE TABLE "
    _q = _q .. SQL.database .. "." .. db_table .. " ( "
    _q = _q .. "uniqueID    INTEGER         PRIMARY KEY AUTO_INCREMENT"
    _q = _q .. " )"
    _q = _q .. ";"
    print( _q )
    SQL_query( _q )
  end
end

function SQL_select( db_table, db_columns, db_where )
  printGM( "db", "SQL_select" )
  local _q = "SELECT "
  _q = _q .. db_columns
  _q = _q .. " FROM " .. tostring( db_table )
  if db_where != nil then
    _q = _q .. " WHERE "
    _q = _q .. db_where
  end
  _q = _q .. ";"
  print( _q )

  if SQL.mode == 0 then
    if SQL_table_exists( db_table ) then
      local _result = SQL_query( _q )
      printTab(_result)
    end
  elseif SQL.mode == 1 then
    SQL_query( _q )
  end
end

function SQL_update( db_table, db_sets, db_where )
  printGM( "db", "SQL_update" )
  local _q = "UPDATE "
  _q = _q .. db_table
  _q = _q .. " SET " .. db_sets
  if db_where != nil then
    _q = _q .. " WHERE "
    _q = _q .. db_where
  end
  _q = _q .. ";"
  print( _q )

  if SQL.mode == 0 then
    if SQL_table_exists( db_table ) then
      SQL_query( _q )
    end
  elseif SQL.mode == 1 then
    SQL_query( _q )
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

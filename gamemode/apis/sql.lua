--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

--[[]]--
function disk_full( error )
  if string.find( error, "database or disk is full" ) then
    if SERVER then
      PrintMessage( HUD_PRINTCENTER, "database or disk is full, please make more space!" )
      net.Start( "yrp_noti" )
        net.WriteString( "database_full_server" )
        net.WriteString( "" )
      net.Broadcast()
    elseif CLIENT then
      local ply = LocalPlayer()

      ply:PrintMessage( HUD_PRINTTALK, "database or disk is full, please make more space!" )
      notification.AddLegacy( "[YourRP] Database or disk is full, please make more space!", NOTIFY_ERROR, 40 )
      printGM( "error", tostring( ply:SteamID() ) .. " (database or disk is full)" )
    end
  end
end

function sql_show_last_error()
  --printGM( "db", "sql_show_last_error()" )
  local _last_error = tostring( sql.LastError() ) or ""
  if SERVER then
    PrintMessage( HUD_PRINTCENTER, "[YourRP|DATABASE] SERVER-DATABASE:" )
    PrintMessage( HUD_PRINTCENTER, _last_error )
  elseif CLIENT then
    local ply = LocalPlayer()
    if ply != NULL and ply != nil then
      ply:PrintMessage( HUD_PRINTTALK, "[YourRP|DATABASE] CLIENT-DATABASE:" )
      ply:PrintMessage( HUD_PRINTTALK, _last_error )
    end
  end
  timer.Simple( 3, function()
    disk_full( _last_error )
  end)
  return _last_error
end

local _db_dc = {}
table.insert( _db_dc, " " )
table.insert( _db_dc, "'" )
table.insert( _db_dc, "´" )
table.insert( _db_dc, "`" )
table.insert( _db_dc, "#" )
table.insert( _db_dc, "*" )
table.insert( _db_dc, "+" )
table.insert( _db_dc, "-" )
table.insert( _db_dc, "(" )
table.insert( _db_dc, ")" )
table.insert( _db_dc, "[" )
table.insert( _db_dc, "]" )
table.insert( _db_dc, "{" )
table.insert( _db_dc, "}" )
table.insert( _db_dc, "^" )
table.insert( _db_dc, "°" )
table.insert( _db_dc, "!" )
table.insert( _db_dc, "§" )
table.insert( _db_dc, "$" )
table.insert( _db_dc, "&" )
table.insert( _db_dc, "/" )
table.insert( _db_dc, "=" )
table.insert( _db_dc, "\"" )
table.insert( _db_dc, "?" )
table.insert( _db_dc, "." )
table.insert( _db_dc, "," )
table.insert( _db_dc, ";" )
table.insert( _db_dc, "<" )
table.insert( _db_dc, ">" )
table.insert( _db_dc, "ü" )
table.insert( _db_dc, "ö" )
table.insert( _db_dc, "ä" )
table.insert( _db_dc, "Ü" )
table.insert( _db_dc, "Ö" )
table.insert( _db_dc, "Ä" )

function db_in_str( str )
  local _res = str
  for k, sym in pairs( _db_dc ) do
    local _pre = ""
    if k < 10 then
      _pre = "0"
    end
    _res = string.Replace( _res, sym, "%" .. _pre .. k )
  end
  return _res
end

function db_out_str( str )
  local _res = str

  for k, sym in pairs( _db_dc ) do
    local _pre = ""
    if k < 10 then
      _pre = "0"
    end
    _res = string.Replace( _res, "%" .. _pre .. k, sym )
  end

  _res = string.Replace( _res, "%", "'" )

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
    printGM( "error", "db_drop_table " .. tostring( db_table ) .. " failed! ( result: " .. tostring( _result ) .. " )" )
    sql_show_last_error()
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

function retry_load_database( db_name )
  printGM( "error", "retry_load_database " .. tostring( db_name ) )
  --SQL_INIT_DATABASE( db_name )
end

local _show_db_if_not_empty = false
function db_is_empty( db_name )
  local _tmp = SQL_SELECT( db_name, "*", nil )

  if worked( _tmp, db_name .. " is empty!" ) then
    if _show_db_if_not_empty then
      hr_pre()
      printGM( "db", db_name )
      printTab( _tmp, db_name )
      hr_pos()
    end
    return false
  else
    return true
  end
end

function db_worked( query )
  if query == nil then
    return "worked"
  else
    return "not worked"
  end
end
--[[]]--

--[[ NEW SQL API ]]--
YRPSQL = YRPSQL or {}
YRPSQL.mode = 0

function GetSQLMode()
  return YRPSQL.mode
end

function GetSQLModeName()
  if YRPSQL.mode == 0 then
    return "SQLITE"
  elseif YRPSQL.mode == 1 then
    return "MYSQL"
  end
end

function SetSQLMode( sqlmode )
  YRPSQL.mode = tonumber( sqlmode )
  local _q = "UPDATE "
  _q = _q .. "yrp_sql"
  _q = _q .. " SET " .. "mode = " .. sqlmode
  _q = _q .. " WHERE uniqueID = 1"
  _q = _q .. ";"

  sql.Query( _q )
end

function SQL_TABLE_EXISTS( db_table )
  --printGM( "db", "SQL_TABLE_EXISTS( " .. tostring( db_table ) .. " )" )
  if YRPSQL.mode == 0 then
    if sql.TableExists( db_table ) then
      return true
    else
      printGM( "note", "Table [" .. tostring( db_table ) .. "] not exists." )
      return false
    end
  elseif YRPSQL.mode == 1 then
    local _r = SQL_SELECT( db_table, "*", nil )
    if _r == nil or istable( _r ) then
      return true
    else
      printGM( "note", "Table [" .. tostring( db_table ) .. "] not exists." )
      return false
    end
  end
end

function SQL_QUERY( query )
  --printGM( "db", "SQL_QUERY( " .. tostring( query ) .. " )" )
  if YRPSQL.mode == 0 then
    local _result = sql.Query( query )
    if _result == nil then
      --printGM( "db", "SQL_QUERY TABLE EMPTY" )
      return _result
    elseif _result == false then
      printGM( "db", "SQL_QUERY TABLE MISSING OR NOTHING FOUND" )
      return _result
    else
      --printGM( "db", "ELSE" )
      return _result
    end
  elseif YRPSQL.mode == 1 then
    local que = YRPSQL.db:query( query )
    que.onError = function( q, e )
      if string.find( e, "Unknown column" ) == nil and string.find( e, "doesn't exist" ) == nil then
        printGM( "error", "SQL_QUERY - ERROR: " .. e )
        printGM( "error", query )
        q:error()
      end
    end
    que:start()
    que:wait( true )
    local _test = que:getData()
    if istable( _test ) then
      if #_test == 0 then
        --printGM( "db", "SQL_QUERY TABLE EMPTY 1" )
        return nil
      end
      return _test
    elseif _test == nil then
      --printGM( "db", "SQL_QUERY TABLE EMPTY 2" )
      return false
    else
      printGM( "db", "SQL_QUERY TABLE MISSING (" .. tostring( _test ) .. ")" )
      return false
    end
  end
end

function SQL_CREATE_TABLE( db_table )
  printGM( "db", "SQL_CREATE_TABLE( " .. tostring( db_table ) .. " )" )

  if YRPSQL.mode == 0 then
    local _q = "CREATE TABLE "
    _q = _q .. db_table .. " ( "
    _q = _q .. "uniqueID    INTEGER         PRIMARY KEY autoincrement"
    _q = _q .. " )"
    _q = _q .. ";"
    local _result = SQL_QUERY( _q )
    return _result
  elseif YRPSQL.mode == 1 then
    local _q = "CREATE TABLE "
    _q = _q .. YRPSQL.schema .. "." .. db_table .. " ( "
    _q = _q .. "uniqueID    INTEGER         PRIMARY KEY AUTO_INCREMENT"
    _q = _q .. " )"
    _q = _q .. ";"
    local _result = SQL_QUERY( _q )
    return _result
  end
end

function SQL_SELECT( db_table, db_columns, db_where )
  --printGM( "db", "SQL_SELECT( " .. tostring( db_table ) .. ", " .. tostring( db_columns ) .. ", " .. tostring( db_where ) .. " )" )
  if YRPSQL.mode == 0 then
    local _q = "SELECT "
    _q = _q .. db_columns
    _q = _q .. " FROM " .. tostring( db_table )
    if db_where != nil then
      _q = _q .. " WHERE "
      _q = _q .. db_where
    end
    _q = _q .. ";"

    return SQL_QUERY( _q )
  elseif YRPSQL.mode == 1 then
    local _q = "SELECT "
    _q = _q .. db_columns
    _q = _q .. " FROM " .. YRPSQL.schema .. "." .. tostring( db_table )
    if db_where != nil then
      _q = _q .. " WHERE "
      _q = _q .. db_where
    end
    _q = _q .. ";"

    return SQL_QUERY( _q )
  end
end

function SQL_UPDATE( db_table, db_sets, db_where )
  --printGM( "db", "SQL_UPDATE( " .. tostring( db_table ) .. ", " .. tostring( db_sets ) .. ", " .. tostring( db_where ) .. " )" )

  if YRPSQL.mode == 0 then
    local _q = "UPDATE "
    _q = _q .. db_table
    _q = _q .. " SET " .. db_sets
    if db_where != nil then
      _q = _q .. " WHERE "
      _q = _q .. db_where
    end
    _q = _q .. ";"

    return SQL_QUERY( _q )
  elseif YRPSQL.mode == 1 then
    local _q = "UPDATE "
    _q = _q .. YRPSQL.schema .. "." .. db_table
    _q = _q .. " SET " .. db_sets
    if db_where != nil then
      _q = _q .. " WHERE "
      _q = _q .. db_where
    end
    _q = _q .. ";"

    return SQL_QUERY( _q )
  end
end

function SQL_INSERT_INTO_DEFAULTVALUES( db_table )
  --printGM( "db", "SQL_INSERT_INTO_DEFAULTVALUES( " .. tostring( db_table ) .. " )" )
  if YRPSQL.mode == 0 then
    if SQL_TABLE_EXISTS( db_table ) then
      local _q = "INSERT INTO "
      _q = _q .. db_table
      _q = _q .. " DEFAULT VALUES"
      local _result = SQL_QUERY( _q )
      if _result != nil then
        printGM( "error", "SQL_INSERT_INTO_DEFAULTVALUES failed! query: " .. tostring( _q ) .. " result: " .. tostring( _result ) .. " lastError: " .. sql_show_last_error() )
      end
      return _result
    end
  elseif YRPSQL.mode == 1 then
    if SQL_TABLE_EXISTS( db_table ) then
      local _q = "INSERT INTO "
      _q = _q .. "'" .. YRPSQL.schema .. "." .. db_table .. "'"
      local _cols = {}
      local _vals = {}
      for i, col in pairs( YRPSQL[db_table] ) do
        table.insert( _cols, i )
        table.insert( _vals, col )
      end
      _cols = string.Implode( ",", _cols )
      _vals = string.Implode( ",", _vals )
      local _result = SQL_INSERT_INTO( db_table, _cols, _vals )

      if _result != nil then
        printGM( "error", "SQL_INSERT_INTO_DEFAULTVALUES failed! query: " .. tostring( _q ) .. " result: " .. tostring( _result ) )
      end
      return _result
    end
  end
end

function SQL_INSERT_INTO( db_table, db_columns, db_values )
  --printGM( "db", "SQL_INSERT_INTO( " .. tostring( db_table ) .. " | " .. tostring( db_columns ) .. " | " .. tostring( db_values ) .. " )" )
  if YRPSQL.mode == 0 then
    if SQL_TABLE_EXISTS( db_table ) then
      local _q = "INSERT INTO "
      _q = _q .. db_table
      _q = _q .. " ( "
      _q = _q .. db_columns
      _q = _q .. " ) VALUES ( "
      _q = _q .. db_values
      _q = _q .. " )"
      local _result = SQL_QUERY( _q )
      if _result != nil then
        printGM( "error", "SQL_INSERT_INTO: has failed! query: " .. tostring( _q ) .. " result: " .. tostring( _result ) .. " lastError: " .. sql_show_last_error() )
      end
      return _result
    end
  elseif YRPSQL.mode == 1 then
    if SQL_TABLE_EXISTS( db_table ) then
      local _v = string.Explode( ", ", db_values )
      local _ins = {}
      for i, col in pairs( string.Explode( ", ", db_columns ) ) do
        _ins[col] = _v[i]
      end

      local _tmp = YRPSQL[db_table]
      db_columns = ""
      db_values = ""
      local _count = 0
      for col, value in pairs( _tmp ) do
        for c, v in pairs( _ins ) do
          if c == col then
            _tmp[col] = v
            break
          end
        end
        if db_columns != "" then
          db_columns = db_columns .. "," .. col
          db_values = db_values .. "," .. _tmp[col]
        else
          db_columns = col
          db_values = _tmp[col]
        end
      end

      local _q = "INSERT INTO "
      _q = _q .. YRPSQL.schema .. "." .. db_table
      _q = _q .. " ( "
      _q = _q .. db_columns
      _q = _q .. " ) VALUES ( "
      _q = _q .. db_values
      _q = _q .. " )"

      local _result = SQL_QUERY( _q )
      if _result != nil then
        printGM( "error", "SQL_INSERT_INTO: has failed! query: " .. tostring( _q ) .. " result: " .. tostring( _result ) )
      end
      return _result
    end
  end
end

function SQL_DELETE_FROM( db_table, db_where )
  if YRPSQL.mode == 0 then
    if SQL_TABLE_EXISTS( db_table ) then
      local _q = "DELETE FROM "
      _q = _q .. db_table
      if db_where != nil then
        _q = _q .. " WHERE "
        _q = _q .. db_where
      end
      local _result = SQL_QUERY( _q )
      if _result != nil then
        printGM( "error", "SQL_DELETE_FROM: has failed! query: " .. tostring( _q ) .. " result: " .. tostring(_result) .. " lastError: " .. sql_show_last_error() )
      end
    end
  elseif YRPSQL.mode == 1 then
    if SQL_TABLE_EXISTS( db_table ) then
      local _q = "DELETE FROM "
      _q = _q .. db_table
      if db_where != nil then
        _q = _q .. " WHERE "
        _q = _q .. db_where
      end
      local _result = SQL_QUERY( _q )
      if _result != nil then
        printGM( "error", "SQL_DELETE_FROM: has failed! query: " .. tostring( _q ) .. " result: " .. tostring(_result) )
      end
    end
  end
end

function SQL_CHECK_IF_COLUMN_EXISTS( db_name, column_name )
  --printGM( "db", "SQL_CHECK_IF_COLUMN_EXISTS( " .. tostring( db_name ) .. ", " .. tostring( column_name ) .. " )" )
  if YRPSQL.mode == 0 then
    local _result = SQL_SELECT( db_name, column_name, nil )
    if _result == false then
      return false
    else
      return true
    end
  elseif YRPSQL.mode == 1 then
    local _result = SQL_SELECT( db_name, column_name, nil )
    if _result == false then
      return false
    else
      return true
    end
  end
end

function SQL_ADD_COLUMN( table_name, column_name, datatype )
  --printGM( "db", "SQL_ADD_COLUMN( " .. tostring( table_name ) .. ", " .. tostring( column_name ) .. ", " .. tostring( datatype ) .. " )" )
  local _result = SQL_CHECK_IF_COLUMN_EXISTS( table_name, column_name )
  if YRPSQL.mode == 0 then
    if !_result then
      local _q = "ALTER TABLE " .. table_name .. " ADD " .. column_name .. " " .. datatype .. ""
      local _r = SQL_QUERY( _q )
      if _r != nil then
        printGM( "error", "SQL_ADD_COLUMN failed! query: " .. tostring( _q ) .. " result: " .. tostring( _result ) .. " lastError: " .. sql_show_last_error() )
      end
      return _r
    end
  elseif YRPSQL.mode == 1 then
    --[[ MYSQL DEFAULT VALUES FIX ]]--
    if YRPSQL[table_name] == nil then
      YRPSQL[table_name] = {}
    end
    if YRPSQL[table_name][column_name] == nil then
      local _start, _end = string.find( datatype, "DEFAULT ", 1 )
      if _end != nil then
        local _default_value = string.sub( datatype, _end+1 )
        YRPSQL[table_name][column_name] = _default_value
      elseif string.find( datatype,"TEXT" ) != nil then
        YRPSQL[table_name][column_name] = "''"
      elseif string.find( datatype,"INT" ) != nil then
        YRPSQL[table_name][column_name] = "1"
      end
    end
    if !_result then
      if string.find( datatype, "TEXT" ) then
        datatype = "TEXT"
      end
      local _q = "ALTER TABLE " .. YRPSQL.schema .. "." .. table_name .. " ADD " .. column_name .. " " .. datatype .. ""
      local _r = SQL_QUERY( _q )
      if _r != nil then
        printGM( "error", "SQL_ADD_COLUMN failed! query: " .. tostring( _q ) .. " result: " .. tostring( _r ) )
      end
      return _r
    end
  end
end

function SQL_INIT_DATABASE( db_name )
  printGM( "db", "SQL_INIT_DATABASE( " .. tostring( db_name ) .. " )" )
  if YRPSQL.mode == 0 then
    if SQL_TABLE_EXISTS( db_name ) then
      --printGM( "db", db_name .. " exists" )
    else
      --printGM( "note", tostring( db_name ) .. " not exists" )
      local _result = SQL_CREATE_TABLE( db_name )

      if _result != nil then
        printGM( "error", "SQL_INIT_DATABASE failed! query: " .. tostring( _query ) .. " result: " .. tostring( _result ) .. " lastError: " .. sql_show_last_error() )
      end
  		if sql.TableExists( tostring( db_name ) ) then
        --printGM( "db", db_name .. _yrp.successdb )
  		else
  			printGM( "error", "CREATE TABLE " .. tostring( db_name ) .. " fail" )
        sql_show_last_error()
        retry_load_database( db_name )
  		end
    end
  elseif YRPSQL.mode == 1 then
    if SQL_TABLE_EXISTS( db_name ) then
      --printGM( "db", db_name .. " exists" )
    else
      --printGM( "note", tostring( db_name ) .. " not exists" )
      local _result = SQL_CREATE_TABLE( db_name )
    end
  end
end

if SERVER then
  --[[ MYSQL ]]--
  require( "mysqloo" )
  if (mysqloo.VERSION != "9" || !mysqloo.MINOR_VERSION || tonumber(mysqloo.MINOR_VERSION) < 1) then
  	MsgC(Color(255, 0, 0), "You are using an outdated mysqloo version\n")
  	MsgC(Color(255, 0, 0), "Download the latest mysqloo9 from here\n")
  	MsgC(Color(86, 156, 214), "https://github.com/syl0r/MySQLOO/releases")
  	return
  end

  --[[ SQLMODE ]]--
  if !sql.TableExists( "yrp_sql" ) then
    local _q = "CREATE TABLE "
    _q = _q .. "yrp_sql" .. " ( "
    _q = _q .. "uniqueID    INTEGER         PRIMARY KEY autoincrement"
    _q = _q .. " )"
    _q = _q .. ";"
    sql.Query( _q )
  end

  local _sql_settings = sql.Query( "SELECT * FROM yrp_sql" )
  if _sql_settings != nil then
    _sql_settings = _sql_settings[1]
    SetSQLMode( tonumber( _sql_settings.mode ) )
    YRPSQL.schema = _sql_settings.database
  end

  if YRPSQL.mode == 1 then
    printGM( "db", "CONNECT TO DATABASE" )
    YRPSQL.db = mysqloo.connect( _sql_settings.host, _sql_settings.username, _sql_settings.password, _sql_settings.database, tonumber( _sql_settings.port ) )
    YRPSQL.db.onConnected = function()
      printGM( "note", "CONNECTED!" )
      SetSQLMode( 1 )
      SQL_QUERY( "SET @@global.sql_mode='MYSQL40'" )
    end
	  YRPSQL.db.onConnectionFailed = function()
      printGM( "note", "CONNECTION failed, changing to SQLITE!" )
      SetSQLMode( 0 )
    end
	  YRPSQL.db:connect()
  elseif YRPSQL.mode == 0 then
    --
  end
end
printGM( "db", "Current SQL Mode: " .. GetSQLModeName() )

--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

-- DO NOT TOUCH THE DATABASE FILES! If you have errors, report them here:
-- https://discord.gg/sEgNZxg

util.AddNetworkString( "get_sql_info" )

util.AddNetworkString( "set_host" )
util.AddNetworkString( "set_port" )
util.AddNetworkString( "set_database" )
util.AddNetworkString( "set_username" )
util.AddNetworkString( "set_password" )

local _db_name = "yrp_sql"

function SQLITE_CHECK_IF_COLUMN_EXISTS( db_name, column_name )
  --printGM( "db", "SQL_CHECK_IF_COLUMN_EXISTS( " .. tostring( db_name ) .. ", " .. tostring( column_name ) .. " )" )
  local _result = sql.Query( "SELECT " .. column_name .. " FROM " .. db_name )
  if _result == false then
    return false
  else
    return true
  end
end

function SQLITE_ADD_COLUMN( table_name, column_name, datatype )
  --printGM( "db", "SQL_ADD_COLUMN( " .. tostring( table_name ) .. ", " .. tostring( column_name ) .. ", " .. tostring( datatype ) .. " )" )
  local _result = SQLITE_CHECK_IF_COLUMN_EXISTS( table_name, column_name )
  if !_result then
    local _q = "ALTER TABLE " .. table_name .. " ADD " .. column_name .. " " .. datatype .. ""
    local _r = sql.Query( _q )
    if _r != nil then
      printGM( "error", "SQLITE_ADD_COLUMN failed! query: " .. tostring( _q ) .. " result: " .. tostring( _result ) .. " lastError: " .. sql_show_last_error() )
    end
    return _r
  end
end

SQLITE_ADD_COLUMN( _db_name, "mode", "INT DEFAULT '0'", true )
SQLITE_ADD_COLUMN( _db_name, "host", "TEXT DEFAULT 'UNKNOWN HOST'", true )
SQLITE_ADD_COLUMN( _db_name, "database", "TEXT DEFAULT 'UNKNOWN DATABASE'", true )
SQLITE_ADD_COLUMN( _db_name, "username", "TEXT DEFAULT 'UNKNOWN USERNAME'", true )
SQLITE_ADD_COLUMN( _db_name, "password", "TEXT DEFAULT 'ADMIN'", true )
SQLITE_ADD_COLUMN( _db_name, "port", "INT DEFAULT '12345'", true )

if sql.Query( "SELECT * FROM yrp_sql" ) == nil then
  printGM( "db", "Missing first entry, insert it now!" )
  sql.Query( "INSERT INTO yrp_sql DEFAULT VALUES" )
end

net.Receive( "get_sql_info", function( len, ply )
  local _sql_info = sql.Query( "SELECT * FROM " .. _db_name )

  if _sql_info != nil and _sql_info != false then
    _sql_info = _sql_info[1]
    net.Start( "get_sql_info" )
      net.WriteTable( _sql_info )
    net.Send( ply )
  end
end)

net.Receive( "set_host", function( len, ply )
  local _host = net.ReadString()

  local _q = "UPDATE "
  _q = _q .. _db_name
  _q = _q .. " SET " .. "host = '" .. _host .. "'"
  _q = _q .. " WHERE "
  _q = _q .. "uniqueID = 1"
  _q = _q .. ";"

  local test = sql.Query( _q )
end)

net.Receive( "set_port", function( len, ply )
  local _port = net.ReadString()

  local _q = "UPDATE "
  _q = _q .. _db_name
  _q = _q .. " SET " .. "port = '" .. _port .. "'"
  _q = _q .. " WHERE "
  _q = _q .. "uniqueID = 1"
  _q = _q .. ";"

  local test = sql.Query( _q )
end)

net.Receive( "set_database", function( len, ply )
  local _database = net.ReadString()

  local _q = "UPDATE "
  _q = _q .. _db_name
  _q = _q .. " SET " .. "database = '" .. _database .. "'"
  _q = _q .. " WHERE "
  _q = _q .. "uniqueID = 1"
  _q = _q .. ";"

  local test = sql.Query( _q )
end)

net.Receive( "set_username", function( len, ply )
  local _username = net.ReadString()

  local _q = "UPDATE "
  _q = _q .. _db_name
  _q = _q .. " SET " .. "username = '" .. _username .. "'"
  _q = _q .. " WHERE "
  _q = _q .. "uniqueID = 1"
  _q = _q .. ";"

  local test = sql.Query( _q )
end)

net.Receive( "set_password", function( len, ply )
  local _password = net.ReadString()

  local _q = "UPDATE "
  _q = _q .. _db_name
  _q = _q .. " SET " .. "password = '" .. _password .. "'"
  _q = _q .. " WHERE "
  _q = _q .. "uniqueID = 1"
  _q = _q .. ";"

  local test = sql.Query( _q )
end)

util.AddNetworkString( "change_to_sql_mode" )
net.Receive( "change_to_sql_mode", function( len, ply )
  local _mode = tonumber( net.ReadString() )
  if ply:HasAccess() then
    SetSQLMode( _mode )
    printGM( "note", ply:YRPName() .. " changed sqlmode to " .. GetSQLModeName() )
    timer.Simple( 1, function()
      game.ConsoleCommand( "changelevel " .. game.GetMap() .. "\n" )
    end)
  else
    printGM( "note", ply:YRPName() .. " tried to use change_to_sql_mode" )
  end
end)

--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

-- DO NOT TOUCH THE DATABASE FILES! If you have errors, report them here:
-- https://discord.gg/sEgNZxg

util.AddNetworkString( "get_sql_info" )

util.AddNetworkString( "set_sql_mode" )
util.AddNetworkString( "set_host" )
util.AddNetworkString( "set_port" )
util.AddNetworkString( "set_database" )
util.AddNetworkString( "set_username" )
util.AddNetworkString( "set_password" )

local _db_name = "yrp_sql"

sql_add_column( _db_name, "mode", "INT DEFAULT '0'" )
sql_add_column( _db_name, "host", "TEXT DEFAULT 'UNKNOWN HOST'" )
sql_add_column( _db_name, "database", "TEXT DEFAULT 'UNKNOWN DATABASE'" )
sql_add_column( _db_name, "username", "TEXT DEFAULT 'UNKNOWN USERNAME'" )
sql_add_column( _db_name, "password", "TEXT DEFAULT 'ADMIN'" )
sql_add_column( _db_name, "port", "INT DEFAULT '12345'" )

if db_select( _db_name, "*", nil ) == nil then
  printGM( "db", "Missing first entry, insert it now!" )
  db_insert_into_DEFAULTVALUES( _db_name )
end

net.Receive( "get_sql_info", function( len, ply )
  local _sql_info = db_select( _db_name, "*", nil )
  if _sql_info != nil then
    _sql_info = _sql_info[1]
    net.Start( "get_sql_info" )
      net.WriteTable( _sql_info )
    net.Send( ply )
  end
end)

net.Receive( "set_sql_mode", function( len, ply )
  local _mode = net.ReadInt( 4 )

  local test = db_update( _db_name, "mode = '" .. _mode .. "'", "uniqueID = 1" )
end)

net.Receive( "set_host", function( len, ply )
  local _host = net.ReadString()

  local test = db_update( _db_name, "host = '" .. _host .. "'", "uniqueID = 1" )
end)

net.Receive( "set_port", function( len, ply )
  local _port = net.ReadString()

  local test = db_update( _db_name, "port = '" .. _port .. "'", "uniqueID = 1" )
end)

net.Receive( "set_database", function( len, ply )
  local _database = net.ReadString()

  local test = db_update( _db_name, "database = '" .. _database .. "'", "uniqueID = 1" )
end)

net.Receive( "set_username", function( len, ply )
  local _username = net.ReadString()

  local test = db_update( _db_name, "username = '" .. _username .. "'", "uniqueID = 1" )
end)

net.Receive( "set_password", function( len, ply )
  local _password = net.ReadString()

  local test = db_update( _db_name, "password = '" .. _password .. "'", "uniqueID = 1" )
end)

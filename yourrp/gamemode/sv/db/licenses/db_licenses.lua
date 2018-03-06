--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

-- DO NOT TOUCH THE DATABASE FILES! If you have errors, report them here:
-- https://discord.gg/sEgNZxg

local _db_name = "yrp_licenses"

sql_add_column( _db_name, "name", "TEXT DEFAULT 'UNNAMED'" )
sql_add_column( _db_name, "description", "TEXT DEFAULT '-'" )
sql_add_column( _db_name, "price", "TEXT DEFAULT '100'" )

--db_drop_table( _db_name )
--db_is_empty( _db_name )

function send_licenses( ply )
  local _all = db_select( _db_name, "*", nil )
  local _nm = _all
  if _nm == nil or _nm == false then
    _nm = {}
  end
  net.Start( "get_licenses" )
    net.WriteTable( _nm )
  net.Send( ply )
end

util.AddNetworkString( "get_licenses" )

net.Receive( "get_licenses", function( len, ply )
  send_licenses( ply )
end)

util.AddNetworkString( "licence_add" )

net.Receive( "licence_add", function( len, ply )
  local _new = db_insert_into( _db_name, "name", "'new licence'" )
  printGM( "db", "Add new licence: " .. tostring( _new ) )

  send_licenses( ply )
end)

util.AddNetworkString( "licence_rem" )

net.Receive( "licence_rem", function( len, ply )
  local _uid = net.ReadString()
  local _new = db_delete_from( _db_name, "uniqueID = " .. _uid )
  printGM( "db", "Removed licence: " .. tostring( _uid ) )

  send_licenses( ply )
end)

util.AddNetworkString( "edit_licence_name" )

net.Receive( "edit_licence_name", function( len, ply )
  local _uid = net.ReadString()
  local _new_name = db_in_str( net.ReadString() )
  local _edit = db_update( _db_name, "name = '" .. _new_name .. "'", "uniqueID = " .. _uid )
  printGM( "db", "edit_licence_name: " .. tostring( db_out_str( _new_name ) ) )
end)

util.AddNetworkString( "edit_licence_description" )

net.Receive( "edit_licence_description", function( len, ply )
  local _uid = net.ReadString()
  local _new_description = db_in_str( net.ReadString() )
  local _edit = db_update( _db_name, "description = '" .. _new_description .. "'", "uniqueID = " .. _uid )
  printGM( "db", "edit_licence_description: " .. tostring( db_out_str( _new_description ) ) )
end)

util.AddNetworkString( "edit_licence_price" )

net.Receive( "edit_licence_price", function( len, ply )
  local _uid = net.ReadString()
  local _new_price = db_in_str( net.ReadString() )
  local _edit = db_update( _db_name, "price = " .. _new_price, "uniqueID = " .. _uid )
  printGM( "db", "edit_licence_price: " .. tostring( db_out_str( _new_price ) ) )
end)

util.AddNetworkString( "get_all_licenses_simple" )

net.Receive( "get_all_licenses_simple", function( len, ply )
  local _all = db_select( _db_name, "name, uniqueID", nil )
  net.Start( "get_all_licenses_simple" )
    net.WriteTable( _all )
  net.Send( ply )
end)

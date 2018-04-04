--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

-- DO NOT TOUCH THE DATABASE FILES! If you have errors, report them here:
-- https://discord.gg/sEgNZxg

local _db_name = "yrp_licenses"

SQL_ADD_COLUMN( _db_name, "name", "TEXT DEFAULT 'UNNAMED'" )
SQL_ADD_COLUMN( _db_name, "description", "TEXT DEFAULT '-'" )
SQL_ADD_COLUMN( _db_name, "price", "TEXT DEFAULT '100'" )

--db_drop_table( _db_name )
--db_is_empty( _db_name )

function send_licenses( ply )
  local _all = SQL_SELECT( _db_name, "*", nil )
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

function sendlicenses( ply )
  local _all = SQL_SELECT( _db_name, "*", nil )
  local _nm = _all
  if _nm == nil or _nm == false then
    _nm = {}
  end
  net.Start( "getlicenses" )
    net.WriteTable( _nm )
  net.Send( ply )
end

util.AddNetworkString( "getlicenses" )

net.Receive( "getlicenses", function( len, ply )
  sendlicenses( ply )
end)

util.AddNetworkString( "licence_add" )

net.Receive( "licence_add", function( len, ply )
  local _new = SQL_INSERT_INTO( _db_name, "name", "'new licence'" )
  printGM( "db", "Add new licence: " .. tostring( _new ) )

  send_licenses( ply )
end)

util.AddNetworkString( "licence_rem" )

net.Receive( "licence_rem", function( len, ply )
  local _uid = net.ReadString()
  local _new = SQL_DELETE_FROM( _db_name, "uniqueID = " .. _uid )
  printGM( "db", "Removed licence: " .. tostring( _uid ) )

  send_licenses( ply )
end)

util.AddNetworkString( "edit_licence_name" )

net.Receive( "edit_licence_name", function( len, ply )
  local _uid = net.ReadString()
  local _new_name = db_in_str( net.ReadString() )
  local _edit = SQL_UPDATE( _db_name, "name = '" .. _new_name .. "'", "uniqueID = " .. _uid )
  printGM( "db", "edit_licence_name: " .. tostring( db_out_str( _new_name ) ) )
end)

util.AddNetworkString( "edit_licence_description" )

net.Receive( "edit_licence_description", function( len, ply )
  local _uid = net.ReadString()
  local _new_description = db_in_str( net.ReadString() )
  local _edit = SQL_UPDATE( _db_name, "description = '" .. _new_description .. "'", "uniqueID = " .. _uid )
  printGM( "db", "edit_licence_description: " .. tostring( db_out_str( _new_description ) ) )
end)

util.AddNetworkString( "edit_licence_price" )

net.Receive( "edit_licence_price", function( len, ply )
  local _uid = net.ReadString()
  local _new_price = db_in_str( net.ReadString() )
  local _edit = SQL_UPDATE( _db_name, "price = " .. _new_price, "uniqueID = " .. _uid )
  printGM( "db", "edit_licence_price: " .. tostring( db_out_str( _new_price ) ) )
end)

util.AddNetworkString( "get_all_licenses_simple" )

net.Receive( "get_all_licenses_simple", function( len, ply )
  local _all = SQL_SELECT( _db_name, "name, uniqueID", nil )
  net.Start( "get_all_licenses_simple" )
    net.WriteTable( _all )
  net.Send( ply )
end)

util.AddNetworkString( "get_role_licenses" )

net.Receive( "get_role_licenses", function( len, ply )
  local _licenses = SQL_SELECT( _db_name, "*", nil )

  if _licenses == nil then
    _licenses = {}
  end

  net.Start( "get_role_licenses" )
    net.WriteTable( _licenses )
  net.Send( ply )
end)

util.AddNetworkString( "role_add_license" )

net.Receive( "role_add_license", function( len, ply )
  local _role_uid = net.ReadString()
  local _license_uid = net.ReadString()

  local _role = SQL_SELECT( "yrp_roles", "licenseIDs", "uniqueID = " .. _role_uid )
  if _role != nil then
    _role = _role[1]
    local _licenseIDs = {}
    if _role.licenseIDs != "" then
      _licenseIDs = string.Explode( ",", _role.licenseIDs )
    end
    if !table.HasValue( _licenseIDs, _license_uid ) then
      table.insert( _licenseIDs, _license_uid )
      _licenseIDs = string.Implode( ",", _licenseIDs )

      SQL_UPDATE( "yrp_roles", "licenseIDs = '" .. _licenseIDs .. "'" ,"uniqueID = " .. _role_uid )
    end
  end
end)

util.AddNetworkString( "role_rem_license" )

net.Receive( "role_rem_license", function( len, ply )
  local _role_uid = net.ReadString()
  local _license_uid = net.ReadString()

  local _role = SQL_SELECT( "yrp_roles", "licenseIDs", "uniqueID = " .. _role_uid )
  if _role != nil then
    _role = _role[1]
    local _licenseIDs = {}
    if _role.licenseIDs != "" then
      _licenseIDs = string.Explode( ",", _role.licenseIDs )
    end

    if table.HasValue( _licenseIDs, _license_uid ) then
      table.RemoveByValue( _licenseIDs, _license_uid )

      _licenseIDs = string.Implode( ",", _licenseIDs )

      SQL_UPDATE( "yrp_roles", "licenseIDs = '" .. _licenseIDs .. "'" ,"uniqueID = " .. _role_uid )
    end
  end
end)

local Player = FindMetaTable( "Player" )
function Player:AddLicense( license )
  local _licenseIDs = self:GetNWString( "licenseIDs", "" )

  _licenseIDs = string.Explode( ",", _licenseIDs )
  if !table.HasValue( _licenseIDs, license ) then
    table.insert( _licenseIDs, license )
  end
  if table.HasValue( _licenseIDs, "" ) then
    table.RemoveByValue( _licenseIDs, "" )
  end
  _licenseIDs = string.Implode( ",", _licenseIDs )

  self:SetNWString( "licenseIDs", tostring( _licenseIDs ) )
end

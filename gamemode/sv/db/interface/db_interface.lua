--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

-- DO NOT TOUCH THE DATABASE FILES! If you have errors, report them here:
-- https://discord.gg/sEgNZxg

local _db_name = "yrp_interface"

SQL_ADD_COLUMN( _db_name, "color", "TEXT DEFAULT ''" )
SQL_ADD_COLUMN( _db_name, "style", "TEXT DEFAULT ''" )
SQL_ADD_COLUMN( _db_name, "design", "TEXT DEFAULT ''" )
SQL_ADD_COLUMN( _db_name, "rounded", "INT DEFAULT '0'" )
SQL_ADD_COLUMN( _db_name, "transparent", "INT DEFAULT '1'" )
SQL_ADD_COLUMN( _db_name, "border", "INT DEFAULT '0'" )

--db_drop_table( _db_name )
--db_is_empty( _db_name )

if SQL_SELECT( "yrp_interface", "*", "uniqueID = 1" ) == nil then
  SQL_INSERT_INTO( _db_name, "color, style, design, rounded, transparent, border", "'blue', 'dark', 'Material Design 1', '1', '1', '1'" )
end

util.AddNetworkString( "get_interface_settings" )
net.Receive( "get_interface_settings", function( len, ply )
  local _tbl = SQL_SELECT( "yrp_interface", "*", "uniqueID = 1" )

  if _tbl != nil then
    _tbl = _tbl[1]
    net.Start( "get_interface_settings" )
      net.WriteTable( _tbl)
    net.Send( ply )
  end
end)

util.AddNetworkString( "set_interface_design" )
net.Receive( "set_interface_design", function( len, ply )
  local _design = net.ReadString()
  SQL_UPDATE( _db_name, "design = '" .. _design .. "'", "uniqueID = 1" )
  for i, pl in pairs( player.GetAll() ) do
    pl:SetNWString( "interface_design", _design )
  end
end)

util.AddNetworkString( "set_interface_style" )
net.Receive( "set_interface_style", function( len, ply )
  local _style = net.ReadString()
  SQL_UPDATE( _db_name, "style = '" .. _style .. "'", "uniqueID = 1" )
  for i, pl in pairs( player.GetAll() ) do
    pl:SetNWString( "interface_style", _style )
  end
end)

util.AddNetworkString( "set_interface_color" )
net.Receive( "set_interface_color", function( len, ply )
  local _color = net.ReadString()
  SQL_UPDATE( _db_name, "color = '" .. _color .. "'", "uniqueID = 1" )
  for i, pl in pairs( player.GetAll() ) do
    pl:SetNWString( "interface_color", _color )
  end
end)

util.AddNetworkString( "set_interface_transparent" )
net.Receive( "set_interface_transparent", function( len, ply )
  local _transparent = net.ReadString()
  SQL_UPDATE( _db_name, "transparent = '" .. _transparent .. "'", "uniqueID = 1" )
  for i, pl in pairs( player.GetAll() ) do
    pl:SetNWBool( "interface_transparent", tobool( _transparent ) )
  end
end)

util.AddNetworkString( "set_interface_border" )
net.Receive( "set_interface_border", function( len, ply )
  local _border = net.ReadString()
  SQL_UPDATE( _db_name, "border = '" .. _border .. "'", "uniqueID = 1" )
  for i, pl in pairs( player.GetAll() ) do
    pl:SetNWBool( "interface_border", tobool( _border ) )
  end
end)

util.AddNetworkString( "set_interface_rounded" )
net.Receive( "set_interface_rounded", function( len, ply )
  local _rounded = net.ReadString()
  SQL_UPDATE( _db_name, "rounded = '" .. _rounded .. "'", "uniqueID = 1" )
  for i, pl in pairs( player.GetAll() ) do
    pl:SetNWBool( "interface_rounded", tobool( _rounded ) )
  end
end)

function SetDesign( ply )
  local _tbl = SQL_SELECT( "yrp_interface", "*", "uniqueID = 1" )
  if _tbl != nil then
    _tbl = _tbl[1]
    ply:SetNWString( "interface_design", _tbl.design )
    ply:SetNWString( "interface_color", _tbl.color )
    ply:SetNWString( "interface_style", _tbl.style )
    ply:SetNWBool( "interface_transparent", tobool( _tbl.transparent ) )
    ply:SetNWBool( "interface_rounded", tobool( _tbl.rounded ) )
    ply:SetNWBool( "interface_border", tobool( _tbl.border ) )
  end
end

util.AddNetworkString( "get_design" )
net.Receive( "get_design", function( len, ply )
  SetDesign( ply )
end)

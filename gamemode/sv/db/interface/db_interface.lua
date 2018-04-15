--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

-- DO NOT TOUCH THE DATABASE FILES! If you have errors, report them here:
-- https://discord.gg/sEgNZxg

local _db_name = "yrp_interface"

SQL_ADD_COLUMN( _db_name, "color", "TEXT DEFAULT ''" )
SQL_ADD_COLUMN( _db_name, "style", "TEXT DEFAULT ''" )
SQL_ADD_COLUMN( _db_name, "design", "TEXT DEFAULT ''" )
SQL_ADD_COLUMN( _db_name, "rounded", "INT DEFAULT '1'" )
SQL_ADD_COLUMN( _db_name, "transparent", "INT DEFAULT '1'" )

--db_drop_table( _db_name )
--db_is_empty( _db_name )

if SQL_SELECT( "yrp_interface", "*", "uniqueID = 1" ) == nil then
  SQL_INSERT_INTO( _db_name, "color, style, design, rounded, transparent", "'blue', 'dark', 'material1', '1', '1'" )
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

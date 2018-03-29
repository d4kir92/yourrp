--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

-- DO NOT TOUCH THE DATABASE FILES! If you have errors, report them here:
-- https://discord.gg/sEgNZxg

local _db_name = "yrp_money"

SQL_ADD_COLUMN( _db_name, "name", "TEXT DEFAULT 'NAME'" )
SQL_ADD_COLUMN( _db_name, "value", "TEXT DEFAULT '0'" )

if SQL_SELECT( _db_name, "*", "name = 'moneypre'" ) == nil then
  SQL_INSERT_INTO( _db_name, "name, value", "'moneypre', '$'" )
end

if SQL_SELECT( _db_name, "*", "name = 'moneypost'" ) == nil then
  SQL_INSERT_INTO( _db_name, "name, value", "'moneypost', ''" )
end

if SQL_SELECT( _db_name, "*", "name = 'moneystart'" ) == nil then
  SQL_INSERT_INTO( _db_name, "name, value", "'moneystart', '1000'" )
end

--db_drop_table( _db_name )
--db_is_empty( _db_name )

util.AddNetworkString( "getMoneyTab" )
util.AddNetworkString( "updateMoney" )

net.Receive( "updateMoney", function( len, ply )
  local _name = net.ReadString()
  local _value = net.ReadString()

  SQL_UPDATE( "yrp_money", "value = '" .. _value .. "'", "name = '" .. _name .. "'" )
  --updateHud( ply )
end)

net.Receive( "getMoneyTab", function( len, ply )
  local _tmpTable = SQL_SELECT( "yrp_money", "*", nil )
  net.Start( "getMoneyTab" )
    net.WriteTable( _tmpTable )
  net.Send( ply )
end)

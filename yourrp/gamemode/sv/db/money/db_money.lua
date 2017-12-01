--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

-- DO NOT TOUCH THE DATABASE FILES! If you have errors, report them here:
-- https://discord.gg/sEgNZxg

local _db_name = "yrp_money"

sql_add_column( _db_name, "name", "TEXT DEFAULT 'NAME'" )
sql_add_column( _db_name, "value", "TEXT DEFAULT '0'" )

if db_select( _db_name, "*", "name = 'moneypre'" ) == nil then
  db_insert_into( _db_name, "name, value", "'moneypre', '$'" )
end

if db_select( _db_name, "*", "name = 'moneypost'" ) == nil then
  db_insert_into( _db_name, "name, value", "'moneypost', ''" )
end

if db_select( _db_name, "*", "name = 'moneystart'" ) == nil then
  db_insert_into( _db_name, "name, value", "'moneystart', '1000'" )
end

--db_drop_table( _db_name )
--db_is_empty( _db_name )

util.AddNetworkString( "getMoneyTab" )
util.AddNetworkString( "updateMoney" )

net.Receive( "updateMoney", function( len, ply )
  local _name = net.ReadString()
  local _value = net.ReadString()

  db_update( "yrp_money", "value = '" .. _value .. "'", "name = '" .. _name .. "'" )
  --updateHud( ply )
end)

net.Receive( "getMoneyTab", function( len, ply )
  local _tmpTable = db_select( "yrp_money", "*", nil )
  net.Start( "getMoneyTab" )
    net.WriteTable( _tmpTable )
  net.Send( ply )
end)

--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

--db_money.lua

include( "money/db_net.lua" )
include( "money/db_func.lua" )

local dbTable = "yrp_money"

sqlAddColumn( dbTable, "name", "TEXT DEFAULT 'NAME'" )
sqlAddColumn( dbTable, "value", "TEXT DEFAULT '0'" )

if dbSelect( "yrp_money", "*", "name = 'moneypre'" ) == nil then
  dbInsertInto( "yrp_money", "name, value", "'moneypre', '$'" )
end

if dbSelect( "yrp_money", "*", "name = 'moneypost'" ) == nil then
  dbInsertInto( "yrp_money", "name, value", "'moneypost', ''" )
end

if dbSelect( "yrp_money", "*", "name = 'moneystart'" ) == nil then
  dbInsertInto( "yrp_money", "name, value", "'moneystart', '1000'" )
end

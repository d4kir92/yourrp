--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

-- DO NOT TOUCH THE DATABASE FILES! If you have errors, report them here:
-- https://discord.gg/sEgNZxg

local _db_name = "yrp_money"

SQL_ADD_COLUMN( _db_name, "moneypre", "TEXT DEFAULT '$'" )
SQL_ADD_COLUMN( _db_name, "moneypos", "TEXT DEFAULT ''" )
SQL_ADD_COLUMN( _db_name, "moneystart", "TEXT DEFAULT '1000'" )

if SQL_SELECT( _db_name, "*", "uniqueID = 1" ) == nil then
  SQL_INSERT_INTO_DEFAULTVALUES( _db_name )
end

--db_drop_table( _db_name )
--db_is_empty( _db_name )

local yrp_money = {}
local _tmp = SQL_SELECT( _db_name, "*", "uniqueID = 1" )
if _tmp != nil and _tmp != false then
  yrp_money = _tmp[1]
end

function GetMoneyPre()
  return yrp_money.moneypre
end
function GetMoneyPos()
  return yrp_money.moneypos
end
function GetMoneyStart()
  return yrp_money.moneystart
end

util.AddNetworkString( "getMoneyTab" )
util.AddNetworkString( "updateMoney" )

net.Receive( "updateMoney", function( len, ply )
  local _name = net.ReadString()
  local _value = net.ReadString()
  yrp_money[_name] = _value
  SQL_UPDATE( "yrp_money", _name .. " = '" .. _value .. "'", "uniqueID = 1" )
  if _name == "moneypre" or _name == "moneypos" then
    for i, pl in pairs( player.GetAll() ) do
      pl:SetNWString( _name, _value )
    end
  end
end)

net.Receive( "getMoneyTab", function( len, ply )
  if ply:CanAccess( "money" ) then
    local _tmpTable = SQL_SELECT( "yrp_money", "*", nil )
    net.Start( "getMoneyTab" )
      net.WriteTable( _tmpTable[1] )
    net.Send( ply )
  end
end)

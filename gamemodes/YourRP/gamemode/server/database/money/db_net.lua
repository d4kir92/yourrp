//db_net.lua

util.AddNetworkString( "getMoneyTab" )
util.AddNetworkString( "updateMoney" )

net.Receive( "updateMoney", function( len, ply )
  local _name = net.ReadString()
  local _value = net.ReadString()

  dbUpdate( "yrp_money", "value = '" .. _value .. "'", "name = '" .. _name .. "'" )
  updateHud( ply )
end)

net.Receive( "getMoneyTab", function( len, ply )
  local _tmpTable = dbSelect( "yrp_money", "*", nil )
  net.Start( "getMoneyTab" )
    net.WriteTable( _tmpTable )
  net.Send( ply )
end)

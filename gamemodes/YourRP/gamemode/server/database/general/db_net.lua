
//##############################################################################
//utils
util.AddNetworkString( "selectGeneral" )
util.AddNetworkString( "updateGeneral" )
util.AddNetworkString( "updateAdvert" )
//##############################################################################

//##############################################################################
//net.Receives
net.Receive( "updateAdvert", function( len, ply )
  _advertname = net.ReadString()
  dbUpdate( "yrp_general", "value = '" .. _advertname .. "'", "name = 'advert'" )
end)

net.Receive( "getGamemodename", function( len, ply )
  net.Start( "getGamemodename" )
    net.WriteString( GAMEMODE.Name )
  net.Send( ply )
end)

net.Receive( "dbGetGeneral", function( len, ply )
  local tmpTable = sql.Query( "SELECT * FROM yrp_general" )
  net.Start( "dbGetGeneral" )
    net.WriteTable( tmpTable )
  net.Send( ply )
end)

net.Receive( "selectGeneral", function( len, ply )
  local tmpName = net.ReadString()
  local tmpQuery = sql.Query( "SELECT value FROM yrp_general WHERE name = '" .. tmpName .. "'" )

  net.Start( "selectGeneral" )
    net.WriteString( tmpName )
    net.WriteString( tmpQuery[1].value )
  net.Send( ply )
end)

net.Receive( "updateGeneral", function( len, ply )
  local tmpString = net.ReadString()
  local tmpString2 = net.ReadString()
  sql.Query( "UPDATE yrp_general SET value = '" .. tmpString .. "' WHERE name = '" .. tmpString2 .. "'" )
end)
//##############################################################################

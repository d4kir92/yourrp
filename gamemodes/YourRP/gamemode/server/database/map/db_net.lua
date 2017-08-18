
util.AddNetworkString( "getMapList" )
util.AddNetworkString( "dbInsertInto" )
util.AddNetworkString( "removeMapEntry" )

net.Receive( "removeMapEntry", function( len, ply )
  local _tmpMapTable = sql.Query( "SELECT * FROM yrp_" .. string.lower( game.GetMap() ) )
  local _tmpUniqueID = net.ReadString()
  dbDeleteFrom( "yrp_" .. string.lower( game.GetMap() ), "uniqueID = " .. _tmpUniqueID )
end)

net.Receive( "getMapList", function( len, ply )
  local _tmpMapTable = sql.Query( "SELECT * FROM yrp_" .. string.lower( game.GetMap() ) )
  local _tmpGroupTable = sql.Query( "SELECT * FROM yrp_groups" )

  if _tmpMapTable != nil then
    net.Start( "getMapList" )
      net.WriteBool( false )
      net.WriteTable( _tmpMapTable )
      net.WriteTable( _tmpGroupTable )
    net.Send( ply )
  else
    _tmpMapTable = {}
    net.Start( "getMapList" )
      net.WriteBool( true )
      net.WriteTable( _tmpMapTable )
      net.WriteTable( _tmpGroupTable )
    net.Send( ply )
  end
end)

net.Receive( "dbInsertInto", function()
  local _tmpDBTable = net.ReadString()
  local _tmpDBCol = net.ReadString()
  local _tmpDBVal = net.ReadString()
  if sql.TableExists( _tmpDBTable ) then
    dbInsertInto( _tmpDBTable, _tmpDBCol, _tmpDBVal )
  else
    printError( "dbInsertInto: " .. _tmpDBTable .. " is not existing" )
  end
end)

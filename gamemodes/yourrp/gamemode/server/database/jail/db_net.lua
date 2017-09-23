--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

util.AddNetworkString( "dbAddJail" )

net.Receive( "dbAddJail", function( len, ply )
  local _tmpDBTable = net.ReadString()
  local _tmpDBCol = net.ReadString()
  local _tmpDBVal = net.ReadString()
  if sql.TableExists( _tmpDBTable ) then
    dbInsertInto( _tmpDBTable, _tmpDBCol, _tmpDBVal )
  else
    printERROR( "dbInsertInto: " .. _tmpDBTable .. " is not existing" )
  end

  local _steamID = net.ReadString()
  local _tmpTable = dbSelect( "yrp_jail", "*", "steamID = '" .. _steamID .. "'" )
  for k, v in pairs( player.GetAll() ) do
    if v:SteamID() == _steamID then
      ply:SetNWBool( "inJail", true )
      ply:SetNWInt( "jailtime", _tmpTable[1].time )
    end
  end
end)

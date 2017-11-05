--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

util.AddNetworkString( "getRistrictions" )
util.AddNetworkString( "dbUpdate" )

net.Receive( "getRistrictions", function( len, ply )
  local _tmp = dbSelect( "yrp_restrictions", "*", nil )
  net.Start( "getRistrictions" )
  if _tmp != nil then
    net.WriteTable( _tmp )
  else
    net.WriteTable( {} )
  end
  net.Send( ply )
end)

net.Receive( "dbUpdate", function( len, ply )
  local _dbTable = net.ReadString()
  local _dbSets = net.ReadString()
  local _dbWhile = net.ReadString()
  dbUpdate( _dbTable, _dbSets, _dbWhile )
  local _usergroup_ = string.Explode( " ", _dbWhile )
  local _restriction_ = string.Explode( " ", _dbSets )
  printGM( "note", ply:SteamName() .. " SETS " .. _dbSets .. " WHERE " .. _dbWhile )
end)

--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

--db_func.lua

function teleportToReleasepoint( ply )
  local _tmpTele = dbSelect( "yrp_" .. string.lower( game.GetMap() ), "*", "type = '" .. "releasepoint" .. "'" )

  if _tmpTele != nil then
    local _tmp = string.Explode( ",", _tmpTele[1].position )
    yrp_tp( ply, Vector( _tmp[1], _tmp[2], _tmp[3] ) )
    _tmp = string.Explode( ",", _tmpTele[1].angle )
    ply:SetEyeAngles( Angle( _tmp[1], _tmp[2], _tmp[3] ) )
  end
end

function teleportToJailpoint( ply )
  local _tmpTele = dbSelect( "yrp_" .. string.lower( game.GetMap() ), "*", "type = '" .. "jailpoint" .. "'" )

  if _tmpTele != nil then
    local _tmp = string.Explode( ",", _tmpTele[1].position )
    yrp_tp( ply, Vector( _tmp[1], _tmp[2], _tmp[3] ) )
    _tmp = string.Explode( ",", _tmpTele[1].angle )
    ply:SetEyeAngles( Angle( _tmp[1], _tmp[2], _tmp[3] ) )
  end
end


function cleanUpJail( ply )
  local _tmpTable = dbSelect( "yrp_jail", "*", "SteamID = '" .. ply:SteamID() .. "'" )
  if _tmpTable != nil then
    dbDeleteFrom( "yrp_jail", "SteamID = '" .. ply:SteamID() .. "'" )
    ply:SetNWBool( "inJail", false )
    ply:SetNWInt( "jailtime", 0 )

    teleportToReleasepoint( ply )
  end
end

--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

function teleportToPoint( ply, pos )
  printGM( "note", "teleportToPoint " .. tostring( pos ) )
  yrp_tp( ply, Vector( pos[1], pos[2], pos[3] ) )
end

function teleportToSpawnpoint( ply )
  local groTab = ply:GetGroTab()

  local chaTab = ply:GetChaTab()
  if chaTab != nil then
    if chaTab.map == string.lower( game.GetMap() ) and chaTab.position != "NULL" and chaTab.angle != "NULL" then
      local _tmpMapTable = dbSelect( "yrp_" .. string.lower( game.GetMap() ), "*", "groupID = " .. groTab.uniqueID )
      if _tmpMapTable != nil then
        local _randomSpawnPoint = table.Random( _tmpMapTable )

        local _tmp = string.Explode( ",", _randomSpawnPoint.position )
        yrp_tp( ply, Vector( _tmp[1], _tmp[2], _tmp[3] ) )
        _tmp = string.Explode( ",", _randomSpawnPoint.angle )
        ply:SetEyeAngles( Angle( _tmp[1], _tmp[2], _tmp[3] ) )
      else
        printGM( "note", groTab.groupID .. " has no group spawn!" )
        yrp_tp( ply, ply:GetPos() )
      end
    end
  else
    printGM( "note", "map: no char" )
  end
end

--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

function teleportToSpawnpoint( ply )
  local _tmpTable = ply:GetGroTab()

  local chaTab = ply:GetChaTab()
  if chaTab != nil then
    if chaTab.map == string.lower( game.GetMap() ) and chaTab.position != "NULL" and chaTab.angle != "NULL" then

      local _tmp = string.Explode( ",", chaTab.position )
      yrp_tp( ply, Vector( _tmp[1], _tmp[2], _tmp[3] ) )
      _tmp = string.Explode( ",", chaTab.angle )
      ply:SetEyeAngles( Angle( _tmp[1], _tmp[2], _tmp[3] ) )

    else
      local _tmpMapTable = dbSelect( "yrp_" .. string.lower( game.GetMap() ), "*", "groupID = " .. _tmpTable.uniqueID )
      if _tmpMapTable != nil then
        local _randomSpawnPoint = table.Random( _tmpMapTable )

        local _tmp = string.Explode( ",", _randomSpawnPoint.position )
        yrp_tp( ply, Vector( _tmp[1], _tmp[2], _tmp[3] ) )
        _tmp = string.Explode( ",", _randomSpawnPoint.angle )
        ply:SetEyeAngles( Angle( _tmp[1], _tmp[2], _tmp[3] ) )
      else
        --
      end
    end
  else
    printGM( "note", "map: no char" )
  end
end

--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

function teleportToSpawnpoint( ply )
  local _tmpTable = dbSelect( "yrp_players", "roleID", "steamID = '" .. ply:SteamID() .. "'" )
  if _tmpTable != false and _tmpTable != nil then
    local _tmpRoleID = _tmpTable[1].roleID

    _tmpTable = dbSelect( "yrp_roles", "groupID", "uniqueID = " .. _tmpRoleID )
    local _tmpGroupID = _tmpTable[1].groupID

    if _tmpGroupID != nil then

      _tmpTable = sql.Query( "SELECT * FROM yrp_" .. string.lower( game.GetMap() ) .. " WHERE groupID = " .. _tmpGroupID )
      if _tmpTable != nil then
        local _randomSpawnPoint = table.Random( _tmpTable )

        local _tmp = string.Explode( ",", _randomSpawnPoint.position )
        yrp_tp( ply, Vector( _tmp[1], _tmp[2], _tmp[3] ) )
        _tmp = string.Explode( ",", _randomSpawnPoint.angle )
        ply:SetEyeAngles( Angle( _tmp[1], _tmp[2], _tmp[3] ) )
      else
        local tmpGroup = dbSelect( "yrp_groups", "*", "uniqueID = '" .. _tmpGroupID .. "'" )
        if tmpGroup != nil then
          printGM( "note", "There is no spawnpoint for: " .. tmpGroup[1].groupID )

          local _infoPlayerStart = ents.FindByClass( "info_player_start" )
          local _spawnpoints = table.Random( _infoPlayerStart )
          yrp_tp( ply, _spawnpoints:GetPos() )
        else
          printGM( "note", "There is no group" )
        end
      end
    end
  end
end

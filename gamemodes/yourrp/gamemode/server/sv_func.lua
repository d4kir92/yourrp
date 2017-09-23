--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

--Drehung
function yrp_tp_test( ply, pos )
  local tr = {
  	start = pos,
    endpos = pos,
    mins = Vector( -18, -18, 0 ),
  	maxs = Vector( 18, 18, 75 )
  }

  local hullTrace = util.TraceHull( tr )
  if !hullTrace.Hit then
    return true
  else
    return false
  end
end

--Auf Boden
function yrp_tp_test2( ply, pos )
  local tr = {
  	start = pos,
    endpos = pos-Vector( 0, 0, 9999 ),
    mins = Vector( -18, -18, 0 ),
  	maxs = Vector( 18, 18, 75 )
  }

  local hullTrace = util.TraceHull( tr )
  if hullTrace.Hit then
    return hullTrace.HitPos + Vector( 0, 0, 2 )
  else
    return pos
  end
end

function yrp_tp( ply, pos )
  local _angle = Angle( 0, 0, 0 )
  local _tmpAngle = ply:EyeAngles()
  ply:SetEyeAngles( _angle )
  if yrp_tp_test( ply, pos + Vector( 0, 0, 2 ) ) then
    ply:SetPos( yrp_tp_test2( ply, pos + Vector( 0, 0, 2 ) ) )
    ply:SetEyeAngles( _tmpAngle )
  else
    for i = 1, 3 do
      for j = 0, 360, 45 do
        _angle:RotateAroundAxis( ply:GetForward(), 45 )
        if yrp_tp_test( ply, pos + Vector( 0, 0, 2 ) + _angle:Forward() * 40 * i ) then
          ply:SetPos( yrp_tp_test2( ply, pos + Vector( 0, 0, 2 ) + _angle:Forward() * 40 * i ) )
          ply:SetEyeAngles( _tmpAngle )
          return
        end
      end
    end
  end
end

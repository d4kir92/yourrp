--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

local hunger = Material( "icon16/cake.png" )

function showMH( ply )
  return ply:GetNWBool( "toggle_hunger", false )
end

function hudMH( ply, color )
  if showMH( ply ) then
    local _mhtext = math.Round( ( math.Round( ply:GetNWInt( "hunger", 0 ), 0 ) / 100 ) * 100, 0 ) .. "%"
    drawHUDElement( "mh", ply:GetNWInt( "hunger", 0 ), 100, _mhtext, hunger, color )
  end
end

function hudMHBR( ply )
  if showMH( ply ) then
    drawHUDElementBr( "mh" )
  end
end

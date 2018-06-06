--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

local thirst = Material( "icon16/cup.png" )

function showMT( ply )
  return ply:GetNWBool( "bool_thirst", false )
end

function hudMT( ply, color )
  if showMT( ply ) then
    local _mttext = math.Round( ( math.Round( ply:GetNWFloat( "thirst", 0.0 ), 1 ) / 100 ) * 100, 1 ) .. "%"
    drawHUDElement( "mt", ply:GetNWFloat( "thirst", 0.0 ), 100, _mttext, thirst, color )
  end
end

function hudMTBR( ply )
  if showMT( ply ) then
    drawHUDElementBr( "mt" )
  end
end

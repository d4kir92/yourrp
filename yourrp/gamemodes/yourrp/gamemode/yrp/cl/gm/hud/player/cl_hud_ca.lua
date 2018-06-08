--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

local cast = Material( "icon16/hourglass.png" )

function showCA( ply )
  return ply:GetNWBool( "iscasting", false )
end

function hudCA( ply, color )
  if showCA( ply ) then
    local _catext = lang_string( ply:GetNWString( "castname", "" ) ) .. " (" .. math.Round( ( math.Round( ply:GetNWFloat( "castcur", 0.0 ), 1 ) / ply:GetNWFloat( "castmax", 0.0 ) ) * 100, 0 ) .. "%)"
    drawHUDElement( "ca", ply:GetNWFloat( "castcur", 0.0 ), ply:GetNWFloat( "castmax", 0.0 ), _catext, cast, color )
  end
end

function hudCABR( ply )
  if showCA( ply ) then
    drawHUDElementBr( "ca" )
  end
end

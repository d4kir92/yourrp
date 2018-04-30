--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

function hudWN( ply, color, weapon )
  local _wntext = ""
  if weapon != nil and weapon != NULL then
    _wntext = weapon:GetPrintName() or ""
  end
  drawHUDElement( "wn", nil, nil, _wntext, nil, nil )
end

function hudWNBR( ply )
  drawHUDElementBr( "wn" )
end

--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

local stamina = Material( "icon16/lightning.png" )

function showMS( ply )
  return ply:GetNWBool( "toggle_stamina", false )
end

function hudMS( ply, color )
  if showMS( ply ) then
    local _mstext = math.Round( ( math.Round( ply:GetNWInt( "GetCurStamina", 0 ), 0 ) / ply:GetNWInt( "GetMaxStamina", 0 ) ) * 100, 0 ) .. "%"
    drawHUDElement( "ms", ply:GetNWInt( "GetCurStamina", 0 ), ply:GetNWInt( "GetMaxStamina", 0 ), _mstext, stamina, color )
  end
end

function hudMSBR( ply )
  if showMS( ply ) then
    drawHUDElementBr( "ms" )
  end
end

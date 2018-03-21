--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

local health = Material( "icon16/heart.png" )

function hudHP( ply, color )
  local _hptext = math.Round( ply:Health(), 0 ) .. "/" .. ply:GetMaxHealth() .. "|" .. math.Round( ( math.Round( ply:Health(), 0 ) / ply:GetMaxHealth() ) * 100, 0 ) .. "%"
  drawHUDElement( "hp", ply:Health(), ply:GetMaxHealth(), _hptext, health, color )
end

function hudHPBR()
  drawHUDElementBr( "hp" )
end

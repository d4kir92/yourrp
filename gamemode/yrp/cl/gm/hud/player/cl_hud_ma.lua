--Copyright (C) 2017-2018 Arno Zura (https://www.gnu.org/licenses/gpl.txt )

local mana = Material("icon16/wand.png" )

function hudMA(ply, color )
	local _matext = ply:GetNWInt("GetCurAbility", 0 ) .. "/" .. ply:GetNWInt("GetMaxAbility", 100 ) .. "|" .. math.Round((math.Round(ply:GetNWInt("GetCurAbility", 0 ), 0 ) / ply:GetNWInt("GetMaxAbility", 100 ) ) * 100, 0 ) .. "%"
	drawHUDElement("ma", ply:GetNWInt("GetCurAbility", 0 ), ply:GetNWInt("GetMaxAbility", 100 ), _matext, mana, color )
end

function hudMABR()
	drawHUDElementBr("ma" )
end

--Copyright (C) 2017-2019 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

local armor = Material("icon16/shield.png")

function hudAR(ply, color)
	local _artext = math.Round(ply:Armor(), 0) .. "/" .. ply:GetNWInt("MaxArmor", 1) .. "|" .. math.Round((math.Round(ply:Armor(), 0) / ply:GetNWInt("MaxArmor", 1)) * 100, 0) .. "%"
	drawHUDElement("ar", ply:Armor(), ply:GetNWInt("MaxArmor"), _artext, armor, color)
end

function hudARBR()
	drawHUDElementBr("ar")
end

--Copyright (C) 2017-2019 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

include("shared.lua")

local yrp_icon = Material("yrp/yrp_icon")

function ENT:Draw()
	local ply = LocalPlayer()
	if ply:GetPos():Distance(self:GetPos()) < 2200 then
		self:DrawModel()
		local money = self:GetMoney()
		if money != nil then
			if money >= 1000 then
				money = MoneyFormatRounded(money)
			else
				money = MoneyFormat(money)
			end

			local pos = self:GetPos()
			local ang = self:GetAngles()
			cam.Start3D2D(pos + self:GetUp() * 0.82, ang, 0.02 )
				if self:GetModel() == "models/props/cs_assault/money.mdl" then
					draw.RoundedBox(0, -200, -92, 200 * 2, 92 * 2, Color(6,92,39))
					surface.SetDrawColor(255, 255, 255, 255)
					surface.SetMaterial(yrp_icon)
					surface.DrawTexturedRect(-180, -72, 40, 40)
				end
				draw.SimpleTextOutlined(money, "Y_O_72_700", 0, 0, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
			cam.End3D2D()

			local up = ang:RotateAroundAxis(ang:Up(), 180)
			local right = ang:RotateAroundAxis(ang:Right(), 0)
			local forward = ang:RotateAroundAxis(ang:Forward(), 180)
			cam.Start3D2D(pos + self:GetUp() * 0.06, ang, 0.02 )
				if self:GetModel() == "models/props/cs_assault/money.mdl" then
					draw.RoundedBox(0, -200, -92, 200 * 2, 92 * 2, Color(6,92,39))
					surface.SetDrawColor(255, 255, 255, 255)
					surface.SetMaterial(yrp_icon)
					surface.DrawTexturedRect(-180, -72, 40, 40)
				end
				draw.SimpleTextOutlined(money, "Y_O_72_700", 0, 0, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
			cam.End3D2D()

			if GetGlobalDBool("bool_tag_on_head_name", false) then
				ang = ply:GetAngles()
				ang = Angle(0, ang.y - 90, 90)
				cam.Start3D2D(pos + Vector(0, 0, 4), ang, 0.04 )
					draw.SimpleTextOutlined(money, "Y_O_72_700", 0, 0, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
				cam.End3D2D()
			end
		end
	end
end

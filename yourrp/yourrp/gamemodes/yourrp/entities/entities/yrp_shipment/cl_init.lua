--Copyright (C) 2017-2022 D4KiR (https://www.gnu.org/licenses/gpl.txt)

include( "shared.lua" )

function ENT:Draw()
	local lply = LocalPlayer()
	if lply:GetPos():Distance(self:GetPos() ) < 2200 then
		self:DrawModel()
		local amount = self:GetYRPInt( "amount", 0 )
		local name = self:GetYRPString( "name", "" )
		if amount and name then
			local pos = self:GetPos() + Vector( 0, 0, 50 )
			local ang = self:GetAngles()

			local up = ang:RotateAroundAxis( ang:Up(), 180)
			local right = ang:RotateAroundAxis( ang:Right(), 0)
			local forward = ang:RotateAroundAxis( ang:Forward(), 180)

			ang = lply:GetAngles()
			ang = Angle(0, ang.y - 90, 90)
			cam.Start3D2D(pos + Vector(0, 0, 4), ang, 0.06 )
				draw.SimpleTextOutlined( amount .. "x " .. name, "Y_72_500", 0, 0, white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0, 255 ) )
			cam.End3D2D()
		end
	end
end

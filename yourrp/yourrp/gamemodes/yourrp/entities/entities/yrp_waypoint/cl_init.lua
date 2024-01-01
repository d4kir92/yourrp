--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
include("shared.lua")
function ENT:Draw()
	local lply = LocalPlayer()
	if lply:GetPos():Distance(self:GetPos()) < 2200 then
		self:DrawModel()
		local yrp_waypoint_next = self:GetYRPEntity("yrp_waypoint_next")
		if IsValid(yrp_waypoint_next) then
			local vec = Vector(0, 0, 10)
			render.SetColorMaterial()
			render.DrawBeam(self:GetPos() + vec, yrp_waypoint_next:GetPos() + vec, 2, 0, 0, Color(60, 60, 255))
			local selent = lply:GetYRPEntity("yrp_waypoint_selected")
			if IsValid(selent) then
				render.SetColorMaterial()
				render.DrawSphere(selent:GetPos(), 16, 16, 16, Color(255, 255, 0, 4))
			end
		end
	end
end
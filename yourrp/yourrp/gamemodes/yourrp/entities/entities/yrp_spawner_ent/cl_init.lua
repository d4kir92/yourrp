--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
include("shared.lua")
function ENT:Draw()
	local lply = LocalPlayer()
	if lply:GetPos():Distance(self:GetPos()) < 2200 then
		self:DrawModel()
		render.SetColorMaterial()
		render.DrawSphere(self:GetPos(), 16, 16, 16, Color(255, 255, 0, 4))
	end
end
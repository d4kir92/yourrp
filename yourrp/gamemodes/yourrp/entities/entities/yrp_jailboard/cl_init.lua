--Copyright (C) 2017-2021 Arno Zura (https://www.gnu.org/licenses/gpl.txt)
include("shared.lua")

function ENT:Draw()
	local lply = LocalPlayer()
	local eyeTrace = lply:GetEyeTrace()

	if lply:GetPos():Distance(self:GetPos()) < 2000 then
		self:DrawModel()
	end
end

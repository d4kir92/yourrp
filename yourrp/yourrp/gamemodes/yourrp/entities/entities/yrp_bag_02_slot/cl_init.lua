--Copyright (C) 2017-2023 D4KiR (https://www.gnu.org/licenses/gpl.txt)

include( "shared.lua" )

function ENT:Draw()
	local lply = LocalPlayer()
	if lply:GetPos():Distance(self:GetPos() ) < 2200 then
		self:DrawModel()
	end
end

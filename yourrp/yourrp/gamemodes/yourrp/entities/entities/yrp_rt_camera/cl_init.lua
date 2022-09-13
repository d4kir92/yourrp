--Copyright (C) 2017-2022 D4KiR (https://www.gnu.org/licenses/gpl.txt)

include( "shared.lua" )

function ENT:Draw()
	if LocalPlayer():GetPos():Distance(self:GetPos() ) < 2000 then
		self:DrawModel()
	end
end

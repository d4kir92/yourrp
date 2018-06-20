--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

include("shared.lua")

function ENT:Draw()
	if LocalPlayer():GetPos():Distance( self:GetPos() ) < 2000 then
		self:DrawModel()
	end
end

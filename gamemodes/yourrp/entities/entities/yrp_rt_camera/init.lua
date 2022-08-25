--Copyright (C) 2017-2022 D4KiR (https://www.gnu.org/licenses/gpl.txt)

AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( "shared.lua" )

function ENT:Initialize()
	self:SetModel( "models/maxofs2d/camera.mdl" )
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)

	self:SetPos(self:GetPos() + Vector(0,0,100) )
	local phys = self:GetPhysicsObject()
	if (phys:IsValid() ) then
		phys:Wake()
	end
end

function ENT:Use( activator, caller)

end

function ENT:OnRemove()

end

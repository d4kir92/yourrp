--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( "shared.lua" )

function ENT:Initialize()
	self:SetModel( "models/props_junk/cardboard_box002b.mdl" )
	self:SetModelScale( 0.6, 0 )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )

	self:SetPos(self:GetPos()+Vector(0,0,100))
  local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end

	self.storage = self:InitBackpackStorage( 8, 12 )
end

function ENT:Use( activator, caller )
	openStorage( activator, self:GetNWString( "storage_uid" ) )
end

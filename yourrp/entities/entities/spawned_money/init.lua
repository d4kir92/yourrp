--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( "shared.lua" )

resource.AddFile( "models/props/cs_assault/money.mdl" )

function ENT:Initialize()
	self:SetModel( "models/props/cs_assault/money.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )

  local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
end

function ENT:Getamount()
	return self:GetNWString( "money" )
end

function ENT:Setamount( money )
	self:SetNWString( "money", money )
end

function ENT:Use( activator, caller )
	caller:addMoney( self:Getamount() )
  self:Remove()
end

function ENT:Think()

end

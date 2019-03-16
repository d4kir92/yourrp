--Copyright (C) 2017-2019 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/Items/ammocrate_smg1.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)

	self:SetPos(self:GetPos()+Vector(0,0,100))
	local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end

	self.storage = self:InitStorage(8, 12)
	self:SetNWBool("isaworldstorage", true)
end

function ENT:Use(activator, caller)
	openStorage(activator, self:GetNWString("storage_uid"))
end

--Copyright (C) 2017-2021 D4KiR (https://www.gnu.org/licenses/gpl.txt)

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:SetStorage(id)
	self._suid = id
end

function ENT:Use(activator, caller, useType, value)
	self.d = self.d or 0
	if self.d < CurTime() then
		self.d = CurTime() + 1
		if self._suid != nil then
			OpenWorldStorage(activator, self._suid, self:GetClass())
		end
	end
end

function ENT:Initialize()
	self:SetModel("models/items/ammocrate_rockets.mdl")

	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end

	self.text_type = "chest"
	self.bag_size = 32
	
	timer.Simple(0.1, function()
		YRPRegisterObject(self)
	end)
end

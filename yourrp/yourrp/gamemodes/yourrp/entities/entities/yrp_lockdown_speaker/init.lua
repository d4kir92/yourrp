--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
function ENT:Initialize()
	self:SetModel("models/props_wasteland/speakercluster01a.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetPos(self:GetPos() + Vector(0, 0, 100))
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
	end

	AddToLockdownSpeakers(self)
end

function ENT:Use(activator, caller)
end

function ENT:OnRemove()
	RemoveFromLockdownSpeakers(self)
	self:StopSound("sound_lockdown")
end
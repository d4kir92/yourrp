--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
function ENT:Initialize()
	self:SetModel("models/hunter/plates/plate1x4.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
	end

	self:SetModelScale(0.010)
end

function ENT:Use(activator, caller)
	local filename = "buttons/button14.wav"
	util.PrecacheSound(filename)
	activator:EmitSound(filename, 75, 100, 1, CHAN_AUTO)
end

function ENT:Think()
end
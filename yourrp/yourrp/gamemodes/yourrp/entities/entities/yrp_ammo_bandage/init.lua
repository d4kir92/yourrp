--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
function ENT:Initialize()
	self:SetModel("models/props_junk/PopCan01a.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
	end
end

function ENT:Use(activator, caller)
	if not activator:IsValid() then return end
	local weap = activator:GetActiveWeapon()
	if IsValid(weap) then
		local pram = weap:GetPrimaryAmmoType()
		activator:GiveAmmo(1, pram)
		self:Remove()
	end
end

function ENT:Think()
end
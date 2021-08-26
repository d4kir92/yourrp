--Copyright (C) 2017-2021 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/Items/ammocrate_smg1.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)

	local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
		self:DropToFloor()
	end
end

util.AddNetworkString("yrp_open_weaponchest")
function ENT:Use(activator, caller)
	if !activator:GetNW2Bool("clicked", false) then
		activator:SetNW2Bool("clicked", true)
		
		net.Start("yrp_open_weaponchest")
		net.Send(activator)

		timer.Simple(0.4, function()
			activator:SetNW2Bool("clicked", false)
		end)
	end
end

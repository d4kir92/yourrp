--Copyright (C) 2017-2021 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/props_wasteland/controlroom_storagecloset001a.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)

	self:SetPos(self:GetPos() + Vector(0,0,100))

	local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		timer.Simple(0.0, function()
			phys:Wake()
			self:DropToFloor()
		end)
	end
end

util.AddNetworkString("openAM")
function ENT:Use(activator, caller)
	if !activator:GetDBool("clicked", false) then
		activator:SetDBool("clicked", true)
		net.Start("openAM")
		net.Send(activator)
		timer.Simple(0.4, function()
			activator:SetDBool("clicked", false)
		end)
	end
end

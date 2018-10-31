--Copyright (C) 2017-2018 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

util.AddNetworkString("ATMPressPrev")
util.AddNetworkString("ATMPressNext")

function ENT:Initialize()
	self:SetModel("models/props_wasteland/controlroom_storagecloset001a.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)

	self:SetPos(self:GetPos()+Vector(0,0,100))
	self:DropToFloor()
	local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
end

util.AddNetworkString("openAM")
function ENT:Use(activator, caller)
	if !activator:GetNWBool("clicked", false) then
		activator:SetNWBool("clicked", true)
		net.Start("openAM")
		net.Send(activator)
		timer.Simple(0.4, function()
			activator:SetNWBool("clicked", false)
		end)
	end
end

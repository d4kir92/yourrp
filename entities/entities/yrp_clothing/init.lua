--Copyright (C) 2017-2019 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

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
	if !activator:GetNW2Bool("clicked", false) then
		activator:SetNW2Bool("clicked", true)
		net.Start("openAM")
		net.Send(activator)
		timer.Simple(0.4, function()
			activator:SetNW2Bool("clicked", false)
		end)
	end
end

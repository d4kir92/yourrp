--Copyright (C) 2017-2019 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

util.AddNetworkString("openLawBoard")

function ENT:Initialize()
	self:SetModel("models/props_combine/combine_intmonitor001.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)

	local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
end

function ENT:Use(activator, caller)
	local tmpTable = SQL_SELECT("yrp_jail", "*", nil)

	if tmpTable == nil or tmpTable == false then
		tmpTable = {}
	end
	net.Start("openLawBoard")
		net.WriteTable(tmpTable)
	net.Send(caller)
end

function ENT:Think()

end

util.AddNetworkString("jail")
net.Receive("jail", function(len, ply)
	local target = net.ReadEntity()

	teleportToJailpoint(target)
end)

util.AddNetworkString("unjail")
net.Receive("unjail", function(len, ply)
	local target = net.ReadEntity()

	teleportToReleasepoint(target)
end)
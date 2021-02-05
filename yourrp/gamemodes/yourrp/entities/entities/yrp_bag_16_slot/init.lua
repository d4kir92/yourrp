--Copyright (C) 2017-2021 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:SetStorage(id)
	if id == nil then
		local storage = CreateStorage(self.bag_size)
		if wk(storage) then
			self._suid = tonumber(storage.uniqueID)
		end
	else
		self._suid = tonumber(id)
	end
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

util.AddNetworkString("open_storage")
function OpenWorldStorage(ply, suid, name)
	net.Start("open_storage")
		net.WriteString(suid)
		net.WriteString(name)
	net.Send(ply)
end

function ENT:Initialize()
	self:SetModel("models/props_junk/garbage_takeoutcarton001a.mdl")

	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end

	self.text_type = "bag"
	self.bag_size = 16
	
	timer.Simple(0.1, function()
		self:SetStorage(self._suid)
		YRPRegisterObject(self)
	end)
end

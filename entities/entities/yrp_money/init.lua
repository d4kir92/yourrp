--Copyright (C) 2017-2019 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	if table.HasValue(GetWorkshopIDs(), "1189643820") then
		self:SetModel(YRPGetMoneyModel())
	else
		self:SetModel("models/props_junk/garbage_newspaper001a.mdl")
	end
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end

	self:SetMoney(tonumber(self.money))
end

function ENT:SetMoney(money)
	self.money = tonumber(money)
	self:SetNWString("money", self.money)
end

function ENT:Use(activator, caller)
	activator:addMoney(self:GetMoney())
	self:Remove()
end

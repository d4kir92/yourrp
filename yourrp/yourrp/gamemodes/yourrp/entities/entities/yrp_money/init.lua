--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
function ENT:Initialize()
	local moneyModel = YRPGetMoneyModel()
	if moneyModel then
		self:SetModel(YRPGetMoneyModel())
	end

	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
	end

	self:SetMoney(tonumber(self.money))
	self.ismoney = true
end

function ENT:SetMoney(money)
	self.money = tonumber(money)
	if self.money then
		self:SetYRPString("money", self.money)
	end
end

function ENT:Use(activator, caller)
	if activator:IsPlayer() then
		activator:addMoney(self:GetMoney())
		self:Remove()
	end
end

function ENT:StartTouch(ent)
	if ent.ismoney and self:EntIndex() < ent:EntIndex() then
		self:SetMoney(self:GetMoney() + ent:GetMoney())
		ent:Remove()
	end
end
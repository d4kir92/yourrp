--Copyright (C) 2017-2025 D4KiR (https://www.gnu.org/licenses/gpl.txt)
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
resource.AddFile("models/props/cs_assault/money.mdl")
function ENT:Initialize()
	if table.HasValue(GetWorkshopIDs(), "1189643820") then
		self:SetModel("models/props/cs_assault/money.mdl")
	else
		self:SetModel("models/props_junk/garbage_newspaper001a.mdl")
	end

	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
	end
end

function ENT:Getamount()
	return tonumber(self:GetYRPString("money", "0")) or 0
end

function ENT:Setamount(money)
	money = tonumber(money)
	if money == nil then
		YRP:msg("note", "[spawned_money] Setamount got a non-number")

		return
	end

	self:SetYRPString("money", money)
end

function ENT:Use(activator, caller)
	if not IsValid(activator) or not activator:IsPlayer() then return end
	local amount = self:Getamount()
	if amount > 0 then
		activator:addMoney(amount)
	end

	self:Remove()
end

function ENT:Think()
end

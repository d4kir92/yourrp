--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
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
	return self:GetYRPString("money")
end

function ENT:Setamount(money)
	self:SetYRPString("money", money)
end

function ENT:Use(activator, caller)
	caller:addMoney(self:Getamount())
	self:Remove()
end

function ENT:Think()
end
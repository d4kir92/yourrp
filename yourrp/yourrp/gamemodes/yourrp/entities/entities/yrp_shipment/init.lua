--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
function ENT:Initialize()
	self:SetModel("models/items/item_item_crate.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
	end

	self.delay = 0
end

function ENT:SetClassName(classname)
	self:SetYRPString("classname", classname)
	if not YRPEntityAlive(self.viewmodel) then
		self.viewmodel = ents.Create("prop_dynamic")
		self.viewmodel:SetPos(self:GetPos())
		self.viewmodel:SetModel("models/items/item_item_crate.mdl")
		self.viewmodel:Spawn()
		self:SetYRPEntity("viewmodel", self.viewmodel)
	end

	local mdl = ents.Create(classname)
	if YRPEntityAlive(mdl) then
		self.viewmodel:SetModel(mdl:GetModel())
		mdl:Remove()
		self:SetYRPEntity("viewmodel", self.viewmodel)
	end
end

function ENT:SetDisplayName(itemname)
	self:SetYRPString("itemname", itemname)
end

function ENT:SetItemType(typ)
	self:SetYRPString("itemtype", typ)
end

function ENT:SetAmount(amount)
	self:SetYRPInt("amount", amount)
end

function ENT:OnRemove()
	if YRPEntityAlive(self.viewmodel) then
		self.viewmodel:Remove()
	end
end

function ENT:AddOne(ent)
	self:SetYRPInt("amount", self:GetYRPInt("amount", 1) + 1)
	if YRPEntityAlive(ent) then
		ent:Remove()
	end
end

function ENT:RemoveOne()
	self:SetYRPInt("amount", self:GetYRPInt("amount", 1) - 1)
	if self:GetYRPInt("amount", 1) == 0 then
		self:Remove()
	end
end

function ENT:Use(activator, caller)
	if activator:IsPlayer() then
		self.delay = self.delay or 0
		if self.delay < CurTime() then
			self.delay = CurTime() + 0.5
			if self:GetYRPString("itemtype") == "weapons" then
				local wep = activator:Give(self:GetYRPString("classname", ""))
				if YRPEntityAlive(wep) then
					self:RemoveOne()
				else
					local weap = ents.Create(self:GetYRPString("classname", ""))
					if YRPEntityAlive(weap) then
						weap:Spawn()
						tp_to(weap, activator:GetPos() + Vector(0, 0, 70))
						self:RemoveOne()
					end
				end
			end
		end
	end
end

function ENT:StartTouch(ent)
	if ent:GetClass() == "yrp_shipment" then
		if ent:GetYRPString("classname") == self:GetYRPString("classname") and ent:GetYRPString("itemtype") == self:GetYRPString("itemtype") then
			local amount = ent:GetYRPInt("amount") + self:GetYRPInt("amount")
			if self:GetPos().z > ent:GetPos().z then
				ent:Remove()
				self:SetAmount(amount)
			end
		end
	end
end

function ENT:Touch(ent)
	if ent:GetClass() == self:GetYRPString("classname") and ent.checkadd == nil then
		ent.checkadd = true
		self:AddOne(ent)
	end
end
--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
AddCSLuaFile()
DEFINE_BASECLASS("yrp_money")
ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "YourRP - 0 Money"
ENT.Author = "D4KiR"
ENT.Contact = "-"
ENT.Purpose = "Sharing money"
ENT.Information = "Test"
ENT.Instructions = ""
ENT.Category = "[YourRP] Money"
ENT.Editable = false
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT
ENT.money = 0
function ENT:GetMoney()
	self.money = tonumber(self:GetYRPString("money", "-1"))
	self.PrintName = "YourRP - " .. self.money .. " Money"

	return self.money
end
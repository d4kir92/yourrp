--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
function ENT:Initialize()
	self:SetModel("")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
	end

	HasUseFunction(self)
end

function ENT:Think()
	if string.lower(GetGlobalYRPString("text_weapon_system_model", "models/items/ammocrate_smg1.mdl")) ~= self:GetModel() then
		self:SetModel(string.lower(GetGlobalYRPString("text_weapon_system_model", "models/items/ammocrate_smg1.mdl")))
	end
end

util.AddNetworkString("nws_yrp_open_weaponchest")
function ENT:Use(activator, caller, useType, value)
	if not activator:GetYRPBool("wc_clicked", false) then
		activator:SetYRPBool("wc_clicked", true)
		net.Start("nws_yrp_open_weaponchest")
		net.Send(activator)
		timer.Simple(
			0.4,
			function()
				if IsValid(activator) then
					activator:SetYRPBool("wc_clicked", false)
				end
			end
		)
	end

	timer.Simple(
		1,
		function()
			if IsValid(activator) and activator:GetYRPBool("wc_clicked", false) then
				activator:SetYRPBool("wc_clicked", false)
			end
		end
	)
end
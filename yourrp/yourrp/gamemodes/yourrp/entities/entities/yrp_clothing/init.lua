--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
function ENT:Initialize()
	self:SetModel("")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetPos(self:GetPos())
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
	end
end

local delay = 5
local lastTS = 0
function ENT:Think()
	local phys = self:GetPhysicsObject()
	if not IsValid(phys) and lastTS < os.time() then
		lastTS = os.time() + delay
		local msg = "[CLOTHING] Model has no Physic Object, cant be used for Clothing"
		YRP.msg("note", msg)
		if SERVER then
			PrintMessage(HUD_PRINTCENTER, msg)
		end
	end

	if string.lower(GetGlobalYRPString("text_appearance_model", "models/props_wasteland/controlroom_storagecloset001a.mdl")) ~= self:GetModel() then
		self:SetModel(string.lower(GetGlobalYRPString("text_appearance_model", "models/props_wasteland/controlroom_storagecloset001a.mdl")))
	end
end

util.AddNetworkString("nws_yrp_openAM")
function ENT:Use(activator, caller)
	if not activator:GetYRPBool("clicked", false) then
		activator:SetYRPBool("clicked", true)
		net.Start("nws_yrp_openAM")
		net.Send(activator)
		timer.Simple(
			0.4,
			function()
				activator:SetYRPBool("clicked", false)
			end
		)
	end
end
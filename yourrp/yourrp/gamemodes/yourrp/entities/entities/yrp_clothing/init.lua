--Copyright (C) 2017-2022 D4KiR (https://www.gnu.org/licenses/gpl.txt)

AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( "shared.lua" )

function ENT:Initialize()
	self:SetModel( "" )

	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)

	self:SetPos(self:GetPos() )

	local phys = self:GetPhysicsObject()
	if (phys:IsValid() ) then
		phys:Wake()
	end
end

function ENT:Think()
	if string.lower(GetGlobalYRPString( "text_appearance_model", "models/props_wasteland/controlroom_storagecloset001a.mdl" ) ) != self:GetModel() then
		self:SetModel(string.lower(GetGlobalYRPString( "text_appearance_model", "models/props_wasteland/controlroom_storagecloset001a.mdl" ) ))
	end
end

util.AddNetworkString( "openAM" )
function ENT:Use( activator, caller)
	if !activator:GetYRPBool( "clicked", false) then
		activator:SetYRPBool( "clicked", true)
		net.Start( "openAM" )
		net.Send( activator)
		timer.Simple(0.4, function()
			activator:SetYRPBool( "clicked", false)
		end)
	end
end

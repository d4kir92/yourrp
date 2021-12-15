--Copyright (C) 2017-2021 D4KiR (https://www.gnu.org/licenses/gpl.txt)

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
	if string.lower(GetGlobalString( "text_appearance_model", "models/props_wasteland/controlroom_storagecloset001a.mdl" ) ) != self:GetModel() then
		self:SetModel(string.lower(GetGlobalString( "text_appearance_model", "models/props_wasteland/controlroom_storagecloset001a.mdl" ) ))
	end
end

util.AddNetworkString( "openAM" )
function ENT:Use( activator, caller)
	if !activator:GetNW2Bool( "clicked", false) then
		activator:SetNW2Bool( "clicked", true)
		net.Start( "openAM" )
		net.Send( activator)
		timer.Simple(0.4, function()
			activator:SetNW2Bool( "clicked", false)
		end)
	end
end

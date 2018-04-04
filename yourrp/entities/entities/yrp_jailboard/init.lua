--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( "shared.lua" )

util.AddNetworkString( "openLawBoard" )

function ENT:Initialize()
	self:SetModel( "models/props_c17/Frame002a.mdl" )
	self:SetModelScale( 2, 0 )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_NONE )
	self:SetSolid( SOLID_VPHYSICS )

  local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
end

function ENT:OnRemove()

end

function ENT:Use( activator, caller )
	local tmpTable = db_select( "yrp_jail", "*", nil )
	local tmpGroups = db_select( "yrp_groups", "*", nil )
	local tmpGeneral = db_select( "yrp_general", "*", nil )
	local chaTab = caller:GetChaTab()
	local tmpRoles = db_select( "yrp_roles", "*", "uniqueID = " .. chaTab.roleID .. "")

	if tmpTable == nil or tmpTable == false then
		tmpTable = {}
	end
	net.Start( "openLawBoard" )
		net.WriteTable( tmpTable )
		net.WriteTable( tmpGroups )
		net.WriteTable( tmpGeneral )
		net.WriteInt( tmpRoles[1].groupID, 16 )
	net.Send( caller )
end

function ENT:Think()

end

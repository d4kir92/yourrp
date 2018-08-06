--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( "shared.lua" )

util.AddNetworkString( "openLawBoard" )

function ENT:Initialize()
	self:SetModel( "models/props_c17/Frame002a.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )

	self:SetPos(self:GetPos()+Vector(0,0,100))
	self:DropToFloor()
	local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
end

function ENT:Use( activator, caller )
	local tmpTable = SQL_SELECT( "yrp_jail", "*", nil )
	local tmpGroups = SQL_SELECT( "yrp_ply_groups", "*", nil )
	local tmpGeneral = SQL_SELECT( "yrp_general", "*", nil )
	local chaTab = caller:GetChaTab()
	local tmpRoles = SQL_SELECT( "yrp_roles", "*", "uniqueID = " .. chaTab.roleID .. "")

	if tmpTable == nil or tmpTable == false then
		tmpTable = {}
	end
	net.Start( "openLawBoard" )
		net.WriteTable( tmpTable )
		net.WriteTable( tmpGroups )
		net.WriteTable( tmpGeneral )
		net.WriteInt( tmpRoles[1].string_name, 16 )
	net.Send( caller )
end

function ENT:Think()

end

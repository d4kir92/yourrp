--Copyright (C) 2017-2022 D4KiR (https://www.gnu.org/licenses/gpl.txt)

AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( "shared.lua" )

function ENT:Initialize()
	self:SetModel( "models/items/item_item_crate.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )

	local phys = self:GetPhysicsObject()
	if (phys:IsValid() ) then
		phys:Wake()
	end
	self.delay = 0
end

function ENT:Think()
	if ea( self.viewmodel ) then
		local ang = self:GetAngles()
		ang.p = 0
		ang.r = 0
		self.viewmodel:SetPos( self:GetPos() + Vector( 0, 0, 40 ) )
		self.viewmodel:SetAngles( ang )
	end
end

function ENT:SetClassName( classname )
	self:SetYRPString( "classname", classname )

	if !ea( self.viewmodel ) then
		self.viewmodel = ents.Create( "prop_dynamic" )
		self.viewmodel:SetModel( "models/items/item_item_crate.mdl" )
		self.viewmodel:Spawn()
		--self.viewmodel:SetPos( self:GetPos() + Vector( 0, 0, 40 ) )
		--self.viewmodel:SetParent( self )
	end

	local mdl = ents.Create( classname )
	if ea( mdl ) then
		self.viewmodel:SetModel( mdl:GetModel() )
		mdl:Remove()
	end
end

function ENT:SetDisplayName( name )
	self:SetYRPString( "name", name )
end

function ENT:SetItemType( typ )
	self:SetYRPString( "type", typ )
end

function ENT:SetAmount( amount )
	self:SetYRPInt( "amount", amount )
end

function ENT:RemoveOne()
	self:SetYRPInt( "amount", self:GetYRPInt( "amount", 1 ) - 1 )
	if self:GetYRPInt( "amount", 1 ) == 0 then
		self:Remove()
	end
end

function ENT:Use( activator, caller )
	if activator:IsPlayer() then
		self.delay = self.delay or 0
		if self.delay < CurTime() then
			self.delay = CurTime() + 0.5
			if self:GetYRPString( "type" ) == "weapons" then
				local wep = activator:Give( self:GetYRPString( "classname", "" ) )
				if ea( wep ) then
					self:RemoveOne()
				else
					local weap = ents.Create( self:GetYRPString( "classname", "" ) )
					if ea( weap ) then
						weap:Spawn()
						tp_to( weap, activator:GetPos() + Vector( 0, 0, 42 ) )
						self:RemoveOne()
					end
				end
			end			
		end
	end
end


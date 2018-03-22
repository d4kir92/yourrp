--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

/*
local schdChase = ai_schedule.New( "yrp_dealer" )

schdChase:EngTask( "TASK_GET_PATH_TO_RANDOM_NODE", 	128 )
schdChase:EngTask( "TASK_RUN_PATH", 				0 )
schdChase:EngTask( "TASK_WAIT_FOR_MOVEMENT", 	0 )
schdChase:AddTask( "PlaySequence", 				{ Name = "cheer1", Speed = 1 } )

schdChase:AddTask( "FindEnemy", 		{ Class = "player", Radius = 2000 } )
schdChase:EngTask( "TASK_GET_PATH_TO_RANGE_ENEMY_LKP_LOS", 	0 )
schdChase:EngTask( "TASK_RUN_PATH", 				0 )
schdChase:EngTask( "TASK_WAIT_FOR_MOVEMENT", 	0 )

schdChase:EngTask( "TASK_STOP_MOVING", 			0 )
schdChase:EngTask( "TASK_FACE_ENEMY", 			0 )
schdChase:EngTask( "TASK_ANNOUNCE_ATTACK", 		0 )
schdChase:EngTask( "TASK_RANGE_ATTACK1", 		0 )
schdChase:EngTask( "TASK_RELOAD", 				0 )
*/

function ENT:Initialize()
	self:SetHullType( HULL_HUMAN )
	self:SetHullSizeNormal( )
	self:SetNPCState( NPC_STATE_SCRIPT )
	self:SetSolid(  SOLID_BBOX )
	self:CapabilitiesAdd( CAP_ANIMATEDFACE )
	self:CapabilitiesAdd( CAP_TURN_HEAD )
	self:DropToFloor()

	self:SetHealth( 100 )

	self:SetUseType( SIMPLE_USE )
	if IsDealerImmortal() then
		self:SetNWBool( "immortal", true )
	else
		self:SetNWBool( "immortal", false )
	end
end

function ENT:OnTakeDamage(dmg)
	self:SetHealth(self:Health() - dmg:GetDamage())
	if IsDealerImmortal() then
		self:SetNWBool( "immortal", true )
	else
		self:SetNWBool( "immortal", false )
		if self:Health() <= 0 then
			self:SetSchedule( SCHED_FALL_TO_GROUND )
			local _rd = ents.Create( "prop_ragdoll" )
			_rd:SetModel( self:GetModel() )
			_rd:SetPos( self:GetPos() )
			_rd:SetAngles( self:GetAngles() )
			_rd:Spawn()
			self:Remove()
			timer.Simple( 9, function()
				if tostring( _rd ) != "[NULL Entity]" then
					_rd:Remove()
				end
			end)
		end
	end
end

function ENT:SelectSchedule()
	//self:StartSchedule( schdChase )
end

function ENT:Open( activator, caller )
	if IsDealerImmortal() then
		self:SetNWBool( "immortal", true )
	else
		self:SetNWBool( "immortal", false )
	end
	if !activator:GetNWBool( "open_menu", false ) then
		openBuyMenu( activator, self:GetNWString( "dealerID", "-1" ) )

		activator:SetNWBool( "open_menu", true )
		timer.Simple( 1, function()
			activator:SetNWBool( "open_menu", false )
		end)
	end
end

function ENT:AcceptInput( input, entActivator, entCaller, data )
	if string.lower(input) == "use" then
		self:Open( entActivator, entCaller )
		return
	end
end

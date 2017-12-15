
SWEP.Author = "D4KiR"
SWEP.Contact = "youtube.com/c/D4KiR"
SWEP.Purpose = ""
SWEP.Instructions = "Leftclick - arrest\nRightclick - unarrest"

--The category that you SWep will be shown in, in the Spawn (Q) Menu
--(This can be anything, GMod will create the categories for you)
SWEP.Category = "YourRP"

--The name of the SWep, as appears in the weapons tab in the spawn menu(Q Menu)
SWEP.PrintName = "Arrest stick"

--Sets the position of the weapon in the switching menu
--(appears when you use the scroll wheel or keys 1-6 by default)
SWEP.Slot = 1
SWEP.SlotPos = 1

--Sets drawing the ammuntion levels for this weapon
SWEP.DrawAmmo = false

--Sets the drawing of the crosshair when this weapon is deployed
SWEP.DrawCrosshair = true

SWEP.Spawnable = true -- Whether regular players can see it
SWEP.AdminSpawnable = true -- Whether Admins/Super Admins can see it

SWEP.ViewModel = "models/weapons/v_stunbaton.mdl" -- This is the model used for clients to see in first person.
SWEP.WorldModel = "models/weapons/w_stunbaton.mdl" -- This is the model shown to all other clients and in third-person.

--This determins how big each clip/magazine for the gun is. You can
--set it to -1 to disable the ammo system, meaning primary ammo will
--not be displayed and will not be affected.
SWEP.Primary.ClipSize = -1

--This sets the number of rounds in the clip when you first get the gun. Again it can be set to -1.
SWEP.Primary.DefaultClip = -1

--Obvious. Determines whether the primary fire is automatic. This should be true/false
SWEP.Primary.Automatic = false

--Sets the ammunition type the gun uses, see below for a list of types.
SWEP.Primary.Ammo = "none"
SWEP.Secondary.Ammo = "none"

SWEP.DrawCrosshair = true

SWEP.HoldType = "melee"
function SWEP:Initialize()
	self:SetWeaponHoldType( self.HoldType )
end

function SWEP:Reload()

end

function SWEP:Think()

end

local swingsound = Sound( "Weapon_Stunstick.Single" )
local hitsound = Sound( "Weapon_Stunstick.Melee_Hit" )

SWEP.delay = 0
SWEP.cooldown = 0.4

function SWEP:PrimaryAttack()

	local ply = self:GetOwner()

	if CurTime() < self.delay then return end
	self.delay = CurTime() + self.cooldown

	local ply = self:GetOwner()
	local tr = util.QuickTrace( ply:EyePos(), ply:GetAimVector() * 64, ply )
	if tr.Hit then
		self.Weapon:SendWeaponAnim( ACT_VM_HITCENTER )
		ply:SetAnimation( PLAYER_ATTACK1 )

		ply:EmitSound( hitsound )
		if tr.Entity:IsPlayer() then
			if SERVER then
				teleportToJailpoint( tr.Entity )
				tr.Entity:SetNWBool( "inJail", true )
				--tr.Entity:SetNWInt( "jailtime", 9000 )
			end
		end
	else
		self.Weapon:SendWeaponAnim( ACT_VM_MISSCENTER )
		ply:SetAnimation( PLAYER_ATTACK1 )

		ply:EmitSound( swingsound )
	end
end

function SWEP:SecondaryAttack()
	local ply = self:GetOwner()

	if CurTime() < self.delay then return end
	self.delay = CurTime() + self.cooldown

	local ply = self:GetOwner()
	local tr = util.QuickTrace( ply:EyePos(), ply:GetAimVector() * 64, ply )
	if tr.Hit then
		self.Weapon:SendWeaponAnim( ACT_VM_HITCENTER )
		ply:SetAnimation( PLAYER_ATTACK1 )

		ply:EmitSound( hitsound )
		if tr.Entity:IsPlayer() then
			if SERVER then
				teleportToReleasepoint( tr.Entity )
				tr.Entity:SetNWBool( "inJail", false )
			end
		end
	else
		self.Weapon:SendWeaponAnim( ACT_VM_MISSCENTER )
		ply:SetAnimation( PLAYER_ATTACK1 )

		ply:EmitSound( swingsound )
	end
end

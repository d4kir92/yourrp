
SWEP.Author = "D4KiR"
SWEP.Contact = "youtube.com/c/D4KiR"
SWEP.Purpose = ""
SWEP.Instructions = "Leftclick - arrest\nRightclick - unarrest"

SWEP.Category = "YourRP Admin"

SWEP.PrintName = "Arrest stick"
SWEP.Language = "en"
SWEP.LanguageString = "arreststick"

SWEP.Slot = 1
SWEP.SlotPos = 1

SWEP.DrawAmmo = false

SWEP.DrawCrosshair = true

SWEP.Spawnable = true
SWEP.AdminSpawnable = true

SWEP.ViewModel = "models/weapons/v_stunbaton.mdl"
SWEP.WorldModel = "models/weapons/w_stunbaton.mdl"

SWEP.Primary.ClipSize = -1

SWEP.Primary.DefaultClip = -1

SWEP.Primary.Automatic = false

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
				tr.Entity:SetNWInt( "jailtime", 500 )
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


SWEP.Author = "D4KiR"
SWEP.Contact = "youtube.com/c/D4KiR"
SWEP.Purpose = ""
SWEP.Instructions = "Leftclick - arrest\nRightclick - unarrest"

SWEP.Category = "[YourRP] Civil Protection"

SWEP.PrintName = "Arrest stick"
SWEP.Language = "en"
SWEP.LanguageString = "LID_arreststick"

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

SWEP.HoldType = "melee"
function SWEP:Initialize()
	self:SetWeaponHoldType(self.HoldType)
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

	if !ply:IsValid() then return false end

	if CurTime() < self.delay then return end
	self.delay = CurTime() + self.cooldown

	local tr = util.QuickTrace(ply:EyePos(), ply:GetAimVector() * 64, ply)
	if tr.Hit then
		self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER)
		ply:SetAnimation(PLAYER_ATTACK1)

		ply:EmitSound(hitsound)
		if tr.Entity:IsPlayer() then
			if SERVER then
				teleportToJailpoint(tr.Entity, 2 * 60, ply)
			end
		end
	else
		self.Weapon:SendWeaponAnim(ACT_VM_MISSCENTER)
		ply:SetAnimation(PLAYER_ATTACK1)

		ply:EmitSound(swingsound)
	end
end

function SWEP:SecondaryAttack()
	local ply = self:GetOwner()

	if CurTime() < self.delay then return end
	self.delay = CurTime() + self.cooldown

	local tr = util.QuickTrace(ply:EyePos(), ply:GetAimVector() * 64, ply)
	if tr.Hit then
		self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER)
		ply:SetAnimation(PLAYER_ATTACK1)

		ply:EmitSound(hitsound)
		if tr.Entity:IsPlayer() then
			if SERVER then
				teleportToReleasepoint(tr.Entity)
			end
		end
	else
		self.Weapon:SendWeaponAnim(ACT_VM_MISSCENTER)
		ply:SetAnimation(PLAYER_ATTACK1)

		ply:EmitSound(swingsound)
	end
end

local wave = Material( "vgui/entities/yrp_arrest_stick.png", "noclamp smooth" )
function SWEP:DrawWeaponSelection( x, y, wide, tall, alpha )
	surface.SetMaterial( wave )
	surface.SetDrawColor( Color( 255, 255, 255, 255 ) )
	surface.DrawTexturedRect( x + (wide - tall) / 2, y, tall, tall )
end


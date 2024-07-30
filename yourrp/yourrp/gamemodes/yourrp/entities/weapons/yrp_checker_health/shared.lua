SWEP.Author = "D4KiR"
SWEP.Contact = "youtube.com/c/D4KiR"
SWEP.Purpose = ""
SWEP.Instructions = "Leftclick - Healthcheck"
SWEP.Category = "[YourRP] Civil Protection"
SWEP.PrintName = "Health checker"
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

local swingsound = Sound("Weapon_Stunstick.Single")
local hitsound = Sound("Weapon_Stunstick.Melee_Hit")
SWEP.delay = 0
SWEP.cooldown = 0.4
function SWEP:PrimaryAttack()
	local ply = self:GetOwner()
	if not ply:IsValid() then return false end
	if CurTime() < self.delay then return end
	self.delay = CurTime() + self.cooldown
	local tr = util.QuickTrace(ply:EyePos(), ply:GetAimVector() * 64, ply)
	if tr.Hit then
		self:SendWeaponAnim(ACT_VM_HITCENTER)
		ply:SetAnimation(PLAYER_ATTACK1)
		ply:EmitSound(hitsound)
		if tr.Entity:IsPlayer() and CLIENT then
			chat.AddText("--- --- --- --- --- --- --- --- ---")
			chat.AddText(YRP:trans("LID_health") .. " ( " .. tr.Entity:RPName() .. " )" .. ": " .. tr.Entity:Health())
			chat.AddText(YRP:trans("LID_armor") .. " ( " .. tr.Entity:RPName() .. " )" .. ": " .. tr.Entity:Armor())
			chat.AddText("--- --- --- --- --- --- --- --- ---")
		end
	else
		self:SendWeaponAnim(ACT_VM_MISSCENTER)
		ply:SetAnimation(PLAYER_ATTACK1)
		ply:EmitSound(swingsound)
	end
end

function SWEP:SecondaryAttack()
	local ply = self:GetOwner()
	if not ply:IsValid() then return false end
	if CurTime() < self.delay then return end
	self.delay = CurTime() + self.cooldown
	self:SendWeaponAnim(ACT_VM_HITCENTER)
	ply:SetAnimation(PLAYER_ATTACK1)
	ply:EmitSound(hitsound)
	if CLIENT then
		chat.AddText("--- --- --- --- --- --- --- --- ---")
		chat.AddText(YRP:trans("LID_health") .. " ( " .. ply:RPName() .. " )" .. ": " .. ply:Health())
		chat.AddText(YRP:trans("LID_armor") .. " ( " .. ply:RPName() .. " )" .. ": " .. ply:Armor())
		chat.AddText("--- --- --- --- --- --- --- --- ---")
	end
end

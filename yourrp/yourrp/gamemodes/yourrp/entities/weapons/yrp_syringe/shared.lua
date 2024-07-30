SWEP.Author = "D4KiR"
SWEP.Contact = "youtube.com/c/D4KiR"
SWEP.Purpose = ""
SWEP.Instructions = ""
SWEP.Category = "[YourRP] Medical"
SWEP.PrintName = "Syringe"
SWEP.Language = "en"
SWEP.LanguageString = "LID_syringe"
SWEP.Slot = 1
SWEP.SlotPos = 1
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.ViewModel = "models/props_junk/PopCan01a.mdl"
SWEP.WorldModel = "models/props_junk/PopCan01a.mdl"
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"
SWEP.Secondary.Ammo = "none"
SWEP.DrawCrosshair = true
SWEP.HoldType = "normal"
function SWEP:Initialize()
	self:SetWeaponHoldType(self.HoldType)
end

function SWEP:Reload()
end

function SWEP:Think()
end

function SWEP:PrimaryAttack()
	local ply = self:GetOwner()
	local tr = util.QuickTrace(ply:EyePos(), ply:GetAimVector() * 64, ply)
	if tr.Hit then
		self.target = tr.Entity
		if tr.Entity:IsPlayer() then end --YRP:msg( "note", "bandaging" )
	end
end

function SWEP:SecondaryAttack()
end

local wave = Material("vgui/entities/yrp_syringe.png", "noclamp smooth")
function SWEP:DrawWeaponSelection(x, y, wide, tall, alpha)
	surface.SetMaterial(wave)
	surface.SetDrawColor(Color(255, 255, 255, 255))
	surface.DrawTexturedRect(x + (wide - tall) / 2, y, tall, tall)
end

SWEP.Author = "D4KiR"
SWEP.Contact = "youtube.com/c/D4KiR"
SWEP.Purpose = "Shows the idcard"
SWEP.Instructions = "-"
SWEP.Category = "[YourRP] Roleplay"
SWEP.PrintName = "IDCard"
SWEP.Language = "en"
SWEP.LanguageString = "LID_idcard"
SWEP.Slot = 1
SWEP.SlotPos = 1
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.ViewModel = ""
SWEP.WorldModel = ""
SWEP.notdropable = true
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Ammo = "none"
SWEP.DrawCrosshair = false
SWEP.HoldType = "pistol"

function SWEP:Initialize()
	self:SetWeaponHoldType(self.HoldType)
end

function SWEP:Reload()
end

function SWEP:Think()
end

function SWEP:PrimaryAttack()
	if SERVER and self:GetOwner():IsValid() then
		local ent = self:GetOwner():GetEyeTrace().Entity

		if YRPEntityAlive(ent) and ent:GetPos():Distance(self:GetOwner():GetPos()) < GetGlobalYRPInt("int_door_distance", 200) and (ent:GetClass() == "prop_door_rotating" or ent:GetClass() == "func_door" or ent:GetClass() == "func_door_rotating") then
			YRPOpenDoor(self:GetOwner(), ent, 0)
		end
	end
end

function SWEP:SecondaryAttack()
end

local wave = Material("vgui/entities/yrp_idcard.png", "noclamp smooth")

function SWEP:DrawWeaponSelection(x, y, wide, tall, alpha)
	surface.SetMaterial(wave)
	surface.SetDrawColor(Color(255, 255, 255, 255))
	surface.DrawTexturedRect(x + (wide - tall) / 2, y, tall, tall)
end
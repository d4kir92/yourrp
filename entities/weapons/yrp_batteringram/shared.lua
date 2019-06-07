
SWEP.Author = "D4KiR"
SWEP.Contact = "youtube.com/c/D4KiR"
SWEP.Purpose = ""
SWEP.Instructions = ""

SWEP.Category = "[YourRP] Weapon"

SWEP.PrintName = "Battering ram"
SWEP.Language = "en"
SWEP.LanguageString = "LID_batteringram"

SWEP.Slot = 1
SWEP.SlotPos = 1

SWEP.DrawAmmo = false

SWEP.DrawCrosshair = false

SWEP.Spawnable = true
SWEP.AdminSpawnable = true

SWEP.ViewModel = "models/weapons/c_rpg.mdl"
SWEP.WorldModel = "models/weapons/w_rocket_launcher.mdl"

SWEP.Primary.ClipSize = -1

SWEP.Primary.DefaultClip = -1

SWEP.Primary.Automatic = false

SWEP.Primary.Ammo = "none"
SWEP.Secondary.Ammo = "none"

SWEP.DrawCrosshair = true

SWEP.HoldType = "rpg"
function SWEP:Initialize()
	self:SetWeaponHoldType(self.HoldType)
end

function SWEP:Reload()

end

function SWEP:Think()

end

local _target
function SWEP:PrimaryAttack()
	--if SERVER then
	if SERVER then
		local ply = self:GetOwner()
		local tr = util.QuickTrace(ply:EyePos(), ply:GetAimVector() * 64, ply)
		if tr.Hit then
			self.target = tr.Entity
			local class = tr.Entity:GetClass()
			if class ==  "func_door_rotating" or class ==  "func_door" or class == "prop_door_rotating" then
				self.target:Fire("Unlock")
				self.target:Fire("Open")

				self:GetOwner():EmitSound("physics/wood/wood_box_impact_hard2.wav", 75, 100, 1, CHAN_AUTO)
			end
		end
	end
end

function SWEP:SecondaryAttack()
	-- nothing
end

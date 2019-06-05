
SWEP.Author = "D4KiR"
SWEP.Contact = "youtube.com/c/D4KiR"
SWEP.Purpose = ""
SWEP.Instructions = ""

SWEP.Category = "[YourRP] Food"

SWEP.PrintName = "Food"
SWEP.Language = "en"
SWEP.LanguageString = "LID_food"

SWEP.Slot = 5
SWEP.SlotPos = 1

SWEP.DrawAmmo = false

SWEP.DrawCrosshair = false

SWEP.Spawnable = true
SWEP.AdminSpawnable = true

SWEP.ViewModel = "models/props_junk/PopCan01a.mdl"
SWEP.WorldModel = "models/props_junk/PopCan01a.mdl"

SWEP.Primary.ClipSize = 1
SWEP.Primary.DefaultClip = 1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "food"
SWEP.Secondary.Ammo = ""

SWEP.DrawCrosshair = true

SWEP.HoldType = "fist"
function SWEP:Initialize()
	self:SetWeaponHoldType(self.HoldType)
end

function SWEP:Reload()
	self:DefaultReload(ACT_VM_RELOAD)
end

function SWEP:Think()
	if SERVER and self:Clip1() <= 0 then
		self:Remove()
		self:GetOwner():SetActiveWeapon("yrp_unarmed")
		self:GetOwner():SelectWeapon("yrp_unarmed")
	end
end

local _target = nil
function SWEP:PrimaryAttack()
	if SERVER and self:Clip1() > 0 then
		local ply = self:GetOwner()
		self.target = ply
		ply:StartCasting("yrp_food_eating", "LID_eating", 0, self.target, 3, 100, 1, false)
	end
end

if SERVER then
	hook.Add("yrp_castdone_yrp_food_eating", "yrp_food_eating", function(args)
		args.target:Eat(10.0)
		args.attacker:GetActiveWeapon():TakePrimaryAmmo(1)
	end)
end


function SWEP:SecondaryAttack()
	--
end

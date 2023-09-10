SWEP.Author = "D4KiR"
SWEP.Contact = "youtube.com/c/D4KiR"
SWEP.Purpose = ""
SWEP.Instructions = ""
SWEP.Category = "[YourRP] Medical"
SWEP.PrintName = "Health Pack"
SWEP.Slot = 5
SWEP.SlotPos = 1
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false
SWEP.UseHands = true
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.ViewModel = "models/weapons/c_medkit.mdl"
SWEP.WorldModel = "models/weapons/w_medkit.mdl"
SWEP.Primary.ClipSize = 1
SWEP.Primary.DefaultClip = 1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "healthpack"
SWEP.Secondary.Ammo = "healthpacksecondary"
SWEP.HoldType = "fist"

function SWEP:Initialize()
	self:SetWeaponHoldType(self.HoldType)
end

function SWEP:Reload()
	self:DefaultReload(ACT_VM_RELOAD)
end

function SWEP:Think()
end

local _target = nil

function SWEP:PrimaryAttack()
	if SERVER and self:Clip1() > 0 then
		local ply = self:GetOwner()
		local tr = util.QuickTrace(ply:EyePos(), ply:GetAimVector() * 100, ply)

		if tr.Hit then
			self.target = tr.Entity

			if tr.Entity:IsPlayer() then
				--StartCasting(net_str, lang_str, mode, target, duration, range, cost, canmove)
				ply:StartCasting("healthpack", "LID_healing", 0, self.target, 3, 100, 1, false)
			end
		end
	end
end

if SERVER then
	hook.Add("yrp_castdone_healthpack", "healthpack", function(args)
		args.target:Heal(100)
		args.target:StopBleeding()
		args.attacker:GetActiveWeapon():TakePrimaryAmmo(1)
	end)
end

function SWEP:SecondaryAttack()
	if SERVER and self:Clip1() > 0 then
		local ply = self:GetOwner()
		_target = ply
		ply:StartCasting("healthpack", "LID_bandaging", 0, _target, 3, 100, 1, false)
	end
end

local wave = Material("vgui/entities/yrp_healthpack.png", "noclamp smooth")

function SWEP:DrawWeaponSelection(x, y, wide, tall, alpha)
	surface.SetMaterial(wave)
	surface.SetDrawColor(Color(255, 255, 255, 255))
	surface.DrawTexturedRect(x + (wide - tall) / 2, y, tall, tall)
end
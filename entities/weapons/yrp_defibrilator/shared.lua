
SWEP.Author = "D4KiR"
SWEP.Contact = "youtube.com/c/D4KiR"
SWEP.Purpose = ""
SWEP.Instructions = ""

SWEP.Category = "[YourRP] Medical"

SWEP.PrintName = "Defibrilator"

SWEP.Slot = 1
SWEP.SlotPos = 1

SWEP.DrawAmmo = false
SWEP.DrawCrosshair = true

SWEP.Spawnable = true
SWEP.AdminSpawnable = true

SWEP.UseHands = true
SWEP.ViewModel = ""
SWEP.WorldModel = ""

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"
SWEP.Secondary.Ammo = "none"

SWEP.HoldType = "normal"
function SWEP:Initialize()
	self:SetWeaponHoldType(self.HoldType)
end

function SWEP:Reload()

end

function SWEP:Think()

end

local _target
function SWEP:PrimaryAttack()
	if SERVER then
		local ply = self:GetOwner()
		local tr = util.QuickTrace(ply:EyePos(), ply:GetAimVector() * 64, ply)
		if tr.Hit then
			self.target = tr.Entity
			if tr.Entity:GetClass() == "prop_ragdoll" then
				ply:StartCasting("revive", "LID_revive", 0, self.target, 3, 100, 1, false)
			end
		end
	end
end

if SERVER then
	hook.Add("yrp_castdone_revive", "revive", function(args)
		if IsValid(args.target.ply) then
			local ply = args.target.ply
			local pos = ply:GetPos()
			if pos != nil then
				ply.ignorespawnpoint = true
				ply:Spawn()
				ply:SetPos(pos)
			end
		end
	end)
end

function SWEP:SecondaryAttack()
	
end

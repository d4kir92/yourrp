
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

function SWEP:PrimaryAttack()
	self.delay = self.delay or 0
	if CLIENT then
		if self.delay < CurTime() then
			self.delay = CurTime() + 1
			notification.AddLegacy( "[Spawn Corpse On Death] is disabled, which is needed for the defi", NOTIFY_HINT, 3)
		end
	end
	if SERVER then
		local ply = self:GetOwner()
		local tr = util.QuickTrace(ply:EyePos(), ply:GetAimVector() * 64, ply)
		if tr.Hit then
			self.target = tr.Entity
			if self.target:GetClass() == "prop_ragdoll" then
				ply:StartCasting( "revive", "LID_revive", 0, self.target, 0.1, 200, 1, false)
			end
		end
	end
end

if SERVER then
	hook.Add( "yrp_castdone_revive", "revive", function( args)
		if IsValid( args.target.ply) then
			local ragdoll = args.target
			local ply = args.target.ply
			local pos = ragdoll:GetPos()
			if pos != nil then
				ply:Revive(pos)
			else
				YRP.msg( "note", "[REVIVE] Ragdoll is not valid" )
			end
		else
			YRP.msg( "note", "[REVIVE] target player is not valid" )
		end
	end)
end

function SWEP:SecondaryAttack()
	
end

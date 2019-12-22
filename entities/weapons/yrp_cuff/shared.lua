
SWEP.Author = "D4KiR"
SWEP.Contact = "youtube.com/c/D4KiR"
SWEP.Purpose = ""
SWEP.Instructions = ""

SWEP.Category = "[YourRP] Weapon"

SWEP.PrintName = "Handcuffs"
SWEP.Language = "en"
SWEP.LanguageString = "LID_handcuffs"

SWEP.Slot = 1
SWEP.SlotPos = 1

SWEP.DrawAmmo = false

SWEP.DrawCrosshair = false

SWEP.Spawnable = true
SWEP.AdminSpawnable = true

SWEP.ViewModel = ""
SWEP.WorldModel = "models/Items/combine_rifle_ammo01.mdl"

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

local _target
function SWEP:PrimaryAttack()
	if SERVER then
		local ply = self:GetOwner()
		local tr = util.QuickTrace(ply:EyePos(), ply:GetAimVector() * 64, ply)
		if tr.Hit then
			self.target = tr.Entity
			if tr.Entity:IsPlayer() then
				ply:StartCasting("tieup", "LID_tieup", 0, self.target, 3, 100, 1, false)
			end
		end
	end
end

if CLIENT then

	function DrawCuff(ply)
		if ply:GetDBool("cuffed", false) then
			local _r_hand = ply:LookupBone("ValveBiped.Bip01_R_Hand")
			if _r_hand != nil then
				local startPos = ply:GetBonePosition(ply:LookupBone("ValveBiped.Bip01_R_Hand"))
				local _l_hand = ply:LookupBone("ValveBiped.Bip01_L_Hand")
				if _l_hand != nil then
					local endPos = ply:GetBonePosition(ply:LookupBone("ValveBiped.Bip01_L_Hand"))
					for i=0, 0.5, 0.01 do
						render.DrawLine(startPos-Vector(0,0,i), endPos-Vector(0,0,i), Color(100, 100, 100), true)
					end
				end
			end
		end
	end
	hook.Add("PrePlayerDraw", "DrawCuff", DrawCuff)
end

if SERVER then
	hook.Add("yrp_castdone_tieup", "tieup", function(args)
		if !args.target:GetDBool("cuffed", false) then
			args.target:Give("yrp_cuffed")
			args.target:SetActiveWeapon("yrp_cuffed")
			args.target:SelectWeapon("yrp_cuffed")
			args.target:SetDBool("cuffed", true)
		end
	end)
end

if SERVER then
	hook.Add("yrp_castdone_unleash", "unleash", function(args)
		if args.target:GetDBool("cuffed", false) then
			args.target:SetDBool("cuffed", false)
			local _weapon = args.target:GetActiveWeapon()
			if ea(_weapon) then
				_weapon:Remove()
			end
			args.target:SetActiveWeapon("yrp_unarmed")
			args.target:SelectWeapon("yrp_unarmed")
		end
	end)
end

function SWEP:SecondaryAttack()
	if SERVER then
		local ply = self:GetOwner()
		local tr = util.QuickTrace(ply:EyePos(), ply:GetAimVector() * 64, ply)
		if tr.Hit then
			self.target = tr.Entity
			if tr.Entity:IsPlayer() then
				ply:StartCasting("unleash", "LID_unleash", 0, self.target, 3, 100, 1, false)
			end
		end
	end
end

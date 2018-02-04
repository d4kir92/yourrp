
SWEP.Author = "D4KiR"
SWEP.Contact = "youtube.com/c/D4KiR"
SWEP.Purpose = ""
SWEP.Instructions = ""

SWEP.Category = "YourRP"

SWEP.PrintName = "Handcuffs"
SWEP.Language = "en"
SWEP.LanguageString = "handcuffs"

SWEP.Slot = 1
SWEP.SlotPos = 1

SWEP.DrawAmmo = false

SWEP.DrawCrosshair = false

SWEP.Spawnable = true
SWEP.AdminSpawnable = true

SWEP.ViewModel = "models/weapons/c_arms.mdl"
SWEP.WorldModel = ""

SWEP.Primary.ClipSize = -1

SWEP.Primary.DefaultClip = -1

SWEP.Primary.Automatic = false

SWEP.Primary.Ammo = "none"
SWEP.Secondary.Ammo = "none"

SWEP.DrawCrosshair = true

SWEP.HoldType = "normal"
function SWEP:Initialize()
	self:SetWeaponHoldType( self.HoldType )
end

function SWEP:Reload()

end

function SWEP:Think()

end

local _target
function SWEP:PrimaryAttack()
	if SERVER then
		local ply = self:GetOwner()
		local tr = util.QuickTrace( ply:EyePos(), ply:GetAimVector() * 64, ply )
		if tr.Hit then
			self.target = tr.Entity
			if tr.Entity:IsPlayer() then
				ply:StartCasting( "tieup", "tieup", 0, self.target, 3, 100, 1, false )
			end
		end
	end
end

if CLIENT then
	function DrawCuff( ply )
		if ply:GetNWBool( "cuffed" ) then
			local _r_hand = ply:LookupBone( "ValveBiped.Bip01_R_Hand" )
			if _r_hand != nil then
				local startPos = ply:GetBonePosition( ply:LookupBone( "ValveBiped.Bip01_R_Hand" ) )
				local _l_hand = ply:LookupBone( "ValveBiped.Bip01_L_Hand" )
				if _l_hand != nil then
					local endPos = ply:GetBonePosition( ply:LookupBone( "ValveBiped.Bip01_L_Hand" ) )
					local line = render.DrawLine( startPos, endPos, Color( 255, 0, 0 ), false )
				end
			end
		end
	end
	hook.Add( "PostPlayerDraw", "DrawCuff", DrawCuff )
end

if SERVER then
	hook.Add( "yrp_castdone_tieup", "tieup", function( args )
		args.target:SetActiveWeapon( "yrp_unarmed" )
		args.target:SelectWeapon( "yrp_unarmed" )
		args.target:SetNWBool( "cuffed", true )
	end)
end

if SERVER then
	hook.Add( "yrp_castdone_unleash", "unleash", function( args )
		args.target:SetNWBool( "cuffed", false )
	end)
end

function SWEP:SecondaryAttack()
	if SERVER then
		local ply = self:GetOwner()
		local tr = util.QuickTrace( ply:EyePos(), ply:GetAimVector() * 64, ply )
		if tr.Hit then
			self.target = tr.Entity
			if tr.Entity:IsPlayer() then
				ply:StartCasting( "unleash", "unleash", 0, self.target, 3, 100, 1, false )
			end
		end
	end
end

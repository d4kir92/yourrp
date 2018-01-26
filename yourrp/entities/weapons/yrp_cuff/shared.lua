
SWEP.Author = "D4KiR"
SWEP.Contact = "youtube.com/c/D4KiR"
SWEP.Purpose = ""
SWEP.Instructions = ""

SWEP.Category = "YourRP"

SWEP.PrintName = "Handcuffs"
SWEP.Language = "en"

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

function SWEP:PrimaryAttack()
	local ply = self:GetOwner()
	local tr = util.QuickTrace( ply:EyePos(), ply:GetAimVector() * 64, ply )
	if tr.Hit then
		self.target = tr.Entity
		if tr.Entity:IsPlayer() then
			self.cd = 3
			self.current = 0
			self.tick = 0.1
			ply:SetNWInt( "castMin", 0 )
			ply:SetNWInt( "castMax", self.cd )
			ply:SetNWBool( "casting", true )
			timer.Create( "handcuffPlayer" .. tostring(self.target), self.tick, 0, function()
				ply:SetNWInt( "castCur", self.current )
				if self.target != nil then
					if self.target:GetNWBool( "cuffed" ) then
						ply:SetNWString( "castName", lang_string( "unleash" ) )
						if ply:Health() > 0 and self.target:Health() > 0 and ply:KeyDown( IN_ATTACK ) and ply:GetPos():Distance( self.target:GetPos() ) < 64 then
							if tonumber( ply:GetNWInt( "castCur", 0 ) ) >= tonumber( self.cd ) then
								ply:SetNWBool( "casting", false )
								self.target:SetNWBool( "cuffed", false )
								timer.Remove( "handcuffPlayer" .. tostring(self.target) )
							end
						else
							ply:SetNWBool( "casting", false )
							timer.Remove( "handcuffPlayer" .. tostring(self.target) )
						end
					else
						ply:SetNWString( "castName", lang_string( "tieup" ) )
						if ply:Health() > 0 and self.target:Health() > 0 and ply:KeyDown( IN_ATTACK ) and ply:GetPos():Distance( self.target:GetPos() ) < 64 then
							if tonumber( ply:GetNWInt( "castCur", 0 ) ) >= tonumber( self.cd ) then
								ply:SetNWBool( "casting", false )
								if SERVER then
									self.target:SetActiveWeapon( "yrp_unarmed" )
							    self.target:SelectWeapon( "yrp_unarmed" )
								end
								self.target:SetNWBool( "cuffed", true )

								timer.Remove( "handcuffPlayer" .. tostring(self.target) )
							end
						else
							ply:SetNWBool( "casting", false )
							timer.Remove( "handcuffPlayer" .. tostring(self.target) )
						end
					end
				end
				self.current = self.current + self.tick
			end)
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

function SWEP:SecondaryAttack()

end


SWEP.Author = "D4KiR"
SWEP.Contact = "youtube.com/c/D4KiR"
SWEP.Purpose = ""
SWEP.Instructions = ""

--The category that you SWep will be shown in, in the Spawn (Q) Menu
--(This can be anything, GMod will create the categories for you)
SWEP.Category = "YourRP"

--The name of the SWep, as appears in the weapons tab in the spawn menu(Q Menu)
SWEP.PrintName = "YRP - Handcuffs"

--Sets the position of the weapon in the switching menu
--(appears when you use the scroll wheel or keys 1-6 by default)
SWEP.Slot = 1
SWEP.SlotPos = 1

--Sets drawing the ammuntion levels for this weapon
SWEP.DrawAmmo = false

--Sets the drawing of the crosshair when this weapon is deployed
SWEP.DrawCrosshair = false

SWEP.Spawnable = true -- Whether regular players can see it
SWEP.AdminSpawnable = true -- Whether Admins/Super Admins can see it

SWEP.ViewModel = "models/weapons/c_arms.mdl" -- This is the model used for clients to see in first person.
SWEP.WorldModel = "" -- This is the model shown to all other clients and in third-person.

--This determins how big each clip/magazine for the gun is. You can
--set it to -1 to disable the ammo system, meaning primary ammo will
--not be displayed and will not be affected.
SWEP.Primary.ClipSize = -1

--This sets the number of rounds in the clip when you first get the gun. Again it can be set to -1.
SWEP.Primary.DefaultClip = -1

--Obvious. Determines whether the primary fire is automatic. This should be true/false
SWEP.Primary.Automatic = false

--Sets the ammunition type the gun uses, see below for a list of types.
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
				if self.target:GetNWBool( "cuffed" ) then
					ply:SetNWString( "castName", lang.unleash )
					if ply:Health() > 0 and self.target:Health() > 0 and ply:KeyDown( IN_ATTACK ) and ply:GetPos():Distance( self.target:GetPos() ) < 64 then
						if self.target:IsPlayer() then
							self.target:SetRunSpeed( self.target:GetNWInt( "speedrun", 0 )*0.1 )
			        self.target:SetWalkSpeed( self.target:GetNWInt( "speedwalk", 0 )*0.1 )
						end
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
					ply:SetNWString( "castName", lang.tieup )
					if ply:Health() > 0 and self.target:Health() > 0 and ply:KeyDown( IN_ATTACK ) and ply:GetPos():Distance( self.target:GetPos() ) < 64 then
						if self.target:IsPlayer() then
							self.target:SetRunSpeed( self.target:GetNWInt( "speedrun", 0 )*0.1 )
			        self.target:SetWalkSpeed( self.target:GetNWInt( "speedwalk", 0 )*0.1 )
						end
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
				self.current = self.current + self.tick
			end)
		end
	end
end

if CLIENT then
	function DrawCuff( ply )
		if ply:GetNWBool( "cuffed" ) then
			local startPos = ply:GetBonePosition( ply:LookupBone( "ValveBiped.Bip01_R_Hand" ) )
			local endPos = ply:GetBonePosition( ply:LookupBone( "ValveBiped.Bip01_L_Hand" ) )
			local line = render.DrawLine( startPos, endPos, Color( 255, 0, 0 ), false )
		end
	end
	hook.Add( "PostPlayerDraw", "DrawCuff", DrawCuff )
end

function SWEP:SecondaryAttack()

end

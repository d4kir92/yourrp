
SWEP.Author = "D4KiR"
SWEP.Contact = "youtube.com/c/D4KiR"
SWEP.Purpose = "This item can unlock/lock the door that you owned"
SWEP.Instructions = "Left Click - Unlock door\nRight Click - Lock door"

--The category that you SWep will be shown in, in the Spawn (Q) Menu
--(This can be anything, GMod will create the categories for you)
SWEP.Category = "YourRP"

--The name of the SWep, as appears in the weapons tab in the spawn menu(Q Menu)
SWEP.PrintName = "Key"

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

SWEP.numbers = {}
function SWEP:AddKeyNr( nr )
  table.insert( self.numbers, nr )
end

function SWEP:PrimaryAttack()
	if SERVER then
	  if self.Owner:GetEyeTrace().Entity:GetClass() == "prop_door_rotating" or self.Owner:GetEyeTrace().Entity:GetClass() == "func_door" or self.Owner:GetEyeTrace().Entity:GetClass() == "func_door_rotating" then
	    if unlockDoor( self.Owner:GetEyeTrace().Entity, self.numbers ) then
	      self:GetOwner():PrintMessage( HUD_PRINTCENTER, lang_string( "unlockeddoor" ) )
	    else
	      self:GetOwner():PrintMessage( HUD_PRINTCENTER, lang_string( "youdonthaveakey" ) )
	    end
	  elseif self.Owner:GetEyeTrace().Entity:IsVehicle() then
			if unlockVehicle( self.Owner:GetEyeTrace().Entity, self.numbers ) then
	      self:GetOwner():PrintMessage( HUD_PRINTCENTER, lang_string( "unlockedvehicle" ) )
	    else
	      self:GetOwner():PrintMessage( HUD_PRINTCENTER, lang_string( "youdonthaveakey" ) )
	    end
		end
	end
end

function SWEP:SecondaryAttack()
  if SERVER then
    if self.Owner:GetEyeTrace().Entity:GetClass() == "prop_door_rotating" or self.Owner:GetEyeTrace().Entity:GetClass() == "func_door" or self.Owner:GetEyeTrace().Entity:GetClass() == "func_door_rotating" then
      if lockDoor( self.Owner:GetEyeTrace().Entity, self.numbers ) then
        self:GetOwner():PrintMessage( HUD_PRINTCENTER, lang_string( "lockeddoor" ) )
      else
        self:GetOwner():PrintMessage( HUD_PRINTCENTER, lang_string( "youdonthaveakey" ) )
      end
		elseif self.Owner:GetEyeTrace().Entity:IsVehicle() then
			if lockVehicle( self.Owner:GetEyeTrace().Entity, self.numbers ) then
        self:GetOwner():PrintMessage( HUD_PRINTCENTER, lang_string( "lockedvehicle" ) )
      else
        self:GetOwner():PrintMessage( HUD_PRINTCENTER, lang_string( "youdonthaveakey" ) )
      end
		end
  end
end

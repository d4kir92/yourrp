
SWEP.Author = "D4KiR"
SWEP.Contact = "youtube.com/c/D4KiR"
SWEP.Purpose = "This item can unlock/lock the door that you owned"
SWEP.Instructions = "Left Click - Unlock door\nRight Click - Lock door"

SWEP.Category = "YourRP"

SWEP.PrintName = "Key"
SWEP.Language = "en"
SWEP.LanguageString = "keys"

SWEP.Slot = 1
SWEP.SlotPos = 1

SWEP.DrawAmmo = false

SWEP.DrawCrosshair = false

SWEP.Spawnable = true
SWEP.AdminSpawnable = true

SWEP.ViewModel = "models/weapons/c_arms.mdl"
SWEP.WorldModel = ""
SWEP.UseHands = true

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

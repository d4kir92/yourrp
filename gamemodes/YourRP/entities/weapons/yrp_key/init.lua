//This makes sure clients download the file
AddCSLuaFile ("shared.lua")
AddCSLuaFile ("cl_init.lua")

include( "shared.lua" )

//How heavy the SWep is
SWEP.Weight = 5

//Allow automatic switching to/from this weapon when weapons are picked up
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

function SWEP:PrimaryAttack()
  for k, v in pairs( self.numbers ) do
    if unlockDoor( self.Owner:GetEyeTrace().Entity, v ) then
      self:GetOwner():PrintMessage( HUD_PRINTCENTER, "unlocked door" )
    else
      self:GetOwner():PrintMessage( HUD_PRINTCENTER, "You dont have a key for that" )
    end
  end
end

function SWEP:SecondaryAttack()
  for k, v in pairs( self.numbers ) do
    if lockDoor( self.Owner:GetEyeTrace().Entity, v ) then
      self:GetOwner():PrintMessage( HUD_PRINTCENTER, "locked door" )
    else
      self:GetOwner():PrintMessage( HUD_PRINTCENTER, "You dont have a key for that" )
    end
  end
end

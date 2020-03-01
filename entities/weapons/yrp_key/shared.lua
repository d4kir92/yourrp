
SWEP.Author = "D4KiR"
SWEP.Contact = "youtube.com/c/D4KiR"
SWEP.Purpose = "This item can unlock/lock the door that you owned"
SWEP.Instructions = "Left Click - Unlock door\nRight Click - Lock door"

SWEP.Category = "[YourRP] Roleplay"

SWEP.PrintName = "Key"
SWEP.Language = "en"
SWEP.LanguageString = "LID_keys"

SWEP.Slot = 1
SWEP.SlotPos = 1

SWEP.DrawAmmo = false

SWEP.DrawCrosshair = false

SWEP.Spawnable = true
SWEP.AdminSpawnable = true

SWEP.ViewModel = ""
SWEP.WorldModel = ""
SWEP.notdropable = true
SWEP.UseHands = true

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
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

SWEP.numbers = {}
function SWEP:AddKeyNr(nr)
	table.insert(self.numbers, nr)
end

function SWEP:PrimaryAttack()
	if SERVER and self:GetOwner():IsValid() then
		local ent = self:GetOwner():GetEyeTrace().Entity
		if ea(ent) and ent:GetPos():Distance(self:GetOwner():GetPos()) < GetGlobalDInt("int_door_distance", 200) then
			if ent:GetClass() == "prop_door_rotating" or ent:GetClass() == "func_door" or ent:GetClass() == "func_door_rotating" then
				if unlockDoor(self:GetOwner(), ent, ent:GetDString("buildingID", "Failed")) then
					self:GetOwner():PrintMessage(HUD_PRINTCENTER,YRP.lang_string("LID_unlockeddoor"))
				else
					self:GetOwner():PrintMessage(HUD_PRINTCENTER,YRP.lang_string("LID_youdonthaveakey"))
				end
			elseif ent:IsVehicle() and ent:GetDString("item_uniqueID", "Failed") != "Failed" then
				if unlockVehicle(self:GetOwner(), ent, ent:GetDString("item_uniqueID", "Failed")) then
					self:GetOwner():PrintMessage(HUD_PRINTCENTER,YRP.lang_string("LID_unlockedvehicle"))
				else
					self:GetOwner():PrintMessage(HUD_PRINTCENTER,YRP.lang_string("LID_youdonthaveakey"))
				end
			end
		end
	end
end

function SWEP:SecondaryAttack()
	if SERVER and self:GetOwner():IsValid() then
		local ent = self:GetOwner():GetEyeTrace().Entity
		if ea(ent) and ent:GetPos():Distance(self:GetOwner():GetPos()) < GetGlobalDInt("int_door_distance", 200) then
			if ent:GetClass() == "prop_door_rotating" or ent:GetClass() == "func_door" or ent:GetClass() == "func_door_rotating" then
				if lockDoor(self:GetOwner(), ent, ent:GetDString("buildingID", "Failed")) then
					self:GetOwner():PrintMessage(HUD_PRINTCENTER,YRP.lang_string("LID_lockeddoor"))
				else
					self:GetOwner():PrintMessage(HUD_PRINTCENTER,YRP.lang_string("LID_youdonthaveakey"))
				end
			elseif ent:IsVehicle() and ent:GetDString("item_uniqueID", "Failed") != "Failed" then
				if lockVehicle(self:GetOwner(), ent, ent:GetDString("item_uniqueID", "Failed")) then
					self:GetOwner():PrintMessage(HUD_PRINTCENTER,YRP.lang_string("LID_lockedvehicle"))
				else
					self:GetOwner():PrintMessage(HUD_PRINTCENTER,YRP.lang_string("LID_youdonthaveakey"))
				end
			end
		end
	end
end

local wave = Material( "vgui/entities/yrp_key.png", "noclamp smooth" )
function SWEP:DrawWeaponSelection( x, y, wide, tall, alpha )
	surface.SetMaterial( wave )
	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.DrawTexturedRect( x + (wide - tall) / 2, y, tall, tall )
end
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
SWEP.notdropable = true
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Ammo = "none"
SWEP.DrawCrosshair = true
SWEP.HoldType = "pistol"
SWEP.ViewModelFOV = 90
SWEP.ViewModelFlip = false
SWEP.UseHands = true
SWEP.ViewModel = "" --"models/props/yrp_key.mdl"
SWEP.WorldModel = "" --"models/props/yrp_key.mdl"
SWEP.ShowViewModel = true
SWEP.ShowWorldModel = true
if CLIENT then
	net.Receive(
		"nws_yrp_door_anim",
		function(self, len)
			local ply = net.ReadEntity()
			if YRPEntityAlive(ply) then
				local msg = net.ReadString()
				if msg == "lock" then
					ply:AnimRestartGesture(GESTURE_SLOT_CUSTOM, ACT_GMOD_GESTURE_ITEM_PLACE, true)
				elseif msg == "unlock" then
					ply:AnimRestartGesture(GESTURE_SLOT_CUSTOM, ACT_GMOD_GESTURE_ITEM_PLACE, true)
				elseif msg == "knock" then
					ply:AnimRestartGesture(GESTURE_SLOT_CUSTOM, ACT_HL2MP_GESTURE_RANGE_ATTACK_FIST, true)
				end
			end
		end
	)
end

function SWEP:Reload()
	if SERVER then
		local owner = self:GetOwner()
		owner.ts = owner.ts or CurTime()
		if YRPEntityAlive(owner) and owner.ts + 0.5 < CurTime() then
			owner.ts = CurTime()
			owner:EmitSound("physics/wood/wood_crate_impact_hard" .. math.random(1, 5) .. ".wav", 100, math.random(90, 110))
			net.Start("nws_yrp_door_anim")
			net.WriteEntity(owner)
			net.WriteString("knock")
			net.Broadcast()
		end
	end
end

function SWEP:Think()
end

SWEP.numbers = {}
function SWEP:AddKeyNr(nr)
	table.insert(self.numbers, nr)
end

function SWEP:PrimaryAttack()
	if SERVER and self:GetOwner() and self:GetOwner():IsValid() then
		local ent = self:GetOwner():GetEyeTrace().Entity
		if YRPEntityAlive(ent) and ent:GetPos():Distance(self:GetOwner():GetPos()) < GetGlobalYRPInt("int_door_distance", 200) then
			if ent:GetClass() == "prop_door_rotating" or ent:GetClass() == "func_door" or ent:GetClass() == "func_door_rotating" then
				if YRPLockDoor(self:GetOwner(), ent, ent:GetYRPString("buildingID", "Failed")) then
					self:GetOwner():PrintMessage(HUD_PRINTCENTER, YRP:trans("LID_lockeddoor"))
				else
					self:GetOwner():PrintMessage(HUD_PRINTCENTER, YRP:trans("LID_youdonthaveakey"))
				end
			elseif ent:IsVehicle() and ent:GetYRPInt("item_uniqueID", 0) ~= 0 then
				if YRPLockVehicle(self:GetOwner(), ent, ent:GetYRPInt("item_uniqueID", 0)) then
					self:GetOwner():PrintMessage(HUD_PRINTCENTER, YRP:trans("LID_lockedvehicle"))
				else
					self:GetOwner():PrintMessage(HUD_PRINTCENTER, YRP:trans("LID_youdonthaveakey"))
				end
			else
				if YRPLockVehicle(self:GetOwner(), ent, ent:GetYRPInt("item_uniqueID", 0)) then
					self:GetOwner():PrintMessage(HUD_PRINTCENTER, YRP:trans("LID_lockedvehicle"))
				else
					self:GetOwner():PrintMessage(HUD_PRINTCENTER, YRP:trans("LID_youdonthaveakey"))
				end
			end
		end
	end
end

function SWEP:SecondaryAttack()
	if SERVER and self:GetOwner() and self:GetOwner():IsValid() then
		local ent = self:GetOwner():GetEyeTrace().Entity
		if YRPEntityAlive(ent) and ent:GetPos():Distance(self:GetOwner():GetPos()) < GetGlobalYRPInt("int_door_distance", 200) then
			if ent:GetClass() == "prop_door_rotating" or ent:GetClass() == "func_door" or ent:GetClass() == "func_door_rotating" then
				if YRPUnlockDoor(self:GetOwner(), ent, ent:GetYRPString("buildingID", "Failed")) then
					self:GetOwner():PrintMessage(HUD_PRINTCENTER, YRP:trans("LID_unlockeddoor"))
				else
					self:GetOwner():PrintMessage(HUD_PRINTCENTER, YRP:trans("LID_youdonthaveakey"))
				end
			elseif ent:GetYRPInt("item_uniqueID", 0) ~= 0 then
				if YRPUnlockVehicle(self:GetOwner(), ent, ent:GetYRPInt("item_uniqueID", 0)) then
					self:GetOwner():PrintMessage(HUD_PRINTCENTER, YRP:trans("LID_unlockedvehicle"))
				else
					self:GetOwner():PrintMessage(HUD_PRINTCENTER, YRP:trans("LID_youdonthaveakey"))
				end
			else
				if YRPUnlockVehicle(self:GetOwner(), ent, ent:GetYRPInt("item_uniqueID", 0)) then
					self:GetOwner():PrintMessage(HUD_PRINTCENTER, YRP:trans("LID_unlockedvehicle"))
				else
					self:GetOwner():PrintMessage(HUD_PRINTCENTER, YRP:trans("LID_youdonthaveakey"))
				end
			end
		end
	end
end

local wave = Material("vgui/entities/yrp_key.png", "noclamp smooth")
function SWEP:DrawWeaponSelection(x, y, wide, tall, alpha)
	surface.SetMaterial(wave)
	surface.SetDrawColor(Color(255, 255, 255, 255))
	surface.DrawTexturedRect(x + (wide - tall) / 2, y, tall, tall)
end

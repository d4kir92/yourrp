SWEP.Author = "D4KiR"
SWEP.Contact = "youtube.com/c/D4KiR"
SWEP.Purpose = ""
SWEP.Instructions = "Leftclick - Weaponcheck"
SWEP.Category = "[YourRP] Civil Protection"
SWEP.PrintName = "Weapon checker"
SWEP.Slot = 1
SWEP.SlotPos = 1
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = true
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.ViewModel = "models/weapons/v_stunbaton.mdl"
SWEP.WorldModel = "models/weapons/w_stunbaton.mdl"
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"
SWEP.Secondary.Ammo = "none"
SWEP.HoldType = "melee"

function SWEP:Initialize()
	self:SetWeaponHoldType(self.HoldType)
end

function SWEP:Reload()
end

function SWEP:Think()
end

local swingsound = Sound("Weapon_Stunstick.Single")
local hitsound = Sound("Weapon_Stunstick.Melee_Hit")
SWEP.delay = 0
SWEP.cooldown = 0.5

function SWEP:PrimaryAttack()
	local ply = self:GetOwner()
	if not ply:IsValid() then return false end
	if CurTime() < self.delay then return end
	self.delay = CurTime() + self.cooldown
	local tr = util.QuickTrace(ply:EyePos(), ply:GetAimVector() * 64, ply)

	if tr.Hit and CLIENT then
		self:SendWeaponAnim(ACT_VM_HITCENTER)
		ply:SetAnimation(PLAYER_ATTACK1)
		ply:EmitSound(hitsound)

		if tr.Entity:IsPlayer() then
			if CLIENT then
				chat.AddText("--- --- --- --- --- --- --- --- ---")
				chat.AddText(YRP.trans("LID_weapons") .. " ( " .. tr.Entity:RPName() .. " )" .. ":")
			end

			for i, w in pairs(tr.Entity:GetWeapons()) do
				if CLIENT then
					local wn = w:GetPrintName() or w.PrintName
					local pa = tr.Entity:GetAmmoCount(w:GetPrimaryAmmoType())
					local sa = tr.Entity:GetAmmoCount(w:GetSecondaryAmmoType())
					chat.AddText(tostring(wn), " | PA: ", tostring(pa), " | SA: ", tostring(sa))
				end
			end

			if CLIENT then
				chat.AddText("--- --- --- --- --- --- --- --- ---")
			end
		end
	else
		self:SendWeaponAnim(ACT_VM_MISSCENTER)
		ply:SetAnimation(PLAYER_ATTACK1)
		ply:EmitSound(swingsound)
	end
end

function SWEP:SecondaryAttack()
	local ply = self:GetOwner()
	if not ply:IsValid() then return false end
	if CurTime() < self.delay then return end
	self.delay = CurTime() + self.cooldown
	self:SendWeaponAnim(ACT_VM_HITCENTER)
	ply:SetAnimation(PLAYER_ATTACK1)
	ply:EmitSound(hitsound)

	if CLIENT then
		chat.AddText("--- --- --- --- --- --- --- --- ---")
		chat.AddText(YRP.trans("LID_weapons") .. " ( " .. ply:RPName() .. " )" .. ":")
	end

	for i, w in pairs(ply:GetWeapons()) do
		if CLIENT then
			local wn = w:GetPrintName() or w.PrintName
			local pa = ply:GetAmmoCount(w:GetPrimaryAmmoType())
			local sa = ply:GetAmmoCount(w:GetSecondaryAmmoType())
			chat.AddText(wn, " | PA: ", pa, " | SA: ", sa)
		end
	end

	if CLIENT then
		chat.AddText("--- --- --- --- --- --- --- --- ---")
	end
end
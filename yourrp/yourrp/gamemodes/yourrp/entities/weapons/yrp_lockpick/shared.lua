SWEP.Author = "D4KiR"
SWEP.Contact = "youtube.com/c/D4KiR"
SWEP.Purpose = ""
SWEP.Instructions = ""
SWEP.Category = "[YourRP] Weapon"
SWEP.PrintName = "Lockpick (Normal)"
SWEP.Language = "en"
SWEP.LanguageString = "LID_lockpick"
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
	--if SERVER then
	if SERVER then
		local ply = self:GetOwner()
		if ply then
			local tr = util.QuickTrace(ply:EyePos(), ply:GetAimVector() * 64, ply)
			if tr.Hit then
				self.target = tr.Entity
				local ent = tr.Entity
				local class = tr.Entity:GetClass()
				if YRPEntityAlive(ent) and ent:GetPos():Distance(self:GetOwner():GetPos()) < GetGlobalYRPInt("int_door_distance", 200) and (class == "func_door_rotating" or class == "func_door" or class == "prop_door_rotating") then
					ply:StartCasting("lockpick", "LID_lockpicking", 0, self.target, 3, 50, 1, false)
					local filename = "doors/door_locked2.wav"
					util.PrecacheSound(filename)
					ply:EmitSound(filename, 75, 100, 1, CHAN_AUTO)
					timer.Create(
						"lockpick_loop",
						2,
						3,
						function()
							filename = "doors/door_locked2.wav"
							util.PrecacheSound(filename)
							ply:EmitSound(filename, 75, 100, 1, CHAN_AUTO)
						end
					)
				end
			end
		end
	end
end

if SERVER then
	hook.Add(
		"yrp_castdone_lockpick",
		"lockpick",
		function(args)
			timer.Remove("lockpick_loop")
			args.target:Fire("Unlock")
		end
	)

	hook.Add(
		"yrp_interupt_lockpick",
		"lockpick",
		function(args)
			timer.Remove("lockpick_loop")
		end
	)
end

function SWEP:SecondaryAttack()
end

-- nothing
local wave = Material("vgui/entities/yrp_lockpick.png", "noclamp smooth")
function SWEP:DrawWeaponSelection(x, y, wide, tall, alpha)
	surface.SetMaterial(wave)
	surface.SetDrawColor(Color(255, 255, 255, 255))
	surface.DrawTexturedRect(x + (wide - tall) / 2, y, tall, tall)
end
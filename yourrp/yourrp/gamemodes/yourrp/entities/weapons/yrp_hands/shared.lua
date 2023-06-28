SWEP.Author = "D4KiR"
SWEP.Contact = "youtube.com/c/D4KiR"
SWEP.Purpose = ""
SWEP.Instructions = ""
SWEP.Category = "[YourRP] Roleplay"
SWEP.PrintName = "Arms"
SWEP.Language = "en"
SWEP.LanguageString = "LID_arms"
SWEP.Slot = 1
SWEP.SlotPos = 1
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false
SWEP.UseHands = true
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.ViewModel = Model("models/weapons/c_arms.mdl")
SWEP.WorldModel = ""
SWEP.ViewModelFOV = 54
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Ammo = "none"
SWEP.HoldType = "normal"

function SWEP:Initialize()
	self:SetHoldType(self.HoldType)
	self.Time = 0
	self.Range = 150
end

function SWEP:Think()
	if self.Drag and (not self:GetOwner():KeyDown(IN_ATTACK) or not IsValid(self.Drag.Entity)) then
		self.Drag = nil
	end
end

function SWEP:PrimaryAttack()
	local Pos = self:GetOwner():GetShootPos()
	local Aim = self:GetOwner():GetAimVector()

	local Tr = util.TraceLine{
		start = Pos,
		endpos = Pos + Aim * self.Range,
		filter = player.GetAll(),
	}

	local HitEnt = Tr.Entity

	if self.Drag then
		HitEnt = self.Drag.Entity
	else
		if not IsValid(HitEnt) or HitEnt:GetMoveType() ~= MOVETYPE_VPHYSICS or HitEnt:IsVehicle() or HitEnt:GetYRPBool("NoDrag", false) or HitEnt.BlockDrag or IsValid(HitEnt:GetParent()) then return end

		if not self.Drag then
			self.Drag = {
				OffPos = HitEnt:WorldToLocal(Tr.HitPos),
				Entity = HitEnt,
				Fraction = Tr.Fraction,
			}
		end
	end

	if CLIENT or not IsValid(HitEnt) then return end
	local Phys = HitEnt:GetPhysicsObject()

	if IsValid(Phys) then
		local Pos2 = Pos + Aim * self.Range * self.Drag.Fraction
		local OffPos = HitEnt:LocalToWorld(self.Drag.OffPos)
		local Dif = Pos2 - OffPos
		local Nom = (Dif:GetNormal() * math.min(1, Dif:Length() / 100) * 500 - Phys:GetVelocity()) * Phys:GetMass()
		Phys:ApplyForceOffset(Nom, OffPos)
		Phys:AddAngleVelocity(-Phys:GetAngleVelocity() / 4)
	end
end

function SWEP:SecondaryAttack()
end

--
if CLIENT then
	local x, y = ScrW() / 2, ScrH() / 2
	local mainColor = Color(40, 40, 255, 255)
	local textColor = Color(255, 255, 255, 255)

	function SWEP:DrawHUD()
		if IsValid(self:GetOwner()) and self:GetOwner().GetVehicle and IsValid(self:GetOwner():GetVehicle()) then return end
		local Pos = self:GetOwner():GetShootPos()
		local Aim = self:GetOwner():GetAimVector()

		local Tr = util.TraceLine{
			start = Pos,
			endpos = Pos + Aim * self.Range,
			filter = player.GetAll(),
		}

		local HitEnt = Tr.Entity

		if IsValid(HitEnt) and HitEnt:GetMoveType() == MOVETYPE_VPHYSICS and not self.rDag and not HitEnt:IsVehicle() and not IsValid(HitEnt:GetParent()) and not HitEnt:GetYRPBool("NoDrag", false) then
			self.Time = math.min(1, self.Time + 2 * FrameTime())
		else
			self.Time = math.max(0, self.Time - 2 * FrameTime())
		end

		if self.Time > 0 and not self.Drag then
			textColor.a = mainColor.a * self.Time
			draw.SimpleText(YRP.trans("LID_drag"), "Y_30_500", x, y, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end

		if self.Drag and IsValid(self.Drag.Entity) then
			local Pos2 = Pos + Aim * 100 * self.Drag.Fraction
			local OffPos = self.Drag.Entity:LocalToWorld(self.Drag.OffPos)
			local A = OffPos:ToScreen()
			local B = Pos2:ToScreen()
			surface.SetDrawColor(mainColor)

			for size = 1, 5 do
				surface.DrawCircle(A.x, A.y, size, mainColor)
				surface.DrawCircle(B.x, B.y, size, mainColor)
			end

			surface.DrawLine(A.x, A.y, B.x, B.y)
		end
	end
end
--[[function SWEP:PreDrawViewModel( vm, pl, wep )
	return true
end]]
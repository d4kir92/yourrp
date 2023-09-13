SWEP.Author = "D4KiR"
SWEP.Contact = "youtube.com/c/D4KiR"
SWEP.Purpose = ""
SWEP.Instructions = ""
SWEP.Category = "[YourRP] Civil Protection"
SWEP.PrintName = "Handcuffs"
SWEP.Language = "en"
SWEP.LanguageString = "LID_handcuffs"
SWEP.Slot = 1
SWEP.SlotPos = 1
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = true
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.UseHands = true
SWEP.ViewModel = "models/perp2/v_fists.mdl"
SWEP.WorldModel = "models/katharsmodels/handcuffs/handcuffs-1.mdl"
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"
SWEP.Secondary.Ammo = "none"
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
	if SERVER then
		local ply = self:GetOwner()
		local tr = util.QuickTrace(ply:EyePos(), ply:GetAimVector() * 64, ply)

		if tr.Hit then
			self.target = tr.Entity

			if tr.Entity:IsPlayer() then
				ply:StartCasting("tieup", "LID_tieup", 0, self.target, 3, 100, 1, false)
			end
		end
	end
end

if CLIENT then
	function YRP_DrawCuff(ply)
		if ply.GetYRPBool and ply:GetYRPBool("cuffed", false) then
			local _r_hand = ply:LookupBone("ValveBiped.Bip01_R_Hand")

			if _r_hand ~= nil then
				local startPos = ply:GetBonePosition(ply:LookupBone("ValveBiped.Bip01_R_Hand"))
				local _l_hand = ply:LookupBone("ValveBiped.Bip01_L_Hand")

				if _l_hand ~= nil then
					local endPos = ply:GetBonePosition(ply:LookupBone("ValveBiped.Bip01_L_Hand"))
					render.DrawBeam(startPos, endPos, 1, 0, 0, Color(100, 100, 100))
				end
			end

			local t1 = ply:GetYRPEntity("cuff_target")
			local t2 = t1:GetYRPEntity("cuff_target")

			if IsValid(t1) and IsValid(t2) and t1:LookupBone("ValveBiped.Bip01_R_Hand") and t2:LookupBone("ValveBiped.Bip01_R_Hand") then
				t1 = t1:GetBonePosition(t1:LookupBone("ValveBiped.Bip01_R_Hand"))
				t2 = t2:GetBonePosition(t2:LookupBone("ValveBiped.Bip01_R_Hand"))
				render.DrawBeam(t1, t2, 1, 0, 0, Color(100, 100, 100))
			end
		end
	end

	hook.Add("PrePlayerDraw", "YRP_DrawCuff", YRP_DrawCuff)
end

if SERVER then
	function YRPUnleashPlayer(ply, target)
		target:SetYRPBool("cuffed", false)
		local _weapon = target:GetActiveWeapon()

		if YRPEntityAlive(_weapon) then
			_weapon:Remove()
		end

		if not target:HasWeapon("yrp_unarmed") then
			target:Give("yrp_unarmed")
		end

		target:SelectWeapon("yrp_unarmed")
		target:InteruptCasting()
	end

	hook.Add("yrp_castdone_tieup", "tieup", function(args)
		if not args.target:GetYRPBool("cuffed", false) then
			args.target:Give("yrp_cuffed")
			-- args.target:SetActiveWeapon( "yrp_cuffed" )
			args.target:SelectWeapon("yrp_cuffed")
			args.target:SetYRPBool("cuffed", true)
			local ply = args.attacker
			local target = args.target
			ply:SetYRPEntity("cuff_target", target)
			target:SetYRPEntity("cuff_target", ply)
			target:InteruptCasting()
		end
	end)
end

if SERVER then
	hook.Add("yrp_castdone_unleash", "unleash", function(args)
		if args.target:GetYRPBool("cuffed", false) then
			local ply = args.attacker
			local target = args.target
			YRPUnleashPlayer(ply, target)
		end
	end)
end

function SWEP:SecondaryAttack()
	if SERVER then
		local ply = self:GetOwner()
		local tr = util.QuickTrace(ply:EyePos(), ply:GetAimVector() * 64, ply)

		if tr.Hit then
			self.target = tr.Entity

			if tr.Entity:IsPlayer() then
				ply:StartCasting("unleash", "LID_unleash", 0, self.target, 3, 100, 1, false)
			end
		end
	end
end

local wave = Material("vgui/entities/yrp_cuffs.png", "noclamp smooth")

function SWEP:DrawWeaponSelection(x, y, wide, tall, alpha)
	surface.SetMaterial(wave)
	surface.SetDrawColor(Color(255, 255, 255, 255))
	surface.DrawTexturedRect(x + (wide - tall) / 2, y, tall, tall)
end

hook.Add("SetupMove", "YRP_SetupMove_Cuffs", function(ply, mv, cmd)
	if ply.GetYRPBool == nil then return end
	if not ply:GetYRPBool("cuffed", false) then return end
	local target = ply:GetYRPEntity("cuff_target")

	if IsValid(target) and target.IsPlayer and target:IsPlayer() then
		local TargetPoint = (target:IsPlayer() and target:GetShootPos()) or target:GetPos()
		local MoveDir = (TargetPoint - ply:GetPos()):GetNormal()
		local ShootPos = ply:GetShootPos() + Vector(0, 0, ply:Crouching() and 0)
		local Distance = 120
		local distFromTarget = ShootPos:Distance(TargetPoint)
		if distFromTarget <= (Distance + 5) then return end

		if ply:InVehicle() then
			if SERVER and (distFromTarget > (Distance * 3)) then
				ply:ExitVehicle()
			end

			return
		end

		local TargetPos = TargetPoint - (MoveDir * Distance)
		local xDif = math.abs(ShootPos[1] - TargetPos[1])
		local yDif = math.abs(ShootPos[2] - TargetPos[2])
		local zDif = math.abs(ShootPos[3] - TargetPos[3])
		local speedMult = 3 + ((xDif + yDif) * 0.5) ^ 1.01
		local vertMult = math.max((math.Max(300 - (xDif + yDif), -10) * 0.08) ^ 1.01 + (zDif / 2), 0)

		if target:GetGroundEntity() == ply then
			vertMult = -vertMult
		end

		local TargetVel = (TargetPos - ShootPos):GetNormal() * 10
		TargetVel[1] = TargetVel[1] * speedMult
		TargetVel[2] = TargetVel[2] * speedMult
		TargetVel[3] = TargetVel[3] * vertMult
		local dir = mv:GetVelocity()
		local clamp = 50
		local vclamp = 20
		local accel = 200
		local vaccel = 30 * (vertMult / 50)
		dir[1] = (dir[1] > TargetVel[1] - clamp or dir[1] < TargetVel[1] + clamp) and math.Approach(dir[1], TargetVel[1], accel) or dir[1]
		dir[2] = (dir[2] > TargetVel[2] - clamp or dir[2] < TargetVel[2] + clamp) and math.Approach(dir[2], TargetVel[2], accel) or dir[2]

		if ShootPos[3] < TargetPos[3] then
			dir[3] = (dir[3] > TargetVel[3] - vclamp or dir[3] < TargetVel[3] + vclamp) and math.Approach(dir[3], TargetVel[3], vaccel) or dir[3]
		end

		mv:SetVelocity(dir)

		if distFromTarget > 500 and SERVER and YRPUnleashPlayer then
			YRPUnleashPlayer(target, ply)
		end
	end
end)
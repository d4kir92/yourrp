SWEP.Author = "D4KiR"
SWEP.Contact = "youtube.com/c/D4KiR"
SWEP.Purpose = ""
SWEP.Instructions = "Leftclick - Create Releasepoint\nRightclick - Remove Releasepoint"
SWEP.Category = "[YourRP] Admin"
SWEP.PrintName = "Tool Releasepoint Spawner"
SWEP.Language = "en"
SWEP.LanguageString = "Tool Releasepoint Spawner"
SWEP.Slot = 1
SWEP.SlotPos = 1
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = true
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.AdminOnly = true
SWEP.ViewModel = "models/weapons/v_toolgun.mdl"
SWEP.WorldModel = "models/weapons/w_toolgun.mdl"
SWEP.Primary.ClipSize = 0
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"
SWEP.Secondary.ClipSize = 0
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
SWEP.DrawCrosshair = true
SWEP.HoldType = "pistol"

function SWEP:Initialize()
	self:SetWeaponHoldType(self.HoldType)
end

function SWEP:Reload()
	local pos = ""

	for i, v in pairs(GetGlobalYRPTable("yrp_releasepoints")) do
		pos = v.pos
	end

	if pos ~= "" then
		local s = StringToVector(pos)
		self:GetOwner():SetPos(s)
	end
end

local size = 8

function SWEP:PrimaryAttack()
	self.pdelay = self.pdelay or 0

	if self.pdelay < CurTime() then
		self.pdelay = CurTime() + 0.4

		if CLIENT then
			local lply = LocalPlayer()
			net.Start("nws_yrp_dbInsertIntoMap")
			net.WriteString("yrp_" .. GetMapNameDB())
			net.WriteString("position, angle, type")
			local tmpPos = string.Explode(" ", tostring(lply:GetPos()))
			local tmpAng = string.Explode(" ", tostring(lply:GetAngles()))
			local tmpString = "'" .. tonumber(tmpPos[1]) .. "," .. tonumber(tmpPos[2]) .. "," .. tonumber(tmpPos[3] + 4) .. "', '" .. tonumber(tmpAng[1]) .. "," .. tonumber(tmpAng[2]) .. "," .. tonumber(tmpAng[3]) .. "', 'releasepoint'"
			net.WriteString(tmpString)
			net.SendToServer()
		end

		if SERVER then
			local ply = self:GetOwner()
			local pos = Vector(0, 0, 0)

			local tr = util.TraceLine({
				start = ply:EyePos(),
				endpos = ply:EyePos() + ply:EyeAngles():Forward() * 10000,
				filter = function(ent)
					if ent:GetClass() == "prop_physics" then return true end
				end
			})

			pos = tr.HitPos or pos
			YRP.msg("db", "Added Releasepoint")
			UpdateReleasepointTable()
		end
	end
end

function SWEP:SecondaryAttack()
	if SERVER then
		local ply = self:GetOwner()
		local pos = Vector(0, 0, 0)

		local tr = util.TraceLine({
			start = ply:EyePos(),
			endpos = ply:EyePos() + ply:EyeAngles():Forward() * 10000,
			filter = function(ent)
				if ent:GetClass() == "prop_physics" then return true end
			end
		})

		pos = tr.HitPos or pos
		local found = false

		for i, v in pairs(GetGlobalYRPTable("yrp_releasepoints")) do
			local p = StringToVector(v.pos)

			if p:Distance(pos) < size * 2 then
				YRP_SQL_DELETE_FROM("yrp_" .. GetMapNameDB(), "uniqueID = '" .. v.uniqueID .. "'")
				YRP.msg("db", "Removed Spawner")
				found = true
			end
		end

		if not found then
			for i, v in pairs(GetGlobalYRPTable("yrp_releasepoints")) do
				local p = StringToVector(v.pos)

				if p:Distance(ply:GetPos()) < 160 then
					YRP_SQL_DELETE_FROM("yrp_" .. GetMapNameDB(), "uniqueID = '" .. v.uniqueID .. "'")
					YRP.msg("db", "Removed Spawner")
				end
			end
		end

		UpdateReleasepointTable()
	end
end

if CLIENT then
	local r = math.random(0, 255)
	local g = math.random(0, 255)
	local b = math.random(0, 255)
	local delay = CurTime()

	hook.Add("PostDrawTranslucentRenderables", "yrp_draw_releasepoint", function()
		if LocalPlayer():GetActiveWeapon():IsValid() and LocalPlayer():GetActiveWeapon():GetClass() == "yrp_tool_releasepointspawner" then
			if delay < CurTime() then
				delay = CurTime() + 0.1
				r = math.random(0, 255)
				g = math.random(0, 255)
				b = math.random(0, 255)
			end

			for i, v in pairs(GetGlobalYRPTable("yrp_releasepoints")) do
				local pos = StringToVector(v.pos)

				if LocalPlayer():GetPos():Distance(pos) < 6000 then
					render.SetColorMaterial()
					render.DrawSphere(pos, size, 16, 16, Color(r, g, b, 200))
				end
			end
		end
	end)
end
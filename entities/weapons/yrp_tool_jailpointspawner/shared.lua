
SWEP.Author = "D4KiR"
SWEP.Contact = "youtube.com/c/D4KiR"
SWEP.Purpose = ""
SWEP.Instructions = "Leftclick - Create Jailpoint\nRightclick - Remove Jailpoint"

SWEP.Category = "[YourRP] Admin"

SWEP.PrintName = "Tool Jailpoint Spawner"
SWEP.Language = "en"
SWEP.LanguageString = "Tool Jailpoint Spawner"

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
	for i, v in pairs(GetGlobalDTable("yrp_jailpoints")) do
		pos = v.pos
	end
	if pos != "" then
		self:GetOwner():SetPos(StringToVector(pos))
	end
end

local size = 8

function SWEP:PrimaryAttack()
	if CLIENT then
		local ply = LocalPlayer()
		net.Start("dbInsertIntoMap")
			net.WriteString("yrp_" .. GetMapNameDB())
			net.WriteString("position, angle, type")
			local tmpPos = string.Explode(" ", tostring(ply:GetPos()))
			local tmpAng = string.Explode(" ", tostring(ply:GetAngles()))
			local tmpString = "'" .. tonumber(tmpPos[1]) .. "," .. tonumber(tmpPos[2]) .. "," .. tonumber(tmpPos[3] + 4) .. "', '" .. tonumber(tmpAng[1]) .. "," .. tonumber(tmpAng[2]) .. "," .. tonumber(tmpAng[3]) .. "', 'jailpoint'"
			net.WriteString(tmpString)
		net.SendToServer()
	end

	if SERVER then
		local ply = self:GetOwner()

		local pos = Vector(0, 0, 0)
		local tr = util.TraceLine( {
			start = ply:EyePos(),
			endpos = ply:EyePos() + ply:EyeAngles():Forward() * 10000,
			filter = function( ent ) if ( ent:GetClass() == "prop_physics" ) then return true end end
		} )
		pos = tr.HitPos or pos

		YRP.msg("db", "Added Jailpoint")

		UpdateJailpointTable()
	end
end

function SWEP:SecondaryAttack()
	if SERVER then
		local ply = self:GetOwner()

		local pos = Vector(0, 0, 0)
		local tr = util.TraceLine( {
			start = ply:EyePos(),
			endpos = ply:EyePos() + ply:EyeAngles():Forward() * 10000,
			filter = function( ent ) if ( ent:GetClass() == "prop_physics" ) then return true end end
		} )
		pos = tr.HitPos or pos

		for i, v in pairs(GetGlobalDTable("yrp_jailpoints")) do
			local p = StringToVector(v.pos)
			if p:Distance(pos) < size * 2 then
				SQL_DELETE_FROM("yrp_" .. GetMapNameDB(), "uniqueID = '" .. v.uniqueID .. "'")
				YRP.msg("db", "Removed Jailpoint")
			end
		end

		UpdateJailpointTable()
	end
end

function StringToVector(str)
	local tab = string.Explode(",", str)
	local vec = Vector(tab[1], tab[2], tab[3])
	return vec
end

if CLIENT then
	local r = math.random(0, 255)
	local g = math.random(0, 255)
	local b = math.random(0, 255)
	local delay = CurTime()
	hook.Add("PostDrawTranslucentRenderables", "yrp_draw_jailpoint", function()
		if LocalPlayer():GetActiveWeapon():IsValid() and LocalPlayer():GetActiveWeapon():GetClass() == "yrp_tool_jailpointspawner" then
			if delay < CurTime() then
				delay = CurTime() + 0.1
				r = math.random(0, 255)
				g = math.random(0, 255)
				b = math.random(0, 255)
			end
			for i, v in pairs(GetGlobalDTable("yrp_jailpoints")) do
				local pos = StringToVector(v.pos)
				if LocalPlayer():GetPos():Distance(pos) < 6000 then
					render.SetColorMaterial()
					render.DrawSphere(pos, size, 16, 16, Color(r, g, b, 200) )
				end
			end
		end
	end)
end

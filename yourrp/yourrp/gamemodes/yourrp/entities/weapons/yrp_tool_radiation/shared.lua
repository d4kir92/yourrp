SWEP.Author = "D4KiR"
SWEP.Contact = "youtube.com/c/D4KiR"
SWEP.Purpose = ""
SWEP.Instructions = "Leftclick - Create Radiation\nRightclick - Remove Radiation"
SWEP.Category = "[YourRP] Admin"
SWEP.PrintName = "Tool Radiation Spawner"
SWEP.Language = "en"
SWEP.LanguageString = "Tool Radiation"
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
	for i, v in pairs(GetGlobalYRPTable("yrp_radiation")) do
		pos = v.pos
	end

	if pos ~= "" then
		local s, e = StringToVector2(pos)
		local midpos = (s + e) / 2
		self:GetOwner():SetPos(midpos)
	end
end

if SERVER then
	YRP:AddNetworkString("nws_yrp_radiation_options")
end

local size = 128
local key_delay = CurTime()
local keydown = false
function SWEP:Think()
	if SERVER and key_delay < CurTime() then
		local ply = self:GetOwner()
		key_delay = CurTime() + 0.1
		if ply:KeyDown(IN_USE) and not keydown then
			keydown = true
			local pos = Vector(0, 0, 0)
			local tr = util.TraceLine(
				{
					start = ply:EyePos(),
					endpos = ply:EyePos() + ply:EyeAngles():Forward() * 10000,
					filter = function(ent)
						if ent:GetClass() == "prop_physics" then return true end
					end
				}
			)

			pos = tr.HitPos or pos
			for i, v in pairs(GetGlobalYRPTable("yrp_radiation")) do
				local p = StringToVector(v.pos)
				if p:Distance(pos) < size * 2 then
					YRP:msg("db", "Option Radiation")
					local stab = YRP_SQL_SELECT("yrp_" .. GetMapNameDB(), "*", "uniqueID = '" .. v.uniqueID .. "'")
					if IsNotNilAndNotFalse(stab) then
						stab = stab[1]
						net.Start("nws_yrp_radiation_options")
						net.WriteTable(stab)
						net.Send(ply)
					end
				end
			end
		elseif not ply:KeyDown(IN_USE) then
			keydown = false
		end
	end
end

if CLIENT then
	net.Receive(
		"nws_yrp_radiation_options",
		function()
			if YRPIsNoMenuOpen() then
				local stab = net.ReadTable()
				local w = YRPCreateD("YFrame", nil, YRP:ctr(800), YRP:ctr(800), 0, 0)
				w:Center()
				w:MakePopup()
				w:SetHeaderHeight(YRP:ctr(100))
				w:SetTitle("LID_radiation")
				-- name time
				w.nametext = YRPCreateD("YLabel", w:GetContent(), YRP:ctr(400), YRP:ctr(50), YRP:ctr(10), YRP:ctr(0))
				w.nametext:SetText("LID_name")
				w.name = YRPCreateD("DTextEntry", w:GetContent(), YRP:ctr(400), YRP:ctr(50), YRP:ctr(10), YRP:ctr(50))
				w.name:SetText(stab.name)
				function w.name:OnChange()
					local name = self:GetText()
					net.Start("nws_yrp_update_map_name")
					net.WriteString(stab.uniqueID)
					net.WriteString(name)
					net.SendToServer()
				end
			end
		end
	)
end

function SWEP:PrimaryAttack()
	self.pdelay = self.pdelay or 0
	if self.pdelay < CurTime() then
		self.pdelay = CurTime() + 0.4
		if CLIENT then
			local lply = LocalPlayer()
			if self.startpos == nil then
				self.startpos = string.Explode(" ", tostring(lply:GetPos()))
				self.startang = string.Explode(" ", tostring(lply:GetAngles()))
			else
				self.endpos = string.Explode(" ", tostring(lply:GetPos()))
				self.endang = string.Explode(" ", tostring(lply:GetAngles()))
				net.Start("nws_yrp_dbInsertIntoMap")
				net.WriteString("yrp_" .. GetMapNameDB())
				net.WriteString("position, angle, type")
				local tmpString = "'" .. self.startpos[1] .. "," .. self.startpos[2] .. "," .. self.startpos[3] .. "," .. self.endpos[1] .. "," .. self.endpos[2] .. "," .. self.endpos[3] .. "',"
				tmpString = tmpString .. " '" .. self.startang[1] .. "," .. self.startang[2] .. "," .. self.startang[3] .. "," .. self.endang[1] .. "," .. self.endang[2] .. "," .. self.endang[3] .. "',"
				tmpString = tmpString .. " 'radiation'"
				net.WriteString(tmpString)
				net.SendToServer()
				self.startpos = nil
				self.startang = nil
				self.endpos = nil
				self.endang = nil
			end
		end
	end
end

function IsInsideRadiation(ply)
	if not IsValid(ply) then return false end
	for i, v in pairs(GetGlobalYRPTable("yrp_radiation")) do
		local pos = string.Explode(",", v.pos)
		local spos = Vector(pos[1], pos[2], pos[3])
		local epos = Vector(pos[4], pos[5], pos[6])
		pos = ply:GetPos()
		local sx = math.min(spos.x, epos.x)
		local mx = math.max(spos.x, epos.x)
		local sy = math.min(spos.y, epos.y)
		local my = math.max(spos.y, epos.y)
		local sz = math.min(spos.z, epos.z)
		local mz = math.max(spos.z, epos.z)
		if (pos.x >= sx and pos.x <= mx) and (pos.y >= sy and pos.y <= my) and (pos.z >= sz and pos.z <= mz) then return true end
	end

	return false
end

function SWEP:SecondaryAttack()
	if SERVER then
		local ply = self:GetOwner()
		for i, v in pairs(GetGlobalYRPTable("yrp_radiation")) do
			local pos = string.Explode(",", v.pos)
			local spos = Vector(pos[1], pos[2], pos[3])
			local epos = Vector(pos[4], pos[5], pos[6])
			inbox = ents.FindInBox(spos, epos)
			for id, e in pairs(inbox) do
				if e == ply then
					YRP_SQL_DELETE_FROM("yrp_" .. GetMapNameDB(), "uniqueID = '" .. v.uniqueID .. "'")
					YRP:msg("db", "Removed Radiation")
				end
			end
		end

		UpdateRadiationTable()
	end
end

if CLIENT then
	local delay = CurTime()
	local r = math.random(0, 255)
	local g = math.random(0, 255)
	local b = math.random(0, 255)
	hook.Add(
		"PostDrawTranslucentRenderables",
		"yrp_draw_radiation",
		function()
			if LocalPlayer():GetActiveWeapon():IsValid() and LocalPlayer():GetActiveWeapon():GetClass() == "yrp_tool_radiation" then
				if delay < CurTime() then
					delay = CurTime() + 0.1
					r = math.random(0, 255)
					g = math.random(0, 255)
					b = math.random(0, 255)
				end

				for i, v in pairs(GetGlobalYRPTable("yrp_radiation")) do
					local pos = string.Explode(",", v.pos)
					local spos = Vector(pos[1], pos[2], pos[3])
					local epos = Vector(pos[4], pos[5], pos[6])
					if LocalPlayer():GetPos():Distance(spos) < 6000 then
						render.SetColorMaterial()
						render.DrawBox(spos, Angle(0, 0, 0), Vector(0, 0, 0), epos - spos, Color(40, 223, 40, 100))
						--render.DrawSphere(spos, size, 16, 16, Color(r, g, b, 200) )
					end
				end
			end
		end
	)
end

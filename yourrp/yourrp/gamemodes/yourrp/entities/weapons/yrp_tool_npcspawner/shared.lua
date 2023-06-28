SWEP.Author = "D4KiR"
SWEP.Contact = "youtube.com/c/D4KiR"
SWEP.Purpose = ""
SWEP.Instructions = "Leftclick - Create Spawner\nRightclick - Remove Spawner"
SWEP.Category = "[YourRP] Admin"
SWEP.PrintName = "Tool NPC Spawner"
SWEP.Language = "en"
SWEP.LanguageString = "LID_npcspawner"
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

	for i, v in pairs(GetGlobalYRPTable("yrp_spawner_npc")) do
		pos = v.pos
	end

	if pos ~= "" then
		local s = StringToVector(pos)
		self:GetOwner():SetPos(s)
	end
end

if SERVER then
	util.AddNetworkString("nws_yrp_spawner_npc_options")
end

local size = 8
local key_delay = CurTime()
local keydown = false

function SWEP:Think()
	if SERVER and key_delay < CurTime() then
		local ply = self:GetOwner()
		key_delay = CurTime() + 0.1

		if ply:KeyDown(IN_USE) and not keydown then
			keydown = true
			local pos = Vector(0, 0, 0)

			local tr = util.TraceLine({
				start = ply:EyePos(),
				endpos = ply:EyePos() + ply:EyeAngles():Forward() * 10000,
				filter = function(ent)
					if ent:GetClass() == "prop_physics" then return true end
				end
			})

			pos = tr.HitPos or pos

			for i, v in pairs(GetGlobalYRPTable("yrp_spawner_npc")) do
				local p = StringToVector(v.pos)

				if p:Distance(pos) < size * 2 then
					YRP.msg("db", "Option NPCSpawner")
					local stab = YRP_SQL_SELECT("yrp_" .. GetMapNameDB(), "*", "uniqueID = '" .. v.uniqueID .. "'")

					if IsNotNilAndNotFalse(stab) then
						stab = stab[1]
						net.Start("nws_yrp_spawner_npc_options")
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
	net.Receive("nws_yrp_spawner_npc_options", function()
		local stab = net.ReadTable()
		local sw = 700
		local w = YRPCreateD("YFrame", nil, YRP.ctr(800), YRP.ctr(800), 0, 0)
		w:Center()
		w:MakePopup()
		w:SetHeaderHeight(YRP.ctr(100))
		w:SetTitle("LID_npcspawner")
		-- Respawn time
		w.respawntext = YRPCreateD("YLabel", w:GetContent(), YRP.ctr(sw), YRP.ctr(50), YRP.ctr(10), YRP.ctr(0))
		w.respawntext:SetText(YRP.trans("LID_respawntime") .. " ( " .. YRP.trans("LID_seconds") .. " )")
		w.respawn = YRPCreateD("DNumberWang", w:GetContent(), YRP.ctr(sw), YRP.ctr(50), YRP.ctr(10), YRP.ctr(50))
		w.respawn:SetMin(1)
		w.respawn:SetMax(60 * 60 * 6)
		w.respawn:SetValue(stab.int_respawntime)

		function w.respawn:OnValueChanged()
			net.Start("nws_yrp_update_map_int_respawntime")
			net.WriteString(stab.uniqueID)
			net.WriteString(self:GetValue())
			net.SendToServer()
		end

		-- Amount
		w.amounttext = YRPCreateD("YLabel", w:GetContent(), YRP.ctr(sw), YRP.ctr(50), YRP.ctr(10), YRP.ctr(150))
		w.amounttext:SetText("LID_quantity")
		w.amount = YRPCreateD("DNumberWang", w:GetContent(), YRP.ctr(sw), YRP.ctr(50), YRP.ctr(10), YRP.ctr(200))
		w.amount:SetMin(1)
		w.amount:SetMax(10)
		w.amount:SetValue(stab.int_amount)

		function w.amount:OnValueChanged()
			net.Start("nws_yrp_update_map_int_amount")
			net.WriteString(stab.uniqueID)
			net.WriteString(self:GetValue())
			net.SendToServer()
		end

		-- ClassName
		w.classnametext = YRPCreateD("YLabel", w:GetContent(), YRP.ctr(sw), YRP.ctr(50), YRP.ctr(10), YRP.ctr(300))
		w.classnametext:SetText("LID_npc")
		w.classname = YRPCreateD("DComboBox", w:GetContent(), YRP.ctr(sw), YRP.ctr(50), YRP.ctr(10), YRP.ctr(350))
		w.classname:SetText(stab.string_classname)

		for i, v in pairs(list.Get("NPC")) do
			w.classname:AddChoice(i, i)
		end

		function w.classname:OnSelect()
			net.Start("nws_yrp_update_map_string_classname")
			net.WriteString(stab.uniqueID)
			net.WriteString(self:GetText())
			net.SendToServer()
		end

		-- swep
		w.sweptext = YRPCreateD("YLabel", w:GetContent(), YRP.ctr(sw), YRP.ctr(50), YRP.ctr(10), YRP.ctr(450))
		w.sweptext:SetText("LID_entity")
		w.swep = YRPCreateD("DComboBox", w:GetContent(), YRP.ctr(sw), YRP.ctr(50), YRP.ctr(10), YRP.ctr(500))
		w.swep:SetText(stab.string_swep)
		w.swep:AddChoice("", "")

		for i, v in pairs(YRPGetSWEPsList()) do
			w.swep:AddChoice(v.ClassName, v.ClassName)
		end

		function w.swep:OnSelect()
			net.Start("nws_yrp_update_map_string_swep")
			net.WriteString(stab.uniqueID)
			net.WriteString(self:GetText())
			net.SendToServer()
		end
	end)
end

function SWEP:PrimaryAttack()
	self.pdelay = self.pdelay or 0

	if self.pdelay < CurTime() then
		self.pdelay = CurTime() + 0.4

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
			YRP_SQL_INSERT_INTO("yrp_" .. GetMapNameDB(), "position, type, name", "'" .. string.Replace(tostring(pos), " ", ",") .. "', '" .. "spawner_npc" .. "', 'Spawner'")
			YRP.msg("db", "Added NPC Spawner")
			UpdateSpawnerNPCTable()
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

		for i, v in pairs(GetGlobalYRPTable("yrp_spawner_npc")) do
			local p = StringToVector(v.pos)

			if p:Distance(pos) < size * 2 then
				YRP_SQL_DELETE_FROM("yrp_" .. GetMapNameDB(), "uniqueID = '" .. v.uniqueID .. "'")
				YRP.msg("db", "Removed Spawner")
				found = true
			end
		end

		if not found then
			for i, v in pairs(GetGlobalYRPTable("yrp_spawner_npc")) do
				local p = StringToVector(v.pos)

				if p:Distance(ply:GetPos()) < 160 then
					YRP_SQL_DELETE_FROM("yrp_" .. GetMapNameDB(), "uniqueID = '" .. v.uniqueID .. "'")
					YRP.msg("db", "Removed Spawner")
				end
			end
		end

		UpdateSpawnerNPCTable()
	end
end

if CLIENT then
	local r = math.random(0, 255)
	local g = math.random(0, 255)
	local b = math.random(0, 255)
	local delay = CurTime()

	hook.Add("PostDrawTranslucentRenderables", "yrp_draw_spawner_npc", function()
		if LocalPlayer():GetActiveWeapon():IsValid() and LocalPlayer():GetActiveWeapon():GetClass() == "yrp_tool_npcspawner" then
			if delay < CurTime() then
				delay = CurTime() + 0.1
				r = math.random(0, 255)
				g = math.random(0, 255)
				b = math.random(0, 255)
			end

			for i, v in pairs(GetGlobalYRPTable("yrp_spawner_npc")) do
				local pos = StringToVector(v.pos)

				if LocalPlayer():GetPos():Distance(pos) < 6000 then
					render.SetColorMaterial()
					render.DrawSphere(pos, size, 16, 16, Color(r, g, b, 200))
				end
			end
		end
	end)
end
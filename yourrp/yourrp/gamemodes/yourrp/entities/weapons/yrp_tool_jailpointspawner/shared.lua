
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
	for i, v in pairs(GetGlobalYRPTable( "yrp_jailpoints" ) ) do
		pos = v.pos
	end
	if !strEmpty(pos) then
		local s = StringToVector(pos)
		
		self:GetOwner():SetPos(s)
	end
end

if SERVER then
	util.AddNetworkString( "nws_yrp_jailpoints_options" )
end

local size = 8

local key_delay = CurTime()
local keydown = false
function SWEP:Think()
	if SERVER and key_delay < CurTime() then
		local ply = self:GetOwner()
		key_delay = CurTime() + 0.1

		if ply:KeyDown(IN_USE) and !keydown then
			keydown = true
			local pos = Vector(0, 0, 0)
			local tr = util.TraceLine( {
				start = ply:EyePos(),
				endpos = ply:EyePos() + ply:EyeAngles():Forward() * 10000,
				filter = function( ent ) if ( ent:GetClass() == "prop_physics" ) then return true end end
			} )
			pos = tr.HitPos or pos

			for i, v in pairs(GetGlobalYRPTable( "yrp_jailpoints" ) ) do
				local p = StringToVector( v.pos)
				if p:Distance(pos) < size * 2 then
					YRP.msg( "db", "Option Jailpoint" )

					local stab = YRP_SQL_SELECT( "yrp_" .. GetMapNameDB(), "*", "type = 'jailpoint' AND uniqueID = '" .. v.uniqueID .. "'" )
					if IsNotNilAndNotFalse(stab) then
						stab = stab[1]
						net.Start( "nws_yrp_jailpoints_options" )
							net.WriteTable(stab)
						net.Send(ply)
					end
				end
			end
		elseif !ply:KeyDown(IN_USE) then
			keydown = false
		end
	end
end

if CLIENT then
	net.Receive( "nws_yrp_jailpoints_options", function()
		if YRPIsNoMenuOpen() then
			local stab = net.ReadTable()

			local w = YRPCreateD( "YFrame", nil, YRP.ctr(800), YRP.ctr(800), 0, 0)
			w:Center()
			w:MakePopup()
			w:SetHeaderHeight(YRP.ctr(100) )
			w:SetTitle( "LID_jailpoint" )

			-- name time
			w.nametext = YRPCreateD( "YLabel", w:GetContent(), YRP.ctr(400), YRP.ctr(50), YRP.ctr(10), YRP.ctr(0) )
			w.nametext:SetText( "LID_name" )
			w.name = YRPCreateD( "DTextEntry", w:GetContent(), YRP.ctr(400), YRP.ctr(50), YRP.ctr(10), YRP.ctr(50) )
			w.name:SetText(stab.name)
			function w.name:OnChange()
				local name = self:GetText()
				net.Start( "nws_yrp_update_map_name" )
					net.WriteString(stab.uniqueID)
					net.WriteString(name)
				net.SendToServer()
			end
		end
	end)
end

function SWEP:PrimaryAttack()
	self.pdelay = self.pdelay or 0
	if self.pdelay < CurTime() then
		self.pdelay = CurTime() + 0.4
		if CLIENT then
			local lply = LocalPlayer()
			net.Start( "nws_yrp_dbInsertIntoMap" )
				net.WriteString( "yrp_" .. GetMapNameDB() )
				net.WriteString( "position, angle, type" )
				local tmpPos = string.Explode( " ", tostring(lply:GetPos() ))
				local tmpAng = string.Explode( " ", tostring(lply:GetAngles() ))
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

			YRP.msg( "db", "Added Jailpoint" )

			UpdateJailpointTable()
		end
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

		local found = false
		for i, v in pairs(GetGlobalYRPTable( "yrp_jailpoints" ) ) do
			local p = StringToVector( v.pos)
			if p:Distance(pos) < size * 2 then
				YRP_SQL_DELETE_FROM( "yrp_" .. GetMapNameDB(), "type = 'jailpoint' AND uniqueID = '" .. v.uniqueID .. "'" )
				YRP.msg( "db", "Removed Spawner" )
				found = true
			end
		end

		if !found then
			for i, v in pairs(GetGlobalYRPTable( "yrp_jailpoints" ) ) do
				local p = StringToVector( v.pos)
				if p:Distance(ply:GetPos() ) < 160 then
					YRP_SQL_DELETE_FROM( "yrp_" .. GetMapNameDB(), "type = 'jailpoint' AND uniqueID = '" .. v.uniqueID .. "'" )
					YRP.msg( "db", "Removed Spawner" )
				end
			end
		end

		UpdateJailpointTable()
	end
end

if CLIENT then
	local r = math.random(0, 255)
	local g = math.random(0, 255)
	local b = math.random(0, 255)
	local delay = CurTime()
	hook.Add( "PostDrawTranslucentRenderables", "yrp_draw_jailpoint", function()
		if LocalPlayer():GetActiveWeapon():IsValid() and LocalPlayer():GetActiveWeapon():GetClass() == "yrp_tool_jailpointspawner" then
			if delay < CurTime() then
				delay = CurTime() + 0.1
				r = math.random(0, 255)
				g = math.random(0, 255)
				b = math.random(0, 255)
			end
			for i, v in pairs(GetGlobalYRPTable( "yrp_jailpoints" ) ) do
				local pos = StringToVector( v.pos)
				if LocalPlayer():GetPos():Distance(pos) < 6000 then
					render.SetColorMaterial()
					render.DrawSphere(pos, size, 16, 16, Color(r, g, b, 200) )
				end
			end
		end
	end)
end

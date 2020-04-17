--Copyright (C) 2017-2020 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

CreateConVar("yrp_cl_hud", 1, {}, "")
--##############################################################################
--Resolution Change
hook.Add("Initialize", "Resolution Change", function()
	vgui.CreateFromTable {
		Base = "Panel",
		PerformLayout = function()
			hook.Run("ResolutionChanged", ScrW(), ScrH())
		end
	} : ParentToHUD()
end)

hook.Add("ResolutionChanged", "Resolution Change", function(w, h)
	local rw, rh = getResolutionRatio()
	printGM("gm", "Changed Resolution to " .. w .. "x" .. h .. " (" .. rw .. ":" .. rh .. ")")
	changeFontSize()

	net.Start("ply_changed_resolution")
	net.SendToServer()
end)
--##############################################################################

--##############################################################################

function GM:DrawDeathNotice(x, y)
	--No Kill Feed
end

hook.Add("HUDShouldDraw", "yrp_hidehud", function(name)
	if GetGlobalDBool("bool_yrp_hud", false) then
		local lply = LocalPlayer()
		if lply:IsValid() then
			local hide = {
				CHudHealth = true,
				CHudBattery = true,
				CHudAmmo = true,
				CHudSecondaryAmmo = true,
				CHudCrosshair = GetGlobalDBool("bool_yrp_crosshair", false),
				CHudVoiceStatus = false,
				CHudDamageIndicator = true,
				CHudDeathNotice = true
			}

			if g_VoicePanelList != nil then
				g_VoicePanelList:SetVisible(false)
			end
			if (hide[ name ]) then return false end
		end
	end
end)

--##############################################################################

--##############################################################################
--includes
include("hud/cl_hud_map.lua")
include("hud/cl_hud_player.lua")
include("hud/cl_hud_view.lua")
include("hud/cl_hud_crosshair.lua")
--##############################################################################

Material("voice/icntlk_pl"):SetFloat("$alpha", 0)

function IsScreenshotting()
	if input.IsKeyDown(KEY_F12) or input.IsKeyDown(KEY_F5) then
		return true
	else
		return false
	end
end

function GM:PlayerStartVoice(pl)
	if pl != nil then
		if pl == LocalPlayer() then
			_showVoice = true
			net.Start("yrp_voice_start")
			net.SendToServer()
		end
		if pl.SteamID != nil then
			local stid = pl:SteamID()
			stid = stid or ""
			if stid == LocalPlayer():GetDString("voice_global_steamid") and pl:GetDInt("speak_channel", 0) == 2 then
				_showGlobalVoice = true
			end
		end
	end
end

function GM:PlayerEndVoice(pl)
	if pl == LocalPlayer() then
		_showVoice = false
		net.Start("yrp_voice_end")
		net.SendToServer()
	end
	local stid = pl:SteamID()
	stid = stid or ""
	if stid == LocalPlayer():GetDString("voice_global_steamid") then
		_showGlobalVoice = false
	end
end

function show_global_voice_info(ply)
	if _showGlobalVoice then
		local tab = {}
		tab["NAME"] = ply:RPName()
		draw.SimpleTextOutlined(YRP.lang_string("LID_makesanannoucment", tab) .. "!", "Y_24_500", ScrW2(), YRP.ctr(400), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
	end
end

function show_voice_info(ply)
	--Voice
	if _showVoice then
		local _voice_text = ""
		if GetGlobalDBool("bool_voice", false) then
			_voice_text = YRP.lang_string("LID_youarespeaking")
			if GetGlobalDBool("bool_voice_channels", false) then
				_voice_text = get_speak_channel_name(ply)
			elseif GetGlobalDBool("bool_voice_radio", false) then
				_voice_text = _voice_text .. " (" .. ply:FrequencyText() .. ")"
			end
		else
			_voice_text = YRP.lang_string("LID_voicechatisdisabled")
		end

		draw.SimpleTextOutlined(_voice_text, "Y_24_500", ScrW2(), YRP.ctr(500), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
	end
end

local _yrp_icon = Material("vgui/yrp/logo100_beta.png")
local star = Material("vgui/material/icon_star.png")

function DrawEquipment(ply, name)
	local _tmp = ply:GetDEntity(name, NULL)
	if ea(_tmp) then
		if tonumber(ply:GetDString("view_range", "0")) <= 0 then
			_tmp:SetNoDraw(true)
		else
			_tmp:SetNoDraw(false)
		end
	end
end

hook.Add("HUDPaint", "yrp_hud_safezone", function()
	local lply = LocalPlayer()
	if IsInsideSafezone(lply) then
		draw.SimpleText(YRP.lang_string("LID_safezone"), "Y_24_500", ScW() / 2, YRP.ctr(650), Color(100, 100, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
end)

hook.Add("HUDPaint", "yrp_hud_alert", function()
	local text = GetGlobalDString("yrp_alert", "")
	local font = "Y_100_500"

	surface.SetFont(font)
	local tw, th = surface.GetTextSize(text)
	if tw > ScW() then
		font = "Y_72_500"
		surface.SetFont(font)
		tw, th = surface.GetTextSize(text)
		if tw > ScW() then
			font = "Y_36_500"
			surface.SetFont(font)
			tw, th = surface.GetTextSize(text)
			if tw > ScW() then
				font = "Y_18_500"
			end
		end
	end


	draw.SimpleText(text, font, ScW() / 2, YRP.ctr(500), Color(255, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end)

local oldlevel = oldlevel or nil--ply:Level()
hook.Add("HUDPaint", "yrp_hud_levelup", function()
	local ply = LocalPlayer()
	if IsLevelSystemEnabled() then
		if oldlevel == nil then
			ply:Level()
		end
		if oldlevel != ply:Level() then
			oldlevel = ply:Level()

			surface.PlaySound("garrysmod/content_downloaded.wav")

			local levelup = createD("DFrame", nil, YRP.ctr(600), YRP.ctr(160), 0, 0)
			levelup:SetPos(ScrW() / 2 - levelup:GetWide() / 2, ScrH() / 2 - levelup:GetTall() / 2 - YRP.ctr(400))
			levelup:ShowCloseButton(false)
			levelup:SetTitle("")
			levelup.LID_levelup = YRP.lang_string("LID_levelup")
			local tab = {}
			tab["LEVEL"] = ply:Level()
			levelup.LID_levelx = YRP.lang_string("LID_levelx", tab)
			levelup.lucolor = Color(255, 255, 100, 255)
			levelup.lxcolor = Color(255, 255, 255, 255)
			levelup.brcolor = Color(0, 0, 0, 255)
			levelup.level = oldlevel
			function levelup:Paint(pw, ph)
				surface.SetFont("Y_36_500")
				local tw, th = surface.GetTextSize(self.LID_levelup)
				tw = tw + 2 * YRP.ctr(20)
				self.aw = self.aw or 0

				draw.RoundedBox(YRP.ctr(10), pw / 2 - self.aw / 2, 0, self.aw, ph, Color(0, 0, 0, 120))

				if self.aw < tw then
					self.aw = math.Clamp(self.aw + 5, 0, tw)
				else
					draw.SimpleTextOutlined(self.LID_levelup, "Y_36_500", pw / 2, ph / 4, self.lucolor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, self.brcolor)
					draw.SimpleTextOutlined(self.LID_levelx, "Y_24_500", pw / 2, ph / 4 * 3, self.lxcolor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, self.brcolor)
				end

				if self.level != ply:Level() then
					self:Remove()
				end
				self.delay = self.delay or CurTime() + 6
				if self.delay < CurTime() then
					self:Remove()
				end
			end
		end
	end
end)

local HUD_AVATAR = nil
local PAvatar = vgui.Create("DPanel")
function PAvatar:Paint(pw, ph)
	if GetGlobalDBool("bool_yrp_hud", false) then
		render.ClearStencil()
		render.SetStencilEnable(true)

			render.SetStencilWriteMask(1)
			render.SetStencilTestMask(1)

			render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_NEVER)

			render.SetStencilFailOperation(STENCILOPERATION_INCR)
			render.SetStencilPassOperation(STENCILOPERATION_KEEP)
			render.SetStencilZFailOperation(STENCILOPERATION_KEEP)

			render.SetStencilReferenceValue(1)

			drawRoundedBox(ph / 2, 0, 0, pw, ph, Color(255, 255, 255, 255))

			render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)

			if HUD_AVATAR != nil then
				HUD_AVATAR:SetPaintedManually(false)
				HUD_AVATAR:PaintManual()
				HUD_AVATAR:SetPaintedManually(true)
			end

		render.SetStencilEnable(false)
	end
end
timer.Simple(1, function()
	HUD_AVATAR = vgui.Create("AvatarImage", PAvatar)
	local ava = {}
	ava.w = 64
	ava.h = 64
	ava.x = 0
	ava.y = 0
	ava.version = -1
	function HUD_AVATAR:Think()
		if GetGlobalDBool("bool_yrp_hud", false) then
			local lply = LocalPlayer()
			if lply:GetDInt("hud_version", 0) != ava.version then
				ava.version = lply:GetDInt("hud_version", 0)

				ava.w = lply:HudValue("AV", "SIZE_W")
				ava.h = lply:HudValue("AV", "SIZE_H")
				ava.x = lply:HudValue("AV", "POSI_X")
				ava.y = lply:HudValue("AV", "POSI_Y")
				ava.visible = lply:HudValue("AV", "VISI")

				PAvatar:SetPos(ava.x, ava.y)
				PAvatar:SetSize(ava.h, ava.h)
				self:SetPlayer(LocalPlayer(), ava.h)
				if !ava.visible then
					PAvatar:SetSize(0, 0)
				end

				self:SetPos(0, 0)
				self:SetSize(PAvatar:GetWide(), PAvatar:GetTall())
			end
		end
	end
end)

SL = SL or vgui.Create("DHTML", nil)
SL.w = 64
SL.h = 64
SL.x = 0
SL.y = 0
SL.url = ""
SL.visible = false
SL.version = -1

YRP_PM = YRP_PM or vgui.Create("DModelPanel", nil)
YRP_PM.w = 64
YRP_PM.h = 64
YRP_PM.x = 0
YRP_PM.y = 0
YRP_PM.version = -1
YRP_PM.model = ""
function YRP_PM:Think()
	if GetGlobalDBool("bool_yrp_hud", false) then
		local lply = LocalPlayer()
		if !lply:IsValid() then return end
		if lply:GetDInt("hud_version", 0) != YRP_PM.version or YRP_PM.model != lply:GetPlayerModel() then
			YRP_PM.version = lply:GetDInt("hud_version", 0)
			YRP_PM.model = lply:GetPlayerModel()

			YRP_PM.w = lply:HudValue("PM", "SIZE_W")
			YRP_PM.h = lply:HudValue("PM", "SIZE_H")
			YRP_PM.x = lply:HudValue("PM", "POSI_X")
			YRP_PM.y = lply:HudValue("PM", "POSI_Y")
			YRP_PM.visible = lply:HudValue("PM", "VISI")

			YRP_PM:SetPos(YRP_PM.x, YRP_PM.y)
			YRP_PM:SetSize(YRP_PM.h, YRP_PM.h)
			YRP_PM:SetModel(YRP_PM.model)

			local lb = YRP_PM.Entity:LookupBone("ValveBiped.Bip01_Head1")
			if lb != nil then
				local eyepos = YRP_PM.Entity:GetBonePosition(lb)
				eyepos:Add(Vector(0, 0, 2))	-- Move up slightly
				YRP_PM:SetLookAt(eyepos - Vector(0, 0, 4))
				YRP_PM:SetCamPos(eyepos - Vector(0, 0, 4) - Vector(-26, 0, 0))	-- Move cam in front of eyes
				YRP_PM.Entity:SetEyeTarget(eyepos-Vector(-40, 0, 0))
			else
				YRP_PM:SetLookAt(Vector(0, 0, 40))
				YRP_PM:SetCamPos(Vector(50, 50, 50))
			end

			if !YRP_PM.visible then
				YRP_PM:SetModel("")
			end
		end

		if lply:GetDInt("hud_version", 0) != SL.version or SL.url != GetGlobalDString("text_server_logo", "") then
			SL.version = lply:GetDInt("hud_version", 0)
			SL.visible = lply:HudValue("SL", "VISI")
			SL.url = GetGlobalDString("text_server_logo", "")

			SL.w = lply:HudValue("SL", "SIZE_W")
			SL.h = lply:HudValue("SL", "SIZE_H")
			SL.x = lply:HudValue("SL", "POSI_X")
			SL.y = lply:HudValue("SL", "POSI_Y")

			SL:SetPos(SL.x, SL.y)
			SL:SetSize(SL.h, SL.h)
			SL:SetHTML(GetHTMLImage(SL.url, SL.h, SL.h))

			SL:SetVisible(SL.visible)
		end
	end
end

function YRP_PM:LayoutEntity(ent)
	local seq = ent:LookupSequence("menu_gman")
	if seq > -1 then
		ent:SetSequence(ent:LookupSequence("menu_gman"))
	end
	YRP_PM:RunAnimation()
	return
end

local tested = false
function TestYourRPContent()
	if !tested then
		tested = true
		local str = ""
		local files, directories = file.Find("addons/*", "GAME")
		for i, v in pairs(files) do
			if string.find(v, "1189643820") then
				local ts = file.Time("addons/" .. v, "GAME")
				if ts < 1585861486 then
					if str != "" then
						str = str .. "\n"
					end
					str = str .. v
				end
			end
		end
		LocalPlayer():SetDString("badyourrpcontent", str)
		LocalPlayer():SetDBool("badyourrpcontent", true)
	end
end
TestYourRPContent()
hook.Add("HUDPaint", "yrp_hud", function()
	local ply = LocalPlayer()

	DONE_LOADING = DONE_LOADING or false
	if !DONE_LOADING then
		draw.RoundedBox(0, 0, 0, ScrW(), ScrH(), Color(10, 10, 10))
	end

	if GetGlobalDBool("blinded", false) then
		surfaceBox(0, 0, ScrW(), ScrH(), Color(255, 255, 255, 255))
		surfaceText(YRP.lang_string("LID_blinded"), "Y_30_500", ScrW2(), ScrH2() + YRP.ctr(100), Color(255, 255, 0, 255), 1, 1)
	end
	if ply:IsFlagSet(FL_FROZEN) then
		surfaceText(YRP.lang_string("LID_frozen"), "Y_30_500", ScrW2(), ScrH2() + YRP.ctr(150), Color(255, 255, 0, 255), 1, 1)
	end
	if ply:GetDBool("cloaked", false) then
		surfaceText(YRP.lang_string("LID_cloaked"), "Y_30_500", ScrW2(), ScrH2() - YRP.ctr(400), Color(255, 255, 0, 255), 1, 1)
	end

	DrawEquipment(ply, "backpack")
	DrawEquipment(ply, "weaponprimary1")
	DrawEquipment(ply, "weaponprimary2")
	DrawEquipment(ply, "weaponsecondary1")
	DrawEquipment(ply, "weaponsecondary2")
	DrawEquipment(ply, "weapongadget")

	if !ply:InVehicle() then
		HudPlayer(ply)
		HudView()
		HudCrosshair()
	end

	show_voice_info(ply)
	show_global_voice_info(ply)

	if game.SinglePlayer() then
		draw.SimpleTextOutlined("[YourRP] " .. "DO NOT USE SINGLEPLAYER" .. "!", "Y_72_500", ScrW2(), ScrH2(), Color(255, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, YRP.ctr(1), Color(0, 0, 0, 255))
	end

	local _target = LocalPlayer():GetDString("hittargetName", "")
	if !strEmpty(_target) then
		surfaceText(YRP.lang_string("LID_target") .. ": " .. LocalPlayer():GetDString("hittargetName", ""), "Y_24_500", YRP.ctr(10), YRP.ctr(10), Color(255, 0, 0, 255), 0, 0)
		LocalPlayer():drawHitInfo()
	end

	if IsSpVisible() then
		local _br = {}
		_br.y = 50
		_br.x = 10

		local _r = 60

		local _sp = GetSpTable()

		draw.RoundedBox(ctrb(_r), _sp.x - _br.x, _sp.y - _br.y, _sp.w + 2 * _br.x, _sp.h + 2 * _br.y, getSpCaseColor())

		surface.SetDrawColor(255, 255, 255, 255)
		surface.SetMaterial(_yrp_icon	)
		surface.DrawTexturedRect(_sp.x + _sp.w / 2 - ctrb(246) / 2, _sp.y - ctrb(80 + 10), ctrb(246), ctrb(80))
	end

	if GetGlobalDBool("bool_wanted_system", false) and false then
		local stars = {}
		stars.size = YRP.ctr(80)
		stars.cur = stars.size
		stars.x = -YRP.ctr(32) + ScrW() - 6 * stars.size
		stars.y = YRP.ctr(32)

		-- Slot
		surface.SetDrawColor(0, 0, 0, 255)
		surface.SetMaterial(star)
		for x = 1, 5 do
			surface.DrawTexturedRect(stars.x + x * stars.size, stars.y, stars.cur, stars.cur)
		end

		stars.cur = YRP.ctr(60)
		stars.br = (stars.size - stars.cur) / 2
		surface.SetDrawColor(100, 100, 100, 255)
		for x = 1, 5 do
			surface.DrawTexturedRect(stars.x + x * stars.size + stars.br, stars.y + stars.br, stars.cur, stars.cur)
		end

		-- Current Stars
		surface.SetDrawColor(255, 255, 255, 255)
		for x = 1, 5 do
			if ply:GetDInt("yrp_stars", 0) >= x then
				surface.DrawTexturedRect(stars.x + x * stars.size + stars.br, stars.y + stars.br, stars.cur, stars.cur)
			end
		end
	end

	if !HasYRPContent() then
		draw.SimpleText("YOURRP CONTENT IS MISSING! (FROM SERVER COLLECTION)", "Y_60_500", ScrW2(), ScrH2(), Color(255, 255, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

	if LocalPlayer():GetDString("badyourrpcontent", "") != "" then
		draw.SimpleText("Your addon is outdated, please delete/redownload (addons folder):", "Y_30_500", ScrW2() + YRP.ctr(50), ScrH2() + YRP.ctr(50), Color(255, 0, 0, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		local addons = string.Explode("\n", LocalPlayer():GetDString("badyourrpcontent", ""))
		for i, v in pairs(addons) do
			draw.SimpleText("• " .. v, "Y_30_500", ScrW2() + YRP.ctr(50), ScrH2() + YRP.ctr(50) + i * YRP.ctr(50), Color(255, 0, 0, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		end
	end

	if GetGlobalDBool("bool_radiation", false) then
		LocalPlayer().radiation = LocalPlayer().radiation or CurTime()
		if LocalPlayer().radiation < CurTime() then
			LocalPlayer().radiation = CurTime() + math.Rand(0.1, 0.5)
			if IsInsideRadiation(LocalPlayer()) then
				LocalPlayer():EmitSound("tools/ifm/ifm_snap.wav")
			end
		end
	end
end)


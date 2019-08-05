--Copyright (C) 2017-2019 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

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
	local lply = LocalPlayer()
	if lply:IsValid() then
		local hide = {
			CHudHealth = true,
			CHudBattery = true,
			CHudAmmo = true,
			CHudSecondaryAmmo = true,
			CHudCrosshair = GetGlobalDBool("bool_yrp_crosshair", false),
			CHudVoiceStatus = false
		}

		if g_VoicePanelList != nil then
			g_VoicePanelList:SetVisible(false)
		end
		if (hide[ name ]) then return false end
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
		draw.SimpleTextOutlined(YRP.lang_string("LID_makesanannoucment", tab) .. "!", "HudBars", ScrW2(), YRP.ctr(400), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
	end
end

function show_voice_info(ply)
	--Voice
	if _showVoice then
		local _voice_text = ""
		if GetGlobalDBool("bool_voice", false) then
			_voice_text = YRP.lang_string("LID_youarespeaking")
			if GetGlobalDBool("bool_voice_channels", false) then
				if ply:GetDInt("speak_channel", -1) == 1 then
					_voice_text = YRP.lang_string("LID_speakgroup")
				elseif ply:GetDInt("speak_channel", -1) == 2 then
					_voice_text = YRP.lang_string("LID_speakglobal")
				else
					_voice_text = YRP.lang_string("LID_speaklocal")
				end
				--_voice_text = _voice_text .. ")"
			end
		else
			_voice_text = YRP.lang_string("LID_voicechatisdisabled")
		end

		draw.SimpleTextOutlined(_voice_text, "HudBars", ScrW2(), YRP.ctr(500), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
	end
end

local _yrp_icon = Material("vgui/yrp/logo100_beta.png")
local _yrp_testing = Material("yrp/warn_testing.png")
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

local oldlevel = nil
hook.Add("HUDPaint", "yrp_hud_levelup", function()
	local ply = LocalPlayer()

	if IsLevelSystemEnabled() then
		if oldlevel == nil then
			ply:Level()
		end
		if oldlevel != ply:Level() then
			oldlevel = ply:Level()

			surface.PlaySound("garrysmod/content_downloaded.wav")

			local levelup = createD("DFrame", nil, YRP.ctr(600), YRP.ctr(300), 0, 0)
			levelup:SetPos(ScrW() / 2 - levelup:GetWide() / 2, ScrH() / 2 - levelup:GetTall() / 2 - YRP.ctr(400))
			levelup:ShowCloseButton(false)
			levelup:SetTitle("")

			function levelup:Paint(pw, ph)
				draw.SimpleTextOutlined(YRP.lang_string("LID_levelup"), "HudHeader", pw / 2, ph / 2, Color(255, 255, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
				local tab = {}
				tab["LEVEL"] = ply:Level()
				draw.SimpleTextOutlined(YRP.lang_string("LID_levelx", tab), "HudBars", pw / 2, ph / 2 + YRP.ctr(80), Color(255, 255, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
				if oldlevel != ply:Level() then
					self:Remove()
				end
			end
			levelup.timer = timer.Simple(10, function()
				levelup:Remove()
			end)
		end
	end
end)

local HUD_AVATAR = nil
local PAvatar = vgui.Create("DPanel")
function PAvatar:Paint(pw, ph)
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
timer.Simple(1, function()
	HUD_AVATAR = vgui.Create("AvatarImage", PAvatar)
	local ava = {}
	ava.w = 64
	ava.h = 64
	ava.x = 0
	ava.y = 0
	ava.version = -1
	function HUD_AVATAR:Think()
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
end)

timer.Simple(2, function()
	local PM = vgui.Create("DModelPanel", nil)
	local pm = {}
	pm.w = 64
	pm.h = 64
	pm.x = 0
	pm.y = 0
	pm.version = -1
	function PM:Think()
		local lply = LocalPlayer()
		if lply:GetDInt("hud_version", 0) != pm.version then
			pm.version = lply:GetDInt("hud_version", 0)

			pm.w = lply:HudValue("PM", "SIZE_W")
			pm.h = lply:HudValue("PM", "SIZE_H")
			pm.x = lply:HudValue("PM", "POSI_X")
			pm.y = lply:HudValue("PM", "POSI_Y")
			pm.visible = lply:HudValue("PM", "VISI")

			PM:SetPos(pm.x, pm.y)
			PM:SetSize(pm.h, pm.h)
			PM:SetModel(lply:GetModel())
			if !pm.visible then
				PM:SetModel("")
			end
		end
	end
end)

hook.Add("HUDPaint", "yrp_hud", function()
	local ply = LocalPlayer()

	if GetGlobalDBool("blinded", false) then
		surfaceBox(0, 0, ScrW(), ScrH(), Color(255, 255, 255, 255))
		surfaceText(YRP.lang_string("LID_blinded"), "SettingsHeader", ScrW2(), ScrH2() + YRP.ctr(100), Color(255, 255, 0, 255), 1, 1)
	end
	if ply:IsFlagSet(FL_FROZEN) then
		surfaceText(YRP.lang_string("LID_frozen"), "SettingsHeader", ScrW2(), ScrH2() + YRP.ctr(150), Color(255, 255, 0, 255), 1, 1)
	end
	if ply:GetDBool("cloaked", false) then
		surfaceText(YRP.lang_string("LID_cloaked"), "SettingsHeader", ScrW2(), ScrH2() - YRP.ctr(400), Color(255, 255, 0, 255), 1, 1)
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
		draw.SimpleTextOutlined("[YourRP] " .. "DO NOT USE SINGLEPLAYER" .. "!", "72", ScrW2(), ScrH2(), Color(255, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, YRP.ctr(1), Color(0, 0, 0, 255))
	end

	local _target = LocalPlayer():GetDString("hittargetName", "")
	if !strEmpty(_target) then
		surfaceText(YRP.lang_string("LID_target") .. ": " .. LocalPlayer():GetDString("hittargetName", ""), "HudBars", YRP.ctr(10), YRP.ctr(10), Color(255, 0, 0, 255), 0, 0)
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

	if !ply:GetDBool("serverdedicated", false) then
		if !string.find(tostring(_yrp_testing), "error") then
			local icon = {}
			icon.s = 165 * 2
			surface.SetDrawColor(255, 255, 255, 255)
			surface.SetMaterial(_yrp_testing	)
			surface.DrawTexturedRect(ScrW() - YRP.ctr(icon.s), 0, YRP.ctr(icon.s), YRP.ctr(icon.s))
		else
			draw.SimpleText("YOURRP CONTENT IS MISSING/OUTDATED!", "HudBars", ScrW2(), ScrH2(), Color(255, 255, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
	end
end)
--##############################################################################

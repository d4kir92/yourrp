--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
CreateConVar("yrp_cl_hud", 1, {}, "")
hook.Add(
	"Initialize",
	"Resolution Change",
	function()
		vgui.CreateFromTable{
			Base = "Panel",
			PerformLayout = function()
				hook.Run("ResolutionChanged", ScrW(), ScrH())
			end
		}:ParentToHUD()
	end
)

hook.Add(
	"ResolutionChanged",
	"Resolution Change",
	function(w, h)
		changeFontSize()
		net.Start("nws_yrp_ply_changed_resolution")
		net.SendToServer()
	end
)

function GM:DrawDeathNotice(x, y)
end

hook.Add(
	"HUDShouldDraw",
	"yrp_HUDShouldDraw_hidehud",
	function(name)
		if GetGlobalYRPBool("bool_yrp_hud", false) then
			local lply = LocalPlayer()
			if lply:IsValid() then
				local hide = {
					CHudHealth = true,
					CHudBattery = true,
					CHudAmmo = true,
					CHudSecondaryAmmo = true,
					CHudCrosshair = GetGlobalYRPBool("bool_yrp_crosshair", false),
					CHudVoiceStatus = false,
					CHudDamageIndicator = true,
					CHudDeathNotice = true
				}

				if hide[name] then return false end
			end
		end

		if YRPPanelAlive and g_VoicePanelList and YRPPanelAlive(g_VoicePanelList) then
			g_VoicePanelList:SetVisible(GetGlobalYRPBool("bool_gmod_voice_module", false), true)
		end
	end
)

include("hud/cl_hud_map.lua")
include("hud/cl_hud_player.lua")
include("hud/cl_hud_view.lua")
include("hud/cl_hud_crosshair.lua")
Material("voice/icntlk_pl"):SetFloat("$alpha", 0)
function IsScreenshotting()
	if input.IsKeyDown(KEY_F12) or input.IsKeyDown(KEY_F5) then
		return true
	else
		return false
	end
end

hook.Add(
	"PlayerStartVoice",
	"yrp_playerstartvoice",
	function(pl)
		if pl ~= nil and pl == LocalPlayer() then
			_showVoice = true
			net.Start("nws_yrp_voice_start")
			net.SendToServer()
		end
	end
)

hook.Add(
	"PlayerEndVoice",
	"yrp_playerendvoice",
	function(pl)
		if pl == LocalPlayer() then
			_showVoice = false
			net.Start("nws_yrp_voice_end")
			net.SendToServer()
		end
	end
)

local _yrp_icon = Material("vgui/yrp/logo100_beta.png")
local star = Material("vgui/material/icon_star.png")
function DrawEquipment(ply, name)
	local _tmp = ply:GetYRPEntity(name, NULL)
	if YRPEntityAlive(_tmp) then
		ply.yrp_view_range = ply.yrp_view_range or 0
		if ply.yrp_view_range <= 0 then
			_tmp:SetNoDraw(true)
		else
			_tmp:SetNoDraw(false)
		end
	end
end

hook.Add(
	"HUDPaint",
	"yrp_hud_safezone",
	function()
		local lply = LocalPlayer()
		if IsInsideSafezone(lply) then
			draw.SimpleText(YRP:trans("LID_safezone"), "Y_24_500", ScrW() / 2, YRP:ctr(650), Color(100, 100, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
	end
)

local lastzone = ""
local zonedelay = 0
hook.Add(
	"HUDPaint",
	"yrp_hud_zone",
	function()
		local lply = LocalPlayer()
		if IsInsideZone == nil then return end
		local inzone, zonename, zonecolor = IsInsideZone(lply)
		if inzone and lastzone ~= zonename then
			lastzone = zonename
			zonedelay = CurTime() + 4
		end

		if inzone and zonedelay > CurTime() then
			zonecolor = StringToColor(zonecolor)
			draw.SimpleText(YRP:trans("LID_entered") .. ":", "Y_30_500", ScrW() / 2, YRP:ctr(400), zonecolor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.SimpleText(zonename, "Y_80_500", ScrW() / 2, YRP:ctr(500), zonecolor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
	end
)

hook.Add(
	"HUDPaint",
	"yrp_hud_alert",
	function()
		local text = GetGlobalYRPString("yrp_alert", "")
		local font = "Y_100_500"
		surface.SetFont(font)
		local tw, _ = surface.GetTextSize(text)
		if tw > ScrW() then
			font = "Y_72_500"
			surface.SetFont(font)
			tw, th = surface.GetTextSize(text)
			if tw > ScrW() then
				font = "Y_36_500"
				surface.SetFont(font)
				tw, th = surface.GetTextSize(text)
				if tw > ScrW() then
					font = "Y_18_500"
				end
			end
		end

		draw.SimpleText(text, font, ScrW() / 2, YRP:ctr(500), Color(255, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
)

local color1 = Color(0, 0, 0, 120)
local oldlevel = oldlevel or nil --ply:Level()
hook.Add(
	"HUDPaint",
	"yrp_hud_levelUp",
	function()
		local lply = LocalPlayer()
		if IsLevelSystemEnabled() then
			if oldlevel == nil then
				lply:Level()
			end

			if oldlevel ~= lply:Level() then
				oldlevel = lply:Level()
				surface.PlaySound("garrysmod/content_downloaded.wav")
				local levelUp = YRPCreateD("DFrame", nil, YRP:ctr(600), YRP:ctr(160), 0, 0)
				if levelUp and levelUp.GetWide and levelUp.GetTall then
					levelUp:SetPos(ScrW() / 2 - levelUp:GetWide() / 2, ScrH() / 2 - levelUp:GetTall() / 2 - YRP:ctr(400))
					levelUp:ShowCloseButton(false)
					levelUp:SetTitle("")
					levelUp.LID_levelUp = YRP:trans("LID_levelUp")
					local tab = {}
					tab["LEVEL"] = lply:Level()
					levelUp.LID_levelx = YRP:trans("LID_levelx", tab)
					levelUp.lucolor = Color(255, 255, 100, 255)
					levelUp.lxcolor = Color(255, 255, 255, 255)
					levelUp.brcolor = Color(0, 0, 0, 255)
					levelUp.level = oldlevel
					function levelUp:Paint(pw, ph)
						surface.SetFont("Y_36_500")
						local tw, _ = surface.GetTextSize(self.LID_levelUp)
						tw = tw + 2 * YRP:ctr(20)
						self.aw = self.aw or 0
						draw.RoundedBox(YRP:ctr(10), pw / 2 - self.aw / 2, 0, self.aw, ph, color1)
						if self.aw < tw then
							self.aw = math.Clamp(self.aw + 5, 0, tw)
						else
							draw.SimpleText(self.LID_levelUp, "Y_36_500", pw / 2, ph / 4, self.lucolor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
							draw.SimpleText(self.LID_levelx, "Y_24_500", pw / 2, ph / 4 * 3, self.lxcolor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
						end

						if self.level ~= lply:Level() then
							self:Remove()
						end

						self.delay = self.delay or CurTime() + 6
						if self.delay < CurTime() then
							self:Remove()
						end
					end
				end
			end
		end
	end
)

HUD_AVATAR = HUD_AVATAR or nil
PAvatar = PAvatar or nil
if YRPPanelAlive(PAvatar, "PAvatar") then
	PAvatar:Remove()
end

PAvatar = vgui.Create("DPanel")
function PAvatar:Paint(pw, ph)
	if GetGlobalYRPBool("bool_yrp_hud", false) and YRPIsScoreboardVisible and not YRPIsScoreboardVisible() then
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
		if YRPPanelAlive(HUD_AVATAR, "HUD_AVATAR") then
			HUD_AVATAR:SetPaintedManually(false)
			HUD_AVATAR:PaintManual()
			HUD_AVATAR:SetPaintedManually(true)
		end

		render.SetStencilEnable(false)
	end
end

timer.Simple(
	1,
	function()
		HUD_AVATAR = vgui.Create("AvatarImage", PAvatar)
		HUD_AVATAR:MoveToBack()
		local ava = {}
		ava.w = 64
		ava.h = 64
		ava.x = 0
		ava.y = 0
		ava.version = -1
		function HUD_AVATARUpdate()
			if not YRPPanelAlive(HUD_AVATAR, "HUD_AVATAR 2") then return end
			HUD_AVATAR:MoveToBack()
			local lply = LocalPlayer()
			if lply ~= NULL then
				if GetGlobalYRPBool("bool_yrp_hud", false) then
					if GetGlobalYRPInt("YRPHUDVersion", -1) ~= ava.version then
						ava.version = GetGlobalYRPInt("YRPHUDVersion", -1)
						HUD_AVATAR:Show()
						ava.w = lply:HudValue("AV", "SIZE_W")
						ava.h = lply:HudValue("AV", "SIZE_H")
						ava.x = lply:HudValue("AV", "POSI_X")
						ava.y = lply:HudValue("AV", "POSI_Y")
						ava.visible = lply:HudValue("AV", "VISI")
						PAvatar:SetPos(ava.x, ava.y)
						PAvatar:SetSize(ava.h, ava.h)
						HUD_AVATAR:SetPlayer(LocalPlayer(), ava.h)
						if not ava.visible then
							PAvatar:SetSize(0, 0)
						end

						HUD_AVATAR:SetPos(0, 0)
						HUD_AVATAR:SetSize(PAvatar:GetWide(), PAvatar:GetTall())
					end
				else
					if GetGlobalYRPInt("YRPHUDVersion", -1) ~= ava.version then
						ava.version = GetGlobalYRPInt("YRPHUDVersion", -1)
						HUD_AVATAR:Hide()
					end
				end
			end

			timer.Simple(1, HUD_AVATARUpdate)
		end

		HUD_AVATARUpdate()
	end
)

YRP_SL = YRP_SL or vgui.Create("DHTML", nil)
YRP_SL.w = 64
YRP_SL.h = 64
YRP_SL.x = 0
YRP_SL.y = 0
YRP_SL.url = ""
YRP_SL.visible = false
YRP_SL.version = -1
YRP_PM = YRP_PM or vgui.Create("DModelPanel", nil)
YRP_PM.w = 64
YRP_PM.h = 64
YRP_PM.x = 0
YRP_PM.y = 0
YRP_PM.version = -1
YRP_PM.model = ""
local function YRPBodyGroupChanged()
	if YRP_PM and YRP_PM.Entity then
		for i, v in pairs(LocalPlayer():GetBodyGroups()) do
			if YRP_PM.Entity:GetBodygroup(v.id) ~= LocalPlayer():GetBodygroup(v.id) then return true end
		end
	end

	return false
end

function YRP_PMUpdate()
	local lply = LocalPlayer()
	if IsValid(lply) then
		if GetGlobalYRPBool("bool_yrp_hud", false) then
			if GetGlobalYRPInt("YRPHUDVersion", -1) ~= YRP_PM.version or YRP_PM.model ~= lply:GetPlayerModel() or YRP_PM.skin ~= lply:GetSkin() or YRPBodyGroupChanged() then
				YRP_PM.version = GetGlobalYRPInt("YRPHUDVersion", -1)
				YRP_PM.model = lply:GetPlayerModel()
				YRP_PM.skin = lply:GetSkin()
				YRP_PM.w = lply:HudValue("PM", "SIZE_W")
				YRP_PM.h = lply:HudValue("PM", "SIZE_H")
				YRP_PM.x = lply:HudValue("PM", "POSI_X")
				YRP_PM.y = lply:HudValue("PM", "POSI_Y")
				YRP_PM.visible = lply:HudValue("PM", "VISI")
				YRP_PM:SetPos(YRP_PM.x, YRP_PM.y)
				YRP_PM:SetSize(YRP_PM.h, YRP_PM.h)
				YRP_PM:SetModel(YRP_PM.model)
				if YRPEntityAlive(YRP_PM.Entity) then
					YRP_PM.Entity:SetSkin(lply:GetSkin())
					local lb = YRP_PM.Entity:LookupBone("ValveBiped.Bip01_Head1")
					if lb ~= nil then
						local eyepos = YRP_PM.Entity:GetBonePosition(lb)
						eyepos:Add(Vector(0, 0, 2)) -- Move up YRP_SLightly
						YRP_PM:SetLookAt(eyepos - Vector(0, 0, 4))
						YRP_PM:SetCamPos(eyepos - Vector(0, 0, 4) - Vector(-26, 0, 0)) -- Move cam in front of eyes
						YRP_PM.Entity:SetEyeTarget(eyepos - Vector(-40, 0, 0))
					else
						YRP_PM:SetLookAt(Vector(0, 0, 40))
						YRP_PM:SetCamPos(Vector(50, 50, 50))
					end

					for i, v in pairs(LocalPlayer():GetBodyGroups()) do
						YRP_PM.Entity:SetBodygroup(v.id, LocalPlayer():GetBodygroup(v.id))
					end
				end

				if not YRP_PM.visible then
					YRP_PM:SetModel("")
				end
			end

			if IsValid(YRP_SL) and (GetGlobalYRPInt("YRPHUDVersion", -1) ~= YRP_SL.version or YRP_SL.url ~= GetGlobalYRPString("text_server_logo", "")) then
				YRP_SL.version = GetGlobalYRPInt("YRPHUDVersion", -1)
				YRP_SL.visible = lply:HudValue("SL", "VISI")
				YRP_SL.url = GetGlobalYRPString("text_server_logo", "")
				YRP_SL.w = lply:HudValue("SL", "SIZE_W")
				YRP_SL.h = lply:HudValue("SL", "SIZE_H")
				YRP_SL.x = lply:HudValue("SL", "POSI_X")
				YRP_SL.y = lply:HudValue("SL", "POSI_Y")
				YRP_SL:SetPos(YRP_SL.x, YRP_SL.y)
				YRP_SL:SetSize(YRP_SL.h, YRP_SL.h)
				YRP_SL:SetHTML(YRPGetHTMLImage(YRP_SL.url, YRP_SL.h, YRP_SL.h))
				YRP_SL:SetVisible(YRP_SL.visible)
			end
		else
			if GetGlobalYRPInt("YRPHUDVersion", -1) ~= YRP_PM.version then
				YRP_PM.version = GetGlobalYRPInt("YRPHUDVersion", -1)
				YRP_PM:SetModel("")
			end
		end
	end

	if YRPIsScoreboardVisible and YRPIsScoreboardVisible() then
		YRP_PM:Hide()
	else
		YRP_PM:Show()
	end

	timer.Simple(0.3, YRP_PMUpdate)
end

YRP_PMUpdate()
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
	if not tested then
		tested = true
		local str = ""
		local files, _ = file.Find("addons/*", "GAME")
		for i, v in pairs(files) do
			if string.find(v, "1189643820", 1, true) then
				local ts = file.Time("addons/" .. v, "GAME")
				if ts < 1585861486 then
					if str ~= "" then
						str = str .. "\n"
					end

					str = str .. v
				end
			end
		end

		LocalPlayer().badyourrpcontent = LocalPlayer().badyourrpcontent or ""
		if LocalPlayer() ~= NULL then
			LocalPlayer().badyourrpcontent = str
		end
	end
end

timer.Simple(
	4,
	function()
		TestYourRPContent()
	end
)

local function HUDPermille()
	local lply = LocalPlayer()
	if lply:Permille() > 0 then
		DrawMotionBlur(0.1, 0.79, 0.05)
	end
end

hook.Add("RenderScreenspaceEffects", "BlurTest", HUDPermille)
hook.Add(
	"HUDPaint",
	"yrp_hud",
	function()
		local lply = LocalPlayer()
		if lply:GetYRPBool("yrp_spawning", false) then
			draw.RoundedBox(0, 0, 0, ScrW(), ScrH(), Color(0, 0, 0, 255)) -- Black Background - Respawning
			draw.SimpleText(YRP:trans("LID_pleasewait"), "Y_18_500", ScrW() / 2, ScrH() / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.SimpleText(YRP:trans("LID_respawning"), "Y_40_500", ScrW() / 2, ScrH() / 2 + YRP:ctr(100), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end

		if lply:GetYRPBool("yrp_speaking", false) then
			local text = YRP:trans("LID_youarespeaking")
			if lply:GetYRPBool("mute_voice", false) then
				text = text .. " ( " .. YRP:trans("LID_speaklocal") .. " )"
			end

			if YRPGetVoiceRangeText(lply) ~= "" then
				text = text .. " ( " .. YRP:trans("LID_range") .. " " .. YRPGetVoiceRangeText(lply) .. " [" .. YRPGetVoiceRange(lply) .. "])"
			end

			draw.SimpleText(text, "Y_24_500", ScrW2(), ScrH2() - YRP:ctr(600), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end

		if yrp_loading_screen and YRPPanelAlive(yrp_loading_screen, "yrp_loading_screen 2") then
			draw.RoundedBox(0, 0, 0, ScrW(), ScrH(), Color(10, 10, 10))
		end

		if GetGlobalYRPBool("blinded", false) then
			draw.RoundedBox(0, 0, 0, ScrW(), ScrH(), Color(255, 255, 255, 255))
			surfaceText(YRP:trans("LID_blinded"), "Y_30_500", ScrW2(), ScrH2() + YRP:ctr(100), Color(255, 255, 0, 255), 1, 1)
		end

		if lply:IsFlagSet(FL_FROZEN) then
			surfaceText(YRP:trans("LID_frozen"), "Y_30_500", ScrW2(), ScrH2() + YRP:ctr(150), Color(255, 255, 0, 255), 1, 1)
		end

		if lply:GetYRPBool("cloaked", false) then
			surfaceText(YRP:trans("LID_cloaked"), "Y_30_500", ScrW2(), ScrH2() - YRP:ctr(400), Color(255, 255, 0, 255), 1, 1)
		end

		DrawEquipment(lply, "backpack")
		if not lply:InVehicle() then
			YRPHudPlayer(lply)
			YRPHudView()
			YRPHudCrosshair()
		end

		local _target = LocalPlayer():GetYRPString("hittargetName", "")
		if not strEmpty(_target) then
			surfaceText(YRP:trans("LID_target") .. ": " .. LocalPlayer():GetYRPString("hittargetName", ""), "Y_24_500", YRP:ctr(10), YRP:ctr(10), Color(255, 0, 0, 255), 0, 0)
			LocalPlayer():drawHitInfo()
		end

		if IsSpVisible() then
			local _br = {}
			_br.y = 50
			_br.x = 10
			local _r = 60
			if GetSpTable then
				local _sp = GetSpTable()
				if YRPGetSpCaseColor then
					draw.RoundedBox(ctrb(_r), _sp.x - _br.x, _sp.y - _br.y, _sp.w + 2 * _br.x, _sp.h + 2 * _br.y, YRPGetSpCaseColor())
				end

				surface.SetDrawColor(Color(255, 255, 255, 255))
				surface.SetMaterial(_yrp_icon)
				surface.DrawTexturedRect(_sp.x + _sp.w / 2 - ctrb(246) / 2, _sp.y - ctrb(80 + 10), ctrb(246), ctrb(80))
			end
		end

		if GetGlobalYRPBool("bool_wanted_system", false) and false then
			local stars = {}
			stars.size = YRP:ctr(80)
			stars.cur = stars.size
			stars.x = -YRP:ctr(32) + ScrW() - 6 * stars.size
			stars.y = YRP:ctr(32)
			-- Slot
			surface.SetDrawColor(Color(0, 0, 0, 255))
			surface.SetMaterial(star)
			for x = 1, 5 do
				surface.DrawTexturedRect(stars.x + x * stars.size, stars.y, stars.cur, stars.cur)
			end

			stars.cur = YRP:ctr(60)
			stars.br = (stars.size - stars.cur) / 2
			surface.SetDrawColor(100, 100, 100, 255)
			for x = 1, 5 do
				surface.DrawTexturedRect(stars.x + x * stars.size + stars.br, stars.y + stars.br, stars.cur, stars.cur)
			end

			-- Current Stars
			surface.SetDrawColor(Color(255, 255, 255, 255))
			for x = 1, 5 do
				if lply:GetYRPInt("yrp_stars", 0) >= x then
					surface.DrawTexturedRect(stars.x + x * stars.size + stars.br, stars.y + stars.br, stars.cur, stars.cur)
				end
			end
		end

		LocalPlayer().badyourrpcontent = LocalPlayer().badyourrpcontent or ""
		if LocalPlayer().badyourrpcontent ~= "" then
			draw.SimpleText("Your addon is outdated, please delete/redownload ( addons folder):", "Y_30_500", ScrW2() + YRP:ctr(50), ScrH2() + YRP:ctr(50), Color(255, 0, 0, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			local addons = string.Explode("\n", LocalPlayer().badyourrpcontent)
			for i, v in pairs(addons) do
				draw.SimpleText("• " .. v, "Y_30_500", ScrW2() + YRP:ctr(50), ScrH2() + YRP:ctr(50) + i * YRP:ctr(50), Color(255, 0, 0, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			end
		end

		if game.SinglePlayer() then
			draw.RoundedBox(0, 0, 0, ScrW(), ScrH(), Color(0, 0, 0, 255))
			draw.SimpleText("[YourRP] " .. "DO NOT USE SINGLEPLAYER" .. "!", "Y_72_500", ScrW2(), ScrH2() - 100, Color(255, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end

		if not HasYRPContent() and GetGlobalYRPString("YRP_VERSIONART", "X") == "workshop" then
			draw.SimpleTextOutlined("\"YourRP Content\" IS MISSING! (FROM SERVER COLLECTION)", "Y_60_500", ScrW2(), ScrH2() - 250, Color(255, 255, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
			draw.SimpleTextOutlined("Add \"YourRP Content\" to your Server Collection!", "Y_60_500", ScrW2(), ScrH2() - 200, Color(255, 255, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
		end

		if HasDarkrpmodification() then
			draw.SimpleTextOutlined("You have \"darkrpmodification\" (locally) on your Server", "Y_60_500", ScrW2(), ScrH2() - 450, Color(255, 255, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
			draw.SimpleTextOutlined("Remove \"darkrpmodification\" to make YourRP work!", "Y_60_500", ScrW2(), ScrH2() - 400, Color(255, 255, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
		end

		if GetGlobalYRPBool("bool_radiation", false) then
			LocalPlayer().radiation = LocalPlayer().radiation or CurTime()
			if LocalPlayer().radiation < CurTime() then
				LocalPlayer().radiation = CurTime() + math.Rand(0.1, 0.5)
				if IsInsideRadiation(LocalPlayer()) then
					local filename = "tools/ifm/ifm_snap.wav"
					util.PrecacheSound(filename)
					LocalPlayer():EmitSound(filename)
				end
			end
		end
	end, hook.MONITOR_HIGH
)

hook.Add(
	"HUDPaint",
	"yrp_hud_collectionid",
	function()
		local lply = LocalPlayer()
		if YRPCollectionID() == "0" and lply:HasAccess("hud1") then
			local text = "[STEAM] " .. YRP:trans("LID_thecollectionidismissing") .. " ( " .. "to start config: " .. "+host_workshop_collection WORKSHOPID" .. " )"
			draw.SimpleTextOutlined(text, "Y_50_500", ScrW() / 2, ScrH() * 0.2, Color(255, 255, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
		end
	end, hook.MONITOR_HIGH
)

hook.Add(
	"HUDPaint",
	"yrp_hud_charbackground",
	function()
		local lply = LocalPlayer()
		if GetGlobalYRPBool("bool_character_system", true) and YRPGetCharBGNotFound and strEmpty(GetGlobalYRPString("text_character_background")) and lply:HasAccess("hud2") then
			local text = YRPGetCharBGNotFound()
			draw.SimpleTextOutlined(text, "Y_40_500", ScrW() / 2, ScrH() * 0.25, Color(255, 255, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
		end
	end, hook.MONITOR_HIGH
)

local yrpeh = nil
function YRPInitEdgeHud()
	if EdgeHUD and EdgeHUD.Configuration and yrpeh == nil then
		YRP:msg("note", "EDGEHUD installed, add hunger and thirst.")
		if EdgeHUD.Configuration.GetConfigValue("LowerLeft") and EdgeHUD.Colors and EdgeHUD.Vars then
			--Create a variable for the local player.
			local ply = LocalPlayer()
			--Create a copy of the colors and vars table.
			local COLORS = table.Copy(EdgeHUD.Colors)
			local VARS = table.Copy(EdgeHUD.Vars)
			--local screenWidth = ScrW()
			local screenHeight = ScrH()
			local alwaysShowPercentage = EdgeHUD.Configuration.GetConfigValue("LowerLeft_AlwaysShow")
			--Create a table where we store information about the statuswidgets.
			local statusWidgets = {}
			--Insert intot he table.
			table.insert(
				statusWidgets,
				{
					Icon = Material("edgehud/icon_hunger.png", "smooth"),
					Color = Color(131, 90, 38),
					getData = function() return ply:getDarkRPVar("Energy") end,
					getMax = function() return 100 end,
					IsDisabled = function() return not GetGlobalYRPBool("bool_hunger", false) end
				}
			)

			table.insert(
				statusWidgets,
				{
					Icon = Material("edgehud/icon_thirst.png", "smooth"),
					Color = ply:HudValue("TH", "BA"),
					getData = function() return ply:getDarkRPVar("Thirst") end,
					getMax = function() return 100 end,
					IsDisabled = function() return not GetGlobalYRPBool("bool_thirst", false) end
				}
			)

			--Loop through statusWidgets.
			for i = 1, #statusWidgets do
				local id = i + 2
				--Create a x & y var for the position.
				local x = VARS.ScreenMargin + (VARS.ElementsMargin + VARS.statusWidgetWidth) * (i - 1)
				local y = screenHeight - VARS.ScreenMargin - VARS.WidgetHeight * 3 - VARS.ElementsMargin * 2
				--Create a var for the current widget.
				local curWidget = statusWidgets[i]
				--Create a widgetbox.
				local statusWidget = vgui.Create("EdgeHUD:WidgetBox")
				statusWidget:SetWidth(VARS.statusWidgetWidth)
				if EdgeHUD.LeftOffset and EdgeHUD.BottomOffset then
					statusWidget:SetPos(x + EdgeHUD.LeftOffset, y - EdgeHUD.BottomOffset - (VARS.WidgetHeight + VARS.ElementsMargin))
				end

				yrpeh = statusWidget
				--Register the derma element.
				EdgeHUD.RegisterDerma("StatusWidget_" .. id, statusWidget)
				--Create the icon.
				local Icon = vgui.Create("DImage", statusWidget)
				Icon:SetSize(VARS.iconSize_Small, VARS.iconSize_Small)
				Icon:SetPos(statusWidget:GetWide() / 2 - VARS.iconSize_Small / 2, VARS.iconMargin_Small)
				Icon:SetMaterial(curWidget.Icon)
				--Create a lerpedData for the curWidget.
				local lerpedData = curWidget.getData()
				--Create a lerpedSize var.
				local lerpedSize = Icon:GetWide()
				--Create a lerpedPos var.
				local xPos, lerpedPos = Icon:GetPos()
				--Create a lerpedAlha var.
				local lerpedAlpha = 255
				--Create a PaintOVer function for the statusWidget.
				statusWidget.Paint = function(s, w, h)
					if curWidget:IsDisabled() then
						Icon:Hide()

						return
					else
						Icon:Show()
					end

					--Draw the background.
					surface.SetDrawColor(COLORS["Black_Transparent"])
					surface.DrawRect(0, 0, w, h)
					--Get the player's max health.
					local max = curWidget.getMax()
					local data = math.max(curWidget.getData() or 0, 0)
					--Cache the FrameTime.
					local FT = FrameTime() * 5
					--Lerp the EdgeHUD.calcData.
					lerpedData = Lerp(FT or 0, lerpedData or 0, data or 0)
					--Calculate the proportion.
					local prop = math.Clamp(lerpedData / max, 0, 1)
					--Lerp the Alpha.
					lerpedAlpha = Lerp(FT, lerpedAlpha, prop > 0.999 and alwaysShowPercentage == false and data <= max and 0 or 255)
					--Calculate the height.
					local height = h * prop
					--Draw the overlay.
					surface.SetDrawColor(ColorAlpha(curWidget.Color, lerpedAlpha))
					surface.DrawRect(0, h - height, w, height)
					--Draw the infotext.
					draw.SimpleText(math.max(math.Round(lerpedData), 0) .. "%", "EdgeHUD:Small", w / 2, h - VARS.iconMargin_Small, ColorAlpha(COLORS["White"], lerpedAlpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
					--Draw the white outline.
					surface.SetDrawColor(COLORS["White_Outline"])
					surface.DrawOutlinedRect(0, 0, w, h)
					--Draw the corners.
					surface.SetDrawColor(COLORS["White_Corners"])
					EdgeHUD.DrawEdges(0, 0, w, h, 8)
					--Calculate the new size.
					lerpedSize = Lerp(FT, lerpedSize, prop > 0.999 and alwaysShowPercentage == false and data <= max and VARS.iconSize or VARS.iconSize_Small)
					--Update the size.
					Icon:SetSize(lerpedSize, lerpedSize)
					--Calculate the new ypos.
					lerpedPos = Lerp(FT, lerpedPos, prop > 0.999 and alwaysShowPercentage == false and data <= max and VARS.iconMargin or VARS.iconMargin_Small)
					--Update the position.
					Icon:SetPos(xPos, lerpedPos)
				end
			end
		end
	end

	timer.Simple(2, YRPInitEdgeHud)
end

YRPInitEdgeHud()
local VO = {}
hook.Add(
	"HUDPaint",
	"yrp_voice_module",
	function()
		local lply = LocalPlayer()
		if GetGlobalYRPBool("bool_voice", false) and lply:HudValue("VO", "VISI") then
			VO.font = "Y_18_700"
			surface.SetFont(VO.font)
			local texta = {}
			local textp = {}
			for i, v in SortedPairsByMemberValue(GetGlobalYRPTable("yrp_voice_channels", {}), "int_position", false) do
				if IsActiveInChannel(lply, v.uniqueID) then
					table.insert(texta, v.string_name)
				end

				if IsInChannel(lply, v.uniqueID) then
					table.insert(textp, v.string_name)
				end
			end

			local ca = table.Count(texta)
			local cp = table.Count(textp)
			if ca == 0 then
				VO.text = "-"
			else
				VO.text = YRP:trans("LID_active") .. ": " .. table.concat(texta, ", ")
			end

			VO.text = VO.text .. " | " .. YRP:trans("LID_passive") .. ": "
			if cp == 0 then
				VO.text = VO.text .. "-"
			elseif cp <= 3 then
				VO.text = VO.text .. table.concat(textp, ", ")
			else
				VO.text = VO.text .. string.Replace(YRP:trans("LID_xpassive"), "X", cp)
			end

			if ca == 0 and cp == 0 then
				VO.text = "" .. string.Replace(YRP:trans("LID_presskeytoenablevoicemenu"), "KEY", YRPGetKeybindName("voice_menu")) .. ""
			else
				VO.text = VO.text .. " ( " .. input.GetKeyName(KEY_LSHIFT) .. " + " .. YRPGetKeybindName("voice_menu") .. " )"
			end

			VO.tw = surface.GetTextSize(VO.text)
			if GetGlobalYRPInt("YRPHUDVersion", -1) ~= VO.version then
				VO.version = GetGlobalYRPInt("YRPHUDVersion", -1)
				VO.x = lply:HudValue("VO", "POSI_X")
				VO.y = lply:HudValue("VO", "POSI_Y")
				VO.w = lply:HudValue("VO", "SIZE_W")
				VO.h = lply:HudValue("VO", "SIZE_H")
				VO.tx = VO.x + VO.w / 2
				VO.ty = VO.y + VO.h / 2
			end

			VO.tw = VO.tw + VO.h / 2
			YRPDrawRectBlurHUD(15, VO.tx - VO.tw / 2, VO.y, VO.tw, VO.h, 200)
			draw.SimpleText(VO.text, VO.font, VO.tx, VO.ty, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
	end
)

-- HUD API
local YRPHUDMats = {}
local YRPHUDAnchors = {}
local YRPTEMPDATA = {}
local YRPHUDVersion = 0
function YRPHUDUpdateAnchors()
	--YRP:msg( "note", "YRPHUDUpdateAnchors()" )
	YRPHUDAnchors["TOPLEFT"] = {0, 0}
	YRPHUDAnchors["TOPRIGHT"] = {ScrW(), 0}
	YRPHUDAnchors["BOTTOMLEFT"] = {0, ScrH()}
	YRPHUDAnchors["BOTTOMRIGHT"] = {ScrW(), ScrH()}
	YRPHUDAnchors["CENTER"] = {ScrW() / 2, ScrH() / 2}
	YRPHUDAnchors["TOP"] = {ScrW() / 2, 0}
	YRPHUDAnchors["BOTTOM"] = {ScrW() / 2, ScrH()}
	YRPHUDAnchors["LEFT"] = {0, ScrH() / 2}
	YRPHUDAnchors["RIGHT"] = {ScrW(), ScrH() / 2}
end

YRPHUDUpdateAnchors()
function YRPHUDValues(name, anchor, posx, posy, sizew, sizeh)
	if name == nil then
		YRP:msg("note", "[YRPHUDDrawTexture] NAME IS INVALID")

		return false
	end

	if YRPTEMPDATA[name] == nil or YRPTEMPDATA[name].version < YRPHUDVersion then
		YRPTEMPDATA[name] = {}
		YRPTEMPDATA[name].version = YRPHUDVersion
		if anchor == nil then
			YRP:msg("note", "[YRPHUDDrawTexture] ANCHOR IS INVALID")

			return false
		end

		if posx == nil or posy == nil then
			YRP:msg("note", "[YRPHUDDrawTexture] POSX or POSY IS INVALID")

			return false
		end

		if sizew == nil or sizeh == nil then
			YRP:msg("note", "[YRPHUDDrawTexture] SIZEW or SIZEH IS INVALID")

			return false
		end

		local ax = YRPHUDAnchors[anchor][1]
		local ay = YRPHUDAnchors[anchor][2]
		YRPTEMPDATA[name].x = ax + posx
		YRPTEMPDATA[name].y = ay + posy
		YRPTEMPDATA[name].w = sizew
		YRPTEMPDATA[name].h = sizeh
	end

	return true
end

function YRPHUDDrawTexture(name, anchor, posx, posy, sizew, sizeh, material)
	if not YRPHUDValues(name, anchor, posx, posy, sizew, sizeh) then return end
	if material == nil then
		YRP:msg("note", "[YRPHUDDrawTexture] MATERIAL IS INVALID")

		return false
	end

	if YRPHUDMats[material] == nil then
		YRPHUDMats[material] = Material(material)
	end

	surface.SetDrawColor(Color(255, 255, 255, 255))
	surface.SetMaterial(YRPHUDMats[material])
	surface.DrawTexturedRect(YRPTEMPDATA[name].x, YRPTEMPDATA[name].y, YRPTEMPDATA[name].w, YRPTEMPDATA[name].h)
end

function YRPHUDDrawText(name, anchor, posx, posy, text, font, textcolor, tax, tay)
	YRPHUDValues(name, anchor, posx, posy, 10, 10)
	draw.SimpleText(text, font, YRPTEMPDATA[name].x, YRPTEMPDATA[name].y, textcolor or Color(255, 255, 255, 255), tax, tay)
end

function YRPHUDGetFont(ts, thick)
	if thick then
		return "Y_" .. ts .. "_700"
	else
		return "Y_" .. ts .. "_500"
	end
end

local oldsw = ScrW()
local oldsh = ScrH()
hook.Add(
	"HUDPaint",
	"yrp_hud_api",
	function()
		if oldsw ~= ScrW() or oldsh ~= ScrH() then
			oldsw = ScrW()
			oldsh = ScrH()
			YRPHUDUpdateAnchors()
			YRPHUDVersion = YRPHUDVersion + 1
		end
	end
)

-- AMMO FUNCTIONS
function YRPGetAWClip1(ply)
	if IsValid(ply) then
		local weapon = ply:GetActiveWeapon()
		if IsValid(weapon) then
			local clip1 = weapon:Clip1()

			return clip1
		end
	end

	return -1
end

function YRPGetAWClip2(ply)
	if IsValid(ply) then
		local weapon = ply:GetActiveWeapon()
		if IsValid(weapon) then
			local clip2 = weapon:Clip2()

			return clip2
		end
	end

	return -1
end

function YRPGetAWClip1Max(ply)
	if IsValid(ply) then
		local weapon = ply:GetActiveWeapon()
		if IsValid(weapon) then
			local clip1max = weapon:GetMaxClip1()

			return clip1max
		end
	end

	return -1
end

function YRPGetAWClip2Max(ply)
	if IsValid(ply) then
		local weapon = ply:GetActiveWeapon()
		if IsValid(weapon) then
			local clip2max = weapon:GetMaxClip2()

			return clip2max
		end
	end

	return -1
end

function YRPGetAWAmmo1(ply)
	if IsValid(ply) then
		local weapon = ply:GetActiveWeapon()
		if IsValid(weapon) then
			local ammo1 = ply:GetAmmoCount(weapon:GetPrimaryAmmoType())

			return ammo1
		end
	end

	return -1
end

function YRPGetAWAmmo2(ply)
	if IsValid(ply) then
		local weapon = ply:GetActiveWeapon()
		if IsValid(weapon) then
			local ammo2 = ply:GetAmmoCount(weapon:GetSecondaryAmmoType())

			return ammo2
		end
	end

	return -1
end

--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
-- #scoreboard #Scoreboard #SCOREBOARD
local color1 = Color(0, 0, 0, 255)
local color2 = Color(255, 255, 255, 255)
surface.CreateFont(
	"Open Sans_60",
	{
		font = "Open Sans",
		extended = true,
		size = 60,
		weight = 700,
		blursize = 0,
		scanlines = 0,
		antialias = true,
		underline = false,
		italic = false,
		strikeout = false,
		symbol = false,
		rotary = false,
		shadow = false,
		additive = false,
		outline = false
	}
)

surface.CreateFont(
	"Open Sans_28",
	{
		font = "Open Sans",
		extended = true,
		size = 28,
		weight = 700,
		blursize = 0,
		scanlines = 0,
		antialias = true,
		underline = false,
		italic = false,
		strikeout = false,
		symbol = false,
		rotary = false,
		shadow = false,
		additive = false,
		outline = false
	}
)

surface.CreateFont(
	"Open Sans_24",
	{
		font = "Open Sans",
		extended = true,
		size = 24,
		weight = 500,
		blursize = 0,
		scanlines = 0,
		antialias = true,
		underline = false,
		italic = false,
		strikeout = false,
		symbol = false,
		rotary = false,
		shadow = false,
		additive = false,
		outline = false
	}
)

surface.CreateFont(
	"Open Sans_16",
	{
		font = "Open Sans",
		extended = true,
		size = 16,
		weight = 500,
		blursize = 0,
		scanlines = 0,
		antialias = true,
		underline = false,
		italic = false,
		strikeout = false,
		symbol = false,
		rotary = false,
		shadow = false,
		additive = false,
		outline = false
	}
)

local xn = 160
local alwaysshow = {}
alwaysshow["avatar"] = true
alwaysshow["ping"] = true
alwaysshow["mute"] = true
alwaysshow["scroll"] = true
local function YRPIsElementEnabled(name)
	if alwaysshow[name] then return true end

	return GetGlobalYRPBool("bool_yrp_scoreboard_show_" .. name, false)
end

local eles = {
	[1] = {
		["name"] = "avatar",
		["size"] = 40,
		["tran"] = "",
		["func"] = nil,
	},
	[2] = {
		["name"] = "level",
		["size"] = 70,
		["tran"] = "LID_level",
		["func"] = "Level",
		["sort"] = true,
	},
	[3] = {
		["name"] = "idcardid",
		["size"] = 155,
		["tran"] = "LID_id",
		["func"] = "IDCardID",
		["sort"] = true,
	},
	[4] = {
		["name"] = "name",
		["size"] = 250,
		["tran"] = "LID_name",
		["func"] = "RPName",
		["sort"] = true,
	},
	[5] = {
		["name"] = "rolename",
		["size"] = 310,
		["tran"] = "LID_role",
		["func"] = "GetRoleName",
		["sort"] = true,
		["cfun"] = "GetRoleColor",
	},
	[6] = {
		["name"] = "groupname",
		["size"] = 310,
		["tran"] = "LID_group",
		["func"] = "GetGroupName",
		["sort"] = true,
		["cfun"] = "GetGroupColor",
	},
	[7] = {
		["name"] = "usergroup",
		["size"] = 170,
		["tran"] = "LID_rank",
		["func"] = "GetUserGroupNice",
		["sort"] = true,
		["cfun"] = "GetUserGroupColor",
	},
	[8] = {
		["name"] = "language",
		["size"] = 80,
		["tran"] = "LID_language",
		["func"] = "GetLanguageShort",
		["sort"] = true,
	},
	[9] = {
		["name"] = "operating_system",
		["size"] = 70,
		["tran"] = "LID_os",
		["func"] = "OS",
		["sort"] = true,
	},
	[10] = {
		["name"] = "playtime",
		["size"] = 150,
		["tran"] = "LID_playtime",
		["func"] = "FormattedUptimeTotal",
		["sort"] = true,
	},
	[11] = {
		["name"] = "ping",
		["size"] = 100,
		["tran"] = "LID_ping",
		["func"] = "Ping",
		["sort"] = true,
	},
	[12] = {
		["name"] = "mute",
		["size"] = 40,
		["tran"] = "",
		["func"] = nil,
	},
	[13] = {
		["name"] = "scroll",
		["size"] = 24,
		["tran"] = "",
	},
}

local size = 40
local hr = 2
function YRPNotSelf(ply)
	return ply ~= LocalPlayer()
end

function YRPIsScoreboardVisible()
	if YRPPanelAlive(YRPScoreboard, "YRPScoreboard 1") and YRPScoreboard:IsVisible() then return true end

	return false
end

function YRPCloseSBS()
	if not YRPPanelAlive(YRPScoreboard, "YRPScoreboard 2") then return end
	YRPScoreboard:Hide()
	gui.EnableScreenClicker(false)
end

function YRPSortScoreboard()
	if not YRPPanelAlive(YRPScoreboard, "YRPScoreboard 3") then return end
	local lply = LocalPlayer()
	if lply.yrp_sb_reverse == nil then
		lply.yrp_sb_reverse = false
	end

	if lply.yrp_sb_sortby == nil then
		lply.yrp_sb_sortby = "groupname"
	end

	-- Players
	YRPScoreboard.list:Clear()
	YRPScoreboard.plys = {}
	YRPScoreboard.id = YRPScoreboard.id or 0
	YRPScoreboard.id = YRPScoreboard.id + 1
	local id = YRPScoreboard.id
	local plys = {}
	for i, ply in pairs(player.GetAll()) do
		if IsValid(ply) then
			local entry = {}
			entry.ply = ply
			entry.rolename = ply:GetRoleUID()
			if entry.rolename <= 0 then
				entry.rolename = 999999
			end

			entry.groupname = ply:GetGroupUID()
			if entry.groupname <= 0 then
				entry.groupname = 999999
			end

			entry.usergroup = ply:GetUserGroupNice()
			entry.level = ply:Level()
			entry.idcardid = ply:IDCardID()
			entry.name = ply:RPName()
			entry.language = ply:GetLanguage()
			entry.ping = ply:Ping()
			entry.operating_system = ply:OS()
			entry.playtime = ply:FormattedUptimeTotal()
			table.insert(plys, entry)
		end
	end

	local c = 0
	if IsNotNilAndNotFalse(lply.yrp_sb_sortby) and lply.yrp_sb_reverse ~= nil then
		for i, entry in SortedPairsByMemberValue(plys, lply.yrp_sb_sortby, lply.yrp_sb_reverse) do
			c = c + 1
			timer.Simple(
				c * 0.01,
				function()
					if YRPScoreboard and YRPScoreboard.id == id and entry and entry.ply then
						YRPScoreboardAddPlayer(entry.ply)
					end
				end
			)
		end
	end
end

function YRPScoreboardAddPlayer(ply)
	if YRPPanelAlive(YRPScoreboard, "YRPScoreboard 4") and IsValid(ply) and not table.HasValue(YRPScoreboard.plys, ply) then
		table.insert(YRPScoreboard.plys, ply)
		local plyframe = YRPCreateD("DPanel", YRPScoreboard.list, size, size, 0, 0)
		plyframe:Dock(TOP)
		plyframe.open = false
		plyframe.targh = size
		plyframe.lerph = size
		function plyframe:Paint(pw, ph)
			self.lerph = Lerp(8 * FrameTime(), self.lerph, self.targh)
			if self.open then
				self.targh = size * 2
			else
				self.targh = size
			end

			self:SetTall(self.lerph)
			if self.open then
				draw.RoundedBox(0, 1, 1, pw - 2, ph - 2, Color(0, 0, 0, 100))
			end
		end

		-- First Line
		local plypnl = YRPCreateD("DPanel", plyframe, size, size, 0, 0)
		plypnl:Dock(TOP)
		function plypnl:Paint(pw, ph)
			if IsValid(ply) then
				if self.Mute then
					if ply:IsBot() then
						self.Mute:Hide()
					else
						self.Mute:Show()
					end
				end
			else
				table.RemoveByValue(YRPScoreboard.plys, ply)
				--YRPScoreboard.list:RemoveItem(plypnl)
				plypnl:Remove()
			end
		end

		local x = 0
		for i, v in ipairs(eles) do
			if YRPIsElementEnabled(v.name) then
				if v.name == "avatar" then
					local avatarp = YRPCreateD("DPanel", plypnl, v.size, size, 0, 0)
					avatarp:Dock(LEFT)
					function avatarp:Paint(pw, ph)
						local br = 3
						draw.RoundedBox(0, br, br, pw - 2 * br, ph - 2 * br, Color(255, 255, 255, 255))
					end

					local avatar = YRPCreateD("AvatarImage", avatarp, v.size - 8, 40 - 8, 0, 0)
					avatar:DockMargin(4, 4, 4, 4)
					avatar:Dock(LEFT)
					avatar:SetPlayer(ply)
				elseif v.name == "mute" then
					plypnl.Mute = YRPCreateD("DButton", plypnl, v.size, size, 0, 0)
					plypnl.Mute:SetText("")
					plypnl.Mute:Dock(LEFT)
					plypnl.Muted = ply:IsMuted()
					plypnl.Mute.DoClick = function(s)
						if IsValid(ply) then
							ply:SetMuted(not ply:IsMuted())
						end
					end

					plypnl.Mute.OnMouseWheeled = function(s, delta)
						if IsValid(ply) then
							ply:SetVoiceVolumeScale(ply:GetVoiceVolumeScale() + (delta / 100 * 5))
							s.LastTick = CurTime()
						end
					end

					plypnl.Mute.Paint = function(s, w, h)
						if IsValid(ply) then
							local img = YRP.GetDesignIcon("volume_up")
							if ply:GetVoiceVolumeScale() <= 0.0 then
								img = YRP.GetDesignIcon("volume_off")
							elseif ply:GetVoiceVolumeScale() <= 0.25 then
								img = YRP.GetDesignIcon("volume_mute")
							elseif ply:GetVoiceVolumeScale() < 0.5 then
								img = YRP.GetDesignIcon("volume_down")
							end

							if IsValid(ply) and ply:IsMuted() then
								img = YRP.GetDesignIcon("volume_off")
							end

							if img then
								local size2 = math.ceil(h * 0.75)
								local br = (h - size2) / 2
								surface.SetMaterial(img)
								surface.SetDrawColor(Color(255, 255, 255, 255))
								surface.DrawTexturedRect(br, br, size2, size2)
							end

							if s:IsHovered() then
								s.LastTick = CurTime()
							end

							local a = 255 - math.Clamp(CurTime() - (s.LastTick or 0), 0, 3) * 255
							if a > 0 then
								color1.a = a * 0.75
								color2.a = a
								draw.RoundedBox(4, 0, 0, w, h, color1)
								draw.SimpleText(math.ceil(ply:GetVoiceVolumeScale() * 100) .. "%", "DermaDefaultBold", w / 2, h / 2, color2, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
							end
						end
					end
				else
					local plyinf = YRPCreateD("DButton", plypnl, v.size, 32, 0, 0)
					plyinf:SetText("")
					plyinf:Dock(LEFT)
					function plyinf:Paint(pw, ph)
						if IsValid(ply) and v.func and ply[v.func] then
							local text = ply[v.func](ply)
							if v.name == "usergroup" then
								text = string.upper(text)
							end

							local font = "Open Sans_24"
							if ply:LoadedGamemode() and YRP.GetDesignIcon("circle") and v.cfun and ply[v.cfun] and ply:CharID() > 0 then
								local circlesize = ph * 0.4
								surface.SetFont(font)
								local tsw, _ = surface.GetTextSize(text)
								local br = 4
								local col = ply[v.cfun](ply)
								surface.SetDrawColor(col)
								surface.SetMaterial(YRP.GetDesignIcon("circle"))
								surface.DrawTexturedRect(pw / 2 - tsw / 2 - circlesize - br, ph / 2 - circlesize / 2, circlesize, circlesize)
							end

							if v.name == "language" then
								if ply:HasLanguage() then
									self.lang = YRP.GetDesignIcon("lang_" .. ply:GetLanguageShort())
									local sh = math.ceil(size * 0.6)
									local sw = sh * 1.49
									YRP.DrawIcon(self.lang, sw, sh, pw / 2 - sw / 2, ph / 2 - sh / 2, Color(255, 255, 255, 255))
								end
							else
								local px = pw / 2
								local ax = TEXT_ALIGN_CENTER
								local col = Color(255, 255, 255, 255)
								if v.name == "ping" then
									local br = 4
									local mat = YRP.GetDesignIcon("signal3")
									if text >= 300 then
										col = Color(255, 0, 0, 255)
										mat = YRP.GetDesignIcon("signal1")
									elseif text >= 150 then
										col = Color(255, 100, 100, 255)
										mat = YRP.GetDesignIcon("signal1")
									elseif text >= 100 then
										col = Color(255, 255, 100)
										mat = YRP.GetDesignIcon("signal2")
									else
										col = Color(100, 255, 100, 255)
										mat = YRP.GetDesignIcon("signal3")
									end

									if mat then
										local circlesize = math.Round(ph * 0.7, 0)
										surface.SetDrawColor(col)
										surface.SetMaterial(mat)
										surface.DrawTexturedRect(pw / 2 - circlesize - br, ph / 2 - circlesize / 2, circlesize, circlesize)
									end

									if text == 0 then
										text = "!"
									end

									ax = TEXT_ALIGN_LEFT
									px = px + br
								end

								if v.name == "name" then
									if not ply:LoadedGamemode() then
										text = "[" .. YRP.trans("LID_loading") .. "]"
									elseif ply:IsInCharacterSelection() then
										text = "[" .. YRP.trans("LID_characterselection") .. "]"
									end
								end

								if (v.name == "rolename" or v.name == "groupname" or v.name == "idcardid") and not ply:LoadedGamemode() or ply:IsInCharacterSelection() then
									text = ""
								end

								if v.name == "usergroup" and not ply:LoadedGamemode() then
									text = ""
								end

								if v.name == "operating_system" then
									if ply:HasOS() then
										self.lang = YRP.GetDesignIcon("os_" .. ply:OS())
										local sh = math.ceil(size * 0.6)
										local sw = sh
										YRP.DrawIcon(self.lang, sw, sh, pw / 2 - sw / 2, ph / 2 - sh / 2, Color(255, 255, 255, 255))
									end

									if ply:GetYRPString("gmod_branch", "unknown") ~= "64Bit" and not ply:IsBot() then
										text = ply:GetYRPString("gmod_branch", "unknown")
									else
										text = ""
									end
								end

								draw.SimpleText(text, font, px, ph / 2, col, ax, TEXT_ALIGN_CENTER)
							end
						end
					end

					function plyinf:DoClick()
						plyframe.open = not plyframe.open
					end

					if v.name == "name" then
						xn = x + v.size / 2
					end
				end

				x = x + v.size
			end
		end

		-- Second Line
		local plyopt2 = YRPCreateD("DPanel", plyframe, size, size, 0, 0)
		plyopt2:Dock(FILL)
		function plyopt2:Paint(pw, ph)
			local iconsize = math.ceil(ph * 0.666)
			local br = (ph - iconsize) / 2
			if IsValid(ply) and LocalPlayer():HasAccess("YRPScoreboardAddPlayer1") then
				-- Money
				if YRP.GetDesignIcon("64_money-bill") then
					surface.SetMaterial(YRP.GetDesignIcon("64_money-bill"))
					surface.SetDrawColor(Color(255, 255, 255, 255))
					surface.DrawTexturedRect(br, br, iconsize, iconsize)
				end

				draw.SimpleText(ply:FormattedMoney(), "Open Sans_24", ph + br, ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
				draw.SimpleText(ply:SteamName(), "Open Sans_24", xn, ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end

			local text = "GMOD: "
			if ply:GetYRPString("gmod_beta", "unknown") ~= "unknown" then
				text = text .. ply:GetYRPString("gmod_beta", "unknown")
			else
				text = text .. "NO BETA"
			end

			draw.SimpleText(text, "Open Sans_24", pw - br, ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
		end

		local adminbtns = YRPCreateD("DHorizontalScroller", plyopt2, size, size, 0, 0)
		--adminbtns:Dock( RIGHT )
		adminbtns:SetOverlap(-10)
		function adminbtns:Paint(pw, ph)
		end

		--
		local btns = {}
		btns[1] = {
			"LID_account",
			"account",
			false,
			false,
			function()
				if IsValid(ply) then
					ply:ShowProfile()
				end
			end
		}

		btns[2] = {
			"LID_info",
			"128_info-circle",
			false,
			false,
			function()
				if IsValid(ply) and ply:YRPSteamID() and ply:SteamID() then
					SetClipboardText("SteamID: \t" .. ply:YRPSteamID() .. " \nRPName: \t" .. ply:RPName() .. " \nSteamName: \t" .. ply:SteamName())
					notification.AddLegacy("[" .. string.upper(YRP.trans("LID_info")) .. "] COPIED TO CLIPBOARD", NOTIFY_GENERIC, 3)
				else
					notification.AddLegacy("[" .. string.upper(YRP.trans("LID_info")) .. "] PLAYER IS NOT VALID", NOTIFY_ERROR, 3)
				end
			end
		}

		btns[3] = {
			"LID_tpto",
			"128_arrow-circle-up",
			true,
			true,
			function()
				if IsValid(ply) and YRPNotSelf(ply) then
					net.Start("nws_yrp_tp_tpto")
					net.WriteEntity(ply)
					net.SendToServer()
				end
			end
		}

		btns[4] = {
			"LID_bring",
			"128_arrow-circle-down",
			true,
			true,
			function()
				if IsValid(ply) and YRPNotSelf(ply) then
					net.Start("nws_yrp_tp_bring")
					net.WriteEntity(ply)
					net.SendToServer()
				end
			end
		}

		btns[5] = {
			"LID_return",
			"return",
			true,
			false,
			function()
				if IsValid(ply) then
					net.Start("nws_yrp_tp_return")
					net.WriteEntity(ply)
					net.SendToServer()
				end
			end,
			function(btn)
				if IsValid(ply) then
					if ply:GetYRPVector("yrpoldpos") ~= Vector(0, 0, 0) then
						btn.iconcolor = Color(255, 255, 255, 255)
					else
						btn.iconcolor = Color(255, 0, 0, 255)
					end
				end
			end
		}

		btns[6] = {
			"LID_freeze",
			"128_snowflake",
			true,
			false,
			function()
				if IsValid(ply) then
					if not ply:IsFlagSet(FL_FROZEN) then
						net.Start("nws_yrp_freeze")
						net.WriteEntity(ply)
						net.SendToServer()
					else
						net.Start("nws_yrp_unfreeze")
						net.WriteEntity(ply)
						net.SendToServer()
					end
				end
			end,
			function(btn)
				if IsValid(ply) then
					if ply:IsFlagSet(FL_FROZEN) then
						btn.iconcolor = Color(100, 100, 255)
					else
						btn.iconcolor = Color(255, 255, 255, 255)
					end
				end
			end
		}

		btns[7] = {
			"LID_spectate",
			"eye",
			true,
			true,
			function()
				if IsValid(ply) and YRPNotSelf(ply) then
					local frame = vgui.Create("DFrame")
					frame:SetTitle(ply:RPName() .. " [" .. ply:SteamName() .. "]")
					frame:SetSize(ScrW() / 2, ScrH() / 2)
					frame:Center()
					frame:SetScreenLock(true)
					frame:SetSizable(true)
					--frame:MakePopup()
					function frame:Paint(w, h)
						if IsValid(ply) then
							local px, py = self:GetPos()
							local tr = util.TraceHull(
								{
									start = ply:EyePos(),
									endpos = ply:EyePos() - (ply:GetAimVector() * 200),
									filter = ply,
									mins = Vector(-10, -10, -10),
									maxs = Vector(10, 10, 10),
									mask = MASK_SHOT_HULL
								}
							)

							local old = DisableClipping(true) -- Avoid issues introduced by the natural clipping of Panel rendering
							render.RenderView(
								{
									origin = tr.HitPos, --ply:EyePos() - ply:GetRenderAngles():Forward() * 200,
									angles = ply:GetRenderAngles(), -- + LocalPlayer():GetAngles(),
									x = px,
									y = py,
									w = w,
									h = h
								}
							)

							DisableClipping(old)
						else
							self:Remove()
						end
					end
				end
			end
		}

		btns[8] = {
			"LID_cloak",
			"incognito",
			true,
			false,
			function()
				if IsValid(ply) then
					if not ply:GetYRPBool("cloaked", false) then
						net.Start("nws_yrp_cloak")
						net.WriteEntity(ply)
						net.SendToServer()
					else
						net.Start("nws_yrp_uncloak")
						net.WriteEntity(ply)
						net.SendToServer()
					end
				end
			end,
			function(btn)
				if IsValid(ply) then
					if ply:GetYRPBool("cloaked", false) then
						btn.iconcolor = Color(255, 255, 0, 255)
					else
						btn.iconcolor = Color(255, 255, 255, 255)
					end
				end
			end
		}

		btns[9] = {
			"LID_kick",
			"128_fist-raised",
			true,
			true,
			function()
				if IsValid(ply) then
					net.Start("nws_yrp_ply_kick")
					net.WriteEntity(ply)
					net.SendToServer()
				end
			end
		}

		--[[
		BAN player, seem to happen to often.. :D
		btns[10] = {
			"LID_ban",
			"128_gavel",
			true,
			true,
			function()
				if IsValid(ply) then
					net.Start("nws_yrp_ply_ban")
					net.WriteEntity(ply)
					net.SendToServer()
				end
			end
		}]]
		local c = 0
		for i, btn in pairs(btns) do
			if not btn[3] or (btn[3] and LocalPlayer():HasAccess("YRPScoreboardAddPlayer2")) and (not btn[4] or (btn[4] and YRPNotSelf(ply))) then
				c = c + 1
				local b = YRPCreateD("YButton", adminbtns, size, size, 0, 0)
				b:Dock(LEFT)
				b:SetText("")
				b.icon = btn[2]
				b.iconcolor = Color(255, 255, 255, 255)
				function b:Paint(pw, ph)
					local iconsize = math.ceil(ph * 0.666)
					local br = (ph - iconsize) / 2
					if self:IsDown() or self:IsPressed() then
						if not self.clicked then
							self.clicked = true
							surface.PlaySound("garrysmod/ui_click.wav")
						end
					elseif self:IsHovered() then
						if not self.hovering then
							self.hovering = true
							surface.PlaySound("garrysmod/ui_hover.wav")
						end

						if not YRPPanelAlive(self.tt) then
							self.tt = YRPCreateD("DFrame", nil, 100, 20, 0, 0)
							self.tt:SetTitle("")
							self.tt:ShowCloseButton(false)
							self.tt:SetDraggable(false)
							function self.tt:Paint(ppw, pph)
								draw.SimpleText(YRP.trans(btn[1]), "Y_16_500", ppw / 2, pph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
								if not YRPIsScoreboardVisible() then
									self:Remove()
								end
							end

							local bpx, bpy = self:LocalToScreen(0, 0)
							local ttsw, _ = self.tt:GetSize()
							local bsw, bsh = self:GetSize()
							self.tt:SetPos(bpx + bsw / 2 - ttsw / 2, bpy + bsh)
						end
					else
						self.hovering = false
						self.clicked = false
						if YRPPanelAlive(self.tt) then
							self.tt:Remove()
						end
					end

					local alpha = 100
					if self:IsHovered() then
						alpha = 255
					end

					local color = self.iconcolor
					color.a = alpha
					if YRP.GetDesignIcon(btn[2]) then
						surface.SetMaterial(YRP.GetDesignIcon(btn[2]))
						surface.SetDrawColor(color)
						surface.DrawTexturedRect(br, br, iconsize, iconsize)
					end

					if btn[6] then
						btn[6](self)
					end
				end

				function b:DoClick()
					btn[5](self)
				end
			end
		end

		adminbtns:SetSize(c * size, size)
		adminbtns:SetPos(YRPScoreboard.Header:GetWide() / 2 - adminbtns:GetWide() / 2, 0)
		YRPScoreboard.list:AddItem(plyframe)
	end
end

function YRPOpenSBS()
	if not YRPPanelAlive(YRPScoreboard, "YRPScoreboard 5") then return end
	local lply = LocalPlayer()
	-- Table Header
	YRPScoreboard.Header:Clear()
	local x = 0
	for i, v in ipairs(eles) do
		if YRPIsElementEnabled(v.name) then
			local sortbtn = YRPCreateD("DButton", YRPScoreboard.Header, v.size, 40, x, 0)
			sortbtn:SetText("")
			sortbtn:Dock(LEFT)
			function sortbtn:Paint(pw, ph)
				local siz = 16 + 4
				local px = pw / 2
				local text = YRP.trans(v.tran)
				if v.name == "level" and string.len(text) > 3 then
					text = string.sub(text, 1, 3)
					text = text .. "."
				end

				if v.name == "language" and string.len(text) > 4 then
					text = string.sub(text, 1, 4)
					text = text .. "."
				end

				if v.name == "ping" and string.len(text) > 4 then
					text = string.sub(text, 1, 4)
					text = text .. "."
				end

				if lply.yrp_sb_sortby == v.name then
					px = pw / 2 - siz / 2
					YRPDrawOrder(self, px, ph / 2, text, "Open Sans_28", v.name)
				end

				draw.SimpleText(text, "Open Sans_28", px, ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end

			function sortbtn:DoClick()
				if v.tran ~= "" then
					if lply.yrp_sb_sortby == v.name then
						lply.yrp_sb_reverse = not lply.yrp_sb_reverse
					end

					lply.yrp_sb_sortby = v.name
					YRPSortScoreboard()
				end
			end
		end
	end

	timer.Simple(
		0.05,
		function()
			if YRPPanelAlive(YRPScoreboard, "YRPScoreboard 6") then
				local sw = 0
				for i, v in pairs(YRPScoreboard.Header:GetChildren()) do
					sw = sw + v:GetWide()
				end

				YRPScoreboard.Header:SetWide(sw)
				YRPScoreboard:SetWide(sw + 4 * 2)
				YRPScoreboard:Center()
				YRPScoreboard:Show()
				gui.EnableScreenClicker(true)
				YRPSortScoreboard()
			end
		end
	)
end

local yrp_logo = Material("yrp/yrp_icon")
function YRPDrawOrder(self, x, y, text, font, art)
	local lply = LocalPlayer()
	if lply.yrp_sb_sortby == art then
		surface.SetFont(font)
		local sw, _ = surface.GetTextSize(text)
		local siz = 16
		x = x + sw / 2 + 4
		y = y - siz / 2
		local triangle = {
			{
				x = x + 0,
				y = y + siz
			},
			{
				x = x + siz / 2,
				y = y + 0
			},
			{
				x = x + siz,
				y = y + siz
			}
		}

		if lply.yrp_sb_reverse then
			triangle = {
				{
					x = x + 0,
					y = y + 0
				},
				{
					x = x + siz,
					y = y + 0
				},
				{
					x = x + siz / 2,
					y = y + siz
				}
			}
		end

		surface.SetDrawColor(Color(255, 255, 255, 255))
		draw.NoTexture()
		surface.DrawPoly(triangle)
	end
end

function YRPInitScoreboard()
	if YRPPanelAlive(YRPScoreboard, "YRPScoreboard 7") then
		YRPScoreboard:Remove()
	end

	YRPScoreboard = YRPCreateD("DFrame", nil, ScrW(), ScrH(), 0, 0)
	YRPScoreboard:DockPadding(4, 4, 4, 4)
	YRPScoreboard.plys = {}
	YRPScoreboard:Hide()
	YRPScoreboard:SetTitle("")
	YRPScoreboard:ShowCloseButton(false)
	YRPScoreboard:SetDraggable(false)
	YRPScoreboard.delay = 0
	YRPScoreboard.w = ScrW()
	function YRPScoreboard:Paint(pw, ph)
		Derma_DrawBackgroundBlur(self, 0)
		if self.amount ~= player.GetCount() then
			self.amount = player.GetCount()
			YRPOpenSBS()
		end

		if self.logo then
			if self.logo.svlogo ~= GetGlobalYRPString("text_server_logo", "") then
				self.logo.svlogo = GetGlobalYRPString("text_server_logo", "")
				if not strEmpty(GetGlobalYRPString("text_server_logo", "")) then
					YRPScoreboard.logo:SetHTML(YRPGetHTMLImage(GetGlobalYRPString("text_server_logo", ""), 128, 128))
					YRPScoreboard.logo:Show()
				else
					YRPScoreboard.logo:Hide()
				end
			end

			if not self.logo:IsVisible() then
				surface.SetMaterial(yrp_logo)
				surface.SetDrawColor(Color(255, 255, 255, 255))
				surface.DrawTexturedRect(0, 0, 128, 128)
			end
		end

		if input.IsMouseDown(MOUSE_RIGHT) and self.delay < CurTime() then
			self.delay = CurTime() + 0.5
			gui.EnableScreenClicker(not vgui.CursorVisible())
		end

		-- MOUSE HELP
		if not vgui.CursorVisible() then
			draw.SimpleText(YRP.trans("LID_rightclicktoshowmouse"), "Open Sans_24", pw / 2, 34, Color(255, 255, 100), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end

		-- BOTTOM LEFT
		local br = 2
		local server = ""
		if GAMEMODE.dedicated then
			server = " [Dedicated]"
		end

		draw.SimpleText("v" .. YRPVersion() .. " ( " .. GetGlobalYRPString("YRP_VERSIONART", "X") .. " )" .. string.upper(server), "Open Sans_16", pw - br, br, Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
	end

	YRPScoreboard.BotBar = YRPCreateD("DPanel", YRPScoreboard, 128, 32, 0, 0)
	YRPScoreboard.BotBar:Dock(BOTTOM)
	function YRPScoreboard.BotBar:Paint(pw, ph)
		-- Table Footer
		draw.RoundedBox(5, 0, 0, YRPScoreboard.w, hr, Color(255, 255, 255, 255))
		draw.SimpleText(string.upper(YRP.trans("LID_map")) .. ": " .. GetNiceMapName(), "Open Sans_28", 0, ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		draw.SimpleText("YourRP by D4KiR", "Open Sans_28", pw / 2, ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		draw.SimpleText(player.GetCount() .. "/" .. game.MaxPlayers() .. " (" .. string.upper(YRP.trans("LID_players")) .. ")", "Open Sans_28", pw, ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
	end

	YRPScoreboard.TopBar = YRPCreateD("DPanel", YRPScoreboard, 128, 128, 0, 0)
	YRPScoreboard.TopBar:Dock(TOP)
	function YRPScoreboard.TopBar:Paint(pw, ph)
		-- NAME
		local name = GetGlobalYRPString("text_server_name", "")
		if strEmpty(name) then
			name = YRPGetHostName()
		end

		draw.SimpleText(name, "Open Sans_60", pw / 2, ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

	YRPScoreboard.Header = YRPCreateD("DPanel", YRPScoreboard, 32, 32, 0, 0)
	YRPScoreboard.Header:Dock(TOP)
	function YRPScoreboard.Header:Paint(pw, ph)
		draw.RoundedBox(5, 0, 32 - hr, pw, hr, Color(255, 255, 255, 255))
	end

	YRPScoreboard.list = YRPCreateD("DScrollPanel", YRPScoreboard, 100, 100, 0, 0)
	YRPScoreboard.list:Dock(FILL)
	YRPScoreboard.list:SetPadding(0)
	function YRPScoreboard.list:Paint(pw, ph)
	end

	--
	local sbar = YRPScoreboard.list.VBar
	if IsValid(sbar) then
		function sbar:Paint(w, h)
			draw.RoundedBox(0, 0, 0, w, h, YRPInterfaceValue("YFrame", "NC"))
		end

		function sbar.btnUp:Paint(w, h)
			draw.RoundedBox(0, 0, 0, w, h, Color(60, 60, 60))
		end

		function sbar.btnDown:Paint(w, h)
			draw.RoundedBox(0, 0, 0, w, h, Color(60, 60, 60))
		end

		function sbar.btnGrip:Paint(w, h)
			draw.RoundedBox(w / 2, 0, 0, w, h, YRPInterfaceValue("YFrame", "HI"))
		end
	end

	YRPScoreboard.logo = YRPCreateD("DHTML", YRPScoreboard.TopBar, 128, 128, 0, 0)
	YRPScoreboard.logo:Dock(LEFT)
	YRPScoreboard:Hide()
end

YRPInitScoreboard()
function GM:ScoreboardShow()
	if GetGlobalYRPBool("bool_yrp_scoreboard") then
		YRPOpenSBS()
	end
end

function GM:ScoreboardHide()
	YRPCloseSBS()
end
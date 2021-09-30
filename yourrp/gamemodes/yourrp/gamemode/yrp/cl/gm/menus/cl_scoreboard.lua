--Copyright (C) 2017-2021 D4KiR (https://www.gnu.org/licenses/gpl.txt)

surface.CreateFont("Saira_72", {
	font = "Saira",
	extended = true,
	size = 72,
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
})

surface.CreateFont("Saira_30", {
	font = "Saira",
	extended = true,
	size = 30,
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
})

surface.CreateFont("Saira_24", {
	font = "Saira",
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
})

surface.CreateFont("Saira_16", {
	font = "Saira",
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
})

local sh = ScrH() * 0.8
local sw = sh * 1.8
sh = math.floor(sh)
sw = math.floor(sw)
local size = 40
local hr = 2
local br = 1
local sp = 10

function YRPTextColor(bgcolor, a)
	local brightness = (bgcolor.r * 299 + bgcolor.g * 587 + bgcolor.b * 114) / 1000
	if brightness > 125 then
		return Color(0, 0, 0, a)
	else
		return Color(255, 255, 255, a)
	end
end

function YRPNotSelf(ply)
	return ply != LocalPlayer()
end

function YRPOpenPlayerOptions(ply)
	local lp = LocalPlayer()
	if lp:HasAccess() then
		local _mx, _my = gui.MousePos()
		local _menu = createD("DYRPMenu", nil, YRP.ctr(800), YRP.ctr(50), _mx - YRP.ctr(25), _my - YRP.ctr(25))
		_menu:MakePopup()

		local osp = _menu:AddOption(YRP.lang_string("LID_openprofile"), "icon16/page.png")
		function osp:DoClick()
			ply:ShowProfile()
		end

		_menu:AddSpacer()

		local SteamID = ply:SteamID()
		local SteamID64 = ply:SteamID64()

		if wk(SteamID) and wk(SteamID64) then
			local csid = _menu:AddOption(YRP.lang_string("LID_copysteamid") .. ": " .. SteamID, "icon16/page_copy.png")
			function csid:DoClick()
				SetClipboardText(ply:SteamID())
				_menu:Remove()
			end

			local csid64 = _menu:AddOption(YRP.lang_string("LID_copysteamid64") .. ": " .. SteamID64, "icon16/page_copy.png")
			function csid64:DoClick()
				SetClipboardText(ply:SteamID64())
				_menu:Remove()
			end
		end
		if true then

			local crpname = _menu:AddOption(YRP.lang_string("LID_copyrpname") .. ": " .. ply:RPName(), "icon16/page_copy.png")
			function crpname:DoClick()
				SetClipboardText(ply:RPName())
				_menu:Remove()
			end
			local csname = _menu:AddOption(YRP.lang_string("LID_copysteamname") .. ": " .. ply:SteamName(), "icon16/page_copy.png")
			function csname:DoClick()
				SetClipboardText(ply:SteamName())
				_menu:Remove()
			end
			_menu:AddSpacer()

			_menu:AddOption(YRP.lang_string("LID_language") .. ": " .. ply:GetLanguage(), "icon16/map.png")
			_menu:AddSpacer()

			_menu:AddOption(YRP.lang_string("LID_country") .. ": " .. ply:GetCountry(), "icon16/map.png")
			_menu:AddSpacer()

			if YRPNotSelf(ply) then
				local ban = _menu:AddOption(YRP.lang_string("LID_ban"), "icon16/world_link.png")
				function ban:DoClick()
					net.Start("ply_ban")
						net.WriteEntity(ply)
					net.SendToServer()
				end
				local kick = _menu:AddOption(YRP.lang_string("LID_kick"), "icon16/world_go.png")
				function kick:DoClick()
					net.Start("ply_kick")
						net.WriteEntity(ply)
					net.SendToServer()
				end
				_menu:AddSpacer()
			end

			if YRPNotSelf(ply) then
				local tpto = _menu:AddOption(YRP.lang_string("LID_tpto"), "icon16/arrow_right.png")
				function tpto:DoClick()
					net.Start("tp_tpto")
						net.WriteEntity(ply)
					net.SendToServer()
				end
				local bring = _menu:AddOption(YRP.lang_string("LID_bring"), "icon16/arrow_redo.png")
				function bring:DoClick()
					net.Start("tp_bring")
						net.WriteEntity(ply)
					net.SendToServer()
				end
			end

			if true then
				if !ply:GetNW2Bool("injail", false) then
					local jail = _menu:AddOption(YRP.lang_string("LID_jail"), "icon16/lock_go.png")
					function jail:DoClick()
						net.Start("tp_jail")
							net.WriteEntity(ply)
						net.SendToServer()
						_menu:Remove()
					end
				else
					local unjail = _menu:AddOption(YRP.lang_string("LID_unjail"), "icon16/lock_open.png")
					function unjail:DoClick()
						net.Start("tp_unjail")
							net.WriteEntity(ply)
						net.SendToServer()
						_menu:Remove()
					end
				end
				_menu:AddSpacer()
			end

			if true then
				if !ply:GetNW2Bool("ragdolled", false) then
					local ragdoll = _menu:AddOption(YRP.lang_string("LID_ragdoll"), "icon16/user_red.png")
					function ragdoll:DoClick()
						net.Start("ragdoll")
							net.WriteEntity(ply)
						net.SendToServer()
						_menu:Remove()
					end
				else
					local unragdoll = _menu:AddOption(YRP.lang_string("LID_unragdoll"), "icon16/user_green.png")
					function unragdoll:DoClick()
						net.Start("unragdoll")
							net.WriteEntity(ply)
						net.SendToServer()
						_menu:Remove()
					end
				end
				if !ply:IsFlagSet(FL_FROZEN) then
					local freeze = _menu:AddOption(YRP.lang_string("LID_freeze"), "icon16/user_suit.png")
					function freeze:DoClick()
						net.Start("freeze")
							net.WriteEntity(ply)
						net.SendToServer()
						_menu:Remove()
					end
				else
					local unfreeze = _menu:AddOption(YRP.lang_string("LID_unfreeze"), "icon16/user_gray.png")
					function unfreeze:DoClick()
						net.Start("unfreeze")
							net.WriteEntity(ply)
						net.SendToServer()
						_menu:Remove()
					end
				end
			end

			if true then
				if !ply:GetNW2Bool("godmode", false) then
					local god = _menu:AddOption(YRP.lang_string("LID_god"), "icon16/star.png")
					function god:DoClick()
						net.Start("god")
							net.WriteEntity(ply)
						net.SendToServer()
						_menu:Remove()
					end
				else
					local ungod = _menu:AddOption(YRP.lang_string("LID_ungod"), "icon16/stop.png")
					function ungod:DoClick()
						net.Start("ungod")
							net.WriteEntity(ply)
						net.SendToServer()
						_menu:Remove()
					end
				end
				if !ply:GetNW2Bool("cloaked", false) then
					local cloak = _menu:AddOption(YRP.lang_string("LID_cloak"), "icon16/status_offline.png")
					function cloak:DoClick()
						net.Start("cloak")
							net.WriteEntity(ply)
						net.SendToServer()
						_menu:Remove()
					end
				else
					local uncloak = _menu:AddOption(YRP.lang_string("LID_uncloak"), "icon16/status_online.png")
					function uncloak:DoClick()
						net.Start("uncloak")
							net.WriteEntity(ply)
						net.SendToServer()
						_menu:Remove()
					end
				end
				if !ply:GetNW2Bool("blinded", false) then
					local blind = _menu:AddOption(YRP.lang_string("LID_blind"), "icon16/weather_sun.png")
					function blind:DoClick()
						net.Start("blind")
							net.WriteEntity(ply)
						net.SendToServer()
						_menu:Remove()
					end
				else
					local unblind = _menu:AddOption(YRP.lang_string("LID_unblind"), "icon16/weather_clouds.png")
					function unblind:DoClick()
						net.Start("unblind")
							net.WriteEntity(ply)
						net.SendToServer()
						_menu:Remove()
					end
				end
				if !ply:IsOnFire() then
					local ignite = _menu:AddOption(YRP.lang_string("LID_ignite"), "icon16/fire.png")
					function ignite:DoClick()
						net.Start("ignite")
							net.WriteEntity(ply)
						net.SendToServer()
						_menu:Remove()
					end
				else
					local extinguish = _menu:AddOption(YRP.lang_string("LID_extinguish"), "icon16/water.png")
					function extinguish:DoClick()
						net.Start("extinguish")
							net.WriteEntity(ply)
						net.SendToServer()
						_menu:Remove()
					end
				end

				local slay = _menu:AddOption(YRP.lang_string("LID_slay"), "icon16/delete.png")
				function slay:DoClick()
					net.Start("slay")
						net.WriteEntity(ply)
					net.SendToServer()
					_menu:Remove()
				end
				local slap = _menu:AddOption(YRP.lang_string("LID_slap"), "icon16/heart_delete.png")
				function slap:DoClick()
					net.Start("slap")
						net.WriteEntity(ply)
					net.SendToServer()
				end
			end
		end
	end
end

function YRPIsScoreboardVisible()
	if pa(YRPScoreboard) and YRPScoreboard:IsVisible() then
		return true
	end
	return false
end

function YRPCloseSBS()
	if !pa(YRPScoreboard) then return end

	YRPScoreboard:Hide()
	gui.EnableScreenClicker(false)
end

function YRPSortScoreboard()
	if !pa(YRPScoreboard) then return end
	local lply = LocalPlayer()
	if lply.ypr_sb_reverse == nil then
		lply.ypr_sb_reverse = false
	end
	if lply.yrp_sb_sortby == nil then
		lply.yrp_sb_sortby = "guid"
	end

	-- Players
	YRPScoreboard.list:Clear()
	YRPScoreboard.plys = {}

	local plys = {}
	for i, ply in pairs(player.GetAll()) do
		if IsValid(ply) then
			local entry = {}
			entry.ply = ply
			entry.ruid = ply:GetRoleUID()
			if entry.ruid <= 0 then
				entry.ruid = 999999
			end
			entry.guid = ply:GetGroupUID()
			if entry.guid <= 0 then
				entry.guid = 999999
			end
			entry.usergroup = ply:GetUserGroupNice()
			entry.level = ply:Level()
			entry.idcardid = ply:IDCardID()
			entry.name = ply:RPName()
			entry.language = ply:GetLanguage()
			table.insert(plys, entry)
		end
	end
	
	for i, entry in SortedPairsByMemberValue(plys, lply.yrp_sb_sortby, lply.ypr_sb_reverse) do
		YRPScoreboardAddPlayer(entry.ply)
	end
end

function YRPOpenSBS()
	if !pa(YRPScoreboard) then return end

	local lply = LocalPlayer()

	YRPScoreboard:Show()

	gui.EnableScreenClicker(true)

	YRPSortScoreboard()
end

local yrptab = {}
yrptab["avatar"] = 10
yrptab["level"] = 10
yrptab["idcardid"] = 10
yrptab["name"] = 10
yrptab["groupname"] = 10
yrptab["rolename"] = 10
yrptab["usergroup"] = 10
yrptab["language"] = 10
yrptab["operating_system"] = 10

function YRPScoreboardAddPlayer(ply)
	if pa(YRPScoreboard) and IsValid(ply) and !table.HasValue(YRPScoreboard.plys, ply) then
		table.insert(YRPScoreboard.plys, ply)

		local avsize = size - 2 * hr - 2
		local avbr = hr + 1

		local plyframe = createD("DPanel", YRPScoreboard.list, sw, size, 0, 0)
		plyframe:Dock( TOP )
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
		local plypnl = createD("DPanel", plyframe, sw, size, 0, 0)
		plypnl:Dock( TOP )
		function plypnl:Paint(pw, ph)
			draw.RoundedBox(0, avbr, avbr, avsize, avsize, Color(255, 255, 255, 255))
		end
		plypnl.infos = createD("DPanel", plypnl, sw - 13, size, 13, 0)

		function plypnl.infos:Paint(pw, ph)
			if IsValid(ply) then
				self.guid = ply:GetGroupUID()

				local circlesize = 12
				local circlebr = 6

				local x = yrptab["avatar"] - 2
				if !ply:GetNW2Bool("yrp_characterselection", true) or IsVoidCharEnabled() or !GetGlobalBool("bool_character_system", true) then
					if GetGlobalBool("bool_yrp_scoreboard_show_level", false) then
						draw.SimpleText(ply:Level(), "Saira_24", x + yrptab["level"] / 2, ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
						x = x + yrptab["level"] + sp
					end
					if GetGlobalBool("bool_yrp_scoreboard_show_idcardid", false) then
						draw.SimpleText(ply:IDCardID(), "Saira_24", x + yrptab["idcardid"] / 2, ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
						x = x + yrptab["idcardid"] + sp
					end
					if GetGlobalBool("bool_yrp_scoreboard_show_name", false) then
						local name = ply:RPName()
						if ply:IsBot() then
							name = ply:SteamName()
						end
						draw.SimpleText(name, "Saira_24", x + yrptab["name"] / 2, ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
						x = x + yrptab["name"] + sp
					end
					if GetGlobalBool("bool_yrp_scoreboard_show_groupname", false) then
						local text = ply:GetGroupName()
						local font = "Saira_24"
						surface.SetFont(font)
						local tsw, tsh = surface.GetTextSize(text)

						if YRP.GetDesignIcon("circle") then
							surface.SetDrawColor(ply:GetGroupColor())
							surface.SetMaterial(YRP.GetDesignIcon("circle"))
							surface.DrawTexturedRect(x + yrptab["groupname"] / 2 - tsw / 2 - circlesize - circlebr, ph / 2 - circlesize / 2, circlesize, circlesize)
						end

						draw.SimpleText(text, font, x + yrptab["groupname"] / 2, ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
						x = x + yrptab["groupname"] + sp
					end
					if GetGlobalBool("bool_yrp_scoreboard_show_rolename", false) then
						local text = ply:GetRoleName()
						local font = "Saira_24"
						surface.SetFont(font)
						local tsw, tsh = surface.GetTextSize(text)

						if YRP.GetDesignIcon("circle") then
							surface.SetDrawColor(ply:GetRoleColor())
							surface.SetMaterial(YRP.GetDesignIcon("circle"))
							surface.DrawTexturedRect(x + yrptab["rolename"] / 2 - tsw / 2 - circlesize - circlebr, ph / 2 - circlesize / 2, circlesize, circlesize)
						end

						draw.SimpleText(text, font, x + yrptab["rolename"] / 2, ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
						x = x + yrptab["rolename"] + sp
					end
				elseif ply:GetNW2Bool("yrp_characterselection", true) then
					draw.SimpleText("[" .. YRP.lang_string("LID_characterselection") .. "]", "Saira_24", x, ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
				else
					draw.SimpleText("[" .. "FAIL" .. "]", "Saira_24", x, ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				end
				



				local trx = 90 + sp
				draw.SimpleText(ply:Ping(), "Saira_24", pw - 20 - size, ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				if self.Mute and (self.Muted == nil or self.Muted != ply:IsMuted()) then
					self.Muted = ply:IsMuted()
					if ( self.Muted ) then
						self.Mute:SetImage( "vgui/material/icon_mute.png" )
					else
						self.Mute:SetImage( "vgui/material/icon_voice.png" )
					end
		
					self.Mute.DoClick = function( s ) ply:SetMuted( !self.Muted ) end
					self.Mute.OnMouseWheeled = function( s, delta )
						ply:SetVoiceVolumeScale( ply:GetVoiceVolumeScale() + ( delta / 100 * 5 ) )
						s.LastTick = CurTime()
					end
		
					self.Mute.PaintOver = function( s, w, h )
						if !IsValid(ply) then return end
						if s:IsHovered() then
							s.LastTick = CurTime()
						end
						local a = 255 - math.Clamp( CurTime() - ( s.LastTick or 0 ), 0, 3 ) * 255
						draw.RoundedBox( 4, 0, 0, w, h, Color( 0, 0, 0, a * 0.75 ) )
						draw.SimpleText( math.ceil( ply:GetVoiceVolumeScale() * 100 ) .. "%", "DermaDefaultBold", w / 2, h / 2, Color( 255, 255, 255, a ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
					end
				end
				if ply:IsBot() then
					self.Mute:Hide()
				else
					self.Mute:Show()
				end
				if GetGlobalBool("bool_yrp_scoreboard_show_operating_system", false) then
					--draw.SimpleText(string.upper(ply:GetNW2String("yrp_os", "")), "Saira_24", pw - trx, ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
					self.lang = YRP.GetDesignIcon("os_" .. ply:GetNW2String("yrp_os", ""))
					if self.lang ~= nil then
						if !ply:IsBot() then
							local sh = size * 0.8
							YRP.DrawIcon(self.lang, sh, sh, pw - trx - yrptab["operating_system"] / 2 - sh / 2, size / 2 - sh / 2, Color(255, 255, 255, 255))
						end
					end
					trx = trx + yrptab["operating_system"] + sp
				end
				if GetGlobalBool("bool_yrp_scoreboard_show_language", false) then
					--draw.SimpleText(string.upper(ply:YRPGetLanguage()), "Saira_24", pw - trx, ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
					if !ply:IsBot() then 
						self.lang = YRP.GetDesignIcon("lang_" .. ply:GetLanguageShort())
						if self.lang ~= nil then
							local sh = size * 0.8
							YRP.DrawIcon(self.lang, sh * 1.49, sh, pw - trx - yrptab["language"] / 2 - sh * 1.49 / 2, size / 2 - sh / 2, Color(255, 255, 255, 255))
						end
					end
					trx = trx + yrptab["language"] + sp
				end
				if GetGlobalBool("bool_yrp_scoreboard_show_usergroup", false) then
					local text = ply:GetUserGroupNice()
					local font = "Saira_24"
					surface.SetFont(font)
					local tsw, tsh = surface.GetTextSize(text)

					if YRP.GetDesignIcon("circle") then
						surface.SetDrawColor(ply:GetUserGroupColor())
						surface.SetMaterial(YRP.GetDesignIcon("circle"))
						surface.DrawTexturedRect(pw - trx - yrptab["usergroup"] / 2 - tsw / 2 - circlesize - circlebr, ph / 2 - circlesize / 2, circlesize, circlesize)
					end

					draw.SimpleText(text, font, pw - trx - yrptab["usergroup"] / 2, ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
					trx = trx + yrptab["usergroup"] + sp
				end
			else
				table.RemoveByValue(YRPScoreboard.plys, ply)
				--YRPScoreboard.list:RemoveItem(plypnl)
				plypnl:Remove()
			end
		end
		plypnl.avatar = createD("AvatarImage", plypnl, avsize - 2 * br, avsize - 2 * br, avbr + br, avbr + br)
		plypnl.avatar:SetPlayer(ply)

		plypnl.btn = createD("DButton", plypnl, sw, size, 0, 0)
		plypnl.btn:SetText("")
		function plypnl.btn:Paint(pw, ph)
			-- draw.RoundedBox(0, 0, 0, pw, ph, Color(255, 0, 0, 100))
		end
		function plypnl.btn:DoClick()
			plyframe.open = !plyframe.open
		end
		function plypnl.btn:DoRightClick()
			--YRPOpenPlayerOptions(ply)
		end

		plypnl.infos.Mute = createD("DImageButton", plypnl, size, size, 0, 0)
		plypnl.infos.Mute:Dock( RIGHT )



		-- Second Line
		plyopt = createD("DPanel", plyframe, sw, size, 0, 0)
		plyopt:Dock( TOP )
		function plyopt:Paint(pw, ph)
			if IsValid(ply) and LocalPlayer():HasAccess() then
				local br = ph * 0.1
				local iconsize = ph * 0.8
				local ts = math.Round(math.Clamp(ph * 0.5, 6, 100), 0)

				-- Money
				if YRP.GetDesignIcon("64_money-bill") then
					surface.SetMaterial(YRP.GetDesignIcon("64_money-bill"))
					surface.SetDrawColor(255, 255, 255, 255)
					surface.DrawTexturedRect(br, br, iconsize, iconsize)
				end

				draw.SimpleText(ply:FormattedMoney(), "Y_" .. ts .. "_500", ph + br, ph / 2 * 0.9, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			end
		end

		local btnbr = size * 0.1
		local btnsize = size * 0.8

		plyopt.btns = createD("DHorizontalScroller", plyopt, btnsize, btnsize, 0, 0)
		plyopt.btns:SetOverlap(-10)

		local btns = {}
		btns[1] = {"LID_account", "account", false, false, function()
			if IsValid(ply) then
				ply:ShowProfile()
			end
		end}
		btns[2] = {"LID_info", "128_info-circle", false, false, function()
			if IsValid(ply) and ply:SteamID() and ply:SteamID64() then
				SetClipboardText("SteamID: \t" .. ply:SteamID() .. " \nSteamID64: \t" .. ply:SteamID64() .. " \nRPName: \t" .. ply:RPName() .. " \nSteamName: \t" .. ply:SteamName())
				notification.AddLegacy("[" .. string.upper(YRP.lang_string("LID_info")) .. "] COPIED TO CLIPBOARD", NOTIFY_GENERIC, 3)
			else
				notification.AddLegacy("[" .. string.upper(YRP.lang_string("LID_info")) .. "] PLAYER IS NOT VALID", NOTIFY_ERROR, 3)
			end
		end}
		btns[3] = {"LID_tpto", "128_arrow-circle-up", true, true, function()
			if IsValid(ply) and YRPNotSelf(ply) then
				net.Start("tp_tpto")
					net.WriteEntity(ply)
				net.SendToServer()
			end
		end}
		btns[4] = {"LID_bring", "128_arrow-circle-down", true, true, function()
			if IsValid(ply) and YRPNotSelf(ply) then
				net.Start("tp_bring")
					net.WriteEntity(ply)
				net.SendToServer()
			end
		end}
		btns[5] = {"LID_return", "return", true, false, function()
			if IsValid(ply) then
				net.Start("tp_return")
					net.WriteEntity(ply)
				net.SendToServer()
			end
		end, function(btn)
			if IsValid(ply) then
				if ply:GetNW2Vector("yrpoldpos") != Vector(0, 0, 0) then
					btn.iconcolor = Color(255, 255, 255)
				else
					btn.iconcolor = Color(255, 0, 0)
				end
			end
		end}
		btns[6] = {"LID_freeze", "128_snowflake", true, false, function()
			if IsValid(ply) then
				if !ply:IsFlagSet(FL_FROZEN) then
					net.Start("freeze")
						net.WriteEntity(ply)
					net.SendToServer()
				else
					net.Start("unfreeze")
						net.WriteEntity(ply)
					net.SendToServer()
				end
			end
		end, function(btn)
			if IsValid(ply) then
				if ply:IsFlagSet(FL_FROZEN) then
					btn.iconcolor = Color(100, 100, 255)
				else
					btn.iconcolor = Color(255, 255, 255)
				end
			end
		end}
		btns[7] = {"LID_spectate", "eye", true, true, function()
			if IsValid(ply) and YRPNotSelf(ply) then
				local frame = vgui.Create( "DFrame" )
				frame:SetTitle(ply:RPName() .. " [" .. ply:SteamName() .. "]")
				frame:SetSize(ScrW() / 2, ScrH() / 2)
				frame:Center()
				frame:SetScreenLock(true)
				frame:SetSizable(true)
				--frame:MakePopup()

				function frame:Paint( w, h )
					if IsValid(ply) then
						local x, y = self:GetPos()

						local tr = util.TraceHull( {
							start = ply:EyePos(),
							endpos = ply:EyePos() - ( ply:GetAimVector() * 200 ),
							filter = ply,
							mins = Vector( -10, -10, -10 ),
							maxs = Vector( 10, 10, 10 ),
							mask = MASK_SHOT_HULL
						} )

						local old = DisableClipping( true ) -- Avoid issues introduced by the natural clipping of Panel rendering
						render.RenderView( {
							origin = tr.HitPos, --ply:EyePos() - ply:GetRenderAngles():Forward() * 200,
							angles = ply:GetRenderAngles(), -- + LocalPlayer():GetAngles(),
							x = x, y = y,
							w = w, h = h
						} )
						DisableClipping( old )
					else
						self:Remove()
					end
				end
			end
		end}
		btns[8] = {"LID_cloak", "incognito", true, false, function()
			if IsValid(ply) then
				if !ply:GetNW2Bool("cloaked", false) then
					net.Start("cloak")
						net.WriteEntity(ply)
					net.SendToServer()
				else
					net.Start("uncloak")
						net.WriteEntity(ply)
					net.SendToServer()
				end
			end
		end, function(btn)
			if IsValid(ply) then
				if ply:GetNW2Bool("cloaked", false) then
					btn.iconcolor = Color(0, 255, 0)
				else
					btn.iconcolor = Color(255, 255, 255)
				end
			end
		end}
		btns[9] = {"LID_kick", "128_fist-raised", true, true, function()
			if IsValid(ply) then
				net.Start("ply_kick")
					net.WriteEntity(ply)
				net.SendToServer()
			end
		end}
		btns[10] = {"LID_ban", "128_gavel", true, true, function()
			if IsValid(ply) then
				net.Start("ply_ban")
					net.WriteEntity(ply)
				net.SendToServer()
			end
		end}
		for i, btn in pairs(btns) do
			if !btn[3] or (btn[3] and LocalPlayer():HasAccess()) then
				if !btn[4] or (btn[4] and YRPNotSelf(ply)) then
					local b = createD("YButton", plyopt.btns, btnsize, btnsize, 0, 0)
					b:SetText("")
					b.icon = btn[2]
					b.iconcolor = Color(255, 255, 255)
					function b:Paint(pw, ph)
						local br = ph * 0.1
						local iconsize = ph * 0.8

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

							if !pa(self.tt) then
								self.tt = createD("DFrame", nil, 100, 20, 0, 0)
								self.tt:SetTitle("")
								self.tt:ShowCloseButton(false)
								self.tt:SetDraggable(false)
								function self.tt:Paint(pw, ph)
									draw.SimpleText(YRP.lang_string(btn[1]), "Y_16_500", pw / 2, ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

									if !YRPIsScoreboardVisible() then
										self:Remove()
									end
								end
								local bpx, bpy = self:LocalToScreen(0, 0)
								local ttsw, ttsh = self.tt:GetSize()
								local bsw, bsh = self:GetSize()
								self.tt:SetPos(bpx + bsw / 2 - ttsw / 2, bpy + bsh)
							end
						else
							self.hovering = false
							self.clicked = false

							if pa(self.tt) then
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

					plyopt.btns:AddPanel(b)
				end
			end
		end

		if plyopt.btns.GetCanvas then
			local csw, csh = plyopt.btns:GetCanvas():GetSize()
			plyopt.btns:SetWide(csw)
			plyopt.btns:SetPos(sw / 2 - csw / 2, btnbr)
		end
		
		YRPScoreboard.list:AddItem(plyframe)
	end
end

local ypr_logo = Material("yrp/yrp_icon")
local matBlurScreen = Material( "pp/blurscreen" )

local function DrawBlurRect(x, y, w, h, amount, density)
    surface.SetDrawColor(0, 0, 0)
    surface.SetMaterial(matBlurScreen)

    for i = 1, density do
		matBlurScreen:SetFloat("$blur", (i / 3) * (amount or 6))
        matBlurScreen:Recompute()
        render.UpdateScreenEffectTexture()
        render.SetScissorRect(x, y, x + w, y + h, true)
        surface.DrawTexturedRect(0 * -1, 0 * -1, ScrW(), ScrH())
        render.SetScissorRect(0, 0, 0, 0, false)
    end
end

local function YRPBlurScoreboard(panel, amount, density)
	local x, y = panel:LocalToScreen( 0, 0 )

	local wasEnabled = DisableClipping( true )

	if ( !MENU_DLL ) then
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.SetMaterial( matBlurScreen )

		for i = 1, density do
			matBlurScreen:SetFloat("$blur", (i / 3) * (amount or 6))
			matBlurScreen:Recompute()
			if ( render ) then render.UpdateScreenEffectTexture() end
			surface.DrawTexturedRect( x * -1, y * -1, ScrW(), ScrH() )
		end
	end

	surface.SetDrawColor( 0, 0, 0, 180 )
	surface.DrawRect( x * -1, y * -1, ScrW(), ScrH() )

	DisableClipping( wasEnabled )
end

function YRPDrawOrder(self, x, y, text, font, art)
	local lply = LocalPlayer()
	if lply.yrp_sb_sortby == art then
		surface.SetFont(font)
		local sw, sh = surface.GetTextSize(text)
		local size = 16

		x = x - sw / 2 - size - 10
		y = y - size / 2

		local triangle = {
			{ x = x + 0, y = y + size },
			{ x = x + size / 2, y = y + 0 },
			{ x = x + size, y = y + size }
		}
		if lply.ypr_sb_reverse then
			triangle = {
				{ x = x + 0, y = y + 0 },
				{ x = x + size, y = y + 0},
				{ x = x + size / 2, y = y + size }
			}
		end

		surface.SetDrawColor( 255, 255, 255, 255 )
		draw.NoTexture()
		surface.DrawPoly( triangle )
	end
end

function YRPInitScoreboard()
	sw = math.Clamp(sw, sh, ScrW())
	if pa(YRPScoreboard) then
		YRPScoreboard:Remove()
	end
	YRPScoreboard = createD("DFrame", nil, ScrW(), ScrH(), 0, 0)
	YRPScoreboard.plys = {}
	YRPScoreboard:Hide()
	YRPScoreboard:SetTitle("")
	YRPScoreboard:ShowCloseButton(false)
	YRPScoreboard:SetDraggable(false)
	YRPScoreboard.delay = 0

	YRPScoreboard.logo = createD("DHTML", YRPScoreboard, 128, 128, ScrW() / 2 - sw / 2, 20)

	function YRPScoreboard:Paint(pw, ph)
		YRPBlurScoreboard(self, 10, 3)
		--DrawBlurRect(0, 0, pw, ph, 3, 6)
		
		if self.amount != player.GetCount() then
			self.amount = player.GetCount()
			YRPOpenSBS()
		end

		if self.logo then
			if self.logo.svlogo != GetGlobalString("text_server_logo", "") then
				self.logo.svlogo = GetGlobalString("text_server_logo", "")

				if !strEmpty(GetGlobalString("text_server_logo", "")) then
					YRPScoreboard.logo:SetHTML(GetHTMLImage(GetGlobalString("text_server_logo", ""), 128, 128))
					YRPScoreboard.logo:Show()
				else
					YRPScoreboard.logo:Hide()
				end
			end

			if !self.logo:IsVisible() then
				surface.SetMaterial(ypr_logo)
				surface.SetDrawColor(255, 255, 255, 255)
				surface.DrawTexturedRect(ScrW() / 2 - sw / 2, 20, 128, 128)
			end
		end
		
		if  input.IsMouseDown( MOUSE_RIGHT ) and self.delay < CurTime() then
			self.delay = CurTime() + 0.5
			gui.EnableScreenClicker(!vgui.CursorVisible())
		end

		-- MOUSE HELP
		if !vgui.CursorVisible() then
			draw.SimpleText(YRP.lang_string("LID_rightclicktoshowmouse"), "Saira_24", pw / 2, 34, Color(255, 255, 100, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end

		-- NAME
		local name = GetGlobalString("text_server_name", "")
		if strEmpty(name) then
			name = YRPGetHostName()
		end
		draw.SimpleText(name, "Saira_72", pw / 2, 80, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)



		yrptab["avatar"] = 40
		yrptab["level"] = 50
		yrptab["idcardid"] = 140
		if !GetGlobalBool("bool_yrp_scoreboard_show_level", false) and !GetGlobalBool("bool_yrp_scoreboard_show_idcardid", false) then
			yrptab["name"] = 260
		else
			yrptab["name"] = 160
		end
		yrptab["groupname"] = 320
		if !GetGlobalBool("bool_yrp_scoreboard_show_groupname", false) then
			yrptab["rolename"] = 360
		else
			yrptab["rolename"] = 280
		end
		yrptab["usergroup"] = 210
		yrptab["language"] = 90
		yrptab["operating_system"] = 50



		-- Table Header
		local tx = ScrW() / 2 - sw / 2 + yrptab["avatar"] + sp
		if GetGlobalBool("bool_yrp_scoreboard_show_level", false) then
			if self.sortbylevel == nil then
				self.sortbylevel = createD("DButton", self, 100, 40, 0, 0)
				self.sortbylevel:SetText("")
				function self.sortbylevel:Paint(pw, ph)
					-- 
				end
				function self.sortbylevel:DoClick()
					local lply = LocalPlayer()
					if lply.yrp_sb_sortby == "level" then
						lply.ypr_sb_reverse = !lply.ypr_sb_reverse
					end
					lply.yrp_sb_sortby = "level"
					YRPSortScoreboard()
				end
			end
			self.sortbylevel:SetSize(yrptab["level"], 40)
			self.sortbylevel:SetPos(tx, 160 - 20)

			--draw.RoundedBox(0, tx, 160 - 10, yrptab["level"], 1000, Color(255, 0, 0, 100))
			local text = string.sub(string.upper(YRP.lang_string("LID_level")), 1, 2) .. "."
			draw.SimpleText(text, "Saira_30", tx + yrptab["level"] / 2, 160, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			YRPDrawOrder(self, tx + yrptab["level"] / 2, 160, text, "Saira_30", "level")
			tx = tx + yrptab["level"] + sp
		end
		if GetGlobalBool("bool_yrp_scoreboard_show_idcardid", false) then
			if self.sortbyidcardid == nil then
				self.sortbyidcardid = createD("DButton", self, 100, 40, 0, 0)
				self.sortbyidcardid:SetText("")
				function self.sortbyidcardid:Paint(pw, ph)
					-- 
				end
				function self.sortbyidcardid:DoClick()
					local lply = LocalPlayer()
					if lply.yrp_sb_sortby == "idcardid" then
						lply.ypr_sb_reverse = !lply.ypr_sb_reverse
					end
					lply.yrp_sb_sortby = "idcardid"
					YRPSortScoreboard()
				end
			end
			self.sortbyidcardid:SetSize(yrptab["idcardid"], 40)
			self.sortbyidcardid:SetPos(tx, 160 - 20)
			--draw.RoundedBox(0, tx, 160 - 10, yrptab["idcardid"], 1000, Color(255, 0, 0, 100))
			local text = string.upper(YRP.lang_string("LID_id"))
			draw.SimpleText(text, "Saira_30", tx + yrptab["idcardid"] / 2, 160, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			YRPDrawOrder(self, tx + yrptab["idcardid"] / 2, 160, text, "Saira_30", "idcardid")
			tx = tx + yrptab["idcardid"] + sp
		end
		if GetGlobalBool("bool_yrp_scoreboard_show_name", false) then
			if self.sortbyname == nil then
				self.sortbyname = createD("DButton", self, 100, 40, 0, 0)
				self.sortbyname:SetText("")
				function self.sortbyname:Paint(pw, ph)
					-- 
				end
				function self.sortbyname:DoClick()
					local lply = LocalPlayer()
					if lply.yrp_sb_sortby == "name" then
						lply.ypr_sb_reverse = !lply.ypr_sb_reverse
					end
					lply.yrp_sb_sortby = "name"
					YRPSortScoreboard()
				end
			end
			self.sortbyname:SetSize(yrptab["name"], 40)
			self.sortbyname:SetPos(tx, 160 - 20)
			--draw.RoundedBox(0, tx, 160 - 10, yrptab["name"], 1000, Color(255, 0, 0, 100))
			local text = string.upper(YRP.lang_string("LID_name"))
			draw.SimpleText(text, "Saira_30", tx + yrptab["name"] / 2, 160, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			YRPDrawOrder(self, tx + yrptab["name"] / 2, 160, text, "Saira_30", "name")
			tx = tx + yrptab["name"] + sp
		end
		if GetGlobalBool("bool_yrp_scoreboard_show_groupname", false) then
			if self.sortbyguid == nil then
				self.sortbyguid = createD("DButton", self, 100, 40, 0, 0)
				self.sortbyguid:SetText("")
				function self.sortbyguid:Paint(pw, ph)
					-- 
				end
				function self.sortbyguid:DoClick()
					local lply = LocalPlayer()
					if lply.yrp_sb_sortby == "guid" then
						lply.ypr_sb_reverse = !lply.ypr_sb_reverse
					end
					lply.yrp_sb_sortby = "guid"
					YRPSortScoreboard()
				end
			end
			self.sortbyguid:SetSize(yrptab["groupname"], 40)
			self.sortbyguid:SetPos(tx, 160 - 20)
			--draw.RoundedBox(0, tx, 160 - 10, yrptab["groupname"], 1000, Color(255, 0, 0, 100))
			local text = string.upper(YRP.lang_string("LID_group"))
			draw.SimpleText(text, "Saira_30", tx + yrptab["groupname"] / 2, 160, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			YRPDrawOrder(self, tx + yrptab["groupname"] / 2, 160, text, "Saira_30", "guid")
			tx = tx + yrptab["groupname"] + sp
		end
		if GetGlobalBool("bool_yrp_scoreboard_show_rolename", false) then
			if self.sortbyruid == nil then
				self.sortbyruid = createD("DButton", self, 100, 40, 0, 0)
				self.sortbyruid:SetText("")
				function self.sortbyruid:Paint(pw, ph)
					-- 
				end
				function self.sortbyruid:DoClick()
					local lply = LocalPlayer()
					if lply.yrp_sb_sortby == "ruid" then
						lply.ypr_sb_reverse = !lply.ypr_sb_reverse
					end
					lply.yrp_sb_sortby = "ruid"
					YRPSortScoreboard()
				end
			end
			self.sortbyruid:SetSize(yrptab["rolename"], 40)
			self.sortbyruid:SetPos(tx, 160 - 20)
			--draw.RoundedBox(0, tx, 160 - 10, yrptab["rolename"], 1000, Color(255, 0, 0, 100))
			local text = string.upper(YRP.lang_string("LID_role"))
			draw.SimpleText(text, "Saira_30", tx + yrptab["rolename"] / 2, 160, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			YRPDrawOrder(self, tx + yrptab["rolename"] / 2, 160, text, "Saira_30", "ruid")
			tx = tx + yrptab["rolename"] + sp
		end

		local pr = pw / 2 + sw / 2
		local trx = 90 + sp
		draw.SimpleText(string.upper(YRP.lang_string("LID_ping")), "Saira_30", pr - 20 - size, 160, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		if GetGlobalBool("bool_yrp_scoreboard_show_operating_system", false) then
			if self.sortbyoperating_system == nil then
				self.sortbyoperating_system = createD("DButton", self, 100, 40, 0, 0)
				self.sortbyoperating_system:SetText("")
				function self.sortbyoperating_system:Paint(pw, ph)
					-- 
				end
				function self.sortbyoperating_system:DoClick()
					local lply = LocalPlayer()
					if lply.yrp_sb_sortby == "operating_system" then
						lply.ypr_sb_reverse = !lply.ypr_sb_reverse
					end
					lply.yrp_sb_sortby = "operating_system"
					YRPSortScoreboard()
				end
			end
			self.sortbyoperating_system:SetSize(yrptab["operating_system"], 40)
			self.sortbyoperating_system:SetPos(pr - trx - yrptab["operating_system"], 160 - 20)
			--draw.RoundedBox(0, pr - trx - yrptab["operating_system"], 160 - 10, yrptab["operating_system"], 1000, Color(255, 0, 0, 100))
			local text = string.upper(YRP.lang_string("LID_os"))
			draw.SimpleText(text, "Saira_30", pr - trx - yrptab["operating_system"] / 2, 160, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			YRPDrawOrder(self, pr - trx - yrptab["operating_system"] / 2, 160, text, "Saira_30", "operating_system")
			trx = trx + yrptab["operating_system"] + sp
		end
		if GetGlobalBool("bool_yrp_scoreboard_show_language", false) then
			if self.sortbylanguage == nil then
				self.sortbylanguage = createD("DButton", self, 100, 40, 0, 0)
				self.sortbylanguage:SetText("")
				function self.sortbylanguage:Paint(pw, ph)
					-- 
				end
				function self.sortbylanguage:DoClick()
					local lply = LocalPlayer()
					if lply.yrp_sb_sortby == "language" then
						lply.ypr_sb_reverse = !lply.ypr_sb_reverse
					end
					lply.yrp_sb_sortby = "language"
					YRPSortScoreboard()
				end
			end
			self.sortbylanguage:SetSize(yrptab["language"], 40)
			self.sortbylanguage:SetPos(pr - trx - yrptab["language"], 160 - 20)
			--draw.RoundedBox(0, pr - trx - yrptab["language"], 160 - 10, yrptab["language"], 1000, Color(255, 0, 0, 100))
			local text = string.upper(YRP.lang_string("LID_language"))
			draw.SimpleText(text, "Saira_30", pr - trx - yrptab["language"] / 2, 160, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			YRPDrawOrder(self, pr - trx - yrptab["language"] / 2, 160, text, "Saira_30", "language")
			trx = trx + yrptab["language"] + sp
		end
		if GetGlobalBool("bool_yrp_scoreboard_show_usergroup", false) then
			if self.sortbyusergroup == nil then
				self.sortbyusergroup = createD("DButton", self, 100, 40, 0, 0)
				self.sortbyusergroup:SetText("")
				function self.sortbyusergroup:Paint(pw, ph)
					-- 
				end
				function self.sortbyusergroup:DoClick()
					local lply = LocalPlayer()
					if lply.yrp_sb_sortby == "usergroup" then
						lply.ypr_sb_reverse = !lply.ypr_sb_reverse
					end
					lply.yrp_sb_sortby = "usergroup"
					YRPSortScoreboard()
				end
			end
			self.sortbyusergroup:SetSize(yrptab["usergroup"], 40)
			self.sortbyusergroup:SetPos(pr - trx - yrptab["usergroup"], 160 - 20)
			--draw.RoundedBox(0, pr - trx - yrptab["usergroup"], 160 - 10, yrptab["usergroup"], 1000, Color(255, 0, 0, 100))
			local text = string.upper(YRP.lang_string("LID_rank"))
			draw.SimpleText(text, "Saira_30", pr - trx - yrptab["usergroup"] / 2, 160, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			YRPDrawOrder(self, pr - trx - yrptab["usergroup"] / 2, 160, text, "Saira_30", "usergroup")
			trx = trx + yrptab["usergroup"] + sp
		end
		draw.RoundedBox(5, pw / 2 - sw / 2, 180, sw, hr, Color(255, 255, 255, 255))



		-- Table Footer
		draw.RoundedBox(5, pw / 2 - sw / 2, ScrH() - 40, sw, hr, Color(255, 255, 255, 255))
		local server = ""
		if GAMEMODE.dedicated then
			server = " [Dedicated]"
		end
		draw.SimpleText(string.upper(YRP.lang_string("LID_map")) .. ": " .. GetNiceMapName(), 															"Saira_30", pw / 2 - sw / 2, ScrH() - 20, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		draw.SimpleText(player.GetCount() .. "/" .. game.MaxPlayers() .. " (" .. string.upper(YRP.lang_string("LID_players")) .. ")", 		"Saira_30", pw / 2 + sw / 2, ScrH() - 20, Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
		
		

		-- BOTTOM LEFT
		draw.SimpleText("v" .. YRPVersion() .. " (" .. string.upper(VERSIONART) .. ")" .. string.upper(server), "Saira_16", 6, ScrH() - 8, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	end



	YRPScoreboard.list = createD("DScrollPanel", YRPScoreboard, sw, sh - 3 * hr - hr, ScrW() / 2 - sw / 2, 180 + hr + hr)
	YRPScoreboard.list:SetPadding(0)
	function YRPScoreboard.list:Paint(pw, ph)
		--draw.RoundedBox(5, 0, 0, pw, ph, Color(255, 100, 100, 100))
	end



	YRPScoreboard:Hide()
end
YRPInitScoreboard()

function GM:ScoreboardShow()
	if GetGlobalBool("bool_yrp_scoreboard") then
		YRPOpenSBS()
	end
end

function GM:ScoreboardHide()
	YRPCloseSBS()
end

--Copyright (C) 2017-2021 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

surface.CreateFont("Saira_72", {
	font = "Saira",
	extended = true,
	size = 72,
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

local sh = ScrH() * 0.8
local sw = sh * 1.6
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

function notself(ply)
	return ply != LocalPlayer()
end

function OpenPlayerOptions(ply)
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

			if notself(ply) then
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

			if notself(ply) then
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
				if !ply:GetDBool("injail", false) then
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
				if !ply:GetDBool("ragdolled", false) then
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
				if !ply:GetDBool("godmode", false) then
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
				if !ply:GetDBool("cloaked", false) then
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
				if !ply:GetDBool("blinded", false) then
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

function CloseSBS()
	if !pa(YRPScoreboard) then return end

	YRPScoreboard:Hide()
	gui.EnableScreenClicker(false)
end

function OpenSBS()
	if !pa(YRPScoreboard) then return end

	YRPScoreboard:Show()

	-- Players
	YRPScoreboard.list:Clear()
	YRPScoreboard.plys = {}

	local plys = {}
	for i, ply in pairs(player.GetAll()) do
		local entry = {}
		entry.ply = ply
		entry.guid = ply:GetGroupUID()
		if entry.guid <= 0 then
			entry.guid = 999999
		end
		table.insert(plys, entry)
	end

	for i, entry in SortedPairsByMemberValue(plys, "guid") do
		YRPScoreboardAddPlayer(entry.ply)
	end
end

local yrptab = {}
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
		local plypnl = createD("DPanel", YRPScoreboard.list, sw, size, 0, 0)
		plypnl:Dock( TOP )
		function plypnl:Paint(pw, ph)
			draw.RoundedBox(0, avbr, avbr, avsize, avsize, Color(255, 255, 255, 255))
		end
		plypnl.infos = createD("DPanel", plypnl, sw - 13, size, 13, 0)

		function plypnl.infos:Paint(pw, ph)
			if IsValid(ply) then
				self.guid = ply:GetGroupUID()

				local x = size
				if !ply:GetDBool("yrp_characterselection", true) then
					if GetGlobalDBool("bool_yrp_scoreboard_show_level", false) then
						draw.SimpleText(ply:Level(), "Saira_24", x + yrptab["level"], ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
						x = x + yrptab["level"] + sp
					end
					if GetGlobalDBool("bool_yrp_scoreboard_show_idcardid", false) then
						draw.SimpleText(ply:IDCardID(), "Saira_24", x, ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
						x = x + yrptab["idcardid"] + sp
					end
					if GetGlobalDBool("bool_yrp_scoreboard_show_name", false) then
						draw.SimpleText(ply:RPName(), "Saira_24", x, ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
						x = x + yrptab["name"] + sp
					end
					if GetGlobalDBool("bool_yrp_scoreboard_show_groupname", false) then
						draw.SimpleText(ply:GetGroupName(), "Saira_24", x, ph / 2, ply:GetGroupColor(), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
						x = x + yrptab["groupname"] + sp
					end
					if GetGlobalDBool("bool_yrp_scoreboard_show_rolename", false) then
						draw.SimpleText(ply:GetRoleName(), "Saira_24", x, ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
						x = x + yrptab["rolename"] + sp
					end
				elseif ply:IsBot() then
					draw.SimpleText("[" .. ply:RPName() .. "]", "Saira_24", x, ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
				elseif ply:GetDBool("yrp_characterselection", true) then
					draw.SimpleText("[" .. YRP.lang_string("LID_characterselection") .. "]", "Saira_24", x, ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
				else
					draw.SimpleText("[" .. "FAIL" .. "]", "Saira_24", x, ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
				end
				



				local trx = 90 + size
				draw.SimpleText(ply:Ping(), "Saira_24", pw - 20 - size, ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
				if self.Mute and (self.Muted == nil or self.Muted != ply:IsMuted()) then
					self.Muted = ply:IsMuted()
					if ( self.Muted ) then
						self.Mute:SetImage( "icon32/muted.png" )
					else
						self.Mute:SetImage( "icon32/unmuted.png" )
					end
		
					self.Mute.DoClick = function( s ) ply:SetMuted( !self.Muted ) end
					self.Mute.OnMouseWheeled = function( s, delta )
						ply:SetVoiceVolumeScale( ply:GetVoiceVolumeScale() + ( delta / 100 * 5 ) )
						s.LastTick = CurTime()
					end
		
					self.Mute.PaintOver = function( s, w, h )
						if s:IsHovered() then
							s.LastTick = CurTime()
						end
						local a = 255 - math.Clamp( CurTime() - ( s.LastTick or 0 ), 0, 3 ) * 255
						draw.RoundedBox( 4, 0, 0, w, h, Color( 0, 0, 0, a * 0.75 ) )
						draw.SimpleText( math.ceil( ply:GetVoiceVolumeScale() * 100 ) .. "%", "DermaDefaultBold", w / 2, h / 2, Color( 255, 255, 255, a ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
					end
				end
				if GetGlobalDBool("bool_yrp_scoreboard_show_operating_system", false) then
					--draw.SimpleText(string.upper(ply:GetDString("yrp_os", "")), "Saira_24", pw - trx, ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
					self.lang = YRP.GetDesignIcon("os_" .. ply:GetDString("yrp_os", ""))
					if self.lang ~= nil then
						local sh = size * 0.8
						YRP.DrawIcon(self.lang, sh, sh, pw - trx - sh, size / 2 - sh / 2, Color(255, 255, 255, 255))
					end
					trx = trx + yrptab["operating_system"] + sp
				end
				if GetGlobalDBool("bool_yrp_scoreboard_show_language", false) then
					--draw.SimpleText(string.upper(ply:YRPGetLanguage()), "Saira_24", pw - trx, ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
					self.lang = YRP.GetDesignIcon("lang_" .. ply:GetLanguageShort())
					if self.lang ~= nil then
						local sh = size * 0.8
						YRP.DrawIcon(self.lang, sh * 1.49, sh, pw - trx - sh * 1.49, size / 2 - sh / 2, Color(255, 255, 255, 255))
					end
					trx = trx + yrptab["language"] + sp
				end
				if GetGlobalDBool("bool_yrp_scoreboard_show_usergroup", false) then
					draw.SimpleText(string.upper(ply:GetUserGroup()), "Saira_24", pw - trx, ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
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
			--
		end
		function plypnl.btn:DoRightClick()
			OpenPlayerOptions(ply)
		end

		plypnl.infos.Mute = createD("DImageButton", plypnl, size, size, 0, 0)
		plypnl.infos.Mute:Dock( RIGHT )

		YRPScoreboard.list:AddItem(plypnl)
	end
end

local matBlurScreen = Material( "pp/blurscreen" )
function YRPBlurScoreboard(panel)
	local x, y = panel:LocalToScreen( 0, 0 )

	local wasEnabled = DisableClipping( true )

	-- Menu cannot do blur
	if ( !MENU_DLL ) then
		surface.SetMaterial( matBlurScreen )
		surface.SetDrawColor( 255, 255, 255, 255 )

		for i=0.33, 1, 0.33 do
			matBlurScreen:SetFloat( "$blur", 10 * i )
			matBlurScreen:Recompute()
			if ( render ) then render.UpdateScreenEffectTexture() end -- Todo: Make this available to menu Lua
			surface.DrawTexturedRect( x * -1, y * -1, ScrW(), ScrH() )
		end
	end

	surface.SetDrawColor( 0, 0, 0, 240 )
	surface.DrawRect( x * -1, y * -1, ScrW(), ScrH() )

	DisableClipping( wasEnabled )
end

local ypr_logo = Material("yrp/yrp_icon")

function InitScoreboard()
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
		YRPBlurScoreboard(self)
		
		if self.amount != table.Count(player.GetAll()) then
			self.amount = table.Count(player.GetAll())
			OpenSBS()
		end

		if self.logo then
			if self.logo.svlogo != GetGlobalDString("text_server_logo", "") then
				self.logo.svlogo = GetGlobalDString("text_server_logo", "")

				if !strEmpty(GetGlobalDString("text_server_logo", "")) then
					YRPScoreboard.logo:SetHTML(GetHTMLImage(GetGlobalDString("text_server_logo", ""), 128, 128))
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

		if LocalPlayer():KeyDown(IN_ATTACK2) and self.delay < CurTime() then
			self.delay = CurTime() + 0.5
			gui.EnableScreenClicker(true)
		end

		-- NAME
		local name = GetGlobalDString("text_server_name", "")
		if strEmpty(name) then
			name = GetHostName()
		end
		draw.SimpleText(name, "Saira_72", pw / 2, 80, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)



		
		yrptab["level"] = 24
		yrptab["idcardid"] = 140
		if !GetGlobalDBool("bool_yrp_scoreboard_show_level", false) and !GetGlobalDBool("bool_yrp_scoreboard_show_idcardid", false) then
			yrptab["name"] = 260
		else
			yrptab["name"] = 160
		end
		yrptab["groupname"] = 220
		if !GetGlobalDBool("bool_yrp_scoreboard_show_groupname", false) then
			yrptab["rolename"] = 360
		else
			yrptab["rolename"] = 220
		end
		yrptab["usergroup"] = 200
		yrptab["language"] = 140
		yrptab["operating_system"] = 60



		-- Table Header
		local tx = ScrW() / 2 - sw / 2 + size + 13
		if GetGlobalDBool("bool_yrp_scoreboard_show_level", false) then
			draw.SimpleText(string.sub(string.upper(YRP.lang_string("LID_level")), 1, 2) .. ".", "Saira_30", tx + yrptab["level"], 160, Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
			tx = tx + yrptab["level"] + sp
		end
		if GetGlobalDBool("bool_yrp_scoreboard_show_idcardid", false) then
			draw.SimpleText(string.upper(YRP.lang_string("LID_id")), "Saira_30", tx, 160, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			tx = tx + yrptab["idcardid"] + sp
		end
		if GetGlobalDBool("bool_yrp_scoreboard_show_name", false) then
			draw.SimpleText(string.upper(YRP.lang_string("LID_name")), "Saira_30", tx, 160, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			tx = tx + yrptab["name"] + sp
		end
		if GetGlobalDBool("bool_yrp_scoreboard_show_groupname", false) then
			draw.SimpleText(string.upper(YRP.lang_string("LID_group")), "Saira_30", tx, 160, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			tx = tx + yrptab["groupname"] + sp
		end
		if GetGlobalDBool("bool_yrp_scoreboard_show_rolename", false) then
			draw.SimpleText(string.upper(YRP.lang_string("LID_role")), "Saira_30", tx, 160, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			tx = tx + yrptab["rolename"] + sp
		end

		local pr = pw / 2 + sw / 2
		local trx = 90 + size
		draw.SimpleText(string.upper(YRP.lang_string("LID_ping")), "Saira_30", pr - 20 - size, 160, Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
		if GetGlobalDBool("bool_yrp_scoreboard_show_operating_system", false) then
			draw.SimpleText(string.upper(YRP.lang_string("LID_os")), "Saira_30", pr - trx, 160, Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
			trx = trx + yrptab["operating_system"] + sp
		end
		if GetGlobalDBool("bool_yrp_scoreboard_show_language", false) then
			draw.SimpleText(string.upper(YRP.lang_string("LID_language")), "Saira_30", pr - trx, 160, Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
			trx = trx + yrptab["language"] + sp
		end
		if GetGlobalDBool("bool_yrp_scoreboard_show_usergroup", false) then
			draw.SimpleText(string.upper(YRP.lang_string("LID_usergroup")), "Saira_30", pr - trx, 160, Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
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
		draw.SimpleText("YourRP - " .."v" .. YRPVersion() .. " (" .. string.upper(VERSIONART) .. ")" .. string.upper(server), 																											"Saira_30", pw / 2, ScrH() - 20, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		draw.SimpleText(table.Count(player.GetAll()) .. "/" .. game.MaxPlayers() .. " (" .. string.upper(YRP.lang_string("LID_players")) .. ")", 		"Saira_30", pw / 2 + sw / 2, ScrH() - 20, Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
	end



	YRPScoreboard.list = createD("DScrollPanel", YRPScoreboard, sw, sh - 3 * hr - hr, ScrW() / 2 - sw / 2, 180 + hr + hr)
	YRPScoreboard.list:SetPadding(0)
	function YRPScoreboard.list:Paint(pw, ph)
		--draw.RoundedBox(5, 0, 0, pw, ph, Color(255, 100, 100, 100))
	end



	YRPScoreboard.hide = createD("YButton", YRPScoreboard, 200, 40, ScrW() - 200 - 10, 10)
	YRPScoreboard.hide:SetText("LID_hide")
	function YRPScoreboard.hide:Paint(pw, ph)
		if vgui.CursorVisible() then
			hook.Run("YButtonPaint", self, pw, ph)
		end
	end
	function YRPScoreboard.hide:DoClick()
		if vgui.CursorVisible() then
			CloseSBS()
		end
	end



	YRPScoreboard:Hide()
end
InitScoreboard()

function GM:ScoreboardShow()
	OpenSBS()
end

function GM:ScoreboardHide()
	if !vgui.CursorVisible() then
		CloseSBS()
	end
end

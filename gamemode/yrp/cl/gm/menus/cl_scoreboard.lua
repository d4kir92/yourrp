--Copyright (C) 2017-2019 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

-- #SCOREBOARD

-- CONFIG
local scolen = {}
scolen["leve"] = 160
scolen["idca"] = 340
scolen["name"] = 480
scolen["role"] = 480
scolen["frag"] = 200
scolen["lang"] = 200
scolen["coun"] = 200
scolen["oper"] = 200
scolen["play"] = 160
scolen["ping"] = 120
-- CONFIG

local elePos = {}
elePos.x = 0
elePos.y = 0

local mc = {}

local sbs = {}
sbs.icons = {}
sbs.icons.yrp = Material("yrp/yrp_icon")

isScoreboardOpen = false
function SetIsScoreboardOpen(bo)
	isScoreboardOpen = bo
	if bo and sbs.frame != nil then
		sbs.frame:Show()
	else
		sbs.frame:Hide()
	end
end

function IsScoreboardOpen()
	return isScoreboardOpen
end

function notself(ply)
	if LocalPlayer() != ply then
		return true
	end
	return false
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
	SetIsScoreboardOpen(false)
	if pa(sbs.frame) then
		gui.EnableScreenClicker(false)
		--sbs.frame:Remove()
		--sbs.frame = nil
	end
end

local fac = fac or 1
function OpenSBS()
	if pa(sbs.frame) == false then
		sbs.frame = createD("DFrame", nil, BFW(), BFH(), 0, 0)
		sbs.frame:Center()
		sbs.frame:SetDraggable(false)
		sbs.frame:ShowCloseButton(false)
		sbs.frame:SetTitle("")
		--sbs.frame:MakePopup()
		function sbs.frame.btnClose:DoClick()
			CloseSBS()
		end

		local _mapPNG = getMapPNG()

		local _server_logo = GetGlobalDString("text_server_logo", "")
		text_server_logo = GetHTMLImage(GetGlobalDString("text_server_logo", ""), YRP.ctr(256), YRP.ctr(256))

		sbs.frame.tick = CurTime()
		function sbs.frame:Paint(pw, ph)
			if self.tick < CurTime() then
				if input.IsMouseDown(MOUSE_RIGHT) or input.IsMouseDown(MOUSE_MIDDLE) then
					gui.EnableScreenClicker(!vgui.CursorVisible())
					self.tick = CurTime() + 0.4
				end
			end
			if vgui.CursorVisible() then
				self:ShowCloseButton(true)
			else
				self:ShowCloseButton(false)
			end

			draw.RoundedBox(0, 0, 0, pw, ph, Color(20, 20, 20, 250)) -- Background

			if strEmpty(_server_logo) then
				draw.RoundedBox(0, YRP.ctr(256), YRP.ctr(128-50), pw - YRP.ctr(512), YRP.ctr(100), Color(100, 100, 255, 100)) -- Stripe
			else
				draw.RoundedBox(0, YRP.ctr(256) / 2, YRP.ctr(128-50), pw - YRP.ctr(512) / 2, YRP.ctr(100), Color(100, 100, 255, 100)) -- Stripe
			end

			draw.SimpleTextOutlined(GAMEMODE:GetGameDescription() .. " [" .. GetRPBase() .. "]", "ScoreBoardNormal", YRP.ctr(256 + 20), YRP.ctr(128-20), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
			draw.SimpleTextOutlined(GetHostName(), "ScoreBoardTitle", YRP.ctr(256 + 20), YRP.ctr(128 + 20), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))

			draw.SimpleTextOutlined(YRP.lang_string("LID_map") .. ": " .. GetNiceMapName(), "ScoreBoardNormal", pw - YRP.ctr(256 + 20), YRP.ctr(128-20), Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
			draw.SimpleTextOutlined(YRP.lang_string("LID_players") .. ": " .. #player.GetAll() .. "/" .. game.MaxPlayers(), "ScoreBoardNormal", pw - YRP.ctr(256 + 20), YRP.ctr(128 + 20), Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))

			if strEmpty(_server_logo) then
				surface.SetDrawColor(255, 255, 255, 255)
				surface.SetMaterial(sbs.icons.yrp)
				surface.DrawTexturedRect(YRP.ctr(4), YRP.ctr(4), YRP.ctr(256), YRP.ctr(256))
			end

			if _mapPNG != false then
				draw.RoundedBox(0, pw - YRP.ctr(256 + 8), 0, YRP.ctr(256 + 8), YRP.ctr(256 + 8), Color(0, 0, 0, 255))

				surface.SetDrawColor(255, 255, 255, 255)
				surface.SetMaterial(_mapPNG)
				surface.DrawTexturedRect(pw - YRP.ctr(256 + 4), YRP.ctr(4), YRP.ctr(256), YRP.ctr(256))
			else
				if strEmpty(_server_logo) then
					surface.SetDrawColor(255, 255, 255, 255)
					surface.SetMaterial(sbs.icons.yrp	)
					surface.DrawTexturedRect(pw - YRP.ctr(256 + 4), YRP.ctr(4), YRP.ctr(256), YRP.ctr(256))
				end
			end
		end

		if !strEmpty(_server_logo) then
			local ServerLogo = createD("DHTML", sbs.frame, YRP.ctr(256), YRP.ctr(256), YRP.ctr(4), YRP.ctr(4))
			ServerLogo:SetHTML(text_server_logo)
			--TestHTML(ServerLogo, text_server_logo, false)
			if _mapPNG == false then
				local ServerLogo2 = createD("DHTML", sbs.frame, YRP.ctr(256), YRP.ctr(256), sbs.frame:GetWide() - YRP.ctr(256 + 4), YRP.ctr(4))
				ServerLogo2:SetHTML(text_server_logo)
				--TestHTML(ServerLogo2, text_server_logo, false)
			end
		end

		sbs.header = createD("DPanel", sbs.frame, BFW(), YRP.ctr(64), 0, YRP.ctr(256 + 10))
		local act = {}
		function sbs.header:Paint(pw, ph)
			local t = 0
			for i, v in pairs(act) do
				if v then
					t = t + 1
				end
			end

			fac = 1 + (4 / t * (1 - t / table.Count(scolen)))

			draw.RoundedBox(0, 0, 0, pw, ph, Color(0, 0, 0, 100))

			local br = 40
			local x = 128 + 10

			if IsLevelSystemEnabled() and GetGlobalDBool("bool_yrp_scoreboard_show_level", false) then
				draw.SimpleTextOutlined(YRP.lang_string("LID_level"), "sef", YRP.ctr(x), ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
				x = x + scolen["leve"]
				act["leve"] = true
			else
				act["leve"] = false
			end

			if GetGlobalDBool("bool_yrp_scoreboard_show_idcardid", false) then
				draw.SimpleTextOutlined(YRP.lang_string("LID_idcardid"), "sef", YRP.ctr(x), ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
				x = x + scolen["idca"]
				act["idca"] = true
			else
				act["idca"] = false
			end

			local naugname = YRP.lang_string("LID_name") .. "/" .. YRP.lang_string("LID_usergroup")
			if !GetGlobalDBool("bool_yrp_scoreboard_show_usergroup", false) then
				naugname = YRP.lang_string("LID_name")
			end
			draw.SimpleTextOutlined(naugname, "sef", YRP.ctr(x * fac), ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
			x = x + scolen["name"]
			act["name"] = true

			if GetGlobalDBool("bool_yrp_scoreboard_show_rolename", false) or GetGlobalDBool("bool_yrp_scoreboard_show_groupname", false) then
				local rgname = YRP.lang_string("LID_role") .. "/" .. YRP.lang_string("LID_group")
				if !GetGlobalDBool("bool_yrp_scoreboard_show_rolename", false) then
					rgname = YRP.lang_string("LID_group")
				elseif !GetGlobalDBool("bool_yrp_scoreboard_show_groupname", false) then
					rgname = YRP.lang_string("LID_role")
				end
				draw.SimpleTextOutlined(rgname, "sef", YRP.ctr(x * fac), ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
				x = x + scolen["role"]
				act["role"] = true
			else
				act["role"] = false
			end

			x = br
			draw.SimpleTextOutlined(YRP.lang_string("LID_ping"), "sef", pw - YRP.ctr(x), ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
			x = x + scolen["ping"]
			act["ping"] = true

			if GetGlobalDBool("bool_yrp_scoreboard_show_operating_system", false) then
				draw.SimpleTextOutlined(YRP.lang_string("LID_os"), "sef", pw - YRP.ctr(x * fac), ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
				x = x + scolen["oper"]
				act["oper"] = true
			else
				act["oper"] = false
			end

			if GetGlobalDBool("bool_yrp_scoreboard_show_playtime", false) then
				draw.SimpleTextOutlined(YRP.lang_string("LID_playtime"), "sef", pw - YRP.ctr(x * fac), ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
				x = x + scolen["play"]
				act["play"] = true
			else
				act["play"] = false
			end

			if GetGlobalDBool("bool_yrp_scoreboard_show_country", false) then
				draw.SimpleTextOutlined(YRP.lang_string("LID_country"), "sef", pw - YRP.ctr(x * fac), ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
				x = x + scolen["coun"]
				act["coun"] = true
			else
				act["coun"] = false
			end

			if GetGlobalDBool("bool_yrp_scoreboard_show_language", false) then
				draw.SimpleTextOutlined(YRP.lang_string("LID_language"), "sef", pw - YRP.ctr(x * fac), ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
				x = x + scolen["lang"]
				act["lang"] = true
			else
				act["lang"] = false
			end

			if GetGlobalDBool("bool_yrp_scoreboard_show_frags", false) or GetGlobalDBool("bool_yrp_scoreboard_show_deaths", false) then
				local fdname = string.sub(YRP.lang_string("LID_frags"), 1, 4) .. "/" .. string.sub(YRP.lang_string("LID_deaths"), 1, 4)
				if !GetGlobalDBool("bool_yrp_scoreboard_show_frags", false) then
					fdname = YRP.lang_string("LID_deaths")
				elseif !GetGlobalDBool("bool_yrp_scoreboard_show_deaths", false) then
					fdname = YRP.lang_string("LID_frags")
				end
				draw.SimpleTextOutlined(fdname, "sef", pw - YRP.ctr(x * fac), ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
				x = x + scolen["frag"]
				act["frag"] = true
			else
				act["frag"] = false
			end
		end

		sbs.stab = createD("DPanelList", sbs.frame, BFW(), BFH() - YRP.ctr(256 + 10 + 64), 0, YRP.ctr(256 + 10 + 64))
		sbs.stab:EnableVerticalScrollbar(true)
	end

	sbs.stab:Clear()

	local rplys = {}
	local uplys = {}
	for i, pl in SortedPairsByMemberValue(player.GetAll(), GetFactionUniqueID) do
		pl["group"] = pl:GetGroupName()
		if pl:GetGroupName() != "NO GROUP SELECTED" then
			table.insert(rplys, pl)
		else
			table.insert(uplys, pl)
		end
	end

	for i, pl in SortedPairsByMemberValue(rplys, "group") do
		if pl.sbp == nil then
			pl.sbp = createD("DButton", sbs.stab, BFW(), YRP.ctr(128), 0, 0)
			pl.sbp.pl = pl
			pl.sbp:SetText("")
			function pl.sbp:DoClick()
				OpenPlayerOptions(pl)
			end

			if strUrl(pl:GetDString("roleIcon", "")) then
				pl.sbp.ricon = createD("DHTML", pl.sbp, YRP.ctr(60), YRP.ctr(60), 0, 0)
				TestHTML(pl.sbp.ricon, pl:GetDString("roleIcon", ""), false)
			elseif pa(pl.sbp.ricon) then
				pl.sbp.ricon:Remove()
			end
			if strUrl(pl:GetDString("groupIcon", "")) then
				pl.sbp.gicon = createD("DHTML", pl.sbp, YRP.ctr(60), YRP.ctr(60), 0, 0)
				TestHTML(pl.sbp.gicon, pl:GetDString("groupIcon", ""), false)
			elseif pa(pl.sbp.gicon) then
				pl.sbp.gicon:Remove()
			end

			function pl.sbp:Paint(pw, ph)
				if !self.pl:IsValid() then
					self:Remove()
				else
					pl.sbp.col = i % 2 * 100
					pl.sbp.color = pl:GetGroupColor()
					if pl.sbp.color.r >= 240 then
						pl.sbp.color = Color(pl.sbp.color.r - 20, pl.sbp.color.g - 20, pl.sbp.color.b - 20, 100)
					else
						pl.sbp.color = Color(pl.sbp.color.r + 20, pl.sbp.color.g + 20, pl.sbp.color.b + 20, 100)
					end

					pl.sbp.pt = string.FormattedTime(pl:GetDFloat("uptime_current", 0))
					if pl.sbp.pt.m < 10 then
						pl.sbp.pt.m = "0" .. pl.sbp.pt.m
					end
					if pl.sbp.pt.h < 10 then
						pl.sbp.pt.h = "0" .. pl.sbp.pt.h
					end
					pl.sbp.playtime = pl.sbp.pt.h .. ":" .. pl.sbp.pt.m
					pl.sbp.os = pl:GetDString("yrp_os", "other")
					pl.sbp.lang = pl:GetLanguageShort()

					local country = pl:GetCountry()
					pl.sbp.country = country
					local countryshort = pl:GetCountryShort()
					pl.sbp.cc = string.lower(countryshort)
					if tostring(YRP.GetDesignIcon("flag_" .. pl.sbp.cc)) == "Material [vgui/material/icon_clear]" and mc[pl.sbp.cc] == nil and string.upper(pl.sbp.cc) != "LOADING" and YRP.AllIconsLoaded() then
						mc[pl.sbp.cc] = true
						YRP.msg("mis", "Missing Country: " .. string.upper(pl.sbp.cc))
					end

					self.bg = self.color
					if self:IsHovered() then
						self.bg = Color(255, 255, 0, 255)
					end
					draw.RoundedBox(ph / 2, 0, 0, pw + ph / 2, ph, self.bg)

					local br = 40
					local x = 128 + 10

					if IsLevelSystemEnabled() and GetGlobalDBool("bool_yrp_scoreboard_show_level", false) then
						draw.SimpleTextOutlined(pl:Level(), "sef", YRP.ctr(x), ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
						x = x + scolen["leve"]
					end

					if GetGlobalDBool("bool_yrp_scoreboard_show_idcardid", false) then
						draw.SimpleTextOutlined(pl:GetDString("idcardid", "X"), "sef", YRP.ctr(x), ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
						x = x + scolen["idca"]
					end

					local nay = ph / 4 * 1
					local ugy = ph / 4 * 3
					if !GetGlobalDBool("bool_yrp_scoreboard_show_usergroup", false) then
						nay = ph / 2
					end
					draw.SimpleTextOutlined(pl:RPName(), "sef", YRP.ctr(x * fac), nay, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
					if GetGlobalDBool("bool_yrp_scoreboard_show_usergroup", false) then
						draw.SimpleTextOutlined(string.upper(pl:GetUserGroup()), "sef", YRP.ctr(x * fac), ugy, pl:GetUserGroupColor(), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
					end
					x = x + scolen["name"]
					if GetGlobalDBool("bool_yrp_scoreboard_show_rolename", false) or GetGlobalDBool("bool_yrp_scoreboard_show_groupname", false) then
						local ry = ph / 4 * 1
						local gy = ph / 4 * 3
						if !GetGlobalDBool("bool_yrp_scoreboard_show_rolename", false) then
							gy = ph / 2
						elseif !GetGlobalDBool("bool_yrp_scoreboard_show_groupname", false) then
							ry = ph / 2
						end
						if GetGlobalDBool("bool_yrp_scoreboard_show_rolename", false) then
							self.rolicon = self.rolicon or ""
							if pa(pl.sbp.ricon) then
								if self.rolicon != pl:GetDString("roleIcon", "") then
									self.rolicon = pl:GetDString("roleIcon", "")
									local text_ricon = GetHTMLImage(self.rolicon, YRP.ctr(60), YRP.ctr(60))
									pl.sbp.ricon:SetHTML(text_ricon)
								elseif pa(pl.sbp.ricon) then
									if !strUrl(pl:GetDString("roleIcon", "")) then
										pl.sbp.ricon:Remove()
									else
										pl.sbp.ricon:SetPos(YRP.ctr(x * fac + 2), ry - YRP.ctr(30))
									end
								end
							end
							local iconx = 0
							if strUrl(pl:GetDString("roleIcon", "")) then
								iconx = 64
							end
							draw.SimpleTextOutlined(pl:GetRoleName(), "sef", YRP.ctr(x * fac + iconx + 10), ry, pl:GetRoleColor(), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
						end
						if GetGlobalDBool("bool_yrp_scoreboard_show_groupname", false) then
							self.grpicon = self.grpicon or ""
							if pl.sbp.gicon != nil then
								if self.grpicon != pl:GetDString("groupIcon", "") then
									self.grpicon = pl:GetDString("groupIcon", "")
									local text_gicon = GetHTMLImage(self.grpicon, YRP.ctr(60), YRP.ctr(60))
									pl.sbp.gicon:SetHTML(text_gicon)
								elseif pa(pl.sbp.gicon) then
									if !strUrl(pl:GetDString("groupIcon", "")) then
										pl.sbp.gicon:Remove()
									else
										pl.sbp.gicon:SetPos(YRP.ctr(x * fac + 2), gy - YRP.ctr(30))
									end
								end
							end

							local grpname = pl:GetGroupName()
							if pl:GetFactionName() != pl:GetGroupName() then
								grpname = "[" .. pl:GetFactionName() .. "] " .. grpname
							end
							local iconx = 0
							if strUrl(pl:GetDString("groupIcon", "")) then
								iconx = 64
							end
							draw.SimpleTextOutlined(grpname, "sef", YRP.ctr(x * fac + iconx + 10), gy, pl:GetGroupColor(), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
						end
						x = x + scolen["role"]
					end

					x = br

					local ping = pl:Ping()
					local ping_color = Color(255, 0, 0, 255)
					if ping < 100 then
						ping_color = Color(0, 255, 0, 255)
					elseif ping >= 100 and ping < 200 then
						ping_color = Color(255, 255, 0, 255)
					end
					draw.SimpleTextOutlined(ping, "sef", pw - YRP.ctr(x), ph / 2, ping_color, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
					x = x + scolen["ping"]

					if GetGlobalDBool("bool_yrp_scoreboard_show_operating_system", false) then
						local icon_size = YRP.ctr(100)
						YRP.DrawIcon(YRP.GetDesignIcon("os_" .. self.os), icon_size, icon_size, pw - YRP.ctr(x * fac) - icon_size, (ph - icon_size) / 2, Color(255, 255, 255, 255))
						if self:IsHovered() then
							draw.SimpleTextOutlined(string.upper(self.os), "sef", pw - YRP.ctr(x * fac), ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
						end
						x = x + scolen["oper"]
					end

					if GetGlobalDBool("bool_yrp_scoreboard_show_playtime", false) then
						draw.SimpleTextOutlined(self.playtime, "sef", pw - YRP.ctr(x * fac), ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
						x = x + scolen["play"]
					end

					if GetGlobalDBool("bool_yrp_scoreboard_show_country", false) then
						local icon_size = YRP.ctr(100)
						local icon_wide = icon_size * 1.49
						YRP.DrawIcon(YRP.GetDesignIcon("flag_" .. self.cc), icon_size * 1.49, icon_size, pw - YRP.ctr(x * fac) - icon_wide, ph / 2 - icon_size / 2, Color(255, 255, 255, 255))
						if self:IsHovered() then
							draw.SimpleTextOutlined(string.upper(self.cc), "sef", pw - YRP.ctr(x * fac) - icon_wide / 2, ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
						end
						x = x + scolen["coun"]
					end

					if GetGlobalDBool("bool_yrp_scoreboard_show_language", false) then
						local icon_size = YRP.ctr(100)
						local icon_wide = icon_size * 1.49
						YRP.DrawIcon(YRP.GetDesignIcon("lang_" .. self.lang), icon_size * 1.49, icon_size, pw - YRP.ctr(x * fac) - icon_wide, ph / 2 - icon_size / 2, Color(255, 255, 255, 255))
						if self:IsHovered() then
							draw.SimpleTextOutlined(string.upper(self.lang), "sef", pw - YRP.ctr(x * fac) - icon_wide / 2, ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
						end
						x = x + scolen["lang"]
					end

					if GetGlobalDBool("bool_yrp_scoreboard_show_frags", false) or GetGlobalDBool("bool_yrp_scoreboard_show_deaths", false) then
						local fy = ph / 4 * 1
						local dy = ph / 4 * 3
						if !GetGlobalDBool("bool_yrp_scoreboard_show_frags", false) then
							dy = ph / 2
						elseif !GetGlobalDBool("bool_yrp_scoreboard_show_deaths", false) then
							fy = ph / 2
						end
						if GetGlobalDBool("bool_yrp_scoreboard_show_frags", false) then
							draw.SimpleTextOutlined(pl:Frags(), "sef", pw - YRP.ctr(x * fac), fy, Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
						end
						if GetGlobalDBool("bool_yrp_scoreboard_show_deaths", false) then
							draw.SimpleTextOutlined(pl:Deaths(), "sef", pw - YRP.ctr(x * fac), dy, Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
						end
						x = x + scolen["frag"]
					end
				end
			end

			pl.sbp.avap = createD("DPanel", pl.sbp, YRP.ctr(128-8), YRP.ctr(128-8), YRP.ctr(4), YRP.ctr(4))
			pl.sbp.avap.Avatar = createD("AvatarImage", pl.sbp.avap, YRP.ctr(128-8), YRP.ctr(128-8), 0, 0)
			pl.sbp.avap.Avatar:SetPlayer(pl, YRP.ctr(128-8))
			pl.sbp.avap.Avatar:SetPaintedManually(true)
			function pl.sbp.avap:Paint(pw, ph)
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

					self.Avatar:SetPaintedManually(false)
					self.Avatar:PaintManual()
					self.Avatar:SetPaintedManually(true)

				render.SetStencilEnable(false)
			end
		end
		sbs.stab:AddItem(pl.sbp)
	end

	if #uplys > 0 then
		sbs.hr = createD("DPanel", sbs.frame, BFW(), YRP.ctr(64), 0, YRP.ctr(256 + 10))
		function sbs.hr:Paint(pw, ph)
		end
		sbs.stab:AddItem(sbs.hr)

		sbs.charsel = createD("DPanel", sbs.frame, BFW(), YRP.ctr(64), 0, YRP.ctr(256 + 10))
		function sbs.charsel:Paint(pw, ph)
			draw.RoundedBox(0, 0, 0, pw, ph, Color(0, 0, 0, 100))

			local x = 128 + 10
			draw.SimpleTextOutlined(YRP.lang_string("LID_characterselection"), "sef", YRP.ctr(x * fac), ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
		end
		sbs.stab:AddItem(sbs.charsel)

		sbs.header2 = createD("DPanel", sbs.frame, BFW(), YRP.ctr(64), 0, YRP.ctr(256 + 10))
		function sbs.header2:Paint(pw, ph)
			draw.RoundedBox(0, 0, 0, pw, ph, Color(0, 0, 0, 100))

			local x = 128 + 10

			if IsLevelSystemEnabled() and GetGlobalDBool("bool_yrp_scoreboard_show_level", false) then
				x = x + scolen["leve"]
			end

			local idcardid = YRP.lang_string("LID_idcardid")
			draw.SimpleTextOutlined(idcardid, "sef", YRP.ctr(x * fac), ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
			x = x + scolen["idca"]

			if GetGlobalDBool("bool_yrp_scoreboard_show_idcardid", false) or GetGlobalDBool("bool_yrp_scoreboard_show_groupname", false) then
				x = x + scolen["idca"]
			end

			local naugname = YRP.lang_string("LID_name")
			draw.SimpleTextOutlined(naugname, "sef", YRP.ctr(x * fac), ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
			x = x + scolen["name"]

			if GetGlobalDBool("bool_yrp_scoreboard_show_rolename", false) or GetGlobalDBool("bool_yrp_scoreboard_show_groupname", false) then
				x = x + scolen["role"]
			end

			if GetGlobalDBool("bool_yrp_scoreboard_show_frags", false) or GetGlobalDBool("bool_yrp_scoreboard_show_deaths", false) then
				x = x + scolen["frag"]
			end

			local br = 40
			x = br
			draw.SimpleTextOutlined(YRP.lang_string("LID_ping"), "sef", pw - YRP.ctr(x), ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
			x = x + scolen["ping"]

			if GetGlobalDBool("bool_yrp_scoreboard_show_operating_system", false) then
				draw.SimpleTextOutlined(YRP.lang_string("LID_os"), "sef", pw - YRP.ctr(x * fac), ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
				x = x + scolen["oper"]
			end

			if GetGlobalDBool("bool_yrp_scoreboard_show_playtime", false) then
				draw.SimpleTextOutlined(YRP.lang_string("LID_playtime"), "sef", pw - YRP.ctr(x * fac), ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
				x = x + scolen["play"]
			end

			if GetGlobalDBool("bool_yrp_scoreboard_show_country", false) then
				draw.SimpleTextOutlined(YRP.lang_string("LID_country"), "sef", pw - YRP.ctr(x * fac), ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
				x = x + scolen["coun"]
			end

			if GetGlobalDBool("bool_yrp_scoreboard_show_language", false) then
				draw.SimpleTextOutlined(YRP.lang_string("LID_language"), "sef", pw - YRP.ctr(x * fac), ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
				x = x + scolen["lang"]
			end
		end
		sbs.stab:AddItem(sbs.header2)

		for i, pl in SortedPairsByMemberValue(uplys, "group") do
			if pl.usbp == nil then
				pl.usbp = createD("DButton", sbs.stab, BFW(), YRP.ctr(128), 0, 0)
				pl.usbp:SetText("")
				function pl.usbp:DoClick()
					OpenPlayerOptions(pl)
				end

				function pl.usbp:Paint(pw, ph)
					if !pl:IsValid() then
						self:Remove()
					else
						pl.usbp.col = i % 2 * 100
						pl.usbp.color = Color(255, 255, 255, 255)
						if pl.usbp.color.r >= 240 then
							pl.usbp.color = Color(pl.usbp.color.r - 20, pl.usbp.color.g - 20, pl.usbp.color.b - 20, 100)
						else
							pl.usbp.color = Color(pl.usbp.color.r + 20, pl.usbp.color.g + 20, pl.usbp.color.b + 20, 100)
						end

						pl.usbp.pt = string.FormattedTime(pl:GetDFloat("uptime_current", 0))
						if pl.usbp.pt.m < 10 then
							pl.usbp.pt.m = "0" .. pl.usbp.pt.m
						end
						if pl.usbp.pt.h < 10 then
							pl.usbp.pt.h = "0" .. pl.usbp.pt.h
						end
						pl.usbp.playtime = pl.usbp.pt.h .. ":" .. pl.usbp.pt.m
						pl.usbp.os = pl:GetDString("yrp_os", "other")
						pl.usbp.lang = pl:GetLanguageShort()

						local country = pl:GetCountry()
						pl.usbp.country = country
						local countryshort = pl:GetCountryShort()
						pl.usbp.cc = string.lower(countryshort)
						if tostring(YRP.GetDesignIcon("flag_" .. pl.usbp.cc)) == "Material [vgui/material/icon_clear]" and mc[pl.usbp.cc] == nil and string.upper(pl.usbp.cc) != "LOADING" and YRP.AllIconsLoaded() then
							mc[pl.usbp.cc] = true
							YRP.msg("mis", "Missing Country: " .. string.upper(pl.usbp.cc))
						end
	
						self.bg = self.color
						if self:IsHovered() then
							self.bg = Color(255, 255, 0, 255)
						end
						draw.RoundedBox(ph / 2, 0, 0, pw + ph / 2, ph, self.bg)

						local x = 128 + 10

						if IsLevelSystemEnabled() and GetGlobalDBool("bool_yrp_scoreboard_show_level", false) then
							x = x + scolen["leve"]
						end

						if true then
							local nay = ph / 4 * 1
							local ugy = ph / 4 * 3
							if !GetGlobalDBool("bool_yrp_scoreboard_show_usergroup", false) then
								nay = ph / 2
							end
							draw.SimpleTextOutlined(pl:RPName(), "sef", YRP.ctr(x * fac), nay, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
							if GetGlobalDBool("bool_yrp_scoreboard_show_usergroup", false) then
								draw.SimpleTextOutlined(string.upper(pl:GetUserGroup()), "sef", YRP.ctr(x * fac), ugy, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
							end
							x = x + scolen["name"]
						end

						if GetGlobalDBool("bool_yrp_scoreboard_show_rolename", false) or GetGlobalDBool("bool_yrp_scoreboard_show_groupname", false) then
							x = x + scolen["role"]
						end

						if GetGlobalDBool("bool_yrp_scoreboard_show_frags", false) or GetGlobalDBool("bool_yrp_scoreboard_show_deaths", false) then
							x = x + scolen["frag"]
						end

						local br = 40
						x = br
						draw.SimpleTextOutlined(pl:Ping(), "sef", pw - YRP.ctr(x * fac), ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
						x = x + scolen["ping"]

						if GetGlobalDBool("bool_yrp_scoreboard_show_operating_system", false) then
							local icon_size = YRP.ctr(100)
							YRP.DrawIcon(YRP.GetDesignIcon("os_" .. self.os), icon_size, icon_size, pw - YRP.ctr(x * fac) - icon_size, (ph - icon_size) / 2, Color(255, 255, 255, 255))
							if self:IsHovered() then
								draw.SimpleTextOutlined(string.upper(self.os), "sef", pw - YRP.ctr(x * fac), ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
							end
							x = x + scolen["oper"]
						end

						if GetGlobalDBool("bool_yrp_scoreboard_showpl.usbplaytime", false) then
							draw.SimpleTextOutlined(self.playtime, "sef", pw - YRP.ctr(x * fac), ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
							x = x + scolen["play"]
						end

						if GetGlobalDBool("bool_yrp_scoreboard_show_country", false) then
							local icon_size = YRP.ctr(100)
							local icon_wide = icon_size * 1.49
							YRP.DrawIcon(YRP.GetDesignIcon("flag_" .. self.cc), icon_size * 1.49, icon_size, pw - YRP.ctr(x * fac) - icon_wide, ph / 2 - icon_size / 2, Color(255, 255, 255, 255))
							if self:IsHovered() then
								draw.SimpleTextOutlined(string.upper(self.cc), "sef", pw - YRP.ctr(x * fac) - icon_wide / 2, ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
							end
							x = x + scolen["coun"]
						end

						if GetGlobalDBool("bool_yrp_scoreboard_show_language", false) then
							local icon_size = YRP.ctr(100)
							local icon_wide = icon_size * 1.49
							YRP.DrawIcon(YRP.GetDesignIcon("lang_" .. self.lang), icon_size * 1.49, icon_size, pw - YRP.ctr(x * fac) - icon_wide, ph / 2 - icon_size / 2, Color(255, 255, 255, 255))
							if self:IsHovered() then
								draw.SimpleTextOutlined(string.upper(self.lang), "sef", pw - YRP.ctr(x * fac) - icon_wide / 2, ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
							end
							x = x + scolen["lang"]
						end
					end
				end

				pl.usbp.avap = createD("DPanel", pl.usbp, YRP.ctr(128-8), YRP.ctr(128-8), YRP.ctr(4), YRP.ctr(4))
				pl.usbp.avap.Avatar = createD("AvatarImage", pl.usbp.avap, YRP.ctr(128-8), YRP.ctr(128-8), 0, 0)
				pl.usbp.avap.Avatar:SetPlayer(pl, YRP.ctr(128-8))
				pl.usbp.avap.Avatar:SetPaintedManually(true)
				function pl.usbp.avap:Paint(pw, ph)
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

						self.Avatar:SetPaintedManually(false)
						self.Avatar:PaintManual()
						self.Avatar:SetPaintedManually(true)

					render.SetStencilEnable(false)
				end
			end
			sbs.stab:AddItem(pl.usbp)
		end
	end
	SetIsScoreboardOpen(true)
end

timer.Simple(4, function()
	OpenSBS()
	CloseSBS()
end)

function GM:ScoreboardShow()
	OpenSBS()
end

function GM:ScoreboardHide()
	CloseSBS()
end

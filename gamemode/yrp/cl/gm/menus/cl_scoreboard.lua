--Copyright (C) 2017-2019 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

local elePos = {}
elePos.x = 0
elePos.y = 0

local mc = {}

isScoreboardOpen = false
function SetIsScoreboardOpen(bo)
	isScoreboardOpen = bo
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
		local _menu = createD("DYRPMenu", nil, ctr(800), ctr(50), _mx - ctr(25), _my - ctr(25))
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
				if !ply:GetNWBool("injail", false) then
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
				if !ply:GetNWBool("ragdolled", false) then
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
				if !ply:GetNWBool("godmode", false) then
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
				if !ply:GetNWBool("cloaked", false) then
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
				if !ply:GetNWBool("blinded", false) then
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

local sbs = {}
sbs.icons = {}
sbs.icons.yrp = Material("yrp/yrp_icon")

function CloseSBS()
	SetIsScoreboardOpen(false)
	if pa(sbs.frame) then
		sbs.frame:Remove()
		sbs.frame = nil
	end
end

function OpenSBS()
	if sbs.frame == nil then
		SetIsScoreboardOpen(true)
		sbs.frame = createD("DFrame", nil, ScW(), ScrH(), PosX(), 0)
		sbs.frame:SetDraggable(false)
		sbs.frame:ShowCloseButton(false)
		sbs.frame:SetTitle("")
		sbs.frame:MakePopup()

		local _mapPNG = getMapPNG()

		local _server_logo = LocalPlayer():GetNWString("text_server_logo", "")
		text_server_logo = GetHTMLImage(LocalPlayer():GetNWString("text_server_logo", ""), ctr(256), ctr(256))

		function sbs.frame:Paint(pw, ph)
			draw.RoundedBox(0, 0, 0, pw, ph, Color(0, 0, 0, 100))

			draw.RoundedBox(0, ctr(256), ctr(128-50), pw-ctr(512), ctr(100), Color(0, 0, 255, 100))

			draw.SimpleTextOutlined(GAMEMODE:GetGameDescription() .. " [" .. GetRPBase() .. "]", "ScoreBoardNormal", ctr(256 + 20), ctr(128-20), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
			draw.SimpleTextOutlined(GetHostName(), "ScoreBoardTitle", ctr(256 + 20), ctr(128 + 20), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))

			draw.SimpleTextOutlined(YRP.lang_string("LID_map") .. ": " .. GetNiceMapName(), "ScoreBoardNormal", pw - ctr(256 + 20), ctr(128-20), Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
			draw.SimpleTextOutlined(YRP.lang_string("LID_players") .. ": " .. #player.GetAll() .. "/" .. game.MaxPlayers(), "ScoreBoardNormal", pw - ctr(256 + 20), ctr(128 + 20), Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))

			if _server_logo == "" then
				surface.SetDrawColor(255, 255, 255, 255)
				surface.SetMaterial(sbs.icons.yrp	)
				surface.DrawTexturedRect(0, ctr(4), ctr(256), ctr(256))
			end

			if _mapPNG != false then
				draw.RoundedBox(0, pw-ctr(256 + 8), 0, ctr(256 + 8), ctr(256 + 8), Color(0, 0, 0, 255))

				surface.SetDrawColor(255, 255, 255, 255)
				surface.SetMaterial(_mapPNG	)
				surface.DrawTexturedRect(pw-ctr(256 + 4), ctr(4), ctr(256), ctr(256))
			else
				if _server_logo == "" then
					surface.SetDrawColor(255, 255, 255, 255)
					surface.SetMaterial(sbs.icons.yrp	)
					surface.DrawTexturedRect(pw-ctr(256 + 4), ctr(4), ctr(256), ctr(256))
				end
			end
		end

		if _server_logo != "" then
			local ServerLogo = createD("DHTML", sbs.frame, ctr(256), ctr(256), 0, ctr(4))
			ServerLogo:SetHTML(text_server_logo)
			if _mapPNG == false then
				local ServerLogo2 = createD("DHTML", sbs.frame, ctr(256), ctr(256), sbs.frame:GetWide() - ctr(256 + 4), ctr(4))
				ServerLogo2:SetHTML(text_server_logo)
			end
		end

		sbs.header = createD("DPanel", sbs.frame, ScW(), ctr(64), 0, ctr(256 + 10))
		function sbs.header:Paint(pw, ph)
			local pl = LocalPlayer()
			draw.RoundedBox(0, 0, 0, pw, ph, Color(0, 0, 0, 100))

			local x = 128 + 10
			local naugname = YRP.lang_string("LID_name") .. "/" .. YRP.lang_string("LID_usergroup")
			if !pl:GetNWBool("bool_yrp_scoreboard_show_usergroup", false) then
				naugname = YRP.lang_string("LID_name")
			end
			draw.SimpleTextOutlined(naugname, "sef", ctr(x), ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
			x = x + 700

			if pl:GetNWBool("bool_yrp_scoreboard_show_rolename", false) or pl:GetNWBool("bool_yrp_scoreboard_show_groupname", false) then
				local rgname = YRP.lang_string("LID_role") .. "/" .. YRP.lang_string("LID_group")
				if !pl:GetNWBool("bool_yrp_scoreboard_show_rolename", false) then
					rgname = YRP.lang_string("LID_group")
				elseif !pl:GetNWBool("bool_yrp_scoreboard_show_groupname", false) then
					rgname = YRP.lang_string("LID_role")
				end
				draw.SimpleTextOutlined(rgname, "sef", ctr(x), ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
				x = x + 700
			end

			if pl:GetNWBool("bool_yrp_scoreboard_show_frags", false) or pl:GetNWBool("bool_yrp_scoreboard_show_deaths", false) then
				local fdname = YRP.lang_string("LID_frags") .. "/" .. YRP.lang_string("LID_deaths")
				if !pl:GetNWBool("bool_yrp_scoreboard_show_frags", false) then
					fdname = YRP.lang_string("LID_deaths")
				elseif !pl:GetNWBool("bool_yrp_scoreboard_show_deaths", false) then
					fdname = YRP.lang_string("LID_frags")
				end
				draw.SimpleTextOutlined(fdname, "sef", ctr(x), ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
				x = x + 400
			end

			if pl:GetNWBool("bool_yrp_scoreboard_show_language", false) then
				draw.SimpleTextOutlined(YRP.lang_string("LID_language"), "sef", ctr(x), ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
				x = x + 300
			end

			if pl:GetNWBool("bool_yrp_scoreboard_show_country", false) then
				draw.SimpleTextOutlined(YRP.lang_string("LID_country"), "sef", ctr(x), ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
				x = x + 300
			end

			draw.SimpleTextOutlined(YRP.lang_string("LID_playtime"), "sef", ctr(x), ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
			x = x + 300

			if pl:GetNWBool("bool_yrp_scoreboard_show_operating_system", false) then
				draw.SimpleTextOutlined(YRP.lang_string("LID_os"), "sef", ctr(x), ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
				x = x + 300
			end

			draw.SimpleTextOutlined(YRP.lang_string("LID_ping"), "sef", ctr(x), ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
		end

		sbs.stab = createD("DPanelList", sbs.frame, ScW(), ScrH() - ctr(256 + 10 + 64), 0, ctr(256 + 10 + 64))
		sbs.stab:EnableVerticalScrollbar(true)

		local allplys = player.GetAll()
		local rplys = {}
		local uplys = {}
		for i, pl in pairs(allplys) do
			pl["group"] = pl:GetGroupName()
			if pl:GetGroupName() != "NO GROUP SELECTED" then
				table.insert(rplys, pl)
			else
				table.insert(uplys, pl)
			end
		end
		for i, pl in SortedPairsByMemberValue(rplys, "group") do
			local _p = createD("DButton", sbs.stab, ScW(), ctr(128), 0, 0)
			_p:SetText("")
			function _p:DoClick()
				OpenPlayerOptions(pl)
			end
			_p.col = i % 2 * 100
			_p.color = pl:GetGroupColor()
			if _p.color.r >= 240 then
				_p.color = Color(_p.color.r - 20, _p.color.g - 20, _p.color.b - 20, 100)
			else
				_p.color = Color(_p.color.r + 20, _p.color.g + 20, _p.color.b + 20, 100)
			end

			_p.pt = string.FormattedTime(pl:GetNWFloat("uptime_current", 0))
			if _p.pt.m < 10 then
				_p.pt.m = "0" .. _p.pt.m
			end
			if _p.pt.h < 10 then
				_p.pt.h = "0" .. _p.pt.h
			end
			_p.playtime = _p.pt.h .. ":" .. _p.pt.m
			_p.os = pl:GetNWString("yrp_os", "other")
			_p.lang = pl:GetLanguageShort()

			local country = pl:GetCountry()
			_p.country = country
			local countryshort = pl:GetCountryShort()
			_p.cc = string.lower(countryshort)
			if tostring(YRP.GetDesignIcon("flag_" .. _p.cc)) == "Material [vgui/material/icon_clear]" and mc[_p.cc] == nil and string.upper(_p.cc) != "LOADING" and YRP.AllIconsLoaded() then
				mc[_p.cc] = true
				YRP.msg("mis", "Missing Country: " .. string.upper(_p.cc))
			end

			function _p:Paint(pw, ph)
				if !pl:IsValid() then
					self:Remove()
				else
					self.bg = self.color
					if self:IsHovered() then
						self.bg = Color(255, 255, 0, 200)
					end
					draw.RoundedBox(ph / 2, 0, 0, pw + ph / 2, ph, self.bg)

					local x = 128 + 10
					if true then
						local nay = ph / 4 * 1
						local ugy = ph / 4 * 3
						if !pl:GetNWBool("bool_yrp_scoreboard_show_usergroup", false) then
							nay = ph / 2
						end
						draw.SimpleTextOutlined(pl:RPName(), "sef", ctr(x), nay, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
						if pl:GetNWBool("bool_yrp_scoreboard_show_usergroup", false) then
							draw.SimpleTextOutlined(string.upper(pl:GetUserGroup()), "sef", ctr(x), ugy, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
						end
						x = x + 700
					end

					if pl:GetNWBool("bool_yrp_scoreboard_show_rolename", false) or pl:GetNWBool("bool_yrp_scoreboard_show_groupname", false) then
						local ry = ph / 4 * 1
						local gy = ph / 4 * 3
						if !pl:GetNWBool("bool_yrp_scoreboard_show_rolename", false) then
							gy = ph / 2
						elseif !pl:GetNWBool("bool_yrp_scoreboard_show_groupname", false) then
							ry = ph / 2
						end
						if pl:GetNWBool("bool_yrp_scoreboard_show_rolename", false) then
							draw.SimpleTextOutlined(pl:GetRoleName(), "sef", ctr(x), ry, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
						end
						if pl:GetNWBool("bool_yrp_scoreboard_show_groupname", false) then
							local grpname = pl:GetGroupName()
							if pl:GetFactionName() != pl:GetGroupName() then
								grpname = "[" .. pl:GetFactionName() .. "] " .. grpname
							end
							draw.SimpleTextOutlined(grpname, "sef", ctr(x), gy, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
						end
						x = x + 700
					end

					if pl:GetNWBool("bool_yrp_scoreboard_show_frags", false) or pl:GetNWBool("bool_yrp_scoreboard_show_deaths", false) then
						local fy = ph / 4 * 1
						local dy = ph / 4 * 3
						if !pl:GetNWBool("bool_yrp_scoreboard_show_frags", false) then
							dy = ph / 2
						elseif !pl:GetNWBool("bool_yrp_scoreboard_show_deaths", false) then
							fy = ph / 2
						end
						if pl:GetNWBool("bool_yrp_scoreboard_show_frags", false) then
							draw.SimpleTextOutlined(pl:Frags(), "sef", ctr(x), fy, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
						end
						if pl:GetNWBool("bool_yrp_scoreboard_show_deaths", false) then
							draw.SimpleTextOutlined(pl:Deaths(), "sef", ctr(x), dy, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
						end
						x = x + 400
					end

					if pl:GetNWBool("bool_yrp_scoreboard_show_language", false) then
						local icon_size = ctr(100)
						YRP.DrawIcon(YRP.GetDesignIcon("lang_" .. self.lang), icon_size * 1.49, icon_size, ctr(x), ph / 2 - icon_size / 2, Color(255, 255, 255, 255))
						if self:IsHovered() then
							draw.SimpleTextOutlined(string.upper(self.lang), "sef", ctr(x) + icon_size / 2, ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
						end
						x = x + 300
					end

					if pl:GetNWBool("bool_yrp_scoreboard_show_country", false) then
						local icon_size = ctr(100)
						YRP.DrawIcon(YRP.GetDesignIcon("flag_" .. self.cc), icon_size * 1.49, icon_size, ctr(x), ph / 2 - icon_size / 2, Color(255, 255, 255, 255))
						if self:IsHovered() then
							draw.SimpleTextOutlined(string.upper(self.cc), "sef", ctr(x) + icon_size * 1.49 / 2, ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
						end
						x = x + 300
					end

					if pl:GetNWBool("bool_yrp_scoreboard_show_playtime", false) then
						draw.SimpleTextOutlined(self.playtime, "sef", ctr(x), ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
						x = x + 300
					end

					if pl:GetNWBool("bool_yrp_scoreboard_show_operating_system", false) then
						local icon_size = ctr(100)
						YRP.DrawIcon(YRP.GetDesignIcon("os_" .. self.os), icon_size, icon_size, ctr(x), (ph - icon_size) / 2, Color(255, 255, 255, 255))
						if self:IsHovered() then
							draw.SimpleTextOutlined(string.upper(self.os), "sef", ctr(x), ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
						end
						x = x + 300
					end

					draw.SimpleTextOutlined(pl:Ping(), "sef", ctr(x), ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
				end
			end

			_p.avap = createD("DPanel", _p, ctr(128-8), ctr(128-8), ctr(4), ctr(4))
			_p.avap.Avatar = createD("AvatarImage", _p.avap, ctr(128-8), ctr(128-8), 0, 0)
			_p.avap.Avatar:SetPlayer(pl, ctr(128-8))
			_p.avap.Avatar:SetPaintedManually(true)
			function _p.avap:Paint(pw, ph)
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

			sbs.stab:AddItem(_p)
			--sbs.stab:Rebuild()
		end

		if #uplys > 0 then
			sbs.hr = createD("DPanel", sbs.frame, ScW(), ctr(64), 0, ctr(256 + 10))
			function sbs.hr:Paint(pw, ph)
			end
			sbs.stab:AddItem(sbs.hr)

			sbs.charsel = createD("DPanel", sbs.frame, ScW(), ctr(64), 0, ctr(256 + 10))
			function sbs.charsel:Paint(pw, ph)
				draw.RoundedBox(0, 0, 0, pw, ph, Color(0, 0, 0, 100))

				local x = 128 + 10
				draw.SimpleTextOutlined(YRP.lang_string("LID_characterselection"), "sef", ctr(x), ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
			end
			sbs.stab:AddItem(sbs.charsel)

			sbs.header2 = createD("DPanel", sbs.frame, ScW(), ctr(64), 0, ctr(256 + 10))
			function sbs.header2:Paint(pw, ph)
				local pl = LocalPlayer()
				draw.RoundedBox(0, 0, 0, pw, ph, Color(0, 0, 0, 100))

				local x = 128 + 10
				local naugname = YRP.lang_string("LID_name")
				draw.SimpleTextOutlined(naugname, "sef", ctr(x), ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
				x = x + 700

				if pl:GetNWBool("bool_yrp_scoreboard_show_rolename", false) or pl:GetNWBool("bool_yrp_scoreboard_show_groupname", false) then
					x = x + 700
				end

				if pl:GetNWBool("bool_yrp_scoreboard_show_frags", false) or pl:GetNWBool("bool_yrp_scoreboard_show_deaths", false) then
					x = x + 400
				end

				if pl:GetNWBool("bool_yrp_scoreboard_show_language", false) then
					draw.SimpleTextOutlined(YRP.lang_string("LID_language"), "sef", ctr(x), ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
					x = x + 300
				end

				if pl:GetNWBool("bool_yrp_scoreboard_show_country", false) then
					draw.SimpleTextOutlined(YRP.lang_string("LID_country"), "sef", ctr(x), ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
					x = x + 300
				end

				draw.SimpleTextOutlined(YRP.lang_string("LID_playtime"), "sef", ctr(x), ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
				x = x + 300

				if pl:GetNWBool("bool_yrp_scoreboard_show_operating_system", false) then
					draw.SimpleTextOutlined(YRP.lang_string("LID_os"), "sef", ctr(x), ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
					x = x + 300
				end

				draw.SimpleTextOutlined(YRP.lang_string("LID_ping"), "sef", ctr(x), ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
			end
			sbs.stab:AddItem(sbs.header2)

			for i, pl in SortedPairsByMemberValue(uplys, "group") do
				local _p = createD("DButton", sbs.stab, ScW(), ctr(128), 0, 0)
				_p:SetText("")
				function _p:DoClick()
					OpenPlayerOptions(pl)
				end
				_p.col = i % 2 * 100
				_p.color = Color(255, 255, 255, 255)
				if _p.color.r >= 240 then
					_p.color = Color(_p.color.r - 20, _p.color.g - 20, _p.color.b - 20, 100)
				else
					_p.color = Color(_p.color.r + 20, _p.color.g + 20, _p.color.b + 20, 100)
				end

				_p.pt = string.FormattedTime(pl:GetNWFloat("uptime_current", 0))
				if _p.pt.m < 10 then
					_p.pt.m = "0" .. _p.pt.m
				end
				if _p.pt.h < 10 then
					_p.pt.h = "0" .. _p.pt.h
				end
				_p.playtime = _p.pt.h .. ":" .. _p.pt.m
				_p.os = pl:GetNWString("yrp_os", "other")
				_p.lang = pl:GetLanguageShort()

				local country = pl:GetCountry()
				_p.country = country
				local countryshort = pl:GetCountryShort()
				_p.cc = string.lower(countryshort)
				if tostring(YRP.GetDesignIcon("flag_" .. _p.cc)) == "Material [vgui/material/icon_clear]" and mc[_p.cc] == nil and string.upper(_p.cc) != "LOADING" and YRP.AllIconsLoaded() then
					mc[_p.cc] = true
					YRP.msg("mis", "Missing Country: " .. string.upper(_p.cc))
				end

				function _p:Paint(pw, ph)
					if !pl:IsValid() then
						self:Remove()
					else
						local lply = LocalPlayer()
						self.bg = self.color
						if self:IsHovered() then
							self.bg = Color(255, 255, 0, 200)
						end
						draw.RoundedBox(ph / 2, 0, 0, pw + ph / 2, ph, self.bg)

						local x = 128 + 10
						if true then
							local nay = ph / 4 * 1
							local ugy = ph / 4 * 3
							if !lply:GetNWBool("bool_yrp_scoreboard_show_usergroup", false) then
								nay = ph / 2
							end
							draw.SimpleTextOutlined(pl:RPName(), "sef", ctr(x), nay, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
							if pl:GetNWBool("bool_yrp_scoreboard_show_usergroup", false) then
								draw.SimpleTextOutlined(string.upper(pl:GetUserGroup()), "sef", ctr(x), ugy, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
							end
							x = x + 700
						end

						if lply:GetNWBool("bool_yrp_scoreboard_show_rolename", false) or lply:GetNWBool("bool_yrp_scoreboard_show_groupname", false) then
							x = x + 700
						end

						if lply:GetNWBool("bool_yrp_scoreboard_show_frags", false) or lply:GetNWBool("bool_yrp_scoreboard_show_deaths", false) then
							x = x + 400
						end

						if lply:GetNWBool("bool_yrp_scoreboard_show_language", false) then
							local icon_size = ctr(100)
							YRP.DrawIcon(YRP.GetDesignIcon("lang_" .. self.lang), icon_size * 1.49, icon_size, ctr(x), ph / 2 - icon_size / 2, Color(255, 255, 255, 255))
							if self:IsHovered() then
								draw.SimpleTextOutlined(string.upper(self.lang), "sef", ctr(x) + icon_size / 2, ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
							end
							x = x + 300
						end

						if pl:GetNWBool("bool_yrp_scoreboard_show_country", false) then
							local icon_size = ctr(100)
							YRP.DrawIcon(YRP.GetDesignIcon("flag_" .. self.cc), icon_size * 1.49, icon_size, ctr(x), ph / 2 - icon_size / 2, Color(255, 255, 255, 255))
							if self:IsHovered() then
								draw.SimpleTextOutlined(string.upper(self.cc), "sef", ctr(x) + icon_size / 2, ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
							end
							x = x + 300
						end

						if lply:GetNWBool("bool_yrp_scoreboard_show_playtime", false) then
							draw.SimpleTextOutlined(self.playtime, "sef", ctr(x), ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
							x = x + 300
						end

						if lply:GetNWBool("bool_yrp_scoreboard_show_operating_system", false) then
							local icon_size = ctr(100)
							YRP.DrawIcon(YRP.GetDesignIcon("os_" .. self.os), icon_size, icon_size, ctr(x), (ph - icon_size) / 2, Color(255, 255, 255, 255))
							if self:IsHovered() then
								draw.SimpleTextOutlined(string.upper(self.os), "sef", ctr(x), ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
							end
							x = x + 300
						end

						draw.SimpleTextOutlined(pl:Ping(), "sef", ctr(x), ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
					end
				end

				_p.avap = createD("DPanel", _p, ctr(128-8), ctr(128-8), ctr(4), ctr(4))
				_p.avap.Avatar = createD("AvatarImage", _p.avap, ctr(128-8), ctr(128-8), 0, 0)
				_p.avap.Avatar:SetPlayer(pl, ctr(128-8))
				_p.avap.Avatar:SetPaintedManually(true)
				function _p.avap:Paint(pw, ph)
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

				sbs.stab:AddItem(_p)
				--sbs.stab:Rebuild()
			end
		end
	end
end

function GM:ScoreboardShow()
	OpenSBS()
end

function GM:ScoreboardHide()
	CloseSBS()
end

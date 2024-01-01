--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
-- #Settings
include("cl_settings_client_charakter.lua")
include("cl_settings_client_keybinds.lua")
include("cl_settings_server_give.lua")
include("cl_settings_server_characters.lua")
include("cl_settings_server_events.lua")
include("cl_settings_server_licenses.lua")
include("cl_settings_server_specializations.lua")
include("cl_settings_server_shops.lua")
include("cl_settings_server_map.lua")
include("cl_settings_server_whitelist.lua")
include("cl_settings_server_blacklist.lua")
include("cl_settings_server_logs.lua")
include("cl_settings_server_logs_settings.lua")
include("cl_settings_server_scale.lua")
include("cl_settings_server_status.lua")
include("cl_settings_server_feedback.lua")
include("cl_settings_server_general.lua")
include("cl_settings_server_realistic.lua")
include("cl_settings_server_groups_and_roles.lua")
include("cl_settings_server_levelsystem.lua")
include("cl_settings_server_design.lua")
include("cl_settings_server_weapon.lua")
include("cl_settings_server_database.lua")
include("cl_settings_server_usergroups.lua")
include("cl_settings_server_darkrp.lua")
include("cl_settings_server_permaprops.lua")
include("cl_settings_server_importexport.lua")
include("cl_settings_server_yourrp_addons.lua")
local sm = {}
sm.open = false
sm.currentsite = "LID_usermanagement"
sm.category = "LID_usermanagement"
sm.usergroup = nil
function F8CheckUsergroup()
	if LocalPlayer():GetUserGroup() ~= sm.usergroup then
		sm.usergroup = LocalPlayer():GetUserGroup()
		sm.open = false

		return true
	end

	return false
end

function YRPToggleSettings(id)
	local usergroupchanged = F8CheckUsergroup()
	if usergroupchanged then
		F8HardCloseSettings()
	end

	sm.currentsite = id
	if not sm.open and YRPIsNoMenuOpen() then
		F8OpenSettings()
	elseif sm.open then
		F8CloseSettings()
	end
end

function F8CloseSettings(pnl)
	sm.open = false
	if YRPPanelAlive(sm.win) then
		sm.win:Hide()
	elseif IsNotNilAndNotFalse(pnl) and pnl.Remove ~= nil then
		pnl:Remove()
	end
end

function F8HardCloseSettings()
	sm.open = false
	if YRPPanelAlive(sm.win) then
		sm.win:Remove()
		sm.win = nil
	end
end

function GetSettingsSite()
	return sm.tabsite or sm.site
end

function F8RequireUG(site, usergroups)
	local lply = LocalPlayer()
	local ugs = string.Explode(", ", usergroups)
	local PARENT = GetSettingsSite()
	if not YRPPanelAlive(PARENT) then return end
	local allugs = {}
	allugs["USERGROUPS"] = usergroups
	local notallowed = YRPCreateD("DPanel", PARENT, PARENT:GetWide(), PARENT:GetTall(), 0, 0)
	function notallowed:Paint(w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 255))
		surfaceText(YRP.trans("LID_settings_yourusergrouphasnopermission") .. " [ " .. site .. " ]", "Y_24_500", w / 2, h / 2, Color(0, 255, 0), 1, 1)
		if site ~= "usergroups" then
			surfaceText(YRP.trans("LID_settings_gotof8usergroups"), "Y_24_500", w / 2, h / 2 + YRP.ctr(100), Color(255, 255, 0), 1, 1)
		else
			surfaceText(YRP.trans("LID_settings_giveyourselftheusergroup", allugs), "Y_24_500", w / 2, h / 2 + YRP.ctr(100), Color(255, 255, 0), 1, 1)
			surfaceText("(In SERVER Console) (Respawn after usergroup changed!) Example:", "Y_24_500", w / 2, h / 2 + YRP.ctr(250), Color(255, 255, 0), 1, 1)
		end
	end

	if site == "usergroups" then
		for i, v in pairs(ugs) do
			local example = YRPCreateD("DTextEntry", PARENT, YRP.ctr(1400), YRP.ctr(50), PARENT:GetWide() / 2 - YRP.ctr(1400 / 2), PARENT:GetTall() / 2 + YRP.ctr(300) + (i - 1) * YRP.ctr(60))
			if DAMVERSION then
				example:SetText("dam addply \"" .. lply:RPName() .. "\" " .. v)
			elseif SAM_LOADED then
				example:SetText("sam setrank \"" .. lply:RPName() .. "\" " .. v)
			else
				example:SetText("ulx adduser \"" .. lply:RPName() .. "\" " .. v)
			end
		end
	end
end

concommand.Add(
	"yrp_open_settings",
	function(ply, cmd, args)
		YRP.msg("gm", "Open settings window")
		F8OpenSettings()
	end
)

function SettingsTabsContent()
	local lply = LocalPlayer()
	local PARENT = sm.site
	-- TABS
	local tabs = YRPCreateD("YTabs", PARENT, PARENT:GetWide(), PARENT:GetTall(), 0, 0)
	function tabs:Think()
		self:SetSize(PARENT:GetWide(), PARENT:GetTall())
	end

	sm.tabsite = tabs.site
	if sm.currentsite == "LID_usermanagement" then
		if lply:GetYRPBool("bool_events", false) then
			tabs:AddOption(
				"LID_event",
				function(parent)
					OpenSettingsEvents()
					sm.win:SetTitle(string.upper(YRP.trans("LID_event")))
				end
			)
		end

		if lply:GetYRPBool("bool_players", false) then
			tabs:AddOption(
				"LID_settings_players",
				function(parent)
					OpenSettingsPlayers()
					sm.win:SetTitle(string.upper(YRP.trans("LID_players")))
				end
			)
		end

		if lply:GetYRPBool("bool_players", false) then
			tabs:AddOption(
				"LID_characters",
				function(parent)
					OpenSettingsCharacters()
					sm.win:SetTitle(string.upper(YRP.trans("LID_characters")))
				end
			)
		end

		if lply:GetYRPBool("bool_whitelist", false) then
			tabs:AddOption(
				"LID_whitelist",
				function(parent)
					OpenSettingsWhitelist()
					sm.win:SetTitle(string.upper(YRP.trans("LID_whitelist")))
				end
			)
		end

		tabs:GoToSite("LID_event")
	elseif sm.currentsite == "LID_moderation" then
		if lply:GetYRPBool("bool_status", false) then
			tabs:AddOption(
				"LID_settings_status",
				function(parent)
					OpenSettingsStatus()
					sm.win:SetTitle(string.upper(YRP.trans("LID_settings_status")))
				end
			)
		end

		if lply:GetYRPBool("bool_groupsandroles", false) then
			tabs:AddOption(
				"LID_settings_groupsandroles",
				function(parent)
					OpenSettingsGroupsAndRoles()
					sm.win:SetTitle(string.upper(YRP.trans("LID_settings_groupsandroles")))
				end
			)
		end

		if lply:GetYRPBool("bool_map", false) then
			tabs:AddOption(
				"LID_settings_map",
				function(parent)
					OpenSettingsMap()
					sm.win:SetTitle(string.upper(YRP.trans("LID_settings_map")))
				end
			)
		end

		if lply:GetYRPBool("bool_logs", false) then
			tabs:AddOption(
				"LID_logs",
				function(parent)
					OpenSettingsLogs()
					sm.win:SetTitle(string.upper(YRP.trans("LID_logs")))
				end
			)
		end

		if lply:GetYRPBool("bool_logs", false) then
			tabs:AddOption(
				"LID_logs_settings",
				function(parent)
					OpenSettingsLogsSettings()
					sm.win:SetTitle(string.upper(YRP.trans("LID_logs_settings")))
				end
			)
		end

		if lply:GetYRPBool("bool_blacklist", false) then
			tabs:AddOption(
				"LID_blacklist",
				function(parent)
					OpenSettingsBlacklist()
					sm.win:SetTitle(string.upper(YRP.trans("LID_blacklist")))
				end
			)
		end

		if lply:GetYRPBool("bool_feedback", false) then
			tabs:AddOption(
				"LID_tickets",
				function(parent)
					OpenSettingsFeedback()
					sm.win:SetTitle(string.upper(YRP.trans("LID_tickets")))
				end
			)
		end

		tabs:GoToSite("LID_settings_status")
	elseif sm.currentsite == "LID_administration" then
		if lply:GetYRPBool("bool_usergroups", false) then
			tabs:AddOption(
				"LID_settings_usergroups",
				function(parent)
					YRPOpenSettingsUsergroups()
					sm.win:SetTitle(string.upper(YRP.trans("LID_settings_usergroups")))
				end
			)
		end

		if lply:GetYRPBool("bool_realistic", false) then
			tabs:AddOption(
				"LID_settings_realistic",
				function(parent)
					OpenSettingsRealistic()
					sm.win:SetTitle(string.upper(YRP.trans("LID_settings_realistic")))
				end
			)
		end

		if lply:GetYRPBool("bool_shops", false) then
			tabs:AddOption(
				"LID_settings_shops",
				function(parent)
					OpenSettingsShops()
					sm.win:SetTitle(string.upper(YRP.trans("LID_settings_shops")))
				end
			)
		end

		if lply:GetYRPBool("bool_licenses", false) then
			tabs:AddOption(
				"LID_settings_licenses",
				function(parent)
					OpenSettingsLicenses()
					sm.win:SetTitle(string.upper(YRP.trans("LID_settings_licenses")))
				end
			)
		end

		if lply:GetYRPBool("bool_specializations", false) then
			tabs:AddOption(
				"LID_specializations",
				function(parent)
					OpenSettingsSpecializations()
					sm.win:SetTitle(string.upper(YRP.trans("LID_specializations")))
				end
			)
		end

		if lply:GetYRPBool("bool_levelsystem", false) then
			tabs:AddOption(
				"LID_levelsystem",
				function(parent)
					OpenSettingsLevelsystem()
					sm.win:SetTitle(string.upper(YRP.trans("LID_levelsystem")))
				end
			)
		end

		if lply:GetYRPBool("bool_design", false) then
			tabs:AddOption(
				"LID_settings_design",
				function(parent)
					OpenSettingsDesign()
					sm.win:SetTitle(string.upper(YRP.trans("LID_settings_design")))
				end
			)
		end

		if lply:GetYRPBool("bool_scale", false) then
			tabs:AddOption(
				"LID_scale",
				function(parent)
					OpenSettingsScale()
					sm.win:SetTitle(string.upper(YRP.trans("LID_scale")))
				end
			)
		end

		if lply:GetYRPBool("bool_weaponsystem", false) then
			tabs:AddOption(
				"LID_weaponsystem",
				function(parent)
					OpenSettingsWeaponSystem()
					sm.win:SetTitle(string.upper(YRP.trans("LID_weaponsystem")))
				end
			)
		end

		tabs:GoToSite("LID_settings_usergroups")
	elseif sm.currentsite == "LID_server" then
		if lply:GetYRPBool("bool_general", false) then
			tabs:AddOption(
				"LID_settings_general",
				function(parent)
					OpenSettingsGeneral()
					sm.win:SetTitle(string.upper(YRP.trans("LID_settings_general")))
				end
			)
		end

		if lply:GetYRPBool("bool_ac_database", false) then
			tabs:AddOption(
				"LID_settings_database",
				function(parent)
					OpenSettingsDatabase()
					sm.win:SetTitle(string.upper(YRP.trans("LID_settings_database")))
				end
			)
		end

		if lply:GetYRPBool("bool_darkrp", false) then
			tabs:AddOption(
				"DarkRP",
				function(parent)
					OpenSettingsDarkRP()
					sm.win:SetTitle(string.upper("DarkRP"))
				end
			)
		end

		if lply:GetYRPBool("bool_permaprops", false) then
			tabs:AddOption(
				"Perma Props",
				function(parent)
					OpenSettingsPermaProps()
					sm.win:SetTitle(string.upper("Perma Props"))
				end
			)
		end

		if lply:GetYRPBool("bool_permaprops", false) then
			tabs:AddOption(
				"Perma Props - Clean & Easy",
				function(parent)
					OpenSettingsPermaProps2()
					sm.win:SetTitle(string.upper("Perma Props - Clean & Easy"))
				end
			)
		end

		tabs:GoToSite("LID_settings_general")
	elseif sm.currentsite == "LID_import" then
		if lply:GetYRPBool("bool_import_darkrp", false) then
			tabs:AddOption(
				"DarkRP",
				function(parent)
					OpenSettingsImportDarkRP()
					sm.win:SetTitle(string.upper("DarkRP"))
				end
			)
		end

		tabs:GoToSite("DarkRP")
	elseif sm.currentsite == "YourRP" then
		if lply:GetYRPBool("bool_yourrp_addons", false) then
			tabs:AddOption(
				"LID_settings_yourrp_addons",
				function(parent)
					OpenSettingsYourRPAddons()
					sm.win:SetTitle(string.upper(YRP.trans("LID_settings_yourrp_addons")))
				end
			)
		end

		tabs:GoToSite("LID_settings_yourrp_addons")
	end
end

function F8OpenSettings()
	local usergroupchanged = F8CheckUsergroup()
	if usergroupchanged then
		F8HardCloseSettings()
	end

	local lply = LocalPlayer()
	if lply.settings_expanded == nil then
		lply.settings_expanded = true
	end

	if lply.settingsmaximised == nil then
		lply.settingsmaximised = false
	end

	sm.open = true
	local br = YRP.ctr(20)
	if YRPPanelAlive(sm.win) == false then
		local sites = {}
		local c = 0
		if lply:GetYRPBool("bool_players", false) or lply:GetYRPBool("bool_whitelist", false) then
			sites[c] = {}
			sites[c].name = "LID_usermanagement"
			sites[c].icon = "64_user"
			sites[c].content = SettingsTabsContent
			c = c + 1
		end

		if lply:GetYRPBool("bool_status", false) or lply:GetYRPBool("bool_groupsandroles", false) or lply:GetYRPBool("bool_map", false) or lply:GetYRPBool("bool_logs", false) or lply:GetYRPBool("bool_blacklist", false) or lply:GetYRPBool("bool_feedback", false) then
			sites[c] = {}
			sites[c].name = "LID_moderation"
			sites[c].icon = "64_info-circle"
			sites[c].content = SettingsTabsContent
			c = c + 1
		end

		if lply:GetYRPBool("bool_realistic", false) or lply:GetYRPBool("bool_shops", false) or lply:GetYRPBool("bool_licenses", false) or lply:GetYRPBool("bool_usergroups", false) or lply:GetYRPBool("bool_levelsystem", false) or lply:GetYRPBool("bool_design", false) or lply:GetYRPBool("bool_scale", false) or lply:GetYRPBool("bool_weaponsystem", false) then
			sites[c] = {}
			sites[c].name = "LID_administration"
			sites[c].icon = "64_wrench"
			sites[c].content = SettingsTabsContent
			c = c + 1
		end

		if lply:GetYRPBool("bool_general", false) or lply:GetYRPBool("bool_ac_database", false) or lply:GetYRPBool("bool_darkrp", false) or lply:GetYRPBool("bool_permaprops", false) then
			sites[c] = {}
			sites[c].name = "LID_server"
			sites[c].icon = "64_server"
			sites[c].content = SettingsTabsContent
			c = c + 1
		end

		if lply:GetYRPBool("bool_import_darkrp", false) then
			sites[c] = {}
			sites[c].name = "LID_import"
			sites[c].icon = "importexport"
			sites[c].content = SettingsTabsContent
			c = c + 1
		end

		if lply:GetYRPBool("bool_yourrp_addons", false) then
			sites[c] = {}
			sites[c].name = "YourRP"
			sites[c].icon = "64_theater-masks"
			sites[c].content = SettingsTabsContent
			c = c + 1
		end

		sm.win = YRPCreateD("YFrame", nil, BFW(), BFH(), BPX(), BPY())
		sm.win:SetTitle("")
		sm.win:MakePopup()
		--sm.win:SetHeaderHeight(YRP.ctr(100) )
		sm.win:SetBorder(0)
		sm.win:CanMaximise()
		sm.win:SetMaximised(LocalPlayer().settingsmaximised, "SETTING")
		sm.win:SetSizable(true)
		sm.win:SetMinWidth(700)
		sm.win:SetMinHeight(700)
		local rlsize = sm.win:GetHeaderHeight() - YRP.ctr(20)
		function sm.win:Paint(pw, ph)
			hook.Run("YFramePaint", self, pw, ph)
			draw.SimpleText(self:GetTitle(), "Y_18_500", self:GetHeaderHeight() / 2, self:GetHeaderHeight() / 2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			draw.SimpleText(YRP.trans("LID_players") .. ": " .. player.GetCount() .. "/" .. game.MaxPlayers(), "Y_18_500", pw / 2 - YRP.ctr(300), self:GetHeaderHeight() / 2, Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
			draw.SimpleText("YourRP Version.: " .. YRPGetVersionFull() .. " ( " .. string.upper(GAMEMODE.dedicated) .. " Server)", "Y_18_500", pw / 2 + YRP.ctr(120), self:GetHeaderHeight() / 2, YRPGetVersionColor(), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			if sm.win.reload and (sm.win.reload.sw ~= sm.win:GetWide() or sm.win.reload.sh ~= sm.win:GetTall()) then
				sm.win.reload:SetPos(sm.win:GetWide() - sm.win:GetHeaderHeight() * 5.6 - rlsize, YRP.ctr(10))
			end
		end

		function sm.win:Close()
			F8CloseSettings(self)
		end

		sm.win.reload = YRPCreateD("YButton", sm.win, rlsize, rlsize, 0, 0)
		sm.win.reload:SetText("")
		function sm.win.reload:Paint(pw, ph)
			hook.Run("YButtonPaint", self, pw, ph)
			local pbr = YRP.ctr(10)
			if YRP.GetDesignIcon("64_angle-right") ~= nil then
				surface.SetMaterial(YRP.GetDesignIcon("64_sync"))
				surface.SetDrawColor(Color(255, 255, 255, 255))
				surface.DrawTexturedRect(pbr, pbr, ph - 2 * pbr, ph - 2 * pbr)
			end
		end

		function sm.win.reload:DoClick()
			F8HardCloseSettings()
			timer.Simple(
				0.1,
				function()
					YRPToggleSettings()
				end
			)
		end

		-- LOGO
		local logoS = sm.win:GetHeaderHeight() - YRP.ctr(20)
		sm.win.logo = YRPCreateD("YPanel", sm.win, YRP.ctr(200), logoS, sm.win:GetWide() / 2 - YRP.ctr(200), YRP.ctr(10))
		sm.win.logo.yrp = Material("vgui/yrp/logo100_beta.png")
		function sm.win.logo:Paint(pw, ph)
			--draw.RoundedBox(0, 0, 0, pw, ph, Color( 0, 255, 0 ) )
			surface.SetDrawColor(Color(255, 255, 255, 255))
			surface.SetMaterial(self.yrp)
			surface.DrawTexturedRect(0, 0, 400 * logoS / 130, 130 * logoS / 130)
			self.w = self.w or 0
			if self.w ~= 400 * logoS / 130 or self.h ~= logoS or self.x ~= sm.win:GetWide() / 2 - self.w or self.y ~= YRP.ctr(10) then
				self.w = 400 * logoS / 130
				self.h = logoS
				self.x = sm.win:GetWide() / 2 - self.w
				self.y = YRP.ctr(10)
				self:SetSize(self.w, self.h)
				self:SetPos(self.x, self.y)
			end
		end

		-- DISCORD
		local icon_size = sm.win:GetHeaderHeight() - YRP.ctr(20)
		local icon_x, icon_y = sm.win.logo:GetPos()
		icon_x = icon_x + sm.win.logo:GetWide() + YRP.ctr(20)
		sm.win.discord = YRPCreateD("YPanel", sm.win, icon_size, icon_size, icon_x, icon_y)
		sm.win.discord.logo = YRPCreateD("DPanel", sm.win.discord, icon_size, icon_size, 0, 0)
		sm.win.discord.btn = YRPCreateD("DButton", sm.win.discord, icon_size, icon_size, 0, 0)
		sm.win.discord.btn:SetText("")
		function sm.win.discord.logo:Paint(pw, ph)
			if YRP.GetDesignIcon("discord") then
				surface.SetDrawColor(Color(255, 255, 255, 255))
				surface.SetMaterial(YRP.GetDesignIcon("discord"))
				surface.DrawTexturedRect(0, 0, ph, ph)
			end
		end

		function sm.win.discord:Paint(pw, ph)
			icon_size = sm.win:GetHeaderHeight() - YRP.ctr(20)
			icon_x, icon_y = sm.win.logo:GetPos()
			icon_x = icon_x + sm.win.logo:GetWide() + YRP.ctr(20)
			if self.w ~= icon_size or self.h ~= icon_size or self.x ~= icon_x or self.y ~= icon_y then
				self.w = icon_size
				self.h = icon_size
				self.x = icon_x
				self.y = icon_y
				self:SetSize(self.w, self.h)
				self:SetPos(self.x, self.y)
				self.logo:SetSize(self.w, self.h)
				self.btn:SetSize(self.w, self.h)
			end
		end

		function sm.win.discord.btn:Paint(pw, ph)
		end

		function sm.win.discord.btn:DoClick()
			gui.OpenURL("https://discord.gg/CXXDCMJ")
		end

		--[[sm.win.botbar = YRPCreateD( "DPanel", sm.win, sm.win:GetWide(), YRP.ctr(50), 0, 0)
		function sm.win.botbar:Paint(pw, ph)
			self:SetWide(sm.win:GetWide() )
			self:SetPos(0, sm.win:GetTall() - YRP.ctr(50) )
			draw.RoundedBox(0, 0, 0, pw, ph, YRPInterfaceValue( "YFrame", "NC" ) )

			draw.SimpleText(GetGlobalYRPString( "text_server_name", "-" ), "Y_18_500", ph / 2, ph / 2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			draw.SimpleText( "YourRP Version.: " .. YRPGetVersionFull() .. " ( " .. string.upper(GAMEMODE.dedicated) .. " Server)", "Y_18_500", pw / 2, ph / 2, YRPGetVersionColor(), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.SimpleText(YRP.trans( "LID_map" ) .. ": " .. game.GetMap() .. "        " .. YRP.trans( "LID_players" ) .. ": " .. player.GetCount() .. "/" .. game.MaxPlayers(), "Y_18_500", pw - ph / 2, ph / 2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
		end]]
		local content = sm.win:GetContent()
		-- MENU
		sm.menu = YRPCreateD("DPanelList", content, 10, BFH() - sm.win:GetHeaderHeight(), 0, 0)
		sm.menu:SetText("")
		sm.menu.pw = YRP.ctr(64) + 2 * br
		sm.menu.ph = YRP.ctr(64) + 2 * br
		sm.menu.expanded = sm.menu.expanded or lply.settings_expanded
		local font = "Y_" .. math.Clamp(math.Round(sm.menu.ph - 2 * br), 4, 100) .. "_500"
		function sm.menu:Paint(pw, ph)
			draw.RoundedBoxEx(YRP.ctr(10), 0, 0, pw, ph, YRPInterfaceValue("YFrame", "HB"), false, false, true, false)
			self:SetTall(sm.win:GetTall() - sm.win:GetHeaderHeight())
		end

		sm.menu:SetSpacing(YRP.ctr(20))
		sm.menu.expander = YRPCreateD("DButton", sm.win, sm.menu.ph, sm.menu.ph, 0, sm.win:GetTall() - sm.menu.ph)
		sm.menu.expander:SetText("")
		function sm.menu.expander:DoClick()
			if lply.settings_expanded then
				sm.win:UpdateCustomeSize(sm.menu.ph)
				sm.menu.expanded = false
			else
				sm.win:UpdateCustomeSize()
				sm.menu.expanded = true
			end

			lply.settings_expanded = sm.menu.expanded
		end

		function sm.menu.expander:Paint(pw, ph)
			self:SetPos(0, sm.win:GetTall() - sm.menu.ph)
			if lply.settings_expanded then
				if YRP.GetDesignIcon("64_angle-left") ~= nil then
					surface.SetMaterial(YRP.GetDesignIcon("64_angle-left"))
				end
			else
				if YRP.GetDesignIcon("64_angle-right") ~= nil then
					surface.SetMaterial(YRP.GetDesignIcon("64_angle-right"))
				end
			end

			surface.SetDrawColor(Color(255, 255, 255, 255))
			surface.DrawTexturedRect(br, br, ph - 2 * br, ph - 2 * br)
		end

		-- SITE
		sm.site = YRPCreateD("YPanel", content, BFW() - 10, BFH() - sm.win:GetHeaderHeight(), 10, 0)
		sm.site:SetText("")
		sm.site:SetHeaderHeight(sm.win:GetHeaderHeight())
		function sm.site:Paint(pw, ph)
			self:SetTall(sm.win:GetTall() - sm.win:GetHeaderHeight())
			--draw.RoundedBox(0, 0, 0, pw, ph, Color( 255, 0, 0, 255) )
			local tab = {}
			tab.color = YRPInterfaceValue("YFrame", "BG")
			hook.Run("YPanelPaint", self, pw, ph, tab) --draw.RoundedBox(0, 0, 0, pw, ph, Color(60, 60, 60, 255) )
		end

		-- SITES
		sm.sites = {}
		function sm.menu:ClearSelection()
			for i, child in pairs(sm.site:GetChildren()) do
				child:Remove()
			end

			for i, v in pairs(sm.sites) do
				v.selected = false
			end
		end

		function sm.win:UpdateCustomeSize(pw)
			local sw = pw or sm.menu.pw + sm.menu.ph + 2 * br
			sm.menu:SetWide(sw)
			sm.menu:SetTall(sm.win:GetContent():GetTall())
			sm.site:SetWide(sm.win:GetWide() - sm.menu:GetWide())
			sm.site:SetTall(sm.win:GetContent():GetTall())
			sm.site:SetPos(sm.menu:GetWide(), 0)
		end

		surface.SetFont(font)
		for i, v in pairs(sites) do
			if v.name ~= "hr" then
				local tw, _ = surface.GetTextSize(YRP.trans(v.name))
				if tw > sm.menu.pw then
					sm.menu.pw = tw
				end

				sm.sites[v.name] = YRPCreateD("YButton", sm.menu, sm.menu.pw, sm.menu.ph, 0, 0)
				local site = sm.sites[v.name]
				site:SetText("")
				site.id = tonumber(i)
				function site:Paint(pw, ph)
					self.aw = self.aw or 0
					local target = pw
					local color = YRPInterfaceValue("YFrame", "HB")
					if self:IsHovered() then
						color = YRPInterfaceValue("YButton", "SC")
						color.a = 120
					elseif self.selected then
						color = YRPInterfaceValue("YButton", "SC")
					else
						target = 0
					end

					self.aw = Lerp(10 * FrameTime(), self.aw, target)
					draw.RoundedBox(0, 0, 0, self.aw, ph, color)
					if YRP.GetDesignIcon(v.icon) ~= nil then
						surface.SetDrawColor(Color(255, 255, 255, 255))
						surface.SetMaterial(YRP.GetDesignIcon(v.icon))
						surface.DrawTexturedRect(br, br, ph - 2 * br, ph - 2 * br)
					end

					surface.SetFont(font)
					local ptw, _ = surface.GetTextSize(YRP.trans(v.name))
					if ptw > sm.menu.pw then
						sm.menu.pw = ptw
					end

					draw.SimpleText(YRP.trans(v.name), font, ph, ph / 2, YRPInterfaceValue("YFrame", "HT"), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
				end

				function site:DoClick()
					sm.menu:ClearSelection()
					sm.currentsite = v.name
					self.selected = true
					if v.content ~= nil then
						v.content(sm.site) --CreateHelpMenuContent(sm.site)
					end
				end

				if sm.currentsite == site.id then
					site:DoClick()
				end

				sm.menu:AddItem(site)
			else
				sm.sites[v.name] = YRPCreateD("DPanel", sm.menu, sm.menu.pw, YRP.ctr(20), 0, 0)
				local site = sm.sites[v.name]
				function site:Paint(pw, ph)
					local hr = YRP.ctr(2)
					draw.RoundedBox(0, br, ph / 2 - hr / 2, pw - br * 2, hr, Color(255, 255, 255, 255))
				end

				sm.menu:AddItem(site)
			end
		end

		if lply.settings_expanded then
			sm.win:UpdateCustomeSize()
		else
			sm.win:UpdateCustomeSize(sm.menu.ph)
		end

		if c == 0 then
			YRPOpenSettingsUsergroups()
		end
	elseif YRPPanelAlive(sm.win) then
		sm.win:Show()
	end
end

net.Receive(
	"nws_yrp_setting_hasnoaccess",
	function(len)
		local site = net.ReadString()
		local usergroups = net.ReadString()
		F8RequireUG(YRP.trans(site), usergroups)
	end
)
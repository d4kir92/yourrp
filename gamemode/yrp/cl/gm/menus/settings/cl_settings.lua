--Copyright (C) 2017-2020 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

-- #Settings

include("cl_settings_client_charakter.lua")
include("cl_settings_client_keybinds.lua")
include("cl_settings_server_give.lua")
include("cl_settings_server_licenses.lua")
include("cl_settings_server_shops.lua")
include("cl_settings_server_map.lua")
include("cl_settings_server_whitelist.lua")
include("cl_settings_server_blacklist.lua")
include("cl_settings_server_logs.lua")
include("cl_settings_server_scale.lua")

include("cl_settings_server_console.lua")
include("cl_settings_server_status.lua")
include("cl_settings_server_feedback.lua")

include("cl_settings_server_general.lua")
include("cl_settings_server_realistic.lua")
include("cl_settings_server_groups_and_roles.lua")
include("cl_settings_server_levelsystem.lua")
include("cl_settings_server_design.lua")

include("cl_settings_server_database.lua")
include("cl_settings_server_usergroups.lua")
include("cl_settings_server_darkrp.lua")
include("cl_settings_server_permaprops.lua")

include("cl_settings_server_yourrp_addons.lua")

local sm = {}
sm.open = false
sm.currentsite = 1

sm.category = "LID_usermanagement"

function ToggleSettings(id)
	id = tonumber(id)
	sm.currentsite = id
	if !sm.open and YRPIsNoMenuOpen() then
		OpenSettings()
	elseif sm.open then
		CloseSettings()
	end
end

function CloseSettings()
	sm.open = false
	if pa(sm.win) then
		sm.win:Hide()
	end
end

function GetSettingsSite()
	return sm.tabsite or sm.site
end

function F8RequireUG(site, usergroups)
	local lply = LocalPlayer()
	local ugs = string.Explode(", ", usergroups)

	local PARENT = GetSettingsSite()
	if !pa(PARENT) then return end

	local allugs = {}
	allugs["USERGROUPS"] = usergroups
	local notallowed = createD("DPanel", PARENT, PARENT:GetWide(), PARENT:GetTall(), 0, 0)
	function notallowed:Paint(w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 255))
		surfaceText(YRP.lang_string("LID_settings_yourusergrouphasnopermission") .. " [ " .. site .. " ]", "Y_24_500", w / 2, h / 2, Color(255, 0, 0), 1, 1)

		if site != "usergroups" then
			surfaceText(YRP.lang_string("LID_settings_gotof8usergroups"), "Y_24_500", w / 2, h / 2 + YRP.ctr(100), Color(255, 255, 0), 1, 1)
		else
			surfaceText(YRP.lang_string("LID_settings_giveyourselftheusergroup", allugs), "Y_24_500", w / 2, h / 2 + YRP.ctr(100), Color(255, 255, 0), 1, 1)
			surfaceText("(In SERVER Console) (Respawn after usergroup changed!) Example:", "Y_24_500", w / 2, h / 2 + YRP.ctr(250), Color(255, 255, 0), 1, 1)
		end
	end

	if site == "usergroups" then
		for i, v in pairs(ugs) do
			local example = createD("DTextEntry", PARENT, YRP.ctr(1400), YRP.ctr(50), PARENT:GetWide() / 2 - YRP.ctr(1400 / 2), PARENT:GetTall() / 2 + YRP.ctr(300) + (i - 1) * YRP.ctr(60))
			example:SetText("yrp_usergroup \"" .. lply:RPName() .. "\" " .. v .. "       OR when ULX/ULIB installed: " .. "ulx adduser \"" .. lply:RPName() .. "\" " .. v)
		end
	end
end

concommand.Add("yrp_open_settings", function(ply, cmd, args)
	printGM( "gm", "Open settings window" )
	OpenSettings()
end)

function SettingsTabsContent()
	local lply = LocalPlayer()
	local PARENT = sm.site

	-- TABS
	local tabs = createD("YTabs", PARENT, PARENT:GetWide(), PARENT:GetTall(), 0, 0)
	function tabs:Think()
		self:SetSize(PARENT:GetWide(), PARENT:GetTall())
	end

	sm.tabsite = tabs.site

	if sm.currentsite == 1 then
		if lply:GetDBool("bool_players", false) then
			tabs:AddOption("LID_settings_players", function(parent)
				OpenSettingsPlayers()
				sm.win:SetTitle(string.upper(YRP.lang_string("LID_players")))
			end)
		end
		if lply:GetDBool("bool_whitelist", false) then
			tabs:AddOption("LID_whitelist", function(parent)
				OpenSettingsWhitelist()
				sm.win:SetTitle(string.upper(YRP.lang_string("LID_whitelist")))
			end)
		end
		
		tabs:GoToSite("LID_settings_players")
	elseif sm.currentsite == 2 then
		if lply:GetDBool("bool_status", false) then
			tabs:AddOption("LID_settings_status", function(parent)
				OpenSettingsStatus()
				sm.win:SetTitle(string.upper(YRP.lang_string("LID_settings_status")))
			end)
		end
		if lply:GetDBool("bool_groupsandroles", false) then
			tabs:AddOption("LID_settings_groupsandroles", function(parent)
				OpenSettingsGroupsAndRoles()
				sm.win:SetTitle(string.upper(YRP.lang_string("LID_settings_groupsandroles")))
			end)
		end
		if lply:GetDBool("bool_map", false) then
			tabs:AddOption("LID_settings_map", function(parent)
				OpenSettingsMap()
				sm.win:SetTitle(string.upper(YRP.lang_string("LID_settings_map")))
			end)
		end
		--if lply:GetDBool("bool_status", false) then
		--[[tabs:AddOption("LID_character", function(parent)

		end)]]
		--end
		if lply:GetDBool("bool_logs", false) then
			tabs:AddOption("LID_logs", function(parent)
				OpenSettingsLogs()
				sm.win:SetTitle(string.upper(YRP.lang_string("LID_logs")))
			end)
		end
		if lply:GetDBool("bool_blacklist", false) then
			tabs:AddOption("LID_blacklist", function(parent)
				OpenSettingsBlacklist()
				sm.win:SetTitle(string.upper(YRP.lang_string("LID_blacklist")))
			end)
		end
		if lply:GetDBool("bool_feedback", false) then
			tabs:AddOption("LID_feedback", function(parent)
				OpenSettingsFeedback()
				sm.win:SetTitle(string.upper(YRP.lang_string("LID_feedback")))
			end)
		end

		tabs:GoToSite("LID_settings_status")
	elseif sm.currentsite == 3 then
		if lply:GetDBool("bool_realistic", false) then
			tabs:AddOption("LID_settings_realistic", function(parent)
				OpenSettingsRealistic()
				sm.win:SetTitle(string.upper(YRP.lang_string("LID_settings_realistic")))
			end)
		end
		if lply:GetDBool("bool_shops", false) then
			tabs:AddOption("LID_settings_shops", function(parent)
				OpenSettingsShops()
				sm.win:SetTitle(string.upper(YRP.lang_string("LID_settings_shops")))
			end)
		end
		if lply:GetDBool("bool_licenses", false) then
			tabs:AddOption("LID_settings_licenses", function(parent)
				OpenSettingsLicenses()
				sm.win:SetTitle(string.upper(YRP.lang_string("LID_settings_licenses")))
			end)
		end
		if lply:GetDBool("bool_usergroups", false) then
			tabs:AddOption("LID_settings_usergroups", function(parent)
				OpenSettingsUsergroups()
				sm.win:SetTitle(string.upper(YRP.lang_string("LID_settings_usergroups")))
			end)
		end
		if lply:GetDBool("bool_levelsystem", false) then
			tabs:AddOption("LID_levelsystem", function(parent)
				OpenSettingsLevelsystem()
				sm.win:SetTitle(string.upper(YRP.lang_string("LID_levelsystem")))
			end)
		end
		if lply:GetDBool("bool_design", false) then
			tabs:AddOption("LID_settings_design", function(parent)
				OpenSettingsDesign()
				sm.win:SetTitle(string.upper(YRP.lang_string("LID_settings_design")))
			end)
		end
		if lply:GetDBool("bool_scale", false) then
			tabs:AddOption("LID_scale", function(parent)
				OpenSettingsScale()
				sm.win:SetTitle(string.upper(YRP.lang_string("LID_scale")))
			end)
		end

		tabs:GoToSite("LID_settings_realistic")
	elseif sm.currentsite == 4 then
		if lply:GetDBool("bool_general", false) then
			tabs:AddOption("LID_settings_general", function(parent)
				OpenSettingsGeneral()
				sm.win:SetTitle(string.upper(YRP.lang_string("LID_settings_general")))
			end)
		end
		if lply:GetDBool("bool_console", false) then
			tabs:AddOption("LID_server_console", function(parent)
				OpenSettingsConsole()
				sm.win:SetTitle(string.upper(YRP.lang_string("LID_server_console")))
			end)
		end
		if lply:GetDBool("bool_ac_database", false) then
			tabs:AddOption("LID_settings_database", function(parent)
				OpenSettingsDatabase()
				sm.win:SetTitle(string.upper(YRP.lang_string("LID_settings_database")))
			end)
		end
		--if lply:GetDBool("bool_status", false) then
			--[[tabs:AddOption("LID_settings_socials", function(parent)
				
			end)]]
		--end
		if lply:GetDBool("bool_darkrp", false) then
			tabs:AddOption("DarkRP", function(parent)
				OpenSettingsDarkRP()
				sm.win:SetTitle(string.upper("DarkRP"))
			end)
		end
		if lply:GetDBool("bool_permaprops", false) then
			tabs:AddOption("Perma Props", function(parent)
				OpenSettingsPermaProps()
				sm.win:SetTitle(string.upper("Perma Props"))
			end)
		end

		tabs:GoToSite("LID_settings_general")
	elseif sm.currentsite == 5 then
		if lply:GetDBool("bool_yourrp_addons", false) then
			tabs:AddOption("LID_settings_yourrp_addons", function(parent)
				OpenSettingsYourRPAddons()
				sm.win:SetTitle(string.upper(YRP.lang_string("LID_settings_yourrp_addons")))
			end)
		end

		tabs:GoToSite("LID_settings_yourrp_addons")
	end
end

function OpenSettings()
	local lply = LocalPlayer()
	sm.open = true
	local br = YRP.ctr(20)
	if pa(sm.win) == false then

		local sites = {}
		
		local c = 1
		if lply:GetDBool("bool_players", false) or lply:GetDBool("bool_whitelist", false) then
			sites[c] = {}
			sites[c].name = "LID_usermanagement"
			sites[c].icon = "64_user"
			sites[c].content = SettingsTabsContent
			c = c + 1
		end

		if lply:GetDBool("bool_status", false) or lply:GetDBool("bool_groupsandroles", false) or lply:GetDBool("bool_map", false) or lply:GetDBool("bool_logs", false) or lply:GetDBool("bool_blacklist", false) or lply:GetDBool("bool_feedback", false) then
			sites[c] = {}
			sites[c].name = "LID_moderation"
			sites[c].icon = "64_info-circle"
			sites[c].content = SettingsTabsContent
			c = c + 1
		end

		if lply:GetDBool("bool_realistic", false) or lply:GetDBool("bool_shops", false) or lply:GetDBool("bool_licenses", false) or lply:GetDBool("bool_usergroups", false) or lply:GetDBool("bool_levelsystem", false) or lply:GetDBool("bool_design", false) or lply:GetDBool("bool_scale", false) then
			sites[c] = {}
			sites[c].name = "LID_administration"
			sites[c].icon = "64_wrench"
			sites[c].content = SettingsTabsContent
			c = c + 1
		end

		if lply:GetDBool("bool_general", false) or lply:GetDBool("bool_console", false) or lply:GetDBool("bool_ac_database", false) or lply:GetDBool("bool_darkrp", false) or lply:GetDBool("bool_permaprops", false) then
			sites[c] = {}
			sites[c].name = "LID_server"
			sites[c].icon = "64_server"
			sites[c].content = SettingsTabsContent
			c = c + 1
		end
	
		if lply:GetDBool("bool_yourrp_addons", false) then
			sites[c] = {}
			sites[c].name = "YourRP"
			sites[c].icon = "64_theater-masks"
			sites[c].content = SettingsTabsContent
			c = c + 1
		end

		if c == 1 then
			OpenSettingsUsergroups()
		end

		sm.win = createD("YFrame", nil, BFW(), BFH(), BPX(), BPY())
		sm.win:SetTitle("")
		sm.win:MakePopup()
		--sm.win:SetHeaderHeight(YRP.ctr(100))
		sm.win:SetBorder(0)
		sm.win:CanMaximise()
		sm.win:SetMaximised(LocalPlayer():GetDBool("settingsmaximised", nil), "SETTING")
		function sm.win:Paint(pw, ph)
			hook.Run("YFramePaint", self, pw, ph)
			draw.SimpleText(self:GetTitle(), "Y_18_500", self:GetHeaderHeight() / 2, self:GetHeaderHeight() / 2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			draw.SimpleText("YourRP Version.: " .. GAMEMODE.Version .. " (" .. string.upper(GAMEMODE.dedicated) .. " Server)", "Y_18_500", pw / 2 + YRP.ctr(120), self:GetHeaderHeight() / 2, GetVersionColor(), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			draw.SimpleText(YRP.lang_string("LID_players") .. ": " .. table.Count(player.GetAll()) .. "/" .. game.MaxPlayers(), "Y_18_500", pw - YRP.ctr(300), self:GetHeaderHeight() / 2, Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
		end

		-- LOGO
		local logoS = sm.win:GetHeaderHeight() - YRP.ctr(20)
		sm.win.logo = createD("YPanel", sm.win, YRP.ctr(200), logoS, sm.win:GetWide() / 2 - YRP.ctr(200), YRP.ctr(10))
		sm.win.logo.yrp = Material("vgui/yrp/logo100_beta.png")
		function sm.win.logo:Paint(pw, ph)
			--draw.RoundedBox(0, 0, 0, pw, ph, Color(255, 0, 0))
			surface.SetDrawColor(255, 255, 255, 255)
			surface.SetMaterial(self.yrp)
			surface.DrawTexturedRect(0, 0, 400 * logoS / 130, 130 * logoS / 130)

			self.w = self.w or 0
			if self.w != 400 * logoS / 130 or self.h != logoS or self.x != sm.win:GetWide() / 2 - self.w or self.y != YRP.ctr(10) then
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
		sm.win.discord = createD("YPanel", sm.win, icon_size, icon_size, icon_x, icon_y)
		sm.win.discord.logo = createD("DHTML", sm.win.discord, icon_size, icon_size, 0, 0)
		sm.win.discord.btn = createD("DButton", sm.win.discord, icon_size, icon_size, 0, 0)
		sm.win.discord.btn:SetText("")
		local img = GetHTMLImage("https://discordapp.com/assets/f8389ca1a741a115313bede9ac02e2c0.svg", icon_size, icon_size)
		sm.win.discord.logo:SetHTML(img)
		function sm.win.discord:Paint(pw, ph)
			icon_size = sm.win:GetHeaderHeight() - YRP.ctr(20)
			icon_x, icon_y = sm.win.logo:GetPos()
			icon_x = icon_x + sm.win.logo:GetWide() + YRP.ctr(20)
			if self.w != icon_size or self.h != icon_size or self.x != icon_x or self.y != icon_y then
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

		--[[sm.win.botbar = createD("DPanel", sm.win, sm.win:GetWide(), YRP.ctr(50), 0, 0)
		function sm.win.botbar:Paint(pw, ph)
			self:SetWide(sm.win:GetWide())
			self:SetPos(0, sm.win:GetTall() - YRP.ctr(50))
			draw.RoundedBox(0, 0, 0, pw, ph, lply:InterfaceValue("YFrame", "NC"))

			draw.SimpleText(GetGlobalDString("text_server_name", "-"), "Y_18_500", ph / 2, ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			draw.SimpleText("YourRP Version.: " .. GAMEMODE.Version .. " (" .. string.upper(GAMEMODE.dedicated) .. " Server)", "Y_18_500", pw / 2, ph / 2, GetVersionColor(), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.SimpleText(YRP.lang_string("LID_map") .. ": " .. game.GetMap() .. "        " .. YRP.lang_string("LID_players") .. ": " .. table.Count(player.GetAll()) .. "/" .. game.MaxPlayers(), "Y_18_500", pw - ph / 2, ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
		end]]

		local content = sm.win:GetContent()
		-- MENU
		sm.menu = createD("DPanelList", content, 10, BFH() - sm.win:GetHeaderHeight(), 0, 0)
		sm.menu:SetText("")
		sm.menu.pw = 10
		sm.menu.ph = YRP.ctr(64) + 2 * br
		sm.menu.expanded = sm.menu.expanded or lply:GetDBool("settings_expanded", true)
		local font = "Y_" .. math.Clamp(math.Round(sm.menu.ph - 2 * br), 4, 100) ..  "_700"
		function sm.menu:Paint(pw, ph)
			draw.RoundedBoxEx(YRP.ctr(10), 0, 0, pw, ph, lply:InterfaceValue("YFrame", "HB"), false, false, true, false)
			self:SetTall(sm.win:GetTall() - sm.win:GetHeaderHeight())
		end
		sm.menu:SetSpacing(YRP.ctr(20))
		
		sm.menu.expander = createD("DButton", sm.menu, sm.menu.ph, sm.menu.ph, 0, sm.menu:GetTall() - sm.menu.ph)
		sm.menu.expander:SetText("")
		function sm.menu.expander:DoClick()
			if lply:GetDBool("settings_expanded", true) then
				sm.win:UpdateSize(sm.menu.ph)

				sm.menu.expanded = false
			else
				sm.win:UpdateSize()

				sm.menu.expanded = true
			end
			lply:SetDBool("settings_expanded", sm.menu.expanded)
		end
		function sm.menu.expander:Paint(pw, ph)
			self:SetPos(0, sm.menu:GetTall() - sm.menu.ph)
			if lply:GetDBool("settings_expanded", true) then
				surface.SetMaterial(YRP.GetDesignIcon("64_angle-left"))
			else
				surface.SetMaterial(YRP.GetDesignIcon("64_angle-right"))
			end
			surface.SetDrawColor(255, 255, 255, 255)
			surface.DrawTexturedRect(br, br, ph - 2 * br, ph - 2 * br)
		end
		
		-- SITE
		sm.site = createD("YPanel", content, BFW() - 10, BFH() - sm.win:GetHeaderHeight(), 10, 0)
		sm.site:SetText("")
		sm.site:SetHeaderHeight(sm.win:GetHeaderHeight())
		function sm.site:Paint(pw, ph)
			self:SetTall(sm.win:GetTall() - sm.win:GetHeaderHeight())
			--draw.RoundedBox(0, 0, 0, pw, ph, Color(255, 0, 0, 255))
			local tab = {}
			tab.color = lply:InterfaceValue("YFrame", "BG")
			hook.Run("YPanelPaint", self, pw, ph, tab) --draw.RoundedBox(0, 0, 0, pw, ph, Color(60, 60, 60, 255))
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

		function sm.win:UpdateSize(pw)
			local sw = pw or sm.menu.pw + sm.menu.ph + 2 * br

			sm.menu:SetWide(sw)
			sm.site:SetWide(sm.win:GetWide() - sm.menu:GetWide())

			sm.site:SetPos(sm.menu:GetWide(), 0)
		end

		surface.SetFont(font)
		for i, v in pairs(sites) do
			if v.name != "hr" then
		
				local tw, th = surface.GetTextSize(YRP.lang_string(v.name))
				if tw > sm.menu.pw then
					sm.menu.pw = tw
				end

				sm.sites[v.name] = createD("YButton", sm.menu, sm.menu.pw, sm.menu.ph, 0, 0)
				local site = sm.sites[v.name]
				site:SetText("")
				site.id = tonumber(i)
				function site:Paint(pw, ph)
					self.aw = self.aw or 0

					local lply = LocalPlayer()
					local color = lply:InterfaceValue("YFrame", "HB")
					if self:IsHovered() then
						color = lply:InterfaceValue("YButton", "SC")
						color.a = 120
						self.aw = math.Clamp(self.aw + 20, 0, pw)
					elseif self.selected then
						color = lply:InterfaceValue("YButton", "SC")
						self.aw = math.Clamp(self.aw + 20, 0, pw)
					else
						self.aw = math.Clamp(self.aw - 20, 0, pw)
					end
					draw.RoundedBox(0, 0, 0, self.aw, ph, color)

					surface.SetDrawColor(255, 255, 255, 255)
					surface.SetMaterial(YRP.GetDesignIcon(v.icon))
					surface.DrawTexturedRect(br, br, ph - 2 * br, ph - 2 * br)

					surface.SetFont(font)
					local tw, th = surface.GetTextSize(YRP.lang_string(v.name))
					if tw > sm.menu.pw then
						sm.menu.pw = tw
					end
					draw.SimpleText(YRP.lang_string(v.name), font, ph, ph / 2, lply:InterfaceValue("YFrame", "HT"), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
				end
				function site:DoClick()
					sm.menu:ClearSelection()
					sm.currentsite = tonumber(self.id)
					self.selected = true
					if v.content != nil then
						v.content(sm.site) --CreateHelpMenuContent(sm.site)
					end
				end

				if sm.currentsite == site.id then
					site:DoClick()
				end

				sm.menu:AddItem(site)
			else
				sm.sites[v.name] = createD("DPanel", sm.menu, sm.menu.pw, YRP.ctr(20), 0, 0)
				local site = sm.sites[v.name]
				function site:Paint(pw, ph)
					local hr = YRP.ctr(2)
					draw.RoundedBox(0, br, ph / 2 - hr / 2, pw - br * 2, hr, Color(255, 255, 255, 255))
				end

				sm.menu:AddItem(site)
			end
		end

		if lply:GetDBool("settings_expanded", true) then
			sm.win:UpdateSize()
		else
			sm.win:UpdateSize(sm.menu.ph)
		end
	elseif pa(sm.win) then
		sm.win:Show()
	end
end

net.Receive("setting_hasnoaccess", function(len)
	local site = net.ReadString()
	local usergroups = net.ReadString()
	F8RequireUG(YRP.lang_string(site), usergroups)
end)

--[[
settings_players		-- Give Role, ...
settings_licenses		-- Manage Licenses
settings_shops			-- Manage Shops
logs					-- LOGS: Kills, connections, spawns, ...
scale?					-- NEW! Scale hunger, thirst, radiation, hygiene

server_console			-- Server console, commands, ...
settings_status			-- Status about the gamemode, whats missing, ...
settings_feedback		-- Tickets from players, ...

settings_general		-- General server/gamemode settings, THIS MAY SPLIT SOMEDAY
settings_realistic		-- Realistic things, like damage, ...
settings_groupsandroles	-- Factions, Groups, ROLES, ...
levelsystem				-- Manage levelsystem
settings_design			-- Design of interface and HUD, also font
settings_map			-- Map things for gamemode, Spawnpoints, dealers, ...

settings_database		-- Database tables, remove or change to mysql
settings_usergroup		-- Manage Usergroups
whitelist				-- Whitelist roles, groups, ...
blacklist				-- NEW! disallow items for inventory pickup 

settings_yourrp_addons	-- Other yourrp addons are here
]]
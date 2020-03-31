--Copyright (C) 2017-2020 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

-- #WHITELIST

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

include("cl_settings_server_yourrp_addons.lua")

local _yrp_settings = {}
_yrp_settings.design = {}
_yrp_settings.design.mode = "dark"
_yrp_settings.materials = {}
_yrp_settings.materials.logo100 = Material("vgui/yrp/logo100_beta.png")
_yrp_settings.materials.dark = {}
_yrp_settings.materials.dark.close = Material("vgui/yrp/dark_close.png")
_yrp_settings.materials.dark.settings = Material("vgui/yrp/dark_settings.png")
_yrp_settings.materials.dark.burger = Material("vgui/yrp/dark_burger.png")
_yrp_settings.materials.light = {}
_yrp_settings.materials.light.close = Material("vgui/yrp/light_close.png")
_yrp_settings.materials.light.settings = Material("vgui/yrp/light_settings.png")
_yrp_settings.materials.light.burger = Material("vgui/yrp/light_burger.png")

settingsWindow = settingsWindow or {}

function get_icon_burger_menu()
	return _yrp_settings.materials[_yrp_settings.design.mode].burger
end

function F8RequireUG(site, usergroups)
	local ply = LocalPlayer()
	local ugs = string.Explode(", ", usergroups)

	if !pa(settingsWindow) then return end
	if !pa(settingsWindow.window) then return end
	if !pa(settingsWindow.window.site) then return end

	local allugs = {}
	allugs["USERGROUPS"] = usergroups
	local notallowed = createD("DPanel", settingsWindow.window.site, settingsWindow.window.site:GetWide(), settingsWindow.window.site:GetTall(), 0, 0)
	function notallowed:Paint(w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 255))
		surfaceText(YRP.lang_string("LID_settings_yourusergrouphasnopermission") .. " [ " .. site .. " ]", "Y_24_500", w / 2, h / 2, Color(255, 0, 0), 1, 1)

		if site != "usergroups" then
			surfaceText(YRP.lang_string("LID_settings_gotof8usergroups"), "Y_24_500", w / 2, h / 2 + YRP.ctr(100), Color(255, 255, 0), 1, 1)
		else
			surfaceText(YRP.lang_string("LID_settings_giveyourselftheusergroup", allugs), "Y_24_500", w / 2, h / 2 + YRP.ctr(100), Color(255, 255, 0), 1, 1)
			surfaceText("(In Server Console) Example:", "Y_24_500", w / 2, h / 2 + YRP.ctr(250), Color(255, 255, 0), 1, 1)
		end
	end

	if site == "usergroups" then
		for i, v in pairs(ugs) do
			local example = createD("DTextEntry", settingsWindow.window.site, YRP.ctr(1000), YRP.ctr(50), settingsWindow.window.site:GetWide() / 2 - YRP.ctr(1000 / 2), settingsWindow.window.site:GetTall() / 2 + YRP.ctr(300) + (i - 1) * YRP.ctr(60))
			example:SetText("yrp_usergroup \"" .. ply:SteamName() .. "\" " .. v)
		end
	end
end

local delaysettings = 0
function toggleSettings()
	if YRPIsNoMenuOpen() then
		if delaysettings < CurTime() then
			delaysettings = CurTime() + 2
			OpenSettings()
		else
			CloseSettings()
			notification.AddLegacy("SETTINGS MENU IS ON COOLDOWN", NOTIFY_GENERIC, 2)
		end
	else
		CloseSettings()
	end
end

concommand.Add("yrp_open_settings", function(ply, cmd, args)
	printGM("gm", "Open settings window")
	OpenSettings()
end)

function CloseSettings()
	if settingsWindow.window != NULL and settingsWindow.window != nil then
		closeMenu()
		settingsWindow.window:Remove()
		settingsWindow.window = nil
	end
end

local SAVE_CATE = "" --"LID_settings_server_gameplay"
local SAVE_SITE = "" --"open_server_general"
local maximised = false
function SaveLastSite()
	
end

function OpenSettings()
	local lply = LocalPlayer()
	openMenu()

	YRPCheckVersion()

	settingsWindow.window = createD("YFrame", nil, BFW(), BFH(), BPX(), BPY())
	settingsWindow.window:Center()
	settingsWindow.window:MakePopup()
	settingsWindow.window:SetTitle("LID_chooseapage")
	settingsWindow.window:SetMaximised(maximised)
	settingsWindow.window:SetBorder(0)
	settingsWindow.window:SetDraggable(true)
	settingsWindow.window:SetMinWidth(100)
	settingsWindow.window:SetMinHeight(100)
	settingsWindow.window:Sizable(true)
	settingsWindow.window:SetMaximised(LocalPlayer():GetDBool("settingsmaximised", nil), "SETTING")
	
	local tmp = settingsWindow.window

	-- LOGO
	local logoS = tmp:GetHeaderHeight() - YRP.ctr(20)
	tmp.logo = createD("YPanel", tmp, YRP.ctr(200), logoS, tmp:GetWide() / 2 - YRP.ctr(200), YRP.ctr(10))
	tmp.logo.yrp = Material("vgui/yrp/logo100_beta.png")
	function tmp.logo:Paint(pw, ph)
		--draw.RoundedBox(0, 0, 0, pw, ph, Color(255, 0, 0))
		surface.SetDrawColor(255, 255, 255, 255)
		surface.SetMaterial(self.yrp)
		surface.DrawTexturedRect(0, 0, 400 * logoS / 130, 130 * logoS / 130)

		self.w = self.w or 0
		if self.w != 400 * logoS / 130 or self.h != logoS or self.x != tmp:GetWide() / 2 - self.w or self.y != YRP.ctr(10) then
			self.w = 400 * logoS / 130
			self.h = logoS
			self.x = tmp:GetWide() / 2 - self.w
			self.y = YRP.ctr(10)

			self:SetSize(self.w, self.h)
			self:SetPos(self.x, self.y)
		end
	end

	-- DISCORD
	local icon_size = tmp:GetHeaderHeight() - YRP.ctr(20)
	local icon_x, icon_y = tmp.logo:GetPos()
	icon_x = icon_x + tmp.logo:GetWide() + YRP.ctr(20)
	tmp.discord = createD("YPanel", tmp, icon_size, icon_size, icon_x, icon_y)
	tmp.discord.logo = createD("DHTML", tmp.discord, icon_size, icon_size, 0, 0)
	tmp.discord.btn = createD("DButton", tmp.discord, icon_size, icon_size, 0, 0)
	tmp.discord.btn:SetText("")
	local img = GetHTMLImage("https://discordapp.com/assets/f8389ca1a741a115313bede9ac02e2c0.svg", icon_size, icon_size)
	tmp.discord.logo:SetHTML(img)
	function tmp.discord:Paint(pw, ph)
		icon_size = tmp:GetHeaderHeight() - YRP.ctr(20)
		icon_x, icon_y = tmp.logo:GetPos()
		icon_x = icon_x + tmp.logo:GetWide() + YRP.ctr(20)
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
	function tmp.discord.btn:Paint(pw, ph)
	end
	function tmp.discord.btn:DoClick()
		gui.OpenURL("https://discord.gg/CXXDCMJ")
	end

	function settingsWindow.window:AddCategory(str, icon)
		self.cats = self.cats or {}

		self.cats[str] = {}
		self.cats[str].icon = icon or self.cats[str].icon
		self.cats[str].icon = Material(self.cats[str].icon)
		
		self.cats[str]["id"] = table.Count(self.cats)

		self.cats[str].sites = self.cats[str].sites or {}
	end

	function settingsWindow.window:AddSite(cat, str, lstr, icon, bo)
		if !lply:GetDBool(bo, false) then
			return
		end

		self.cats[cat].sites[str] = self.cats[cat].sites[str] or {}
		self.cats[cat].sites[str].lstr = lstr
		self.cats[cat].sites[str].icon = Material(icon)
		self.cats[cat].sites[str]["id"] = table.Count(self.cats[cat].sites)
	end

	function settingsWindow.window:ChangedSize()
		self.menubg:SetSize(self._mw, self:GetTall() - self:GetHeaderHeight() - self._bh)
		self.menubg:SetPos(0, self:GetHeaderHeight())

		self.menu:SetSize(self._is, self.menubg:GetTall() - 2 * self._mb)
		self.menu:SetPos(self._mb, self._mb)
		function self.menu:Paint(pw, ph)
			--draw.RoundedBox(0, 0, 0, pw, ph, Color(255, 100, 100, 100))
		end

		self.botbar:SetSize(self:GetWide(), self._bh)
		self.botbar:SetPos(0, self:GetTall() - self._bh)

		self.site:SetSize(self:GetWide() - self._mw, self:GetTall() - self:GetHeaderHeight() - self._bh)
		self.site:SetPos(self._mw, self:GetHeaderHeight())
	end

	function settingsWindow.window:CloseAll()
		if self.menu != nil then
			for i, v in pairs(self.menu:GetItems()) do
				v.btn:Close()
				v.list:CloseAll()
				settingsWindow.window.site:Clear()
				settingsWindow.window:SetTitle(YRP.lang_string("LID_chooseapage"))
			end
		end
	end

	function settingsWindow.window:CreateMenu()
		self._is = YRP.ctr(120) 					-- Icon Size
		self._mb = YRP.ctr(20)						-- Menu Border
		self._mw = self._is + 2 * self._mb		-- Menu Width
		self._bh = YRP.ctr(50)						-- Bottombar Height

		self.menubg = createD("DPanel", self, 10, 10, 0, 0)
		function self.menubg:Paint(pw, ph)
			draw.RoundedBox(0, 0, 0, pw, ph, lply:InterfaceValue("YFrame", "NC"))
		end
		self.menu = createD("DPanelList", self.menubg, 10, 10, 0, 0)
		self.menu:SetSpacing(self._mb * 2)

		self.botbar = createD("DPanel", self, 10, 10, 0, 0)
		function self.botbar:Paint(pw, ph)
			draw.RoundedBox(0, 0, 0, pw, ph, lply:InterfaceValue("YFrame", "NC"))

			draw.SimpleText(GetGlobalDString("text_server_name", "-"), "Y_18_500", ph / 2, ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			draw.SimpleText("YourRP Version.: " .. GAMEMODE.Version .. " (" .. string.upper(GAMEMODE.dedicated) .. " Server)", "Y_18_500", pw / 2, ph / 2, GetVersionColor(), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.SimpleText(YRP.lang_string("LID_map") .. ": " .. game.GetMap() .. "        " .. YRP.lang_string("LID_players") .. ": " .. table.Count(player.GetAll()) .. "/" .. game.MaxPlayers(), "Y_18_500", pw - ph / 2, ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
		end

		self.site = createD("DPanel", self, 10, 10, 0, 0)
		function self.site:Paint(pw, ph)
			draw.RoundedBox(0, 0, 0, pw, ph, lply:InterfaceValue("YFrame", "BG"))
		end

		self:ChangedSize()

		for cname, c in SortedPairsByMemberValue(self.cats, "id") do
			local cat = createD("DPanel", nil, self._is, self._is, 0, 0)
			cat.main = self
			function cat:Paint(pw, ph)
				draw.RoundedBox(ph / 2, 0, 0, pw, ph, lply:InterfaceValue("YFrame", "PC"))
			end

			cat.list = createD("DPanelList", cat, self._is, 0, 0, 0)
			cat.list.main = self
			cat.list:SetSpacing(self._mb)
			function cat.list:Paint(pw, ph)
				draw.RoundedBox(ph / 2, 0, 0, pw, ph, lply:InterfaceValue("YFrame", "PC"))
			end
			function cat.list:CloseAll()
				for i, v in pairs(cat.list:GetItems()) do
					v:Close()
				end
			end

			cat.btn = createD("DButton", cat, self._is, self._is, 0, 0)
			cat.btn.main = self
			cat.btn:SetText("")
			cat.btn.name = cname
			cat.btn.list = cat.list
			function cat.btn:Paint(pw, ph)
				--self.r = self.r or 0
				self.col = self.cor or lply:InterfaceValue("YFrame", "HI")
				if self._sel then
					self.col = lply:InterfaceValue("YFrame", "HI")
					self.col.r = math.Clamp(self.col.r + 30, 0, 255)
					self.col.g = math.Clamp(self.col.g + 30, 0, 255)
					self.col.b = math.Clamp(self.col.b + 30, 0, 255)
				else
					self.col = lply:InterfaceValue("YFrame", "HI")
				end

				if self:IsHovered() or self._sel then
					--self.r = self.r - 1
				else
					--self.r = self.r + 1
				end
				--self.r = math.Clamp(self.r, 10, ph / 2)
				draw.RoundedBox(0, 0, 0, pw, ph, self.col)

				surface.SetDrawColor(255, 255, 255, 255)
				surface.SetMaterial(c.icon)
				surface.DrawTexturedRect(ph * 0.1, ph * 0.1, ph * 0.8, ph * 0.8)

				local text = YRP.lang_string(self.name)
				surface.SetFont("Y_18_700")
				local tw, th = surface.GetTextSize(text)
				self.tx = self.tx or pw / 2
				if tw > pw then
					self.tx = self.tx - 0.5
					if self.tx < -tw / 1.5 then
						self.tx = tw * 1.5
					end
				end
				draw.SimpleText(text, "Y_18_700", self.tx, ph / 2, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
			function cat.btn:Close()
				self._sel = false
				cat:SetTall(self.main._is)
				cat.list:SetTall(self.main._is)

				self.main.menu:Rebuild()
			end
			function cat.btn:Open()
				self._sel = true
				cat:SetTall((table.Count(c.sites) + 1) * (self.main._is + self.main._mb) - self.main._mb)
				cat.list:SetTall(cat:GetTall() - (self.main._is + self.main._mb))
				cat.list:SetPos(0, self.main._is + self.main._mb)
				
				self.main.menu:Rebuild()
			end
			function cat.btn:DoClick()
				self._sel = self._sel or false

				self._sel = !self._sel

				if self._sel then
					self.main:CloseAll()
					self:Open()
				else
					self:Close()
				end
			end
			settingsWindow.window.cats[cname].btn = cat.btn
			if table.Count(c.sites) == 0 then
				cat:Remove()
				continue
			end
			for i, s in SortedPairsByMemberValue(c.sites, "id") do
				local site = createD("DButton", nil, cat.btn.main._is, cat.btn.main._is, 0, 0)
				site:SetText("")
				site.hook = i
				site.name = s.lstr
				site.icon = s.icon
				function site:Paint(pw, ph)
					--self.r = self.r or 0
					self.col = self.cor or lply:InterfaceValue("YFrame", "HI")
					if self._sel then
						self.col = lply:InterfaceValue("YFrame", "HI")
						self.col.r = math.Clamp(self.col.r + 40, 0, 255)
						self.col.g = math.Clamp(self.col.g + 40, 0, 255)
						self.col.b = math.Clamp(self.col.b + 40, 0, 255)
					else
						self.col = lply:InterfaceValue("YFrame", "HI")
					end

					if self:IsHovered() or self._sel then
						--self.r = self.r - 1
					else
						--self.r = self.r + 1
					end
					--self.r = math.Clamp(self.r, 10, ph / 2)
					draw.RoundedBox(ph / 2, 0, 0, pw, ph, self.col)
	
					surface.SetDrawColor(255, 255, 255, 255)
					surface.SetMaterial(self.icon)
					surface.DrawTexturedRect(ph * 0.2, ph * 0.2, ph * 0.6, ph * 0.6)
	
					local text = YRP.lang_string(self.name)
					surface.SetFont("Y_18_700")
					local tw, th = surface.GetTextSize(text)
					self.tx = self.tx or pw / 2
					if tw > pw then
						self.tx = self.tx - 0.5
						if self.tx < -tw / 1.5 then
							self.tx = tw * 1.5
						end
					end
					draw.SimpleText(text, "Y_18_700", self.tx, ph / 2, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				end
				function site:DoClick()
					SAVE_CATE = cname
					SAVE_SITE = i

					tmp:SetTitle(string.upper(YRP.lang_string(site.name)))

					cat.list:CloseAll()

					site:Open()

					settingsWindow.window.site:Clear()

					hook.Call(self.hook)
				end
				function site:Close()
					self._sel = false
				end
				function site:Open()
					self._sel = true
				end

				settingsWindow.window.cats[cname].sites[i].btn = site

				cat.list:AddItem(site)
			end

			self.menu:AddItem(cat)
		end
	end

	function settingsWindow.window:SwitchToSite(cat, site)
		function self.site:Paint(pw, ph)
			draw.RoundedBox(0, 0, 0, pw, ph, lply:InterfaceValue("YFrame", "BG"))
		end
	
		if self.cats[cat] != nil then
			self.cats[cat].btn:DoClick()
			if self.cats[cat].sites[site] != nil then
				function self.site:Paint(pw, ph)
					draw.RoundedBox(0, 0, 0, pw, ph, lply:InterfaceValue("YFrame", "BG"))
				end
				self.cats[cat].sites[site].btn:DoClick()
			else
				function self.site:Paint(pw, ph)
					draw.RoundedBox(0, 0, 0, pw, ph, lply:InterfaceValue("YFrame", "BG"))
					draw.SimpleText(YRP.lang_string("LID_settings_yourusergrouphasnopermission"), "Y_30_500", pw / 2, ph / 2, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				end
			end
		else
			function self.site:Paint(pw, ph)
				draw.RoundedBox(0, 0, 0, pw, ph, lply:InterfaceValue("YFrame", "BG"))
				draw.SimpleText(YRP.lang_string("LID_settings_yourusergrouphasnopermission"), "Y_30_500", pw / 2, ph / 2, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
		end
	end



	--Sites
	local SV_USERMANAGEMENT = "LID_usermanagement"
	settingsWindow.window:AddCategory(SV_USERMANAGEMENT, "icon16/user.png")
	settingsWindow.window:AddSite(SV_USERMANAGEMENT, "open_server_give", "LID_settings_players", "icon16/group.png", "bool_players")
	settingsWindow.window:AddSite(SV_USERMANAGEMENT, "open_server_whitelist", "LID_whitelist", "icon16/page_white_add.png", "bool_whitelist")

	local SV_MODERATION = "LID_moderation"
	settingsWindow.window:AddCategory(SV_MODERATION, "icon16/shield.png")
	settingsWindow.window:AddSite(SV_MODERATION, "open_server_status", "LID_settings_status", "icon16/error.png", "bool_status")
	settingsWindow.window:AddSite(SV_MODERATION, "open_server_groups_and_roles", "LID_settings_groupsandroles", "icon16/group_edit.png", "bool_groupsandroles")
	settingsWindow.window:AddSite(SV_MODERATION, "open_server_map", "LID_settings_map", "icon16/map_edit.png", "bool_map")
	-- character [vcard_edit.png] Character
	settingsWindow.window:AddSite(SV_MODERATION, "open_server_logs", "LID_logs", "icon16/page_white_error.png", "bool_logs")
	settingsWindow.window:AddSite(SV_MODERATION, "open_server_blacklist", "LID_blacklist", "icon16/page_white_delete.png", "bool_blacklist")
	settingsWindow.window:AddSite(SV_MODERATION, "open_server_feedback", "LID_settings_feedback", "icon16/user_comment.png", "bool_feedback")
	
	local SV_ADMINISTRATION = "LID_administration"
	settingsWindow.window:AddCategory(SV_ADMINISTRATION, "icon16/lightning.png")
	settingsWindow.window:AddSite(SV_ADMINISTRATION, "open_server_realistic", "LID_settings_realistic", "icon16/rainbow.png", "bool_realistic")
	settingsWindow.window:AddSite(SV_ADMINISTRATION, "open_server_shops", "LID_settings_shops", "icon16/cart_edit.png", "bool_shops")
	settingsWindow.window:AddSite(SV_ADMINISTRATION, "open_server_licenses", "LID_settings_licenses", "icon16/vcard_edit.png", "bool_licenses")
	settingsWindow.window:AddSite(SV_ADMINISTRATION, "open_server_usergroups", "LID_settings_usergroups", "icon16/user_edit.png", "bool_usergroups")
	settingsWindow.window:AddSite(SV_ADMINISTRATION, "open_server_levelsystem", "LID_levelsystem", "icon16/wand.png", "bool_levelsystem")
	settingsWindow.window:AddSite(SV_ADMINISTRATION, "open_server_design", "LID_settings_design", "icon16/picture_edit.png", "bool_design")
	settingsWindow.window:AddSite(SV_ADMINISTRATION, "open_server_scale", "LID_scale", "icon16/arrow_out.png", "bool_scale")
	-- money money.png "bool_money"

	local SV_SERVER = "LID_server"
	settingsWindow.window:AddCategory(SV_SERVER, "icon16/wrench_orange.png")
	settingsWindow.window:AddSite(SV_SERVER, "open_server_general", "LID_settings_general", "icon16/world.png", "bool_general")
	settingsWindow.window:AddSite(SV_SERVER, "open_server_console", "LID_server_console", "icon16/application_xp_terminal.png", "bool_console")
	settingsWindow.window:AddSite(SV_SERVER, "open_server_database", "LID_settings_database", "icon16/database_gear.png", "bool_ac_database")
	-- Socials [television.png]
	settingsWindow.window:AddSite(SV_SERVER, "open_server_darkrp", "DarkRP", "icon16/bomb.png", "bool_darkrp")
	
	local YRP_YOURRP = "YourRP"
	settingsWindow.window:AddCategory(YRP_YOURRP, "vgui/yrp/icon24.png")
	settingsWindow.window:AddSite(YRP_YOURRP, "open_server_yourrp_addons", "LID_settings_yourrp_addons", "icon16/plugin.png", "bool_yourrp_addons")



	settingsWindow.window:CreateMenu()
	settingsWindow.window:SwitchToSite(SAVE_CATE, SAVE_SITE)
	
	--[[

	--StartSite
	settingsWindow.window:SwitchToSite(SAVE_SITE)
	settingsWindow.window:SetMaximised(LocalPlayer():GetDBool("settingsmaximised", nil), "SETTING")

	--"https://discordapp.com/assets/4f004ac9be168ac6ee18fc442a52ab53.svg")
	--"https://discord.gg/CXXDCMJ")

	]]
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
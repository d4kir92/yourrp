--Copyright (C) 2017-2019 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

-- OLD Sites
include("cl_settings_client_charakter.lua")
include("cl_settings_client_keybinds.lua")
include("cl_settings_server_give.lua")
include("cl_settings_server_licenses.lua")
include("cl_settings_server_shops.lua")
include("cl_settings_server_map.lua")
include("cl_settings_server_whitelist.lua")

-- CLIENT

-- WIP

--SERVER
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

	local allugs = {}
	allugs["USERGROUPS"] = usergroups
	function settingsWindow.window.site:Paint(w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 255))
		surfaceText(YRP.lang_string("LID_settings_yourusergrouphasnopermission") .. " [ " .. site .. " ]", "roleInfoHeader", w / 2, h / 2, Color(255, 0, 0), 1, 1)

		if site != "usergroups" then
			surfaceText(YRP.lang_string("LID_settings_gotof8usergroups"), "roleInfoHeader", w / 2, h / 2 + YRP.ctr(100), Color(255, 255, 0), 1, 1)
		else
			surfaceText(YRP.lang_string("LID_settings_giveyourselftheusergroup", allugs), "roleInfoHeader", w / 2, h / 2 + YRP.ctr(100), Color(255, 255, 0), 1, 1)
			surfaceText("(In Server Console) Example:", "roleInfoHeader", w / 2, h / 2 + YRP.ctr(250), Color(255, 255, 0), 1, 1)
		end
	end

	if site == "usergroups" then
		for i, v in pairs(ugs) do
			local example = createD("DTextEntry", settingsWindow.window.site, YRP.ctr(1000), YRP.ctr(50), settingsWindow.window.site:GetWide() / 2 - YRP.ctr(1000 / 2), settingsWindow.window.site:GetTall() / 2 + YRP.ctr(300) + (i - 1) * YRP.ctr(60))
			example:SetText("yrp_usergroup \"" .. ply:SteamName() .. "\" " .. v)
		end
	end
end

function toggleSettings()
	if isNoMenuOpen() then
		OpenSettings()
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

local _save_site = "open_client_character"

function SaveLastSite()
	if pa(settingsWindow) and settingsWindow.window.lastsite != "" then
		_save_site = settingsWindow.window.lastsite
	end
end

function OpenSettings()
	openMenu()

	YRPCheckVersion()

	settingsWindow.window = createMDMenu(nil, ScrW(), ScrH(), 0, 0)

	function settingsWindow.window:Paint(pw, ph)
		--
	end

	function settingsWindow.window:OnClose()
		closeMenu()
	end

	function settingsWindow.window:OnRemove()
		closeMenu()
	end

	--Sites
	local _client = YRP.lang_string("LID_settings_client") .. " [PROTOTYPES]"
	settingsWindow.window:AddCategory(_client)
	settingsWindow.window:AddSite("open_client_character", "LID_settings_character", _client, "icon16/user_edit.png")
	settingsWindow.window:AddSite("open_client_keybinds", "LID_settings_keybinds", _client, "icon16/keyboard.png")

	local _server_admin = YRP.lang_string("LID_settings_server") .. " [PROTOTYPES]"
	settingsWindow.window:AddCategory(_server_admin)
	settingsWindow.window:AddSite("open_server_give", "LID_settings_players", _server_admin, "icon16/user_edit.png")
	settingsWindow.window:AddSite("open_server_licenses", "LID_settings_licenses", _server_admin, "icon16/vcard_edit.png")
	settingsWindow.window:AddSite("open_server_shops", "LID_settings_shops", _server_admin, "icon16/basket_edit.png")
	settingsWindow.window:AddSite("open_server_map", "LID_settings_map", _server_admin, "icon16/map.png")
	settingsWindow.window:AddSite("open_server_whitelist", "Whitelist", _server_admin, "icon16/page_white_key.png")

	--local _wip = "wip"
	--settingsWindow.window:AddCategory(_wip)


	local _settings_server_maintance = "LID_settings_server_maintance"
	settingsWindow.window:AddCategory(_settings_server_maintance)
	settingsWindow.window:AddSite("open_server_console", "LID_server_console", _settings_server_maintance, "icon16/application_xp_terminal.png")
	settingsWindow.window:AddSite("open_server_status", "LID_settings_status", _settings_server_maintance, "icon16/error.png")
	settingsWindow.window:AddSite("open_server_feedback", "LID_settings_feedback", _settings_server_maintance, "icon16/page_lightning.png")

	local _settings_server_gameplay = "LID_settings_server_gameplay"
	settingsWindow.window:AddCategory(_settings_server_gameplay)
	settingsWindow.window:AddSite("open_server_general", "LID_settings_general", _settings_server_gameplay, "icon16/server.png")
	settingsWindow.window:AddSite("open_server_realistic", "LID_settings_realistic", _settings_server_gameplay, "icon16/bomb.png")
	settingsWindow.window:AddSite("open_server_groups_and_roles", "LID_settings_groupsandroles", _settings_server_gameplay, "icon16/group.png")
	settingsWindow.window:AddSite("open_server_levelsystem", "LID_levelsystem", _settings_server_gameplay, "icon16/layers.png")
	settingsWindow.window:AddSite("open_server_design", "LID_settings_design", _settings_server_gameplay, "icon16/photo.png")

	local _settings_server_management = "LID_settings_server_management"
	settingsWindow.window:AddCategory(_settings_server_management)
	settingsWindow.window:AddSite("open_server_database", "LID_settings_database", _settings_server_management, "icon16/database.png")
	settingsWindow.window:AddSite("open_server_usergroups", "LID_settings_usergroups", _settings_server_management, "icon16/group_go.png")

	local _server_addons = "LID_settings_server_addons"
	settingsWindow.window:AddCategory(_server_addons)
	settingsWindow.window:AddSite("open_server_yourrp_addons", "LID_settings_yourrp_addons", _server_addons, "icon16/plugin.png")

	--StartSite
	settingsWindow.window.cursite = "character"
	settingsWindow.window:SwitchToSite(_save_site)
	--Mainbar
	local mainBar = createD("DPanel", settingsWindow.window, ScrW(), YRP.ctr(100), 0, 0)

	function mainBar:Paint(pw, ph)
		draw.RoundedBox(0, 0, 0, pw, ph, YRPGetColor("5"))
		surface.SetDrawColor(255, 255, 255, 255)
		surface.SetMaterial(_yrp_settings.materials.logo100)
		surface.DrawTexturedRect(YRP.ctr(610), YRP.ctr(10), YRP.ctr(400 * 0.6), YRP.ctr(130 * 0.6))

		local _singleplayer = ""

		if game.SinglePlayer() then
			_singleplayer = "Singleplayer"
		end

		local _color = GetVersionColor()
		draw.SimpleTextOutlined(_singleplayer .. " (" .. GAMEMODE.dedicated .. " Server) YourRP V.: " .. GAMEMODE.Version .. " by D4KiR", "mat1header", YRP.ctr(610 + 400 * 0.6 + 10), ph / 2, Color(_color.r, _color.g, _color.b, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
	end

	YRP.DChangeLanguage(settingsWindow.window, ScrW() - YRP.ctr(310), YRP.ctr(10), YRP.ctr(120))
	local feedback = createD("DButton", settingsWindow.window, YRP.ctr(500), YRP.ctr(80), ScrW() - YRP.ctr(820), YRP.ctr(10))
	feedback:SetText("")

	function feedback:Paint(pw, ph)
		local color = YRPGetColor("2")

		if self:IsHovered() then
			color = YRPGetColor("1")
		end

		color.a = 200
		draw.RoundedBox(ph / 4, 0, 0, pw, ph, color)
		draw.SimpleTextOutlined(YRP.lang_string("LID_givefeedback"), "mat1text", pw / 2, ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
	end

	function feedback:DoClick()
		CloseSettings()
		openFeedbackMenu()
	end

	local _bg = createD("HTML", settingsWindow.window, YRP.ctr(500 - 8), YRP.ctr(80 - 12), ScrW() - YRP.ctr(820 + 500 + 10 - 6), YRP.ctr(10 + 6))
	_bg:OpenURL("https://discordapp.com/assets/4f004ac9be168ac6ee18fc442a52ab53.svg")
	local liveSupport = createD("DButton", settingsWindow.window, YRP.ctr(500), YRP.ctr(80), ScrW() - YRP.ctr(820 + 500 + 10), YRP.ctr(10))
	liveSupport:SetText("")

	function liveSupport:DoClick()
		gui.OpenURL("https://discord.gg/CXXDCMJ")
	end

	function liveSupport:Paint(pw, ph)
		local color = YRPGetColor("2")

		if self:IsHovered() then
			color = YRPGetColor("1")
		end

		color.a = 200
		draw.RoundedBox(ph / 4, 0, 0, pw, ph, color)
		draw.SimpleTextOutlined(YRP.lang_string("LID_getlivesupport"), "mat1text", pw / 2, ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
	end

	local exitButton = createD("DButton", mainBar, YRP.ctr(80), YRP.ctr(80), ScrW() - YRP.ctr(80 + 10), YRP.ctr(10))
	exitButton:SetText("")

	function exitButton:Paint(pw, ph)
		local color = YRPGetColor("2")

		if self:IsHovered() then
			color = YRPGetColor("1")
		end

		draw.RoundedBox(ph / 2, 0, 0, pw, ph, color)
		surface.SetDrawColor(YRPGetColor("6"))
		surface.SetMaterial(_yrp_settings.materials[_yrp_settings.design.mode].close)
		surface.DrawTexturedRect(YRP.ctr(15), YRP.ctr(15), YRP.ctr(50), YRP.ctr(50))
	end

	function exitButton:DoClick()
		if settingsWindow.window != nil then
			settingsWindow.window:Remove()
			settingsWindow.window = nil
		end
	end

	local burgerMenu = createD("DButton", mainBar, YRP.ctr(600 - 10 * 2), YRP.ctr(80), YRP.ctr(10), YRP.ctr(10))
	burgerMenu:SetText("")

	function burgerMenu:Paint(pw, ph)
		draw.RoundedBox(ph / 2, 0, 0, pw, ph, YRPGetColor("4"))
		local color = YRPGetColor("2")

		if self:IsHovered() then
			color = YRPGetColor("1")
		end

		draw.RoundedBox(ph / 2, 0, 0, ph, ph, color)
		surface.SetDrawColor(YRPGetColor("6"))
		surface.SetMaterial(_yrp_settings.materials[_yrp_settings.design.mode].burger)
		surface.DrawTexturedRect(YRP.ctr(15), YRP.ctr(15), YRP.ctr(50), YRP.ctr(50))
		draw.SimpleTextOutlined(string.upper(YRP.lang_string("LID_menu")), "mat1text", YRP.ctr(90), YRP.ctr(40), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
	end

	function burgerMenu:DoClick()
		if settingsWindow.window != NULL then
			settingsWindow.window:openMenu()
		end
	end

	settingsWindow.window:MakePopup()
end

net.Receive("setting_hasnoaccess", function(len)
	local site = net.ReadString()
	local usergroups = net.ReadString()
	F8RequireUG(YRP.lang_string(site), usergroups)
end)

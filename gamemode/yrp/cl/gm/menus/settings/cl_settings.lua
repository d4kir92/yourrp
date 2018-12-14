--Copyright (C) 2017-2018 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

-- OLD Sites
include("cl_settings_client_hud.lua")
include("cl_settings_client_charakter.lua")
include("cl_settings_client_keybinds.lua")
include("cl_settings_server_interface.lua")
include("cl_settings_server_roles.lua")
include("cl_settings_server_give.lua")
include("cl_settings_server_licenses.lua")
include("cl_settings_server_shops.lua")
include("cl_settings_server_map.lua")
include("cl_settings_server_whitelist.lua")

-- CLIENT

-- WIP
include("cl_settings_server_groups_and_roles.lua")

--SERVER
include("cl_settings_server_status.lua")
include("cl_settings_server_feedback.lua")

include("cl_settings_server_general.lua")
include("cl_settings_server_realistic.lua")

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
	local tab = {}
	tab[1] = usergroups

	function settingsWindow.window.site:Paint(w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 255))
		surfaceText(YRP.lang_string("LID_settings_yourusergrouphasnopermission") .. " [ " .. site .. " ]", "roleInfoHeader", w / 2, h / 2, Color(255, 0, 0), 1, 1)

		if site ~= YRP.lang_string("LID_usergroups") then
			surfaceText(YRP.lang_string("LID_settings_gotof8usergroups"), "roleInfoHeader", w / 2, h / 2 + ctr(100), Color(255, 255, 0), 1, 1)
		else
			surfaceText(YRP.replace_string(YRP.lang_string("LID_settings_giveyourselftheusergroup"), tab), "roleInfoHeader", w / 2, h / 2 + ctr(100), Color(255, 255, 0), 1, 1)
			surfaceText("(In Server Console) Example:", "roleInfoHeader", w / 2, h / 2 + ctr(250), Color(255, 255, 0), 1, 1)
		end
	end

	if site == YRP.lang_string("LID_usergroups") then
		local first_usergroup = string.Explode(",", tab[1])
		local example = createD("DTextEntry", settingsWindow.window.site, ctr(1000), ctr(50), settingsWindow.window.site:GetWide() / 2 - ctr(1000 / 2), settingsWindow.window.site:GetTall() / 2 + ctr(300))
		example:SetText("yrp_usergroup \"" .. ply:SteamName() .. "\" " .. first_usergroup[1])
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
	if settingsWindow.window ~= NULL and settingsWindow.window ~= nil then
		closeMenu()
		settingsWindow.window:Remove()
		settingsWindow.window = nil
	end
end

local _save_site = "open_client_character"

function SaveLastSite()
	if pa(settingsWindow) and settingsWindow.window.lastsite ~= "" then
		_save_site = settingsWindow.window.lastsite
	end
end

function OpenSettings()
	openMenu()

	testVersion()

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
	settingsWindow.window:AddSite("open_client_character", "settings_character", _client, "icon16/user_edit.png")
	settingsWindow.window:AddSite("open_client_hud", "settings_hud", _client, "icon16/photo.png")
	settingsWindow.window:AddSite("open_client_keybinds", "settings_keybinds", _client, "icon16/keyboard.png")

	local _server_admin = YRP.lang_string("LID_settings_server") .. " [PROTOTYPES]"
	settingsWindow.window:AddCategory(_server_admin)
	settingsWindow.window:AddSite("open_server_interface", "settings_surface", _server_admin, "icon16/application_view_gallery.png")
	settingsWindow.window:AddSite("open_server_give", "settings_players", _server_admin, "icon16/user_edit.png")
	settingsWindow.window:AddSite("open_server_licenses", "settings_licenses", _server_admin, "icon16/vcard_edit.png")
	settingsWindow.window:AddSite("open_server_shops", "settings_shops", _server_admin, "icon16/basket_edit.png")
	settingsWindow.window:AddSite("open_server_map", "settings_map", _server_admin, "icon16/map.png")
	settingsWindow.window:AddSite("open_server_whitelist", "whitelist", _server_admin, "icon16/page_white_key.png")

	local _wip = "wip"
	settingsWindow.window:AddCategory(_wip)
	--settingsWindow.window:AddSite("open_server_roles", YRP.lang_string("LID_roles") .. " [OLD]", _wip, "icon16/group_edit.png")
	settingsWindow.window:AddSite("open_server_groups_and_roles", "settings_groupsandroles", _wip, "icon16/group.png")

	local _settings_server_maintance = "settings_server_maintance"
	settingsWindow.window:AddCategory(_settings_server_maintance)
	settingsWindow.window:AddSite("open_server_status", "settings_status", _settings_server_maintance, "icon16/error.png")
	settingsWindow.window:AddSite("open_server_feedback", "settings_feedback", _settings_server_maintance, "icon16/page_lightning.png")

	local _settings_server_gameplay = "settings_server_gameplay"
	settingsWindow.window:AddCategory(_settings_server_gameplay)
	settingsWindow.window:AddSite("open_server_general", "settings_general", _settings_server_gameplay, "icon16/server.png")
	settingsWindow.window:AddSite("open_server_realistic", "settings_realistic", _settings_server_gameplay, "icon16/bomb.png")

	local _settings_server_management = "settings_server_management"
	settingsWindow.window:AddCategory(_settings_server_management)
	settingsWindow.window:AddSite("open_server_database", "settings_database", _settings_server_management, "icon16/database.png")
	settingsWindow.window:AddSite("open_server_usergroups", "settings_usergroups", _settings_server_management, "icon16/group_go.png")

	local _server_addons = "settings_server_addons"
	settingsWindow.window:AddCategory(_server_addons)
	settingsWindow.window:AddSite("open_server_yourrp_addons", "settings_yourrp_addons", _server_addons, "icon16/plugin.png")

	--StartSite
	settingsWindow.window.cursite = "character"
	settingsWindow.window:SwitchToSite(_save_site)
	--Mainbar
	local mainBar = createD("DPanel", settingsWindow.window, ScrW(), ctr(100), 0, 0)

	function mainBar:Paint(pw, ph)
		draw.RoundedBox(0, 0, 0, pw, ph, YRPGetColor("5"))
		surface.SetDrawColor(255, 255, 255, 255)
		surface.SetMaterial(_yrp_settings.materials.logo100)
		surface.DrawTexturedRect(ctr(610), ctr(10), ctr(400 * 0.6), ctr(130 * 0.6))

		if not version_tested() then
			testVersion()
		end

		local _singleplayer = ""

		if game.SinglePlayer() then
			_singleplayer = "Singleplayer"
		end

		local _color = version_color()
		draw.SimpleTextOutlined(_singleplayer .. " (" .. GAMEMODE.dedicated .. " Server) YourRP V.: " .. GAMEMODE.Version .. " by D4KiR", "mat1header", ctr(610 + 400 * 0.6 + 10), ph / 2, Color(_color.r, _color.g, _color.b, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
	end

	YRP.DChangeLanguage(settingsWindow.window, ScrW() - ctr(310), ctr(10), ctr(120))
	local feedback = createD("DButton", settingsWindow.window, ctr(500), ctr(80), ScrW() - ctr(820), ctr(10))
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

	local _bg = createD("HTML", settingsWindow.window, ctr(500 - 8), ctr(80 - 12), ScrW() - ctr(820 + 500 + 10 - 6), ctr(10 + 6))
	_bg:OpenURL("https://discordapp.com/assets/4f004ac9be168ac6ee18fc442a52ab53.svg")
	local liveSupport = createD("DButton", settingsWindow.window, ctr(500), ctr(80), ScrW() - ctr(820 + 500 + 10), ctr(10))
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
		draw.SimpleTextOutlined(YRP.lang_string("LID_livesupport"), "mat1text", pw / 2, ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
	end

	local settingsButton = createD("DButton", mainBar, ctr(80), ctr(80), ScrW() - ctr(180), ctr(10))
	settingsButton:SetText("")

	function settingsButton:Paint(pw, ph)
		local color = YRPGetColor("2")

		if self:IsHovered() then
			color = YRPGetColor("1")
		end

		draw.RoundedBox(ph / 2, 0, 0, pw, ph, color)
		surface.SetDrawColor(YRPGetColor("6"))
		surface.SetMaterial(_yrp_settings.materials[_yrp_settings.design.mode].settings)
		surface.DrawTexturedRect(ctr(15), ctr(15), ctr(50), ctr(50))
	end

	hook.Add("open_menu_settings", "open_menu_settings", function()
		if pa(settingsWindow) then
			local w = settingsWindow.window.sitepanel:GetWide()
			local h = settingsWindow.window.sitepanel:GetTall()
			settingsWindow.window.site = createD("DPanel", settingsWindow.window.sitepanel, w, h, 0, 0)

			function settingsWindow.window.site:Paint(pw, ph)
				--
				draw.SimpleTextOutlined(YRP.lang_string("LID_color"), "mat1text", ctr(10), ctr(200), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM, 1, Color(0, 0, 0))
			end

			createMDSwitch(settingsWindow.window.site, ctr(400), ctr(80), ctr(10), ctr(10), "dark", "light", "cl_mode")
			--primary
			colorP = {}
			colorP[1] = Color(66, 66, 66, 255)
			colorP[2] = Color(21, 101, 192, 255)
			colorP[3] = Color(46, 125, 50, 255)
			colorP[4] = Color(239, 108, 0, 255)
			colorP[5] = Color(249, 168, 37, 255)
			colorP[6] = Color(78, 52, 46, 255)
			local primarybg = createD("DPanel", settingsWindow.window.site, ctr(400), ctr(200), ctr(10), ctr(200))

			for k, v in pairs(colorP) do
				addPColorField(primarybg, v, ctr(10 + (k - 1) * 60), ctr(10))
			end

			--secondary
			colorS = {}
			colorS[1] = Color(117, 117, 117, 255)
			colorS[2] = Color(30, 136, 229, 255)
			colorS[3] = Color(67, 160, 71, 255)
			colorS[4] = Color(251, 140, 0, 255)
			colorS[5] = Color(253, 216, 53, 255)
			colorS[6] = Color(109, 76, 65, 255)
			local secondarybg = createD("DPanel", settingsWindow.window.site, ctr(400), ctr(200), ctr(500), ctr(200))

			for k, v in pairs(colorS) do
				addSColorField(secondarybg, v, ctr(10 + (k - 1) * 60), ctr(10))
			end
		end
	end)

	function settingsButton:DoClick()
		if settingsWindow.window ~= NULL then
			settingsWindow.window:SwitchToSite("open_menu_settings")
		end
	end

	local exitButton = createD("DButton", mainBar, ctr(80), ctr(80), ScrW() - ctr(80 + 10), ctr(10))
	exitButton:SetText("")

	function exitButton:Paint(pw, ph)
		local color = YRPGetColor("2")

		if self:IsHovered() then
			color = YRPGetColor("1")
		end

		draw.RoundedBox(ph / 2, 0, 0, pw, ph, color)
		surface.SetDrawColor(YRPGetColor("6"))
		surface.SetMaterial(_yrp_settings.materials[_yrp_settings.design.mode].close)
		surface.DrawTexturedRect(ctr(15), ctr(15), ctr(50), ctr(50))
	end

	function exitButton:DoClick()
		if settingsWindow.window ~= NULL then
			settingsWindow.window:Remove()
			settingsWindow.window = nil
		end
	end

	local burgerMenu = createD("DButton", mainBar, ctr(600 - 10 * 2), ctr(80), ctr(10), ctr(10))
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
		surface.DrawTexturedRect(ctr(15), ctr(15), ctr(50), ctr(50))
		draw.SimpleTextOutlined(string.upper(YRP.lang_string("LID_menu")), "mat1text", ctr(90), ctr(40), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 255))
	end

	function burgerMenu:DoClick()
		if settingsWindow.window ~= NULL then
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

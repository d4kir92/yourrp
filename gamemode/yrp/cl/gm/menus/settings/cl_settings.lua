--Copyright (C) 2017-2019 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

-- #WHITELIST

-- OLD Sites
include("cl_settings_client_charakter.lua")
include("cl_settings_client_keybinds.lua")
include("cl_settings_server_give.lua")
include("cl_settings_server_licenses.lua")
include("cl_settings_server_shops.lua")
include("cl_settings_server_map.lua")
include("cl_settings_server_whitelist.lua")
include("cl_settings_server_logs.lua")

-- CLIENT

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

	if !pa(settingsWindow) then return end
	if !pa(settingsWindow.window) then return end
	if !pa(settingsWindow.window.site) then return end

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

local delaysettings = 0
function toggleSettings()
	if isNoMenuOpen() then
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

local _save_site = "open_server_general"
local maximised = false
function SaveLastSite()
	if pa(settingsWindow) and settingsWindow.window.lastsite != "" then
		_save_site = settingsWindow.window.lastsite
	end
end

function OpenSettings()
	openMenu()

	YRPCheckVersion()

	settingsWindow.window = createMDMenu(nil, BFW(), BFH(), BPX(), BPY())
	settingsWindow.window:SetMaximised(maximised)

	function settingsWindow.window:OnClose()
		closeMenu()
	end

	function settingsWindow.window:OnRemove()
		closeMenu()
	end

	--Sites
	local _server_prototypes = YRP.lang_string("LID_settings_server") .. " [PROTOTYPES]"
	settingsWindow.window:AddCategory(_server_prototypes)
	settingsWindow.window:AddSite("open_server_give", "LID_settings_players", _server_prototypes, "icon16/user_edit.png")
	settingsWindow.window:AddSite("open_server_licenses", "LID_settings_licenses", _server_prototypes, "icon16/vcard_edit.png")
	settingsWindow.window:AddSite("open_server_shops", "LID_settings_shops", _server_prototypes, "icon16/basket_edit.png")
	settingsWindow.window:AddSite("open_server_logs", "LID_logs", _server_prototypes, "icon16/note.png")
	


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
	settingsWindow.window:AddSite("open_server_map", "LID_settings_map", _settings_server_gameplay, "icon16/map.png")
	


	local _settings_server_management = "LID_settings_server_management"
	settingsWindow.window:AddCategory(_settings_server_management)
	settingsWindow.window:AddSite("open_server_database", "LID_settings_database", _settings_server_management, "icon16/database.png")
	settingsWindow.window:AddSite("open_server_usergroups", "LID_settings_usergroups", _settings_server_management, "icon16/group_go.png")
	settingsWindow.window:AddSite("open_server_whitelist", "LID_whitelist", _settings_server_management, "icon16/page_white_key.png")


	
	local _server_addons = "LID_settings_server_addons"
	settingsWindow.window:AddCategory(_server_addons)
	settingsWindow.window:AddSite("open_server_yourrp_addons", "LID_settings_yourrp_addons", _server_addons, "icon16/plugin.png")



	settingsWindow.window:CreateMenu()



	--StartSite
	settingsWindow.window:SwitchToSite(_save_site)
	settingsWindow.window:SetMaximised(LocalPlayer():GetDBool("settingsmaximised", nil), "SETTING")
	--"https://discordapp.com/assets/4f004ac9be168ac6ee18fc442a52ab53.svg")
	--"https://discord.gg/CXXDCMJ")

	
	settingsWindow.window:MakePopup()
end

net.Receive("setting_hasnoaccess", function(len)
	local site = net.ReadString()
	local usergroups = net.ReadString()
	F8RequireUG(YRP.lang_string(site), usergroups)
end)

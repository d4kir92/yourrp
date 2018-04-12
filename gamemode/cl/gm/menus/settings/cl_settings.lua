--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

include( "cl_settings_client_hud.lua" )
include( "cl_settings_client_charakter.lua" )

include( "cl_settings_server_collection.lua" )
include( "cl_settings_server_general.lua" )
include( "cl_settings_server_roles.lua" )
include( "cl_settings_server_give.lua" )
include( "cl_settings_server_money.lua" )
include( "cl_settings_server_licenses.lua" )
include( "cl_settings_server_shops.lua" )
include( "cl_settings_server_map.lua" )
include( "cl_settings_server_whitelist.lua" )
include( "cl_settings_server_restriction.lua" )

include( "cl_settings_server_feedback.lua" )

include( "cl_settings_yourrp_add_langu.lua")
include( "cl_settings_yourrp_contact.lua")
include( "cl_settings_yourrp_workshop.lua")

local _yrp_settings = {}
_yrp_settings.design = {}
_yrp_settings.design.mode = "dark"
_yrp_settings.materials = {}
_yrp_settings.materials.logo100 = Material( "vgui/yrp/logo100_beta.png" )
_yrp_settings.materials.dark = {}
_yrp_settings.materials.dark.close = Material( "vgui/yrp/dark_close.png" )
_yrp_settings.materials.dark.settings = Material( "vgui/yrp/dark_settings.png" )
_yrp_settings.materials.dark.burger = Material( "vgui/yrp/dark_burger.png" )

_yrp_settings.materials.light = {}
_yrp_settings.materials.light.close = Material( "vgui/yrp/light_close.png" )
_yrp_settings.materials.light.settings = Material( "vgui/yrp/light_settings.png" )
_yrp_settings.materials.light.burger = Material( "vgui/yrp/light_burger.png" )

settingsWindow = settingsWindow or {}

function get_icon_burger_menu()
  return _yrp_settings.materials[_yrp_settings.design.mode].burger
end

concommand.Add( "yrp_toggle_settings", function( ply, cmd, args )
  printGM( "gm", "Toggling settings window" )
	toggleSettings()
end )

function toggleSettings()
  if isNoMenuOpen() then
    openSettings()
  else
    closeSettings()
  end
end

function closeSettings()
  if settingsWindow.window != NULL and settingsWindow.window != nil then
    closeMenu()
    settingsWindow.window:Remove()
    settingsWindow.window = nil
  end
end

function openSettings()
  openMenu()
  addMDColor( "dprimary", getMDPColor() )
  addMDColor( "dprimaryBG", colorBG( getMDPColor() ) )

  addMDColor( "dsecondary", getMDSColor() )
  addMDColor( "dsecondaryH", colorH( getMDSColor() ) )

  local ply = LocalPlayer()

  --Frame
  settingsWindow.window = createMDMenu( nil, ScrW(), ScrH(), 0, 0 )
  function settingsWindow.window:Paint( pw, ph )
    draw.RoundedBox( 0, 0, 0, pw, ph, get_dbg_col() )
  end
  function settingsWindow.window:OnClose()
    closeMenu()
  end
  function settingsWindow.window:OnRemove()
    closeMenu()
  end

  --Sites
  settingsWindow.window:AddCategory( lang_string( "client" ) )
  settingsWindow.window:AddSite( "open_client_character", lang_string( "character" ), lang_string( "client" ), "icon16/user_edit.png" )
  settingsWindow.window:AddSite( "open_client_hud", lang_string( "hud" ), lang_string( "client" ), "icon16/photo.png" )
  settingsWindow.window:AddSite( "open_client_keybinds", lang_string( "keybindchanger" ), lang_string( "client" ), "icon16/keyboard.png" )

  local _server = lang_string( "server" )
  settingsWindow.window:AddCategory( _server )
  settingsWindow.window:AddSite( "open_server_collection", lang_string( "workshopcollection" ), _server, "icon16/page_world.png" )
  if ply:HasAccess() then
    local _server_admin = lang_string( "server" ) .. " (" .. lang_string( "access" ) .. ": " .. tostring( lang_string( "admin" ) ) .. ")"
    settingsWindow.window:AddCategory( _server_admin )
    settingsWindow.window:AddSite( "open_server_general", lang_string( "general" ), _server_admin, "icon16/server_database.png" )
    settingsWindow.window:AddSite( "open_server_realistic", lang_string( "realistic" ), _server_admin, "icon16/bomb.png" )
    settingsWindow.window:AddSite( "open_server_roles", lang_string( "roles" ), _server_admin, "icon16/group_edit.png" )
    settingsWindow.window:AddSite( "open_server_give", lang_string( "players" ), _server_admin, "icon16/user_edit.png" )
    settingsWindow.window:AddSite( "open_server_money", lang_string( "money" ), _server_admin, "icon16/money.png" )
    settingsWindow.window:AddSite( "open_server_licenses", lang_string( "licenses" ), _server_admin, "icon16/vcard_edit.png" )
    settingsWindow.window:AddSite( "open_server_shops", lang_string( "shops" ), _server_admin, "icon16/basket_edit.png" )
    settingsWindow.window:AddSite( "open_server_map", lang_string( "map" ), _server_admin, "icon16/map.png" )
    settingsWindow.window:AddSite( "open_server_whitelist", lang_string( "whitelist" ), _server_admin, "icon16/page_white_key.png" )
    settingsWindow.window:AddSite( "open_server_restrictions", lang_string( "restriction" ), _server_admin, "icon16/group_go.png" )
    settingsWindow.window:AddSite( "open_server_feedback", lang_string( "feedback" ), _server_admin, "icon16/page_lightning.png" )
  end

  settingsWindow.window:AddCategory( "yourrp" )
  settingsWindow.window:AddSite( "open_yourp_workshop", lang_string( "workshop" ), "yourrp", "icon16/layout_content.png" )

  settingsWindow.window:AddCategory( lang_string( "settings" ) )
  settingsWindow.window:AddSite( "open_menu_settings", lang_string( "settings" ), lang_string( "settings" ), "vgui/yrp/dark_settings.png" )

  --StartSite
  settingsWindow.window.cursite = lang_string( "character" )
  settingsWindow.window:SwitchToSite( "open_client_character" )

  --Mainbar
  local mainBar = createD( "DPanel", settingsWindow.window, ScrW(), ctr( 100 ), 0, 0 )
  function mainBar:Paint( pw, ph )
    draw.RoundedBox( 0, 0, 0, pw, ph, get_dp_col() )

    surface.SetDrawColor( 255, 255, 255, 255 )
    surface.SetMaterial( _yrp_settings.materials.logo100	)
    surface.DrawTexturedRect( ctr( 100 + 400 + 10 ), ctr( 10 ), ctr( 400*0.6 ), ctr( 130*0.6 ) )

    if !version_tested() then
  		testVersion()
  	end
  	local _singleplayer = ""
  	if game.SinglePlayer() then
  		_singleplayer = "Singleplayer"
  	end
    local _color = version_color()
  	draw.SimpleTextOutlined( _singleplayer .. " (" .. GAMEMODE.dedicated .. " Server) V.: " .. GAMEMODE.Version .. " by D4KiR", "HudBars", ctr( 820 ), ph/2, Color( _color.r, _color.g, _color.b, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )

    --draw.SimpleTextOutlined( settingsWindow.cursite or "", "HudBars", pw/2, ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
  end

  local feedback = createD( "DButton", settingsWindow.window, ctr( 500 ), ctr( 80 ), ScrW() - ctr( 1860 ), ctr( 10 ) )
  feedback:SetText( "" )
  function feedback:Paint( pw, ph )
    local color = get_dsbg_col()
    if !self:IsHovered() then
      color = get_ds_col()
  	end
    color.a = 200
    draw.RoundedBox( 0, 0, 0, pw, ph, color )
    draw.SimpleTextOutlined( lang_string( "givefeedback" ), "sef", pw/2, ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
  end
  function feedback:DoClick()
    closeSettings()
    openFeedbackMenu()
  end

  local _bg = createD( "HTML", settingsWindow.window, ctr( 500-8 ), ctr( 80-12 ), ScrW() - ctr( 1350-6 ), ctr( 10+6 ) )
  _bg:OpenURL( "https://discordapp.com/assets/4f004ac9be168ac6ee18fc442a52ab53.svg" )

  local liveSupport = createD( "DButton", settingsWindow.window, ctr( 500 ), ctr( 80 ), ScrW() - ctr( 1350 ), ctr( 10 ) )
  liveSupport:SetText( "" )
  function liveSupport:DoClick()
    gui.OpenURL( "https://discord.gg/CXXDCMJ" )
  end
  function liveSupport:Paint( pw, ph )
    local color = get_dsbg_col()
    if !self:IsHovered() then
      color = get_ds_col()
  	end
    color.a = 200
    draw.RoundedBox( 0, 0, 0, pw, ph, color )
    draw.SimpleTextOutlined( lang_string( "livesupport" ), "sef", pw/2, ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
  end

  local language = createD( "DPanel", settingsWindow.window, ctr( 650 ), ctr( 80 ), ScrW() - ctr( 840 ), ctr( 10 ) )
  function language:Paint( pw, ph )
    draw.RoundedBox( 0, 0, 0, pw, ph, get_ds_col() )
    draw.SimpleTextOutlined( "Language: ", "HudBars", ctr( 250 ), ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
  end
  derma_change_language( language, ctr( 400 ), ctr( 80 ), ctr( 250 ), ctr( 0 ) )

  local settingsButton = createD( "DButton", mainBar, ctr( 80 ), ctr( 80 ), ScrW() - ctr( 180 ), ctr( 10 ) )
  settingsButton:SetText( "" )
  function settingsButton:Paint( pw, ph )
    paintMDBackground( self, pw, ph )

  	surface.SetDrawColor( 255, 255, 255, 255 )
  	surface.SetMaterial( _yrp_settings.materials[_yrp_settings.design.mode].settings	)
  	surface.DrawTexturedRect( ctr( 15 ), ctr( 15 ), ctr( 50 ), ctr( 50 ) )
  end

  hook.Add( "open_menu_settings", "open_menu_settings", function()
    local ply = LocalPlayer()

    local w = settingsWindow.window.sitepanel:GetWide()
    local h = settingsWindow.window.sitepanel:GetTall()

    settingsWindow.window.site = createD( "DPanel", settingsWindow.window.sitepanel, w, h, 0, 0 )
    function settingsWindow.window.site:Paint( pw, ph )
      draw.RoundedBox( 4, 0, 0, pw, ph, get_dbg_col() )
      draw.SimpleTextOutlined( lang_string( "color" ), "HudBars", ctr( 10 ), ctr( 200 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM, 1, Color( 0, 0, 0 ) )
    end

    local switchMode = createMDSwitch( settingsWindow.window.site, ctr( 400 ), ctr( 80 ), ctr( 10 ), ctr( 10 ), "dark", "light", "cl_mode" )

    --primary
    colorP = {}
    colorP[1] = Color( 66, 66, 66, 255 )
    colorP[2] = Color( 21, 101, 192, 255 )
    colorP[3] = Color( 46, 125, 50, 255 )
    colorP[4] = Color( 239, 108, 0, 255 )
    colorP[5] = Color( 249, 168, 37, 255 )
    colorP[6] = Color( 78, 52, 46, 255 )

    local primarybg = createD( "DPanel", settingsWindow.window.site, ctr( 400 ), ctr( 200 ), ctr( 10 ), ctr( 200 ) )

    for k, v in pairs( colorP ) do
      addPColorField( primarybg, v, ctr( 10 + (k-1)*60 ), ctr( 10 ) )
    end

    --secondary
    colorS = {}
    colorS[1] = Color( 117, 117, 117, 255 )
    colorS[2] = Color( 30, 136, 229, 255 )
    colorS[3] = Color( 67, 160, 71, 255 )
    colorS[4] = Color( 251, 140, 0, 255 )
    colorS[5] = Color( 253, 216, 53, 255 )
    colorS[6] = Color( 109, 76, 65, 255 )

    local secondarybg = createD( "DPanel", settingsWindow.window.site, ctr( 400 ), ctr( 200 ), ctr( 500 ), ctr( 200 ) )

    for k, v in pairs( colorS ) do
      addSColorField( secondarybg, v, ctr( 10 + (k-1)*60 ), ctr( 10 ) )
    end
  end)

  function settingsButton:DoClick()
    if settingsWindow.window != NULL then
      settingsWindow.window:SwitchToSite( "open_menu_settings" )
    end
  end

  local exitButton = createD( "DButton", mainBar, ctr( 80 ), ctr( 80 ), ScrW() - ctr( 80 + 10 ), ctr( 10 ) )
  exitButton:SetText( "" )
  function exitButton:Paint( pw, ph )
    paintMDBackground( self, pw, ph )

  	surface.SetDrawColor( 255, 255, 255, 255 )
  	surface.SetMaterial( _yrp_settings.materials[_yrp_settings.design.mode].close	)
  	surface.DrawTexturedRect( ctr( 15 ), ctr( 15 ), ctr( 50 ), ctr( 50 ) )
  end
  function exitButton:DoClick()
    if settingsWindow.window != NULL then
      settingsWindow.window:Remove()
      settingsWindow.window = nil
    end
  end

  local burgerMenu = createD( "DButton", mainBar, ctr( 480 ), ctr( 80 ), ctr( 10 ), ctr( 10 ) )
  burgerMenu:SetText( "" )
  function burgerMenu:Paint( pw, ph )
    draw.RoundedBox( 0, 0, 0, pw, ph, Color( 0, 0, 0, 100 ) )
    if self:IsHovered() then
      draw.RoundedBox( 0, 0, 0, ph, ph, get_dsbg_col() )
    else
      draw.RoundedBox( 0, 0, 0, ph, ph, get_ds_col() )
    end

  	surface.SetDrawColor( 255, 255, 255, 255 )
  	surface.SetMaterial( _yrp_settings.materials[_yrp_settings.design.mode].burger	)
  	surface.DrawTexturedRect( ctr( 15 ), ctr( 15 ), ctr( 50 ), ctr( 50 ) )

    draw.SimpleTextOutlined( string.upper( lang_string( "menu" ) ), "HudBars", ctr( 90 ), ctr( 40 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0, 255 ) )
  end
  function burgerMenu:DoClick()
    if settingsWindow.window != NULL then
      settingsWindow.window:openMenu()
    end
  end

  settingsWindow.window:MakePopup()
end

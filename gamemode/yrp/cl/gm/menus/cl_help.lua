--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

--[[
local HELPMENU = {}

function toggleHelpMenu()
  if isNoMenuOpen() then
    openHelpMenu()
  else
    closeHelpMenu()
  end
end

function closeHelpMenu()
  if HELPMENU.window != nil then
    closeMenu()
    HELPMENU.window:Remove()
    HELPMENU.window = nil
  end
end

function GetTextLength( text, font )
  surface.SetFont( font )
  local l, h = surface.GetTextSize( text )
  return l
end

function DrawSelector( btn, w, h, text )
  draw.SimpleTextOutlined( text, "mat1text", w/2, h/2, Color( 255, 255, 255, 255 ), 1, 1, ctr( 1 ), Color( 0, 0, 0, 255 ) )
  if btn.ani_h == nil then
    btn.ani_h = 0
  end
  if btn:IsHovered() then
    if btn.ani_h < 10 then
      btn.ani_h = btn.ani_h + 1
    end
  else
    if btn.ani_h > 0 then
      btn.ani_h = btn.ani_h - 1
    end
  end
  surfaceBox( 0, h - ctr( btn.ani_h ), w, ctr( btn.ani_h ), Color( 26, 121, 255, 255 ) )
end

function MakeHelpSpacer()
  local spacer = createD( "DButton", HELPMENU.window, ctr( 30 ), ctr( 100 ), 0, 0 )
  spacer:SetText( "" )
  function spacer:Paint( pw, ph )
  end
  return spacer
end

function openHelpMenu()

  openMenu()
  HELPMENU.window = createD( "DFrame", nil, ScrW(), ScrH(), 0, 0 )
  HELPMENU.window:MakePopup()
  HELPMENU.window:Center()
  HELPMENU.window:SetTitle( "" )
  HELPMENU.window:SetDraggable( false )
  function HELPMENU.window:Paint( pw, ph )
    surfaceBox( 0, 0, pw, ph, Color( 90, 90, 90, 100 ) )
  end

  HELPMENU.tabs = {}

  local help = lang_string( "help" )
  HELPMENU.help = createD( "DButton", HELPMENU.window, GetTextLength( help, "mat1text" ) + ctr( 30 * 2 ), ctr( 100 ), ctr( 400 ), 0 )
  HELPMENU.help:SetText( "" )
  function HELPMENU.help:Paint( pw, ph )
    DrawSelector( self, pw, ph, help )
  end
  table.insert( HELPMENU.tabs, HELPMENU.help )

  HELPMENU.spacer = MakeHelpSpacer()
  table.insert( HELPMENU.tabs, HELPMENU.spacer )

  local staff = lang_string( "staff" )
  HELPMENU.staff = createD( "DButton", HELPMENU.window, GetTextLength( staff, "mat1text" ) + ctr( 30 * 2 ), ctr( 100 ), ctr( 400 ), 0 )
  HELPMENU.staff:SetText( "" )
  function HELPMENU.staff:Paint( pw, ph )
    DrawSelector( self, pw, ph, staff )
  end
  table.insert( HELPMENU.tabs, HELPMENU.staff )

  table.insert( HELPMENU.tabs, HELPMENU.spacer )

  local collection = lang_string( "collection" )
  HELPMENU.collection = createD( "DButton", HELPMENU.window, GetTextLength( collection, "mat1text" ) + ctr( 30 * 2 ), ctr( 100 ), ctr( 400 ), 0 )
  HELPMENU.collection:SetText( "" )
  function HELPMENU.collection:Paint( pw, ph )
    DrawSelector( self, pw, ph, collection )
  end
  table.insert( HELPMENU.tabs, HELPMENU.collection )

  table.insert( HELPMENU.tabs, HELPMENU.spacer )

  local community = lang_string( "community" )
  HELPMENU.community = createD( "DButton", HELPMENU.window, GetTextLength( community, "mat1text" ) + ctr( 30 * 2 ), ctr( 100 ), ctr( 400 ), 0 )
  HELPMENU.community:SetText( "" )
  function HELPMENU.community:Paint( pw, ph )
    DrawSelector( self, pw, ph, community )
  end
  table.insert( HELPMENU.tabs, HELPMENU.community )

  table.insert( HELPMENU.tabs, HELPMENU.spacer )

  local yourrp = "YourRP"
  HELPMENU.yourrp = createD( "DButton", HELPMENU.window, GetTextLength( yourrp, "mat1text" ) + ctr( 30 * 2 ), ctr( 100 ), ctr( 400 ), 0 )
  HELPMENU.yourrp:SetText( "" )
  function HELPMENU.yourrp:Paint( pw, ph )
    DrawSelector( self, pw, ph, yourrp )
  end
  table.insert( HELPMENU.tabs, HELPMENU.yourrp )

  HELPMENU.mainmenu = createD( "DHorizontalScroller", HELPMENU.window, ctr( 100 ), ctr( 100 ), 0, 0 )
  HELPMENU.mainmenu.w = 0
  HELPMENU.mainmenu.x = 0
  for i, tab in pairs( HELPMENU.tabs ) do
    HELPMENU.mainmenu.w = HELPMENU.mainmenu.w + tab:GetWide()
    HELPMENU.mainmenu:AddPanel( tab )
  end
  HELPMENU.mainmenu:SetSize( HELPMENU.mainmenu.w, ctr( 100 ) )
  HELPMENU.mainmenu:SetPos( ScrW2() - HELPMENU.mainmenu.w/2, 0 )
end
]]--

local _hm = {}

function toggleHelpMenu()
  if isNoMenuOpen() then
    openHelpMenu()
    done_tutorial( "tut_hudhelp" )
  else
    closeHelpMenu()
  end
end

function closeHelpMenu()
  if _hm.window != nil then
    closeMenu()
    _hm.window:Remove()
    _hm.window = nil
  end
end

function replaceKeyName( str )
  if str == "uparrow" or str == "pgup" then
    return "↑"
  elseif str == "downarrow" or str == "pgdn"  then
    return "↓"
  elseif str == "rightarrow" then
    return "→"
  elseif str == "leftarrow" then
    return "←"
  elseif str == "home" then
    return lang_string( "numpadhome" )
  elseif str == "plus" then
    return "+"
  elseif str == "minus" then
    return "-"
  elseif str == "ins" then
    return lang_string( "keyinsert" )
  end
  return str
end

function nicekey( key_str )
  local _str = string.lower( tostring( key_str ) )
  if _str != nil then
    if string.find( _str, "kp_" ) then
      local _end = string.sub( _str, 4 )

      _end = replaceKeyName( _end )
      return lang_string( "keynumpad" ) .. " " .. _end
    elseif string.find( _str, "pg" ) then
      return lang_string( "keypage" ) .. " " .. replaceKeyName( _str )
    end
    _str = replaceKeyName( _str )
  end
  return tostring( _str )
end

function openHelpMenu()
  done_tutorial( "tut_welcome" )
  openMenu()
  _hm.window = createD( "DFrame", nil, BScrW(), ScrH(), 0, 0 )
  _hm.window:Center()
  _hm.window:SetTitle( "" )
  _hm.window:SetDraggable( false )
  function _hm.window:OnClose()
    closeMenu()
  end
  function _hm.window:OnRemove()
    closeMenu()
  end

  _hm.langu = derma_change_language( _hm.window, ctr( 400 ), ctr( 50 ), BScrW()/2, ctr( 0 ) )

  function _hm.window:Paint( pw, ph )
    surfaceWindow( self, pw, ph, lang_string( "help" ) .. " - " .. lang_string( "menu" ) )
    local _abstand = ctr( HudV("ttsf") ) * 3.8

    draw.SimpleTextOutlined( "Language: ", "ttsf", BScrW()/2 - ctr( 10 ), ctr( 25 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )

    draw.SimpleTextOutlined( "[" .. string.upper( nicekey( "F1" ) ) .. "] " .. lang_string( "help" ), "ttsf", ctr( 50 ), ctr( 10 ) + ctr( 10 + 1*_abstand ), Color( 255, 255, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
    draw.SimpleTextOutlined( "[" .. string.upper( nicekey( GetKeybindName("menu_character_selection" ) ) ) .. "] " .. lang_string( "characterselection" ), "ttsf", ctr( 50 ), ctr( 10 ) + ctr( 10 + 2*_abstand ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
    draw.SimpleTextOutlined( "[" .. string.upper( nicekey( GetKeybindName("toggle_mouse" ) ) ) .. "] " .. lang_string( "guimouse" ), "ttsf", ctr( 50 ), ctr( 10 ) + ctr( 10 ) + ctr( 3*_abstand ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
    draw.SimpleTextOutlined( "[" .. string.upper( nicekey( GetKeybindName("menu_role" ) ) ) .. "] " .. lang_string( "rolemenu" ), "ttsf", ctr( 50 ), ctr( 10 ) + ctr( 10 ) + ctr( 4*_abstand ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
    draw.SimpleTextOutlined( "[" .. "F7" .. "] " .. lang_string( "givefeedback" ), "ttsf", ctr( 50 ), ctr( 10 ) + ctr( 10 ) + ctr( 5*_abstand ), Color( 255, 255, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
    draw.SimpleTextOutlined( "[" .. string.upper( nicekey( GetKeybindName("menu_settings" ) ) ) .. "] " .. lang_string( "settings" ), "ttsf", ctr( 50 ), ctr( 10 ) + ctr( 10 ) + ctr( 6*_abstand ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
    draw.SimpleTextOutlined( "[" .. string.upper( nicekey( GetKeybindName("menu_buy" ) ) ) .. "] " .. lang_string( "buymenu" ), "ttsf", ctr( 50 ), ctr( 10 ) + ctr( 10 ) + ctr( 7*_abstand ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
    draw.SimpleTextOutlined( "[" .. string.upper( nicekey( GetKeybindName("toggle_map" ) ) ) .. "] " .. lang_string( "map" ), "ttsf", ctr( 50 ), ctr( 10 ) + ctr( 10 ) + ctr( 8*_abstand ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
    draw.SimpleTextOutlined( "[" .. string.upper( nicekey( GetKeybindName("menu_inventory" ) ) ) .. "] " .. lang_string( "inventory" ), "ttsf", ctr( 50 ), ctr( 10 ) + ctr( 10 ) + ctr( 9*_abstand ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
    draw.SimpleTextOutlined( "[" .. string.upper( nicekey( GetKeybindName("menu_appearance" ) ) ) .. "] " .. lang_string( "appearance" ), "ttsf", ctr( 50 ), ctr( 10 ) + ctr( 10 ) + ctr( 10*_abstand ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
    draw.SimpleTextOutlined( "[" .. string.upper( nicekey( GetKeybindName("drop_item" ) ) ) .. "] " .. lang_string( "drop" ), "ttsf", ctr( 50 ), ctr( 10 ) + ctr( 10 ) + ctr( 11*_abstand ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
    draw.SimpleTextOutlined( "[" .. string.upper( nicekey( GetKeybindName("weaponlowering" ) ) ) .. "] " .. lang_string( "weaponlowering" ), "ttsf", ctr( 50 ), ctr( 10 ) + ctr( 10 ) + ctr( 12*_abstand ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
    draw.SimpleTextOutlined( "[" .. string.upper( nicekey( GetKeybindName("menu_emotes" ) ) ) .. "] " .. lang_string( "emotes" ), "ttsf", ctr( 50 ), ctr( 10 ) + ctr( 10 ) + ctr( 13*_abstand ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )

    draw.SimpleTextOutlined( "[" .. string.upper( nicekey( GetKeybindName("view_switch" ) ) ) .. "] " .. lang_string( "viewswitch" ), "ttsf", pw/2, ctr( 20 ) + ctr( 1*_abstand ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
    draw.SimpleTextOutlined( "[" .. string.upper( nicekey( GetKeybindName("view_up" ) ) ) .. "] " .. lang_string( "incviewheight" ), "ttsf", pw/2, ctr( 20 ) + ctr( 2*_abstand ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
    draw.SimpleTextOutlined( "[" .. string.upper( nicekey( GetKeybindName("view_down" ) ) ) .. "] " .. lang_string( "decviewheight" ), "ttsf", pw/2, ctr( 20 ) + ctr( 3*_abstand ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
    draw.SimpleTextOutlined( "[" .. string.upper( nicekey( GetKeybindName("view_right" ) ) ) .. "] " .. lang_string( "viewposright" ), "ttsf", pw/2, ctr( 20 ) + ctr( 4*_abstand ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
    draw.SimpleTextOutlined( "[" .. string.upper( nicekey( GetKeybindName("view_left" ) ) ) .. "] " .. lang_string( "viewposleft" ), "ttsf", pw/2, ctr( 20 ) + ctr( 5*_abstand ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
    draw.SimpleTextOutlined( "[" .. string.upper( nicekey( GetKeybindName("view_spin_right" ) ) ) .. "] " .. lang_string( "turnviewangleright" ), "ttsf", pw/2, ctr( 20 ) + ctr( 6*_abstand ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
    draw.SimpleTextOutlined( "[" .. string.upper( nicekey( GetKeybindName("view_spin_left" ) ) ) .. "] " .. lang_string( "turnviewangleleft" ), "ttsf", pw/2, ctr( 20 ) + ctr( 7*_abstand ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
    draw.SimpleTextOutlined( lang_string( "viewzoomoutpre" ) .. " " .. "[" .. string.upper( nicekey( GetKeybindName( "view_zoom_out" ) ) ) .. "]" .. " " .. lang_string( "viewzoomoutpos" ), "ttsf", pw/2, ctr( 20 ) + ctr( 8*_abstand ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
    draw.SimpleTextOutlined( lang_string( "viewzoominpre" ) .. " " .. "[" .. string.upper( nicekey( GetKeybindName( "view_zoom_in" ) ) ) .. "]" .. " " .. lang_string( "viewzoominpos" ), "ttsf", pw/2, ctr( 20 ) + ctr( 9*_abstand ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
    draw.SimpleTextOutlined( lang_string( "howtoopensmartphonepre" ) .. " [" .. string.upper( nicekey( GetKeybindName( "sp_open" ) ) ) .. "] " .. lang_string( "howtoopensmartphonepos" ), "ttsf", pw/2, ctr( 20 ) + ctr( 11*_abstand ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
    draw.SimpleTextOutlined( lang_string( "howtoclosesmartphonepre" ) .. " [" .. string.upper( nicekey( GetKeybindName( "sp_close" ) ) ) .. "] " .. lang_string( "howtoclosesmartphonepos" ), "ttsf", pw/2, ctr( 20 ) + ctr( 12*_abstand ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
    draw.SimpleTextOutlined( "[" .. string.upper( nicekey( GetKeybindName("speak_next" ) ) ) .. "] " .. lang_string( "voicenext" ), "ttsf", pw/2, ctr( 20 ) + ctr( 14*_abstand ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
    draw.SimpleTextOutlined( "[" .. string.upper( nicekey( GetKeybindName("speak_prev" ) ) ) .. "] " .. lang_string( "voiceprev" ), "ttsf", pw/2, ctr( 20 ) + ctr( 15*_abstand ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )

    if LocalPlayer():HasAccess() then
      draw.SimpleTextOutlined( "[" .. string.upper( GetKeybindName( "menu_settings" ) ) .. "] " .. lang_string( "ifadminsettings" ).. "!", "ttsf", ctr( 50 ), ctr( 10 ) + ctr( 10 ) + ctr( 18*_abstand ), Color( 255, 255, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
    else
      local _name = LocalPlayer():SteamName()
      draw.SimpleTextOutlined( lang_string( "ifnotadminsettings" ) .. "!" .. " (in Server-Console: " .. "yrp_usergroup " .. "\"" .. _name .. "\"" .. " " .. "superadmin" .. ")", "ttsf", ctr( 50 ), ctr( 10 ) + ctr( 10 ) + ctr( 18*_abstand ), Color( 255, 255, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
    end
  end

  _hm.feedback = createD( "DButton", _hm.window, ctr( 500 ), ctr( 50 ), ctr( 50 ), ctr( 900 ) )
  _hm.feedback:SetText( "" )
  function _hm.feedback:Paint( pw, ph )
    surfaceButton( self, pw, ph, lang_string( "givefeedback" ) )
  end
  function _hm.feedback:DoClick()
    closeHelpMenu()
    openFeedbackMenu()
    --gui.OpenURL( "https://docs.google.com/forms/d/e/1FAIpQLSd2uI9qa5CCk3s-l4TtOVMca-IXn6boKhzx-gUrPFks1YCKjA/viewform?usp=sf_link" )
  end

  _hm.discord = createD( "DButton", _hm.window, ctr( 400 ), ctr( 50 ), ctr( 560 ), ctr( 900 ) )
  _hm.discord:SetText( "" )
  function _hm.discord:Paint( pw, ph )
    surfaceButton( self, pw, ph, lang_string( "livesupport" ) )
  end
  function _hm.discord:DoClick()
    gui.OpenURL( "https://discord.gg/sEgNZxg" )
  end

  local _g_docs_news_panel = createD( "DPanel", _hm.window, BScrW()/2-ctr(10+10), ctr( 1130 ), ctr( 10 ), ctr( 1020 ) )
  function _g_docs_news_panel:Paint( pw, ph )
    draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 255, 255, 255 ) )
  end

  local _g_docs_news_html = createD( "HTML", _g_docs_news_panel, BScrW()/2-ctr(10+10), ctr( 1130 + 212 + 50 ), 0, -ctr( 212 ) )
  _g_docs_news_html:OpenURL( "https://docs.google.com/document/d/1s9lqfYeTbTW7YOgyvg3F2gNx4LBvNpt9fA8eGUYfpTI/edit?usp=sharing" )
  --_g_docs_news_html:OpenURL( "https://docs.google.com/document/d/e/2PACX-1vRcuPnvnAqRD7dQFOkH9d0Q1G3qXFn6rAHJWAAl7wV2TEABGhDdJK9Y-LCONFKTiAWmJJZpsTcDnz5W/pub" )

  local _g_docs_help_panel = createD( "DPanel", _hm.window, BScrW()/2-ctr(10+10), ctr( 1130 ), BScrW()/2 + ctr( 10 ), ctr( 1020 ) )
  function _g_docs_help_panel:Paint( pw, ph )
    draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 255, 255, 255 ) )
  end

  local _g_docs_help_html = createD( "HTML", _g_docs_help_panel, BScrW()/2-ctr(10+10), ctr( 1130 + 60 + 140 ), 0, -ctr( 80 ) )
  --_g_docs_help_html:OpenURL( "https://docs.google.com/document/d/1J-N9Hd2fliTdvHiN5cTHsj_1jPLeNn82X1A-pzkIKsU/edit?usp=sharing" )
  _g_docs_help_html:OpenURL( "https://docs.google.com/document/d/e/2PACX-1vQrwLHPnntg4ZBAICAmwrgXyilU3i8L9n8ein9gHROoJAzmL8ypN1nxTltro_7CHV-qqE7vkoLqeyvH/pub" )

  _hm.window:MakePopup()
end

--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

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

function OpenStaffSite()
  for i, child in pairs( HELPMENU.site:GetChildren() ) do
    child:Remove()
  end

  local staffpnl = createD( "DPanel", HELPMENU.site, HELPMENU.site:GetWide(), HELPMENU.site:GetTall(), 0, 0 )
  function staffpnl:Paint( pw, ph )
    local _abstand = ctr( HudV("ttsf") ) * 3.8
    draw.SimpleTextOutlined( lang_string( "wip" ), "ttsf", BScrW()/2 - ctr( 10 ), ctr( 25 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
  end
end

net.Receive( "getsitehelp", function( len )
  if pa( HELPMENU.mainmenu.site ) then
    local helppnl = createD( "DPanel", HELPMENU.mainmenu.site, HELPMENU.mainmenu.site:GetWide(), HELPMENU.mainmenu.site:GetTall(), 0, 0 )

    function helppnl:Paint( pw, ph )
      -- draw.RoundedBox( 0, 0, 0, pw, ph, Color(255, 0, 0 ))
      local _abstand = ctr( HudV("ttsf") ) * 3.8

      draw.SimpleTextOutlined( "[" .. string.upper( nicekey( "F1" ) ) .. "] " .. lang_string( "help" ), "ttsf", ctr( 20 ), ctr( 20 ) + ctr( 0*_abstand ), Color( 255, 255, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
      draw.SimpleTextOutlined( "[" .. string.upper( nicekey( GetKeybindName("menu_character_selection" ) ) ) .. "] " .. lang_string( "characterselection" ), "ttsf", ctr( 20 ), ctr( 20 ) + ctr( 1*_abstand ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
      draw.SimpleTextOutlined( "[" .. string.upper( nicekey( GetKeybindName("toggle_mouse" ) ) ) .. "] " .. lang_string( "guimouse" ), "ttsf", ctr( 20 ), ctr( 20 ) + ctr( 2*_abstand ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
      draw.SimpleTextOutlined( "[" .. string.upper( nicekey( GetKeybindName("menu_role" ) ) ) .. "] " .. lang_string( "rolemenu" ), "ttsf", ctr( 20 ), ctr( 20 ) + ctr( 3*_abstand ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
      draw.SimpleTextOutlined( "[" .. "F7" .. "] " .. lang_string( "givefeedback" ), "ttsf", ctr( 20 ), ctr( 20 ) + ctr( 4*_abstand ), Color( 255, 255, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
      draw.SimpleTextOutlined( "[" .. string.upper( nicekey( GetKeybindName("menu_settings" ) ) ) .. "] " .. lang_string( "settings" ), "ttsf", ctr( 20 ), ctr( 20 ) + ctr( 5*_abstand ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
      draw.SimpleTextOutlined( "[" .. string.upper( nicekey( GetKeybindName("menu_buy" ) ) ) .. "] " .. lang_string( "buymenu" ), "ttsf", ctr( 20 ), ctr( 20 ) + ctr( 6*_abstand ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
      draw.SimpleTextOutlined( "[" .. string.upper( nicekey( GetKeybindName("toggle_map" ) ) ) .. "] " .. lang_string( "map" ), "ttsf", ctr( 20 ), ctr( 10 ) + ctr( 10 ) + ctr( 8*_abstand ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
      draw.SimpleTextOutlined( "[" .. string.upper( nicekey( GetKeybindName("menu_inventory" ) ) ) .. "] " .. lang_string( "inventory" ), "ttsf", ctr( 20 ), ctr( 10 ) + ctr( 10 ) + ctr( 9*_abstand ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
      draw.SimpleTextOutlined( "[" .. string.upper( nicekey( GetKeybindName("menu_appearance" ) ) ) .. "] " .. lang_string( "appearance" ), "ttsf", ctr( 20 ), ctr( 10 ) + ctr( 10 ) + ctr( 10*_abstand ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
      draw.SimpleTextOutlined( "[" .. string.upper( nicekey( GetKeybindName("drop_item" ) ) ) .. "] " .. lang_string( "drop" ), "ttsf", ctr( 20 ), ctr( 10 ) + ctr( 10 ) + ctr( 11*_abstand ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
      draw.SimpleTextOutlined( "[" .. string.upper( nicekey( GetKeybindName("weaponlowering" ) ) ) .. "] " .. lang_string( "weaponlowering" ), "ttsf", ctr( 20 ), ctr( 10 ) + ctr( 10 ) + ctr( 12*_abstand ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
      draw.SimpleTextOutlined( "[" .. string.upper( nicekey( GetKeybindName("menu_emotes" ) ) ) .. "] " .. lang_string( "emotes" ), "ttsf", ctr( 20 ), ctr( 10 ) + ctr( 10 ) + ctr( 13*_abstand ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )

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

    HELPMENU.feedback = createD( "DButton", helppnl, ctr( 500 ), ctr( 50 ), ctr( 50 ), ctr( 900 ) )
    HELPMENU.feedback:SetText( "" )
    function HELPMENU.feedback:Paint( pw, ph )
      surfaceButton( self, pw, ph, lang_string( "givefeedback" ) )
    end
    function HELPMENU.feedback:DoClick()
      closeHelpMenu()
      openFeedbackMenu()
      --gui.OpenURL( "https://docs.google.com/forms/d/e/1FAIpQLSd2uI9qa5CCk3s-l4TtOVMca-IXn6boKhzx-gUrPFks1YCKjA/viewform?usp=sf_link" )
    end

    HELPMENU.discord = createD( "DButton", helppnl, ctr( 400 ), ctr( 50 ), ctr( 560 ), ctr( 900 ) )
    HELPMENU.discord:SetText( "" )
    function HELPMENU.discord:Paint( pw, ph )
      surfaceButton( self, pw, ph, lang_string( "livesupport" ) )
    end
    function HELPMENU.discord:DoClick()
      gui.OpenURL( "https://discord.gg/sEgNZxg" )
    end

    local _g_docs_news_panel = createD( "DPanel", helppnl, BScrW()/2-ctr(10+10), ctr( 1130 ), ctr( 10 ), ctr( 1020 ) )
    function _g_docs_news_panel:Paint( pw, ph )
      draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 255, 255, 255 ) )
    end

    local _g_docs_news_html = createD( "HTML", _g_docs_news_panel, BScrW()/2-ctr(10+10), ctr( 1130 + 212 + 50 ), 0, -ctr( 212 ) )
    _g_docs_news_html:OpenURL( "https://docs.google.com/document/d/1s9lqfYeTbTW7YOgyvg3F2gNx4LBvNpt9fA8eGUYfpTI/edit?usp=sharing" )
    --_g_docs_news_html:OpenURL( "https://docs.google.com/document/d/e/2PACX-1vRcuPnvnAqRD7dQFOkH9d0Q1G3qXFn6rAHJWAAl7wV2TEABGhDdJK9Y-LCONFKTiAWmJJZpsTcDnz5W/pub" )

    local _g_docs_help_panel = createD( "DPanel", helppnl, BScrW()/2-ctr(10+10), ctr( 1130 ), BScrW()/2 + ctr( 10 ), ctr( 1020 ) )
    function _g_docs_help_panel:Paint( pw, ph )
      draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 255, 255, 255 ) )
    end

    local _g_docs_help_html = createD( "HTML", _g_docs_help_panel, BScrW()/2-ctr(10+10), ctr( 1130 + 60 + 140 ), 0, -ctr( 80 ) )
    --_g_docs_help_html:OpenURL( "https://docs.google.com/document/d/1J-N9Hd2fliTdvHiN5cTHsj_1jPLeNn82X1A-pzkIKsU/edit?usp=sharing" )
    _g_docs_help_html:OpenURL( "https://docs.google.com/document/d/e/2PACX-1vQrwLHPnntg4ZBAICAmwrgXyilU3i8L9n8ein9gHROoJAzmL8ypN1nxTltro_7CHV-qqE7vkoLqeyvH/pub" )
  end
end)

net.Receive( "getsitestaff", function( len )
  if pa( HELPMENU.mainmenu.site ) then
    local staff = net.ReadTable()

    for i, pl in pairs( staff ) do
      local tmp = createD( "DButton", HELPMENU.mainmenu.site, ctr( 800 ), ctr( 200 ), 0, 0 )
      tmp:SetText( "" )
      function tmp:Paint( pw, ph )
        draw.RoundedBox( 0, 0, 0, pw, ph, Color( 0, 255, 255, 200 ) )
        draw.SimpleTextOutlined( "RPName: " .. pl:RPName(), "mat1text", ph + ctr( 10 ), ph/2, Color( 255, 255, 255, 255 ), 0, 1, ctr( 1 ), Color( 0, 0, 0, 255 ) )
      end
    end
  end
end)

function openHelpMenu()
  openMenu()
  HELPMENU.window = createD( "DFrame", nil, ScrW(), ScrH(), 0, 0 )
  HELPMENU.window:MakePopup()
  HELPMENU.window:Center()
  HELPMENU.window:SetTitle( "" )
  HELPMENU.window:SetDraggable( false )
  HELPMENU.window:ShowCloseButton( false )
  function HELPMENU.window:Paint( pw, ph )
    surfaceBox( 0, 0, pw, ph, Color( 90, 90, 90, 200 ) )
  end

  HELPMENU.mainmenu = createD( "DYRPHorizontalMenu", HELPMENU.window, BScrW(), ScrH(), 0, 0 )
  HELPMENU.mainmenu:GetMenuInfo( "gethelpmenu" )
  HELPMENU.mainmenu:SetStartTab( "help" )

  HELPMENU.changelanguage = DChangeLanguage( HELPMENU.window, BScrW() - ctr( 400 ), ctr( 20 ), ctr( 100 ) )

  HELPMENU.close = createD( "DButton", HELPMENU.window, ctr( 64 ), ctr( 64 ), BScrW() - ctr( 64 + 20 ), ctr( 20 ) )
  HELPMENU.close:SetText( "" )
  function HELPMENU.close:Paint( pw, ph )
    draw.RoundedBox( ph/2, 0, 0, pw, ph, Color( 0, 0, 255, 255 ) )
    DrawIcon( GetDesignIcon( "close" ), ph, ph, 0, 0, Color( 255, 255, 255, 255 ) )
  end
  function HELPMENU.close:DoClick()
    HELPMENU.window:Close()
  end
end

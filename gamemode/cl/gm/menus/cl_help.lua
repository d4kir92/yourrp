--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

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

  _hm.langu = derma_change_language( _hm.window, ctr( 400 ), ctr( 50 ), BScrW()/2, ctr( 10 ) )

  function _hm.window:Paint( pw, ph )
    --paintWindow( self, pw, ph, lang_string( "help" ) )
    draw.RoundedBox( 0, 0, 0, pw, ph, Color( 0, 0, 0, 200 ) )

    local _abstand = ctr( HudV("ttsf") ) * 3.8

    draw.SimpleTextOutlined( "Language: ", "ttsf", BScrW()/2 - ctr( 10 ), ctr( 10 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )

    --[[ LEFT ]]--
    draw.SimpleTextOutlined( lang_string( "help" ) .. " - " .. lang_string( "menu" ), "ttsf", ctr( 10 ), ctr( 10 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
    draw.SimpleTextOutlined( "[" .. string.upper( nicekey( "F1" ) ) .. "] " .. lang_string( "help" ), "ttsf", ctr( 50 ), ctr( 10 ) + ctr( 10 + 1*_abstand ), Color( 255, 255, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
    draw.SimpleTextOutlined( "[" .. string.upper( nicekey( GetKeybindName("menu_character_selection" ) ) ) .. "] " .. lang_string( "characterselection" ), "ttsf", ctr( 50 ), ctr( 10 ) + ctr( 10 + 2*_abstand ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
    draw.SimpleTextOutlined( "[" .. string.upper( nicekey( GetKeybindName("toggle_mouse" ) ) ) .. "] " .. lang_string( "guimouse" ), "ttsf", ctr( 50 ), ctr( 10 ) + ctr( 10 ) + ctr( 3*_abstand ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
    draw.SimpleTextOutlined( "[" .. string.upper( nicekey( GetKeybindName("menu_role" ) ) ) .. "] " .. lang_string( "rolemenu" ), "ttsf", ctr( 50 ), ctr( 10 ) + ctr( 10 ) + ctr( 4*_abstand ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
    draw.SimpleTextOutlined( "[" .. "F7" .. "] " .. lang_string( "givefeedback" ), "ttsf", ctr( 50 ), ctr( 10 ) + ctr( 10 ) + ctr( 5*_abstand ), Color( 255, 255, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
    draw.SimpleTextOutlined( "[" .. string.upper( nicekey( GetKeybindName("menu_settings" ) ) ) .. "] " .. lang_string( "settings" ), "ttsf", ctr( 50 ), ctr( 10 ) + ctr( 10 ) + ctr( 6*_abstand ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
    draw.SimpleTextOutlined( "[" .. string.upper( nicekey( GetKeybindName("menu_buy" ) ) ) .. "] " .. lang_string( "buymenu" ), "ttsf", ctr( 50 ), ctr( 10 ) + ctr( 10 ) + ctr( 7*_abstand ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
    draw.SimpleTextOutlined( "[" .. string.upper( nicekey( GetKeybindName("toggle_map" ) ) ) .. "] " .. lang_string( "map" ), "ttsf", ctr( 50 ), ctr( 10 ) + ctr( 10 ) + ctr( 8*_abstand ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
    --draw.SimpleTextOutlined( "[" .. string.upper( nicekey( GetKeybindName("menu_inventory" ) ) ) .. "] " .. lang_string( "inventory" ), "ttsf", ctr( 50 ), ctr( 10 ) + ctr( 10 ) + ctr( 9*_abstand ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
    draw.SimpleTextOutlined( "[" .. string.upper( nicekey( GetKeybindName("menu_appearance" ) ) ) .. "] " .. lang_string( "appearance" ), "ttsf", ctr( 50 ), ctr( 10 ) + ctr( 10 ) + ctr( 10*_abstand ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
    draw.SimpleTextOutlined( "[" .. string.upper( nicekey( GetKeybindName("drop_item" ) ) ) .. "] " .. lang_string( "drop" ), "ttsf", ctr( 50 ), ctr( 10 ) + ctr( 10 ) + ctr( 11*_abstand ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
    draw.SimpleTextOutlined( "[" .. string.upper( nicekey( GetKeybindName("weaponlowering" ) ) ) .. "] " .. lang_string( "weaponlowering" ), "ttsf", ctr( 50 ), ctr( 10 ) + ctr( 10 ) + ctr( 12*_abstand ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )

    --[[ RIGHT ]]--
    draw.SimpleTextOutlined( "[" .. string.upper( nicekey( GetKeybindName("view_switch" ) ) ) .. "] " .. lang_string( "viewswitch" ), "ttsf", pw/2, ctr( 20 ) + ctr( 1*_abstand ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
    draw.SimpleTextOutlined( "[" .. string.upper( nicekey( GetKeybindName("view_up" ) ) ) .. "] " .. lang_string( "incviewheight" ), "ttsf", pw/2, ctr( 20 ) + ctr( 2*_abstand ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
    draw.SimpleTextOutlined( "[" .. string.upper( nicekey( GetKeybindName("view_down" ) ) ) .. "] " .. lang_string( "decviewheight" ), "ttsf", pw/2, ctr( 20 ) + ctr( 3*_abstand ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
    draw.SimpleTextOutlined( "[" .. string.upper( nicekey( GetKeybindName("view_right" ) ) ) .. "] " .. lang_string( "viewposright" ), "ttsf", pw/2, ctr( 20 ) + ctr( 4*_abstand ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
    draw.SimpleTextOutlined( "[" .. string.upper( nicekey( GetKeybindName("view_left" ) ) ) .. "] " .. lang_string( "viewposleft" ), "ttsf", pw/2, ctr( 20 ) + ctr( 5*_abstand ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
    draw.SimpleTextOutlined( "[" .. string.upper( nicekey( GetKeybindName("view_spin_right" ) ) ) .. "] " .. lang_string( "turnviewangleright" ), "ttsf", pw/2, ctr( 20 ) + ctr( 6*_abstand ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
    draw.SimpleTextOutlined( "[" .. string.upper( nicekey( GetKeybindName("view_spin_left" ) ) ) .. "] " .. lang_string( "turnviewangleleft" ), "ttsf", pw/2, ctr( 20 ) + ctr( 7*_abstand ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
    draw.SimpleTextOutlined( lang_string( "viewzoomoutpre" ) .. " " .. "[" .. string.upper( nicekey( GetKeybindName("view_zoom_out" ) ) ) .. "]" .. " " .. lang_string( "viewzoomoutpos" ), "ttsf", pw/2, ctr( 20 ) + ctr( 8*_abstand ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
    draw.SimpleTextOutlined( lang_string( "viewzoominpre" ) .. " " .. "[" .. string.upper( nicekey( GetKeybindName("view_zoom_in" ) ) ) .. "]" .. " " .. lang_string( "viewzoominpos" ), "ttsf", pw/2, ctr( 20 ) + ctr( 9*_abstand ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
    draw.SimpleTextOutlined( lang_string( "howtoopensmartphonepre" ) .. " [" .. string.upper( nicekey( input.GetKeyName( KEY_UP ) ) ) .. "] " .. lang_string( "howtoopensmartphonepos" ), "ttsf", pw/2, ctr( 20 ) + ctr( 11*_abstand ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
    draw.SimpleTextOutlined( lang_string( "howtoclosesmartphonepre" ) .. " [" .. string.upper( nicekey( input.GetKeyName( KEY_DOWN ) ) ) .. "] " .. lang_string( "howtoclosesmartphonepos" ), "ttsf", pw/2, ctr( 20 ) + ctr( 12*_abstand ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
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
    paintButton( self, pw, ph, lang_string( "givefeedback" ) )
  end
  function _hm.feedback:DoClick()
    closeHelpMenu()
    openFeedbackMenu()
    --gui.OpenURL( "https://docs.google.com/forms/d/e/1FAIpQLSd2uI9qa5CCk3s-l4TtOVMca-IXn6boKhzx-gUrPFks1YCKjA/viewform?usp=sf_link" )
  end

  _hm.discord = createD( "DButton", _hm.window, ctr( 400 ), ctr( 50 ), ctr( 560 ), ctr( 900 ) )
  _hm.discord:SetText( "" )
  function _hm.discord:Paint( pw, ph )
    paintButton( self, pw, ph, lang_string( "livesupport" ) )
  end
  function _hm.discord:DoClick()
    gui.OpenURL( "https://discord.gg/sEgNZxg" )
  end

  --[[ GDocs News ]]--
  local _g_docs_news_panel = createD( "DPanel", _hm.window, BScrW()/2-ctr(10+10), ctr( 1130 ), ctr( 10 ), ctr( 1020 ) )
  function _g_docs_news_panel:Paint( pw, ph )
    draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 255, 255, 255 ) )
  end

  local _g_docs_news_html = createD( "HTML", _g_docs_news_panel, BScrW()/2-ctr(10+10), ctr( 1130 + 212 + 50 ), 0, -ctr( 212 ) )
  _g_docs_news_html:OpenURL( "https://docs.google.com/document/d/1s9lqfYeTbTW7YOgyvg3F2gNx4LBvNpt9fA8eGUYfpTI/edit?usp=sharing" )
  --_g_docs_news_html:OpenURL( "https://docs.google.com/document/d/e/2PACX-1vRcuPnvnAqRD7dQFOkH9d0Q1G3qXFn6rAHJWAAl7wV2TEABGhDdJK9Y-LCONFKTiAWmJJZpsTcDnz5W/pub" )

  --[[ GDocs Help ]]--
  local _g_docs_help_panel = createD( "DPanel", _hm.window, BScrW()/2-ctr(10+10), ctr( 1130 ), BScrW()/2 + ctr( 10 ), ctr( 1020 ) )
  function _g_docs_help_panel:Paint( pw, ph )
    draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 255, 255, 255 ) )
  end

  local _g_docs_help_html = createD( "HTML", _g_docs_help_panel, BScrW()/2-ctr(10+10), ctr( 1130 + 60 + 140 ), 0, -ctr( 80 ) )
  --_g_docs_help_html:OpenURL( "https://docs.google.com/document/d/1J-N9Hd2fliTdvHiN5cTHsj_1jPLeNn82X1A-pzkIKsU/edit?usp=sharing" )
  _g_docs_help_html:OpenURL( "https://docs.google.com/document/d/e/2PACX-1vQrwLHPnntg4ZBAICAmwrgXyilU3i8L9n8ein9gHROoJAzmL8ypN1nxTltro_7CHV-qqE7vkoLqeyvH/pub" )

  _hm.window:MakePopup()
end

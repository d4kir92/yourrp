--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

local _hm = {}

function toggleHelpMenu()
  if isNoMenuOpen() then
    openHelpMenu()
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

function nicekey( key_str )
  if key_str != nil then
    if string.lower( key_str ) == "uparrow" then
      return "↑"
    elseif string.lower( key_str ) == "downarrow" then
      return "↓"
    elseif string.lower( key_str ) == "kp_plus" then
      return lang_string( "keynumpad" ) .. "+"
    elseif string.lower( key_str ) == "kp_minus" then
      return lang_string( "keynumpad" ) .. "-"
    elseif string.lower( key_str ) == "pgup" then
      return lang_string( "keypage" ) .. "↑"
    elseif string.lower( key_str ) == "pgdn" then
      return lang_string( "keypage" ) .. "↓"
    end
  end
  return tostring( key_str )
end

function openHelpMenu()
  done_tutorial( "tut_hudhelp" )
  openMenu()
  _hm.window = createD( "DFrame", nil, ScrH(), ScrH(), 0, 0 )
  _hm.window:Center()
  _hm.window:SetTitle( "" )
  function _hm.window:OnClose()
    closeMenu()
  end
  function _hm.window:OnRemove()
    closeMenu()
  end

  _hm.langu = derma_change_language( _hm.window, ctr( 400 ), ctr( 50 ), ctr( 1400 ), ctr( 50 ) )

  function _hm.window:Paint( pw, ph )
    paintWindow( self, pw, ph, lang_string( "help" ) )

    local _abstand = ctr( HudV("ttsf") ) * 3.8

    draw.SimpleTextOutlined( "Language: ", "ttsf", ctr( 1400 ), ctr( 50 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )

    draw.SimpleTextOutlined( "[" .. nicekey( "F1" ) .. "] " .. lang_string( "help" ), "ttsf", ctr( 10 ) + ctr( 32 ), ctr( 10 ) + ctr( 10 + 1*_abstand ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
    draw.SimpleTextOutlined( "[" .. string.upper( nicekey( input.GetKeyName( get_keybind( "menu_character_selection" ) ) ) ) .. "] " .. lang_string( "characterselection" ), "ttsf", ctr( 10 ) + ctr( 32 ), ctr( 10 ) + ctr( 10 + 2*_abstand ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
    draw.SimpleTextOutlined( "[" .. string.upper( nicekey( input.GetKeyName( get_keybind( "menu_role" ) ) ) ) .. "] " .. lang_string( "rolemenu" ), "ttsf", ctr( 10 ) + ctr( 32 ), ctr( 10 ) + ctr( 10 ) + ctr( 3*_abstand ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
    draw.SimpleTextOutlined( "[" .. string.upper( nicekey( input.GetKeyName( get_keybind( "menu_buy" ) ) ) ) .. "] " .. lang_string( "buymenu" ), "ttsf", ctr( 10 ) + ctr( 32 ), ctr( 10 ) + ctr( 10 ) + ctr( 4*_abstand ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
    draw.SimpleTextOutlined( "[" .. string.upper( nicekey( input.GetKeyName( get_keybind( "menu_settings" ) ) ) ) .. "] " .. lang_string( "settings" ), "ttsf", ctr( 10 ) + ctr( 32 ), ctr( 10 ) + ctr( 10 ) + ctr( 5*_abstand ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
    draw.SimpleTextOutlined( "[" .. string.upper( nicekey( input.GetKeyName( get_keybind( "toggle_mouse" ) ) ) ) .. "] " .. lang_string( "guimouse" ), "ttsf", ctr( 10 ) + ctr( 32 ), ctr( 10 ) + ctr( 10 ) + ctr( 6*_abstand ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
    draw.SimpleTextOutlined( lang_string( "viewzoomoutpre" ) .. " " .. "[" .. string.upper( nicekey( input.GetKeyName( get_keybind( "view_zoom_out" ) ) ) ) .. "]" .. " " .. lang_string( "viewzoomoutpos" ), "ttsf", ctr( 10 ) + ctr( 32 ), ctr( 10 ) + ctr( 10 ) + ctr( 7*_abstand ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
    draw.SimpleTextOutlined( lang_string( "viewzoominpre" ) .. " " .. "[" .. string.upper( nicekey( input.GetKeyName( get_keybind( "view_zoom_in" ) ) ) ) .. "]" .. " " .. lang_string( "viewzoominpos" ), "ttsf", ctr( 10 ) + ctr( 32 ), ctr( 10 ) + ctr( 10 ) + ctr( 8*_abstand ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
    draw.SimpleTextOutlined( "[" .. string.upper( nicekey( input.GetKeyName( get_keybind( "toggle_map" ) ) ) ) .. "] " .. lang_string( "map" ), "ttsf", ctr( 10 ) + ctr( 32 ), ctr( 10 ) + ctr( 10 ) + ctr( 9*_abstand ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
    draw.SimpleTextOutlined( "[" .. string.upper( nicekey( input.GetKeyName( get_keybind( "menu_inventory" ) ) ) ) .. "] " .. lang_string( "inventory" ), "ttsf", ctr( 10 ) + ctr( 32 ), ctr( 10 ) + ctr( 10 ) + ctr( 10*_abstand ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
    draw.SimpleTextOutlined( "[" .. string.upper( nicekey( input.GetKeyName( get_keybind( "speak_next" ) ) ) ) .. "] " .. lang_string( "voicenext" ), "ttsf", ctr( 10 ) + ctr( 32 ), ctr( 10 ) + ctr( 10 ) + ctr( 11*_abstand ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
    draw.SimpleTextOutlined( "[" .. string.upper( nicekey( input.GetKeyName( get_keybind( "speak_prev" ) ) ) ) .. "] " .. lang_string( "voiceprev" ), "ttsf", ctr( 10 ) + ctr( 32 ), ctr( 10 ) + ctr( 10 ) + ctr( 12*_abstand ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
    draw.SimpleTextOutlined( "[" .. string.upper( nicekey( input.GetKeyName( get_keybind( "drop_item" ) ) ) ) .. "] " .. lang_string( "drop" ), "ttsf", ctr( 10 ) + ctr( 32 ), ctr( 10 ) + ctr( 10 ) + ctr( 13*_abstand ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
    draw.SimpleTextOutlined( "[" .. string.upper( nicekey( input.GetKeyName( get_keybind( "weaponlowering" ) ) ) ) .. "] " .. lang_string( "weaponlowering" ), "ttsf", ctr( 10 ) + ctr( 32 ), ctr( 10 ) + ctr( 10 ) + ctr( 14*_abstand ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
    draw.SimpleTextOutlined( lang_string( "howtoopensmartphonepre" ) .. " [" .. string.upper( nicekey( input.GetKeyName( KEY_UP ) ) ) .. "] " .. lang_string( "howtoopensmartphonepos" ), "ttsf", ctr( 10 ) + ctr( 32 ), ctr( 10 ) + ctr( 10 ) + ctr( 15*_abstand ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
    draw.SimpleTextOutlined( lang_string( "howtoclosesmartphonepre" ) .. " [" .. string.upper( nicekey( input.GetKeyName( KEY_DOWN ) ) ) .. "] " .. lang_string( "howtoclosesmartphonepos" ), "ttsf", ctr( 10 ) + ctr( 32 ), ctr( 10 ) + ctr( 10 ) + ctr( 16*_abstand ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )

    if LocalPlayer():IsSuperAdmin() or LocalPlayer():IsAdmin() then
      draw.SimpleTextOutlined( "[" .. string.upper( input.GetKeyName( get_keybind( "menu_settings" ) ) ) .. "] " .. lang_string( "ifadminsettings" ).. "!", "ttsf", ctr( 10 ) + ctr( 32 ), ctr( 10 ) + ctr( 10 ) + ctr( 18*_abstand ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
    else
      draw.SimpleTextOutlined( lang_string( "ifnotadminsettings" ) .. "!", "ttsf", ctr( 10 ) + ctr( 32 ), ctr( 10 ) + ctr( 10 ) + ctr( 18*_abstand ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
    end

    draw.SimpleTextOutlined( lang_string( "notshowagain"), "ttsf", ctr( 110 ), ctr( 960 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
  end

  _hm.feedback = createD( "DButton", _hm.window, ctr( 500 ), ctr( 50 ), ctr( 50 ), ctr( 900 ) )
  _hm.feedback:SetText( "" )
  function _hm.feedback:Paint( pw, ph )
    paintButton( self, pw, ph, "Give Feedback / Report problem" )
  end
  function _hm.feedback:DoClick()
    gui.OpenURL( "https://docs.google.com/forms/d/e/1FAIpQLSd2uI9qa5CCk3s-l4TtOVMca-IXn6boKhzx-gUrPFks1YCKjA/viewform?usp=sf_link" )
  end

  _hm.discord = createD( "DButton", _hm.window, ctr( 400 ), ctr( 50 ), ctr( 560 ), ctr( 900 ) )
  _hm.discord:SetText( "" )
  function _hm.discord:Paint( pw, ph )
    paintButton( self, pw, ph, "Live Support" )
  end
  function _hm.discord:DoClick()
    gui.OpenURL( "https://discord.gg/sEgNZxg" )
  end

  _hm.dontopenagain = createD( "DCheckBox", _hm.window, ctr( 50 ), ctr( 50 ), ctr( 50 ), ctr( 960 ) )
  local _value = 0
  if !tobool(get_tutorial( "tut_welcome" )) then
    _value = 1
  end
  _hm.dontopenagain:SetValue( _value )
  function _hm.dontopenagain:OnChange( bVal )
    if bVal then
      done_tutorial( "tut_welcome" )
    else
      reset_tutorial( "tut_welcome" )
    end
  end

  --[[ GDocs News ]]--
  local _g_docs_news_panel = createD( "DPanel", _hm.window, ctr( 1060 ), ctr( 1130 ), ctr( 10 ), ctr( 1020 ) )
  function _g_docs_news_panel:Paint( pw, ph )
    draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 255, 255, 255 ) )
  end

  local _g_docs_news_html = createD( "HTML", _g_docs_news_panel, ScrH() - ctr( 980 + 20 - 30 ), ctr( 1130 + 212 + 50 ), -ctr( 30 ), -ctr( 212 ) )
  _g_docs_news_html:OpenURL( "https://docs.google.com/document/d/1s9lqfYeTbTW7YOgyvg3F2gNx4LBvNpt9fA8eGUYfpTI/edit?usp=sharing" )
  --_g_docs_news_html:OpenURL( "https://docs.google.com/document/d/e/2PACX-1vRcuPnvnAqRD7dQFOkH9d0Q1G3qXFn6rAHJWAAl7wV2TEABGhDdJK9Y-LCONFKTiAWmJJZpsTcDnz5W/pub" )

  --[[ GDocs Help ]]--
  local _g_docs_help_panel = createD( "DPanel", _hm.window, ctr( 1060 ), ctr( 1130 ), ctr( 10 + 1060 + 20 ), ctr( 1020 ) )
  function _g_docs_help_panel:Paint( pw, ph )
    draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 255, 255, 255 ) )
  end

  local _g_docs_help_html = createD( "HTML", _g_docs_help_panel, ScrH() - ctr( 980 + 20 ), ctr( 1130 + 60 + 140 ), 0, -ctr( 80 ) )
  --_g_docs_help_html:OpenURL( "https://docs.google.com/document/d/1J-N9Hd2fliTdvHiN5cTHsj_1jPLeNn82X1A-pzkIKsU/edit?usp=sharing" )
  _g_docs_help_html:OpenURL( "https://docs.google.com/document/d/e/2PACX-1vQrwLHPnntg4ZBAICAmwrgXyilU3i8L9n8ein9gHROoJAzmL8ypN1nxTltro_7CHV-qqE7vkoLqeyvH/pub" )

  _hm.window:MakePopup()
end

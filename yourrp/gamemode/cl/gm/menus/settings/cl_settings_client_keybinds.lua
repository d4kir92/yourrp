--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

function createDKeybinder( parent, w, h, x, y, keybind )
  local _tmp = createD( "DBinder", parent, w, h, x, y )
  _tmp:SetValue( get_keybind( keybind ) )
  function _tmp:OnChange( num )
    set_keybind( keybind, num )
  end
  function _tmp:Paint( pw, ph )
    paintButton( self, pw, ph, "" )
  end
  return _tmp
end

hook.Add( "open_client_keybinds", "open_client_keybinds", function()
  local ply = LocalPlayer()
  local w = settingsWindow.sitepanel:GetWide()
  local h = settingsWindow.sitepanel:GetTall()

  local _wide = 800

  settingsWindow.site = createD( "DPanel", settingsWindow.sitepanel, w, h, 0, 0 )
  --sheet:AddSheet( lang_string( "character" ), cl_charPanel, "icon16/user_edit.png" )
  function settingsWindow.site:Paint( w, h )
    --draw.RoundedBox( 0, 0, 0, sv_generalPanel:GetWide(), sv_generalPanel:GetTall(), _yrp.colors.panel )
    draw.SimpleTextOutlined( lang_string("characterselection"), "sef", ctr( _wide ), ctr( 60 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
    draw.SimpleTextOutlined( lang_string("rolemenu"), "sef", ctr( _wide ), ctr( 120 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
    draw.SimpleTextOutlined( lang_string("buymenu"), "sef", ctr( _wide ), ctr( 180 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
    draw.SimpleTextOutlined( lang_string("settings"), "sef", ctr( _wide ), ctr( 240 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
    draw.SimpleTextOutlined( lang_string("guimouse"), "sef", ctr( _wide ), ctr( 300 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
    draw.SimpleTextOutlined( lang_string("changeview"), "sef", ctr( _wide ), ctr( 360 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
    draw.SimpleTextOutlined( lang_string("map"), "sef", ctr( _wide ), ctr( 420 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
    draw.SimpleTextOutlined( lang_string("inventory"), "sef", ctr( _wide ), ctr( 480 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
    draw.SimpleTextOutlined( lang_string("vehicles") .. " (" .. lang_string("settings") .. ")", "sef", ctr( _wide ), ctr( 540 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
    draw.SimpleTextOutlined( lang_string("doors") .. " (" .. lang_string("settings") .. ")", "sef", ctr( _wide ), ctr( 600 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
    draw.SimpleTextOutlined( lang_string("voicenext"), "sef", ctr( _wide ), ctr( 660 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
    draw.SimpleTextOutlined( lang_string("voiceprev"), "sef", ctr( _wide ), ctr( 720 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
end

  local _k = {}
  _k._cs = createDKeybinder( settingsWindow.site, ctr( 400 ), ctr( 50 ), ctr( _wide+10 ), ctr( 60 ), "menu_character_selection" )
  _k._mr = createDKeybinder( settingsWindow.site, ctr( 400 ), ctr( 50 ), ctr( _wide+10 ), ctr( 120 ), "menu_role" )
  _k._mb = createDKeybinder( settingsWindow.site, ctr( 400 ), ctr( 50 ), ctr( _wide+10 ), ctr( 180 ), "menu_buy" )
  _k._ms = createDKeybinder( settingsWindow.site, ctr( 400 ), ctr( 50 ), ctr( _wide+10 ), ctr( 240 ), "menu_settings" )
  _k._tm = createDKeybinder( settingsWindow.site, ctr( 400 ), ctr( 50 ), ctr( _wide+10 ), ctr( 300 ), "toggle_mouse" )
  _k._tv = createDKeybinder( settingsWindow.site, ctr( 400 ), ctr( 50 ), ctr( _wide+10 ), ctr( 360 ), "toggle_view" )
  _k._tm = createDKeybinder( settingsWindow.site, ctr( 400 ), ctr( 50 ), ctr( _wide+10 ), ctr( 420 ), "toggle_map" )
  _k._mi = createDKeybinder( settingsWindow.site, ctr( 400 ), ctr( 50 ), ctr( _wide+10 ), ctr( 480 ), "menu_inventory" )
  _k._mv = createDKeybinder( settingsWindow.site, ctr( 400 ), ctr( 50 ), ctr( _wide+10 ), ctr( 540 ), "menu_options_vehicle" )
  _k._md = createDKeybinder( settingsWindow.site, ctr( 400 ), ctr( 50 ), ctr( _wide+10 ), ctr( 600 ), "menu_options_door" )
  _k._sgr = createDKeybinder( settingsWindow.site, ctr( 400 ), ctr( 50 ), ctr( _wide+10 ), ctr( 660 ), "speak_next" )
  _k._sgl = createDKeybinder( settingsWindow.site, ctr( 400 ), ctr( 50 ), ctr( _wide+10 ), ctr( 720 ), "speak_prev" )
end)

--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

--cl_settings_client_hud.lua

function createDerma( art, parent, w, h, x, y )
  tmpDerma = vgui.Create( art, parent )
  tmpDerma:SetSize( ctrW(w), ctrW(h) )
  tmpDerma:SetPos( ctrW(x), ctrW(y) )
  return tmpDerma
end

function changeHudElement( parent, tmpx, tmpy, tmpw, tmph, tmpt, textPre )
  local ply = LocalPlayer()
  local frame = createDerma( "DFrame", parent, cl_db[tmpw], cl_db[tmph], cl_db[tmpx], cl_db[tmpy] )
  frame:SetTitle( "" )
  frame:ShowCloseButton( false )
  frame:SetSizable( true )
  frame:SetMinHeight( ctrW( 40 ) )
  frame:SetMinWidth( ctrW( 40 ) )

  function frame:Paint( pw, ph )
    draw.RoundedBox( 0, 0, 0, pw, ph, Color( 0, 0, 0, 120 ) )
    draw.RoundedBox( 0, 0, 0, pw, ctrH( 50 ), Color( 0, 0, 255, 200 ) )

    if frame:GetSizable() then
      draw.RoundedBox( 0, pw - ctrW( 20 ), ph - ctrH( 20 ), ctrW( 20 ), ctrH( 20 ), Color( 0, 255, 0, 200 ) )
    end

    drawText( textPre, "HudBars", pw, ph, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

    if frame:IsHovered() then

      local tw, th = frame:GetSize()
      if tw != ctrW( cl_db[tmpw] ) or th != ctrW( cl_db[tmph] ) then
        cl_db[tmpw] = (tw*ctrF( ScrH() )) - (tw*ctrF( ScrH() ))%20
        cl_db[tmph] = (th*ctrF( ScrH() )) - (th*ctrF( ScrH() ))%20
        frame:SetSize( ctrW( cl_db[tmpw] ), ctrW( cl_db[tmph] ) )
        updateDBHud( tmpw, cl_db[tmpw] )
        updateDBHud( tmph, cl_db[tmph] )
      end

      local x, y = frame:GetPos()
      if x != ctrW( cl_db[tmpx] ) or y != ctrW( cl_db[tmpy] ) then
        local w, h = frame:GetSize()
        local outside = false
        if x+w > ScrW() then
          frame:SetPos( ScrW()-w, y )
          outside = true
        elseif y+h > ScrH() then
          frame:SetPos( x, ScrH()-h )
          outside = true
        elseif x < 0 then
          frame:SetPos( 0, y )
          outside = true
        elseif y < 0 then
          frame:SetPos( x, 0 )
          outside = true
        end
        if !outside then
          cl_db[tmpx] = ( x*ctrF( ScrH() ) ) - ( ( x*ctrF( ScrH() ) )%20 )
          cl_db[tmpy] = ( y*ctrF( ScrH() ) ) - ( ( y*ctrF( ScrH() ) )%20 )

          frame:SetPos( ctrW( cl_db[tmpx] ), ctrW( cl_db[tmpy] ) )
          updateDBHud( tmpx, cl_db[tmpx] )
          updateDBHud( tmpy, cl_db[tmpy] )
        end
      end
    end
  end

  local tmpToggle = createDerma( "DCheckBox", frame, 30, 30, 10, 10 )
  local tmpToggleChecked = -1
  if tonumber( cl_db[tmpt] ) == 0 then
    tmpToggleChecked = false
  elseif tonumber( cl_db[tmpt] ) == 1 then
    tmpToggleChecked = true
  end
  tmpToggle:SetChecked( tmpToggleChecked )
  function tmpToggle:OnChange( bVal )
  	if ( bVal ) then
      cl_db[tmpt] = 1
  		updateDBHud( tmpt, cl_db[tmpt] )
  	else
      cl_db[tmpt] = 0
  		updateDBHud( tmpt, cl_db[tmpt] )
  	end
  end

  return frame
end

function changeFont( string, _settingsFontSizes, w, h, x, y )
  local _tmp = createVGUI( "DNumberWang", _settingsFontSizes, w, h, x, y )
  _tmp:SetValue( cl_db[string] )
  _tmp:SetMin( 6 )
  _tmp:SetMax( 72 )
  function _tmp:OnValueChanged( val )
    if tonumber( val ) >= _tmp:GetMin() then
      if tonumber( val ) <= _tmp:GetMax() then
        updateDBHud( string, val )
        loadDBHud( "yrp_cl_hud", string )
        createFont( string, tmpFont, cl_db[string], 500, true )
      else
        updateDBHud( string, _tmp:GetMax() )
        loadDBHud( "yrp_cl_hud", string )
        createFont( string, tmpFont, cl_db[string], 500, true )
      end
    else
      updateDBHud( string, _tmp:GetMin() )
      loadDBHud( "yrp_cl_hud", string )
      createFont( string, tmpFont, cl_db[string], 500, true )
    end
  end
  return _tmp
end

hook.Add( "open_client_hud", "open_client_hud", function()
  local ply = LocalPlayer()

  local w = settingsWindow.sitepanel:GetWide()
  local h = settingsWindow.sitepanel:GetTall()

  settingsWindow.site = createD( "DPanel", settingsWindow.sitepanel, w, h, 0, 0 )
  --sheet:AddSheet( lang.hud, cl_hudPanel, "icon16/photo.png" )
  function settingsWindow.site:Paint( w, h )
    --draw.RoundedBox( 0, 0, 0, sv_generalPanel:GetWide(), sv_generalPanel:GetTall(), yrp.colors.panel )
  end

  local changeHudButton = createDerma( "DButton", settingsWindow.site, 470, 50, 0, 0 )
  changeHudButton:SetText( lang.changehud )
  function changeHudButton:DoClick()
    settingsWindow:Close()

    local changeHudWindow = createDerma( "DFrame", nil, ScrW() * ctrF( ScrH() ), ScrH() * ctrF( ScrH() ), 0, 0 )
    changeHudWindow:SetDraggable( false )
    changeHudWindow:SetTitle( "" )
    changeHudWindow:ShowCloseButton( false )
    function changeHudWindow:Paint( w, h )
      local gridSize = ctrW( 20 )
      draw.RoundedBox( 0, 0, 0, ScrW(), ScrH(), Color( 0, 0, 0, 120 ) )
      for i=1, ScrW()/gridSize do
        if i%(ScrW()/gridSize/2) == 0 then
          draw.RoundedBox( 0, (i*gridSize)-ctrW( 2 ), 0, ctrW( 4 ), ScrH(), Color( 255, 255, 0, 60 ) )
        elseif i%10 == 1 then
            draw.RoundedBox( 0, (i*gridSize)-ctrW( 2 ), 0, ctrW( 4 ), ScrH(), Color( 0, 0, 255, 50 ) )
        else
          draw.RoundedBox( 0, (i*gridSize)-ctrW( 2 ), 0, ctrW( 4 ), ScrH(), Color( 255, 255, 255, 20 ) )
        end
      end

      for i=1, ScrH()/gridSize do
        if i%(ScrH()/gridSize/2) == 0 then
          draw.RoundedBox( 0, 0, (i*gridSize)-2, ScrW(), ctrW( 4 ), Color( 255, 255, 0, 60 ) )
        elseif i%10 == 9 then
          draw.RoundedBox( 0, 0, (i*gridSize)-2, ScrW(), ctrW( 4 ), Color( 0, 0, 255, 50 ) )
        else
          draw.RoundedBox( 0, 0, (i*gridSize)-2, ScrW(), ctrW( 4 ), Color( 255, 255, 255, 20 ) )
        end
      end
    end

    local changeHudWindowCloseButton = createDerma( "DButton", changeHudWindow, ScrW() * ctrF( ScrH() ), ScrH() * ctrF( ScrH() ), 0, 0 )
    changeHudWindowCloseButton:SetText( "" )
    function changeHudWindowCloseButton:DoClick()
      changeHudWindow:Close()
    end
    function changeHudWindowCloseButton:Paint( pw, ph )
      draw.SimpleText( lang.helpclose, "HudBars", pw/2, ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

      draw.SimpleText( lang.helpmove, "HudBars", pw/2, ph/2+20, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
      draw.SimpleText( lang.helpresize, "HudBars", pw/2, ph/2+40, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    end

    changeHudElement( changeHudWindow, "mmx", "mmy", "mmw", "mmh", "mmt", lang.minimap )
    changeHudElement( changeHudWindow, "hpx", "hpy", "hpw", "hph", "hpt", lang.health )
    changeHudElement( changeHudWindow, "arx", "ary", "arw", "arh", "art", lang.armor )
    changeHudElement( changeHudWindow, "wnx", "wny", "wnw", "wnh", "wnt", lang.wname )
    changeHudElement( changeHudWindow, "wpx", "wpy", "wpw", "wph", "wpt", lang.wprimary )
    changeHudElement( changeHudWindow, "wsx", "wsy", "wsw", "wsh", "wst", lang.wsecondary )
    changeHudElement( changeHudWindow, "rix", "riy", "riw", "rih", "rit", lang.role )
    changeHudElement( changeHudWindow, "ttx", "tty", "ttw", "tth", "ttt", lang.tooltip )
    changeHudElement( changeHudWindow, "mox", "moy", "mow", "moh", "mot", lang.money )
    changeHudElement( changeHudWindow, "mhx", "mhy", "mhw", "mhh", "mht", lang.hunger )
    changeHudElement( changeHudWindow, "mtx", "mty", "mtw", "mth", "mtt", lang.thirst )
    changeHudElement( changeHudWindow, "msx", "msy", "msw", "msh", "mst", lang.stamina )
    changeHudElement( changeHudWindow, "max", "may", "maw", "mah", "mat", "Mana" )
    changeHudElement( changeHudWindow, "cax", "cay", "caw", "cah", "cat", "Cast" )
    changeHudElement( changeHudWindow, "stx", "sty", "stw", "sth", "stt", "Status" )
    --local votes = changeHudElement( changeHudWindow, "vtx", "vty", "vtw", "vth", "vtt", lang.votes )
    --votes:SetSizable( false )

    changeHudElement( changeHudWindow, "cbx", "cby", "cbw", "cbh", "cbt", "ChatBox" )

    changeHudWindow:MakePopup()
  end

  function testIf( question, atrue, afalse )
    if question == 1 then
      return atrue
    else
      return afalse
    end
  end

  local toggleHud = createVGUI( "DButton", settingsWindow.site, 470, 50, 0, 50 + 10 )
  toggleHud:SetText( lang.togglehud .. " (" .. testIf( GetConVar( "yrp_cl_hud" ):GetInt(), lang.on, lang.off ) .. ")" )
  function toggleHud:DoClick()
    if GetConVar( "yrp_cl_hud" ):GetInt() == 1 then
      GetConVar( "yrp_cl_hud" ):SetInt( 0 )
    elseif GetConVar( "yrp_cl_hud" ):GetInt() == 0 then
      GetConVar( "yrp_cl_hud" ):SetInt( 1 )
    end
    toggleHud:SetText( lang.togglehud .. " (" .. testIf( GetConVar( "yrp_cl_hud" ):GetInt(), lang.on, lang.off ) .. ")" )
  end

  local resetHudButton = createDerma( "DColorButton", settingsWindow.site, 470, 50, 470 + 10, 50 + 10 )
  resetHudButton:SetText( "" )
  function resetHudButton:Paint( pw, ph )
    if resetHudButton:IsHovered() then
      draw.RoundedBox( 0, 0,0, pw, ph, Color( 255, 255, 0 ) )
    else
      draw.RoundedBox( 0, 0,0, pw, ph, Color( 255, 0, 0 ) )
    end

    draw.SimpleText( lang.resethud, "sef", pw/2, ph/2, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
  end
  function resetHudButton:DoClick()
    local _window = createVGUI( "DFrame", nil, 430, 50 + 10 + 50 + 10, 0, 0 )
    _window:Center()
    _window:SetTitle( lang.areyousure )

    local _yesButton = createVGUI( "DButton", _window, 200, 50, 10, 60 )
    _yesButton:SetText( lang.yes )
    function _yesButton:DoClick()
      resetHud()
      _window:Close()
    end

    local _noButton = createVGUI( "DButton", _window, 200, 50, 10 + 200 + 10, 60 )
    _noButton:SetText( lang.no )
    function _noButton:DoClick()
      _window:Close()
    end

    _window:MakePopup()
  end

  local _colorBackgroundPanel = createVGUI( "DPanel", settingsWindow.site, 470, 510, 0, 50+10+50+10 )
  function _colorBackgroundPanel:Paint( pw, ph )
    draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 255, 255 ) )

    draw.SimpleText( lang.hudbackground, "sef", ctrW( 10 ), ctrW( 50 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM )
  end

  local _colorBackground = createVGUI( "DColorMixer", _colorBackgroundPanel, 450, 450, 10, 50 )
  _colorBackground:SetPalette( true )
  _colorBackground:SetAlphaBar( true )
  _colorBackground:SetWangs( true )
  if cl_db["colbgr"] != nil then
    _colorBackground:SetColor( Color( cl_db["colbgr"], cl_db["colbgg"], cl_db["colbgb"], cl_db["colbga"] ) )	--Set the default color
  end
  function _colorBackground:ValueChanged( newColor )
    updateDBHud( "colbgr", newColor.r )
    updateDBHud( "colbgg", newColor.g )
    updateDBHud( "colbgb", newColor.b )
    updateDBHud( "colbga", newColor.a )
  end

  local _colorBorderPanel = createVGUI( "DPanel", settingsWindow.site, 470, 510, 470+10, 50+10+50+10 )
  function _colorBorderPanel:Paint( pw, ph )
    draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 255, 255 ) )

    draw.SimpleText( lang.hudborder, "sef", ctrW( 10 ), ctrW( 50 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM )
  end

  local _colorBorder = createVGUI( "DColorMixer", _colorBorderPanel, 450, 450, 10, 50 )
  _colorBorder:SetPalette( true )
  _colorBorder:SetAlphaBar( true )
  _colorBorder:SetWangs( true )
  _colorBorder:SetColor( Color( cl_db["colbrr"], cl_db["colbrg"], cl_db["colbrb"], cl_db["colbra"] ) )	--Set the default color
  function _colorBorder:ValueChanged( newColor )
    updateDBHud( "colbrr", newColor.r )
    updateDBHud( "colbrg", newColor.g )
    updateDBHud( "colbrb", newColor.b )
    updateDBHud( "colbra", newColor.a )
  end

  local _colorCrosshairPanel = createVGUI( "DPanel", settingsWindow.site, 470, 510, 0, 50+10+50+10+510+10 )
  function _colorCrosshairPanel:Paint( pw, ph )
    draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 255, 255 ) )

    draw.SimpleText( lang.crosshair, "sef", ctrW( 10 ), ctrW( 50 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM )
  end

  local _colorCrosshair = createVGUI( "DColorMixer", _colorCrosshairPanel, 450, 450, 10, 50 )
  _colorCrosshair:SetPalette( true )
  _colorCrosshair:SetAlphaBar( true )
  _colorCrosshair:SetWangs( true )
  _colorCrosshair:SetColor( Color( cl_db["colchr"], cl_db["colchg"], cl_db["colchb"], cl_db["colcha"] ) )	--Set the default color
  function _colorCrosshair:ValueChanged( newColor )
    updateDBHud( "colchr", newColor.r )
    updateDBHud( "colchg", newColor.g )
    updateDBHud( "colchb", newColor.b )
    updateDBHud( "colcha", newColor.a )
  end

  local _colorCrosshairBorderPanel = createVGUI( "DPanel", settingsWindow.site, 470, 510, 470+10, 50+10+50+10+510+10 )
  function _colorCrosshairBorderPanel:Paint( pw, ph )
    draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 255, 255 ) )

    draw.SimpleText( lang.crosshairborder, "sef", ctrW( 10 ), ctrW( 50 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM )
  end

  local _colorCrosshairBorder = createVGUI( "DColorMixer", _colorCrosshairBorderPanel, 450, 450, 10, 50 )
  _colorCrosshairBorder:SetPalette( true )
  _colorCrosshairBorder:SetAlphaBar( true )
  _colorCrosshairBorder:SetWangs( true )
  _colorCrosshairBorder:SetColor( Color( cl_db["colchbrr"], cl_db["colchbrg"], cl_db["colchbrb"], cl_db["colchbra"] ) )	--Set the default color
  function _colorCrosshairBorder:ValueChanged( newColor )
    updateDBHud( "colchbrr", newColor.r )
    updateDBHud( "colchbrg", newColor.g )
    updateDBHud( "colchbrb", newColor.b )
    updateDBHud( "colchbra", newColor.a )
  end

  local _settingCrosshairPanel = createVGUI( "DPanel", settingsWindow.site, 470, 510, 470+10+470+10, 50+10+50+10+510+10 )
  function _settingCrosshairPanel:Paint( pw, ph )
    draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 255, 255 ) )

    draw.SimpleText( lang.crosshairsettings, "sef", ctrW( 10 ), ctrW( 50 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM )

    draw.SimpleText( lang.length .. ":", "sef", ctrW( 10 ), ctrW( 100 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM )
    draw.SimpleText( lang.gap .. ":", "sef", ctrW( 10 ), ctrW( 200 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM )
    draw.SimpleText( lang.thickness .. ":", "sef", ctrW( 10 ), ctrW( 300 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM )
    draw.SimpleText( lang.border .. ":", "sef", ctrW( 10 ), ctrW( 400 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM )
  end

  local _settingCrosshairLength = createVGUI( "DNumberWang", _settingCrosshairPanel, 450, 50, 10, 100 )
  _settingCrosshairLength:SetValue( cl_db["chl"] )
  function _settingCrosshairLength:OnValueChanged( val )
    updateDBHud( "chl", val )
  end

  local _settingCrosshairGap = createVGUI( "DNumberWang", _settingCrosshairPanel, 450, 50, 10, 200 )
  _settingCrosshairGap:SetValue( cl_db["chg"] )
  function _settingCrosshairGap:OnValueChanged( val )
    updateDBHud( "chg", val )
  end

  local _settingCrosshairThickness = createVGUI( "DNumberWang", _settingCrosshairPanel, 450, 50, 10, 300 )
  _settingCrosshairThickness:SetValue( cl_db["chh"] )
  function _settingCrosshairThickness:OnValueChanged( val )
    updateDBHud( "chh", val )
  end

  local _settingCrosshairBorder = createVGUI( "DNumberWang", _settingCrosshairPanel, 450, 50, 10, 400 )
  _settingCrosshairBorder:SetValue( cl_db["chbr"] )
  function _settingCrosshairBorder:OnValueChanged( val )
    updateDBHud( "chbr", val )
  end

  local _settingsFontSizes = createVGUI( "DPanel", settingsWindow.site, 1910, 510, 0, 50+10+50+10+510+10+510+10 )
  function _settingsFontSizes:Paint( pw, ph )
    draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 255, 255 ) )

    draw.SimpleText( "Change FontSizes", "sef", ctrW( 10 ), ctrW( 50 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM )

    draw.SimpleText( lang.health .. ":", "sef", ctrW( 10 ), ctrW( 100 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM )
    draw.SimpleText( lang.armor .. ":", "sef", ctrW( 10 ), ctrW( 200 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM )
    draw.SimpleText( lang.hunger .. ":", "sef", ctrW( 10 ), ctrW( 300 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM )
    draw.SimpleText( lang.thirst .. ":", "sef", ctrW( 10 ), ctrW( 400 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM )

    draw.SimpleText( lang.stamina .. ":", "sef", ctrW( 480 ), ctrW( 100 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM )
    draw.SimpleText( lang.money .. ":", "sef", ctrW( 480 ), ctrW( 200 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM )
    draw.SimpleText( lang.role .. ":", "sef", ctrW( 480 ), ctrW( 300 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM )
    draw.SimpleText( lang.minimap .. ":", "sef", ctrW( 480 ), ctrW( 400 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM )

    draw.SimpleText( lang.wprimary .. ":", "sef", ctrW( 960 ), ctrW( 100 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM )
    draw.SimpleText( lang.wsecondary .. ":", "sef", ctrW( 960 ), ctrW( 200 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM )
    draw.SimpleText( lang.wname .. ":", "sef", ctrW( 960 ), ctrW( 300 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM )
    draw.SimpleText( lang.votes .. ":", "sef", ctrW( 960 ), ctrW( 400 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM )

    draw.SimpleText( "Chat" .. ":", "sef", ctrW( 1440 ), ctrW( 100 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM )
    draw.SimpleText( "Voice" .. ":", "sef", ctrW( 1440 ), ctrW( 200 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM )
    draw.SimpleText( lang.tooltip .. ":", "sef", ctrW( 1440 ), ctrW( 300 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM )
    draw.SimpleText( lang.settings .. ":", "sef", ctrW( 1440 ), ctrW( 400 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM )
  end

  local _settingsHPF = changeFont( "hpf", _settingsFontSizes, 450, 40, 10, 100 )
  local _settingsARF = changeFont( "arf", _settingsFontSizes, 450, 40, 10, 200 )
  local _settingsMHF = changeFont( "mhf", _settingsFontSizes, 450, 40, 10, 300 )
  local _settingsMTF = changeFont( "mtf", _settingsFontSizes, 450, 40, 10, 400 )

  local _settingsMSF = changeFont( "msf", _settingsFontSizes, 450, 40, 480, 100 )
  local _settingsMOF = changeFont( "mof", _settingsFontSizes, 450, 40, 480, 200 )
  local _settingsRIF = changeFont( "rif", _settingsFontSizes, 450, 40, 480, 300 )
  local _settingsRIF = changeFont( "mmf", _settingsFontSizes, 450, 40, 480, 400 )

  local _settingsMSF = changeFont( "wpf", _settingsFontSizes, 450, 40, 960, 100 )
  local _settingsMOF = changeFont( "wsf", _settingsFontSizes, 450, 40, 960, 200 )
  local _settingsRIF = changeFont( "wnf", _settingsFontSizes, 450, 40, 960, 300 )
  local _settingsRIF = changeFont( "vtf", _settingsFontSizes, 450, 40, 960, 400 )

  local _settingsMSF = changeFont( "cbf", _settingsFontSizes, 450, 40, 1440, 100 )
  local _settingsMOF = changeFont( "vof", _settingsFontSizes, 450, 40, 1440, 200 )
  local _settingsMOF = changeFont( "ttf", _settingsFontSizes, 450, 40, 1440, 300 )
  local _settingsSEF = changeFont( "sef", _settingsFontSizes, 450, 40, 1440, 400 )
end)

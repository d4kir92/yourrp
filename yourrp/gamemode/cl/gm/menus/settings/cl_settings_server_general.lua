--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

local _advertname = "NULL"
local _restartTime = 0
hook.Add( "open_server_general", "open_server_general", function()
  local ply = LocalPlayer()

  local w = settingsWindow.window.sitepanel:GetWide()
  local h = settingsWindow.window.sitepanel:GetTall()

  settingsWindow.window.site = createD( "DPanel", settingsWindow.window.sitepanel, w, h, 0, 0 )

  local _center = 800

  local sv_generalName = vgui.Create( "DTextEntry", settingsWindow.window.site )
  local sv_generalAdvert = vgui.Create( "DTextEntry", settingsWindow.window.site )
  local sv_generalHunger = createVGUI( "DCheckBox", settingsWindow.window.site, 30, 30, _center, 315 )
  local sv_generalThirst = createVGUI( "DCheckBox", settingsWindow.window.site, 30, 30, _center, 375 )
  local sv_generalStamina = createVGUI( "DCheckBox", settingsWindow.window.site, 30, 30, _center, 435 )
  local sv_generalBuilding = createVGUI( "DCheckBox", settingsWindow.window.site, 30, 30, _center, 495 )
  local sv_generalHud = createVGUI( "DCheckBox", settingsWindow.window.site, 30, 30, _center, 555 )
  local sv_generalInventory = createVGUI( "DCheckBox", settingsWindow.window.site, 30, 30, _center, 615 )
  local sv_generalClearInventoryOnDead = createVGUI( "DCheckBox", settingsWindow.window.site, 30, 30, _center, 675 )
  local sv_generalGraffiti = createVGUI( "DCheckBox", settingsWindow.window.site, 30, 30, _center, 735 )
  local sv_generalRestartTime = vgui.Create( "DNumberWang", settingsWindow.window.site )
  local sv_generalViewDistance = vgui.Create( "DNumberWang", settingsWindow.window.site )
  local sv_generalRealisticDamage = createVGUI( "DCheckBox", settingsWindow.window.site, 30, 30, _center, 855 )
  local sv_generalRealisticFalldamage = createVGUI( "DCheckBox", settingsWindow.window.site, 30, 30, _center, 915 )
  local sv_generalSmartphone = createVGUI( "DCheckBox", settingsWindow.window.site, 30, 30, _center, 975 )

  local sv_generalNoClipCrow = createVGUI( "DCheckBox", settingsWindow.window.site, 30, 30, _center, 1100 )
  local sv_generalNoClipTags = createVGUI( "DCheckBox", settingsWindow.window.site, 30, 30, _center, 1160 )
  local sv_generalNoClipStealth = createVGUI( "DCheckBox", settingsWindow.window.site, 30, 30, _center, 1220 )
  local sv_generalNoClipEffect = createVGUI( "DCheckBox", settingsWindow.window.site, 30, 30, _center, 1280 )

  local oldGamemodename = ""
  function settingsWindow.window.site:Paint()
    --draw.RoundedBox( 0, 0, 0, settingsWindow.window.site:GetWide(), settingsWindow.window.site:GetTall(), _yrp.colors.panel )
    draw.SimpleTextOutlined( lang_string( "gamemodename" ) .. ":", "sef", ctr( _center - 10 ), ctr( 5 + 25 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
    if oldGamemodename != sv_generalName:GetText() then
      draw.SimpleTextOutlined( "you need to update Server!", "sef", ctr( _center + 400 + 10 ), ctr( 5 + 25 ), Color( 255, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
    end

    if string.lower( LocalPlayer():GetUserGroup() ) != "owner" then
      draw.SimpleTextOutlined( "Only UserGroup [owner] can reset DATABASE", "sef", ctr( 10 ), ctr( 270 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
    end

    draw.SimpleTextOutlined( lang_string( "advertname" ) .. ":", "sef", ctr( _center - 10 ), ctr( 90 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
    draw.SimpleTextOutlined( lang_string( "updatecountdown" ) .. ":", "sef", ctr( _center - 10 ), ctr( 150 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
    draw.SimpleTextOutlined( lang_string( "hunger" ) .. ":", "sef", ctr( _center - 10 ), ctr( 330 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
    draw.SimpleTextOutlined( lang_string( "thirst" ) .. ":", "sef", ctr( _center - 10 ), ctr( 390 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
    draw.SimpleTextOutlined( lang_string( "stamina" ) .. ":", "sef", ctr( _center - 10 ), ctr( 450 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
    draw.SimpleTextOutlined( lang_string( "building" ) .. ":", "sef", ctr( _center - 10 ), ctr( 510 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
    draw.SimpleTextOutlined( lang_string( "server_hud" ) .. ":", "sef", ctr( _center - 10 ), ctr( 570 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )

    draw.SimpleTextOutlined( lang_string( "inventory" ) .. ":", "sef", ctr( _center - 10 ), ctr( 630 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )

    draw.SimpleTextOutlined( "(After stable release)", "sef", ctr( _center + 60 ), ctr( 630 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )

    draw.SimpleTextOutlined( lang_string( "clearinventoryondead" ) .. ":", "sef", ctr( _center - 10 ), ctr( 690 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )

    draw.SimpleTextOutlined( "(After stable release)", "sef", ctr( _center + 60 ), ctr( 690 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )

    draw.SimpleTextOutlined( lang_string( "graffiti" ) .. ":", "sef", ctr( _center - 10 ), ctr( 750 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
    draw.SimpleTextOutlined( lang_string( "thirdpersonviewdistance" ) .. ":", "sef", ctr( _center - 10 ), ctr( 810 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )


    draw.SimpleTextOutlined( lang_string( "realisticdamage" ) .. ":", "sef", ctr( _center - 10 ), ctr( 870 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
    draw.SimpleTextOutlined( lang_string( "realisticfalldamage" ) .. ":", "sef", ctr( _center - 10 ), ctr( 930 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )

    draw.SimpleTextOutlined( lang_string( "smartphone" ) .. ":", "sef", ctr( _center - 10 ), ctr( 990 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )

    draw.SimpleTextOutlined( lang_string( "noclip" ) .. " [" .. lang_string( "crow" ) .. "]" .. ":", "sef", ctr( _center - 10 ), ctr( 1110 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
    draw.SimpleTextOutlined( lang_string( "noclip" ) .. " [" .. lang_string( "usergroup" ) .. "]" .. ":", "sef", ctr( _center - 10 ), ctr( 1170 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
    draw.SimpleTextOutlined( lang_string( "noclip" ) .. " [" .. lang_string( "stealth" ) .. "]" .. ":", "sef", ctr( _center - 10 ), ctr( 1230 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
    draw.SimpleTextOutlined( lang_string( "noclip" ) .. " [" .. lang_string( "effect" ) .. "]" .. ":", "sef", ctr( _center - 10 ), ctr( 1290 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
  end

  sv_generalName:SetPos( ctr( _center ), ctr( 5 ) )
  sv_generalName:SetSize( ctr( 400 ), ctr( 50 ) )
  sv_generalName:SetText( GAMEMODE.BaseName )

  net.Start("dbGetGeneral")
  net.SendToServer()

  net.Receive( "dbGetGeneral", function()
    local _yrp_general = net.ReadTable()

    GAMEMODE.BaseName = db_out_str( _yrp_general.name_gamemode ) or "FAILED"
    oldGamemodename = GAMEMODE.BaseName or ""
    sv_generalName:SetText( oldGamemodename )
    _advertname = _yrp_general.name_advert or "FAILED"
    sv_generalAdvert:SetText( tostring( _advertname ) )
    sv_generalHunger:SetChecked( tobool( _yrp_general.toggle_hunger ) )
    sv_generalThirst:SetChecked( tobool( _yrp_general.toggle_thirst ) )
    sv_generalStamina:SetChecked( tobool( _yrp_general.toggle_stamina ) )
    sv_generalBuilding:SetChecked( tobool( _yrp_general.toggle_building ) )
    sv_generalHud:SetValue( tonumber( _yrp_general.toggle_hud ) )
    sv_generalInventory:SetValue( tonumber( _yrp_general.toggle_inventory ) )
    sv_generalClearInventoryOnDead:SetValue( tonumber( _yrp_general.toggle_clearinventoryondead ) )
    sv_generalGraffiti:SetValue( tonumber( _yrp_general.toggle_graffiti ) )
    sv_generalRestartTime:SetValue( tonumber( _yrp_general.time_restart ) )
    sv_generalViewDistance:SetValue( tonumber( _yrp_general.view_distance ) )
    sv_generalRealisticDamage:SetValue( tonumber( _yrp_general.toggle_realistic_damage ) )
    sv_generalRealisticFalldamage:SetValue( tonumber( _yrp_general.toggle_realistic_falldamage ) )
    sv_generalSmartphone:SetValue( tonumber( _yrp_general.toggle_smartphone ) )

    sv_generalNoClipCrow:SetValue( tonumber( _yrp_general.toggle_noclip_crow ) )
    sv_generalNoClipTags:SetValue( tonumber( _yrp_general.toggle_noclip_tags ) )
    sv_generalNoClipStealth:SetValue( tonumber( _yrp_general.toggle_noclip_stealth ) )
    sv_generalNoClipEffect:SetValue( tonumber( _yrp_general.toggle_noclip_effect ) )
  end)

  sv_generalAdvert:SetPos( ctr( _center ), ctr( 5 + 50 + 10 ) )
  sv_generalAdvert:SetSize( ctr( 400 ), ctr( 50 ) )
  sv_generalAdvert:SetText( _advertname )
  function sv_generalAdvert:OnChange()
    net.Start( "updateAdvert" )
      net.WriteString( sv_generalAdvert:GetText() )
    net.SendToServer()
  end

  sv_generalRestartTime:SetPos( ctr( _center ), ctr( 5 + 50 + 10 + 50 + 10 ) )
  sv_generalRestartTime:SetSize( ctr( 400 ), ctr( 50 ) )
  sv_generalRestartTime:SetMin( 3 )
  sv_generalRestartTime:SetMax( 240 )
  sv_generalRestartTime:SetDecimals( 0 )
  function sv_generalRestartTime:OnValueChanged( value )
    net.Start( "updateGeneral" )
      net.WriteString( tostring( math.Round( value ) ) )
    net.SendToServer()
  end

  if string.lower( LocalPlayer():GetUserGroup() ) == "owner" then
    local sv_generalSQL = createD( "DButton", settingsWindow.window.site, ctr( 500 ), ctr( 50 ), BScrW()/2, ctr( 10 ) )
    sv_generalSQL:SetText( lang_string( "database" ) .. " (" .. lang_string( "wip" ) .. ")" )
    function sv_generalSQL:DoClick()
      local _win = createD( "DFrame", nil, ctr( 600 ), ctr( 800 ), 0, 0 )
      _win:SetTitle( "" )
      _win:MakePopup()
      _win:Center()
      function _win:Paint( pw, ph )
        surfaceBox( 0, 0, pw, ph, Color( 0, 0, 100, 200 ) )
      end

      local _sqlmode = createD( "DYRPPanelPlus", _win, ctr( 580 ), ctr( 100 ), ctr( 10 ), ctr( 50 ) )
      _sqlmode:INITPanel( "DComboBox" )
      _sqlmode:SetHeader( lang_string( "sqlmode" ) )
      _sqlmode.plus:AddChoice( "SQLite", 0 )
      _sqlmode.plus:AddChoice( "MYSQL", 1 )
      _sqlmode.plus.choice = "SQLite"
      function _sqlmode.plus:OnSelect( index, value, data )
        self.choice = value
      end

      local _sql_host = createD( "DYRPPanelPlus", _win, ctr( 580 ), ctr( 100 ), ctr( 10 ), ctr( 50 + 100 + 10 ) )
      _sql_host:INITPanel( "DTextEntry" )
      _sql_host:SetHeader( lang_string( "host" ) )

      local _sql_host = createD( "DYRPPanelPlus", _win, ctr( 580 ), ctr( 100 ), ctr( 10 ), ctr( 50 + 100 + 10 + 100 + 10 ) )
      _sql_host:INITPanel( "DTextEntry" )
      _sql_host:SetHeader( lang_string( "username" ) )

      local _sql_host = createD( "DYRPPanelPlus", _win, ctr( 580 ), ctr( 100 ), ctr( 10 ), ctr( 50 + 100 + 10 + 100 + 10 + 100 + 10 ) )
      _sql_host:INITPanel( "DTextEntry" )
      _sql_host:SetHeader( lang_string( "password" ) )

      local _sql_host = createD( "DYRPPanelPlus", _win, ctr( 580 ), ctr( 100 ), ctr( 10 ), ctr( 50 + 100 + 10 + 100 + 10 + 100 + 10 + 100 + 10 ) )
      _sql_host:INITPanel( "DTextEntry" )
      _sql_host:SetHeader( lang_string( "port" ) )

      local _sql_change_to = createD( "DButton", _win, ctr( 580 ), ctr( 100 ), ctr( 10 ), ctr( 50 + 100 + 10 + 100 + 10 + 100 + 10 + 100 + 10 + 100 + 10 ) )
      function _sql_change_to:Paint( pw, ph )
        surfaceBox( 0, 0, pw, ph, Color( 255, 255, 255, 200 ) )
        _sql_change_to:SetText( lang_string( "changetopre" ) .. " " .. tostring( _sqlmode.plus.choice ) .. " " .. lang_string( "changetopos" ) )
      end
    end
  end

  local sv_generalRestartServer = vgui.Create( "DButton", settingsWindow.window.site )
  sv_generalRestartServer:SetSize( ctr( 400 ), ctr( 50 ) )
  sv_generalRestartServer:SetPos( ctr( 5 ), ctr( 5 + 50 + 10 + 50 + 10 + 50 + 10 ) )
  sv_generalRestartServer:SetText( lang_string( "updateserver" ) )
  function sv_generalRestartServer:Paint()
    local color = Color( 255, 0, 0, 200 )
    if sv_generalRestartServer:IsHovered() then
      color = Color( 255, 255, 0, 200 )
    end
    draw.RoundedBox( ctr( 10 ), 0, 0, sv_generalRestartServer:GetWide(), sv_generalRestartServer:GetTall(), color )
  end
  function sv_generalRestartServer:DoClick()
    if sv_generalName != nil then
      net.Start( "updateServer" )
        GAMEMODE.BaseName = sv_generalName:GetText()
        net.WriteString( GAMEMODE.BaseName )
        net.WriteInt( math.Round( sv_generalRestartTime:GetValue() ), 16 )
      net.SendToServer()
    end
    settingsWindow.window:Close()
  end

  local sv_generalRestartServerCancel = vgui.Create( "DButton", settingsWindow.window.site )
  sv_generalRestartServerCancel:SetSize( ctr( 400 ), ctr( 50 ) )
  sv_generalRestartServerCancel:SetPos( ctr( 5 + 400 + 10 ), ctr( 5 + 50 + 10 + 50 + 10 + 50 + 10 ) )
  sv_generalRestartServerCancel:SetText( lang_string( "cancelupdateserver" ) )
  function sv_generalRestartServerCancel:Paint()
    local color = Color( 0, 255, 0, 200 )
    if sv_generalRestartServerCancel:IsHovered() then
      color = Color( 255, 255, 0, 200 )
    end
    draw.RoundedBox( ctr( 10 ), 0, 0, sv_generalRestartServerCancel:GetWide(), sv_generalRestartServerCancel:GetTall(), color )
  end
  function sv_generalRestartServerCancel:DoClick()
    net.Start( "cancelRestartServer" )
    net.SendToServer()
    settingsWindow.window:Close()
  end

  if string.lower( LocalPlayer():GetUserGroup() ) == "owner" then
    local sv_generalHardReset = vgui.Create( "DButton", settingsWindow.window.site )
    sv_generalHardReset:SetSize( ctr( 400 ), ctr( 50 ) )
    sv_generalHardReset:SetPos( ctr( 5 ), ctr( 5 + 50 + 10 + 50 + 10 + 50 + 10 + 50 + 10 ) )
    sv_generalHardReset:SetText( lang_string( "hardresetdatabase" ) )
    function sv_generalHardReset:Paint( pw, ph )
      local color = Color( 255, 0, 0, 200 )
      if sv_generalHardReset:IsHovered() then
        color = Color( 255, 255, 0, 200 )
      end
      draw.RoundedBox( ctr( 10 ), 0, 0, pw, ph, color )
    end
    function sv_generalHardReset:DoClick()
      local _tmpFrame = createVGUI( "DFrame", nil, 630, 110, 0, 0 )
      _tmpFrame:Center()
      _tmpFrame:SetTitle( lang_string( "areyousure" ) )
      function _tmpFrame:Paint( pw, ph )
        local color = Color( 0, 0, 0, 200 )
        draw.RoundedBox( ctr( 10 ), 0, 0, pw, ph, color )
      end

      local sv_generalHardResetSure = vgui.Create( "DButton", _tmpFrame )
      sv_generalHardResetSure:SetSize( ctr( 300 ), ctr( 50 ) )
      sv_generalHardResetSure:SetPos( ctr( 10 ), ctr( 50 ) )
      sv_generalHardResetSure:SetText( lang_string( "yes" ) .. ": DELETE DATABASE" )
      function sv_generalHardResetSure:DoClick()
        net.Start( "hardresetdatabase" )
        net.SendToServer()
        _tmpFrame:Close()
      end
      function sv_generalHardResetSure:Paint( pw, ph )
        local color = Color( 255, 0, 0, 200 )
        if sv_generalHardResetSure:IsHovered() then
          color = Color( 255, 255, 0, 200 )
        end
        draw.RoundedBox( ctr( 10 ), 0, 0, pw, ph, color )
      end

      local sv_generalHardResetNot = vgui.Create( "DButton", _tmpFrame )
      sv_generalHardResetNot:SetSize( ctr( 300 ), ctr( 50 ) )
      sv_generalHardResetNot:SetPos( ctr( 10 + 300 + 10 ), ctr( 50 ) )
      sv_generalHardResetNot:SetText( lang_string( "no" ) .. ": do nothing" )
      function sv_generalHardResetNot:DoClick()
        _tmpFrame:Close()
      end
      function sv_generalHardResetNot:Paint( pw, ph )
        local color = Color( 0, 255, 0, 200 )
        if sv_generalHardResetNot:IsHovered() then
          color = Color( 255, 255, 0, 200 )
        end
        draw.RoundedBox( ctr( 10 ), 0, 0, pw, ph, color )
      end
      settingsWindow.window:Close()
      _tmpFrame:MakePopup()
    end
  end

  function sv_generalHunger:OnChange( bVal )
    local _tonumber = 0
    if bVal then
      _tonumber = 1
    end
    net.Start( "db_update_hunger" )
      net.WriteInt( _tonumber, 4 )
    net.SendToServer()
  end

  function sv_generalThirst:OnChange( bVal )
    local _tonumber = 0
    if bVal then
      _tonumber = 1
    end
    net.Start( "db_update_thirst" )
      net.WriteInt( _tonumber, 4 )
    net.SendToServer()
  end

  function sv_generalStamina:OnChange( bVal )
    local _tonumber = 0
    if bVal then
      _tonumber = 1
    end
    net.Start( "db_update_stamina" )
      net.WriteInt( _tonumber, 4 )
    net.SendToServer()
  end

  function sv_generalBuilding:OnChange( bVal )
    local _tonumber = 0
    if bVal then
      _tonumber = 1
    end
    net.Start( "dbUpdateNWBool2" )
      net.WriteInt( _tonumber, 4 )
    net.SendToServer()
  end

  function sv_generalHud:OnChange( bVal )
    local _tonumber = 0
    if bVal then
      _tonumber = 1
    end
    net.Start( "db_update_hud" )
      net.WriteInt( _tonumber, 4 )
    net.SendToServer()
  end

  function sv_generalInventory:OnChange( bVal )
    local _tonumber = 0
    if bVal then
      _tonumber = 1
    end
    net.Start( "db_update_inventory" )
      net.WriteInt( _tonumber, 4 )
    net.SendToServer()
  end

  function sv_generalClearInventoryOnDead:OnChange( bVal )
    local _tonumber = 0
    if bVal then
      _tonumber = 1
    end
    net.Start( "db_update_clearinventoryondead" )
      net.WriteInt( _tonumber, 4 )
    net.SendToServer()
  end

  function sv_generalGraffiti:OnChange( bVal )
    local _tonumber = 0
    if bVal then
      _tonumber = 1
    end
    net.Start( "db_update_graffiti" )
      net.WriteInt( _tonumber, 4 )
    net.SendToServer()
  end

  sv_generalViewDistance:SetPos( ctr( _center ), ctr( 785 ) )
  sv_generalViewDistance:SetSize( ctr( 200 ), ctr( 50 ) )
  sv_generalViewDistance:SetMin( 0 )
  sv_generalViewDistance:SetMax( 800 )
  sv_generalViewDistance:SetDecimals( 0 )
  function sv_generalViewDistance:OnValueChanged( value )
    if tonumber( value ) > tonumber( self:GetMax() ) then
      value = tonumber( self:GetMax() )
      self:SetValue( value )
    end
    net.Start( "db_update_view_distance" )
      net.WriteInt( tostring( math.Round( value ) ), 16 )
    net.SendToServer()
  end

  function sv_generalRealisticDamage:OnChange( bVal )
    local _tonumber = 0
    if bVal then
      _tonumber = 1
    end
    net.Start( "db_update_realistic_damage" )
      net.WriteInt( _tonumber, 4 )
    net.SendToServer()
  end

  function sv_generalRealisticFalldamage:OnChange( bVal )
    local _tonumber = 0
    if bVal then
      _tonumber = 1
    end
    net.Start( "db_update_realistic_falldamage" )
      net.WriteInt( _tonumber, 4 )
    net.SendToServer()
  end

  function sv_generalSmartphone:OnChange( bVal )
    local _tonumber = 0
    if bVal then
      _tonumber = 1
    end
    net.Start( "db_update_smartphone" )
      net.WriteInt( _tonumber, 4 )
    net.SendToServer()
  end

  function sv_generalNoClipCrow:OnChange( bVal )
    local _tonumber = 0
    if bVal then
      _tonumber = 1
    end
    net.Start( "db_update_noclip_crow" )
      net.WriteInt( _tonumber, 4 )
    net.SendToServer()
  end

  function sv_generalNoClipTags:OnChange( bVal )
    local _tonumber = 0
    if bVal then
      _tonumber = 1
    end
    net.Start( "db_update_noclip_tags" )
      net.WriteInt( _tonumber, 4 )
    net.SendToServer()
  end

  function sv_generalNoClipStealth:OnChange( bVal )
    local _tonumber = 0
    if bVal then
      _tonumber = 1
    end
    net.Start( "db_update_noclip_stealth" )
      net.WriteInt( _tonumber, 4 )
    net.SendToServer()
  end

  function sv_generalNoClipEffect:OnChange( bVal )
    local _tonumber = 0
    if bVal then
      _tonumber = 1
    end
    net.Start( "db_update_noclip_effect" )
      net.WriteInt( _tonumber, 4 )
    net.SendToServer()
  end
end)

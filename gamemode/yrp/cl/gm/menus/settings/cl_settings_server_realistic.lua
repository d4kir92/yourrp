--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

net.Receive( "get_yrp_realistic", function( len )
  if pa( settingsWindow ) then
    local sv_bf = createD( "DCheckBox", settingsWindow.window.site, ctr( 50 ), ctr( 50 ), ctr( 10 ), ctr( 10 ) )
    local sv_bl = createD( "DCheckBox", settingsWindow.window.site, ctr( 50 ), ctr( 50 ), ctr( 10 ), ctr( 70 ) )

    local sv_blc = createD( "DNumberWang", settingsWindow.window.site, ctr( 200 ), ctr( 50 ), ctr( 400 ), ctr( 70 ) )

    local sv_bcl = createD( "DNumberWang", settingsWindow.window.site, ctr( 200 ), ctr( 50 ), ctr( 400 ), ctr( 10 ) )
    local sv_bca = createD( "DNumberWang", settingsWindow.window.site, ctr( 200 ), ctr( 50 ), ctr( 1100 ), ctr( 10 ) )

    local sv_hd = createD( "DCheckBox", settingsWindow.window.site, ctr( 50 ), ctr( 50 ), ctr( 10 ), ctr( 180 ) )
    local sv_hhead = createD( "DNumberWang", settingsWindow.window.site, ctr( 200 ), ctr( 50 ), ctr( 10 ), ctr( 300 ) )
    local sv_hches = createD( "DNumberWang", settingsWindow.window.site, ctr( 200 ), ctr( 50 ), ctr( 10 ), ctr( 370 ) )
    local sv_hstom = createD( "DNumberWang", settingsWindow.window.site, ctr( 200 ), ctr( 50 ), ctr( 10 ), ctr( 440 ) )
    local sv_harms = createD( "DNumberWang", settingsWindow.window.site, ctr( 200 ), ctr( 50 ), ctr( 10 ), ctr( 510 ) )
    local sv_hlegs = createD( "DNumberWang", settingsWindow.window.site, ctr( 200 ), ctr( 50 ), ctr( 10 ), ctr( 580 ) )

    local sv_hd_npc = createD( "DCheckBox", settingsWindow.window.site, ctr( 50 ), ctr( 50 ), ctr( 10 ), ctr( 780 ) )
    local sv_hhead_npc = createD( "DNumberWang", settingsWindow.window.site, ctr( 200 ), ctr( 50 ), ctr( 10 ), ctr( 900 ) )
    local sv_hches_npc = createD( "DNumberWang", settingsWindow.window.site, ctr( 200 ), ctr( 50 ), ctr( 10 ), ctr( 970 ) )
    local sv_hstom_npc = createD( "DNumberWang", settingsWindow.window.site, ctr( 200 ), ctr( 50 ), ctr( 10 ), ctr( 1040 ) )
    local sv_harms_npc = createD( "DNumberWang", settingsWindow.window.site, ctr( 200 ), ctr( 50 ), ctr( 10 ), ctr( 1110 ) )
    local sv_hlegs_npc = createD( "DNumberWang", settingsWindow.window.site, ctr( 200 ), ctr( 50 ), ctr( 10 ), ctr( 1180 ) )

    local sv_h_entity = createD( "DNumberWang", settingsWindow.window.site, ctr( 200 ), ctr( 50 ), ctr( 10 ), ctr( 1400 ) )
    local sv_h_vehicle = createD( "DNumberWang", settingsWindow.window.site, ctr( 200 ), ctr( 50 ), ctr( 10 ), ctr( 1470 ) )

    sv_blc:SetMax( 100 )

    sv_bcl:SetMax( 100 )
    sv_bca:SetMax( 100 )

    sv_hhead:SetMax( 999999999 )
    sv_hches:SetMax( 999999999 )
    sv_hstom:SetMax( 999999999 )
    sv_harms:SetMax( 999999999 )
    sv_hlegs:SetMax( 999999999 )

    sv_hhead_npc:SetMax( 999999999 )
    sv_hches_npc:SetMax( 999999999 )
    sv_hstom_npc:SetMax( 999999999 )
    sv_harms_npc:SetMax( 999999999 )
    sv_hlegs_npc:SetMax( 999999999 )

    sv_h_entity:SetMax( 999999999 )
    sv_h_vehicle:SetMax( 999999999 )

    local _preview = createD( "DNumberWang", settingsWindow.window.site, ctr( 200 ), ctr( 50 ), ctr( 1300 ), ctr( 240 ) )
    _preview:SetValue( 1.0 )

    function settingsWindow.window.site:Paint()
      --draw.RoundedBox( 0, 0, 0, settingsWindow.window.site:GetWide(), settingsWindow.window.site:GetTall(), _yrp.colors.panel )

      draw.SimpleTextOutlined( lang_string( "bonefracturing" ), "sef", ctr( 70 ), ctr( 35 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
      draw.SimpleTextOutlined( lang_string( "bleeding" ), "sef", ctr( 70 ), ctr( 95 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )

      draw.SimpleTextOutlined( "% " .. lang_string( "bleedingchance" ), "sef", ctr( 610 ), ctr( 95 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )

      draw.SimpleTextOutlined( "% " .. lang_string( "breakchance" ) .. " - " .. lang_string( "legs" ), "sef", ctr( 610 ), ctr( 35 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
      draw.SimpleTextOutlined( "% " .. lang_string( "breakchance" ) .. " - " .. lang_string( "arms" ), "sef", ctr( 1310 ), ctr( 35 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )

      draw.SimpleTextOutlined( lang_string( "damage" ) .. " (" .. lang_string( "preview" ) .. ")", "sef", ctr( 1300 - 10 ), ctr( 265 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )

      --[[ Players ]]--
      draw.SimpleTextOutlined( lang_string( "shotintheheadisdeadly" ) .. " (" .. lang_string( "players" ) .. ")", "sef", ctr( 70 ), ctr( 205 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )

      draw.SimpleTextOutlined( lang_string( "hitareas" ) .. " (" .. lang_string( "players" ) .. ")", "sef", ctr( 10 ), ctr( 265 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
      draw.SimpleTextOutlined( lang_string( "hitfactor" ) .. " - " .. lang_string( "head" ), "sef", ctr( 220 ), ctr( 325 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
      draw.SimpleTextOutlined( lang_string( "hitfactor" ) .. " - " .. lang_string( "chest" ), "sef", ctr( 220 ), ctr( 395 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
      draw.SimpleTextOutlined( lang_string( "hitfactor" ) .. " - " .. lang_string( "stomach" ), "sef", ctr( 220 ), ctr( 465 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
      draw.SimpleTextOutlined( lang_string( "hitfactor" ) .. " - " .. lang_string( "arms" ), "sef", ctr( 220 ), ctr( 535 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
      draw.SimpleTextOutlined( lang_string( "hitfactor" ) .. " - " .. lang_string( "legs" ), "sef", ctr( 220 ), ctr( 605 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )

      draw.SimpleTextOutlined( sv_hhead:GetValue()*_preview:GetValue() .. " " .. lang_string( "damage" ), "sef", ctr( 1300 ), ctr( 325 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
      draw.SimpleTextOutlined( sv_hches:GetValue()*_preview:GetValue() .. " " .. lang_string( "damage" ), "sef", ctr( 1300 ), ctr( 395 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
      draw.SimpleTextOutlined( sv_hstom:GetValue()*_preview:GetValue() .. " " .. lang_string( "damage" ), "sef", ctr( 1300 ), ctr( 465 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
      draw.SimpleTextOutlined( sv_harms:GetValue()*_preview:GetValue() .. " " .. lang_string( "damage" ), "sef", ctr( 1300 ), ctr( 535 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
      draw.SimpleTextOutlined( sv_hlegs:GetValue()*_preview:GetValue() .. " " .. lang_string( "damage" ), "sef", ctr( 1300 ), ctr( 605 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )

      --[[ NPCs ]]--
      draw.SimpleTextOutlined( lang_string( "shotintheheadisdeadly" ) .. " (" .. lang_string( "npcs" ) .. ")", "sef", ctr( 70 ), ctr( 805 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )

      draw.SimpleTextOutlined( lang_string( "hitareas" ) .. " (" .. lang_string( "npcs" ) .. ")", "sef", ctr( 10 ), ctr( 865 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
      draw.SimpleTextOutlined( lang_string( "hitfactor" ) .. " - " .. lang_string( "head" ), "sef", ctr( 220 ), ctr( 925 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
      draw.SimpleTextOutlined( lang_string( "hitfactor" ) .. " - " .. lang_string( "chest" ), "sef", ctr( 220 ), ctr( 995 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
      draw.SimpleTextOutlined( lang_string( "hitfactor" ) .. " - " .. lang_string( "stomach" ), "sef", ctr( 220 ), ctr( 1065 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
      draw.SimpleTextOutlined( lang_string( "hitfactor" ) .. " - " .. lang_string( "arms" ), "sef", ctr( 220 ), ctr( 1135 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
      draw.SimpleTextOutlined( lang_string( "hitfactor" ) .. " - " .. lang_string( "legs" ), "sef", ctr( 220 ), ctr( 1205 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )

      draw.SimpleTextOutlined( sv_hhead_npc:GetValue()*_preview:GetValue() .. " " .. lang_string( "damage" ), "sef", ctr( 1300 ), ctr( 925 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
      draw.SimpleTextOutlined( sv_hches_npc:GetValue()*_preview:GetValue() .. " " .. lang_string( "damage" ), "sef", ctr( 1300 ), ctr( 995 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
      draw.SimpleTextOutlined( sv_hstom_npc:GetValue()*_preview:GetValue() .. " " .. lang_string( "damage" ), "sef", ctr( 1300 ), ctr( 1065 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
      draw.SimpleTextOutlined( sv_harms_npc:GetValue()*_preview:GetValue() .. " " .. lang_string( "damage" ), "sef", ctr( 1300 ), ctr( 1135 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
      draw.SimpleTextOutlined( sv_hlegs_npc:GetValue()*_preview:GetValue() .. " " .. lang_string( "damage" ), "sef", ctr( 1300 ), ctr( 1205 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )

      draw.SimpleTextOutlined( lang_string( "hitfactor" ) .. " - " .. lang_string( "entities" ), "sef", ctr( 220 ), ctr( 1425 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
      draw.SimpleTextOutlined( lang_string( "hitfactor" ) .. " - " .. lang_string( "vehicles" ), "sef", ctr( 220 ), ctr( 1495 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )

      draw.SimpleTextOutlined( sv_h_entity:GetValue()*_preview:GetValue() .. " " .. lang_string( "damage" ), "sef", ctr( 1300 ), ctr( 1425 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
      draw.SimpleTextOutlined( sv_h_vehicle:GetValue()*_preview:GetValue() .. " " .. lang_string( "damage" ), "sef", ctr( 1300 ), ctr( 1495 ), Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0 ) )
    end

    local _tab = net.ReadTable()

    if sv_bf != NULL then
      sv_bf:SetValue( _tab.bonefracturing )
      sv_bl:SetValue( _tab.bleeding )

      sv_blc:SetValue( _tab.bleedingchance )

      sv_bcl:SetValue( _tab.bonechance_legs )
      sv_bca:SetValue( _tab.bonechance_arms )

      sv_hd:SetValue( _tab.headshotdeadly_player )
      sv_hhead:SetValue( _tab.hitfactor_player_head )
      sv_hches:SetValue( _tab.hitfactor_player_ches )
      sv_hstom:SetValue( _tab.hitfactor_player_stom )
      sv_harms:SetValue( _tab.hitfactor_player_arms )
      sv_hlegs:SetValue( _tab.hitfactor_player_legs )

      sv_hd_npc:SetValue( _tab.headshotdeadly_npc )
      sv_hhead_npc:SetValue( _tab.hitfactor_npc_head )
      sv_hches_npc:SetValue( _tab.hitfactor_npc_ches )
      sv_hstom_npc:SetValue( _tab.hitfactor_npc_stom )
      sv_harms_npc:SetValue( _tab.hitfactor_npc_arms )
      sv_hlegs_npc:SetValue( _tab.hitfactor_npc_legs )

      sv_h_entity:SetValue( _tab.hitfactor_entity )
      sv_h_vehicle:SetValue( _tab.hitfactor_vehicle )
    end

    function sv_h_entity:OnValueChanged( val )
      net.Start( "yrp_hit_entity" )
        net.WriteFloat( val )
      net.SendToServer()
    end

    function sv_h_vehicle:OnValueChanged( val )
      net.Start( "yrp_hit_vehicle" )
        net.WriteFloat( val )
      net.SendToServer()
    end

    function sv_bf:OnChange( bVal )
      local _tonumber = 0
      if bVal then
        _tonumber = 1
      end
      net.Start( "yrp_bonefracturing" )
        net.WriteInt( _tonumber, 4 )
      net.SendToServer()
    end

    function sv_bl:OnChange( bVal )
      local _tonumber = 0
      if bVal then
        _tonumber = 1
      end
      net.Start( "yrp_bleeding" )
        net.WriteInt( _tonumber, 4 )
      net.SendToServer()
    end

    --[[ Player ]]--
    function sv_hd:OnChange( bVal )
      local _tonumber = 0
      if bVal then
        _tonumber = 1
      end
      net.Start( "yrp_headdeadly" )
        net.WriteInt( _tonumber, 4 )
      net.SendToServer()
    end

    function sv_hhead:OnValueChanged( val )
      net.Start( "yrp_hithead" )
        net.WriteFloat( val, 16 )
      net.SendToServer()
    end

    function sv_hches:OnValueChanged( val )
      net.Start( "yrp_hitches" )
        net.WriteFloat( val, 16 )
      net.SendToServer()
    end

    function sv_hstom:OnValueChanged( val )
      net.Start( "yrp_hitstom" )
        net.WriteFloat( val, 16 )
      net.SendToServer()
    end

    function sv_harms:OnValueChanged( val )
      net.Start( "yrp_hitarms" )
        net.WriteFloat( val, 16 )
      net.SendToServer()
    end

    function sv_hlegs:OnValueChanged( val )
      net.Start( "yrp_hitlegs" )
        net.WriteFloat( val, 16 )
      net.SendToServer()
    end

    --[[ NPCs ]]--
    function sv_hd_npc:OnChange( bVal )
      local _tonumber = 0
      if bVal then
        _tonumber = 1
      end
      net.Start( "yrp_headdeadly_npc" )
        net.WriteInt( _tonumber, 4 )
      net.SendToServer()
    end

    function sv_hhead_npc:OnValueChanged( val )
      net.Start( "yrp_hithead_npc" )
        net.WriteFloat( val, 16 )
      net.SendToServer()
    end

    function sv_hches_npc:OnValueChanged( val )
      net.Start( "yrp_hitches_npc" )
        net.WriteFloat( val, 16 )
      net.SendToServer()
    end

    function sv_hstom_npc:OnValueChanged( val )
      net.Start( "yrp_hitstom_npc" )
        net.WriteFloat( val, 16 )
      net.SendToServer()
    end

    function sv_harms_npc:OnValueChanged( val )
      net.Start( "yrp_hitarms_npc" )
        net.WriteFloat( val, 16 )
      net.SendToServer()
    end

    function sv_hlegs_npc:OnValueChanged( val )
      net.Start( "yrp_hitlegs_npc" )
        net.WriteFloat( val, 16 )
      net.SendToServer()
    end

    function sv_bcl:OnValueChanged( val )
      net.Start( "yrp_bonechance_legs" )
        net.WriteFloat( val, 16 )
      net.SendToServer()
    end

    function sv_bca:OnValueChanged( val )
      net.Start( "yrp_bonechance_arms" )
        net.WriteFloat( val, 16 )
      net.SendToServer()
    end

    function sv_blc:OnValueChanged( val )
      net.Start( "yrp_bleedingchance" )
        net.WriteFloat( val, 16 )
      net.SendToServer()
    end
  end
end)

hook.Add( "open_server_realistic", "open_server_realistic", function()
  SaveLastSite()
  local ply = LocalPlayer()

  local w = settingsWindow.window.sitepanel:GetWide()
  local h = settingsWindow.window.sitepanel:GetTall()

  settingsWindow.window.site = createD( "DPanel", settingsWindow.window.sitepanel, w, h, 0, 0 )

  net.Start( "get_yrp_realistic" )
  net.SendToServer()
end)

--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

function CreateCheckBoxLine( dpanellist, val, lstr, netstr )
  local background = createD( "DPanel", nil, ctr( 800 ), ctr( 50 ), 0, 0 )
  background.text_posx = ctr( 50 + 10 )
  function background:Paint( pw, ph )
    surfacePanel( self, pw, ph, lang_string( lstr ), nil, self.text_posx, nil, 0, 1 )
  end

  background.checkbox = createD( "DCheckBox", background, ctr( 50 ), ctr( 50 ), 0, 0 )
  background.checkbox:SetValue( val )
  function background.checkbox:Paint( pw, ph )
    surfaceCheckBox( self, pw, ph, "done" )
  end
  background.checkbox.serverside = false

  function background.checkbox:OnChange( bVal )
    if !self.serverside then
      net.Start( netstr )
        net.WriteBool( bVal )
      net.SendToServer()
    end
  end

  net.Receive( netstr, function( len )
    local b = net.ReadString()
    if pa( background.checkbox ) then
      background.checkbox.serverside = true
      background.checkbox:SetValue( b )
      background.checkbox.serverside = false
    end
  end)

  dpanellist:AddItem( background )
  return background
end

function CreateCheckBoxLineTab( dpanellist, val, lstr, netstr )
  local cb = CreateCheckBoxLine( dpanellist, val, lstr, netstr )
  cb.checkbox:SetPos( ctr( 50 ), ctr( 0 ) )
  cb.text_posx = ctr( 50 + 50 + 10 )
end

function CreateButtonLine( dpanellist, lstr, netstr, lstr2 )
  local background = createD( "DPanel", nil, ctr( 800 ), ctr( 100 ), 0, 0 )
  function background:Paint( pw, ph )
    surfacePanel( self, pw, ph, lang_string( lstr ) .. ":", nil, ctr( 10 ), ph*1/4, 0, 1 )
  end

  background.button = createD( "DButton", background, ctr( 800 ) - ctr( 10*2 ), ctr( 50 ), ctr( 10 ), ctr( 50 ) )
  background.button:SetText( "" )
  function background.button:Paint( pw, ph )
    surfaceButton( self, pw, ph, lstr2 or lstr, Color( 200, 200, 200, 255 ) )
  end

  function background.button:DoClick()
    net.Start( netstr )
    net.SendToServer()
  end

  dpanellist:AddItem( background )

  return background
end

function CreateTextBoxLine( dpanellist, text, lstr, netstr )
  local background = createD( "DPanel", nil, ctr( 800 ), ctr( 100 ), 0, 0 )
  function background:Paint( pw, ph )
    surfacePanel( self, pw, ph, lang_string( lstr ) .. ":", nil, ctr( 10 ), ph*1/4, 0, 1 )
  end

  local textbox = createD( "DTextEntry", background, ctr( 800 ) - ctr( 10*2 ), ctr( 50 ), ctr( 10 ), ctr( 50 ) )
  textbox:SetText( text )
  textbox.serverside = false

  function textbox:OnChange()
    if !self.serverside then
      net.Start( netstr )
        net.WriteString( self:GetText() )
      net.SendToServer()
    end
  end

  net.Receive( netstr, function( len )
    local text = net.ReadString()
    if pa( textbox ) then
      textbox.serverside = true
      textbox:SetText( text )
      textbox.serverside = false
    end
  end)

  dpanellist:AddItem( background )

  return background
end

function CreateTextBoxBox( dpanellist, text, lstr, netstr )
  local background = createD( "DPanel", nil, ctr( 800 ), ctr( 50+400 ), 0, 0 )
  function background:Paint( pw, ph )
    surfacePanel( self, pw, ph, lang_string( lstr ) .. ":", nil, ctr( 10 ), ctr( 25 ), 0, 1 )
  end

  local textbox = createD( "DTextEntry", background, ctr( 800 ) - ctr( 10*2 ), ctr( 400 ), ctr( 10 ), ctr( 50 ) )
  textbox:SetText( text )
  textbox:SetMultiline( true )
  textbox.serverside = false

  function textbox:OnChange()
    if !self.serverside then
      net.Start( netstr )
        net.WriteString( self:GetText() )
      net.SendToServer()
    end
  end

  net.Receive( netstr, function( len )
    local text = net.ReadString()
    if pa( textbox ) then
      textbox.serverside = true
      textbox:SetText( text )
      textbox.serverside = false
    end
  end)

  dpanellist:AddItem( background )

  return background
end

function CreateTextBoxLineSpecial( dpanellist, text, text2, lstr, netstr, netstr2 )
  local background = createD( "DPanel", nil, ctr( 800 ), ctr( 100 ), 0, 0 )
  function background:Paint( pw, ph )
    surfacePanel( self, pw, ph, lang_string( lstr ) .. ": (" .. text .. "100" .. text2 .. ")", nil, ctr( 10 ), ph*1/4, 0, 1 )
  end

  background.textbox = createD( "DTextEntry", background, ctr( 400 ) - ctr( 10*2 ), ctr( 50 ), ctr( 10 ), ctr( 50 ) )
  background.textbox:SetText( text )
  background.textbox.serverside = false

  function background.textbox:OnChange()
    if !self.serverside then
      net.Start( netstr )
        net.WriteString( self:GetText() )
      net.SendToServer()
    end
  end

  net.Receive( netstr, function( len )
    local text = net.ReadString()
    if pa( background.textbox ) then
      background.textbox.serverside = true
      background.textbox:SetText( text )
      background.textbox.serverside = false
    end
  end)

  background.textbox2 = createD( "DTextEntry", background, ctr( 400 ) - ctr( 10*2 ), ctr( 50 ), ctr( 10 + 400 ), ctr( 50 ) )
  background.textbox2:SetText( text2 )
  background.textbox2.serverside = false

  function background.textbox2:OnChange()
    if !self.serverside then
      net.Start( netstr2 )
        net.WriteString( self:GetText() )
      net.SendToServer()
    end
  end

  net.Receive( netstr2, function( len )
    local text = net.ReadString()
    if pa( background.textbox2 ) then
      background.textbox2.serverside = true
      background.textbox2:SetText( text )
      background.textbox2.serverside = false
    end
  end)

  dpanellist:AddItem( background )

  return background
end

function CreateNumberWangLine( dpanellist, value, lstr, netstr )
  local background = createD( "DPanel", nil, ctr( 800 ), ctr( 100 ), 0, 0 )
  function background:Paint( pw, ph )
    surfacePanel( self, pw, ph, lang_string( lstr ) .. ":", nil, ctr( 10 ), ph*1/4, 0, 1 )
  end

  background.numberwang = createD( "DNumberWang", background, ctr( 800 ) - ctr( 10*2 ), ctr( 50 ), ctr( 10 ), ctr( 50 ) )
  background.numberwang:SetMax( 999999999999 )
  background.numberwang:SetMin( -999999999999 )
  background.numberwang:SetValue( value )
  background.numberwang.serverside = false

  function background.numberwang:OnChange()
    if !self.serverside then
      net.Start( netstr )
        net.WriteString( self:GetText() )
      net.SendToServer()
    end
  end

  net.Receive( netstr, function( len )
    local value = net.ReadString()
    if pa( background.numberwang ) then
      background.numberwang.serverside = true
      background.numberwang:SetValue( value )
      background.numberwang.serverside = false
    end
  end)

  dpanellist:AddItem( background )

  return background
end

function CreateHRLine( dpanellist )
  local hr = createD( "DPanel", nil, ctr( 800 ), ctr( 20 ), 0, 0 )
  function hr:Paint( pw, ph )
    surfacePanel( self, pw, ph, "" )
    surfaceBox( ctr( 10 ), hr:GetTall()/4, hr:GetWide() - ctr( 2*10 ), hr:GetTall()/2, Color( 0, 0, 0, 255 ) )
  end
  dpanellist:AddItem( hr )
  return hr
end

net.Receive( "Connect_Settings_General", function( len )
  if pa( settingsWindow ) then
    if pa( settingsWindow.window ) then
      function settingsWindow.window.site:Paint( pw, ph )
        draw.RoundedBox( 4, 0, 0, pw, ph, Color( 0, 0, 0, 254 ) )

        surfaceText( lang_string( "wip" ), "mat1text", pw - ctr( 400 ), ph - ctr( 100 ), Color( 255, 255, 255 ), 1, 1 )
      end

      local PARENT = settingsWindow.window.site

      function PARENT:OnRemove()
        net.Start( "Disconnect_Settings_General" )
        net.SendToServer()
      end

      local GEN = net.ReadTable()
      printTab( GEN )



      local General_Slider = createD( "DHorizontalScroller", PARENT, ScrW() - ctr( 2*20 ), ScrH() - ctr( 100 + 20 + 20 ), ctr( 20 ), ctr( 20 ) )
      General_Slider:SetOverlap( - ctr( 20 ) )



      --[[ SERVER SETTINGS ]]--
      local Server_Settings = createD( "DPanel", General_Slider, ctr( 800 ), General_Slider:GetTall(), 0, 0 )
      General_Slider:AddPanel( Server_Settings )
      local SERVER_SETTINGS = createD( "DYRPPanelPlus", Server_Settings, ctr( 800 ), General_Slider:GetTall(), 0, 0 )
      SERVER_SETTINGS:INITPanel( "DPanelList" )
      SERVER_SETTINGS:SetHeader( "serversettings" )
      function SERVER_SETTINGS.plus:Paint( pw, ph )
        surfaceBox( 0, 0, pw, ph, Color( 80, 80, 80, 255 ) )
      end

      local bool_server_reload = CreateCheckBoxLine( SERVER_SETTINGS.plus, GEN.bool_server_reload, "automaticreloadingoftheserver", "update_bool_server_reload" )
      CreateHRLine( SERVER_SETTINGS.plus )
      local bool_noclip_effect = CreateCheckBoxLine( SERVER_SETTINGS.plus, GEN.bool_noclip_effect, "noclipeffect", "update_bool_noclip_effect" )
      local bool_noclip_stealth = CreateCheckBoxLineTab( SERVER_SETTINGS.plus, GEN.bool_noclip_stealth, "noclipcloak", "update_bool_noclip_stealth" )
      local bool_noclip_tags = CreateCheckBoxLine( SERVER_SETTINGS.plus, GEN.bool_noclip_tags, "noclipusergroup", "update_bool_noclip_tags" )
      local bool_noclip_model = CreateCheckBoxLine( SERVER_SETTINGS.plus, GEN.bool_noclip_model, "noclipmodel", "update_bool_noclip_model" )
      local noclip_mdl = CreateButtonLine( SERVER_SETTINGS.plus, "noclipmodel", "update_text_noclip_mdl", "change" )
      hook.Add( "update_text_noclip_mdl", "yrp_update_text_noclip_mdl", function()
        local mdl = LocalPlayer():GetNWString( "WorldModel", "" )
        net.Start( "update_text_noclip_mdl" )
          net.WriteString( mdl )
        net.SendToServer()
      end)
      function noclip_mdl.button:DoClick()
        local playermodels = player_manager.AllValidModels()
        local tmpTable = {}
        local count = 0
        for k, v in pairs( playermodels ) do
          count = count + 1
          tmpTable[count] = {}
          tmpTable[count].WorldModel = v
          tmpTable[count].ClassName = v
          tmpTable[count].PrintName = player_manager.TranslateToPlayerModelName( v )
        end

        LocalPlayer():SetNWString( "WorldModel", GEN.bool_noclip_mdl )
        OpenSingleSelector( tmpTable, "update_text_noclip_mdl" )
      end
      CreateHRLine( SERVER_SETTINGS.plus )
      local text_server_collectionid = CreateNumberWangLine( SERVER_SETTINGS.plus, GEN.text_server_collectionid, "collectionid", "update_text_server_collectionid" )
      CreateHRLine( SERVER_SETTINGS.plus )
      local text_server_logo = CreateTextBoxLine( SERVER_SETTINGS.plus, GEN.text_server_logo, "serverlogo", "update_text_server_logo" )
      --[LATER] CreateHRLine( SERVER_SETTINGS.plus )
      --[LATER] local community_servers = CreateButtonLine( SERVER_SETTINGS.plus, "communityservers", "update_community_servers" )
      CreateHRLine( SERVER_SETTINGS.plus )
      local text_server_rules = CreateTextBoxBox( SERVER_SETTINGS.plus, GEN.text_server_rules, "rules", "update_text_server_rules" )



      --[[ GAMEMODE SETTINGS ]]--
      local Gamemode_Settings = createD( "DPanel", General_Slider, ctr( 800 ), General_Slider:GetTall(), 0, 0 )
      General_Slider:AddPanel( Gamemode_Settings )
      local GAMEMODE_SETTINGS = createD( "DYRPPanelPlus", Gamemode_Settings, ctr( 800 ), General_Slider:GetTall(), 0, 0 )
      GAMEMODE_SETTINGS:INITPanel( "DPanelList" )
      GAMEMODE_SETTINGS:SetHeader( "gamemodesettings" )
      function GAMEMODE_SETTINGS.plus:Paint( pw, ph )
        surfaceBox( 0, 0, pw, ph, Color( 80, 80, 80, 255 ) )
      end

      local text_gamemode_name = CreateTextBoxLine( GAMEMODE_SETTINGS.plus, GEN.text_gamemode_name, "gamemodename", "update_text_gamemode_name" )
      CreateHRLine( GAMEMODE_SETTINGS.plus )
      local bool_graffiti_disabled = CreateCheckBoxLine( GAMEMODE_SETTINGS.plus, GEN.bool_graffiti_disabled, "graffitidisabled", "update_bool_graffiti_disabled" )
      local bool_anti_bhop = CreateCheckBoxLine( GAMEMODE_SETTINGS.plus, GEN.bool_anti_bhop, "antibunnyhop", "update_bool_anti_bhop" )
      local bool_suicide_disabled = CreateCheckBoxLine( GAMEMODE_SETTINGS.plus, GEN.bool_suicide_disabled, "suicidedisabled", "update_bool_suicide_disabled" )
      CreateHRLine( GAMEMODE_SETTINGS.plus )
      local bool_drop_items_on_death = CreateCheckBoxLine( GAMEMODE_SETTINGS.plus, GEN.bool_drop_items_on_death, "dropitemsondeath", "update_bool_drop_items_on_death" )
      CreateHRLine( GAMEMODE_SETTINGS.plus )
      local bool_players_can_drop_weapons = CreateCheckBoxLine( GAMEMODE_SETTINGS.plus, GEN.bool_players_can_drop_weapons, "playerscandropweapons", "update_bool_players_can_drop_weapons" )
      CreateHRLine( GAMEMODE_SETTINGS.plus )
      local bool_dealers_can_take_damage = CreateCheckBoxLine( GAMEMODE_SETTINGS.plus, GEN.bool_dealers_can_take_damage, "dealerscantakedamage", "update_bool_dealers_can_take_damage" )
      CreateHRLine( GAMEMODE_SETTINGS.plus )
      local text_view_distance = CreateNumberWangLine( GAMEMODE_SETTINGS.plus, GEN.text_view_distance, "thirdpersonmaxdistance", "update_text_view_distance" )
      CreateHRLine( GAMEMODE_SETTINGS.plus )
      local text_chat_advert = CreateTextBoxLine( GAMEMODE_SETTINGS.plus, GEN.text_chat_advert, "channelname", "update_text_chat_advert" )



      --[[ GAMEMODE SYSTEMS ]]--
      local Gamemode_Systems = createD( "DPanel", General_Slider, ctr( 800 ), General_Slider:GetTall(), 0, 0 )
      General_Slider:AddPanel( Gamemode_Systems )
      local GAMEMODE_SYSTEMS = createD( "DYRPPanelPlus", Gamemode_Systems, ctr( 800 ), General_Slider:GetTall(), 0, 0 )
      GAMEMODE_SYSTEMS:INITPanel( "DPanelList" )
      GAMEMODE_SYSTEMS:SetHeader( "gamemodesystems" )
      function GAMEMODE_SYSTEMS.plus:Paint( pw, ph )
        surfaceBox( 0, 0, pw, ph, Color( 80, 80, 80, 255 ) )
      end

      local bool_hunger = CreateCheckBoxLine( GAMEMODE_SYSTEMS.plus, GEN.bool_hunger, "hunger", "update_bool_hunger" )
      local bool_thirst = CreateCheckBoxLine( GAMEMODE_SYSTEMS.plus, GEN.bool_thirst, "thirst", "update_bool_thirst" )
      local bool_stamina = CreateCheckBoxLine( GAMEMODE_SYSTEMS.plus, GEN.bool_stamina, "stamina", "update_bool_stamina" )
      CreateHRLine( GAMEMODE_SYSTEMS.plus )
      local bool_building_system = CreateCheckBoxLine( GAMEMODE_SYSTEMS.plus, GEN.bool_building_system, "buildingsystem", "update_bool_building_system" )
      local bool_inventory_system = CreateCheckBoxLine( GAMEMODE_SYSTEMS.plus, GEN.bool_inventory_system, "inventorysystem", "update_bool_inventory_system" )
      local bool_realistic_system = CreateCheckBoxLine( GAMEMODE_SYSTEMS.plus, GEN.bool_realistic_system, "realisticsystem", "update_bool_realistic_system" )
      CreateHRLine( GAMEMODE_SYSTEMS.plus )
      local bool_appearance_system = CreateCheckBoxLine( GAMEMODE_SYSTEMS.plus, GEN.bool_appearance_system, "appearancesystem", "update_bool_appearance_system" )
      local bool_smartphone_system = CreateCheckBoxLine( GAMEMODE_SYSTEMS.plus, GEN.bool_smartphone_system, "smartphonesystem", "update_bool_smartphone_system" )
      local bool_weapon_lowering_system = CreateCheckBoxLine( GAMEMODE_SYSTEMS.plus, GEN.bool_weapon_lowering_system, "weaponloweringsystem", "update_bool_weapon_lowering_system" )
      CreateHRLine( GAMEMODE_SYSTEMS.plus )
      local bool_players_can_switch_role = CreateCheckBoxLine( GAMEMODE_SYSTEMS.plus, GEN.bool_players_can_switch_role, "playerscanswitchrole", "update_bool_players_can_switch_role" )
      CreateHRLine( GAMEMODE_SYSTEMS.plus )
      local bool_3d_voice = CreateCheckBoxLine( GAMEMODE_SYSTEMS.plus, GEN.bool_3d_voice, "3dvoicechat", "update_bool_3d_voice" )
      local bool_voice_channels = CreateCheckBoxLine( GAMEMODE_SYSTEMS.plus, GEN.bool_voice_channels, "voicechatchannels", "update_bool_voice_channels" )



      --[[ GAMEMODE VISUALS ]]--
      local Gamemode_Visuals = createD( "DPanel", General_Slider, ctr( 800 ), General_Slider:GetTall(), 0, 0 )
      General_Slider:AddPanel( Gamemode_Visuals )
      local GAMEMODE_VISUALS = createD( "DYRPPanelPlus", Gamemode_Visuals, ctr( 800 ), General_Slider:GetTall(), 0, 0 )
      GAMEMODE_VISUALS:INITPanel( "DPanelList" )
      GAMEMODE_VISUALS:SetHeader( "gamemodevisuals" )
      function GAMEMODE_VISUALS.plus:Paint( pw, ph )
        surfaceBox( 0, 0, pw, ph, Color( 80, 80, 80, 255 ) )
      end

      local bool_yrp_chat = CreateCheckBoxLine( GAMEMODE_VISUALS.plus, GEN.bool_yrp_chat, "yourrpchat", "update_bool_yrp_chat" )
      local bool_yrp_chat_show_rolename = CreateCheckBoxLineTab( GAMEMODE_VISUALS.plus, GEN.bool_yrp_chat_show_rolename, "showrolename", "update_bool_yrp_chat_show_rolename" )
      local bool_yrp_chat_show_groupname = CreateCheckBoxLineTab( GAMEMODE_VISUALS.plus, GEN.bool_yrp_chat_show_groupname, "showgroupname", "update_bool_yrp_chat_show_groupname" )
      local bool_yrp_crosshair = CreateCheckBoxLine( GAMEMODE_VISUALS.plus, GEN.bool_yrp_crosshair, "yourrpcrosshair", "update_bool_yrp_crosshair" )
      local bool_yrp_hud = CreateCheckBoxLine( GAMEMODE_VISUALS.plus, GEN.bool_yrp_hud, "yourrphud", "update_bool_yrp_hud" )
      local bool_yrp_scoreboard = CreateCheckBoxLine( GAMEMODE_VISUALS.plus, GEN.bool_yrp_scoreboard, "yourrpscoreboard", "update_bool_yrp_scoreboard" )
      local bool_yrp_scoreboard_show_usergroup = CreateCheckBoxLineTab( GAMEMODE_VISUALS.plus, GEN.bool_yrp_scoreboard_show_usergroup, "showusergroup", "update_bool_yrp_scoreboard_show_usergroup" )
      local bool_yrp_scoreboard_show_rolename = CreateCheckBoxLineTab( GAMEMODE_VISUALS.plus, GEN.bool_yrp_scoreboard_show_rolename, "showrolename", "update_bool_yrp_scoreboard_show_rolename" )
      local bool_yrp_scoreboard_show_groupname = CreateCheckBoxLineTab( GAMEMODE_VISUALS.plus, GEN.bool_yrp_scoreboard_show_groupname, "showgroupname", "update_bool_yrp_scoreboard_show_groupname" )
      local bool_yrp_scoreboard_show_language = CreateCheckBoxLineTab( GAMEMODE_VISUALS.plus, GEN.bool_yrp_scoreboard_show_language, "showlanguage", "update_bool_yrp_scoreboard_show_language" )
      local bool_yrp_scoreboard_show_playtime = CreateCheckBoxLineTab( GAMEMODE_VISUALS.plus, GEN.bool_yrp_scoreboard_show_playtime, "showplaytime", "update_bool_yrp_scoreboard_show_playtime" )
      local bool_yrp_scoreboard_show_frags = CreateCheckBoxLineTab( GAMEMODE_VISUALS.plus, GEN.bool_yrp_scoreboard_show_frags, "showfrags", "update_bool_yrp_scoreboard_show_frags" )
      local bool_yrp_scoreboard_show_deaths = CreateCheckBoxLineTab( GAMEMODE_VISUALS.plus, GEN.bool_yrp_scoreboard_show_deaths, "showdeaths", "update_bool_yrp_scoreboard_show_deaths" )
      CreateHRLine( GAMEMODE_VISUALS.plus )
      local bool_tag_on_head = CreateCheckBoxLine( GAMEMODE_VISUALS.plus, GEN.bool_tag_on_head, "overheadinfo", "update_bool_tag_on_head" )
      local bool_tag_on_head_name = CreateCheckBoxLineTab( GAMEMODE_VISUALS.plus, GEN.bool_tag_on_head_name, "showname", "update_bool_tag_on_head_name" )
      local bool_tag_on_head_clan = CreateCheckBoxLineTab( GAMEMODE_VISUALS.plus, GEN.bool_tag_on_head_clan, "showclan", "update_bool_tag_on_head_clan" )
      local bool_tag_on_head_rolename = CreateCheckBoxLineTab( GAMEMODE_VISUALS.plus, GEN.bool_tag_on_head_rolename, "showrolename", "update_bool_tag_on_head_rolename" )
      local bool_tag_on_head_groupname = CreateCheckBoxLineTab( GAMEMODE_VISUALS.plus, GEN.bool_tag_on_head_groupname, "showgroupname", "update_bool_tag_on_head_groupname" )
      local bool_tag_on_head_health = CreateCheckBoxLineTab( GAMEMODE_VISUALS.plus, GEN.bool_tag_on_head_health, "showhealth", "update_bool_tag_on_head_health" )
      local bool_tag_on_head_armor = CreateCheckBoxLineTab( GAMEMODE_VISUALS.plus, GEN.bool_tag_on_head_armor, "showarmor", "update_bool_tag_on_head_armor" )
      local bool_tag_on_head_usergroup = CreateCheckBoxLineTab( GAMEMODE_VISUALS.plus, GEN.bool_tag_on_head_usergroup, "showusergroup", "update_bool_tag_on_head_usergroup" )
      local bool_tag_on_head_voice = CreateCheckBoxLineTab( GAMEMODE_VISUALS.plus, GEN.bool_tag_on_head_voice, "showvoiceicon", "update_bool_tag_on_head_voice" )
      local bool_tag_on_head_chat = CreateCheckBoxLineTab( GAMEMODE_VISUALS.plus, GEN.bool_tag_on_head_chat, "showchaticon", "update_bool_tag_on_head_chat" )
      CreateHRLine( GAMEMODE_VISUALS.plus )
      local bool_tag_on_side = CreateCheckBoxLine( GAMEMODE_VISUALS.plus, GEN.bool_tag_on_side, "sideinfo", "update_bool_tag_on_side" )
      local bool_tag_on_side_name = CreateCheckBoxLineTab( GAMEMODE_VISUALS.plus, GEN.bool_tag_on_side_name, "showname", "update_bool_tag_on_side_name" )
      local bool_tag_on_side_clan = CreateCheckBoxLineTab( GAMEMODE_VISUALS.plus, GEN.bool_tag_on_side_clan, "showclan", "update_bool_tag_on_side_clan" )
      local bool_tag_on_side_rolename = CreateCheckBoxLineTab( GAMEMODE_VISUALS.plus, GEN.bool_tag_on_side_rolename, "showrolename", "update_bool_tag_on_side_rolename" )
      local bool_tag_on_side_groupname = CreateCheckBoxLineTab( GAMEMODE_VISUALS.plus, GEN.bool_tag_on_side_groupname, "showgroupname", "update_bool_tag_on_side_groupname" )
      local bool_tag_on_side_health = CreateCheckBoxLineTab( GAMEMODE_VISUALS.plus, GEN.bool_tag_on_side_health, "showhealth", "update_bool_tag_on_side_health" )
      local bool_tag_on_side_armor = CreateCheckBoxLineTab( GAMEMODE_VISUALS.plus, GEN.bool_tag_on_side_armor, "showarmor", "update_bool_tag_on_side_armor" )
      local bool_tag_on_side_usergroup = CreateCheckBoxLineTab( GAMEMODE_VISUALS.plus, GEN.bool_tag_on_side_usergroup, "showusergroup", "update_bool_tag_on_side_usergroup" )



      --[[ MONEY SETTINGS ]]--
      local Money_Settings = createD( "DPanel", General_Slider, ctr( 800 ), General_Slider:GetTall(), 0, 0 )
      General_Slider:AddPanel( Money_Settings )
      local MONEY_SETTINGS = createD( "DYRPPanelPlus", Money_Settings, ctr( 800 ), General_Slider:GetTall(), 0, 0 )
      MONEY_SETTINGS:INITPanel( "DPanelList" )
      MONEY_SETTINGS:SetHeader( "moneysettings" )
      function MONEY_SETTINGS.plus:Paint( pw, ph )
        surfaceBox( 0, 0, pw, ph, Color( 80, 80, 80, 255 ) )
      end

      local bool_drop_money_on_death = CreateCheckBoxLine( MONEY_SETTINGS.plus, GEN.bool_drop_money_on_death, "dropmoneyondeath", "update_bool_drop_money_on_death" )
      local text_money_max_amount_of_dropped_money = CreateNumberWangLine( MONEY_SETTINGS.plus, GEN.text_money_max_amount_of_dropped_money, "maxamountofdroppedmoney", "update_text_money_max_amount_of_dropped_money" )
      CreateHRLine( MONEY_SETTINGS.plus )
      local money_visual = CreateTextBoxLineSpecial( MONEY_SETTINGS.plus, GEN.text_money_pre, GEN.text_money_pos, "visual", "update_text_money_pre", "update_text_money_pos" )
      CreateHRLine( MONEY_SETTINGS.plus )
      local money_reset = CreateButtonLine( MONEY_SETTINGS.plus, "moneyreset", "update_money_reset", "moneyreset" )
      function money_reset.button:DoClick()
        local win = createVGUI( "DFrame", nil, 430, 50 + 10 + 50 + 10, 0, 0 )
        win:Center()
        win:SetTitle( lang_string( "areyousure" ) )
        local _yesButton = createVGUI( "DButton", win, 200, 50, 10, 60 )
        _yesButton:SetText( lang_string( "yes" ) )
        function _yesButton:DoClick()

          net.Start( "moneyreset" )
          net.SendToServer()

          win:Close()
        end
        local _noButton = createVGUI( "DButton", win, 200, 50, 10 + 200 + 10, 60 )
        _noButton:SetText( lang_string( "no" ) )
        function _noButton:DoClick()
          win:Close()
        end
        win:MakePopup()
      end



      --[[ SOCIAL SETTINGS ]]--
      local Social_Settings = createD( "DPanel", General_Slider, ctr( 800 ), General_Slider:GetTall(), 0, 0 )
      General_Slider:AddPanel( Social_Settings )
      local SOCIAL_SETTINGS = createD( "DYRPPanelPlus", Social_Settings, ctr( 800 ), General_Slider:GetTall(), 0, 0 )
      SOCIAL_SETTINGS:INITPanel( "DPanelList" )
      SOCIAL_SETTINGS:SetHeader( "socialsettings" )
      function SOCIAL_SETTINGS.plus:Paint( pw, ph )
        surfaceBox( 0, 0, pw, ph, Color( 80, 80, 80, 255 ) )
      end

      local text_social_website = CreateTextBoxLine( SOCIAL_SETTINGS.plus, GEN.text_social_website, "website", "update_text_social_website" )
      local text_social_forum = CreateTextBoxLine( SOCIAL_SETTINGS.plus, GEN.text_social_forum, "forum", "update_text_social_forum" )
      CreateHRLine( SOCIAL_SETTINGS.plus )
      local text_social_discord = CreateTextBoxLine( SOCIAL_SETTINGS.plus, GEN.text_social_discord, "discord", "update_text_social_discord" )
      local text_social_teamspeak = CreateTextBoxLine( SOCIAL_SETTINGS.plus, GEN.text_social_teamspeak, "teamspeak", "update_text_social_teamspeak" )
      CreateHRLine( SOCIAL_SETTINGS.plus )
      local text_social_youtube = CreateTextBoxLine( SOCIAL_SETTINGS.plus, GEN.text_social_youtube, "youtube", "update_text_social_youtube" )
      local text_social_twitter = CreateTextBoxLine( SOCIAL_SETTINGS.plus, GEN.text_social_twitter, "twitter", "update_text_social_twitter" )
      local text_social_facebook = CreateTextBoxLine( SOCIAL_SETTINGS.plus, GEN.text_social_facebook, "facebook", "update_text_social_facebook" )
      CreateHRLine( SOCIAL_SETTINGS.plus )
      local text_social_steamgroup = CreateTextBoxLine( SOCIAL_SETTINGS.plus, GEN.text_social_steamgroup, "steamgroup", "update_text_social_steamgroup" )

      --[[ OLD ]]--
      local sv_generalSQL = createD( "DButton", PARENT, ctr( 500 ), ctr( 50 ), BScrW()/2, ScrH() - ctr( 10 + 100 + 50 ) )
      sv_generalSQL:SetText( "" )
      function sv_generalSQL:Paint( pw, ph )
        surfaceButton( self, pw, ph, lang_string( "database" ) )
      end
      function sv_generalSQL:DoClick()
        net.Start( "get_sql_info" )
        net.SendToServer()
      end
      net.Receive( "get_sql_info", function( len )
        local _sv_sql = net.ReadTable()

        local _win = createD( "DFrame", nil, ctr( 600 ), ctr( 820 ), 0, 0 )
        _win:SetTitle( "" )
        _win:MakePopup()
        _win:Center()
        function _win:Paint( pw, ph )
          surfaceBox( 0, 0, pw, ph, Color( 0, 0, 100, 200 ) )
        end

        local _sql_host = createD( "DYRPPanelPlus", _win, ctr( 580 ), ctr( 100 ), ctr( 10 ), ctr( 50 + 100 + 10 ) )
        _sql_host:INITPanel( "DTextEntry" )
        _sql_host:SetHeader( lang_string( "host" ) )
        _sql_host.plus:SetText( _sv_sql.host )
        function _sql_host.plus:OnChange()
          net.Start( "set_host" )
            net.WriteString( _sql_host.plus:GetText() )
          net.SendToServer()
        end

        local _sql_port = createD( "DYRPPanelPlus", _win, ctr( 580 ), ctr( 100 ), ctr( 10 ), ctr( 50 + 100 + 10 + 100 + 10 ) )
        _sql_port:INITPanel( "DTextEntry" )
        _sql_port:SetHeader( lang_string( "port" ) )
        _sql_port.plus:SetText( _sv_sql.port )
        function _sql_port.plus:OnChange()
          net.Start( "set_port" )
            net.WriteString( _sql_port.plus:GetText() )
          net.SendToServer()
        end

        local _sql_database = createD( "DYRPPanelPlus", _win, ctr( 580 ), ctr( 100 ), ctr( 10 ), ctr( 50 + 100 + 10 + 100 + 10 + 100 + 10 ) )
        _sql_database:INITPanel( "DTextEntry" )
        _sql_database:SetHeader( lang_string( "database" ) )
        _sql_database.plus:SetText( _sv_sql.database )
        function _sql_database.plus:OnChange()
          net.Start( "set_database" )
            net.WriteString( _sql_database.plus:GetText() )
          net.SendToServer()
        end

        local _sql_username = createD( "DYRPPanelPlus", _win, ctr( 580 ), ctr( 100 ), ctr( 10 ), ctr( 50 + 100 + 10 + 100 + 10 + 100 + 10 + 100 + 10 ) )
        _sql_username:INITPanel( "DTextEntry" )
        _sql_username:SetHeader( lang_string( "username" ) )
        _sql_username.plus:SetText( _sv_sql.username )
        function _sql_username.plus:OnChange()
          net.Start( "set_username" )
            net.WriteString( _sql_username.plus:GetText() )
          net.SendToServer()
        end

        local _sql_password = createD( "DYRPPanelPlus", _win, ctr( 580 ), ctr( 100 ), ctr( 10 ), ctr( 50 + 100 + 10 + 100 + 10 + 100 + 10 + 100 + 10 + 100 + 10 ) )
        _sql_password:INITPanel( "DTextEntry" )
        _sql_password:SetHeader( lang_string( "password" ) )
        _sql_password.plus:SetText( _sv_sql.password )
        function _sql_password.plus:OnChange()
          net.Start( "set_password" )
            net.WriteString( _sql_password.plus:GetText() )
          net.SendToServer()
        end

        local _sqlmode = createD( "DYRPPanelPlus", _win, ctr( 580 ), ctr( 100 ), ctr( 10 ), ctr( 50 ) )
        _sqlmode:INITPanel( "DComboBox" )
        _sqlmode:SetHeader( lang_string( "sqlmode" ) )
        _sqlmode.plus.mode = GetSQLMode()
        if tonumber( _sv_sql.mode ) == 0 then
          _sql_host:SetVisible( false )
          _sql_port:SetVisible( false )
          _sql_database:SetVisible( false )
          _sql_username:SetVisible( false )
          _sql_password:SetVisible( false )
          _sqlmode.plus:AddChoice( "SQLite (" .. lang_string( "internal" ).. ")", 0, true )
          _sqlmode.plus.choice = "SQLite"
        else
          _sqlmode.plus:AddChoice( "SQLite (" .. lang_string( "internal" ).. ")", 0, false )
        end
        if tonumber( _sv_sql.mode ) == 1 then
          _sqlmode.plus:AddChoice( "MYSQL (" .. lang_string( "external" ).. ")", 1, true )
          _sqlmode.plus.choice = "MYSQL"
        else
          _sqlmode.plus:AddChoice( "MYSQL (" .. lang_string( "external" ).. ")", 1, false )
        end
        function _sqlmode.plus:OnSelect( index, value, data )
          self.choice = value
          if data == 0 then
            _sql_host:SetVisible( false )
            _sql_port:SetVisible( false )
            _sql_database:SetVisible( false )
            _sql_username:SetVisible( false )
            _sql_password:SetVisible( false )
          else
            _sql_host:SetVisible( true )
            _sql_port:SetVisible( true )
            _sql_database:SetVisible( true )
            _sql_username:SetVisible( true )
            _sql_password:SetVisible( true )
          end
          self.mode = data
        end

        local _sql_change_to = createD( "DButton", _win, ctr( 580 ), ctr( 100 ), ctr( 10 ), ctr( 50 + 100 + 10 + 100 + 10 + 100 + 10 + 100 + 10 + 100 + 10 + 100 + 10 ) )
        function _sql_change_to:Paint( pw, ph )
          surfaceBox( 0, 0, pw, ph, Color( 255, 255, 255, 200 ) )
          _sql_change_to:SetText( lang_string( "changetopre" ) .. " " .. tostring( _sqlmode.plus.choice ) .. " " .. lang_string( "changetopos" ) )
        end
        function _sql_change_to:DoClick()
          net.Start( "change_to_sql_mode" )
            net.WriteString( _sqlmode.plus.mode )
          net.SendToServer()
          _win:Close()
        end
      end)



    end
  end
end)

hook.Add( "open_server_general", "open_server_general", function()
  SaveLastSite()
  local ply = LocalPlayer()

  local w = settingsWindow.window.sitepanel:GetWide()
  local h = settingsWindow.window.sitepanel:GetTall()

  settingsWindow.window.site = createD( "DPanel", settingsWindow.window.sitepanel, w, h, 0, 0 )

  net.Start( "Connect_Settings_General" )
  net.SendToServer()
end)

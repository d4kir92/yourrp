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
	local background = createD( "DPanel", nil, ctr( 800 ), ctr( 100 + 10 ), 0, 0 )
	function background:Paint( pw, ph )
		surfacePanel( self, pw, ph, lang_string( lstr ) .. ":", nil, ctr( 10 ), ph * 1 / 4, 0, 1 )
	end

	background.button = createD( "DButton", background, ctr( 800 ) - ctr( 10 * 2 ), ctr( 50 ), ctr( 10 ), ctr( 50 ) )
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
	local background = createD( "DPanel", nil, ctr( 800 ), ctr( 100 + 10 ), 0, 0 )
	function background:Paint( pw, ph )
		surfacePanel( self, pw, ph, lang_string( lstr ) .. ":", nil, ctr( 10 ), ph * 1 / 4, 0, 1 )
	end

	local textbox = createD( "DTextEntry", background, ctr( 800 ) - ctr( 10 * 2 ), ctr( 50 ), ctr( 10 ), ctr( 50 ) )
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
		local tex = net.ReadString()
		if pa( textbox ) then
			textbox.serverside = true
			textbox:SetText( tex )
			textbox.serverside = false
		end
	end)

	dpanellist:AddItem( background )

	return background
end

function CreateTextBoxBox( dpanellist, text, lstr, netstr )
	local background = createD( "DPanel", nil, ctr( 800 ), ctr( 50 + 400 + 10 ), 0, 0 )
	function background:Paint( pw, ph )
		surfacePanel( self, pw, ph, lang_string( lstr ) .. ":", nil, ctr( 10 ), ctr( 25 ), 0, 1 )
	end

	local textbox = createD( "DTextEntry", background, ctr( 800 ) - ctr( 10 * 2 ), ctr( 400 ), ctr( 10 ), ctr( 50 ) )
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
		local tex = net.ReadString()
		if pa( textbox ) then
			textbox.serverside = true
			textbox:SetText( tex )
			textbox.serverside = false
		end
	end)

	dpanellist:AddItem( background )

	return background
end

function CreateTextBoxLineSpecial( dpanellist, text, text2, lstr, netstr, netstr2 )
	local background = createD( "DPanel", nil, ctr( 800 ), ctr( 100 + 10 ), 0, 0 )
	function background:Paint( pw, ph )
		local ply = LocalPlayer()
		surfacePanel( self, pw, ph, lang_string( lstr ) .. ": (" .. ply:GetNWString( "text_money_pre", "" ) .. "100" .. ply:GetNWString( "text_money_pos", "" ) .. ")", nil, ctr( 10 ), ph * 1 / 4, 0, 1 )
	end

	background.textbox = createD( "DTextEntry", background, ctr( 400 ) - ctr( 10 * 2 ), ctr( 50 ), ctr( 10 ), ctr( 50 ) )
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
		local tex = net.ReadString()
		if pa( background.textbox ) then
			background.textbox.serverside = true
			background.textbox:SetText( tex )
			background.textbox.serverside = false
		end
	end)

	background.textbox2 = createD( "DTextEntry", background, ctr( 400 ) - ctr( 10 * 2 ), ctr( 50 ), ctr( 10 + 400 ), ctr( 50 ) )
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
		local tex = net.ReadString()
		if pa( background.textbox2 ) then
			background.textbox2.serverside = true
			background.textbox2:SetText( tex )
			background.textbox2.serverside = false
		end
	end)

	dpanellist:AddItem( background )

	return background
end

function CreateNumberWangLine( dpanellist, value, lstr, netstr )
	local background = createD( "DPanel", nil, ctr( 800 ), ctr( 100 + 10 ), 0, 0 )
	function background:Paint( pw, ph )
		surfacePanel( self, pw, ph, lang_string( lstr ) .. ":", nil, ctr( 10 ), ph * 1 / 4, 0, 1 )
	end

	background.numberwang = createD( "DNumberWang", background, ctr( 800 ) - ctr( 10 * 2 ), ctr( 50 ), ctr( 10 ), ctr( 50 ) )
	background.numberwang:SetMax( 999999999999 )
	background.numberwang:SetMin( -999999999999 )
	background.numberwang:SetValue( value )
	background.numberwang.serverside = false

	function background.numberwang:OnChange()
		if !self.serverside then
			local num = tonumber( self:GetValue() )
			local max = self:GetMax()
			local min = self:GetMin()

			if num >= min and num <= max then
				net.Start( netstr )
					net.WriteString( num )
				net.SendToServer()
			else
				if num > max then
					self:SetText( max )
					num = max
				elseif num < min then
					self:SetText( min )
					num = min
				end
				net.Start( netstr )
					net.WriteString( num )
				net.SendToServer()
			end
		end
	end

	net.Receive( netstr, function( len )
		local val = net.ReadString()
		if pa( background.numberwang ) then
			background.numberwang.serverside = true
			background.numberwang:SetValue( val )
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
		surfaceBox( ctr( 10 ), hr:GetTall() / 4, hr:GetWide() - ctr( 2 * 10 ), hr:GetTall() / 2, Color( 0, 0, 0, 255 ) )
	end
	dpanellist:AddItem( hr )
	return hr
end

net.Receive( "Connect_Settings_General", function( len )
	if pa( settingsWindow ) then
		function settingsWindow.window.site:Paint( pw, ph )
			draw.RoundedBox( 4, 0, 0, pw, ph, Color( 0, 0, 0, 254 ) )
		end

		local PARENT = settingsWindow.window.site

		function PARENT:OnRemove()
			net.Start( "Disconnect_Settings_General" )
			net.SendToServer()
		end

		local GEN = net.ReadTable()



		local General_Slider = createD( "DHorizontalScroller", PARENT, ScrW() - ctr(2 * 20), ScrH() - ctr( 100 + 20 + 20 ), ctr( 20 ), ctr( 20 ) )
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
		CreateHRLine( SERVER_SETTINGS.plus )
		local text_server_welcome_message = CreateTextBoxLine( SERVER_SETTINGS.plus, GEN.text_server_welcome_message, "welcomemessage", "update_text_server_welcome_message" )
		local text_server_message_of_the_day = CreateTextBoxLine( SERVER_SETTINGS.plus, GEN.text_server_message_of_the_day, "messageoftheday", "update_text_server_message_of_the_day" )
		CreateHRLine( SERVER_SETTINGS.plus )
		local bool_server_debug = CreateCheckBoxLine( SERVER_SETTINGS.plus, GEN.bool_server_debug, "DEBUG MODE", "update_bool_server_debug" )
		local int_server_debug_tick = CreateNumberWangLine( SERVER_SETTINGS.plus, GEN.int_server_debug_tick, "DEBUG TICKRATE", "update_int_server_debug_tick" )
		int_server_debug_tick.numberwang:SetMin( 1 )
		int_server_debug_tick.numberwang:SetMax( 60*60 )


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
		text_view_distance.numberwang:SetMax( 9999 )
		text_view_distance.numberwang:SetMin( -200 )
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
		local text_hunger_health_regeneration_tickrate = CreateNumberWangLine( GAMEMODE_SYSTEMS.plus, GEN.text_hunger_health_regeneration_tickrate, "hungerhealthregenerationtickrate", "update_text_hunger_health_regeneration_tickrate" )
		text_hunger_health_regeneration_tickrate.numberwang:SetMax( 3600 )
		text_hunger_health_regeneration_tickrate.numberwang:SetMin( 1 )
		local bool_thirst = CreateCheckBoxLine( GAMEMODE_SYSTEMS.plus, GEN.bool_thirst, "thirst", "update_bool_thirst" )
		local bool_stamina = CreateCheckBoxLine( GAMEMODE_SYSTEMS.plus, GEN.bool_stamina, "stamina", "update_bool_stamina" )
		CreateHRLine( GAMEMODE_SYSTEMS.plus )
		local bool_building_system = CreateCheckBoxLine( GAMEMODE_SYSTEMS.plus, GEN.bool_building_system, "buildingsystem", "update_bool_building_system" )
		local bool_inventory_system = CreateCheckBoxLine( GAMEMODE_SYSTEMS.plus, GEN.bool_inventory_system, "inventorysystem", "update_bool_inventory_system" )
		local bool_realistic_system = CreateCheckBoxLine( GAMEMODE_SYSTEMS.plus, GEN.bool_realistic_system, "realisticsystem", "update_bool_realistic_system" )
		CreateHRLine( GAMEMODE_SYSTEMS.plus )
		local bool_map_system = CreateCheckBoxLine( GAMEMODE_SYSTEMS.plus, GEN.bool_map_system, "map", "update_bool_map_system" )
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
		local bool_yrp_chat_show_usergroup = CreateCheckBoxLineTab( GAMEMODE_VISUALS.plus, GEN.bool_yrp_chat_show_usergroup, "showusergroup", "update_bool_yrp_chat_show_usergroup" )
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
		local bool_yrp_scoreboard_show_operating_system = CreateCheckBoxLineTab( GAMEMODE_VISUALS.plus, GEN.bool_yrp_scoreboard_show_operating_system, "showoperatingsystem", "update_bool_yrp_scoreboard_show_operating_system" )
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
		CreateCheckBoxLine( GAMEMODE_VISUALS.plus, GEN.bool_tag_on_side, "sideinfo", "update_bool_tag_on_side" )
		CreateCheckBoxLineTab( GAMEMODE_VISUALS.plus, GEN.bool_tag_on_side_name, "showname", "update_bool_tag_on_side_name" )
		CreateCheckBoxLineTab( GAMEMODE_VISUALS.plus, GEN.bool_tag_on_side_clan, "showclan", "update_bool_tag_on_side_clan" )
		CreateCheckBoxLineTab( GAMEMODE_VISUALS.plus, GEN.bool_tag_on_side_rolename, "showrolename", "update_bool_tag_on_side_rolename" )
		CreateCheckBoxLineTab( GAMEMODE_VISUALS.plus, GEN.bool_tag_on_side_groupname, "showgroupname", "update_bool_tag_on_side_groupname" )
		CreateCheckBoxLineTab( GAMEMODE_VISUALS.plus, GEN.bool_tag_on_side_health, "showhealth", "update_bool_tag_on_side_health" )
		CreateCheckBoxLineTab( GAMEMODE_VISUALS.plus, GEN.bool_tag_on_side_armor, "showarmor", "update_bool_tag_on_side_armor" )
		CreateCheckBoxLineTab( GAMEMODE_VISUALS.plus, GEN.bool_tag_on_side_usergroup, "showusergroup", "update_bool_tag_on_side_usergroup" )



		--[[ MONEY SETTINGS ]]--
		local Money_Settings = createD( "DPanel", General_Slider, ctr( 800 ), General_Slider:GetTall(), 0, 0 )
		General_Slider:AddPanel( Money_Settings )
		local MONEY_SETTINGS = createD( "DYRPPanelPlus", Money_Settings, ctr( 800 ), General_Slider:GetTall(), 0, 0 )
		MONEY_SETTINGS:INITPanel( "DPanelList" )
		MONEY_SETTINGS:SetHeader( "moneysettings" )
		function MONEY_SETTINGS.plus:Paint( pw, ph )
			surfaceBox( 0, 0, pw, ph, Color( 80, 80, 80, 255 ) )
		end

		CreateCheckBoxLine( MONEY_SETTINGS.plus, GEN.bool_drop_money_on_death, "dropmoneyondeath", "update_bool_drop_money_on_death" )
		CreateNumberWangLine( MONEY_SETTINGS.plus, GEN.text_money_max_amount_of_dropped_money, "maxamountofdroppedmoney", "update_text_money_max_amount_of_dropped_money" )
		CreateHRLine( MONEY_SETTINGS.plus )
		CreateTextBoxLineSpecial( MONEY_SETTINGS.plus, GEN.text_money_pre, GEN.text_money_pos, "visual", "update_text_money_pre", "update_text_money_pos" )
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

		CreateTextBoxLine( SOCIAL_SETTINGS.plus, GEN.text_social_website, "website", "update_text_social_website" )
		CreateTextBoxLine( SOCIAL_SETTINGS.plus, GEN.text_social_forum, "forum", "update_text_social_forum" )
		CreateHRLine( SOCIAL_SETTINGS.plus )
		CreateTextBoxLine( SOCIAL_SETTINGS.plus, GEN.text_social_discord, "discord", "update_text_social_discord" )
		CreateTextBoxLine( SOCIAL_SETTINGS.plus, GEN.text_social_discord_widgetid, lang_string( "discord" ) .. " " .. lang_string( "serverid" ), "update_text_social_discord_widgetid" )
		CreateTextBoxLine( SOCIAL_SETTINGS.plus, GEN.text_social_teamspeak_ip, lang_string( "teamspeak" ) .. " [" .. lang_string( "ip" ) .. "/" .. lang_string( "hostname" ) .. "]", "update_text_social_teamspeak_ip" )
		CreateNumberWangLine( SOCIAL_SETTINGS.plus, GEN.text_social_teamspeak_port, lang_string( "teamspeak" ) .. " [" .. lang_string( "port" ) .. "]", "update_text_social_teamspeak_port" )
		CreateNumberWangLine( SOCIAL_SETTINGS.plus, GEN.text_social_teamspeak_query_port, lang_string( "teamspeak" ) .. " [" .. lang_string( "queryport" ) .. "]", "update_text_social_teamspeak_query_port" )
		CreateHRLine( SOCIAL_SETTINGS.plus )
		CreateTextBoxLine( SOCIAL_SETTINGS.plus, GEN.text_social_youtube, "Youtube", "update_text_social_youtube" )
		CreateTextBoxLine( SOCIAL_SETTINGS.plus, GEN.text_social_twitter, "Twitter", "update_text_social_twitter" )
		CreateTextBoxLine( SOCIAL_SETTINGS.plus, GEN.text_social_facebook, "Facebook", "update_text_social_facebook" )
		CreateHRLine( SOCIAL_SETTINGS.plus )
		CreateTextBoxLine( SOCIAL_SETTINGS.plus, GEN.text_social_steamgroup, "SteamGroup", "update_text_social_steamgroup" )
	end
end)

hook.Add( "open_server_general", "open_server_general", function()
	SaveLastSite()

	local w = settingsWindow.window.sitepanel:GetWide()
	local h = settingsWindow.window.sitepanel:GetTall()

	settingsWindow.window.site = createD( "DPanel", settingsWindow.window.sitepanel, w, h, 0, 0 )

	net.Start( "Connect_Settings_General" )
	net.SendToServer()
end)

--Copyright (C) 2017-2022 D4KiR (https://www.gnu.org/licenses/gpl.txt)

-- DO NOT TOUCH THE DATABASE FILES! If you have errors, report them here:
-- https://discord.gg/sEgNZxg

local DATABASE_NAME = "yrp_general"

--[[ Server Settings ]]--
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "int_version", "INT DEFAULT 1" )

YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_server_reload_notification", "INT DEFAULT 1" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_server_reload", "INT DEFAULT 1" )

YRP_SQL_ADD_COLUMN(DATABASE_NAME, "text_server_collectionid", "INT DEFAULT 0" )

YRP_SQL_ADD_COLUMN(DATABASE_NAME, "text_community_servers", "TEXT DEFAULT ''" )

YRP_SQL_ADD_COLUMN(DATABASE_NAME, "text_server_name", "TEXT DEFAULT ''" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "text_server_logo", "TEXT DEFAULT ''" )

YRP_SQL_ADD_COLUMN(DATABASE_NAME, "text_server_rules", "TEXT DEFAULT ''" )

YRP_SQL_ADD_COLUMN(DATABASE_NAME, "text_server_welcome_message", "TEXT DEFAULT 'Welcome'" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "text_server_message_of_the_day", "TEXT DEFAULT 'Today'" )

YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_server_debug", "INT DEFAULT 0" )

YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_server_debug_voice", "INT DEFAULT 0" )

YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_msg_channel_gm", "INT DEFAULT 1" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_msg_channel_db", "INT DEFAULT 1" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_msg_channel_noti", "INT DEFAULT 1" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_msg_channel_lang", "INT DEFAULT 1" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_msg_channel_darkrp", "INT DEFAULT 1" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_msg_channel_chat", "INT DEFAULT 0" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_msg_channel_debug", "INT DEFAULT 0" )



--[[ Gamemode Settings ]]--
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "text_gamemode_name", "TEXT DEFAULT 'YourRP'" )

YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_graffiti_disabled", "INT DEFAULT 1" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_suicide_disabled", "INT DEFAULT 1" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_team_color", "INT DEFAULT 1" )

YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_antipropkill", "INT DEFAULT 1" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_drop_items_on_death", "INT DEFAULT 1" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_drop_items_role", "INT DEFAULT 0" )

YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_players_need_to_introduce", "INT DEFAULT 0" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_players_can_drop_weapons", "INT DEFAULT 1" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_players_start_with_default_role", "INT DEFAULT 0" )

YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_dealers_can_take_damage", "INT DEFAULT 1" )

YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_thirdperson", "INT DEFAULT 1" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "text_view_distance", "TEXT DEFAULT '200'" )

YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_chat_ooc", "INT DEFAULT 1" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_chat_looc", "INT DEFAULT 1" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_chat_role", "INT DEFAULT 1" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_chat_group", "INT DEFAULT 1" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_chat_yell", "INT DEFAULT 1" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_chat_service", "INT DEFAULT 1" )

YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_canbeowned", "INT DEFAULT 1" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_removebuildingowner", "INT DEFAULT 0" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_removebuildingownercharswitch", "INT DEFAULT 0" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "text_removebuildingownertime", "TEXT DEFAULT '600'" )

YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_autopickup", "INT DEFAULT 0" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "int_ttlsweps", "INT DEFAULT 60" )

YRP_SQL_ADD_COLUMN(DATABASE_NAME, "int_afkkicktime", "INT DEFAULT 300" )



--[[ Gamemode Systems ]]--
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_onlywhencook", "INT DEFAULT 0" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_hunger", "INT DEFAULT 1" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_hunger_health_regeneration", "INT DEFAULT 1" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "text_hunger_health_regeneration_tickrate", "TEXT DEFAULT '10'" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_thirst", "INT DEFAULT 1" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_permille", "INT DEFAULT 0" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_stamina", "INT DEFAULT 1" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_radiation", "INT DEFAULT 0" )

YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_identity_card", "INT DEFAULT 1" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_map_system", "INT DEFAULT 1" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_character_system", "INT DEFAULT 1" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_building_system", "INT DEFAULT 1" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_inventory_system", "INT DEFAULT 0" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_laws_system", "INT DEFAULT 1" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_appearance_system", "INT DEFAULT 1" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "text_appearance_model", "TEXT DEFAULT 'models/props_wasteland/controlroom_storagecloset001a.mdl'" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_smartphone_system", "INT DEFAULT 1" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_realistic_system", "INT DEFAULT 1" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_level_system", "INT DEFAULT 1" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_weapon_system", "INT DEFAULT 1" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "text_weapon_system_model", "TEXT DEFAULT 'models/items/ammocrate_smg1.mdl'" )

YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_players_can_switch_faction", "INT DEFAULT 1" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_players_can_switch_role", "INT DEFAULT 1" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_players_die_on_role_switch", "INT DEFAULT 0" )

YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_wanted_system", "INT DEFAULT 0" )

YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_voice", "INT DEFAULT 1" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_voice_module", "INT DEFAULT 1" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_voice_module_locally", "INT DEFAULT 1" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_voice_3d", "INT DEFAULT 1" )

YRP_SQL_ADD_COLUMN(DATABASE_NAME, "int_voice_max_range", "INT DEFAULT 900" )

YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_gmod_voice_module", "INT DEFAULT 0" )




--[[ Gamemode Visuals ]]--
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_yrp_combined_menu", "INT DEFAULT 1" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_yrp_role_menu", "INT DEFAULT 1" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_yrp_help_menu", "INT DEFAULT 1" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_yrp_buy_menu", "INT DEFAULT 1" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_yrp_char_menu", "INT DEFAULT 1" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_yrp_keybinds_menu", "INT DEFAULT 1" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_yrp_tickets_menu", "INT DEFAULT 1" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_yrp_macro_menu", "INT DEFAULT 1" )

YRP_SQL_ADD_COLUMN(DATABASE_NAME, "text_loading_background", "TEXT DEFAULT ''" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "text_loading_design", "TEXT DEFAULT 'Default'" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "text_character_background", "TEXT DEFAULT ''" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "text_character_design", "TEXT DEFAULT 'Default'" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_yrp_chat", "INT DEFAULT 1" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_yrp_chat_show_name", "INT DEFAULT 1" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_yrp_chat_show_rolename", "INT DEFAULT 1" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_yrp_chat_show_factionname", "INT DEFAULT 1" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_yrp_chat_show_groupname", "INT DEFAULT 1" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_yrp_chat_show_usergroup", "INT DEFAULT 1" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "int_yrp_chat_range_local", "INT DEFAULT 400" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "text_idstructure", "TEXT DEFAULT '!D!D!D!D-!D!D!D!D-!D!D!D!D'" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "text_idcard_background", "TEXT DEFAULT ''" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_yrp_chat_show_idcardid", "INT DEFAULT 1" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_show_securitylevel", "INT DEFAULT 1" )

YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_yrp_play_button", "INT DEFAULT 1" )

YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_yrp_showowner", "INT DEFAULT 1" )

YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_yrp_crosshair", "INT DEFAULT 1" )

YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_yrp_hud", "INT DEFAULT 1" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_yrp_hud_swaying", "INT DEFAULT 0" )

YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_yrp_scoreboard", "INT DEFAULT 1" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "text_yrp_scoreboard_style", "TEXT DEFAULT 'simple'" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_yrp_scoreboard_show_name", "INT DEFAULT 1" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_yrp_scoreboard_show_rolename", "INT DEFAULT 1" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_yrp_scoreboard_show_factionname", "INT DEFAULT 1" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_yrp_scoreboard_show_groupname", "INT DEFAULT 1" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_yrp_scoreboard_show_level", "INT DEFAULT 1" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_yrp_scoreboard_show_usergroup", "INT DEFAULT 1" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_yrp_scoreboard_show_language", "INT DEFAULT 1" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_yrp_scoreboard_show_country", "INT DEFAULT 1" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_yrp_scoreboard_show_frags", "INT DEFAULT 0" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_yrp_scoreboard_show_deaths", "INT DEFAULT 0" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_yrp_scoreboard_show_playtime", "INT DEFAULT 1" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_yrp_scoreboard_show_operating_system", "INT DEFAULT 0" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_yrp_scoreboard_show_idcardid", "INT DEFAULT 1" )

YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_tag_on_head", "INT DEFAULT 0" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_tag_on_head_target", "INT DEFAULT 1" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_tag_on_head_clan", "INT DEFAULT 1" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_tag_on_head_idcardid", "INT DEFAULT 1" )

YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_tag_on_head_name", "INT DEFAULT 1" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_tag_on_head_name_onlyfaction", "INT DEFAULT 0" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_tag_on_head_name_onlygroup", "INT DEFAULT 0" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_tag_on_head_name_onlyrole", "INT DEFAULT 0" )

YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_tag_on_head_level", "INT DEFAULT 1" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_tag_on_head_rolename", "INT DEFAULT 1" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_tag_on_head_factionname", "INT DEFAULT 1" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_tag_on_head_groupname", "INT DEFAULT 1" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_tag_on_head_health", "INT DEFAULT 1" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_tag_on_head_armor", "INT DEFAULT 1" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_tag_on_head_usergroup", "INT DEFAULT 1" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_tag_on_head_target_forced", "INT DEFAULT 0" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_tag_on_head_voice", "INT DEFAULT 1" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_tag_on_head_chat", "INT DEFAULT 1" )

YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_tag_on_side", "INT DEFAULT 0" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_tag_on_side_target", "INT DEFAULT 1" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_tag_on_side_name", "INT DEFAULT 1" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_tag_on_side_idcardid", "INT DEFAULT 1" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_tag_on_side_clan", "INT DEFAULT 1" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_tag_on_side_level", "INT DEFAULT 1" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_tag_on_side_rolename", "INT DEFAULT 1" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_tag_on_side_factionname", "INT DEFAULT 1" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_tag_on_side_groupname", "INT DEFAULT 1" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_tag_on_side_health", "INT DEFAULT 1" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_tag_on_side_armor", "INT DEFAULT 1" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_tag_on_side_usergroup", "INT DEFAULT 1" )



--[[ Money Settings ]]--
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_drop_money_on_death", "INT DEFAULT 1" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "text_money_max_amount_of_dropped_money", "TEXT DEFAULT '1000'" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "text_money_pre", "TEXT DEFAULT '$'" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "text_money_pos", "TEXT DEFAULT ''" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "text_money_model", "TEXT DEFAULT 'models/props/cs_assault/money.mdl'" )

YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_money_printer_spawn_money", "INT DEFAULT 1" )



--[[ Characters Settings ]]--
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "text_characters_money_start", "TEXT DEFAULT '500'" )

YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_characters_changeable_name", "INT DEFAULT 1" )

YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_characters_removeondeath", "INT DEFAULT 0" )

YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_characters_birthday", "INT DEFAULT 1" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_characters_bodyheight", "INT DEFAULT 1" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_characters_weight", "INT DEFAULT 1" )

YRP_SQL_ADD_COLUMN(DATABASE_NAME, "int_logouttime", "INT DEFAULT 5" )

YRP_SQL_ADD_COLUMN(DATABASE_NAME, "int_deathtimestamp_min", "INT DEFAULT 6" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "int_deathtimestamp_max", "INT DEFAULT 30" )

YRP_SQL_ADD_COLUMN(DATABASE_NAME, "bool_deathscreen", "INT DEFAULT 1" )

--[[ Social Settings ]]--
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "text_social_website", "TEXT DEFAULT ''" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "text_social_forum", "TEXT DEFAULT ''" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "text_social_discord", "TEXT DEFAULT ''" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "text_social_discord_widgetid", "TEXT DEFAULT ''" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "text_social_teamspeak_ip", "TEXT DEFAULT ''" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "text_social_teamspeak_port", "TEXT DEFAULT '9987'" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "text_social_teamspeak_query_port", "TEXT DEFAULT '10011'" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "text_social_twitch", "TEXT DEFAULT ''" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "text_social_twitter", "TEXT DEFAULT ''" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "text_social_facebook", "TEXT DEFAULT ''" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "text_social_instagram", "TEXT DEFAULT ''" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "text_social_youtube", "TEXT DEFAULT ''" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "text_social_steamgroup", "TEXT DEFAULT ''" )

--[[ SCALE ]]--
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "float_scale_hunger", "TEXT DEFAULT '1.0'" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "float_scale_thirst", "TEXT DEFAULT '1.5'" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "float_scale_stamina_up", "TEXT DEFAULT '1.0'" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "float_scale_stamina_down", "TEXT DEFAULT '1.0'" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "float_scale_radiation_in", "TEXT DEFAULT '50.0'" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "float_scale_radiation_out", "TEXT DEFAULT '8.0'" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "float_scale_stamina_jump", "TEXT DEFAULT '30.0'" )

-- VOICE
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "int_max_channels_active", "INT DEFAULT 1" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "int_max_channels_passive", "INT DEFAULT 3" )

local HANDLER_GENERAL = {}

function RemFromHandler_General(ply)
	table.RemoveByValue(HANDLER_GENERAL, ply)
end

function AddToHandler_General(ply)
	if !table.HasValue(HANDLER_GENERAL, ply) then
		table.insert(HANDLER_GENERAL, ply)
	end
end

util.AddNetworkString( "Connect_Settings_General" )
net.Receive( "Connect_Settings_General", function(len, ply)
	if ply:CanAccess( "bool_general" ) then
		AddToHandler_General(ply)

		local _yrp_general = YRP_SQL_SELECT(DATABASE_NAME, "*", nil)
		if wk(_yrp_general) then
			_yrp_general = _yrp_general[1]
		else
			_yrp_general = {}
		end
		net.Start( "Connect_Settings_General" )
			net.WriteTable(_yrp_general)
		net.Send(ply)
	end
end)

util.AddNetworkString( "Disconnect_Settings_General" )
net.Receive( "Disconnect_Settings_General", function(len, ply)
	RemFromHandler_General(ply)
end)



local yrp_general = {}

if YRP_SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '1'" ) == nil then
	YRP_SQL_INSERT_INTO_DEFAULTVALUES(DATABASE_NAME)
end

local ld = YRP_SQL_SELECT( DATABASE_NAME, "*", "text_loading_design = 'Bottom'" )
if ld then
	YRP_SQL_UPDATE( DATABASE_NAME, {["text_loading_design"] = "Default"}, "text_loading_design = 'Bottom'" )
end

function YRPLoadGlobals()
	local _init_general = YRP_SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '1'" )
	if wk(_init_general) then
		yrp_general = _init_general[1]

		--RunConsoleCommand( "lua_log_sv", yrp_general.bool_server_debug)
		--RunConsoleCommand( "lua_log_cl", yrp_general.bool_server_debug)

		for name, value in pairs(yrp_general) do
			if string.StartWith(name, "bool_" ) then
				SetGlobalYRPBool(name, tobool( value ) )
			elseif name == "text_server_rules" then
				SetGlobalYRPTable(name, string.Explode( "\n", tostring( value) ))
			elseif string.StartWith(name, "int_" ) then
				SetGlobalYRPInt(name, tonumber( value) )
			elseif string.StartWith(name, "text_" ) then
				SetGlobalYRPString(name, tostring( value) )
			end
		end

		SetGlobalYRPBool( "yrp_general_loaded", true)
	end
end
timer.Simple( 0, YRPLoadGlobals )



--[[ GETTER ]]--
function YRPDebug()
	return GetGlobalYRPBool( "bool_server_debug", false)
end

function YRPErrorMod()
	return 10
end

function YRPIsAutomaticServerReloadingEnabled()
	return GetGlobalYRPBool( "bool_server_reload", false)
end

function YRPGetMoneyModel()
	local model = yrp_general.text_money_model
	if model == "" then
		model = "models/props/cs_assault/money.mdl"
	end
	return model
end

function YRPServerLogo()
	return yrp_general.text_server_logo
end


function YRPServerRules()
	return yrp_general.server_rules
end

function YRPRemoveBuildingOwner()
	local result = yrp_general.bool_removebuildingowner or false
	return tobool(result)
end

function YRPRemoveBuildingOwnerTime()
	local result = yrp_general.text_removebuildingownertime or 60 * 10
	return tonumber(result)
end



function IsDropItemsOnDeathEnabled()
	return GetGlobalYRPBool( "bool_drop_items_on_death", false)
end

function IsDealerImmortal()
	return !GetGlobalYRPBool( "bool_dealers_can_take_damage", false)
end

function IsRealisticEnabled()
	return GetGlobalYRPBool( "bool_realistic", false)
end

function PlayersCanDropWeapons()
	return GetGlobalYRPBool( "bool_players_can_drop_weapons", false)
end

function IsSuicideDisabled()
	return GetGlobalYRPBool( "bool_suicide_disabled", false)
end

function IsDropMoneyOnDeathEnabled()
	return GetGlobalYRPBool( "bool_drop_money_on_death", false)
end

util.AddNetworkString( "do_act" )
net.Receive( "do_act", function(len, ply)
	local act = net.ReadString()
	net.Start( "do_act" )
		net.WriteEntity(ply)
		net.WriteString( act)
	net.Broadcast()
end)

function IsVoiceEnabled()
	return GetGlobalYRPBool( "bool_voice", false)
end

function GetMaxVoiceRange()
	return tonumber(yrp_general.int_voice_max_range)
end

function GetMaxAmountOfDroppedMoney()
	return tonumber(yrp_general.text_money_max_amount_of_dropped_money)
end



function GetIDStructure()
	return GetGlobalYRPString( "text_idstructure", "!D!D!D!D-!D!D!D!D-!D!D!D!D" )
end



--[[ Setter ]]--
function SetYRPCollectionID( cid)
	cid = cid or 0
	cid = tonumber( cid)
	if cid > 0 then
		YRP.msg( "db", "SetYRPCollectionID( " .. cid .. " )" )
		yrp_general.text_server_collectionid = cid
		YRP_SQL_UPDATE(DATABASE_NAME, {["text_server_collectionid"] = cid}, "uniqueID = '1'" )

		--IsServerInfoOutdated()
	end
end

function GeneralDB()
	for i, set in pairs(yrp_general) do
		if string.StartWith(i, "text_" ) then
			SetGlobalYRPString(i, set)
		elseif string.StartWith(i, "bool_" ) then
			SetGlobalYRPBool(i, tobool(set) )
		elseif string.StartWith(i, "int_" ) then
			SetGlobalYRPInt(i, tonumber(set) )
		elseif string.StartWith(i, "float_" ) then
			SetGlobalYRPFloat(i, tonumber(set) )
		end
	end
end
GeneralDB()

--[[ UPDATES ]]--
function GeneralSendToOther(ply, netstr, str)
	for i, pl in pairs(HANDLER_GENERAL) do
		if ply != pl then
			net.Start(netstr)
				net.WriteString(str)
			net.Send(pl)
		end
	end
end

function GeneralUpdateValue(ply, netstr, str, value)
	yrp_general[str] = value
	YRP_SQL_UPDATE(DATABASE_NAME, {[str] = yrp_general[str]}, "uniqueID = '1'" ) -- str .. " = '" .. yrp_general[str] .. "'"
	GeneralSendToOther(ply, netstr, yrp_general[str])
end

function GeneralUpdateBool(ply, netstr, str, value)
	YRP.msg( "db", ply:YRPName() .. " updated " .. str .. " to: " .. tostring(tobool( value) ))
	GeneralUpdateValue(ply, netstr, str, value)
	SetGlobalYRPBool(str, tobool( value) )
end

function GeneralUpdateString(ply, netstr, str, value)
	YRP.msg( "db", ply:YRPName() .. " updated " .. str .. " to: " .. tostring( value) )
	GeneralUpdateValue(ply, netstr, str, value)
	SetGlobalYRPString(str, value)
end

function GeneralUpdateTable(ply, netstr, str, value)
	YRP.msg( "db", ply:YRPName() .. " updated " .. str .. " to: " .. tostring( value) )
	GeneralUpdateValue(ply, netstr, str, value)
	SetGlobalYRPTable(str, string.Explode( "\n", value) )
end

function GeneralUpdateInt(ply, netstr, str, value)
	YRP.msg( "db", ply:YRPName() .. " updated " .. str .. " to: " .. tostring( value) )
	GeneralUpdateValue(ply, netstr, str, value)
	SetGlobalYRPInt(str, value)
end

function GeneralUpdateFloat(ply, netstr, str, value)
	YRP.msg( "db", ply:YRPName() .. " updated " .. str .. " to: " .. tostring( value) )
	GeneralUpdateValue(ply, netstr, str, value)
	SetGlobalYRPFloat(str, value)
end

function GeneralUpdateGlobalValue(ply, netstr, str, value)
	yrp_general[str] = value
	YRP_SQL_UPDATE(DATABASE_NAME, {[str] = yrp_general[str]}, "uniqueID = '1'" )
	GeneralSendToOther(ply, netstr, yrp_general[str])
end

function GeneralUpdateGlobalBool(ply, netstr, str, value)
	YRP.msg( "db", ply:YRPName() .. " updated global " .. str .. " to: " .. tostring(tobool( value) ))
	GeneralUpdateGlobalValue(ply, netstr, str, value)
	SetGlobalYRPBool(str, tobool( value) )
end



--[[ SERVER SETTINGS ]]--
util.AddNetworkString( "update_bool_server_reload_notification" )
net.Receive( "update_bool_server_reload_notification", function(len, ply)
	local b = btn(net.ReadBool() )
	GeneralUpdateBool(ply, "update_bool_server_reload_notification", "bool_server_reload_notification", b)
end)

util.AddNetworkString( "update_bool_server_reload" )
net.Receive( "update_bool_server_reload", function(len, ply)
	local b = btn(net.ReadBool() )
	GeneralUpdateBool(ply, "update_bool_server_reload", "bool_server_reload", b)
end)

util.AddNetworkString( "update_text_server_collectionid" )
net.Receive( "update_text_server_collectionid", function(len, ply)
	local str = net.ReadString()
	GeneralUpdateString(ply, "update_text_server_collectionid", "text_server_collectionid", str)
end)


util.AddNetworkString( "update_text_server_logo" )
net.Receive( "update_text_server_logo", function(len, ply)
	local str = net.ReadString()
	GeneralUpdateString(ply, "update_text_server_logo", "text_server_logo", str)
end)

util.AddNetworkString( "update_text_server_name" )
net.Receive( "update_text_server_name", function(len, ply)
	local str = net.ReadString()
	GeneralUpdateString(ply, "update_text_server_name", "text_server_name", str)
end)



util.AddNetworkString( "update_text_server_rules" )
net.Receive( "update_text_server_rules", function(len, ply)
	local str = net.ReadString()
	GeneralUpdateTable(ply, "update_text_server_rules", "text_server_rules", str)
end)

util.AddNetworkString( "update_text_server_welcome_message" )
net.Receive( "update_text_server_welcome_message", function(len, ply)
	local str = net.ReadString()
	GeneralUpdateString(ply, "update_text_server_welcome_message", "text_server_welcome_message", str)
end)


util.AddNetworkString( "update_text_server_message_of_the_day" )
net.Receive( "update_text_server_message_of_the_day", function(len, ply)
	local str = net.ReadString()
	GeneralUpdateString(ply, "update_text_server_message_of_the_day", "text_server_message_of_the_day", str)
end)

util.AddNetworkString( "update_bool_server_debug" )
net.Receive( "update_bool_server_debug", function(len, ply)
	local b = btn(net.ReadBool() )
	GeneralUpdateBool(ply, "update_bool_server_debug", "bool_server_debug", b)
	RunConsoleCommand( "lua_log_sv", b)
	RunConsoleCommand( "lua_log_cl", b)
end)

util.AddNetworkString( "update_bool_server_debug_voice" )
net.Receive( "update_bool_server_debug_voice", function(len, ply)
	local b = btn(net.ReadBool() )
	GeneralUpdateBool(ply, "update_bool_server_debug_voice", "bool_server_debug_voice", b)
end)

util.AddNetworkString( "update_int_server_debug_tick" )
net.Receive( "update_int_server_debug_tick", function(len, ply)
	local int = net.ReadString()
	if isnumber(tonumber(int) ) then
		GeneralUpdateInt(ply, "update_int_server_debug_tick", "int_server_debug_tick", int)
	end
end)

util.AddNetworkString( "update_bool_msg_channel_gm" )
net.Receive( "update_bool_msg_channel_gm", function(len, ply)
	local b = btn(net.ReadBool() )
	GeneralUpdateGlobalBool(ply, "update_bool_msg_channel_gm", "bool_msg_channel_gm", b)
end)

util.AddNetworkString( "update_bool_msg_channel_db" )
net.Receive( "update_bool_msg_channel_db", function(len, ply)
	local b = btn(net.ReadBool() )
	GeneralUpdateGlobalBool(ply, "update_bool_msg_channel_db", "bool_msg_channel_db", b)
end)

util.AddNetworkString( "update_bool_msg_channel_lang" )
net.Receive( "update_bool_msg_channel_lang", function(len, ply)
	local b = btn(net.ReadBool() )
	GeneralUpdateGlobalBool(ply, "update_bool_msg_channel_lang", "bool_msg_channel_lang", b)
end)

util.AddNetworkString( "update_bool_msg_channel_noti" )
net.Receive( "update_bool_msg_channel_noti", function(len, ply)
	local b = btn(net.ReadBool() )
	GeneralUpdateGlobalBool(ply, "update_bool_msg_channel_noti", "bool_msg_channel_noti", b)
end)

util.AddNetworkString( "update_bool_msg_channel_darkrp" )
net.Receive( "update_bool_msg_channel_darkrp", function(len, ply)
	local b = btn(net.ReadBool() )
	GeneralUpdateGlobalBool(ply, "update_bool_msg_channel_darkrp", "bool_msg_channel_darkrp", b)
end)

util.AddNetworkString( "update_bool_msg_channel_chat" )
net.Receive( "update_bool_msg_channel_chat", function(len, ply)
	local b = btn(net.ReadBool() )
	GeneralUpdateGlobalBool(ply, "update_bool_msg_channel_chat", "bool_msg_channel_chat", b)
end)

util.AddNetworkString( "update_bool_msg_channel_debug" )
net.Receive( "update_bool_msg_channel_debug", function(len, ply)
	local b = btn(net.ReadBool() )
	GeneralUpdateGlobalBool(ply, "update_bool_msg_channel_debug", "bool_msg_channel_debug", b)
end)



--[[ GAMEMODE SETTINGS ]]--
util.AddNetworkString( "update_text_gamemode_name" )
net.Receive( "update_text_gamemode_name", function(len, ply)
	local str = net.ReadString()
	GeneralUpdateString(ply, "update_text_gamemode_name", "text_gamemode_name", str)
	GAMEMODE.BaseName = str
end)

util.AddNetworkString( "update_bool_graffiti_disabled" )
net.Receive( "update_bool_graffiti_disabled", function(len, ply)
	local b = btn(net.ReadBool() )
	GeneralUpdateBool(ply, "update_bool_graffiti_disabled", "bool_graffiti_disabled", b)
end)

util.AddNetworkString( "update_bool_suicide_disabled" )
net.Receive( "update_bool_suicide_disabled", function(len, ply)
	local b = btn(net.ReadBool() )
	GeneralUpdateBool(ply, "update_bool_suicide_disabled", "bool_suicide_disabled", b)
end)

util.AddNetworkString( "update_bool_team_color" )
net.Receive( "update_bool_team_color", function(len, ply)
	local b = btn(net.ReadBool() )
	GeneralUpdateBool(ply, "update_bool_team_color", "bool_team_color", b)
end)



util.AddNetworkString( "update_bool_antipropkill" )
net.Receive( "update_bool_antipropkill", function(len, ply)
	local b = btn(net.ReadBool() )
	GeneralUpdateBool(ply, "update_bool_antipropkill", "bool_antipropkill", b)
end)

util.AddNetworkString( "update_bool_drop_items_on_death" )
net.Receive( "update_bool_drop_items_on_death", function(len, ply)
	local b = btn(net.ReadBool() )
	GeneralUpdateBool(ply, "update_bool_drop_items_on_death", "bool_drop_items_on_death", b)
end)

util.AddNetworkString( "update_bool_drop_items_role" )
net.Receive( "update_bool_drop_items_role", function(len, ply)
	local b = btn(net.ReadBool() )
	GeneralUpdateBool(ply, "update_bool_drop_items_role", "bool_drop_items_role", b)
end)

util.AddNetworkString( "update_bool_players_need_to_introduce" )
net.Receive( "update_bool_players_need_to_introduce", function(len, ply)
	local b = btn(net.ReadBool() )
	GeneralUpdateBool(ply, "update_bool_players_need_to_introduce", "bool_players_need_to_introduce", b)
end)

util.AddNetworkString( "update_bool_players_can_drop_weapons" )
net.Receive( "update_bool_players_can_drop_weapons", function(len, ply)
	local b = btn(net.ReadBool() )
	GeneralUpdateBool(ply, "update_bool_players_can_drop_weapons", "bool_players_can_drop_weapons", b)
end)
util.AddNetworkString( "update_bool_players_start_with_default_role" )
net.Receive( "update_bool_players_start_with_default_role", function(len, ply)
	local b = btn(net.ReadBool() )
	GeneralUpdateBool(ply, "update_bool_players_start_with_default_role", "bool_players_start_with_default_role", b)
end)

util.AddNetworkString( "update_bool_dealers_can_take_damage" )
net.Receive( "update_bool_dealers_can_take_damage", function(len, ply)
	local b = btn(net.ReadBool() )
	GeneralUpdateBool(ply, "update_bool_dealers_can_take_damage", "bool_dealers_can_take_damage", b)
end)



util.AddNetworkString( "update_bool_thirdperson" )
net.Receive( "update_bool_thirdperson", function(len, ply)
	local b = btn(net.ReadBool() )
	GeneralUpdateBool(ply, "update_bool_thirdperson", "bool_thirdperson", b)
end)

util.AddNetworkString( "update_text_view_distance" )
net.Receive( "update_text_view_distance", function(len, ply)
	local str = net.ReadString()
	GeneralUpdateString(ply, "update_text_view_distance", "text_view_distance", str)
end)


util.AddNetworkString( "update_bool_chat_ooc" )
net.Receive( "update_bool_chat_ooc", function(len, ply)
	local b = btn(net.ReadBool() )
	GeneralUpdateBool(ply, "update_bool_chat_ooc", "bool_chat_ooc", b)
end)

util.AddNetworkString( "update_bool_chat_looc" )
net.Receive( "update_bool_chat_looc", function(len, ply)
	local b = btn(net.ReadBool() )
	GeneralUpdateBool(ply, "update_bool_chat_looc", "bool_chat_looc", b)
end)

util.AddNetworkString( "update_bool_chat_role" )
net.Receive( "update_bool_chat_role", function(len, ply)
	local b = btn(net.ReadBool() )
	GeneralUpdateBool(ply, "update_bool_chat_role", "bool_chat_role", b)
end)

util.AddNetworkString( "update_bool_chat_group" )
net.Receive( "update_bool_chat_group", function(len, ply)
	local b = btn(net.ReadBool() )
	GeneralUpdateBool(ply, "update_bool_chat_group", "bool_chat_group", b)
end)

util.AddNetworkString( "update_bool_chat_yell" )
net.Receive( "update_bool_chat_yell", function(len, ply)
	local b = btn(net.ReadBool() )
	GeneralUpdateBool(ply, "update_bool_chat_yell", "bool_chat_yell", b)
end)

util.AddNetworkString( "update_bool_chat_service" )
net.Receive( "update_bool_chat_service", function(len, ply)
	local b = btn(net.ReadBool() )
	GeneralUpdateBool(ply, "update_bool_chat_service", "bool_chat_service", b)
end)

util.AddNetworkString( "update_bool_canbeowned" )
net.Receive( "update_bool_canbeowned", function(len, ply)
	local b = btn(net.ReadBool() )
	GeneralUpdateBool(ply, "update_bool_canbeowned", "bool_canbeowned", b)
end)

util.AddNetworkString( "update_bool_removebuildingowner" )
net.Receive( "update_bool_removebuildingowner", function(len, ply)
	local b = btn(net.ReadBool() )
	GeneralUpdateBool(ply, "update_bool_removebuildingowner", "bool_removebuildingowner", b)
end)

util.AddNetworkString( "update_bool_removebuildingownercharswitch" )
net.Receive( "update_bool_removebuildingownercharswitch", function(len, ply)
	local b = btn(net.ReadBool() )
	GeneralUpdateBool(ply, "update_bool_removebuildingownercharswitch", "bool_removebuildingownercharswitch", b)
end)

util.AddNetworkString( "update_text_removebuildingownertime" )
net.Receive( "update_text_removebuildingownertime", function(len, ply)
	local str = net.ReadString()
	GeneralUpdateString(ply, "update_text_removebuildingownertime", "text_removebuildingownertime", str)
end)

util.AddNetworkString( "update_bool_autopickup" )
net.Receive( "update_bool_autopickup", function(len, ply)
	local b = btn(net.ReadBool() )
	GeneralUpdateBool(ply, "update_bool_autopickup", "bool_autopickup", b)
end)

util.AddNetworkString( "update_int_ttlsweps" )
net.Receive( "update_int_ttlsweps", function(len, ply)
	local int = net.ReadString()
	if isnumber(tonumber(int) ) then
		GeneralUpdateInt(ply, "update_int_ttlsweps", "int_ttlsweps", int)
	end
end)

util.AddNetworkString( "update_int_afkkicktime" )
net.Receive( "update_int_afkkicktime", function(len, ply)
	local int = net.ReadString()
	if isnumber(tonumber(int) ) then
		GeneralUpdateInt(ply, "update_int_afkkicktime", "int_afkkicktime", int)
	end
end)



--[[ GAMEMODE SYSTEMS ]]--
util.AddNetworkString( "update_bool_onlywhencook" )
net.Receive( "update_bool_onlywhencook", function(len, ply)
	local b = btn(net.ReadBool() )
	GeneralUpdateBool(ply, "update_bool_onlywhencook", "bool_onlywhencook", b)
end)

util.AddNetworkString( "update_bool_hunger" )
net.Receive( "update_bool_hunger", function(len, ply)
	local b = btn(net.ReadBool() )
	GeneralUpdateBool(ply, "update_bool_hunger", "bool_hunger", b)
end)

util.AddNetworkString( "update_bool_hunger_health_regeneration" )
net.Receive( "update_bool_hunger_health_regeneration", function(len, ply)
	local b = btn(net.ReadBool() )
	GeneralUpdateBool(ply, "update_bool_hunger_health_regeneration", "bool_hunger_health_regeneration", b)
end)

util.AddNetworkString( "update_text_hunger_health_regeneration_tickrate" )
net.Receive( "update_text_hunger_health_regeneration_tickrate", function(len, ply)
	local str = net.ReadString()
	GeneralUpdateString(ply, "update_text_hunger_health_regeneration_tickrate", "text_hunger_health_regeneration_tickrate", str)
end)

util.AddNetworkString( "update_bool_thirst" )
net.Receive( "update_bool_thirst", function(len, ply)
	local b = btn(net.ReadBool() )
	GeneralUpdateBool(ply, "update_bool_thirst", "bool_thirst", b)
end)

util.AddNetworkString( "update_bool_permille" )
net.Receive( "update_bool_permille", function(len, ply)
	local b = btn(net.ReadBool() )
	GeneralUpdateBool(ply, "update_bool_permille", "bool_permille", b)
end)

util.AddNetworkString( "update_bool_stamina" )
net.Receive( "update_bool_stamina", function(len, ply)
	local b = btn(net.ReadBool() )
	GeneralUpdateBool(ply, "update_bool_stamina", "bool_stamina", b)
end)

util.AddNetworkString( "update_bool_radiation" )
net.Receive( "update_bool_radiation", function(len, ply)
	local b = btn(net.ReadBool() )
	GeneralUpdateBool(ply, "update_bool_radiation", "bool_radiation", b)
end)

util.AddNetworkString( "update_bool_map_system" )
net.Receive( "update_bool_map_system", function(len, ply)
	local b = btn(net.ReadBool() )
	GeneralUpdateBool(ply, "update_bool_map_system", "bool_map_system", b)
end)

util.AddNetworkString( "update_bool_character_system" )
net.Receive( "update_bool_character_system", function(len, ply)
	local b = btn(net.ReadBool() )
	GeneralUpdateBool(ply, "update_bool_character_system", "bool_character_system", b)
end)

util.AddNetworkString( "update_bool_building_system" )
net.Receive( "update_bool_building_system", function(len, ply)
	local b = btn(net.ReadBool() )
	GeneralUpdateBool(ply, "update_bool_building_system", "bool_building_system", b)
end)

util.AddNetworkString( "update_bool_inventory_system" )
net.Receive( "update_bool_inventory_system", function(len, ply)
	local b = btn(net.ReadBool() )
	GeneralUpdateBool(ply, "update_bool_inventory_system", "bool_inventory_system", b)
end)

util.AddNetworkString( "update_bool_realistic_system" )
net.Receive( "update_bool_realistic_system", function(len, ply)
	local b = btn(net.ReadBool() )
	GeneralUpdateBool(ply, "update_bool_realistic_system", "bool_realistic_system", b)
end)

util.AddNetworkString( "update_bool_level_system" )
net.Receive( "update_bool_level_system", function(len, ply)
	local b = btn(net.ReadBool() )
	GeneralUpdateBool(ply, "update_bool_level_system", "bool_level_system", b)
end)

util.AddNetworkString( "update_bool_weapon_system" )
net.Receive( "update_bool_weapon_system", function(len, ply)
	local b = btn(net.ReadBool() )
	GeneralUpdateBool(ply, "update_bool_weapon_system", "bool_weapon_system", b)
end)

util.AddNetworkString( "update_text_weapon_system_model" )
net.Receive( "update_text_weapon_system_model", function(len, ply)
	local str = net.ReadString()
	GeneralUpdateString(ply, "update_text_weapon_system_model", "text_weapon_system_model", str)
end)



util.AddNetworkString( "update_bool_identity_card" )
net.Receive( "update_bool_identity_card", function(len, ply)
	local b = btn(net.ReadBool() )
	GeneralUpdateBool(ply, "update_bool_identity_card", "bool_identity_card", b)
end)

util.AddNetworkString( "update_bool_laws_system" )
net.Receive( "update_bool_laws_system", function(len, ply)
	local b = btn(net.ReadBool() )
	GeneralUpdateBool(ply, "update_bool_laws_system", "bool_laws_system", b)
end)

util.AddNetworkString( "update_bool_appearance_system" )
net.Receive( "update_bool_appearance_system", function(len, ply)
	local b = btn(net.ReadBool() )
	GeneralUpdateBool(ply, "update_bool_appearance_system", "bool_appearance_system", b)
end)

util.AddNetworkString( "update_text_appearance_model" )
net.Receive( "update_text_appearance_model", function(len, ply)
	local str = net.ReadString()
	GeneralUpdateString(ply, "update_text_appearance_model", "text_appearance_model", str)
end)

util.AddNetworkString( "update_bool_smartphone_system" )
net.Receive( "update_bool_smartphone_system", function(len, ply)
	local b = btn(net.ReadBool() )
	GeneralUpdateBool(ply, "update_bool_smartphone_system", "bool_smartphone_system", b)
end)



util.AddNetworkString( "update_bool_players_can_switch_faction" )
net.Receive( "update_bool_players_can_switch_faction", function(len, ply)
	local b = btn(net.ReadBool() )
	GeneralUpdateBool(ply, "update_bool_players_can_switch_faction", "bool_players_can_switch_faction", b)
end)

util.AddNetworkString( "update_bool_players_can_switch_role" )
net.Receive( "update_bool_players_can_switch_role", function(len, ply)
	local b = btn(net.ReadBool() )
	GeneralUpdateBool(ply, "update_bool_players_can_switch_role", "bool_players_can_switch_role", b)
end)

util.AddNetworkString( "update_bool_players_die_on_role_switch" )
net.Receive( "update_bool_players_die_on_role_switch", function(len, ply)
	local b = btn(net.ReadBool() )
	GeneralUpdateBool(ply, "update_bool_players_die_on_role_switch", "bool_players_die_on_role_switch", b)
end)



util.AddNetworkString( "update_bool_wanted_system" )
net.Receive( "update_bool_wanted_system", function(len, ply)
	local b = btn(net.ReadBool() )
	GeneralUpdateBool(ply, "update_bool_wanted_system", "bool_wanted_system", b)
end)



util.AddNetworkString( "update_bool_voice" )
net.Receive( "update_bool_voice", function(len, ply)
	local b = btn(net.ReadBool() )
	GeneralUpdateBool(ply, "update_bool_voice", "bool_voice", b)
end)

util.AddNetworkString( "update_bool_voice_module" )
net.Receive( "update_bool_voice_module", function(len, ply)
	local b = btn(net.ReadBool() )
	GeneralUpdateBool(ply, "update_bool_voice_module", "bool_voice_module", b)
end)

util.AddNetworkString( "update_bool_voice_module_locally" )
net.Receive( "update_bool_voice_module_locally", function(len, ply)
	local b = btn(net.ReadBool() )
	GeneralUpdateBool(ply, "update_bool_voice_module_locally", "bool_voice_module_locally", b)
end)

util.AddNetworkString( "update_bool_voice_3d" )
net.Receive( "update_bool_voice_3d", function(len, ply)
	local b = btn(net.ReadBool() )
	GeneralUpdateBool(ply, "update_bool_voice_3d", "bool_voice_3d", b)
end)

util.AddNetworkString( "update_int_voice_max_range" )
net.Receive( "update_int_voice_max_range", function(len, ply)
	local int = net.ReadString()
	if isnumber(tonumber(int) ) then
		GeneralUpdateInt(ply, "update_int_voice_max_range", "int_voice_max_range", int)
	end
end)


util.AddNetworkString( "update_bool_gmod_voice_module" )
net.Receive( "update_bool_gmod_voice_module", function(len, ply)
	local b = btn(net.ReadBool() )
	GeneralUpdateBool(ply, "update_bool_gmod_voice_module", "bool_gmod_voice_module", b)
end)



--[[ GAMEMODE VISUALS ]]--
util.AddNetworkString( "update_bool_yrp_combined_menu" )
net.Receive( "update_bool_yrp_combined_menu", function(len, ply)
	local b = btn(net.ReadBool() )
	GeneralUpdateBool(ply, "update_bool_yrp_combined_menu", "bool_yrp_combined_menu", b)
end)

util.AddNetworkString( "update_bool_yrp_role_menu" )
net.Receive( "update_bool_yrp_role_menu", function(len, ply)
	local b = btn(net.ReadBool() )
	GeneralUpdateBool(ply, "update_bool_yrp_role_menu", "bool_yrp_role_menu", b)
end)

util.AddNetworkString( "update_bool_yrp_help_menu" )
net.Receive( "update_bool_yrp_help_menu", function(len, ply)
	local b = btn(net.ReadBool() )
	GeneralUpdateBool(ply, "update_bool_yrp_help_menu", "bool_yrp_help_menu", b)
end)

util.AddNetworkString( "update_bool_yrp_buy_menu" )
net.Receive( "update_bool_yrp_buy_menu", function(len, ply)
	local b = btn(net.ReadBool() )
	GeneralUpdateBool(ply, "update_bool_yrp_buy_menu", "bool_yrp_buy_menu", b)
end)

util.AddNetworkString( "update_bool_yrp_char_menu" )
net.Receive( "update_bool_yrp_char_menu", function(len, ply)
	local b = btn(net.ReadBool() )
	GeneralUpdateBool(ply, "update_bool_yrp_char_menu", "bool_yrp_char_menu", b)
end)

util.AddNetworkString( "update_bool_yrp_keybinds_menu" )
net.Receive( "update_bool_yrp_keybinds_menu", function(len, ply)
	local b = btn(net.ReadBool() )
	GeneralUpdateBool(ply, "update_bool_yrp_keybinds_menu", "bool_yrp_keybinds_menu", b)
end)

util.AddNetworkString( "update_bool_yrp_tickets_menu" )
net.Receive( "update_bool_yrp_tickets_menu", function(len, ply)
	local b = btn(net.ReadBool() )
	GeneralUpdateBool(ply, "update_bool_yrp_tickets_menu", "bool_yrp_tickets_menu", b)
end)

util.AddNetworkString( "update_bool_yrp_macro_menu" )
net.Receive( "update_bool_yrp_macro_menu", function(len, ply)
	local b = btn(net.ReadBool() )
	GeneralUpdateBool(ply, "update_bool_yrp_macro_menu", "bool_yrp_macro_menu", b)
end)

util.AddNetworkString( "update_text_character_background" )
net.Receive( "update_text_character_background", function(len, ply)
	local str = net.ReadString()
	str = string.Replace(str, " ", "" )
	GeneralUpdateString(ply, "update_text_character_background", "text_character_background", str)
end)

util.AddNetworkString( "update_text_loading_design" )
net.Receive( "update_text_loading_design", function(len, ply)
	local str = net.ReadString()
	str = string.Replace(str, " ", "" )
	GeneralUpdateString(ply, "update_text_loading_design", "text_loading_design", str)
end)

util.AddNetworkString( "update_text_loading_background" )
net.Receive( "update_text_loading_background", function(len, ply)
	local str = net.ReadString()
	str = string.Replace(str, " ", "" )
	GeneralUpdateString(ply, "update_text_loading_background", "text_loading_background", str)
end)

util.AddNetworkString( "update_text_character_design" )
net.Receive( "update_text_character_design", function(len, ply)
	local str = net.ReadString()
	str = string.Replace(str, " ", "" )
	GeneralUpdateString(ply, "update_text_character_design", "text_character_design", str)
end)

util.AddNetworkString( "update_bool_yrp_chat" )
net.Receive( "update_bool_yrp_chat", function(len, ply)
	local b = btn(net.ReadBool() )
	GeneralUpdateBool(ply, "update_bool_yrp_chat", "bool_yrp_chat", b)
end)

util.AddNetworkString( "update_bool_yrp_chat_show_name" )
net.Receive( "update_bool_yrp_chat_show_name", function(len, ply)
	local b = btn(net.ReadBool() )
	GeneralUpdateBool(ply, "update_bool_yrp_chat_show_name", "bool_yrp_chat_show_name", b)
end)

util.AddNetworkString( "update_bool_yrp_chat_show_rolename" )
net.Receive( "update_bool_yrp_chat_show_rolename", function(len, ply)
	local b = btn(net.ReadBool() )
	GeneralUpdateBool(ply, "update_bool_yrp_chat_show_rolename", "bool_yrp_chat_show_rolename", b)
end)

util.AddNetworkString( "update_bool_yrp_chat_show_factionname" )
net.Receive( "update_bool_yrp_chat_show_factionname", function(len, ply)
	local b = btn(net.ReadBool() )
	GeneralUpdateBool(ply, "update_bool_yrp_chat_show_factionname", "bool_yrp_chat_show_factionname", b)
end)

util.AddNetworkString( "update_bool_yrp_chat_show_groupname" )
net.Receive( "update_bool_yrp_chat_show_groupname", function(len, ply)
	local b = btn(net.ReadBool() )
	GeneralUpdateBool(ply, "update_bool_yrp_chat_show_groupname", "bool_yrp_chat_show_groupname", b)
end)

util.AddNetworkString( "update_bool_yrp_chat_show_usergroup" )
net.Receive( "update_bool_yrp_chat_show_usergroup", function(len, ply)
	local b = btn(net.ReadBool() )
	GeneralUpdateBool(ply, "update_bool_yrp_chat_show_usergroup", "bool_yrp_chat_show_usergroup", b)
end)

util.AddNetworkString( "update_text_idcard_background" )
net.Receive( "update_text_idcard_background", function(len, ply)
	local str = net.ReadString()
	GeneralUpdateString(ply, "update_text_idcard_background", "text_idcard_background", str)
end)

util.AddNetworkString( "update_text_idstructure" )
net.Receive( "update_text_idstructure", function(len, ply)
	local str = net.ReadString()
	GeneralUpdateString(ply, "update_text_idstructure", "text_idstructure", str)
	RecreateNewIDCardID()
end)

util.AddNetworkString( "update_bool_yrp_chat_show_idcardid" )
net.Receive( "update_bool_yrp_chat_show_idcardid", function(len, ply)
	local b = btn(net.ReadBool() )
	GeneralUpdateBool(ply, "update_bool_yrp_chat_show_idcardid", "bool_yrp_chat_show_idcardid", b)
end)

util.AddNetworkString( "update_bool_show_securitylevel" )
net.Receive( "update_bool_show_securitylevel", function(len, ply)
	local b = btn(net.ReadBool() )
	GeneralUpdateBool(ply, "update_bool_show_securitylevel", "bool_show_securitylevel", b)
end)

util.AddNetworkString( "update_int_yrp_chat_range_local" )
net.Receive( "update_int_yrp_chat_range_local", function(len, ply)
	local int = net.ReadString()
	if isnumber(tonumber(int) ) then
		GeneralUpdateInt(ply, "update_int_yrp_chat_range_local", "int_yrp_chat_range_local", int)
	end
end)



util.AddNetworkString( "update_bool_yrp_showowner" )
net.Receive( "update_bool_yrp_showowner", function(len, ply)
	local b = btn(net.ReadBool() )
	GeneralUpdateBool(ply, "update_bool_yrp_showowner", "bool_yrp_showowner", b)
end)



util.AddNetworkString( "update_bool_yrp_crosshair" )
net.Receive( "update_bool_yrp_crosshair", function(len, ply)
	local b = btn(net.ReadBool() )
	GeneralUpdateBool(ply, "update_bool_yrp_crosshair", "bool_yrp_crosshair", b)
end)



util.AddNetworkString( "update_bool_yrp_play_button" )
net.Receive( "update_bool_yrp_play_button", function(len, ply)
	local b = btn(net.ReadBool() )
	GeneralUpdateBool(ply, "update_bool_yrp_play_button", "bool_yrp_play_button", b)
end)



util.AddNetworkString( "update_bool_yrp_hud" )
net.Receive( "update_bool_yrp_hud", function(len, ply)
	local b = btn(net.ReadBool() )
	GeneralUpdateBool(ply, "update_bool_yrp_hud", "bool_yrp_hud", b)
end)

util.AddNetworkString( "update_bool_yrp_hud_swaying" )
net.Receive( "update_bool_yrp_hud_swaying", function(len, ply)
	local b = btn(net.ReadBool() )
	GeneralUpdateBool(ply, "update_bool_yrp_hud_swaying", "bool_yrp_hud_swaying", b)
end)



util.AddNetworkString( "update_bool_yrp_scoreboard" )
net.Receive( "update_bool_yrp_scoreboard", function(len, ply)
	local b = btn(net.ReadBool() )
	GeneralUpdateBool(ply, "update_bool_yrp_scoreboard", "bool_yrp_scoreboard", b)
end)

util.AddNetworkString( "update_text_yrp_scoreboard_style" )
net.Receive( "update_text_yrp_scoreboard_style", function(len, ply)
	local str = net.ReadString()
	GeneralUpdateString(ply, "update_text_yrp_scoreboard_style", "text_yrp_scoreboard_style", str)
end)

util.AddNetworkString( "update_bool_yrp_scoreboard_show_level" )
net.Receive( "update_bool_yrp_scoreboard_show_level", function(len, ply)
	local b = btn(net.ReadBool() )
	GeneralUpdateBool(ply, "update_bool_yrp_scoreboard_show_level", "bool_yrp_scoreboard_show_level", b)
end)

util.AddNetworkString( "update_bool_yrp_scoreboard_show_name" )
net.Receive( "update_bool_yrp_scoreboard_show_name", function(len, ply)
	local b = btn(net.ReadBool() )
	GeneralUpdateBool(ply, "update_bool_yrp_scoreboard_show_name", "bool_yrp_scoreboard_show_name", b)
end)

util.AddNetworkString( "update_bool_yrp_scoreboard_show_usergroup" )
net.Receive( "update_bool_yrp_scoreboard_show_usergroup", function(len, ply)
	local b = btn(net.ReadBool() )
	GeneralUpdateBool(ply, "update_bool_yrp_scoreboard_show_usergroup", "bool_yrp_scoreboard_show_usergroup", b)
end)

util.AddNetworkString( "update_bool_yrp_scoreboard_show_rolename" )
net.Receive( "update_bool_yrp_scoreboard_show_rolename", function(len, ply)
	local b = btn(net.ReadBool() )
	GeneralUpdateBool(ply, "update_bool_yrp_scoreboard_show_rolename", "bool_yrp_scoreboard_show_rolename", b)
end)

util.AddNetworkString( "update_bool_yrp_scoreboard_show_factionname" )
net.Receive( "update_bool_yrp_scoreboard_show_factionname", function(len, ply)
	local b = btn(net.ReadBool() )
	GeneralUpdateBool(ply, "update_bool_yrp_scoreboard_show_factionname", "bool_yrp_scoreboard_show_factionname", b)
end)

util.AddNetworkString( "update_bool_yrp_scoreboard_show_groupname" )
net.Receive( "update_bool_yrp_scoreboard_show_groupname", function(len, ply)
	local b = btn(net.ReadBool() )
	GeneralUpdateBool(ply, "update_bool_yrp_scoreboard_show_groupname", "bool_yrp_scoreboard_show_groupname", b)
end)

util.AddNetworkString( "update_bool_yrp_scoreboard_show_language" )
net.Receive( "update_bool_yrp_scoreboard_show_language", function(len, ply)
	local b = btn(net.ReadBool() )
	GeneralUpdateBool(ply, "update_bool_yrp_scoreboard_show_language", "bool_yrp_scoreboard_show_language", b)
end)

util.AddNetworkString( "update_bool_yrp_scoreboard_show_country" )
net.Receive( "update_bool_yrp_scoreboard_show_country", function(len, ply)
	local b = btn(net.ReadBool() )
	GeneralUpdateBool(ply, "update_bool_yrp_scoreboard_show_country", "bool_yrp_scoreboard_show_country", b)
end)

util.AddNetworkString( "update_bool_yrp_scoreboard_show_playtime" )
net.Receive( "update_bool_yrp_scoreboard_show_playtime", function(len, ply)
	local b = btn(net.ReadBool() )
	GeneralUpdateBool(ply, "update_bool_yrp_scoreboard_show_playtime", "bool_yrp_scoreboard_show_playtime", b)
end)

util.AddNetworkString( "update_bool_yrp_scoreboard_show_frags" )
net.Receive( "update_bool_yrp_scoreboard_show_frags", function(len, ply)
	local b = btn(net.ReadBool() )
	GeneralUpdateBool(ply, "update_bool_yrp_scoreboard_show_frags", "bool_yrp_scoreboard_show_frags", b)
end)

util.AddNetworkString( "update_bool_yrp_scoreboard_show_deaths" )
net.Receive( "update_bool_yrp_scoreboard_show_deaths", function(len, ply)
	local b = btn(net.ReadBool() )
	GeneralUpdateBool(ply, "update_bool_yrp_scoreboard_show_deaths", "bool_yrp_scoreboard_show_deaths", b)
end)

util.AddNetworkString( "update_bool_yrp_scoreboard_show_operating_system" )
net.Receive( "update_bool_yrp_scoreboard_show_operating_system", function(len, ply)
	local b = btn(net.ReadBool() )
	GeneralUpdateBool(ply, "update_bool_yrp_scoreboard_show_operating_system", "bool_yrp_scoreboard_show_operating_system", b)
end)

util.AddNetworkString( "update_bool_yrp_scoreboard_show_idcardid" )
net.Receive( "update_bool_yrp_scoreboard_show_idcardid", function(len, ply)
	local b = btn(net.ReadBool() )
	GeneralUpdateBool(ply, "update_bool_yrp_scoreboard_show_idcardid", "bool_yrp_scoreboard_show_idcardid", b)
end)



util.AddNetworkString( "update_bool_tag_on_head" )
net.Receive( "update_bool_tag_on_head", function(len, ply)
	local b = btn(net.ReadBool() )
	GeneralUpdateBool(ply, "update_bool_tag_on_head", "bool_tag_on_head", b)
end)

util.AddNetworkString( "update_bool_tag_on_head_target" )
net.Receive( "update_bool_tag_on_head_target", function(len, ply)
	local b = btn(net.ReadBool() )
	GeneralUpdateBool(ply, "update_bool_tag_on_head_target", "bool_tag_on_head_target", b)
end)

util.AddNetworkString( "update_bool_tag_on_head_idcardid" )
net.Receive( "update_bool_tag_on_head_idcardid", function(len, ply)
	local b = btn(net.ReadBool() )
	GeneralUpdateBool(ply, "update_bool_tag_on_head_idcardid", "bool_tag_on_head_idcardid", b)
end)

util.AddNetworkString( "update_bool_tag_on_head_name" )
net.Receive( "update_bool_tag_on_head_name", function(len, ply)
	local b = btn(net.ReadBool() )
	GeneralUpdateBool(ply, "update_bool_tag_on_head_name", "bool_tag_on_head_name", b)
end)

util.AddNetworkString( "update_bool_tag_on_head_name_onlyfaction" )
net.Receive( "update_bool_tag_on_head_name_onlyfaction", function(len, ply)
	local b = btn(net.ReadBool() )
	GeneralUpdateBool(ply, "update_bool_tag_on_head_name_onlyfaction", "bool_tag_on_head_name_onlyfaction", b)
end)

util.AddNetworkString( "update_bool_tag_on_head_name_onlygroup" )
net.Receive( "update_bool_tag_on_head_name_onlygroup", function(len, ply)
	local b = btn(net.ReadBool() )
	GeneralUpdateBool(ply, "update_bool_tag_on_head_name_onlygroup", "bool_tag_on_head_name_onlygroup", b)
end)

util.AddNetworkString( "update_bool_tag_on_head_name_onlyrole" )
net.Receive( "update_bool_tag_on_head_name_onlyrole", function(len, ply)
	local b = btn(net.ReadBool() )
	GeneralUpdateBool(ply, "update_bool_tag_on_head_name_onlyrole", "bool_tag_on_head_name_onlyrole", b)
end)

util.AddNetworkString( "update_bool_tag_on_head_clan" )
net.Receive( "update_bool_tag_on_head_clan", function(len, ply)
	local b = btn(net.ReadBool() )
	GeneralUpdateBool(ply, "update_bool_tag_on_head_clan", "bool_tag_on_head_clan", b)
end)

util.AddNetworkString( "update_bool_tag_on_head_level" )
net.Receive( "update_bool_tag_on_head_level", function(len, ply)
	local b = btn(net.ReadBool() )
	GeneralUpdateBool(ply, "update_bool_tag_on_head_level", "bool_tag_on_head_level", b)
end)

util.AddNetworkString( "update_bool_tag_on_head_rolename" )
net.Receive( "update_bool_tag_on_head_rolename", function(len, ply)
	local b = btn(net.ReadBool() )
	GeneralUpdateBool(ply, "update_bool_tag_on_head_rolename", "bool_tag_on_head_rolename", b)
end)

util.AddNetworkString( "update_bool_tag_on_head_factionname" )
net.Receive( "update_bool_tag_on_head_factionname", function(len, ply)
	local b = btn(net.ReadBool() )
	GeneralUpdateBool(ply, "update_bool_tag_on_head_factionname", "bool_tag_on_head_factionname", b)
end)

util.AddNetworkString( "update_bool_tag_on_head_groupname" )
net.Receive( "update_bool_tag_on_head_groupname", function(len, ply)
	local b = btn(net.ReadBool() )
	GeneralUpdateBool(ply, "update_bool_tag_on_head_groupname", "bool_tag_on_head_groupname", b)
end)

util.AddNetworkString( "update_bool_tag_on_head_health" )
net.Receive( "update_bool_tag_on_head_health", function(len, ply)
	local b = btn(net.ReadBool() )
	GeneralUpdateBool(ply, "update_bool_tag_on_head_health", "bool_tag_on_head_health", b)
end)

util.AddNetworkString( "update_bool_tag_on_head_armor" )
net.Receive( "update_bool_tag_on_head_armor", function(len, ply)
	local b = btn(net.ReadBool() )
	GeneralUpdateBool(ply, "update_bool_tag_on_head_armor", "bool_tag_on_head_armor", b)
end)

util.AddNetworkString( "update_bool_tag_on_head_usergroup" )
net.Receive( "update_bool_tag_on_head_usergroup", function(len, ply)
	local b = btn(net.ReadBool() )
	GeneralUpdateBool(ply, "update_bool_tag_on_head_usergroup", "bool_tag_on_head_usergroup", b)
end)

util.AddNetworkString( "update_bool_tag_on_head_target_forced" )
net.Receive( "update_bool_tag_on_head_target_forced", function(len, ply)
	local b = btn(net.ReadBool() )
	GeneralUpdateBool(ply, "update_bool_tag_on_head_target_forced", "bool_tag_on_head_target_forced", b)
end)

util.AddNetworkString( "update_bool_tag_on_head_voice" )
net.Receive( "update_bool_tag_on_head_voice", function(len, ply)
	local b = btn(net.ReadBool() )
	GeneralUpdateBool(ply, "update_bool_tag_on_head_voice", "bool_tag_on_head_voice", b)
end)

util.AddNetworkString( "update_bool_tag_on_head_chat" )
net.Receive( "update_bool_tag_on_head_chat", function(len, ply)
	local b = btn(net.ReadBool() )
	GeneralUpdateBool(ply, "update_bool_tag_on_head_chat", "bool_tag_on_head_chat", b)
end)


util.AddNetworkString( "update_bool_tag_on_side" )
net.Receive( "update_bool_tag_on_side", function(len, ply)
	local b = btn(net.ReadBool() )
	GeneralUpdateBool(ply, "update_bool_tag_on_side", "bool_tag_on_side", b)
end)

util.AddNetworkString( "update_bool_tag_on_side_target" )
net.Receive( "update_bool_tag_on_side_target", function(len, ply)
	local b = btn(net.ReadBool() )
	GeneralUpdateBool(ply, "update_bool_tag_on_side_target", "bool_tag_on_side_target", b)
end)

util.AddNetworkString( "update_bool_tag_on_side_name" )
net.Receive( "update_bool_tag_on_side_name", function(len, ply)
	local b = btn(net.ReadBool() )
	GeneralUpdateBool(ply, "update_bool_tag_on_side_name", "bool_tag_on_side_name", b)
end)

util.AddNetworkString( "update_bool_tag_on_side_idcardid" )
net.Receive( "update_bool_tag_on_side_idcardid", function(len, ply)
	local b = btn(net.ReadBool() )
	GeneralUpdateBool(ply, "update_bool_tag_on_side_idcardid", "bool_tag_on_side_idcardid", b)
end)

util.AddNetworkString( "update_bool_tag_on_side_clan" )
net.Receive( "update_bool_tag_on_side_clan", function(len, ply)
	local b = btn(net.ReadBool() )
	GeneralUpdateBool(ply, "update_bool_tag_on_side_clan", "bool_tag_on_side_clan", b)
end)

util.AddNetworkString( "update_bool_tag_on_side_level" )
net.Receive( "update_bool_tag_on_side_level", function(len, ply)
	local b = btn(net.ReadBool() )
	GeneralUpdateBool(ply, "update_bool_tag_on_side_level", "bool_tag_on_side_level", b)
end)

util.AddNetworkString( "update_bool_tag_on_side_rolename" )
net.Receive( "update_bool_tag_on_side_rolename", function(len, ply)
	local b = btn(net.ReadBool() )
	GeneralUpdateBool(ply, "update_bool_tag_on_side_rolename", "bool_tag_on_side_rolename", b)
end)

util.AddNetworkString( "update_bool_tag_on_side_factionname" )
net.Receive( "update_bool_tag_on_side_factionname", function(len, ply)
	local b = btn(net.ReadBool() )
	GeneralUpdateBool(ply, "update_bool_tag_on_side_factionname", "bool_tag_on_side_factionname", b)
end)

util.AddNetworkString( "update_bool_tag_on_side_groupname" )
net.Receive( "update_bool_tag_on_side_groupname", function(len, ply)
	local b = btn(net.ReadBool() )
	GeneralUpdateBool(ply, "update_bool_tag_on_side_groupname", "bool_tag_on_side_groupname", b)
end)

util.AddNetworkString( "update_bool_tag_on_side_health" )
net.Receive( "update_bool_tag_on_side_health", function(len, ply)
	local b = btn(net.ReadBool() )
	GeneralUpdateBool(ply, "update_bool_tag_on_side_health", "bool_tag_on_side_health", b)
end)

util.AddNetworkString( "update_bool_tag_on_side_armor" )
net.Receive( "update_bool_tag_on_side_armor", function(len, ply)
	local b = btn(net.ReadBool() )
	GeneralUpdateBool(ply, "update_bool_tag_on_side_armor", "bool_tag_on_side_armor", b)
end)

util.AddNetworkString( "update_bool_tag_on_side_usergroup" )
net.Receive( "update_bool_tag_on_side_usergroup", function(len, ply)
	local b = btn(net.ReadBool() )
	GeneralUpdateBool(ply, "update_bool_tag_on_side_usergroup", "bool_tag_on_side_usergroup", b)
end)



--[[ MONEY SETTINGS ]]--
util.AddNetworkString( "update_bool_drop_money_on_death" )
net.Receive( "update_bool_drop_money_on_death", function(len, ply)
	local b = btn(net.ReadBool() )
	GeneralUpdateBool(ply, "update_bool_drop_money_on_death", "bool_drop_money_on_death", b)
end)

util.AddNetworkString( "update_text_money_max_amount_of_dropped_money" )
net.Receive( "update_text_money_max_amount_of_dropped_money", function(len, ply)
	local str = net.ReadString()
	GeneralUpdateString(ply, "update_text_money_max_amount_of_dropped_money", "text_money_max_amount_of_dropped_money", str)
end)


util.AddNetworkString( "update_text_money_pre" )
net.Receive( "update_text_money_pre", function(len, ply)
	local str = net.ReadString()
	GeneralUpdateString(ply, "update_text_money_pre", "text_money_pre", str)
end)

util.AddNetworkString( "update_text_money_pos" )
net.Receive( "update_text_money_pos", function(len, ply)
	local str = net.ReadString()
	GeneralUpdateString(ply, "update_text_money_pos", "text_money_pos", str)
end)

util.AddNetworkString( "update_text_money_model" )
net.Receive( "update_text_money_model", function(len, ply)
	local str = net.ReadString()
	GeneralUpdateString(ply, "update_text_money_model", "text_money_model", str)
end)

util.AddNetworkString( "update_bool_money_printer_spawn_money" )
net.Receive( "update_bool_money_printer_spawn_money", function(len, ply)
	local b = btn(net.ReadBool() )
	GeneralUpdateBool(ply, "update_bool_money_printer_spawn_money", "bool_money_printer_spawn_money", b)
end)



--[[ CHARACTERS SETTINGS ]]--
util.AddNetworkString( "update_text_characters_money_start" )
net.Receive( "update_text_characters_money_start", function(len, ply)
	local str = net.ReadString()
	GeneralUpdateString(ply, "update_text_characters_money_start", "text_characters_money_start", str)
end)

util.AddNetworkString( "update_bool_characters_changeable_name" )
net.Receive( "update_bool_characters_changeable_name", function(len, ply)
	local b = btn(net.ReadBool() )
	GeneralUpdateBool(ply, "update_bool_characters_changeable_name", "bool_characters_changeable_name", b)
end)

util.AddNetworkString( "update_bool_characters_removeondeath" )
net.Receive( "update_bool_characters_removeondeath", function(len, ply)
	local b = btn(net.ReadBool() )
	GeneralUpdateBool(ply, "update_bool_characters_removeondeath", "bool_characters_removeondeath", b)
end)

util.AddNetworkString( "update_bool_characters_birthday" )
net.Receive( "update_bool_characters_birthday", function(len, ply)
	local b = btn(net.ReadBool() )
	GeneralUpdateBool(ply, "update_bool_characters_birthday", "bool_characters_birthday", b)
end)
util.AddNetworkString( "update_bool_characters_bodyheight" )
net.Receive( "update_bool_characters_bodyheight", function(len, ply)
	local b = btn(net.ReadBool() )
	GeneralUpdateBool(ply, "update_bool_characters_bodyheight", "bool_characters_bodyheight", b)
end)
util.AddNetworkString( "update_bool_characters_weight" )
net.Receive( "update_bool_characters_weight", function(len, ply)
	local b = btn(net.ReadBool() )
	GeneralUpdateBool(ply, "update_bool_characters_weight", "bool_characters_weight", b)
end)

util.AddNetworkString( "update_int_logouttime" )
net.Receive( "update_int_logouttime", function(len, ply)
	local int = net.ReadString()
	if isnumber(tonumber(int) ) then
		GeneralUpdateInt(ply, "update_int_logouttime", "int_logouttime", int)
	end
end)

util.AddNetworkString( "update_int_deathtimestamp_min" )
net.Receive( "update_int_deathtimestamp_min", function(len, ply)
	local int = net.ReadString()
	if isnumber(tonumber(int) ) then
		GeneralUpdateInt(ply, "update_int_deathtimestamp_min", "int_deathtimestamp_min", int)
	end
end)
util.AddNetworkString( "update_int_deathtimestamp_max" )
net.Receive( "update_int_deathtimestamp_max", function(len, ply)
	local int = net.ReadString()
	if isnumber(tonumber(int) ) then
		GeneralUpdateInt(ply, "update_int_deathtimestamp_max", "int_deathtimestamp_max", int)
	end
end)

util.AddNetworkString( "update_bool_deathscreen" )
net.Receive( "update_bool_deathscreen", function(len, ply)
	local b = btn(net.ReadBool() )
	GeneralUpdateBool(ply, "update_bool_deathscreen", "bool_deathscreen", b)
end)



--[[ SOCIAL SETTINGS ]]--
util.AddNetworkString( "update_text_social_website" )
net.Receive( "update_text_social_website", function(len, ply)
	local str = net.ReadString()
	str = string.Replace(str, " ", "" )
	GeneralUpdateString(ply, "update_text_social_website", "text_social_website", str)
end)

util.AddNetworkString( "update_text_social_forum" )
net.Receive( "update_text_social_forum", function(len, ply)
	local str = net.ReadString()
	str = string.Replace(str, " ", "" )
	GeneralUpdateString(ply, "update_text_social_forum", "text_social_forum", str)
end)

util.AddNetworkString( "update_text_social_discord" )
net.Receive( "update_text_social_discord", function(len, ply)
	local str = net.ReadString()
	str = string.Replace(str, " ", "" )
	GeneralUpdateString(ply, "update_text_social_discord", "text_social_discord", str)
end)

util.AddNetworkString( "update_text_social_discord_widgetid" )
net.Receive( "update_text_social_discord_widgetid", function(len, ply)
	local str = net.ReadString()
	str = string.Replace(str, " ", "" )
	GeneralUpdateString(ply, "update_text_social_discord_widgetid", "text_social_discord_widgetid", str)
end)

util.AddNetworkString( "update_text_social_teamspeak_ip" )
net.Receive( "update_text_social_teamspeak_ip", function(len, ply)
	local str = net.ReadString()
	str = string.Replace(str, " ", "" )
	GeneralUpdateString(ply, "update_text_social_teamspeak_ip", "text_social_teamspeak_ip", str)
end)

util.AddNetworkString( "update_text_social_teamspeak_port" )
net.Receive( "update_text_social_teamspeak_port", function(len, ply)
	local str = net.ReadString()
	str = string.Replace(str, " ", "" )
	GeneralUpdateString(ply, "update_text_social_teamspeak_port", "text_social_teamspeak_port", str)
end)

util.AddNetworkString( "update_text_social_teamspeak_query_port" )
net.Receive( "update_text_social_teamspeak_query_port", function(len, ply)
	local str = net.ReadString()
	str = string.Replace(str, " ", "" )
	GeneralUpdateString(ply, "update_text_social_teamspeak_query_port", "text_social_teamspeak_query_port", str)
end)

util.AddNetworkString( "update_text_social_youtube" )
net.Receive( "update_text_social_youtube", function(len, ply)
	local str = net.ReadString()
	str = string.Replace(str, " ", "" )
	GeneralUpdateString(ply, "update_text_social_youtube", "text_social_youtube", str)
end)

util.AddNetworkString( "update_text_social_twitch" )
net.Receive( "update_text_social_twitch", function(len, ply)
	local str = net.ReadString()
	GeneralUpdateString(ply, "update_text_social_twitch", "text_social_twitch", str)
end)

util.AddNetworkString( "update_text_social_twitter" )
net.Receive( "update_text_social_twitter", function(len, ply)
	local str = net.ReadString()
	str = string.Replace(str, " ", "" )
	GeneralUpdateString(ply, "update_text_social_twitter", "text_social_twitter", str)
end)

util.AddNetworkString( "update_text_social_facebook" )
net.Receive( "update_text_social_facebook", function(len, ply)
	local str = net.ReadString()
	str = string.Replace(str, " ", "" )
	GeneralUpdateString(ply, "update_text_social_facebook", "text_social_facebook", str)
end)

util.AddNetworkString( "update_text_social_instagram" )
net.Receive( "update_text_social_instagram", function(len, ply)
	local str = net.ReadString()
	str = string.Replace(str, " ", "" )
	GeneralUpdateString(ply, "update_text_social_instagram", "text_social_instagram", str)
end)

util.AddNetworkString( "update_text_social_steamgroup" )
net.Receive( "update_text_social_steamgroup", function(len, ply)
	local str = net.ReadString()
	str = string.Replace(str, " ", "" )
	GeneralUpdateString(ply, "update_text_social_steamgroup", "text_social_steamgroup", str)
end)



util.AddNetworkString( "update_float_scale_hunger" )
net.Receive( "update_float_scale_hunger", function(len, ply)
	local flo = net.ReadFloat()
	GeneralUpdateFloat(ply, "update_float_scale_hunger", "float_scale_hunger", flo)
end)

util.AddNetworkString( "update_float_scale_thirst" )
net.Receive( "update_float_scale_thirst", function(len, ply)
	local flo = net.ReadFloat()
	GeneralUpdateFloat(ply, "update_float_scale_thirst", "float_scale_thirst", flo)
end)


util.AddNetworkString( "update_float_scale_stamina_up" )
net.Receive( "update_float_scale_stamina_up", function(len, ply)
	local flo = net.ReadFloat()
	GeneralUpdateFloat(ply, "update_float_scale_stamina_up", "float_scale_stamina_up", flo)
end)

util.AddNetworkString( "update_float_scale_stamina_down" )
net.Receive( "update_float_scale_stamina_down", function(len, ply)
	local flo = net.ReadFloat()
	GeneralUpdateFloat(ply, "update_float_scale_stamina_down", "float_scale_stamina_down", flo)
end)


util.AddNetworkString( "update_float_scale_radiation_in" )
net.Receive( "update_float_scale_radiation_in", function(len, ply)
	local flo = net.ReadFloat()
	GeneralUpdateFloat(ply, "update_float_scale_radiation_in", "float_scale_radiation_in", flo)
end)

util.AddNetworkString( "update_float_scale_radiation_out" )
net.Receive( "update_float_scale_radiation_out", function(len, ply)
	local flo = net.ReadFloat()
	GeneralUpdateFloat(ply, "update_float_scale_radiation_out", "float_scale_radiation_out", flo)
end)

util.AddNetworkString( "update_float_scale_stamina_jump" )
net.Receive( "update_float_scale_stamina_jump", function(len, ply)
	local flo = net.ReadFloat()
	GeneralUpdateFloat(ply, "update_float_scale_stamina_jump", "float_scale_stamina_jump", flo)
end)


function AddTab(tab, name, netstr)
	local entry = {}
	entry.name = name
	entry.netstr = netstr
	table.insert(tab, entry)
end

function AddSubTab(tab, parent, name, netstr, url, func)
	local entry = {}
	entry.name = name
	entry.netstr = netstr or ""
	entry.parent = parent
	entry.url = url or ""
	entry.func = func or nil
	table.insert(tab, entry)
end

util.AddNetworkString( "gethelpmenu" )
net.Receive( "gethelpmenu", function(len, ply)
	local info = YRP_SQL_SELECT( "yrp_general", "*", "uniqueID = '1'" )
	if wk(info) then
		info = info[1]

		local tabs = {}
		local subtabs = {}

		AddTab(tabs, "LID_help", "getsitehelp" )
		AddTab(tabs, "LID_staff", "getsitestaff" )
	
		AddTab(tabs, "YourRP", "" )
		AddSubTab(subtabs, "YourRP", "Whats New", "getsiteyourrpwhatsnew" )
		AddSubTab(subtabs, "YourRP", "Discord", "getsiteyourrpdiscord" )
		AddSubTab(subtabs, "YourRP", "Translations", "getsiteyourrptranslations", "" )
		AddSubTab(subtabs, "YourRP", "Servers", "getsiteyourrpserverlist", "" )

		net.Start( "gethelpmenu" )
			net.WriteTable(tabs)
			net.WriteTable(subtabs)
		net.Send(ply)
	else
		YRP.msg( "note", "gamemode broken contact developer!" )
	end
end)

util.AddNetworkString( "getsitehelp" )
net.Receive( "getsitehelp", function(len, ply)
	net.Start( "getsitehelp" )
		net.WriteString(yrp_general.text_server_welcome_message)
		net.WriteString(yrp_general.text_server_message_of_the_day)
	net.Send(ply)
end)

util.AddNetworkString( "getsitestaff" )
net.Receive( "getsitestaff", function(len, ply)
	local staff = {}
	for i, pl in pairs(player.GetAll() ) do
		if pl:HasAccess() then
			table.insert(staff, pl)
		end
	end
	net.Start( "getsitestaff" )
		net.WriteTable(staff)
	net.Send(ply)
end)

util.AddNetworkString( "getsiteserverrules" )
net.Receive( "getsiteserverrules", function(len, ply)
	local server_rules = YRP_SQL_SELECT( "yrp_general", "text_server_rules", "uniqueID = '1'" )
	if wk(server_rules) then
		server_rules = server_rules[1].text_server_rules
	else
		server_rules = ""
	end
	net.Start( "getsiteserverrules" )
		net.WriteString(server_rules)
	net.Send(ply)
end)

util.AddNetworkString( "getsitecollection" )
net.Receive( "getsitecollection", function(len, ply)
	local collectionid = YRP_SQL_SELECT( "yrp_general", "text_server_collectionid", "uniqueID = '1'" )
	if wk( collectionid) then
		collectionid = collectionid[1].text_server_collectionid
	else
		collectionid = ""
	end
	net.Start( "getsitecollection" )
		net.WriteString( collectionid)
	net.Send(ply)
end)

util.AddNetworkString( "getsitecommunitywebsite" )
net.Receive( "getsitecommunitywebsite", function(len, ply)
	local link = YRP_SQL_SELECT( "yrp_general", "text_social_website", "uniqueID = '1'" )
	if wk(link) then
		link = link[1].text_social_website
	else
		link = ""
	end
	net.Start( "getsitecommunitywebsite" )
		net.WriteString(link)
	net.Send(ply)
end)

util.AddNetworkString( "getsitecommunityforum" )
net.Receive( "getsitecommunityforum", function(len, ply)
	local link = YRP_SQL_SELECT( "yrp_general", "text_social_forum", "uniqueID = '1'" )
	if wk(link) then
		link = link[1].text_social_forum
	else
		link = ""
	end
	net.Start( "getsitecommunityforum" )
		net.WriteString(link)
	net.Send(ply)
end)

util.AddNetworkString( "getsitecommunitydiscord" )
net.Receive( "getsitecommunitydiscord", function(len, ply)
	local sql_select = YRP_SQL_SELECT( "yrp_general", "text_social_discord, text_social_discord_widgetid", "uniqueID = '1'" )
	local link = ""
	local widgetid = ""
	if wk(link) then
		link = sql_select[1].text_social_discord
		widgetid = sql_select[1].text_social_discord_widgetid
	end
	net.Start( "getsitecommunitydiscord" )
		net.WriteString(link)
		net.WriteString(widgetid)
	net.Send(ply)
end)

util.AddNetworkString( "getsitecommunityteamspeak" )
net.Receive( "getsitecommunityteamspeak", function(len, ply)
	local sql_select = YRP_SQL_SELECT( "yrp_general", "text_social_teamspeak_ip, text_social_teamspeak_port, text_social_teamspeak_query_port", "uniqueID = '1'" )
	local ip = ""
	local port = ""
	local query_port = ""
	if wk(sql_select) then
		ip = sql_select[1].text_social_teamspeak_ip
		port = sql_select[1].text_social_teamspeak_port
		query_port = sql_select[1].text_social_teamspeak_query_port
	end
	net.Start( "getsitecommunityteamspeak" )
		net.WriteString(ip)
		net.WriteString(port)
		net.WriteString(query_port)
	net.Send(ply)
end)

util.AddNetworkString( "getsitecommunitytwitter" )
net.Receive( "getsitecommunitytwitter", function(len, ply)
	local link = YRP_SQL_SELECT( "yrp_general", "text_social_twitter", "uniqueID = '1'" )
	if wk(link) then
		link = link[1].text_social_twitter
	else
		link = ""
	end
	net.Start( "getsitecommunitytwitter" )
		net.WriteString(link)
	net.Send(ply)
end)

util.AddNetworkString( "getsitecommunityyoutube" )
net.Receive( "getsitecommunityyoutube", function(len, ply)
	local link = YRP_SQL_SELECT( "yrp_general", "text_social_youtube", "uniqueID = '1'" )
	if wk(link) then
		link = link[1].text_social_youtube
	else
		link = ""
	end
	net.Start( "getsitecommunityyoutube" )
		net.WriteString(link)
	net.Send(ply)
end)

util.AddNetworkString( "getsitecommunityfacebook" )
net.Receive( "getsitecommunityfacebook", function(len, ply)
	local link = YRP_SQL_SELECT( "yrp_general", "text_social_facebook", "uniqueID = '1'" )
	if wk(link) then
		link = link[1].text_social_facebook
	else
		link = ""
	end
	net.Start( "getsitecommunityfacebook" )
		net.WriteString(link)
	net.Send(ply)
end)

util.AddNetworkString( "getsitecommunitysteamgroup" )
net.Receive( "getsitecommunitysteamgroup", function(len, ply)
	local link = YRP_SQL_SELECT( "yrp_general", "text_social_steamgroup", "uniqueID = '1'" )
	if wk(link) then
		link = link[1].text_social_steamgroup
	else
		link = ""
	end
	net.Start( "getsitecommunitysteamgroup" )
		net.WriteString(link)
	net.Send(ply)
end)



util.AddNetworkString( "getsiteyourrpwhatsnew" )
net.Receive( "getsiteyourrpwhatsnew", function(len, ply)
	net.Start( "getsiteyourrpwhatsnew" )
	net.Send(ply)
end)

util.AddNetworkString( "getsiteyourrpdiscord" )
net.Receive( "getsiteyourrpdiscord", function(len, ply)
	net.Start( "getsiteyourrpdiscord" )
	net.Send(ply)
end)

util.AddNetworkString( "getsiteyourrpserverlist" )
net.Receive( "getsiteyourrpserverlist", function(len, ply)
	net.Start( "getsiteyourrpserverlist" )
	net.Send(ply)
end)

util.AddNetworkString( "getsiteyourrptranslations" )
net.Receive( "getsiteyourrptranslations", function(len, ply)
	net.Start( "getsiteyourrptranslations" )
	net.Send(ply)
end)

--[[ OLD GETTER BELOW ]]--

util.AddNetworkString( "dbUpdate" )
net.Receive( "dbUpdate", function(len, ply)
	local _dbTable = net.ReadString()
	local _dbSets = net.ReadString()
	local _dbWhile = net.ReadString()
	local _result = YRP_SQL_UPDATE(_dbTable, _dbSets, _dbWhile)
	local _usergroup_ = string.Explode( " ", _dbWhile)
	local _restriction_ = string.Explode( " ", _dbSets)
	YRP.msg( "note", "[OLD DBUPDATE] " .. ply:SteamName() .. " SETS " .. _dbSets .. " WHERE " .. _dbWhile)
end)



-- Scoreboard Commands
util.AddNetworkString( "ply_kick" )
net.Receive( "ply_kick", function(len, ply)
	if ply:HasAccess() then
		local _target = net.ReadEntity()
		if ea( _target ) then
			_target:Kick( "You get kicked by " .. ply:YRPName() )
		end
	end
end)
util.AddNetworkString( "ply_ban" )
net.Receive( "ply_ban", function(len, ply)
	if ply:HasAccess() then
		local _target = net.ReadEntity()
		if ea( _target ) then
			_target:Ban(24 * 60, false)
			_target:Kick( "You get banned for 24 hours by " .. ply:YRPName() )
		else
			YRP.msg( "note", "ply_ban " .. tostring(_target) .. " IS NIL => NOT AVAILABLE" )
		end
	end
end)

function YRPGetPlayerBySteamID(steamid)
	for i, ply in pairs(player.GetAll() ) do
		if ply:SteamID() == steamid or ply:SteamID64() == steamid then
			return ply
		end
	end
	return nil
end

util.AddNetworkString( "tp_tpto_steamid" )
net.Receive( "tp_tpto_steamid", function(len, ply)
	if ply:HasAccess() then
		local steamid = net.ReadString()
		local _target = YRPGetPlayerBySteamID(steamid)
		if _target then
			teleportToPoint(ply, _target:GetPos() )
		end
	end
end)
util.AddNetworkString( "tp_bring_steamid" )
net.Receive( "tp_bring_steamid", function(len, ply)
	if ply:HasAccess() then
		local steamid = net.ReadString()
		local _target = YRPGetPlayerBySteamID(steamid)
		if _target then
			teleportToPoint(_target, ply:GetPos() )
		end
	end
end)

util.AddNetworkString( "tp_tpto" )
net.Receive( "tp_tpto", function(len, ply)
	if IsValid( ply ) and ply:HasAccess() then
		local _target = net.ReadEntity()
		if IsValid( _target ) then
			ply:SetYRPVector( "yrpoldpos", ply:GetPos() )
			teleportToPoint(ply, _target:GetPos() )
		end
	end
end)
util.AddNetworkString( "tp_bring" )
net.Receive( "tp_bring", function(len, ply)
	if ply:HasAccess() then
		local _target = net.ReadEntity()
		_target:SetYRPVector( "yrpoldpos", _target:GetPos() )
		teleportToPoint(_target, ply:GetPos() )
	end
end)
util.AddNetworkString( "tp_return" )
net.Receive( "tp_return", function(len, ply)
	if ply:HasAccess() then
		local _target = net.ReadEntity()
		if _target:GetYRPVector( "yrpoldpos" ) != Vector(0, 0, 0) then
			teleportToPoint(_target, _target:GetYRPVector( "yrpoldpos" ) )

			_target:SetYRPVector( "yrpoldpos", Vector(0, 0, 0) ) -- RESET
		end
	end
end)
util.AddNetworkString( "tp_jail" )
net.Receive( "tp_jail", function(len, ply)
	if ply:HasAccess() then
		local _target = net.ReadEntity()
		teleportToJailpoint(_target, 5 * 60 )
	end
end)
util.AddNetworkString( "tp_unjail" )
net.Receive( "tp_unjail", function(len, ply)
	if ply:HasAccess() then
		local _target = net.ReadEntity()
		teleportToReleasepoint(_target)
	end
end)

function YRPIsRagdoll(ply)
	return ply:GetYRPBool( "ragdolled", false)
end

function YRPDoRagdoll(ply)
	if IsValid(ply) and ply:IsPlayer() and not YRPIsRagdoll(ply) then
		ply:SetYRPBool( "ragdolled", true)

		local scale = ply:GetModelScale() or 1

		local tmp = ents.Create( "prop_ragdoll" )
		tmp:SetModel(ply:GetModel() )
		tmp:SetModelScale(scale, 0)
		tmp:SetPos(ply:GetPos() + Vector(0, 0, 0) )
		tmp:Spawn()

		--ply:SetParent(tmp)
		ply:SetYRPEntity( "ragdoll", tmp)

		ply:SetNoTarget( true )
		ply:SetMoveType( MOVETYPE_NONE )
		--ply:Freeze( true )

		YRPRenderCloaked(ply)
	end
end

function YRPDoUnRagdoll(ply)
	if IsValid(ply) and ply:IsPlayer() and YRPIsRagdoll(ply) then
		ply:SetYRPBool( "ragdolled", false)
		--ply:SetParent(nil)

		local ragdoll = ply:GetYRPEntity( "ragdoll" )
		if ea(ragdoll) then
			ply:SetPos( ragdoll:GetPos() )
			ragdoll:Remove()
		end

		ply:SetNoTarget( false )
		ply:SetMoveType( MOVETYPE_WALK )
		--ply:Freeze( false )

		YRPRenderNormal(ply)
	end
end

util.AddNetworkString( "ragdoll" )
net.Receive( "ragdoll", function(len, ply)
	if ply:HasAccess() then
		local _target = net.ReadEntity()
		if ea(_target) then
			YRPDoRagdoll(_target)
		end
	end
end)

util.AddNetworkString( "unragdoll" )
net.Receive( "unragdoll", function(len, ply)
	if ply:HasAccess() then
		local _target = net.ReadEntity()
		if ea(_target) then
			YRPDoUnRagdoll(_target)
		end
	end
end)
util.AddNetworkString( "freeze" )
net.Receive( "freeze", function(len, ply)
	if ply:HasAccess() then
		local _target = net.ReadEntity()
		if ea(_target) and _target.Freeze then
			_target:Freeze(true)
			YRPRenderFrozen(_target)
		end
	end
end)
util.AddNetworkString( "unfreeze" )
net.Receive( "unfreeze", function(len, ply)
	if ply:HasAccess() then
		local _target = net.ReadEntity()
		if ea(_target) then
			_target:Freeze(false)
			YRPRenderNormal(_target)
		end
	end
end)
util.AddNetworkString( "god" )
net.Receive( "god", function(len, ply)
	if ply:HasAccess() then
		local _target = net.ReadEntity()
		if ea(_target) then
			_target:GodEnable()
			_target:AddFlags(FL_GODMODE)
			_target:SetYRPBool( "godmode", true)
		end
	end
end)
util.AddNetworkString( "ungod" )
net.Receive( "ungod", function(len, ply)
	if ply:HasAccess() then
		local _target = net.ReadEntity()
		if ea(_target) then
			_target:GodDisable()
			_target:RemoveFlags(FL_GODMODE)
			_target:SetYRPBool( "godmode", false)
		end
	end
end)
util.AddNetworkString( "cloak" )
net.Receive( "cloak", function(len, ply)
	if ply:HasAccess() then
		local _target = net.ReadEntity()
		if ea(_target) then
			_target:SetYRPBool( "cloaked", true)
			YRPRenderCloaked(_target)
		end
	end
end)
util.AddNetworkString( "uncloak" )
net.Receive( "uncloak", function(len, ply)
	if ply:HasAccess() then
		local _target = net.ReadEntity()
		if ea(_target) then
			_target:SetYRPBool( "cloaked", false)
			YRPRenderNormal(_target)
		end
	end
end)
util.AddNetworkString( "blind" )
net.Receive( "blind", function(len, ply)
	if ply:HasAccess() then
		local _target = net.ReadEntity()
		if ea(_target) then
			_target:SetYRPBool( "blinded", true)
		end
	end
end)
util.AddNetworkString( "unblind" )
net.Receive( "unblind", function(len, ply)
	if ply:HasAccess() then
		local _target = net.ReadEntity()
		if ea(_target) then
			_target:SetYRPBool( "blinded", false)
		end
	end
end)
util.AddNetworkString( "ignite" )
net.Receive( "ignite", function(len, ply)
	if ply:HasAccess() then
		local _target = net.ReadEntity()
		if ea(_target) then
			_target:Ignite(10, 10)
		end
	end
end)
util.AddNetworkString( "extinguish" )
net.Receive( "extinguish", function(len, ply)
	if ply:HasAccess() then
		local _target = net.ReadEntity()
		if ea(_target) then
			_target:Extinguish()
		end
	end
end)
util.AddNetworkString( "slay" )
net.Receive( "slay", function(len, ply)
	if ply:HasAccess() then
		local _target = net.ReadEntity()
		if ea(_target) then
			_target:Kill()
		end
	end
end)
util.AddNetworkString( "slap" )
net.Receive( "slap", function(len, ply)
	if ply:HasAccess() then
		local _target = net.ReadEntity()
		if ea(_target) then
			_target:SetVelocity( Vector(0, 0, 600) )
		end
	end
end)



-- YRPRepairSQLDB
function YRPFixDatabase(tab, name, c)
	c = c or 0
	if wk(tab) then
		for id, value in pairs(tab) do
			if type( value) == "string" then
				YRP_SQL_UPDATE(name, {[id] = YRP_SQL_STR_OUT( value )}, "" .. id .. " = '" .. value .. "'" )
			elseif type( value) == "table" then
				YRPFixDatabase( value, name, c + 1)
			end
		end
	end
end

local fixonce = true
function YRPRepairSQLDB(force) -- Remove %01 - %XX
	local version = YRP_SQL_SELECT(DATABASE_NAME, "int_version", "uniqueID = '1'" )
	if wk( version) then
		version = tonumber( version[1].int_version)
		if ( version <= 1 or force) and fixonce then
			fixonce = false
			local alltables = YRP_SQL_QUERY( "SELECT * FROM sqlite_master WHERE type='table';" )
			MsgC(YRPColGreen(), ">>> REPAIR YourRP DB, START <<<" .. "\n" )
			if alltables then
				for i, v in pairs( alltables ) do
					if string.StartWith( v.name, "yrp_" ) then
						MsgC(YRPColGreen(), "> FIX DB: " .. v.name .. "\n" )
						local tab = YRP_SQL_SELECT( v.name, "*", nil)
						YRPFixDatabase(tab, v.name)
					end
				end
			else
				MsgC(YRPColRed(), ">>> FAILED, NO TABLES <<<" .. "\n" )
			end
			MsgC(YRPColGreen(), ">>> REPAIR YourRP DB, DONE <<<" .. "\n" )

			YRP_SQL_UPDATE(DATABASE_NAME, {["int_version"] = 2}, "uniqueID = '1'" )
		end
	end
end
timer.Simple(1, YRPRepairSQLDB)

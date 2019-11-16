--Copyright (C) 2017-2019 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

-- DO NOT TOUCH THE DATABASE FILES! If you have errors, report them here:
-- https://discord.gg/sEgNZxg

local DATABASE_NAME = "yrp_general"

--db_drop_table(DATABASE_NAME)
--db_is_empty(DATABASE_NAME)

--[[ Server Settings ]]--
SQL_ADD_COLUMN(DATABASE_NAME, "bool_server_reload", "INT DEFAULT 1")

SQL_ADD_COLUMN(DATABASE_NAME, "bool_noclip_model", "INT DEFAULT 1")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_noclip_stealth", "INT DEFAULT 0")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_noclip_tags", "INT DEFAULT 1")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_noclip_effect", "INT DEFAULT 1")
SQL_ADD_COLUMN(DATABASE_NAME, "text_noclip_mdl", "TEXT DEFAULT 'models/crow.mdl'")

SQL_ADD_COLUMN(DATABASE_NAME, "text_server_collectionid", "INT DEFAULT 0")

SQL_ADD_COLUMN(DATABASE_NAME, "text_community_servers", "TEXT DEFAULT ' '")

SQL_ADD_COLUMN(DATABASE_NAME, "text_server_name", "TEXT DEFAULT ''")
SQL_ADD_COLUMN(DATABASE_NAME, "text_server_logo", "TEXT DEFAULT ''")

SQL_ADD_COLUMN(DATABASE_NAME, "text_server_rules", "TEXT DEFAULT ' '")

SQL_ADD_COLUMN(DATABASE_NAME, "text_server_welcome_message", "TEXT DEFAULT 'Welcome'")
SQL_ADD_COLUMN(DATABASE_NAME, "text_server_message_of_the_day", "TEXT DEFAULT 'Today'")

SQL_ADD_COLUMN(DATABASE_NAME, "bool_server_debug", "INT DEFAULT 1")

SQL_ADD_COLUMN(DATABASE_NAME, "bool_server_debug_voice", "INT DEFAULT 0")

SQL_ADD_COLUMN(DATABASE_NAME, "bool_msg_channel_gm", "INT DEFAULT 1")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_msg_channel_db", "INT DEFAULT 1")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_msg_channel_noti", "INT DEFAULT 1")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_msg_channel_lang", "INT DEFAULT 1")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_msg_channel_darkrp", "INT DEFAULT 1")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_msg_channel_chat", "INT DEFAULT 0")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_msg_channel_debug", "INT DEFAULT 0")

--[[ Gamemode Settings ]]--
SQL_ADD_COLUMN(DATABASE_NAME, "text_gamemode_name", "TEXT DEFAULT 'YourRP'")

SQL_ADD_COLUMN(DATABASE_NAME, "bool_graffiti_disabled", "INT DEFAULT 1")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_anti_bhop", "INT DEFAULT 1")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_suicide_disabled", "INT DEFAULT 1")

SQL_ADD_COLUMN(DATABASE_NAME, "bool_drop_items_on_death", "INT DEFAULT 1")

SQL_ADD_COLUMN(DATABASE_NAME, "bool_players_need_to_introduce", "INT DEFAULT 0")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_players_can_drop_weapons", "INT DEFAULT 1")

SQL_ADD_COLUMN(DATABASE_NAME, "bool_dealers_can_take_damage", "INT DEFAULT 1")

SQL_ADD_COLUMN(DATABASE_NAME, "bool_thirdperson", "INT DEFAULT 1")
SQL_ADD_COLUMN(DATABASE_NAME, "text_view_distance", "TEXT DEFAULT '200'")

SQL_ADD_COLUMN(DATABASE_NAME, "text_chat_advert", "TEXT DEFAULT 'Advert'")

SQL_ADD_COLUMN(DATABASE_NAME, "bool_removebuildingowner", "INT DEFAULT 0")
SQL_ADD_COLUMN(DATABASE_NAME, "text_removebuildingownertime", "TEXT DEFAULT '600'")

--[[ Gamemode Systems ]]--
SQL_ADD_COLUMN(DATABASE_NAME, "bool_hunger", "INT DEFAULT 1")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_hunger_health_regeneration", "INT DEFAULT 1")
SQL_ADD_COLUMN(DATABASE_NAME, "text_hunger_health_regeneration_tickrate", "TEXT DEFAULT '10'")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_thirst", "INT DEFAULT 1")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_stamina", "INT DEFAULT 1")

SQL_ADD_COLUMN(DATABASE_NAME, "bool_identity_card", "INT DEFAULT 1")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_map_system", "INT DEFAULT 1")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_building_system", "INT DEFAULT 1")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_inventory_system", "INT DEFAULT 0")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_appearance_system", "INT DEFAULT 1")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_smartphone_system", "INT DEFAULT 1")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_realistic_system", "INT DEFAULT 1")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_level_system", "INT DEFAULT 1")

SQL_ADD_COLUMN(DATABASE_NAME, "bool_players_can_switch_role", "INT DEFAULT 1")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_players_die_on_role_switch", "INT DEFAULT 0")

SQL_ADD_COLUMN(DATABASE_NAME, "bool_wanted_system", "INT DEFAULT 0")

SQL_ADD_COLUMN(DATABASE_NAME, "bool_voice", "INT DEFAULT 1")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_voice_3d", "INT DEFAULT 1")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_voice_channels", "INT DEFAULT 1")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_voice_group_local", "INT DEFAULT 1")
SQL_ADD_COLUMN(DATABASE_NAME, "int_voice_local_range", "INT DEFAULT 300")
SQL_ADD_COLUMN(DATABASE_NAME, "int_voice_max_range", "INT DEFAULT 900")

--[[ Gamemode Visuals ]]--
SQL_ADD_COLUMN(DATABASE_NAME, "bool_yrp_combined_menu", "INT DEFAULT 1")
SQL_ADD_COLUMN(DATABASE_NAME, "text_character_background", "TEXT DEFAULT ''")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_yrp_chat", "INT DEFAULT 1")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_yrp_chat_show_rolename", "INT DEFAULT 1")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_yrp_chat_show_factionname", "INT DEFAULT 1")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_yrp_chat_show_groupname", "INT DEFAULT 1")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_yrp_chat_show_usergroup", "INT DEFAULT 1")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_yrp_chat_show_idcardid", "INT DEFAULT 1")

SQL_ADD_COLUMN(DATABASE_NAME, "bool_yrp_crosshair", "INT DEFAULT 1")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_yrp_hud", "INT DEFAULT 1")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_yrp_scoreboard", "INT DEFAULT 1")
SQL_ADD_COLUMN(DATABASE_NAME, "text_yrp_scoreboard_style", "TEXT DEFAULT 'simple'")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_yrp_scoreboard_show_rolename", "INT DEFAULT 1")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_yrp_scoreboard_show_groupname", "INT DEFAULT 1")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_yrp_scoreboard_show_level", "INT DEFAULT 1")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_yrp_scoreboard_show_usergroup", "INT DEFAULT 1")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_yrp_scoreboard_show_language", "INT DEFAULT 1")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_yrp_scoreboard_show_country", "INT DEFAULT 1")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_yrp_scoreboard_show_frags", "INT DEFAULT 0")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_yrp_scoreboard_show_deaths", "INT DEFAULT 0")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_yrp_scoreboard_show_playtime", "INT DEFAULT 1")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_yrp_scoreboard_show_operating_system", "INT DEFAULT 0")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_yrp_scoreboard_show_idcardid", "INT DEFAULT 1")

SQL_ADD_COLUMN(DATABASE_NAME, "bool_tag_on_head", "INT DEFAULT 0")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_tag_on_head_clan", "INT DEFAULT 1")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_tag_on_head_name", "INT DEFAULT 1")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_tag_on_head_level", "INT DEFAULT 1")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_tag_on_head_rolename", "INT DEFAULT 1")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_tag_on_head_factionname", "INT DEFAULT 1")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_tag_on_head_groupname", "INT DEFAULT 1")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_tag_on_head_health", "INT DEFAULT 1")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_tag_on_head_armor", "INT DEFAULT 1")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_tag_on_head_usergroup", "INT DEFAULT 1")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_tag_on_head_voice", "INT DEFAULT 1")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_tag_on_head_chat", "INT DEFAULT 1")

SQL_ADD_COLUMN(DATABASE_NAME, "bool_tag_on_side", "INT DEFAULT 0")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_tag_on_side_name", "INT DEFAULT 1")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_tag_on_side_clan", "INT DEFAULT 1")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_tag_on_side_level", "INT DEFAULT 1")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_tag_on_side_rolename", "INT DEFAULT 1")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_tag_on_side_factionname", "INT DEFAULT 1")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_tag_on_side_groupname", "INT DEFAULT 1")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_tag_on_side_health", "INT DEFAULT 1")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_tag_on_side_armor", "INT DEFAULT 1")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_tag_on_side_usergroup", "INT DEFAULT 1")

--[[ Money Settings ]]--
SQL_ADD_COLUMN(DATABASE_NAME, "bool_drop_money_on_death", "INT DEFAULT 1")
SQL_ADD_COLUMN(DATABASE_NAME, "text_money_max_amount_of_dropped_money", "TEXT DEFAULT '1000'")
SQL_ADD_COLUMN(DATABASE_NAME, "text_money_pre", "TEXT DEFAULT '$'")
SQL_ADD_COLUMN(DATABASE_NAME, "text_money_pos", "TEXT DEFAULT ' '")
SQL_ADD_COLUMN(DATABASE_NAME, "text_money_model", "TEXT DEFAULT 'models/props/cs_assault/money.mdl'")

SQL_ADD_COLUMN(DATABASE_NAME, "bool_money_printer_spawn_money", "INT DEFAULT 1")

--[[ Characters Settings ]]--
SQL_ADD_COLUMN(DATABASE_NAME, "text_characters_money_start", "TEXT DEFAULT '500'")
SQL_ADD_COLUMN(DATABASE_NAME, "text_characters_max", "TEXT DEFAULT '10'")

SQL_ADD_COLUMN(DATABASE_NAME, "bool_characters_gender", "INT DEFAULT 1")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_characters_othergender", "INT DEFAULT 0")

--[[ Social Settings ]]--
SQL_ADD_COLUMN(DATABASE_NAME, "text_social_website", "TEXT DEFAULT ' '")
SQL_ADD_COLUMN(DATABASE_NAME, "text_social_forum", "TEXT DEFAULT ' '")
SQL_ADD_COLUMN(DATABASE_NAME, "text_social_discord", "TEXT DEFAULT ' '")
SQL_ADD_COLUMN(DATABASE_NAME, "text_social_discord_widgetid", "TEXT DEFAULT ' '")
SQL_ADD_COLUMN(DATABASE_NAME, "text_social_teamspeak_ip", "TEXT DEFAULT ' '")
SQL_ADD_COLUMN(DATABASE_NAME, "text_social_teamspeak_port", "TEXT DEFAULT '9987'")
SQL_ADD_COLUMN(DATABASE_NAME, "text_social_teamspeak_query_port", "TEXT DEFAULT '10011'")
SQL_ADD_COLUMN(DATABASE_NAME, "text_social_twitch", "TEXT DEFAULT ' '")
SQL_ADD_COLUMN(DATABASE_NAME, "text_social_twitter", "TEXT DEFAULT ' '")
SQL_ADD_COLUMN(DATABASE_NAME, "text_social_facebook", "TEXT DEFAULT ' '")
SQL_ADD_COLUMN(DATABASE_NAME, "text_social_youtube", "TEXT DEFAULT ' '")
SQL_ADD_COLUMN(DATABASE_NAME, "text_social_steamgroup", "TEXT DEFAULT ' '")

--[[ OLD ]]--
SQL_ADD_COLUMN(DATABASE_NAME, "access_jail", "TEXT DEFAULT -1")



local HANDLER_GENERAL = {}

function RemFromHandler_General(ply)
	table.RemoveByValue(HANDLER_GENERAL, ply)
	printGM("gm", ply:YRPName() .. " disconnected from General")
end

function AddToHandler_General(ply)
	if !table.HasValue(HANDLER_GENERAL, ply) then
		table.insert(HANDLER_GENERAL, ply)
		printGM("gm", ply:YRPName() .. " connected to General")
	else
		printGM("gm", ply:YRPName() .. " already connected to General")
	end
end

util.AddNetworkString("Connect_Settings_General")
net.Receive("Connect_Settings_General", function(len, ply)
	if ply:CanAccess("bool_general") then
		AddToHandler_General(ply)

		local _yrp_general = SQL_SELECT(DATABASE_NAME, "*", nil)
		if wk(_yrp_general) then
			_yrp_general = _yrp_general[1]
		else
			_yrp_general = {}
		end
		net.Start("Connect_Settings_General")
			net.WriteTable(_yrp_general)
		net.Send(ply)
	end
end)

util.AddNetworkString("Disconnect_Settings_General")
net.Receive("Disconnect_Settings_General", function(len, ply)
	RemFromHandler_General(ply)
end)



local yrp_general = {}

if SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '1'") == nil then
	SQL_INSERT_INTO_DEFAULTVALUES(DATABASE_NAME)
end

local _init_general = SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '1'")
if wk(_init_general) then
	yrp_general = _init_general[1]

	RunConsoleCommand("lua_log_sv", yrp_general.bool_server_debug)
	RunConsoleCommand("lua_log_cl", yrp_general.bool_server_debug)

	for name, value in pairs(yrp_general) do
		if string.StartWith(name, "bool_") then
			SetGlobalDBool(name, tobool(value))
		elseif string.StartWith(name, "text_") then
			SetGlobalDString(name, tostring(value))
		elseif string.StartWith(name, "int_") then
			SetGlobalDInt(name, tonumber(value))
		end
	end

	SetGlobalDBool("yrp_general_loaded", true)
end



--[[ GETTER ]]--
function YRPDebug()
	return tobool(yrp_general.bool_server_debug)
end

function YRPErrorMod()
	return 10
end

function YRPIsAutomaticServerReloadingEnabled()
	return tobool(yrp_general.bool_server_reload)
end


function IsNoClipEffectEnabled()
	return tobool(yrp_general.bool_noclip_effect)
end

function IsNoClipStealthEnabled()
	return tobool(yrp_general.bool_noclip_stealth)
end

function IsNoClipTagsEnabled()
	return tobool(yrp_general.bool_noclip_tags)
end

function IsNoClipModelEnabled()
	return tobool(yrp_general.bool_noclip_model)
end


function YRPCollectionID()
	yrp_general.text_server_collectionid = yrp_general.text_server_collectionid or 0
	return tonumber(yrp_general.text_server_collectionid)
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
	return tobool(yrp_general.bool_drop_items_on_death)
end

function IsDealerImmortal()
	return !tobool(yrp_general.bool_dealers_can_take_damage)
end

function IsRealisticEnabled()
	return tobool(yrp_general.bool_realistic)
end

function PlayersCanDropWeapons()
	return tobool(yrp_general.bool_players_can_drop_weapons)
end

function IsSuicideDisabled()
	return tobool(yrp_general.bool_suicide_disabled)
end

function IsDropMoneyOnDeathEnabled()
	return tobool(yrp_general.bool_drop_money_on_death)
end



function IsVoiceEnabled()
	return tobool(yrp_general.bool_voice)
end

function Is3DVoiceEnabled()
	return tobool(yrp_general.bool_voice_3d)
end

function IsVoiceChannelsEnabled()
	return tobool(yrp_general.bool_voice_channels)
end

function IsLocalGroupVoiceChatEnabled()
	return tobool(yrp_general.bool_voice_group_local)
end

function GetVoiceChatLocalRange()
	return tonumber(yrp_general.int_voice_local_range)
end

function GetMaxVoiceRange()
	return tonumber(yrp_general.int_voice_max_range)
end

function GetMaxAmountOfDroppedMoney()
	return tonumber(yrp_general.text_money_max_amount_of_dropped_money)
end



--[[ Setter ]]--
function SetYRPCollectionID(cid)
	cid = cid or 0
	cid = tonumber(cid)
	if cid > 0 then
		printGM("db", "SetYRPCollectionID(" .. cid .. ")")
		yrp_general.text_server_collectionid = cid
		SQL_UPDATE(DATABASE_NAME, "text_server_collectionid = '" .. cid .. "'", "uniqueID = '1'")

		IsServerInfoOutdated()
	end
end

--[[ LOADOUT ]]--
local Player = FindMetaTable("Player")
function Player:GeneralLoadout()
	--printGM("gm", "[GeneralLoadout] " .. self:YRPName())
	for i, set in pairs(yrp_general) do
		if string.StartWith(i, "text_") then
			SetGlobalDString(i, set)
		elseif string.StartWith(i, "bool_") then
			SetGlobalDBool(i, tobool(set))
		elseif string.StartWith(i, "int_") then
			SetGlobalDInt(i, tonumber(set))
		end
	end
end



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
	SQL_UPDATE(DATABASE_NAME, str .. " = '" .. yrp_general[str] .. "'", "uniqueID = '1'")
	GeneralSendToOther(ply, netstr, yrp_general[str])
end

function GeneralUpdateBool(ply, netstr, str, value)
	printGM("db", ply:YRPName() .. " updated " .. str .. " to: " .. tostring(tobool(value)))
	GeneralUpdateValue(ply, netstr, str, value)
	SetGlobalDBool(str, tobool(value))
end

function GeneralUpdateString(ply, netstr, str, value)
	printGM("db", ply:YRPName() .. " updated " .. str .. " to: " .. tostring(value))
	GeneralUpdateValue(ply, netstr, SQL_STR_IN(str), value)
	SetGlobalDString(str, SQL_STR_OUT(value))
end

function GeneralUpdateInt(ply, netstr, str, value)
	printGM("db", ply:YRPName() .. " updated " .. str .. " to: " .. tostring(value))
	GeneralUpdateValue(ply, netstr, str, value)
	SetGlobalDInt(str, value)
end

function GeneralUpdateGlobalValue(ply, netstr, str, value)
	yrp_general[str] = value
	SQL_UPDATE(DATABASE_NAME, str .. " = '" .. yrp_general[str] .. "'", "uniqueID = '1'")
	GeneralSendToOther(ply, netstr, yrp_general[str])
end

function GeneralUpdateGlobalBool(ply, netstr, str, value)
	printGM("db", ply:YRPName() .. " updated global " .. str .. " to: " .. tostring(tobool(value)))
	GeneralUpdateGlobalValue(ply, netstr, str, value)
	SetGlobalDBool(str, tobool(value))
end



--[[ SERVER SETTINGS ]]--
util.AddNetworkString("update_bool_server_reload")
net.Receive("update_bool_server_reload", function(len, ply)
	local b = btn(net.ReadBool())
	GeneralUpdateBool(ply, "update_bool_server_reload", "bool_server_reload", b)
end)

util.AddNetworkString("update_bool_noclip_effect")
net.Receive("update_bool_noclip_effect", function(len, ply)
	local b = btn(net.ReadBool())
	GeneralUpdateBool(ply, "update_bool_noclip_effect", "bool_noclip_effect", b)
end)

util.AddNetworkString("update_bool_noclip_model")
net.Receive("update_bool_noclip_model", function(len, ply)
	local b = btn(net.ReadBool())
	GeneralUpdateBool(ply, "update_bool_noclip_model", "bool_noclip_model", b)
end)

util.AddNetworkString("update_text_noclip_mdl")
net.Receive("update_text_noclip_mdl", function(len, ply)
	local str = net.ReadString()
	GeneralUpdateString(ply, "update_text_noclip_mdl", "text_noclip_mdl", str)
end)

util.AddNetworkString("update_bool_noclip_tags")
net.Receive("update_bool_noclip_tags", function(len, ply)
	local b = btn(net.ReadBool())
	GeneralUpdateBool(ply, "update_bool_noclip_tags", "bool_noclip_tags", b)
end)

util.AddNetworkString("update_bool_noclip_stealth")
net.Receive("update_bool_noclip_stealth", function(len, ply)
	local b = btn(net.ReadBool())
	GeneralUpdateBool(ply, "update_bool_noclip_stealth", "bool_noclip_stealth", b)
end)


util.AddNetworkString("update_text_server_collectionid")
net.Receive("update_text_server_collectionid", function(len, ply)
	local str = net.ReadString()
	GeneralUpdateString(ply, "update_text_server_collectionid", "text_server_collectionid", str)
end)


util.AddNetworkString("update_text_server_logo")
net.Receive("update_text_server_logo", function(len, ply)
	local str = net.ReadString()
	GeneralUpdateString(ply, "update_text_server_logo", "text_server_logo", str)
end)

util.AddNetworkString("update_text_server_name")
net.Receive("update_text_server_name", function(len, ply)
	local str = net.ReadString()
	GeneralUpdateString(ply, "update_text_server_name", "text_server_name", str)
end)



util.AddNetworkString("update_text_server_rules")
net.Receive("update_text_server_rules", function(len, ply)
	local str = SQL_STR_IN(net.ReadString())
	GeneralUpdateString(ply, "update_text_server_rules", "text_server_rules", str)
end)

util.AddNetworkString("update_text_server_welcome_message")
net.Receive("update_text_server_welcome_message", function(len, ply)
	local str = net.ReadString()
	GeneralUpdateString(ply, "update_text_server_welcome_message", "text_server_welcome_message", str)
end)


util.AddNetworkString("update_text_server_message_of_the_day")
net.Receive("update_text_server_message_of_the_day", function(len, ply)
	local str = net.ReadString()
	GeneralUpdateString(ply, "update_text_server_message_of_the_day", "text_server_message_of_the_day", str)
end)

util.AddNetworkString("update_bool_server_debug")
net.Receive("update_bool_server_debug", function(len, ply)
	local b = btn(net.ReadBool())
	GeneralUpdateBool(ply, "update_bool_server_debug", "bool_server_debug", b)
	RunConsoleCommand("lua_log_sv", b)
	RunConsoleCommand("lua_log_cl", b)
end)

util.AddNetworkString("update_bool_server_debug_voice")
net.Receive("update_bool_server_debug_voice", function(len, ply)
	local b = btn(net.ReadBool())
	GeneralUpdateBool(ply, "update_bool_server_debug_voice", "bool_server_debug_voice", b)
end)

util.AddNetworkString("update_int_server_debug_tick")
net.Receive("update_int_server_debug_tick", function(len, ply)
	local int = net.ReadString()
	if isnumber(tonumber(int)) then
		GeneralUpdateInt(ply, "update_int_server_debug_tick", "int_server_debug_tick", int)
	end
end)

util.AddNetworkString("update_bool_msg_channel_gm")
net.Receive("update_bool_msg_channel_gm", function(len, ply)
	local b = btn(net.ReadBool())
	GeneralUpdateGlobalBool(ply, "update_bool_msg_channel_gm", "bool_msg_channel_gm", b)
end)

util.AddNetworkString("update_bool_msg_channel_db")
net.Receive("update_bool_msg_channel_db", function(len, ply)
	local b = btn(net.ReadBool())
	GeneralUpdateGlobalBool(ply, "update_bool_msg_channel_db", "bool_msg_channel_db", b)
end)

util.AddNetworkString("update_bool_msg_channel_lang")
net.Receive("update_bool_msg_channel_lang", function(len, ply)
	local b = btn(net.ReadBool())
	GeneralUpdateGlobalBool(ply, "update_bool_msg_channel_lang", "bool_msg_channel_lang", b)
end)

util.AddNetworkString("update_bool_msg_channel_noti")
net.Receive("update_bool_msg_channel_noti", function(len, ply)
	local b = btn(net.ReadBool())
	GeneralUpdateGlobalBool(ply, "update_bool_msg_channel_noti", "bool_msg_channel_noti", b)
end)

util.AddNetworkString("update_bool_msg_channel_darkrp")
net.Receive("update_bool_msg_channel_darkrp", function(len, ply)
	local b = btn(net.ReadBool())
	GeneralUpdateGlobalBool(ply, "update_bool_msg_channel_darkrp", "bool_msg_channel_darkrp", b)
end)

util.AddNetworkString("update_bool_msg_channel_chat")
net.Receive("update_bool_msg_channel_chat", function(len, ply)
	local b = btn(net.ReadBool())
	GeneralUpdateGlobalBool(ply, "update_bool_msg_channel_chat", "bool_msg_channel_chat", b)
end)

util.AddNetworkString("update_bool_msg_channel_debug")
net.Receive("update_bool_msg_channel_debug", function(len, ply)
	local b = btn(net.ReadBool())
	GeneralUpdateGlobalBool(ply, "update_bool_msg_channel_debug", "bool_msg_channel_debug", b)
end)



--[[ GAMEMODE SETTINGS ]]--
util.AddNetworkString("update_text_gamemode_name")
net.Receive("update_text_gamemode_name", function(len, ply)
	local str = net.ReadString()
	GeneralUpdateString(ply, "update_text_gamemode_name", "text_gamemode_name", str)
	GAMEMODE.BaseName = str
end)

util.AddNetworkString("update_bool_graffiti_disabled")
net.Receive("update_bool_graffiti_disabled", function(len, ply)
	local b = btn(net.ReadBool())
	GeneralUpdateBool(ply, "update_bool_graffiti_disabled", "bool_graffiti_disabled", b)
end)

util.AddNetworkString("update_bool_anti_bhop")
net.Receive("update_bool_anti_bhop", function(len, ply)
	local b = btn(net.ReadBool())
	GeneralUpdateBool(ply, "update_bool_anti_bhop", "bool_anti_bhop", b)
end)

util.AddNetworkString("update_bool_suicide_disabled")
net.Receive("update_bool_suicide_disabled", function(len, ply)
	local b = btn(net.ReadBool())
	GeneralUpdateBool(ply, "update_bool_suicide_disabled", "bool_suicide_disabled", b)
end)


util.AddNetworkString("update_bool_drop_items_on_death")
net.Receive("update_bool_drop_items_on_death", function(len, ply)
	local b = btn(net.ReadBool())
	GeneralUpdateBool(ply, "update_bool_drop_items_on_death", "bool_drop_items_on_death", b)
end)

util.AddNetworkString("update_bool_players_need_to_introduce")
net.Receive("update_bool_players_need_to_introduce", function(len, ply)
	local b = btn(net.ReadBool())
	GeneralUpdateBool(ply, "update_bool_players_need_to_introduce", "bool_players_need_to_introduce", b)
end)

util.AddNetworkString("update_bool_players_can_drop_weapons")
net.Receive("update_bool_players_can_drop_weapons", function(len, ply)
	local b = btn(net.ReadBool())
	GeneralUpdateBool(ply, "update_bool_players_can_drop_weapons", "bool_players_can_drop_weapons", b)
end)


util.AddNetworkString("update_bool_dealers_can_take_damage")
net.Receive("update_bool_dealers_can_take_damage", function(len, ply)
	local b = btn(net.ReadBool())
	GeneralUpdateBool(ply, "update_bool_dealers_can_take_damage", "bool_dealers_can_take_damage", b)
end)



util.AddNetworkString("update_bool_thirdperson")
net.Receive("update_bool_thirdperson", function(len, ply)
	local b = btn(net.ReadBool())
	GeneralUpdateBool(ply, "update_bool_thirdperson", "bool_thirdperson", b)
end)

util.AddNetworkString("update_text_view_distance")
net.Receive("update_text_view_distance", function(len, ply)
	local str = net.ReadString()
	GeneralUpdateString(ply, "update_text_view_distance", "text_view_distance", str)
end)


util.AddNetworkString("update_text_chat_advert")
net.Receive("update_text_chat_advert", function(len, ply)
	local str = net.ReadString()
	GeneralUpdateString(ply, "update_text_chat_advert", "text_chat_advert", str)
end)

util.AddNetworkString("update_bool_removebuildingowner")
net.Receive("update_bool_removebuildingowner", function(len, ply)
	local b = btn(net.ReadBool())
	GeneralUpdateBool(ply, "update_bool_removebuildingowner", "bool_removebuildingowner", b)
end)

util.AddNetworkString("update_text_removebuildingownertime")
net.Receive("update_text_removebuildingownertime", function(len, ply)
	local str = net.ReadString()
	GeneralUpdateString(ply, "update_text_removebuildingownertime", "text_removebuildingownertime", str)
end)

--[[ GAMEMODE SYSTEMS ]]--
util.AddNetworkString("update_bool_hunger")
net.Receive("update_bool_hunger", function(len, ply)
	local b = btn(net.ReadBool())
	GeneralUpdateBool(ply, "update_bool_hunger", "bool_hunger", b)
end)

util.AddNetworkString("update_bool_hunger_health_regeneration")
net.Receive("update_bool_hunger_health_regeneration", function(len, ply)
	local b = btn(net.ReadBool())
	GeneralUpdateBool(ply, "update_bool_hunger_health_regeneration", "bool_hunger_health_regeneration", b)
end)

util.AddNetworkString("update_text_hunger_health_regeneration_tickrate")
net.Receive("update_text_hunger_health_regeneration_tickrate", function(len, ply)
	local str = net.ReadString()
	GeneralUpdateString(ply, "update_text_hunger_health_regeneration_tickrate", "text_hunger_health_regeneration_tickrate", str)
end)

util.AddNetworkString("update_bool_thirst")
net.Receive("update_bool_thirst", function(len, ply)
	local b = btn(net.ReadBool())
	GeneralUpdateBool(ply, "update_bool_thirst", "bool_thirst", b)
end)

util.AddNetworkString("update_bool_stamina")
net.Receive("update_bool_stamina", function(len, ply)
	local b = btn(net.ReadBool())
	GeneralUpdateBool(ply, "update_bool_stamina", "bool_stamina", b)
end)


util.AddNetworkString("update_bool_map_system")
net.Receive("update_bool_map_system", function(len, ply)
	local b = btn(net.ReadBool())
	GeneralUpdateBool(ply, "update_bool_map_system", "bool_map_system", b)
end)

util.AddNetworkString("update_bool_building_system")
net.Receive("update_bool_building_system", function(len, ply)
	local b = btn(net.ReadBool())
	GeneralUpdateBool(ply, "update_bool_building_system", "bool_building_system", b)
end)

util.AddNetworkString("update_bool_inventory_system")
net.Receive("update_bool_inventory_system", function(len, ply)
	local b = btn(net.ReadBool())
	GeneralUpdateBool(ply, "update_bool_inventory_system", "bool_inventory_system", b)
end)

util.AddNetworkString("update_bool_realistic_system")
net.Receive("update_bool_realistic_system", function(len, ply)
	local b = btn(net.ReadBool())
	GeneralUpdateBool(ply, "update_bool_realistic_system", "bool_realistic_system", b)
end)

util.AddNetworkString("update_bool_level_system")
net.Receive("update_bool_level_system", function(len, ply)
	local b = btn(net.ReadBool())
	GeneralUpdateBool(ply, "update_bool_level_system", "bool_level_system", b)
end)



util.AddNetworkString("update_bool_identity_card")
net.Receive("update_bool_identity_card", function(len, ply)
	local b = btn(net.ReadBool())
	GeneralUpdateBool(ply, "update_bool_identity_card", "bool_identity_card", b)
end)

util.AddNetworkString("update_bool_appearance_system")
net.Receive("update_bool_appearance_system", function(len, ply)
	local b = btn(net.ReadBool())
	GeneralUpdateBool(ply, "update_bool_appearance_system", "bool_appearance_system", b)
end)

util.AddNetworkString("update_bool_smartphone_system")
net.Receive("update_bool_smartphone_system", function(len, ply)
	local b = btn(net.ReadBool())
	GeneralUpdateBool(ply, "update_bool_smartphone_system", "bool_smartphone_system", b)
end)



util.AddNetworkString("update_bool_players_can_switch_role")
net.Receive("update_bool_players_can_switch_role", function(len, ply)
	local b = btn(net.ReadBool())
	GeneralUpdateBool(ply, "update_bool_players_can_switch_role", "bool_players_can_switch_role", b)
end)

util.AddNetworkString("update_bool_players_die_on_role_switch")
net.Receive("update_bool_players_die_on_role_switch", function(len, ply)
	local b = btn(net.ReadBool())
	GeneralUpdateBool(ply, "update_bool_players_die_on_role_switch", "bool_players_die_on_role_switch", b)
end)



util.AddNetworkString("update_bool_wanted_system")
net.Receive("update_bool_wanted_system", function(len, ply)
	local b = btn(net.ReadBool())
	GeneralUpdateBool(ply, "update_bool_wanted_system", "bool_wanted_system", b)
end)



util.AddNetworkString("update_bool_voice")
net.Receive("update_bool_voice", function(len, ply)
	local b = btn(net.ReadBool())
	GeneralUpdateBool(ply, "update_bool_voice", "bool_voice", b)
end)

util.AddNetworkString("update_bool_voice_3d")
net.Receive("update_bool_voice_3d", function(len, ply)
	local b = btn(net.ReadBool())
	GeneralUpdateBool(ply, "update_bool_voice_3d", "bool_voice_3d", b)
end)

util.AddNetworkString("update_bool_voice_channels")
net.Receive("update_bool_voice_channels", function(len, ply)
	local b = btn(net.ReadBool())
	GeneralUpdateBool(ply, "update_bool_voice_channels", "bool_voice_channels", b)
end)

util.AddNetworkString("update_bool_voice_group_local")
net.Receive("update_bool_voice_group_local", function(len, ply)
	local b = btn(net.ReadBool())
	GeneralUpdateBool(ply, "update_bool_voice_group_local", "bool_voice_group_local", b)
end)

util.AddNetworkString("update_int_voice_local_range")
net.Receive("update_int_voice_local_range", function(len, ply)
	local int = net.ReadString()
	if isnumber(tonumber(int)) then
		GeneralUpdateInt(ply, "update_int_voice_local_range", "int_voice_local_range", int)
	end
end)

util.AddNetworkString("update_int_voice_max_range")
net.Receive("update_int_voice_max_range", function(len, ply)
	local int = net.ReadString()
	if isnumber(tonumber(int)) then
		GeneralUpdateInt(ply, "update_int_voice_max_range", "int_voice_max_range", int)
	end
end)



--[[ GAMEMODE VISUALS ]]--
util.AddNetworkString("update_bool_yrp_combined_menu")
net.Receive("update_bool_yrp_combined_menu", function(len, ply)
	local b = btn(net.ReadBool())
	GeneralUpdateBool(ply, "update_bool_yrp_combined_menu", "bool_yrp_combined_menu", b)
end)

util.AddNetworkString("update_text_character_background")
net.Receive("update_text_character_background", function(len, ply)
	local str = net.ReadString()
	GeneralUpdateString(ply, "update_text_character_background", "text_character_background", str)
end)

util.AddNetworkString("update_bool_yrp_chat")
net.Receive("update_bool_yrp_chat", function(len, ply)
	local b = btn(net.ReadBool())
	GeneralUpdateBool(ply, "update_bool_yrp_chat", "bool_yrp_chat", b)
end)

util.AddNetworkString("update_bool_yrp_chat_show_rolename")
net.Receive("update_bool_yrp_chat_show_rolename", function(len, ply)
	local b = btn(net.ReadBool())
	GeneralUpdateBool(ply, "update_bool_yrp_chat_show_rolename", "bool_yrp_chat_show_rolename", b)
end)

util.AddNetworkString("update_bool_yrp_chat_show_factionname")
net.Receive("update_bool_yrp_chat_show_factionname", function(len, ply)
	local b = btn(net.ReadBool())
	GeneralUpdateBool(ply, "update_bool_yrp_chat_show_factionname", "bool_yrp_chat_show_factionname", b)
end)

util.AddNetworkString("update_bool_yrp_chat_show_groupname")
net.Receive("update_bool_yrp_chat_show_groupname", function(len, ply)
	local b = btn(net.ReadBool())
	GeneralUpdateBool(ply, "update_bool_yrp_chat_show_groupname", "bool_yrp_chat_show_groupname", b)
end)

util.AddNetworkString("update_bool_yrp_chat_show_usergroup")
net.Receive("update_bool_yrp_chat_show_usergroup", function(len, ply)
	local b = btn(net.ReadBool())
	GeneralUpdateBool(ply, "update_bool_yrp_chat_show_usergroup", "bool_yrp_chat_show_usergroup", b)
end)

util.AddNetworkString("update_bool_yrp_chat_show_idcardid")
net.Receive("update_bool_yrp_chat_show_idcardid", function(len, ply)
	local b = btn(net.ReadBool())
	GeneralUpdateBool(ply, "update_bool_yrp_chat_show_idcardid", "bool_yrp_chat_show_idcardid", b)
end)



util.AddNetworkString("update_bool_yrp_crosshair")
net.Receive("update_bool_yrp_crosshair", function(len, ply)
	local b = btn(net.ReadBool())
	GeneralUpdateBool(ply, "update_bool_yrp_crosshair", "bool_yrp_crosshair", b)
end)


util.AddNetworkString("update_bool_yrp_hud")
net.Receive("update_bool_yrp_hud", function(len, ply)
	local b = btn(net.ReadBool())
	GeneralUpdateBool(ply, "update_bool_yrp_hud", "bool_yrp_hud", b)
end)


util.AddNetworkString("update_bool_yrp_scoreboard")
net.Receive("update_bool_yrp_scoreboard", function(len, ply)
	local b = btn(net.ReadBool())
	GeneralUpdateBool(ply, "update_bool_yrp_scoreboard", "bool_yrp_scoreboard", b)
end)

util.AddNetworkString("update_text_yrp_scoreboard_style")
net.Receive("update_text_yrp_scoreboard_style", function(len, ply)
	local str = net.ReadString()
	GeneralUpdateString(ply, "update_text_yrp_scoreboard_style", "text_yrp_scoreboard_style", str)
end)

util.AddNetworkString("update_bool_yrp_scoreboard_show_level")
net.Receive("update_bool_yrp_scoreboard_show_level", function(len, ply)
	local b = btn(net.ReadBool())
	GeneralUpdateBool(ply, "update_bool_yrp_scoreboard_show_level", "bool_yrp_scoreboard_show_level", b)
end)

util.AddNetworkString("update_bool_yrp_scoreboard_show_usergroup")
net.Receive("update_bool_yrp_scoreboard_show_usergroup", function(len, ply)
	local b = btn(net.ReadBool())
	GeneralUpdateBool(ply, "update_bool_yrp_scoreboard_show_usergroup", "bool_yrp_scoreboard_show_usergroup", b)
end)

util.AddNetworkString("update_bool_yrp_scoreboard_show_rolename")
net.Receive("update_bool_yrp_scoreboard_show_rolename", function(len, ply)
	local b = btn(net.ReadBool())
	GeneralUpdateBool(ply, "update_bool_yrp_scoreboard_show_rolename", "bool_yrp_scoreboard_show_rolename", b)
end)

util.AddNetworkString("update_bool_yrp_scoreboard_show_groupname")
net.Receive("update_bool_yrp_scoreboard_show_groupname", function(len, ply)
	local b = btn(net.ReadBool())
	GeneralUpdateBool(ply, "update_bool_yrp_scoreboard_show_groupname", "bool_yrp_scoreboard_show_groupname", b)
end)

util.AddNetworkString("update_bool_yrp_scoreboard_show_language")
net.Receive("update_bool_yrp_scoreboard_show_language", function(len, ply)
	local b = btn(net.ReadBool())
	GeneralUpdateBool(ply, "update_bool_yrp_scoreboard_show_language", "bool_yrp_scoreboard_show_language", b)
end)

util.AddNetworkString("update_bool_yrp_scoreboard_show_country")
net.Receive("update_bool_yrp_scoreboard_show_country", function(len, ply)
	local b = btn(net.ReadBool())
	GeneralUpdateBool(ply, "update_bool_yrp_scoreboard_show_country", "bool_yrp_scoreboard_show_country", b)
end)

util.AddNetworkString("update_bool_yrp_scoreboard_show_playtime")
net.Receive("update_bool_yrp_scoreboard_show_playtime", function(len, ply)
	local b = btn(net.ReadBool())
	GeneralUpdateBool(ply, "update_bool_yrp_scoreboard_show_playtime", "bool_yrp_scoreboard_show_playtime", b)
end)

util.AddNetworkString("update_bool_yrp_scoreboard_show_frags")
net.Receive("update_bool_yrp_scoreboard_show_frags", function(len, ply)
	local b = btn(net.ReadBool())
	GeneralUpdateBool(ply, "update_bool_yrp_scoreboard_show_frags", "bool_yrp_scoreboard_show_frags", b)
end)

util.AddNetworkString("update_bool_yrp_scoreboard_show_deaths")
net.Receive("update_bool_yrp_scoreboard_show_deaths", function(len, ply)
	local b = btn(net.ReadBool())
	GeneralUpdateBool(ply, "update_bool_yrp_scoreboard_show_deaths", "bool_yrp_scoreboard_show_deaths", b)
end)

util.AddNetworkString("update_bool_yrp_scoreboard_show_operating_system")
net.Receive("update_bool_yrp_scoreboard_show_operating_system", function(len, ply)
	local b = btn(net.ReadBool())
	GeneralUpdateBool(ply, "update_bool_yrp_scoreboard_show_operating_system", "bool_yrp_scoreboard_show_operating_system", b)
end)

util.AddNetworkString("update_bool_yrp_scoreboard_show_idcardid")
net.Receive("update_bool_yrp_scoreboard_show_idcardid", function(len, ply)
	local b = btn(net.ReadBool())
	GeneralUpdateBool(ply, "update_bool_yrp_scoreboard_show_idcardid", "bool_yrp_scoreboard_show_idcardid", b)
end)



util.AddNetworkString("update_bool_tag_on_head")
net.Receive("update_bool_tag_on_head", function(len, ply)
	local b = btn(net.ReadBool())
	GeneralUpdateBool(ply, "update_bool_tag_on_head", "bool_tag_on_head", b)
end)

util.AddNetworkString("update_bool_tag_on_head_name")
net.Receive("update_bool_tag_on_head_name", function(len, ply)
	local b = btn(net.ReadBool())
	GeneralUpdateBool(ply, "update_bool_tag_on_head_name", "bool_tag_on_head_name", b)
end)

util.AddNetworkString("update_bool_tag_on_head_clan")
net.Receive("update_bool_tag_on_head_clan", function(len, ply)
	local b = btn(net.ReadBool())
	GeneralUpdateBool(ply, "update_bool_tag_on_head_clan", "bool_tag_on_head_clan", b)
end)

util.AddNetworkString("update_bool_tag_on_head_level")
net.Receive("update_bool_tag_on_head_level", function(len, ply)
	local b = btn(net.ReadBool())
	GeneralUpdateBool(ply, "update_bool_tag_on_head_level", "bool_tag_on_head_level", b)
end)

util.AddNetworkString("update_bool_tag_on_head_rolename")
net.Receive("update_bool_tag_on_head_rolename", function(len, ply)
	local b = btn(net.ReadBool())
	GeneralUpdateBool(ply, "update_bool_tag_on_head_rolename", "bool_tag_on_head_rolename", b)
end)

util.AddNetworkString("update_bool_tag_on_head_factionname")
net.Receive("update_bool_tag_on_head_factionname", function(len, ply)
	local b = btn(net.ReadBool())
	GeneralUpdateBool(ply, "update_bool_tag_on_head_factionname", "bool_tag_on_head_factionname", b)
end)

util.AddNetworkString("update_bool_tag_on_head_groupname")
net.Receive("update_bool_tag_on_head_groupname", function(len, ply)
	local b = btn(net.ReadBool())
	GeneralUpdateBool(ply, "update_bool_tag_on_head_groupname", "bool_tag_on_head_groupname", b)
end)

util.AddNetworkString("update_bool_tag_on_head_health")
net.Receive("update_bool_tag_on_head_health", function(len, ply)
	local b = btn(net.ReadBool())
	GeneralUpdateBool(ply, "update_bool_tag_on_head_health", "bool_tag_on_head_health", b)
end)

util.AddNetworkString("update_bool_tag_on_head_armor")
net.Receive("update_bool_tag_on_head_armor", function(len, ply)
	local b = btn(net.ReadBool())
	GeneralUpdateBool(ply, "update_bool_tag_on_head_armor", "bool_tag_on_head_armor", b)
end)

util.AddNetworkString("update_bool_tag_on_head_usergroup")
net.Receive("update_bool_tag_on_head_usergroup", function(len, ply)
	local b = btn(net.ReadBool())
	GeneralUpdateBool(ply, "update_bool_tag_on_head_usergroup", "bool_tag_on_head_usergroup", b)
end)

util.AddNetworkString("update_bool_tag_on_head_voice")
net.Receive("update_bool_tag_on_head_voice", function(len, ply)
	local b = btn(net.ReadBool())
	GeneralUpdateBool(ply, "update_bool_tag_on_head_voice", "bool_tag_on_head_voice", b)
end)

util.AddNetworkString("update_bool_tag_on_head_chat")
net.Receive("update_bool_tag_on_head_chat", function(len, ply)
	local b = btn(net.ReadBool())
	GeneralUpdateBool(ply, "update_bool_tag_on_head_chat", "bool_tag_on_head_chat", b)
end)


util.AddNetworkString("update_bool_tag_on_side")
net.Receive("update_bool_tag_on_side", function(len, ply)
	local b = btn(net.ReadBool())
	GeneralUpdateBool(ply, "update_bool_tag_on_side", "bool_tag_on_side", b)
end)

util.AddNetworkString("update_bool_tag_on_side_name")
net.Receive("update_bool_tag_on_side_name", function(len, ply)
	local b = btn(net.ReadBool())
	GeneralUpdateBool(ply, "update_bool_tag_on_side_name", "bool_tag_on_side_name", b)
end)

util.AddNetworkString("update_bool_tag_on_side_clan")
net.Receive("update_bool_tag_on_side_clan", function(len, ply)
	local b = btn(net.ReadBool())
	GeneralUpdateBool(ply, "update_bool_tag_on_side_clan", "bool_tag_on_side_clan", b)
end)

util.AddNetworkString("update_bool_tag_on_side_level")
net.Receive("update_bool_tag_on_side_level", function(len, ply)
	local b = btn(net.ReadBool())
	GeneralUpdateBool(ply, "update_bool_tag_on_side_level", "bool_tag_on_side_level", b)
end)

util.AddNetworkString("update_bool_tag_on_side_rolename")
net.Receive("update_bool_tag_on_side_rolename", function(len, ply)
	local b = btn(net.ReadBool())
	GeneralUpdateBool(ply, "update_bool_tag_on_side_rolename", "bool_tag_on_side_rolename", b)
end)

util.AddNetworkString("update_bool_tag_on_side_factionname")
net.Receive("update_bool_tag_on_side_factionname", function(len, ply)
	local b = btn(net.ReadBool())
	GeneralUpdateBool(ply, "update_bool_tag_on_side_factionname", "bool_tag_on_side_factionname", b)
end)

util.AddNetworkString("update_bool_tag_on_side_groupname")
net.Receive("update_bool_tag_on_side_groupname", function(len, ply)
	local b = btn(net.ReadBool())
	GeneralUpdateBool(ply, "update_bool_tag_on_side_groupname", "bool_tag_on_side_groupname", b)
end)

util.AddNetworkString("update_bool_tag_on_side_health")
net.Receive("update_bool_tag_on_side_health", function(len, ply)
	local b = btn(net.ReadBool())
	GeneralUpdateBool(ply, "update_bool_tag_on_side_health", "bool_tag_on_side_health", b)
end)

util.AddNetworkString("update_bool_tag_on_side_armor")
net.Receive("update_bool_tag_on_side_armor", function(len, ply)
	local b = btn(net.ReadBool())
	GeneralUpdateBool(ply, "update_bool_tag_on_side_armor", "bool_tag_on_side_armor", b)
end)

util.AddNetworkString("update_bool_tag_on_side_usergroup")
net.Receive("update_bool_tag_on_side_usergroup", function(len, ply)
	local b = btn(net.ReadBool())
	GeneralUpdateBool(ply, "update_bool_tag_on_side_usergroup", "bool_tag_on_side_usergroup", b)
end)



--[[ MONEY SETTINGS ]]--
util.AddNetworkString("update_bool_drop_money_on_death")
net.Receive("update_bool_drop_money_on_death", function(len, ply)
	local b = btn(net.ReadBool())
	GeneralUpdateBool(ply, "update_bool_drop_money_on_death", "bool_drop_money_on_death", b)
end)

util.AddNetworkString("update_text_money_max_amount_of_dropped_money")
net.Receive("update_text_money_max_amount_of_dropped_money", function(len, ply)
	local str = net.ReadString()
	GeneralUpdateString(ply, "update_text_money_max_amount_of_dropped_money", "text_money_max_amount_of_dropped_money", str)
end)


util.AddNetworkString("update_text_money_pre")
net.Receive("update_text_money_pre", function(len, ply)
	local str = net.ReadString()
	GeneralUpdateString(ply, "update_text_money_pre", "text_money_pre", str)
end)

util.AddNetworkString("update_text_money_pos")
net.Receive("update_text_money_pos", function(len, ply)
	local str = net.ReadString()
	GeneralUpdateString(ply, "update_text_money_pos", "text_money_pos", str)
end)

util.AddNetworkString("update_text_money_model")
net.Receive("update_text_money_model", function(len, ply)
	local str = net.ReadString()
	GeneralUpdateString(ply, "update_text_money_model", "text_money_model", str)
end)

util.AddNetworkString("update_bool_money_printer_spawn_money")
net.Receive("update_bool_money_printer_spawn_money", function(len, ply)
	local b = btn(net.ReadBool())
	GeneralUpdateBool(ply, "update_bool_money_printer_spawn_money", "bool_money_printer_spawn_money", b)
end)



--[[ SOCIAL SETTINGS ]]--
util.AddNetworkString("update_text_characters_max")
net.Receive("update_text_characters_max", function(len, ply)
	local str = net.ReadString()
	GeneralUpdateString(ply, "update_text_characters_max", "text_characters_max", str)
end)

util.AddNetworkString("update_text_characters_money_start")
net.Receive("update_text_characters_money_start", function(len, ply)
	local str = net.ReadString()
	GeneralUpdateString(ply, "update_text_characters_money_start", "text_characters_money_start", str)
end)

util.AddNetworkString("update_bool_characters_gender")
net.Receive("update_bool_characters_gender", function(len, ply)
	local b = btn(net.ReadBool())
	GeneralUpdateBool(ply, "update_bool_characters_gender", "bool_characters_gender", b)
end)
util.AddNetworkString("update_bool_characters_othergender")
net.Receive("update_bool_characters_othergender", function(len, ply)
	local b = btn(net.ReadBool())
	GeneralUpdateBool(ply, "update_bool_characters_othergender", "bool_characters_othergender", b)
end)



--[[ SOCIAL SETTINGS ]]--
util.AddNetworkString("update_text_social_website")
net.Receive("update_text_social_website", function(len, ply)
	local str = net.ReadString()
	GeneralUpdateString(ply, "update_text_social_website", "text_social_website", str)
end)

util.AddNetworkString("update_text_social_forum")
net.Receive("update_text_social_forum", function(len, ply)
	local str = net.ReadString()
	GeneralUpdateString(ply, "update_text_social_forum", "text_social_forum", str)
end)

util.AddNetworkString("update_text_social_discord")
net.Receive("update_text_social_discord", function(len, ply)
	local str = net.ReadString()
	GeneralUpdateString(ply, "update_text_social_discord", "text_social_discord", str)
end)

util.AddNetworkString("update_text_social_discord_widgetid")
net.Receive("update_text_social_discord_widgetid", function(len, ply)
	local str = net.ReadString()
	GeneralUpdateString(ply, "update_text_social_discord_widgetid", "text_social_discord_widgetid", str)
end)

util.AddNetworkString("update_text_social_teamspeak_ip")
net.Receive("update_text_social_teamspeak_ip", function(len, ply)
	local str = net.ReadString()
	GeneralUpdateString(ply, "update_text_social_teamspeak_ip", "text_social_teamspeak_ip", str)
end)

util.AddNetworkString("update_text_social_teamspeak_port")
net.Receive("update_text_social_teamspeak_port", function(len, ply)
	local str = net.ReadString()
	GeneralUpdateString(ply, "update_text_social_teamspeak_port", "text_social_teamspeak_port", str)
end)

util.AddNetworkString("update_text_social_teamspeak_query_port")
net.Receive("update_text_social_teamspeak_query_port", function(len, ply)
	local str = net.ReadString()
	GeneralUpdateString(ply, "update_text_social_teamspeak_query_port", "text_social_teamspeak_query_port", str)
end)

util.AddNetworkString("update_text_social_youtube")
net.Receive("update_text_social_youtube", function(len, ply)
	local str = net.ReadString()
	GeneralUpdateString(ply, "update_text_social_youtube", "text_social_youtube", str)
end)

util.AddNetworkString("update_text_social_twitch")
net.Receive("update_text_social_twitch", function(len, ply)
	local str = net.ReadString()
	GeneralUpdateString(ply, "update_text_social_twitch", "text_social_twitch", str)
end)

util.AddNetworkString("update_text_social_twitter")
net.Receive("update_text_social_twitter", function(len, ply)
	local str = net.ReadString()
	GeneralUpdateString(ply, "update_text_social_twitter", "text_social_twitter", str)
end)

util.AddNetworkString("update_text_social_facebook")
net.Receive("update_text_social_facebook", function(len, ply)
	local str = net.ReadString()
	GeneralUpdateString(ply, "update_text_social_facebook", "text_social_facebook", str)
end)

util.AddNetworkString("update_text_social_steamgroup")
net.Receive("update_text_social_steamgroup", function(len, ply)
	local str = net.ReadString()
	GeneralUpdateString(ply, "update_text_social_steamgroup", "text_social_steamgroup", str)
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

util.AddNetworkString("gethelpmenu")
net.Receive("gethelpmenu", function(len, ply)
	local info = SQL_SELECT("yrp_general", "*", "uniqueID = '1'")
	if wk(info) then
		info = info[1]

		local tabs = {}
		local subtabs = {}

		AddTab(tabs, "LID_help", "getsitehelp")
		AddTab(tabs, "LID_staff", "getsitestaff")
		if !strEmpty(info.text_server_rules) then
			AddTab(tabs, "LID_rules", "getsiteserverrules")
		end
		if !strEmpty(info.text_server_collectionid) and tonumber(info.text_server_collectionid) > 0 then
			AddTab(tabs, "LID_collection", "getsitecollection")
		end

		if !strEmpty(info.text_social_website) or
			!strEmpty(info.text_social_forum) or
			!strEmpty(info.text_social_discord) or
			!strEmpty(info.text_social_teamspeak_ip) or
			!strEmpty(info.text_social_twitter) or
			!strEmpty(info.text_social_youtube) or
			!strEmpty(info.text_social_facebook) or
			!strEmpty(info.text_social_steamgroup) then
			--!strEmpty(info.text_social_servers) then
			AddTab(tabs, "LID_community", "")
			if !strEmpty(info.text_social_website) then
				AddSubTab(subtabs, "LID_community", "Website", "getsitecommunitywebsite")
			end
			if !strEmpty(info.text_social_forum) then
				AddSubTab(subtabs, "LID_community", "Forum", "getsitecommunityforum")
			end
			if !strEmpty(info.text_social_discord) then
				AddSubTab(subtabs, "LID_community", "Discord", "getsitecommunitydiscord")
			end
			if !strEmpty(info.text_social_teamspeak_ip) then
				AddSubTab(subtabs, "LID_community", "Teamspeak", "getsitecommunityteamspeak")
			end
			if !strEmpty(info.text_social_twitter) then
				AddSubTab(subtabs, "LID_community", "Twitter", "getsitecommunitytwitter")
			end
			if !strEmpty(info.text_social_youtube) then
				AddSubTab(subtabs, "LID_community", "Youtube", "getsitecommunityyoutube")
			end
			if !strEmpty(info.text_social_facebook) then
				AddSubTab(subtabs, "LID_community", "Facebook", "getsitecommunityfacebook")
			end
			if !strEmpty(info.text_social_steamgroup) then
				AddSubTab(subtabs, "LID_community", "SteamGroup", "getsitecommunitysteamgroup")
			end
			--if info.text_social_servers) then
				--AddSubTab(subtabs, "LID_community", "servers", "getsitecommunityservers")
			--end
		end

		AddTab(tabs, "YourRP - Roadmap", "getsiteyourrproadmap")

		AddTab(tabs, "YourRP", "")
		AddSubTab(subtabs, "YourRP", "News", "getsiteyourrpnews")
		AddSubTab(subtabs, "YourRP", "Whats New", "getsiteyourrpwhatsnew")
		AddSubTab(subtabs, "YourRP", "Discord", "getsiteyourrpdiscord")
		AddSubTab(subtabs, "YourRP", "Translations", "getsiteyourrptranslations", "")
		AddSubTab(subtabs, "YourRP", "Servers", "getsiteyourrpserverlist", "")

		net.Start("gethelpmenu")
			net.WriteTable(tabs)
			net.WriteTable(subtabs)
		net.Send(ply)
	else
		printGM("note", "gamemode broken contact developer!")
	end
end)

util.AddNetworkString("getsitehelp")
net.Receive("getsitehelp", function(len, ply)
	net.Start("getsitehelp")
		net.WriteString(yrp_general.text_server_welcome_message)
		net.WriteString(yrp_general.text_server_message_of_the_day)
	net.Send(ply)
end)

util.AddNetworkString("getsitestaff")
net.Receive("getsitestaff", function(len, ply)
	local staff = {}
	for i, pl in pairs(player.GetAll()) do
		if pl:HasAccess() then
			table.insert(staff, pl)
		end
	end
	net.Start("getsitestaff")
		net.WriteTable(staff)
	net.Send(ply)
end)

util.AddNetworkString("getsiteserverrules")
net.Receive("getsiteserverrules", function(len, ply)
	local server_rules = SQL_SELECT("yrp_general", "text_server_rules", "uniqueID = '1'")
	if wk(server_rules) then
		server_rules = SQL_STR_OUT(server_rules[1].text_server_rules)
	else
		server_rules = ""
	end
	net.Start("getsiteserverrules")
		net.WriteString(server_rules)
	net.Send(ply)
end)

util.AddNetworkString("getsitecollection")
net.Receive("getsitecollection", function(len, ply)
	local collectionid = SQL_SELECT("yrp_general", "text_server_collectionid", "uniqueID = '1'")
	if wk(collectionid) then
		collectionid = collectionid[1].text_server_collectionid
	else
		collectionid = ""
	end
	net.Start("getsitecollection")
		net.WriteString(collectionid)
	net.Send(ply)
end)

util.AddNetworkString("getsitecommunitywebsite")
net.Receive("getsitecommunitywebsite", function(len, ply)
	local link = SQL_SELECT("yrp_general", "text_social_website", "uniqueID = '1'")
	if wk(link) then
		link = link[1].text_social_website
	else
		link = ""
	end
	net.Start("getsitecommunitywebsite")
		net.WriteString(link)
	net.Send(ply)
end)

util.AddNetworkString("getsitecommunityforum")
net.Receive("getsitecommunityforum", function(len, ply)
	local link = SQL_SELECT("yrp_general", "text_social_forum", "uniqueID = '1'")
	if wk(link) then
		link = link[1].text_social_forum
	else
		link = ""
	end
	net.Start("getsitecommunityforum")
		net.WriteString(link)
	net.Send(ply)
end)

util.AddNetworkString("getsitecommunitydiscord")
net.Receive("getsitecommunitydiscord", function(len, ply)
	local sql_select = SQL_SELECT("yrp_general", "text_social_discord, text_social_discord_widgetid", "uniqueID = '1'")
	local link = ""
	local widgetid = ""
	if wk(link) then
		link = sql_select[1].text_social_discord
		widgetid = sql_select[1].text_social_discord_widgetid
	end
	net.Start("getsitecommunitydiscord")
		net.WriteString(link)
		net.WriteString(widgetid)
	net.Send(ply)
end)

util.AddNetworkString("getsitecommunityteamspeak")
net.Receive("getsitecommunityteamspeak", function(len, ply)
	local sql_select = SQL_SELECT("yrp_general", "text_social_teamspeak_ip, text_social_teamspeak_port, text_social_teamspeak_query_port", "uniqueID = '1'")
	local ip = ""
	local port = ""
	local query_port = ""
	if wk(sql_select) then
		ip = sql_select[1].text_social_teamspeak_ip
		port = sql_select[1].text_social_teamspeak_port
		query_port = sql_select[1].text_social_teamspeak_query_port
	end
	net.Start("getsitecommunityteamspeak")
		net.WriteString(ip)
		net.WriteString(port)
		net.WriteString(query_port)
	net.Send(ply)
end)

util.AddNetworkString("getsitecommunitytwitter")
net.Receive("getsitecommunitytwitter", function(len, ply)
	local link = SQL_SELECT("yrp_general", "text_social_twitter", "uniqueID = '1'")
	if wk(link) then
		link = link[1].text_social_twitter
	else
		link = ""
	end
	net.Start("getsitecommunitytwitter")
		net.WriteString(link)
	net.Send(ply)
end)

util.AddNetworkString("getsitecommunityyoutube")
net.Receive("getsitecommunityyoutube", function(len, ply)
	local link = SQL_SELECT("yrp_general", "text_social_youtube", "uniqueID = '1'")
	if wk(link) then
		link = link[1].text_social_youtube
	else
		link = ""
	end
	net.Start("getsitecommunityyoutube")
		net.WriteString(link)
	net.Send(ply)
end)

util.AddNetworkString("getsitecommunityfacebook")
net.Receive("getsitecommunityfacebook", function(len, ply)
	local link = SQL_SELECT("yrp_general", "text_social_facebook", "uniqueID = '1'")
	if wk(link) then
		link = link[1].text_social_facebook
	else
		link = ""
	end
	net.Start("getsitecommunityfacebook")
		net.WriteString(link)
	net.Send(ply)
end)

util.AddNetworkString("getsitecommunitysteamgroup")
net.Receive("getsitecommunitysteamgroup", function(len, ply)
	local link = SQL_SELECT("yrp_general", "text_social_steamgroup", "uniqueID = '1'")
	if wk(link) then
		link = link[1].text_social_steamgroup
	else
		link = ""
	end
	net.Start("getsitecommunitysteamgroup")
		net.WriteString(link)
	net.Send(ply)
end)



util.AddNetworkString("getsiteyourrpwhatsnew")
net.Receive("getsiteyourrpwhatsnew", function(len, ply)
	net.Start("getsiteyourrpwhatsnew")
	net.Send(ply)
end)

util.AddNetworkString("getsiteyourrproadmap")
net.Receive("getsiteyourrproadmap", function(len, ply)
	net.Start("getsiteyourrproadmap")
	net.Send(ply)
end)

util.AddNetworkString("getsiteyourrpnews")
net.Receive("getsiteyourrpnews", function(len, ply)
	net.Start("getsiteyourrpnews")
	net.Send(ply)
end)

util.AddNetworkString("getsiteyourrpdiscord")
net.Receive("getsiteyourrpdiscord", function(len, ply)
	net.Start("getsiteyourrpdiscord")
	net.Send(ply)
end)

util.AddNetworkString("getsiteyourrpserverlist")
net.Receive("getsiteyourrpserverlist", function(len, ply)
	net.Start("getsiteyourrpserverlist")
	net.Send(ply)
end)

util.AddNetworkString("getsiteyourrptranslations")
net.Receive("getsiteyourrptranslations", function(len, ply)
	net.Start("getsiteyourrptranslations")
	net.Send(ply)
end)

--[[ OLD GETTER BELOW ]]--
util.AddNetworkString("db_jailaccess")
net.Receive("db_jailaccess", function(len, ply)
	local _dbTable = net.ReadString()
	local _dbSets = net.ReadString()

	local _result = SQL_UPDATE(_dbTable, _dbSets, "uniqueID = 1")
	if _result != nil then
		printGM("error", "access_jail failed! " .. tostring(_dbTable) .. " | " .. tostring(_dbSets))
	end
end)

util.AddNetworkString("dbUpdate")
net.Receive("dbUpdate", function(len, ply)
	local _dbTable = net.ReadString()
	local _dbSets = net.ReadString()
	local _dbWhile = net.ReadString()
	local _result = SQL_UPDATE(_dbTable, _dbSets, _dbWhile)
	local _usergroup_ = string.Explode(" ", _dbWhile)
	local _restriction_ = string.Explode(" ", SQL_STR_IN(_dbSets))
	printGM("note", "[OLD DBUPDATE] " .. ply:SteamName() .. " SETS " .. _dbSets .. " WHERE " .. _dbWhile)
end)



-- Scoreboard Commands
util.AddNetworkString("ply_kick")
net.Receive("ply_kick", function(len, ply)
	if ply:HasAccess() then
		local _target = net.ReadEntity()
		_target:Kick("You get kicked by " .. ply:YRPName())
	end
end)
util.AddNetworkString("ply_ban")
net.Receive("ply_ban", function(len, ply)
	if ply:HasAccess() then
		local _target = net.ReadEntity()
		if ea(_target) then
			_target:Ban(24 * 60, false)
			_target:Kick("You get banned for 24 hours by " .. ply:YRPName())
		else
			printGM("note", "ply_ban " .. tostring(_target) .. " IS NIL => NOT AVAILABLE")
		end
	end
end)

util.AddNetworkString("tp_tpto")
net.Receive("tp_tpto", function(len, ply)
	if ply:HasAccess() then
		local _target = net.ReadEntity()
		teleportToPoint(ply, _target:GetPos())
	end
end)
util.AddNetworkString("tp_bring")
net.Receive("tp_bring", function(len, ply)
	if ply:HasAccess() then
		local _target = net.ReadEntity()
		teleportToPoint(_target, ply:GetPos())
	end
end)
util.AddNetworkString("tp_jail")
net.Receive("tp_jail", function(len, ply)
	if ply:HasAccess() then
		local _target = net.ReadEntity()
		teleportToJailpoint(_target)
		_target:SetDBool("injail", true)
		_target:SetDInt("jailtime", 5 * 60)
	end
end)
util.AddNetworkString("tp_unjail")
net.Receive("tp_unjail", function(len, ply)
	if ply:HasAccess() then
		local _target = net.ReadEntity()
		teleportToReleasepoint(_target)
		_target:SetDBool("injail", false)
	end
end)

function DoRagdoll(ply)
	ply:SetDBool("ragdolled", true)

	local tmp = ents.Create("prop_ragdoll")
	tmp:SetModel(ply:GetModel())
	tmp:SetModelScale(ply:GetModelScale(), 0)
	tmp:SetPos(ply:GetPos() + Vector(0, 0, 0))
	tmp:Spawn()

	ply:SetParent(tmp)
	ply:SetDEntity("ragdoll", tmp)

	RenderCloaked(ply)
end

function DoUnRagdoll(ply)
	ply:SetDBool("ragdolled", false)
	ply:SetParent(nil)

	local ragdoll = ply:GetDEntity("ragdoll")
	if ea(ragdoll) then
		ply:SetPos(ragdoll:GetPos())
		ragdoll:Remove()
	end

	RenderNormal(ply)
end

util.AddNetworkString("ragdoll")
net.Receive("ragdoll", function(len, ply)
	if ply:HasAccess() then
		local _target = net.ReadEntity()
		DoRagdoll(_target)
	end
end)
util.AddNetworkString("unragdoll")
net.Receive("unragdoll", function(len, ply)
	if ply:HasAccess() then
		local _target = net.ReadEntity()
		DoUnRagdoll(_target)
	end
end)
util.AddNetworkString("freeze")
net.Receive("freeze", function(len, ply)
	if ply:HasAccess() then
		local _target = net.ReadEntity()
		_target:Freeze(true)
		RenderFrozen(_target)
	end
end)
util.AddNetworkString("unfreeze")
net.Receive("unfreeze", function(len, ply)
	if ply:HasAccess() then
		local _target = net.ReadEntity()
		_target:Freeze(false)
		RenderNormal(_target)
	end
end)
util.AddNetworkString("god")
net.Receive("god", function(len, ply)
	if ply:HasAccess() then
		local _target = net.ReadEntity()
		_target:GodEnable()
		_target:AddFlags(FL_GODMODE)
		_target:SetDBool("godmode", true)
	end
end)
util.AddNetworkString("ungod")
net.Receive("ungod", function(len, ply)
	if ply:HasAccess() then
		local _target = net.ReadEntity()
		_target:GodDisable()
		_target:RemoveFlags(FL_GODMODE)
		_target:SetDBool("godmode", false)
	end
end)
util.AddNetworkString("cloak")
net.Receive("cloak", function(len, ply)
	if ply:HasAccess() then
		local _target = net.ReadEntity()
		_target:SetDBool("cloaked", true)
		RenderCloaked(_target)
	end
end)
util.AddNetworkString("uncloak")
net.Receive("uncloak", function(len, ply)
	if ply:HasAccess() then
		local _target = net.ReadEntity()
		_target:SetDBool("cloaked", false)
		RenderNormal(_target)
	end
end)
util.AddNetworkString("blind")
net.Receive("blind", function(len, ply)
	if ply:HasAccess() then
		local _target = net.ReadEntity()
		_target:SetDBool("blinded", true)
	end
end)
util.AddNetworkString("unblind")
net.Receive("unblind", function(len, ply)
	if ply:HasAccess() then
		local _target = net.ReadEntity()
		_target:SetDBool("blinded", false)
	end
end)
util.AddNetworkString("ignite")
net.Receive("ignite", function(len, ply)
	if ply:HasAccess() then
		local _target = net.ReadEntity()
		_target:Ignite(10, 10)
	end
end)
util.AddNetworkString("extinguish")
net.Receive("extinguish", function(len, ply)
	if ply:HasAccess() then
		local _target = net.ReadEntity()
		_target:Extinguish()
	end
end)
util.AddNetworkString("slay")
net.Receive("slay", function(len, ply)
	if ply:HasAccess() then
		local _target = net.ReadEntity()
		_target:Kill()
	end
end)
util.AddNetworkString("slap")
net.Receive("slap", function(len, ply)
	if ply:HasAccess() then
		local _target = net.ReadEntity()
		_target:SetVelocity(Vector(0, 0, 600))
	end
end)

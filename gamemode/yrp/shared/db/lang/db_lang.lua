--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

local yrp_cur_lang = "auto"
local yrp_current_lang = {}
local yrp_default_lang = {}
local yrp_cache_lang = {}
local yrp_button_info = {}
local yrp_shorts = {}
table.insert( yrp_shorts, "en" )
table.insert( yrp_shorts, "de" )
table.insert( yrp_shorts, "bg" )
table.insert( yrp_shorts, "ca" )
table.insert( yrp_shorts, "cs" )
table.insert( yrp_shorts, "es" )
table.insert( yrp_shorts, "fr" )
table.insert( yrp_shorts, "hu" )
table.insert( yrp_shorts, "it" )
table.insert( yrp_shorts, "ko" )
table.insert( yrp_shorts, "lt" )
table.insert( yrp_shorts, "pl" )
table.insert( yrp_shorts, "pt_br" )
table.insert( yrp_shorts, "ro" )
table.insert( yrp_shorts, "ru" )
table.insert( yrp_shorts, "sv" )
table.insert( yrp_shorts, "th" )
table.insert( yrp_shorts, "tr" )
table.insert( yrp_shorts, "ua" )

function GetLanguageAutoInfo()
	local auto = {}
	auto.ineng = "Automatic"
	auto.lang = "Automatic"
	auto.translated_by_name = "D4KiR"
	auto.short = "auto"
	return auto
end

AddCSLuaFile( "read_lang.lua" )

include( "read_lang.lua" )

function set_lang_string( var, str, default, init )
	if default then
		yrp_default_lang[var] = str
	elseif init then
		yrp_cache_lang[var] = str
	else
		yrp_current_lang[var] = str
	end
end

function get_language_name( ls )
	for k, lang in pairs( yrp_button_info ) do
		if lang.short == ls then
			return lang.ineng
		end
	end
	return "FAILED"
end

yrp_current_lang.get_language = "Unknown"
yrp_current_lang.not_found = "not found, using default one."
yrp_current_lang.language = "Unknown"

function search_language()
	yrp_current_lang.get_language = string.lower( GetConVar( "gmod_language" ):GetString() )
end

function replace_string( in_str, tab )
	for i, str in pairs( tab ) do
		in_str = string.Replace( in_str, "[" .. tostring( i ) .. "]", tab[i] )
	end
	return in_str
end

function lang_string( var, failed )
	--[[ string var, string failed ]]--
	--[[ returns translated string, when worked ]]--
	--[[ if failed it uses failed string ]]--
	local _string = yrp_current_lang[var] or yrp_default_lang[var]
	if _string == nil then
		_string = var
		if CLIENT then
			if LocalPlayer():GetNWBool( "yrp_debug", false ) then
				printGM( "note", "lang_string failed! string " .. var .. " not found" )
			end
		end
		return failed or _string
	end
	return _string
end

local auto = {}
auto.short = "auto"
auto.lang = "Automatic"
auto.ineng = "Automatic"

function GetAllLanguages()
	return yrp_button_info
end

function GetCurrentLanguage()
	return yrp_cur_lang
end

function check_languagepack()
	for k, v in pairs( yrp_shorts ) do
		if yrp_current_lang.get_language == v then
			return true
		end
	end
	return false
end

function send_lang( short )
	--[[ send info to server, to let others know what language i chose ]]--
	if CLIENT then
		printGM( "lang", "Send Language to Server: [" .. tostring( short ) .. "]" )
		net.Start( "client_lang" )
			net.WriteString( tostring( short ) )
		net.SendToServer()
	end
end

function read_language( short, init )
	local default = false
	if short == "en" then
		default = true
	end

	if ( !init ) then
		read_lang( "resource/localization/yrp/init/lang_" .. short .. ".properties", default )

		if !default then
			printGM( "lang", "Get Language-Pack [" .. lang_string( "short" ) .. "] " .. lang_string( "language" ) .. "/" .. lang_string( "ineng" ) )
		end

		read_lang( "resource/localization/yrp/_old/lang_" .. "en" .. ".properties", default )

		read_lang( "resource/localization/yrp/general/lang_" .. short .. ".properties", default )
		read_lang( "resource/localization/yrp/settings/lang_" .. short .. ".properties", default )
		read_lang( "resource/localization/yrp/settingsfeedback/lang_" .. short .. ".properties", default )
		read_lang( "resource/localization/yrp/settingsgeneral/lang_" .. short .. ".properties", default )
		read_lang( "resource/localization/yrp/settingsusergroups/lang_" .. short .. ".properties", default )
	else
		read_lang( "resource/localization/yrp/init/lang_" .. short .. ".properties", nil, init )
	end
	yrp_cur_lang = short
end

function LoadLanguage( short , init )
	if short == nil then
		printGM( "note", "LoadLanguage ERROR!" )
		return false
	end
	if ( init ) then
		read_language( short, init )
	else
		hr_pre()
		if short == "auto" then
			printGM( "lang", "[AUTOMATIC DETECTION]" )

			search_language()

			if yrp_current_lang.get_language != "" then
				short = string.lower( yrp_current_lang.get_language )
				printGM( "lang", "Found Language: " .. "[" .. short .. "]" )
					if !check_languagepack() then
						short = "en"
						printGM( "lang", "Can't find Language-Pack, using Default-Language-Pack." )
					end
			else
				short = "en"
				printGM( "lang", "Can't find Language from Game, using Default-Language-Pack." )
			end
		else
			yrp_current_lang.get_language = short
			printGM( "lang", "Manually change to Language [" .. short .. "]" )
		end

		--have to read en first, so incomplete translations have en as base
		if ( short == "en" ) then
			read_language( short, init )

			printGM( "lang", "Language changed to [" .. tostring( yrp_default_lang.short ) .. "] " .. tostring( yrp_default_lang.language ) )
		else
			read_language( "en", init )
			read_language( short, init )

			printGM( "lang", "Language changed to [" .. tostring( yrp_current_lang.short ) .. "] " .. tostring( yrp_current_lang.language ) )
		end

		send_lang( short ) -- Send To Server
		hook.Run( "yrp_current_language_changed" )	-- Update Chat

		hr_pos()
	end
	return true
end

function add_language( short )
	local tmp = {}
	if short == "auto" then
		tmp.ineng = "Automatic"
		tmp.lang = "Automatic"
		tmp.short = short
		tmp.author = "D4KiR"
	else
		tmp.ineng = yrp_cache_lang.ineng
		tmp.lang = yrp_cache_lang.language
		tmp.short = yrp_cache_lang.short
		tmp.author = yrp_cache_lang.translated_by_name
	end

	yrp_button_info[short] = tmp
end

for i, short in pairs( yrp_shorts ) do
	LoadLanguage( short , true )
	add_language( short )
end

if CLIENT then
	--[[ FLAGS ]]--
	for i, tab_lang in pairs( GetAllLanguages() ) do
		if tab_lang.short != nil then
			AddDesignIcon( tab_lang.short, "vgui/flags/lang_" .. tab_lang.short .. ".png" )
		end
	end
end

function initLang()
	hr_pre()
	printGM( "lang", "... SEARCHING FOR LANGUAGE ..." )
	LoadLanguage( "auto" , false )
	hr_pos()
end
initLang()
--##############################################################################

--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

local yrp_current_lang = {}
local yrp_button_info = {}
local yrp_shorts = {}
table.insert( yrp_shorts, "auto" )
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

AddCSLuaFile( "read_lang.lua" )

include( "read_lang.lua" )

function set_lang_string( var, str )
	yrp_current_lang[var] = str
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
	local _string = yrp_current_lang[var]
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
	return yrp_current_lang.get_language
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
		printGM( "lang", "Send Language to Server (" .. tostring( short ) .. ")" )
		net.Start( "client_lang" )
			net.WriteString( tostring( short ) )
		net.SendToServer()
	end
end

function read_language( short, init )
	read_lang( "resource/localization/yrp/init/lang_" .. short .. ".properties" )
	if ( !init ) then
		read_lang( "resource/localization/yrp/general/lang_" .. short .. ".properties" )
		read_lang( "resource/localization/yrp/_old/lang_" .. short .. ".properties" )
		read_lang( "resource/localization/yrp/settings/lang_" .. short .. ".properties" )
		read_lang( "resource/localization/yrp/settingsfeedback/lang_" .. short .. ".properties" )
		read_lang( "resource/localization/yrp/settingsgeneral/lang_" .. short .. ".properties" )
		read_lang( "resource/localization/yrp/settingsusergroups/lang_" .. short .. ".properties" )
	end
end

function LoadLanguage( short , init )
	hr_pre()
	if short == "auto" then
		printGM( "lang", "Automatic detection" )

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

	--lazy loading on init
	if( init ) then
		read_language( short, init)
	else
		--have to read en first, so incomplete translations have en as base
		if( short == "en") then
			read_language( short, init)
		else
			read_language( "en", init)
			read_language( short, init)
		end
	end

	printGM( "lang", "Get Language-Pack [" .. yrp_current_lang.short .. "] " .. yrp_current_lang.language .. " (" .. "translated by" .. " " .. yrp_current_lang.translated_by_name .. ")" )
	printGM( "lang", "Language changed to [" .. yrp_current_lang.short .. "] " .. yrp_current_lang.language )

	send_lang( short ) -- Send To Server
	hook.Run( "yrp_current_language_changed" )	-- Update Chat
	hr_pos()
end

function add_language( short )
	local tmp = {}
	if short == "auto" then
		tmp.ineng = "Automatic"
		tmp.lang = "Automatic"
		tmp.short = short
		tmp.author = "D4KiR"
	else
		tmp.ineng = yrp_current_lang.ineng
		tmp.lang = yrp_current_lang.language
		tmp.short = yrp_current_lang.short
		tmp.author = yrp_current_lang.translated_by_name
	end

	table.insert( yrp_button_info, tmp )
end

for i, short in pairs( yrp_shorts ) do
	LoadLanguage( short , true)
	add_language( short )
end

if CLIENT then
	--[[ FLAGS ]]--
	for i, lang in pairs( GetAllLanguages() ) do
		AddDesignIcon( lang.short, "vgui/flags/lang_" .. lang.short .. ".png" )
	end
end

function initLang()
	hr_pre()
	printGM( "lang", "... SEARCHING FOR LANGUAGE ..." )
	LoadLanguage( "auto" , false)
	hr_pos()
end
initLang()
--##############################################################################

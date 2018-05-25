--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

local yrp_lang = {}
local yrp_all_lang = {}

function add_language()
	local tmp = {}
	tmp.ineng = yrp_lang.ineng
	tmp.lang = yrp_lang.language
	tmp.short = yrp_lang.short
	tmp.author = yrp_lang.translated_by_name
	tmp.varis = #yrp_lang

	local count = 0
	for k, v in pairs( yrp_lang ) do
		count = count + 1
	end
	tmp.varis = count

	table.insert( yrp_all_lang, tmp )
end

function get_language_name( ls )
	for k, lang in pairs( yrp_all_lang ) do
		if lang.short == ls then
			return lang.ineng
		end
	end
	return "FAILED"
end

yrp_lang.get_language = "Unknown"
yrp_lang.not_found = "not found, using default one."
yrp_lang.language = "Unknown"

function search_language()
	yrp_lang.get_language = string.lower( GetConVar( "gmod_language" ):GetString() )
end

function set_lang_string( var, str )
	yrp_lang[var] = str
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
	local _string = yrp_lang[var]
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

function get_all_lang()
	return yrp_all_lang
end

AddCSLuaFile( "languages/db_lang_en.lua" )
AddCSLuaFile( "languages/db_lang_de.lua" )
AddCSLuaFile( "languages/db_lang_ru.lua" )
AddCSLuaFile( "languages/db_lang_tr.lua" )
AddCSLuaFile( "languages/db_lang_fr.lua" )
AddCSLuaFile( "languages/db_lang_pt_br.lua" )
AddCSLuaFile( "languages/db_lang_th.lua" )
AddCSLuaFile( "languages/db_lang_it.lua" )
AddCSLuaFile( "languages/db_lang_sv.lua" )
AddCSLuaFile( "languages/db_lang_bg.lua" )
AddCSLuaFile( "languages/db_lang_pl.lua" )
AddCSLuaFile( "languages/db_lang_ro.lua" )
AddCSLuaFile( "languages/db_lang_es.lua" )
AddCSLuaFile( "languages/db_lang_ca.lua" )
AddCSLuaFile( "languages/db_lang_ua.lua" )
AddCSLuaFile( "languages/db_lang_ko.lua" )
AddCSLuaFile( "languages/db_lang_hu.lua" )
AddCSLuaFile( "languages/db_lang_cs.lua" )

include( "languages/db_lang_en.lua" )
include( "languages/db_lang_de.lua" )
include( "languages/db_lang_ru.lua" )
include( "languages/db_lang_tr.lua" )
include( "languages/db_lang_fr.lua" )
include( "languages/db_lang_pt_br.lua" )
include( "languages/db_lang_th.lua" )
include( "languages/db_lang_it.lua" )
include( "languages/db_lang_sv.lua" )
include( "languages/db_lang_bg.lua" )
include( "languages/db_lang_pl.lua" )
include( "languages/db_lang_ro.lua" )
include( "languages/db_lang_es.lua" )
include( "languages/db_lang_ca.lua" )
include( "languages/db_lang_ua.lua" )
include( "languages/db_lang_ko.lua" )
include( "languages/db_lang_hu.lua" )
include( "languages/db_lang_cs.lua" )

function check_languagepack()
	for k, v in pairs( yrp_all_lang ) do
		if yrp_lang.get_language == v.short then
			return true
		end
	end
	return false
end

function send_lang()
	--[[ send info to server ]]--
	if CLIENT then
		printGM( "lang", "Send Language to Server (" .. tostring( yrp_lang.get_language ) .. ")" )
		net.Start( "client_lang" )
			net.WriteString( tostring( yrp_lang.get_language ) )
		net.SendToServer()
	end
end

function change_language( index )
	hr_pre()

	--[[ change to english first, so missing translations are in english ]]--
	LangEN()

	local _net_lang = index
  if index == "auto" then
    printGM( "lang", "Automatic detection" )
    search_language()
    if yrp_lang.get_language != "" then
			_net_lang = string.lower( yrp_lang.get_language )
      printGM( "lang", "Found Language: " .. "[" .. _net_lang .. "]" )
      if check_languagepack() then
        if _net_lang == "de" then
          LangDE()
				elseif _net_lang == "en" then
          LangEN()
				elseif _net_lang == "ru" then
					LangRU()
				elseif _net_lang == "tr" then
					LangTR()
				elseif _net_lang == "fr" then
					LangFR()
				elseif _net_lang == "pt-br" then
					LangPT_BR()
				elseif _net_lang == "th" then
					LangTH()
				elseif _net_lang == "it" then
					LangIT()
				elseif _net_lang == "sv" then
					LangSV()
				elseif _net_lang == "bg" then
					LangBG()
				elseif _net_lang == "pl" then
					LangPL()
				elseif _net_lang == "ro" then
					LangRO()
				elseif _net_lang == "es" then
					LangES()
				elseif _net_lang == "ca" then
					LangCA()
				elseif _net_lang == "ua" then
					LangUA()
				elseif _net_lang == "ko" then
					LangKO()
				elseif _net_lang == "hu" then
					LangHU()
				elseif _net_lang == "cs" then
					LangCS()
				end
      else
        LangEN()
        printGM( "lang", "Can't find Language-Pack, using Default-Language-Pack." )
      end
    else
      LangEN()
      printGM( "lang", "Can't find Language from Game, using Default-Language-Pack." )
    end
  else
		yrp_lang.get_language = index
    printGM( "lang", "Manually change to Language [" .. index .. "]" )
    if index == "de" then
      LangDE()
    elseif index == "en" then
      LangEN()
		elseif index == "ru" then
			LangRU()
		elseif index == "tr" then
			LangTR()
		elseif index == "fr" then
			LangFR()
		elseif index == "pt-br" then
			LangPT_BR()
		elseif index == "th" then
			LangTH()
		elseif index == "it" then
			LangIT()
		elseif index == "sv" then
			LangSV()
		elseif index == "bg" then
			LangBG()
		elseif index == "pl" then
			LangPL()
		elseif index == "ro" then
			LangRO()
		elseif index == "es" then
			LangES()
		elseif index == "ca" then
			LangCA()
		elseif index == "ua" then
			LangUA()
		elseif index == "ko" then
			LangKO()
		elseif index == "hu" then
			LangHU()
		elseif index == "cs" then
			LangCS()
		else
      printGM( "error", "LANG_E0001" )
      return
    end
  end
  printGM( "lang", "Get Language-Pack [" .. yrp_lang.short .. "] " .. yrp_lang.language .. " (" .. yrp_lang.translated_by .. " " .. yrp_lang.translated_by_name .. ")" )
  printGM( "lang", "Language changed to [" .. yrp_lang.short .. "] " .. yrp_lang.language )

	send_lang()

	hook.Run( "yrp_language_changed" )

  hr_pos()
end

function initLang()
	hr_pre()
	printGM( "lang", "... SEARCHING FOR LANGUAGE ..." )
	change_language( "auto" )
	hr_pos()
end
initLang()
--##############################################################################

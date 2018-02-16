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
	yrp_lang.get_language = GetConVar( "gmod_language" ):GetString()
end

function set_lang_string( var, str )
	yrp_lang[var] = str
end

function lang_string( var )
	local _string = yrp_lang[var]
	if _string == nil then
		_string = "STRING NOT FOUND!"
		if CLIENT then
			if LocalPlayer():GetNWBool( "yrp_debug", false ) then
				printGM( "note", "lang_string failed! string " .. var .. " not found" )
			end
		end
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
      printGM( "lang", "Found Language: " .. "[" .. yrp_lang.get_language .. "]" )
			_net_lang = yrp_lang.get_language
      if check_languagepack() then
        if yrp_lang.get_language == "de" then
          LangDE()
				elseif yrp_lang.get_language == "en" then
          LangEN()
				elseif yrp_lang.get_language == "ru" then
					LangRU()
				elseif yrp_lang.get_language == "tr" then
					LangTR()
				elseif yrp_lang.get_language == "fr" then
					LangFR()
				elseif yrp_lang.get_language == "pt-br" then
					LangPT_BR()
				elseif yrp_lang.get_language == "th" then
					LangTH()
				elseif yrp_lang.get_language == "it" then
					LangIT()
				elseif yrp_lang.get_language == "sv" then
					LangSV()
				elseif yrp_lang.get_language == "bg" then
					LangBG()
				elseif yrp_lang.get_language == "pl" then
					LangPL()
				elseif yrp_lang.get_language == "ro" then
					LangRO()
				elseif yrp_lang.get_language == "es" then
					LangES()
				elseif yrp_lang.get_language == "ca" then
					LangCA()
				elseif yrp_lang.get_language == "ua" then
					LangUA()
				elseif yrp_lang.get_language == "ko" then
					LangKO()
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
		else
      printGM( "error", "LANG_E0001" )
      return
    end
  end
  printGM( "lang", "Get Language-Pack [" .. yrp_lang.short .. "] " .. yrp_lang.language .. " (" .. yrp_lang.translated_by .. " " .. yrp_lang.translated_by_name .. ")" )
  printGM( "lang", "Language changed to [" .. yrp_lang.short .. "] " .. yrp_lang.language )

	send_lang()

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

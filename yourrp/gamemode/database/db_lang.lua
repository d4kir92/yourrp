--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

lang = lang or {}
allLang = allLang or {}

function add_language()
	local tmp = {}
	tmp.ineng = lang.ineng
	tmp.lang = lang.language
	tmp.short = lang.short
	tmp.author = lang.translated_by_name
	tmp.varis = #lang

	local count = 0
	for k, v in pairs( lang ) do
		count = count + 1
	end
	tmp.varis = count

	table.insert( allLang, tmp )
end

lang.get_language = "Unknown"
lang.not_found = "not found, using default one."
lang.language = "Unknown"

function search_language()
	lang.get_language = GetConVar( "gmod_language" ):GetString()
end

function set_lang_string( var, str )
	lang[var] = str
end

function lang_string( var )
	local _string = lang[var]
	if _string == nil then
		_string = "STRING NOT FOUND!"
		printGM( "error", "lang_string failed! " .. var )
	end
	return _string
end

function get_all_lang()
	return allLang
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

function check_languagepack()
	for k, v in pairs( allLang ) do
		if lang.get_language == v.short then
			return true
		end
	end
	return false
end

function change_language( index )
  if index == "auto" then
    printGM( "lang", "Automatic detection" )
    search_language()
    if lang.get_language != "" then
      printGM( "lang", "Found Language: " .. "[" .. lang.get_language .. "]" )
      if check_languagepack() then
        if lang.get_language == "de" then
          LangDE()
				elseif lang.get_language == "en" then
          LangEN()
				elseif lang.get_language == "ru" then
					LangRU()
				elseif lang.get_language == "tr" then
					LangTR()
				elseif lang.get_language == "fr" then
					LangFR()
				elseif lang.get_language == "pt-br" then
					LangPT_BR()
				elseif lang.get_language == "th" then
					LangTH()
				elseif lang.get_language == "it" then
					LangIT()
				elseif lang.get_language == "sv" then
					LangSV()
				elseif lang.get_language == "bg" then
					LangBG()
				elseif lang.get_language == "pl" then
					LangPL()
				elseif lang.get_language == "ro" then
					LangRO()
				elseif lang.get_language == "es" then
					LangES()
				elseif lang.get_language == "ca" then
					LangCA()
				elseif lang.get_language == "ua" then
					LangUA()
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
		else
      printGM( "error", "LANG_E0001" )
      return
    end
  end
  printGM( "lang", "Get Language-Pack [" .. lang.short .. "] " .. lang.language .. " (" .. lang.translated_by .. " " .. lang.translated_by_name .. ")" )
  printGM( "lang", "Language changed to [" .. lang.short .. "] " .. lang.language )
end

function initLang()
	printGM( "lang", "... SEARCHING FOR LANGUAGE ..." )
	change_language( "auto" )
end
initLang()
--##############################################################################

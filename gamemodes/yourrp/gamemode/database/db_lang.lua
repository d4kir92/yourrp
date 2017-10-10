--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

--db_lang.lua

--##############################################################################
--Language Setup
lang = {}
lang.all = {}

function addLanguage()
	local tmp = {}
	tmp.ineng = lang.ineng
	tmp.lang = lang.lang
	tmp.short = lang.short
	tmp.author = lang.translatedByName

	table.insert( lang.all, tmp )
end

lang.getLang = GetConVar( "gmod_language" ):GetString()
lang.notfound = "not found, using default one."
lang.lang = "Unknown"

AddCSLuaFile( "lang/db_lang_en.lua" )
AddCSLuaFile( "lang/db_lang_de.lua" )
AddCSLuaFile( "lang/db_lang_ru.lua" )
AddCSLuaFile( "lang/db_lang_tr.lua" )
AddCSLuaFile( "lang/db_lang_fr.lua" )
AddCSLuaFile( "lang/db_lang_pt_br.lua" )
AddCSLuaFile( "lang/db_lang_th.lua" )
AddCSLuaFile( "lang/db_lang_it.lua" )
AddCSLuaFile( "lang/db_lang_sv.lua" )
AddCSLuaFile( "lang/db_lang_bg.lua" )
AddCSLuaFile( "lang/db_lang_pl.lua" )
AddCSLuaFile( "lang/db_lang_ro.lua" )
AddCSLuaFile( "lang/db_lang_es.lua" )
AddCSLuaFile( "lang/db_lang_ca.lua" )

include( "lang/db_lang_en.lua" )
include( "lang/db_lang_de.lua" )
include( "lang/db_lang_ru.lua" )
include( "lang/db_lang_tr.lua" )
include( "lang/db_lang_fr.lua" )
include( "lang/db_lang_pt_br.lua" )
include( "lang/db_lang_th.lua" )
include( "lang/db_lang_it.lua" )
include( "lang/db_lang_sv.lua" )
include( "lang/db_lang_bg.lua" )
include( "lang/db_lang_pl.lua" )
include( "lang/db_lang_ro.lua" )
include( "lang/db_lang_es.lua" )
include( "lang/db_lang_ca.lua" )

function checkLanguagepack()
	for k, v in pairs( lang.all ) do
		if lang.getLang == v.short then
			return true
		end
	end
	return false
end

function changeLang( index )
	print( yrp.spacePre )
  if index == "auto" then
    printGM( "lang", "Automatic detection" )
    lang.getLang = GetConVar( "gmod_language" ):GetString()
    if lang.getLang != "" then
      printGM( "lang", "Found Language: " .. "[" .. lang.getLang .. "]" )
      if checkLanguagepack() then
        if lang.getLang == "de" then
          LangDE()
				elseif lang.getLang == "en" then
          LangEN()
				elseif lang.getLang == "ru" then
					LangRU()
				elseif lang.getLang == "tr" then
					LangTR()
				elseif lang.getLang == "fr" then
					LangFR()
				elseif lang.getLang == "pt-br" then
					LangPT_BR()
				elseif lang.getLang == "th" then
					LangTH()
				elseif lang.getLang == "it" then
					LangIT()
				elseif lang.getLang == "sv" then
					LangSV()
				elseif lang.getLang == "bg" then
					LangBG()
				elseif lang.getLang == "pl" then
					LangPL()
				elseif lang.getLang == "ro" then
					LangRO()
				elseif lang.getLang == "es" then
					LangES()
				elseif lang.getLang == "ca" then
					LangCA()
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
		else
      printERROR( "LANG_E0001" )
      return
    end
  end
  printGM( "lang", "Get Language-Pack [" .. lang.short .. "] " .. lang.lang .. " (" .. lang.translatedBy .. " " .. lang.translatedByName .. ")" )
  printGM( "lang", "Language changed to [" .. lang.short .. "] " .. lang.lang )
  print( yrp.spacePos )
end

function initLang()
	print( yrp.spacePre )
	printGM( "lang", "... SEARCHING FOR LANGUAGE ..." )
	changeLang( "auto" )
	print( yrp.spacePos )
end
initLang()
--##############################################################################

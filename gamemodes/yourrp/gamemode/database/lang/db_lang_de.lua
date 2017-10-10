--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

--db_lang_de.lua

--##############################################################################
--LANGUAGE de German
AddCSLuaFile( "de/de_all.lua" )

include( "de/de_all.lua" )

function LangDE()
	lang.ineng = "German"
	lang.lang = "Deutsch"
	lang.short = "de"

	lang.translatedBy = "übersetzt von"
	lang.translatedByName = "D4KiR"

	DE_All()
end

LangDE()
addLanguage()
--##############################################################################

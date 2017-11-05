--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

--db_lang_en.lua

--##############################################################################
--LANGUAGE en English
AddCSLuaFile( "en/en_all.lua" )

include( "en/en_all.lua" )

function LangEN()
	lang.ineng = "English"
	lang.lang = "English"
	lang.short = "en"

	lang.translatedBy = "translated by"
	lang.translatedByName = "D4KiR"

	EN_All()
end

LangEN()
addLanguage()
--##############################################################################

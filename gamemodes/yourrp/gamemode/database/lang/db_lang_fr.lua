--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

--db_lang_fr.lua

--##############################################################################
--LANGUAGE fr French
AddCSLuaFile( "fr/fr_all.lua" )

include( "fr/fr_all.lua" )

function LangFR()
	lang.ineng = "French"
	lang.lang = "Français"
	lang.short = "fr"

	lang.translatedBy = "translated by"
	lang.translatedByName = "Nogitsu"

	FR_All()
end

LangFR()
addLanguage()
--##############################################################################

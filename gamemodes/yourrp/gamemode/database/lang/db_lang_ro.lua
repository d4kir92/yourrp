--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

--db_lang_ro.lua

--##############################################################################
--LANGUAGE ro Romanian
AddCSLuaFile( "ro/ro_all.lua" )

include( "ro/ro_all.lua" )

function LangRO()
	lang.ineng = "Romanian"
	lang.lang = "Română"
	lang.short = "ro"

	lang.translatedBy = "translated by"
	lang.translatedByName = "5elesium"

	RO_All()
end

LangRO()
addLanguage()
--##############################################################################

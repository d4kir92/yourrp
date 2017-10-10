--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

--db_lang_es.lua

--##############################################################################
--LANGUAGE es Spanish
AddCSLuaFile( "es/es_all.lua" )

include( "es/es_all.lua" )

function LangES()
	lang.ineng = "Spanish"
	lang.lang = "Español"
	lang.short = "es"

	lang.translatedBy = "translated by"
	lang.translatedByName = "azamio143"

	ES_All()
end

LangES()
addLanguage()
--##############################################################################

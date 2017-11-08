--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

--db_lang_es.lua

--##############################################################################
--LANGUAGE es Spanish
AddCSLuaFile( "es/es_all.lua" )

include( "es/es_all.lua" )

function LangES()
	set_lang_string( "ineng", "Spanish" )
	set_lang_string( "language", "Español" )
	set_lang_string( "short", "es" )

	set_lang_string( "translated_by", "translated by" )
	set_lang_string( "translated_by_name", "azamio143" )

	ES_All()
end

LangES()
add_language()
--##############################################################################

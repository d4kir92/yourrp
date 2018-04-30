--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

--db_lang_tr.lua

--##############################################################################
--LANGUAGE tr Turkish
AddCSLuaFile( "tr/tr_all.lua" )

include( "tr/tr_all.lua" )

function LangTR()
	set_lang_string( "ineng", "Turkish" )
	set_lang_string( "language", "Türkçe" )
	set_lang_string( "short", "tr" )

	set_lang_string( "translated_by", "translated by" )
	set_lang_string( "translated_by_name", "Kael" )

	TR_All()
end

LangTR()
add_language()
--##############################################################################

--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

--db_lang_th.lua

--##############################################################################
--LANGUAGE th thailand
AddCSLuaFile( "th/th_all.lua" )

include( "th/th_all.lua" )

function LangTH()
	set_lang_string( "ineng", "Thai" )
	set_lang_string( "language", "ประเทศไทย" )
	set_lang_string( "short", "th" )

	set_lang_string( "translated_by", "translated by" )
	set_lang_string( "translated_by_name", "EagleGamingZ" )

	TH_All()
end

LangTH()
add_language()
--##############################################################################

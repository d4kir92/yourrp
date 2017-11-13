--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

--db_lang_it.lua

--##############################################################################
--LANGUAGE it Italian
AddCSLuaFile( "it/it_all.lua" )

include( "it/it_all.lua" )

function LangIT()
	set_lang_string( "ineng", "Italian" )
	set_lang_string( "language", "Italiano" )
	set_lang_string( "short", "it" )

	set_lang_string( "translated_by", "translated by" )
	set_lang_string( "translated_by_name", "Frost and Mew Bird" )

	IT_All()
end

LangIT()
add_language()
--##############################################################################

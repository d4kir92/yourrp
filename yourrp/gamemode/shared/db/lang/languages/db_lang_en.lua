--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

--db_lang_en.lua

--##############################################################################
--LANGUAGE en English
AddCSLuaFile( "en/en_all.lua" )

include( "en/en_all.lua" )

function LangEN()
	set_lang_string( "ineng", "English" )
	set_lang_string( "language", "English" )
	set_lang_string( "short", "en" )

	set_lang_string( "translated_by", "translated by" )
	set_lang_string( "translated_by_name", "D4KiR" )

	EN_All()
end

LangEN()
add_language()
--##############################################################################

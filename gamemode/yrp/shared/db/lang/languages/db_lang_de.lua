--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

--db_lang_de.lua

--##############################################################################
--LANGUAGE de German
AddCSLuaFile( "de/de_all.lua" )

include( "de/de_all.lua" )

function LangDE()
	set_lang_string( "ineng", "German" )
	set_lang_string( "language", "Deutsch" )
	set_lang_string( "short", "de" )

	set_lang_string( "translated_by", "übersetzt von" )
	set_lang_string( "translated_by_name", "D4KiR" )

	DE_All()
end

LangDE()
add_language()
--##############################################################################

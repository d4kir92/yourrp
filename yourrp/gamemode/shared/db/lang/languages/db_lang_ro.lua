--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

--db_lang_ro.lua

--##############################################################################
--LANGUAGE ro Romanian
AddCSLuaFile( "ro/ro_all.lua" )

include( "ro/ro_all.lua" )

function LangRO()
	set_lang_string( "ineng", "Romanian" )
	set_lang_string( "language", "Română" )
	set_lang_string( "short", "ro" )

	set_lang_string( "translated_by", "translated by" )
	set_lang_string( "translated_by_name", "5elesium" )

	RO_All()
end

LangRO()
add_language()
--##############################################################################

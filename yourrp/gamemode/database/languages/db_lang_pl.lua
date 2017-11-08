--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

--db_lang_pl.lua

--##############################################################################
--LANGUAGE pl Polish
AddCSLuaFile( "pl/pl_all.lua" )

include( "pl/pl_all.lua" )

function LangPL()
	set_lang_string( "ineng", "Polish" )
	set_lang_string( "language", "Polskie" )
	set_lang_string( "short", "pl" )

	set_lang_string( "translated_by", "translated by" )
	set_lang_string( "translated_by_name", "CallsignCubGambino" )

	PL_All()
end

LangPL()
add_language()
--##############################################################################

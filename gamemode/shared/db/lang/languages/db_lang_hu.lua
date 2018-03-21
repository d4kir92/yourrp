--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

--db_lang_hu.lua

--##############################################################################
--LANGUAGE hu Hungarian
AddCSLuaFile( "hu/hu_all.lua" )

include( "hu/hu_all.lua" )

function LangHU()
	set_lang_string( "ineng", "Hungarian" )
	set_lang_string( "language", "Magyar" )
	set_lang_string( "short", "hu" )

	set_lang_string( "translated_by", "translated by" )
	set_lang_string( "translated_by_name", "ZoliK" )

	HU_All()
end

LangHU()
add_language()
--##############################################################################

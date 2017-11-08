--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

--db_lang_bg.lua

--##############################################################################
--LANGUAGE bg Bulgarian
AddCSLuaFile( "bg/bg_all.lua" )

include( "bg/bg_all.lua" )

function LangBG()
	set_lang_string( "ineng", "Bulgarian" )
	set_lang_string( "language", "Български" )
	set_lang_string( "short", "bg" )

	set_lang_string( "translated_by", "translated by" )
	set_lang_string( "translated_by_name", "RobyVan" )

	BG_All()
end

LangBG()
add_language()
--##############################################################################

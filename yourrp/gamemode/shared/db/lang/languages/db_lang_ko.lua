--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

--db_lang_ko.lua

--##############################################################################
--LANGUAGE ko Korean
AddCSLuaFile( "ko/ko_all.lua" )

include( "ko/ko_all.lua" )

function LangKO()
	set_lang_string( "ineng", "Korean" )
	set_lang_string( "language", "한국어" )
	set_lang_string( "short", "ko" )

	set_lang_string( "translated_by", "translated by" )
	set_lang_string( "translated_by_name", "플보" )

	KO_All()
end

LangKO()
add_language()
--##############################################################################

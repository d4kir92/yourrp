--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

--db_lang_sv.lua

--##############################################################################
--LANGUAGE sv Swedish
AddCSLuaFile( "sv/sv_all.lua" )

include( "sv/sv_all.lua" )

function LangSV()
	set_lang_string( "ineng", "Swedish" )
	set_lang_string( "language", "Svenska" )
	set_lang_string( "short", "sv" )

	set_lang_string( "translated_by", "translated by" )
	set_lang_string( "translated_by_name", "| Phoenix |" )

	SV_ALL()
end

LangSV()
add_language()
--##############################################################################

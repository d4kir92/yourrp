--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

--db_lang_pt_br.lua

--##############################################################################
--LANGUAGE pt_br Portuguese
AddCSLuaFile( "pt_br/pt_br_all.lua" )

include( "pt_br/pt_br_all.lua" )

function LangPT_BR()
	set_lang_string( "ineng", "Portuguese" )
	set_lang_string( "language", "Português Brasil" )
	set_lang_string( "short", "pt-br" )

	set_lang_string( "translated_by", "translated by" )
	set_lang_string( "translated_by_name", "NyanHeavy and Brayan" )

	PT_BR_All()
end

LangPT_BR()
add_language()
--##############################################################################

--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

--db_lang_cs.lua

--##############################################################################
--LANGUAGE cs Czech
AddCSLuaFile( "cs/cs_all.lua" )

include( "cs/cs_all.lua" )

function LangCS()
	set_lang_string( "ineng", "Czech" )
	set_lang_string( "language", "Čeština" )
	set_lang_string( "short", "cs" )

	set_lang_string( "translated_by", "translated by" )
	set_lang_string( "translated_by_name", "ph0enix_z" )

	CS_ALL()
end

LangCS()
add_language()
--##############################################################################

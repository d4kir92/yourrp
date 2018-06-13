--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

--db_lang_fr.lua

--##############################################################################
--LANGUAGE fr French
AddCSLuaFile( "fr/fr_all.lua" )

include( "fr/fr_all.lua" )

function LangFR()
	set_lang_string( "ineng", "French" )
	set_lang_string( "language", "Français" )
	set_lang_string( "short", "fr" )

	set_lang_string( "translated_by", "translated by" )
	set_lang_string( "translated_by_name", "Nogitsu" )

	FR_ALL()
end

LangFR()
add_language()
--##############################################################################

--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

--db_lang_ca.lua

--##############################################################################
--LANGUAGE ca Catalan
AddCSLuaFile( "ca/ca_all.lua" )

include( "ca/ca_all.lua" )

function LangCA()
	set_lang_string( "ineng", "Catalan" )
	set_lang_string( "language", "Català" )
	set_lang_string( "short", "ca" )

	set_lang_string( "translated_by", "translated by" )
	set_lang_string( "translated_by_name", "azamio143" )

	CA_All()
end

LangCA()
add_language()
--##############################################################################

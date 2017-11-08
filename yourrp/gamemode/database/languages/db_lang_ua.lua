--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

--db_lang_ua.lua

--##############################################################################
--LANGUAGE ua Ukrainian
AddCSLuaFile( "ua/ua_all.lua" )

include( "ua/ua_all.lua" )

function LangUA()
	set_lang_string( "ineng", "Ukrainian" )
	set_lang_string( "language", "Українська" )
	set_lang_string( "short", "ua" )

	set_lang_string( "translated_by", "translated by" )
	set_lang_string( "translated_by_name", "Mojito Tea" )

	UA_All()
end

LangUA()
add_language()
--##############################################################################

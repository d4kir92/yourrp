--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

AddCSLuaFile( "en/en_all.lua" )
AddCSLuaFile( "en/en_general.lua" )
AddCSLuaFile( "en/en_settings.lua" )
AddCSLuaFile( "en/en_settingsusergroups.lua" )

include( "en/en_all.lua" )
include( "en/en_general.lua" )
include( "en/en_settings.lua" )
include( "en/en_settingsusergroups.lua" )

function LangEN()
	set_lang_string( "ineng", "English" )
	set_lang_string( "language", "English" )
	set_lang_string( "short", "en" )

	set_lang_string( "translated_by", "translated by" )
	set_lang_string( "translated_by_name", "D4KiR" )

	EN_All()
	EN_GENERAL()
	EN_SETTINGS()
	EN_SETTINGSUSERGROUPS()
end

LangEN()
add_language()
--##############################################################################

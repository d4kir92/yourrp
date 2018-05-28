--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

AddCSLuaFile( "lt/lt_all.lua" )
AddCSLuaFile( "lt/lt_general.lua" )
AddCSLuaFile( "lt/lt_settings.lua" )
AddCSLuaFile( "lt/lt_settingsusergroups.lua" )

include( "lt/lt_all.lua" )
include( "lt/lt_general.lua" )
include( "lt/lt_settings.lua" )
include( "lt/lt_settingsusergroups.lua" )

function LangLT()
	set_lang_string( "ineng", "Lithuanian" )
	set_lang_string( "language", "Lietuvių" )
	set_lang_string( "short", "lt" )

	set_lang_string( "translated_by", "translated by" )
	set_lang_string( "translated_by_name", "WingedHuzzar" )

	LT_ALL()
	LT_GENERAL()
	LT_SETTINGS()
	LT_SETTINGSUSERGROUPS()
end

LangLT()
add_language()

--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

AddCSLuaFile( "de/de_all.lua" )
AddCSLuaFile( "de/de_general.lua" )
AddCSLuaFile( "de/de_settings.lua" )
AddCSLuaFile( "de/de_settingsfeedback.lua" )
AddCSLuaFile( "de/de_settingsusergroups.lua" )

include( "de/de_all.lua" )
include( "de/de_general.lua" )
include( "de/de_settings.lua" )
include( "de/de_settingsfeedback.lua" )
include( "de/de_settingsusergroups.lua" )

function LangDE()
	set_lang_string( "ineng", "German" )
	set_lang_string( "language", "Deutsch" )
	set_lang_string( "short", "de" )

	set_lang_string( "translated_by", "übersetzt von" )
	set_lang_string( "translated_by_name", "D4KiR" )

	DE_ALL()
	DE_GENERAL()
	DE_SETTINGS()
	DE_SETTINGSFEEDBACK()
	DE_SETTINGSUSERGROUPS()
end

LangDE()
add_language()

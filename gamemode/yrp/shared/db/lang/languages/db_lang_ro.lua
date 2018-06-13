--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

AddCSLuaFile( "ro/ro_all.lua" )
AddCSLuaFile( "ro/ro_general.lua" )
AddCSLuaFile( "ro/ro_settings.lua" )
AddCSLuaFile( "ro/ro_settingsfeedback.lua" )
AddCSLuaFile( "ro/ro_settingsgeneral.lua" )
AddCSLuaFile( "ro/ro_settingsusergroups.lua" )

include( "ro/ro_all.lua" )
include( "ro/ro_general.lua" )
include( "ro/ro_settings.lua" )
include( "ro/ro_settingsfeedback.lua" )
include( "ro/ro_settingsgeneral.lua" )
include( "ro/ro_settingsusergroups.lua" )

function LangRO()
	set_lang_string( "ineng", "Romanian" )
	set_lang_string( "language", "Română" )
	set_lang_string( "short", "ro" )

	set_lang_string( "translated_by", "translated by" )
	set_lang_string( "translated_by_name", "5elesium" )

	RO_ALL()
	RO_GENERAL()
	RO_SETTINGS()
	RO_SETTINGSFEEDBACK()
	RO_SETTINGSGENERAL()
	RO_SETTINGSUSERGROUPS()
end

LangRO()
add_language()
--##############################################################################

--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

AddCSLuaFile( "cs/cs_all.lua" )
AddCSLuaFile( "cs/cs_general.lua" )
AddCSLuaFile( "cs/cs_settings.lua" )
AddCSLuaFile( "cs/cs_settingsfeedback.lua" )
AddCSLuaFile( "cs/cs_settingsgeneral.lua" )
AddCSLuaFile( "cs/cs_settingsusergroups.lua" )

include( "cs/cs_all.lua" )
include( "cs/cs_general.lua" )
include( "cs/cs_settings.lua" )
include( "cs/cs_settingsfeedback.lua" )
include( "cs/cs_settingsgeneral.lua" )
include( "cs/cs_settingsusergroups.lua" )

function LangCS()
	set_lang_string( "ineng", "Czech" )
	set_lang_string( "language", "Čeština" )
	set_lang_string( "short", "cs" )

	set_lang_string( "translated_by", "translated by" )
	set_lang_string( "translated_by_name", "ph0enix_z" )

	CS_ALL()
	CS_GENERAL()
	CS_SETTINGS()
	CS_SETTINGSFEEDBACK()
	CS_SETTINGSGENERAL()
	CS_SETTINGSUSERGROUPS()
end

LangCS()
add_language()
--##############################################################################

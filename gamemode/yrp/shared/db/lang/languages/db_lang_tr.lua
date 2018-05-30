--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

AddCSLuaFile( "tr/tr_all.lua" )
AddCSLuaFile( "tr/tr_general.lua" )
AddCSLuaFile( "tr/tr_settings.lua" )
AddCSLuaFile( "tr/tr_settingsfeedback.lua" )
AddCSLuaFile( "tr/tr_settingsusergroups.lua" )

include( "tr/tr_all.lua" )
include( "tr/tr_general.lua" )
include( "tr/tr_settings.lua" )
include( "tr/tr_settingsfeedback.lua" )
include( "tr/tr_settingsusergroups.lua" )

function LangTR()
	set_lang_string( "ineng", "Turkish" )
	set_lang_string( "language", "Türkçe" )
	set_lang_string( "short", "tr" )

	set_lang_string( "translated_by", "translated by" )
	set_lang_string( "translated_by_name", "Kael" )

	TR_ALL()
	TR_GENERAL()
	TR_SETTINGS()
	TR_SETTINGSFEEDBACK()
	TR_SETTINGSUSERGROUPS()
end

LangTR()
add_language()
--##############################################################################

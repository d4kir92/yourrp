--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

AddCSLuaFile( "ru/ru_all.lua" )
AddCSLuaFile( "ru/ru_general.lua" )
AddCSLuaFile( "ru/ru_settings.lua" )
AddCSLuaFile( "ru/ru_settingsfeedback.lua" )
AddCSLuaFile( "ru/ru_settingsusergroups.lua" )

include( "ru/ru_all.lua" )
include( "ru/ru_general.lua" )
include( "ru/ru_settings.lua" )
include( "ru/ru_settingsfeedback.lua" )
include( "ru/ru_settingsusergroups.lua" )

function LangRU()
	set_lang_string( "ineng", "Russian" )
	set_lang_string( "language", "Русский" )
	set_lang_string( "short", "ru" )

	set_lang_string( "translated_by", "translated by" )
	set_lang_string( "translated_by_name", "DropSpawn3rFree and roni_sl" )

	RU_ALL()
	RU_GENERAL()
	RU_SETTINGS()
	RU_SETTINGSFEEDBACK()
	RU_SETTINGSUSERGROUPS()
end

LangRU()
add_language()
--##############################################################################

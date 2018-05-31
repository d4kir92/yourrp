--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

AddCSLuaFile( "ua/ua_all.lua" )
AddCSLuaFile( "ua/ua_general.lua" )
AddCSLuaFile( "ua/ua_settings.lua" )
AddCSLuaFile( "ua/ua_settingsfeedback.lua" )
AddCSLuaFile( "ua/ua_settingsusergroups.lua" )

include( "ua/ua_all.lua" )
include( "ua/ua_general.lua" )
include( "ua/ua_settings.lua" )
include( "ua/ua_settingsfeedback.lua" )
include( "ua/ua_settingsusergroups.lua" )

function LangUA()
	set_lang_string( "ineng", "Ukrainian" )
	set_lang_string( "language", "Українська" )
	set_lang_string( "short", "ua" )

	set_lang_string( "translated_by", "translated by" )
	set_lang_string( "translated_by_name", "Mojito Tea" )

	UA_ALL()
	UA_GENERAL()
	UA_SETTINGS()
	UA_SETTINGSFEEDBACK()
	UA_SETTINGSUSERGROUPS()
end

LangUA()
add_language()

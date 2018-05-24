--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

AddCSLuaFile( "pt_br/pt_br_all.lua" )
AddCSLuaFile( "pt_br/pt_br_general.lua" )
AddCSLuaFile( "pt_br/pt_br_settings.lua" )
AddCSLuaFile( "pt_br/pt_br_settingsusergroups.lua" )

include( "pt_br/pt_br_all.lua" )
include( "pt_br/pt_br_general.lua" )
include( "pt_br/pt_br_settings.lua" )
include( "pt_br/pt_br_settingsusergroups.lua" )

function LangPT_BR()
	set_lang_string( "ineng", "Portuguese" )
	set_lang_string( "language", "Português Brasil" )
	set_lang_string( "short", "pt-br" )

	set_lang_string( "translated_by", "translated by" )
	set_lang_string( "translated_by_name", "NyanHeavy and Brayan" )

	PT_BR_All()
	PT_BR_GENERAL()
	PT_BR_SETTINGS()
	PT_BR_SETTINGSUSERGROUPS()
end

LangPT_BR()
add_language()
--##############################################################################

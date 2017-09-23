--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

--db_lang_en.lua

--##############################################################################
--LANGUAGE en English
AddCSLuaFile( "en/en_general.lua" )
AddCSLuaFile( "en/en_hud.lua" )
AddCSLuaFile( "en/en_role_menu.lua" )
AddCSLuaFile( "en/en_buy_menu.lua" )
AddCSLuaFile( "en/en_settings.lua" )
AddCSLuaFile( "en/en_door.lua" )
AddCSLuaFile( "en/en_interact_menu.lua" )
AddCSLuaFile( "en/en_atm.lua" )

include( "en/en_general.lua" )
include( "en/en_hud.lua" )
include( "en/en_role_menu.lua" )
include( "en/en_buy_menu.lua" )
include( "en/en_settings.lua" )
include( "en/en_door.lua" )
include( "en/en_interact_menu.lua" )
include( "en/en_atm.lua" )

function LangEN()
	lang.ineng = "English"
	lang.lang = "English"
	lang.short = "en"

	lang.translatedBy = "translated by"
	lang.translatedByName = "D4KiR"

	EN_General()
	EN_Hud()
	EN_Role_Menu()
	EN_Buy_Menu()
	EN_Settings()
	EN_Door()
	EN_Interact_Menu()
	EN_Atm()
end

LangEN()
addLanguage()
--##############################################################################

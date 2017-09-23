--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

--db_lang_fr.lua

--##############################################################################
--LANGUAGE fr French
AddCSLuaFile( "fr/fr_general.lua" )
AddCSLuaFile( "fr/fr_hud.lua" )
AddCSLuaFile( "fr/fr_role_menu.lua" )
AddCSLuaFile( "fr/fr_buy_menu.lua" )
AddCSLuaFile( "fr/fr_settings.lua" )
AddCSLuaFile( "fr/fr_door.lua" )
AddCSLuaFile( "fr/fr_interact_menu.lua" )
AddCSLuaFile( "fr/fr_atm.lua" )

include( "fr/fr_general.lua" )
include( "fr/fr_hud.lua" )
include( "fr/fr_role_menu.lua" )
include( "fr/fr_buy_menu.lua" )
include( "fr/fr_settings.lua" )
include( "fr/fr_door.lua" )
include( "fr/fr_interact_menu.lua" )
include( "fr/fr_atm.lua" )

function LangFR()
	lang.ineng = "French"
	lang.lang = "Français"
	lang.short = "fr"

	lang.translatedBy = "translated by"
	lang.translatedByName = "Nogitsu"

	FR_General()
	FR_Hud()
	FR_Role_Menu()
	FR_Buy_Menu()
	FR_Settings()
	FR_Door()
	FR_Interact_Menu()
	FR_Atm()
end

LangFR()
addLanguage()
--##############################################################################

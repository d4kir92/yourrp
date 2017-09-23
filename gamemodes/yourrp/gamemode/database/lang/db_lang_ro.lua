--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

--db_lang_ro.lua

--##############################################################################
--LANGUAGE ro Romanian
AddCSLuaFile( "ro/ro_general.lua" )
AddCSLuaFile( "ro/ro_hud.lua" )
AddCSLuaFile( "ro/ro_role_menu.lua" )
AddCSLuaFile( "ro/ro_buy_menu.lua" )
AddCSLuaFile( "ro/ro_settings.lua" )
AddCSLuaFile( "ro/ro_door.lua" )
AddCSLuaFile( "ro/ro_interact_menu.lua" )
AddCSLuaFile( "ro/ro_atm.lua" )

include( "ro/ro_general.lua" )
include( "ro/ro_hud.lua" )
include( "ro/ro_role_menu.lua" )
include( "ro/ro_buy_menu.lua" )
include( "ro/ro_settings.lua" )
include( "ro/ro_door.lua" )
include( "ro/ro_interact_menu.lua" )
include( "ro/ro_atm.lua" )

function LangRO()
	lang.ineng = "Romanian"
	lang.lang = "Română"
	lang.short = "ro"

	lang.translatedBy = "translated by"
	lang.translatedByName = "5elesium"

	RO_General()
	RO_Hud()
	RO_Role_Menu()
	RO_Buy_Menu()
	RO_Settings()
	RO_Door()
	RO_Interact_Menu()
	RO_Atm()
end

LangRO()
addLanguage()
--##############################################################################

--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

--db_lang_th.lua

--##############################################################################
--LANGUAGE th thailand
AddCSLuaFile( "th/th_general.lua" )
AddCSLuaFile( "th/th_hud.lua" )
AddCSLuaFile( "th/th_role_menu.lua" )
AddCSLuaFile( "th/th_buy_menu.lua" )
AddCSLuaFile( "th/th_settings.lua" )
AddCSLuaFile( "th/th_door.lua" )
AddCSLuaFile( "th/th_interact_menu.lua" )
AddCSLuaFile( "th/th_atm.lua" )

include( "th/th_general.lua" )
include( "th/th_hud.lua" )
include( "th/th_role_menu.lua" )
include( "th/th_buy_menu.lua" )
include( "th/th_settings.lua" )
include( "th/th_door.lua" )
include( "th/th_interact_menu.lua" )
include( "th/th_atm.lua" )

function LangTH()
	lang.ineng = "thailand"
	lang.lang = "ประเทศไทย"
	lang.short = "th"

	lang.translatedBy = "translated by"
	lang.translatedByName = "EagleGamingZ"

	TH_General()
	TH_Hud()
	TH_Role_Menu()
	TH_Buy_Menu()
	TH_Settings()
	TH_Door()
	TH_Interact_Menu()
	TH_Atm()
end

LangTH()
addLanguage()
--##############################################################################

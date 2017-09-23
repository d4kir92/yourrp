--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

--db_lang_tr.lua

--##############################################################################
--LANGUAGE tr Turkish
AddCSLuaFile( "tr/tr_general.lua" )
AddCSLuaFile( "tr/tr_hud.lua" )
AddCSLuaFile( "tr/tr_role_menu.lua" )
AddCSLuaFile( "tr/tr_buy_menu.lua" )
AddCSLuaFile( "tr/tr_settings.lua" )
AddCSLuaFile( "tr/tr_door.lua" )
AddCSLuaFile( "tr/tr_interact_menu.lua" )
AddCSLuaFile( "tr/tr_atm.lua" )

include( "tr/tr_general.lua" )
include( "tr/tr_hud.lua" )
include( "tr/tr_role_menu.lua" )
include( "tr/tr_buy_menu.lua" )
include( "tr/tr_settings.lua" )
include( "tr/tr_door.lua" )
include( "tr/tr_interact_menu.lua" )
include( "tr/tr_atm.lua" )

function LangTR()
	lang.ineng = "Turkish"
	lang.lang = "Turkey"
	lang.short = "tr"

	lang.translatedBy = "translated by"
	lang.translatedByName = "CorayC"

	TR_General()
	TR_Hud()
	TR_Role_Menu()
	TR_Buy_Menu()
	TR_Settings()
	TR_Door()
	TR_Interact_Menu()
	TR_Atm()
end

LangTR()
addLanguage()
--##############################################################################

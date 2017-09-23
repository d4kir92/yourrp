--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

--db_lang_pl.lua

--##############################################################################
--LANGUAGE pl Polish
AddCSLuaFile( "pl/pl_general.lua" )
AddCSLuaFile( "pl/pl_hud.lua" )
AddCSLuaFile( "pl/pl_role_menu.lua" )
AddCSLuaFile( "pl/pl_buy_menu.lua" )
AddCSLuaFile( "pl/pl_settings.lua" )
AddCSLuaFile( "pl/pl_door.lua" )
AddCSLuaFile( "pl/pl_interact_menu.lua" )
AddCSLuaFile( "pl/pl_atm.lua" )

include( "pl/pl_general.lua" )
include( "pl/pl_hud.lua" )
include( "pl/pl_role_menu.lua" )
include( "pl/pl_buy_menu.lua" )
include( "pl/pl_settings.lua" )
include( "pl/pl_door.lua" )
include( "pl/pl_interact_menu.lua" )
include( "pl/pl_atm.lua" )

function LangPL()
	lang.ineng = "Polish"
	lang.lang = "Polskie"
	lang.short = "pl"

	lang.translatedBy = "translated by"
	lang.translatedByName = "CallsignCubGambino"

	PL_General()
	PL_Hud()
	PL_Role_Menu()
	PL_Buy_Menu()
	PL_Settings()
	PL_Door()
	PL_Interact_Menu()
	PL_Atm()
end

LangPL()
addLanguage()
--##############################################################################

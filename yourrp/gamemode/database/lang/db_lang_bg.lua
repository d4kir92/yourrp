--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

--db_lang_bg.lua

--##############################################################################
--LANGUAGE bg Bulgarian
AddCSLuaFile( "bg/bg_general.lua" )
AddCSLuaFile( "bg/bg_hud.lua" )
AddCSLuaFile( "bg/bg_role_menu.lua" )
AddCSLuaFile( "bg/bg_buy_menu.lua" )
AddCSLuaFile( "bg/bg_settings.lua" )
AddCSLuaFile( "bg/bg_door.lua" )
AddCSLuaFile( "bg/bg_interact_menu.lua" )
AddCSLuaFile( "bg/bg_atm.lua" )

include( "bg/bg_general.lua" )
include( "bg/bg_hud.lua" )
include( "bg/bg_role_menu.lua" )
include( "bg/bg_buy_menu.lua" )
include( "bg/bg_settings.lua" )
include( "bg/bg_door.lua" )
include( "bg/bg_interact_menu.lua" )
include( "bg/bg_atm.lua" )

function LangBG()
	lang.ineng = "Bulgarian"
	lang.lang = "Български"
	lang.short = "bg"

	lang.translatedBy = "translated by"
	lang.translatedByName = "RobyVan"

	BG_General()
	BG_Hud()
	BG_Role_Menu()
	BG_Buy_Menu()
	BG_Settings()
	BG_Door()
	BG_Interact_Menu()
	BG_Atm()
end

LangBG()
addLanguage()
--##############################################################################

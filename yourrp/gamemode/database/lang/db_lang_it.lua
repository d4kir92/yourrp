--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

--db_lang_it.lua

--##############################################################################
--LANGUAGE it Italian
AddCSLuaFile( "it/it_general.lua" )
AddCSLuaFile( "it/it_hud.lua" )
AddCSLuaFile( "it/it_role_menu.lua" )
AddCSLuaFile( "it/it_buy_menu.lua" )
AddCSLuaFile( "it/it_settings.lua" )
AddCSLuaFile( "it/it_door.lua" )
AddCSLuaFile( "it/it_interact_menu.lua" )
AddCSLuaFile( "it/it_atm.lua" )

include( "it/it_general.lua" )
include( "it/it_hud.lua" )
include( "it/it_role_menu.lua" )
include( "it/it_buy_menu.lua" )
include( "it/it_settings.lua" )
include( "it/it_door.lua" )
include( "it/it_interact_menu.lua" )
include( "it/it_atm.lua" )

function LangIT()
	lang.ineng = "Italian"
	lang.lang = "Italiano"
	lang.short = "it"

	lang.translatedBy = "translated by"
	lang.translatedByName = "Frost"

	IT_General()
	IT_Hud()
	IT_Role_Menu()
	IT_Buy_Menu()
	IT_Settings()
	IT_Door()
	IT_Interact_Menu()
	IT_Atm()
end

LangIT()
addLanguage()
--##############################################################################

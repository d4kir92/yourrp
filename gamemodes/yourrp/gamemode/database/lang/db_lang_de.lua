--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

--db_lang_de.lua

--##############################################################################
--LANGUAGE de German
AddCSLuaFile( "de/de_general.lua" )
AddCSLuaFile( "de/de_hud.lua" )
AddCSLuaFile( "de/de_role_menu.lua" )
AddCSLuaFile( "de/de_buy_menu.lua" )
AddCSLuaFile( "de/de_settings.lua" )
AddCSLuaFile( "de/de_door.lua" )
AddCSLuaFile( "de/de_interact_menu.lua" )
AddCSLuaFile( "de/de_atm.lua" )

include( "de/de_general.lua" )
include( "de/de_hud.lua" )
include( "de/de_role_menu.lua" )
include( "de/de_buy_menu.lua" )
include( "de/de_settings.lua" )
include( "de/de_door.lua" )
include( "de/de_interact_menu.lua" )
include( "de/de_atm.lua" )

function LangDE()
	lang.ineng = "German"
	lang.lang = "Deutsch"
	lang.short = "de"

	lang.translatedBy = "übersetzt von"
	lang.translatedByName = "D4KiR"

	DE_General()
  DE_Hud()
	DE_Role_Menu()
	DE_Buy_Menu()
	DE_Settings()
	DE_Door()
	DE_Interact_Menu()
	DE_Atm()
end

LangDE()
addLanguage()
--##############################################################################

--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

--db_lang_ru.lua

--##############################################################################
--LANGUAGE ru Russian
AddCSLuaFile( "ru/ru_general.lua" )
AddCSLuaFile( "ru/ru_hud.lua" )
AddCSLuaFile( "ru/ru_role_menu.lua" )
AddCSLuaFile( "ru/ru_buy_menu.lua" )
AddCSLuaFile( "ru/ru_settings.lua" )
AddCSLuaFile( "ru/ru_door.lua" )
AddCSLuaFile( "ru/ru_interact_menu.lua" )
AddCSLuaFile( "ru/ru_atm.lua" )

include( "ru/ru_general.lua" )
include( "ru/ru_hud.lua" )
include( "ru/ru_role_menu.lua" )
include( "ru/ru_buy_menu.lua" )
include( "ru/ru_settings.lua" )
include( "ru/ru_door.lua" )
include( "ru/ru_interact_menu.lua" )
include( "ru/ru_atm.lua" )

function LangRU()
	lang.ineng = "Russian"
	lang.lang = "Русский"
	lang.short = "ru"

	lang.translatedBy = "translated by"
	lang.translatedByName = "DropSpawn3rFree"

	RU_General()
	RU_Hud()
	RU_Role_Menu()
	RU_Buy_Menu()
	RU_Settings()
	RU_Door()
	RU_Interact_Menu()
	RU_Atm()
end

LangRU()
addLanguage()
--##############################################################################

--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

--db_lang_sv.lua

--##############################################################################
--LANGUAGE sv Swedish
AddCSLuaFile( "sv/sv_general.lua" )
AddCSLuaFile( "sv/sv_hud.lua" )
AddCSLuaFile( "sv/sv_role_menu.lua" )
AddCSLuaFile( "sv/sv_buy_menu.lua" )
AddCSLuaFile( "sv/sv_settings.lua" )
AddCSLuaFile( "sv/sv_door.lua" )
AddCSLuaFile( "sv/sv_interact_menu.lua" )
AddCSLuaFile( "sv/sv_atm.lua" )

include( "sv/sv_general.lua" )
include( "sv/sv_hud.lua" )
include( "sv/sv_role_menu.lua" )
include( "sv/sv_buy_menu.lua" )
include( "sv/sv_settings.lua" )
include( "sv/sv_door.lua" )
include( "sv/sv_interact_menu.lua" )
include( "sv/sv_atm.lua" )

function LangSV()
	lang.ineng = "Swedish"
	lang.lang = "Svenska"
	lang.short = "sv"

	lang.translatedBy = "translated by"
	lang.translatedByName = "| Phoenix |"

	SV_General()
	SV_Hud()
	SV_Role_Menu()
	SV_Buy_Menu()
	SV_Settings()
	SV_Door()
	SV_Interact_Menu()
	SV_Atm()
end

LangSV()
addLanguage()
--##############################################################################

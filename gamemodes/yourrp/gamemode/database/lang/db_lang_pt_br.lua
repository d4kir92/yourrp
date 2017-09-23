--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

--db_lang_pt_br.lua

--##############################################################################
--LANGUAGE pt_br Portuguese
AddCSLuaFile( "pt_br/pt_br_general.lua" )
AddCSLuaFile( "pt_br/pt_br_hud.lua" )
AddCSLuaFile( "pt_br/pt_br_role_menu.lua" )
AddCSLuaFile( "pt_br/pt_br_buy_menu.lua" )
AddCSLuaFile( "pt_br/pt_br_settings.lua" )
AddCSLuaFile( "pt_br/pt_br_door.lua" )
AddCSLuaFile( "pt_br/pt_br_interact_menu.lua" )
AddCSLuaFile( "pt_br/pt_br_atm.lua" )

include( "pt_br/pt_br_general.lua" )
include( "pt_br/pt_br_hud.lua" )
include( "pt_br/pt_br_role_menu.lua" )
include( "pt_br/pt_br_buy_menu.lua" )
include( "pt_br/pt_br_settings.lua" )
include( "pt_br/pt_br_door.lua" )
include( "pt_br/pt_br_interact_menu.lua" )
include( "pt_br/pt_br_atm.lua" )

function LangPT_BR()
	lang.ineng = "Portuguese"
	lang.lang = "Português Brasil"
	lang.short = "pt-br"

	lang.translatedBy = "translated by"
	lang.translatedByName = "NyanHeavy"

	PT_BR_General()
	PT_BR_Hud()
	PT_BR_Role_Menu()
	PT_BR_Buy_Menu()
	PT_BR_Settings()
	PT_BR_Door()
	PT_BR_Interact_Menu()
	PT_BR_Atm()
end

LangPT_BR()
addLanguage()
--##############################################################################

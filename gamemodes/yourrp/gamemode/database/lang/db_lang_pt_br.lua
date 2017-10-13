--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

--db_lang_pt_br.lua

--##############################################################################
--LANGUAGE pt_br Portuguese
AddCSLuaFile( "pt_br/pt_br_all.lua" )

include( "pt_br/pt_br_all.lua" )

function LangPT_BR()
	lang.ineng = "Portuguese"
	lang.lang = "Português Brasil"
	lang.short = "pt-br"

	lang.translatedBy = "translated by"
	lang.translatedByName = "NyanHeavy and Brayan"

	PT_BR_All()
end

LangPT_BR()
addLanguage()
--##############################################################################

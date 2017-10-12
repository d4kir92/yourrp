--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

--db_lang_pl.lua

--##############################################################################
--LANGUAGE pl Polish
AddCSLuaFile( "pl/pl_all.lua" )

include( "pl/pl_all.lua" )

function LangPL()
	lang.ineng = "Polish"
	lang.lang = "Polskie"
	lang.short = "pl"

	lang.translatedBy = "translated by"
	lang.translatedByName = "CallsignCubGambino"

	PL_All()
end

LangPL()
addLanguage()
--##############################################################################

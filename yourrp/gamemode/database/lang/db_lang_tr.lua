--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

--db_lang_tr.lua

--##############################################################################
--LANGUAGE tr Turkish
AddCSLuaFile( "tr/tr_all.lua" )

include( "tr/tr_all.lua" )

function LangTR()
	lang.ineng = "Turkish"
	lang.lang = "Turkey"
	lang.short = "tr"

	lang.translatedBy = "translated by"
	lang.translatedByName = "CorayC and Kael"

	TR_All()
end

LangTR()
addLanguage()
--##############################################################################

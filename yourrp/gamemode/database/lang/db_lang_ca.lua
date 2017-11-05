--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

--db_lang_ca.lua

--##############################################################################
--LANGUAGE ca Catalan
AddCSLuaFile( "ca/ca_all.lua" )

include( "ca/ca_all.lua" )

function LangCA()
	lang.ineng = "Catalan"
	lang.lang = "Català"
	lang.short = "ca"

	lang.translatedBy = "translated by"
	lang.translatedByName = "azamio143"

	CA_All()
end

LangCA()
addLanguage()
--##############################################################################

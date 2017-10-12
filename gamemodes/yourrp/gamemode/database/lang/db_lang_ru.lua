--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

--db_lang_ru.lua

--##############################################################################
--LANGUAGE ru Russian
AddCSLuaFile( "ru/ru_all.lua" )

include( "ru/ru_all.lua" )

function LangRU()
	lang.ineng = "Russian"
	lang.lang = "Русский"
	lang.short = "ru"

	lang.translatedBy = "translated by"
	lang.translatedByName = "DropSpawn3rFree and roni_sl"

	RU_All()
end

LangRU()
addLanguage()
--##############################################################################

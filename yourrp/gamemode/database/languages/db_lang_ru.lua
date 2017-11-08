--Copyright (C) 2017 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

--db_lang_ru.lua

--##############################################################################
--LANGUAGE ru Russian
AddCSLuaFile( "ru/ru_all.lua" )

include( "ru/ru_all.lua" )

function LangRU()
	set_lang_string( "ineng", "Russian" )
	set_lang_string( "language", "Русский" )
	set_lang_string( "short", "ru" )

	set_lang_string( "translated_by", "translated by" )
	set_lang_string( "translated_by_name", "DropSpawn3rFree and roni_sl" )

	RU_All()
end

LangRU()
add_language()
--##############################################################################

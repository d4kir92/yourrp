--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

AddCSLuaFile("read_lang.lua" )
include( "read_lang.lua" )

function LangEN()
	read_lang( "resource/localization/_old/lang_en.properties" )
end

LangEN()
add_language()
--##############################################################################

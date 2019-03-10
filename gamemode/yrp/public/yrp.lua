--Copyright (C) 2017-2019 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

--[[ Here are the public functions (FOR DEVELOPERS) ]]

function GTS(id)
	return YRP.lang_string("LID_" .. id)
end

function GetTranslation(id)
	return GTS(id)
end

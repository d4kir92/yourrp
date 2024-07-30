--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
function YRP:RemoveUnallowedSymbols(input)
	local output = input
	output = string.Replace(output, "\"", "")
	output = string.Replace(output, "\'", "")
	output = string.Replace(output, "=", "")

	return output
end

function YRP:read_lang(filepath)
	if file.Exists(filepath, "GAME") then
		local _langFile = file.Read(filepath, "GAME")
		if not _langFile then return end
		_langFile = string.gsub(_langFile, "\r", "")
		local _rawLines = string.Explode("\n", _langFile, false)
		for key, value in pairs(_rawLines) do
			if string.len(value) > 0 then
				local _splitLine = string.Split(value, "=")
				if #_splitLine > 1 then
					local str_id = _splitLine[1]
					local str_trans = _splitLine[2]
					str_id = YRP:RemoveUnallowedSymbols(str_id)
					str_trans = YRP:RemoveUnallowedSymbols(str_trans)
					YRP:set_lang_string(str_id, str_trans)
				end
			end
		end
	else
		YRP:msg("note", "FILE NOT FOUND ( " .. tostring(filepath) .. " )")
	end
end

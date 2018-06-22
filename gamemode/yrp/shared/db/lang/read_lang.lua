--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

function RemoveUnallowedSymbols( input )
	local output = input
	output = string.Replace( output, "\"", "" )
	output = string.Replace( output, "\'", "" )
	output = string.Replace( output, "=", "" )

	return output
end

function read_lang( filepath )
	if file.Exists( filepath, "GAME" ) then
		local _langFile = file.Read( filepath, "GAME" )
		if(!_langFile) then return end
		_langFile = string.gsub( _langFile, "\r", "" )
		local _rawLines = string.Explode( "\n", _langFile, false )
		for key, value in pairs(_rawLines) do
			if string.len(value)>0 then
				local _splitLine = string.Split( value, "=" )
				if #_splitLine>1 then
					local str_id = _splitLine[1]
					local str_trans = _splitLine[2]
					str_id = RemoveUnallowedSymbols( str_id )
					str_trans = RemoveUnallowedSymbols( str_trans )
					set_lang_string( str_id, str_trans)
				end
			end
		end
	else
		printGM( "note", "FILE NOT FOUND (" .. tostring( filepath ) .. ")" )
	end
end

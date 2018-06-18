--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

function read_lang( filepath, default, init )
	if file.Exists( filepath, "GAME" ) then
		local _langFile = file.Read( filepath, "GAME" )
		if(!_langFile) then return end
		_langFile = string.gsub( _langFile, "\r", "")
		local _rawLines = string.Explode( "\n", _langFile, false )
		for key, value in pairs(_rawLines) do
			if string.len(value)>0 then
				local _splitLine = string.Split(value, "=")
				if #_splitLine>1 then
					set_lang_string( _splitLine[1], _splitLine[2], default, init )
				end
			end
		end
	else
		printGM( "note", "FILE NOT FOUND (" .. tostring( filepath ) .. ")" )
	end
end

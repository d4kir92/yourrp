function read_lang( filepath )
	if file.Exists( filepath, "GAME" ) then
		local _langFile = file.Read( filepath, "GAME" )
		if(!_langFile) then return end
		local _rawLines = string.Explode( "\n", _langFile, false )
		for key, value in pairs(_rawLines) do
			if string.len(value)>0 then
				local _splitLine = string.Split(value, "=")
				if #_splitLine>1 then
					set_lang_string(_splitLine[1], _splitLine[2])
				end
			end
		end
	else
		print( "FILE NOT FOUND")
	end
end

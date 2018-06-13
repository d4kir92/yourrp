function read_lang( filepath )
	if file.Exists( filepath, "GAME" ) then
<<<<<<< HEAD
		local _langFile = file.Read( filepath, "GAME" )
		if(!_langFile) then return end
=======
		print( "PIMMELPIMMELPIMMELPIMMELPIMMELPIMMELPIMMELPIMMELPIMMEL" )
		local _langFile = file.Read( filepath, "GAME" )
		if(!_langFile) then return end
		_langFile = string.gsub( _langFile, "\r", "")
>>>>>>> 34114a6771ae28fb4ef8571658bb596152f6ea9e
		local _rawLines = string.Explode( "\n", _langFile, false )
		for key, value in pairs(_rawLines) do
			if string.len(value)>0 then
				local _splitLine = string.Split(value, "=")
				if #_splitLine>1 then
<<<<<<< HEAD
=======
					print("[".._splitLine[1].."]", ":", "[".._splitLine[2].."]")
>>>>>>> 34114a6771ae28fb4ef8571658bb596152f6ea9e
					set_lang_string(_splitLine[1], _splitLine[2])
				end
			end
		end
	else
		print( "FILE NOT FOUND")
	end
<<<<<<< HEAD
end
=======
end
>>>>>>> 34114a6771ae28fb4ef8571658bb596152f6ea9e

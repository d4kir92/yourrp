function read_lang( filepath )
	if file.Exists( filepath, "GAME" ) then
		print( "PIMMELPIMMELPIMMELPIMMELPIMMELPIMMELPIMMELPIMMELPIMMEL" )
		local _langFile = file.Read( filepath, "GAME" )
		if(!_langFile) then return end
		local _rawLines = string.Explode( "\n", _langFile, false )
		for key, value in pairs(_rawLines) do
			
		end
		set_lang_string(_splitline[1], _splitline[2])
	else
		print( "FILE NOT FOUND")
	end
end
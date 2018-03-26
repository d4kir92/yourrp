--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

function combineTables( tab1, tab2 )
	for i, item in pairs( tab2 ) do
		table.insert( tab1, item )
	end
	for i, item in pairs( tab1 ) do
		if item == "" then
			table.RemoveByValue( tab1, "" )
		end
	end
	return tab1
end

function combineStringTables( str1, str2 )
	local _tab1 = string.Explode( ",", str1 )
	local _tab2 = string.Explode( ",", str2 )
	return combineTables( _tab1, _tab2 )
end

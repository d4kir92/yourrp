--Copyright (C) 2017-2022 D4KiR (https://www.gnu.org/licenses/gpl.txt)

function get_month()
	return tonumber(os.date( "%m" , os.time() ))
end

function get_year()
	return tonumber(os.date( "%Y" , os.time() ))
end

--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

local clock = Material( "icon16/clock.png" )

function hudRT( ply, color )
	local _clock = {}
	_clock.sec = os.date( "%S" )
	_clock.min = os.date( "%M" )
	_clock.hours = os.date( "%I" )
	if os.date( "%p" ) == "PM" then
		_clock.hours = tonumber( _clock.hours ) + 12
	end

	local _str = _clock.hours .. ":" .. _clock.min

	color = Color( 255, 255, 0, 200 )

	drawHUDElement( "rt", 100, 100, _str, clock, color )
end

function hudRTBR()
	drawHUDElementBr( "rt" )
end

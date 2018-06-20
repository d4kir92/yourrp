--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

local xp = Material( "icon16/user.png" )

function hudXP( ply, color )
	local _xptext = "" --lang_string( "level" ) .. " " .. 1 .. " (" .. 0 .. "%) " ..
	_xptext = ply:GetNWString( "groupName" ) .. " " .. ply:GetNWString( "roleName" )
	drawHUDElement( "xp", 0, 100, _xptext, xp, color )
end

function hudXPBR()
	drawHUDElementBr( "xp" )
end

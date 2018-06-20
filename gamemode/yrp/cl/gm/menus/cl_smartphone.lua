--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

local sp = sp or {}

function IsSpVisible()
	return sp.visible
end

function GetSpTable()
	return sp:GetTable()
end

function openSP()
	if LocalPlayer():GetNWBool( "bool_smartphone_system" ) then
		if isNoMenuOpen() and ( !sp.visible or sp.visible == nil ) then
			openMenu()
			local _w = ctrb( 560 )
			local _h = ctrb( 1000 )
			local _x = ScrW() - ( _w + ctrb( 25 ) )
			local _y = ScrH() - ( _h )
			sp = createSmartphone( nil, _w, _h, _x, _y )
			sp.visible = true
		end
	end
end

function closeSP()
	closeMenu()

	if sp != nil and sp.visible then
		sp.visible = false
		sp:Close()
	end
end

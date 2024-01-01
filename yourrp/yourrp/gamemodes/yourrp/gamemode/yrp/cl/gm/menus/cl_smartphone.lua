--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
local sp = sp or {}
function IsSpVisible()
	return sp.visible
end

function GetSpTable()
	return sp:GetTable()
end

function openSP()
	if GetGlobalYRPBool("bool_smartphone_system") and YRPIsNoMenuOpen() and (not sp.visible or sp.visible == nil) then
		YRPOpenMenu()
		local _w = ctrb(560)
		local _h = ctrb(1000)
		local _x = ScrW() - (_w + ctrb(25))
		local _y = ScrH() - _h
		sp = createSmartphone(nil, _w, _h, _x, _y)
		sp.visible = true
	end
end

function closeSP()
	YRPCloseMenu()
	if sp ~= nil and sp.visible then
		sp.visible = false
		sp:Close()
	end
end
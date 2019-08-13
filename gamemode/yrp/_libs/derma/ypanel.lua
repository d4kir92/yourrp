--Copyright (C) 2017-2019 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

local PANEL = {}

function PANEL:GetHeaderHeight()
	return self._headerheight
end

function PANEL:SetHeaderHeight(num)
	if isnumber(num) then
		self._headerheight = num
	else
		printGM("note", "SetHeaderHeight | num is not a number: " .. tostring(num) .. "!")
	end
end

function PANEL:Init()
	self._headerheight = 24
end

vgui.Register("YPanel", PANEL, "DPanel")

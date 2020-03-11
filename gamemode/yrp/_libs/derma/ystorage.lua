--Copyright (C) 2017-2020 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

local PANEL = {}

function PANEL:Paint(pw, ph)
	draw.RoundedBox(5, 0, 0, pw, ph, Color(0, 0, 0, 200))
end

function PANEL:SetStorage(s)
	self.suid = tonumber(s)
end

function PANEL:GetStorage()
	return tonumber(self.suid)
end

function PANEL:Init()
	self:SetTitle("")
end

vgui.Register("YStorage", PANEL, "DFrame")

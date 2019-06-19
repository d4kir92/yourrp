--Copyright (C) 2017-2019 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

local PANEL = {}

itemsize = itemsize or 100

function PANEL:Paint(pw, ph)
	draw.RoundedBox(10, 0, 0, pw, ph, Color(40, 40, 40, 254))
end

function PANEL:SetStorage(uid)
	self.storage:SetStorage(uid)
end

function PANEL:Init()
	self:SetTitle("")

	self.storage = createD("YStorage", self, tr(100), tr(100), 0, tr(50))
	self.storage:SetBag(self)

	self:MakePopup()
end

vgui.Register("YBag", PANEL, "DFrame")

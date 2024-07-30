--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
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
	self.storage = YRPCreateD("YStorage", self, YRP:ctr(100), YRP:ctr(100), 0, YRP:ctr(50))
	self.storage:SetBag(self)
	self:MakePopup()
end

vgui.Register("YBag", PANEL, "DFrame")

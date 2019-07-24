--Copyright (C) 2017-2019 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

local PANEL = {}

itemsize = itemsize or 100

function PANEL:Paint(pw, ph)
	draw.RoundedBox(5, 0, 0, pw, ph, Color(255, 255, 255, 255))
end

function PANEL:SetFixed(b)
	self.fixed = b
end

function PANEL:GetFixed()
	return self.fixed
end

function PANEL:SetTyp(t)
	self.typ = t
end

function PANEL:Init()
	self.fixed = false
	self:SetTyp("item")

	self:SetText("")

	self:Droppable("yrp_slot")
end

vgui.Register("YItem", PANEL, "DButton")

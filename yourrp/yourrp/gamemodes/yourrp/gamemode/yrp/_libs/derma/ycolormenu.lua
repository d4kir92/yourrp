--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
local PANEL = {}
function PANEL:ValueChanged(col)
	self._col = col
end

function PANEL:Init()
	self:SetTitle("LID_color")
	local ctrl = YRPCreateD("DColorMixer", self, self:GetWide() - YRP:ctr(40), self:GetTall() - YRP:ctr(40), YRP:ctr(20), YRP:ctr(20))
	ctrl.ValueChanged = function(ctr, color)
		self:ValueChanged(color)
	end

	self:ShowCloseButton(false)
	self._cm = ctrl
end

function PANEL:SetColor(col)
	if IsColor(col) then
		self._cm:SetColor(col)
	else
		YRP:msg("note", "Is not a color: " .. tostring(col))
	end
end

function PANEL:GetColor()
	return self._cm:GetColor()
end

function PANEL:Paint(pw, ph)
	draw.RoundedBox(0, 0, 0, pw, ph, Color(0, 0, 0, 200))
end

function PANEL:Think()
	local px, py = self:GetPos()
	local pw, ph = self:GetSize()
	self._cm:SetSize(pw - YRP:ctr(40), ph - YRP:ctr(40))
	local mx, my = gui.MousePos()
	if mx < px then
		self:Remove()
	elseif mx > px + pw then
		self:Remove()
	elseif my < py then
		self:Remove()
	elseif my > py + ph then
		self:Remove()
	end
end

vgui.Register("YColorMenu", PANEL, "YFrame")

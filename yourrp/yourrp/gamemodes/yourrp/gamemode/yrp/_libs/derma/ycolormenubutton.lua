--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
local PANEL = {}
function PANEL:ColorChanged(col)
end

-- Overrite
function PANEL:DoClick()
	local mx, my = gui.MousePos()
	local ctrl = YRPCreateD("YColorMenu", nil, YRP:ctr(600), YRP:ctr(600), mx - YRP:ctr(20), my - YRP:ctr(20))
	ctrl:MakePopup()
	ctrl:SetColor(self._col)
	ctrl.ValueChanged = function(sel, color)
		if self and self.ValueChanged then
			self:SetColor(color)
			self:ValueChanged(color)
		end
	end

	self._cm = ctrl
end

function PANEL:SetColor(col)
	if IsColor(col) or istable(col) then
		self._col = col
	else
		YRP:msg("note", "Is not a color: " .. tostring(col))
	end
end

function PANEL:Paint(pw, ph)
	if self._colormenu ~= nil and self._colormenu:IsValid() and self._colormenu:GetColor() ~= self._col then
		self._col = self._colormenu:GetColor()
	end

	draw.RoundedBox(ph / 2, 0, 0, pw, ph, self._col)
end

function PANEL:Init()
	self:SetText("")
	self._col = Color(0, 255, 0)
end

vgui.Register("YColorMenuButton", PANEL, "DButton")

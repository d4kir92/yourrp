--Copyright (C) 2017-2021 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

local PANEL = {}

function PANEL:ColorChanged(col)
	-- Overrite
end

function PANEL:DoClick()
	local mx, my = gui.MousePos()

	local ctrl = createD("YColorMenu", nil, YRP.ctr(600), YRP.ctr(600), mx - YRP.ctr(20), my - YRP.ctr(20))
	ctrl:MakePopup()
	ctrl:SetColor(self._col)

	ctrl.ValueChanged = function(ctrl, color)
		self:SetColor(color)
		self:ColorChanged(color)
	end

	self._cm = ctrl
end

function PANEL:SetColor(col)
	if IsColor(col) or istable(col) then
		self._col = col
	else
		YRP.msg("note", "Is not a color: " .. tostring(col))
	end
end

function PANEL:Paint(pw, ph)
	if self._colormenu != nil and self._colormenu:IsValid() then
		if self._colormenu:GetColor() != self._col then
			self._col = self._colormenu:GetColor()
		end
	end
	draw.RoundedBox(ph / 2, 0, 0, pw, ph, self._col)
end

function PANEL:Init()
	self:SetText("")
	self._col = Color(255, 0, 0)
end

vgui.Register("YColorMenuButton", PANEL, "DButton")

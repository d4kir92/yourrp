--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
local PANEL = {}
PANEL._text = ""
PANEL._hovertext = ""
PANEL._selectedtext = ""
PANEL._selected = false
function PANEL:GetText()
	return self._text
end

function PANEL:NewSetText(str)
	self._text = str
	self._hovertext = str
	self._selectedtext = str
	self:OldSetText("")
end

function PANEL:GetHoverText()
	return self._hovertext
end

function PANEL:SetHoverText(str)
	self._hovertext = str
end

function PANEL:GetSelectedText()
	return self._selectedtext
end

function PANEL:SetSelectedText(str)
	self._selectedtext = str
end

function PANEL:IsPressed()
	return self._selected
end

function PANEL:SetPressed(selected)
	self._selected = selected
end

function PANEL:Paint(pw, ph)
	hook.Run("YButtonPaint", self, pw, ph)
end

function PANEL:Init()
	if self.OldSetText == nil then
		self.OldSetText = self.SetText
		self.SetText = self.NewSetText
	end
end

vgui.Register("YButton", PANEL, "DButton")
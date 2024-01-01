--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
local PANEL = {}
PANEL._text = ""
function PANEL:GetText()
	return self._text
end

function PANEL:NewSetText(str)
	self._text = str
	self._hovertext = str
	self._selectedtext = str
	self:OldSetText("")
end

function PANEL:Paint(pw, ph)
	hook.Run("YLabelPaint", self, pw, ph)
end

function PANEL:Init()
	if self.OldSetText == nil then
		self.OldSetText = self.SetText
		self.SetText = self.NewSetText
	end
end

vgui.Register("YLabel", PANEL, "DLabel")
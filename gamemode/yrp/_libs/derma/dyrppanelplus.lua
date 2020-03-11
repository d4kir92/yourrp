--Copyright (C) 2017-2020 Arno Zura (https://www.gnu.org/licenses/gpl.txt)
local PANEL = {}

function PANEL:Init()
	self.header = createD("DPanel", self, self:GetWide(), YRP.ctr(50), 0, 0)
	self.header.text = "UNNAMED"

	function self:SetHeader(text)
		self.header.text = text
	end

	self.header.color = Color(255, 255, 255, 255)

	function self.header:Paint(pw, ph)
		draw.RoundedBox(0, 0, 0, pw, ph, self.color)
		surfaceText(YRP.lang_string(SQL_STR_OUT(self.text)), "Settings_Header", pw / 2, ph / 2, Color(0, 0, 0), 1, 1)
	end
end

function PANEL:INITPanel(derma)
	self.plus = createD(derma, self, self:GetWide(), self:GetTall() - self.header:GetTall(), 0, self.header:GetTall())

	function self:SetText(text)
		self.plus:SetText(text)
	end
end

function PANEL:Think()
	if self.header:GetWide() ~= self:GetWide() then
		self.header:SetWide(self:GetWide())
	end

	if self.plus:GetWide() ~= self:GetWide() then
		self.plus:SetWide(self:GetWide())
	end

	if self.plus:GetTall() ~= self:GetTall() - self.header:GetTall() then
		self.plus:SetTall(self:GetTall() - self.header:GetTall())
	end

	local _px, _py = self.plus:GetPos()

	if _py ~= self.header:GetTall() then
		self.plus:SetPos(0, self.header:GetTall())
	end
end

function PANEL:Paint(w, h)
	draw.RoundedBox(0, 0, 0, w, h, Color(255, 0, 0, 0))
end

vgui.Register("DYRPPanelPlus", PANEL, "Panel")

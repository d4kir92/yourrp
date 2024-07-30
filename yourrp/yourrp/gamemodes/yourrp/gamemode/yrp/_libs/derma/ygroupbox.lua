--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
local PANEL = {}
function PANEL:GetText()
	return self._text
end

function PANEL:SetText(t)
	self._text = t
end

function PANEL:GetHeaderHeight()
	return YRP:ctr(self._headerheight)
end

function PANEL:SetHeaderHeight(h)
	self._headerheight = h
end

function PANEL:GetBorder()
	return YRP:ctr(self._border)
end

function PANEL:SetBorder(b)
	self._border = b
end

-- Send To DPanelList
function PANEL:AddItem(p)
	self.con:AddItem(p)
	self:UpdateSize()
end

function PANEL:SetSpacing(s)
	self.con:SetSpacing(s)
end

function PANEL:AutoSize(b)
	self._autosize = b
	self:UpdateSize()
end

function PANEL:Paint(pw, ph)
	hook.Run("YGroupBox", self, pw, ph)
end

function PANEL:GetContent()
	return self.con
end

function PANEL:UpdateSize()
	if self._autosize then
		local h = 0
		for i, v in pairs(self:GetContent():GetItems()) do
			h = h + v:GetTall()
		end

		self:SetTall(h + 2 * self:GetBorder() + self:GetHeaderHeight())
	end

	self.con:SetSize(self:GetWide() - 2 * self:GetBorder(), self:GetTall() - 2 * self:GetBorder() - self:GetHeaderHeight())
	self.con:SetPos(self:GetBorder(), self:GetHeaderHeight() + self:GetBorder())
end

function PANEL:OnSizeChanged(pw, ph)
	self:UpdateSize()
end

function PANEL:Think()
end

function PANEL:Init()
	self._headerheight = 50
	self._border = 20
	self._text = "GroupBox"
	self._autosize = false
	self.con = YRPCreateD("DPanelList", self, 10, 10, 0, 0)
	self.con:EnableVerticalScrollbar()
	self.con:SetText("CONTENT")
	function self.con:Paint(pw, ph)
	end
	--draw.RoundedBox(0, 0, 0, pw, ph, Color( 255, 255, 255, 255 ) )
end

vgui.Register("YGroupBox", PANEL, "DPanel")

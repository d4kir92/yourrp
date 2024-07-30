--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
local PANEL = {}
function PANEL:Paint(pw, ph)
	draw.RoundedBox(0, 0, 0, pw, ph, Color(255, 100, 100, 10))
end

function PANEL:OnSizeChanged(nw, nh)
	local br = YRP:ctr(0)
	self.header:SetSize(nw, YRP:ctr(50))
	self.numberwang:SetSize(nw - 2 * br, nh - YRP:ctr(50) - 2 * br)
	self.numberwang:SetPos(br, YRP:ctr(50) + br)
end

function PANEL:GetHeader()
	return self.header.name or "Unnamed"
end

function PANEL:SetHeader(header)
	self.header.name = header
end

function PANEL:GetMin()
	return self.numberwang:GetMin()
end

function PANEL:GetMax()
	return self.numberwang:GetMax()
end

function PANEL:SetMin(min)
	self.numberwang:SetMin(min)
end

function PANEL:SetMax(max)
	self.numberwang:SetMax(max)
end

function PANEL:SetDecimals(max)
	self.numberwang:SetDecimals(max)
end

function PANEL:SetValue(val)
	val = math.Clamp(val, self:GetMin(), self:GetMax())
	self.numberwang:SetValue(val)
end

function PANEL:OnValueChanged(val)
end

function PANEL:Init()
	self.header = YRPCreateD("DPanel", self, 10, 10, 0, 0)
	function self.header:Paint(pw, ph)
		draw.SimpleText(YRP:trans(self.name) or "UNNAMED", "Y_" .. math.Round(ph / 3 * 2) .. "_500", pw / 2, ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

	self.numberwang = YRPCreateD("DNumberWang", self, 10, 10, 0, 10)
	self.numberwang.main = self
	function self.numberwang:PerformLayout()
		self:SetFontInternal("Y_18_500")
		self:SetPaintBackgroundEnabled(true)
		local color = YRPInterfaceValue("YFrame", "HI")
		local tcolor = YRPTextColor(color)
		self:SetTextColor(tcolor)
		self:SetFGColor(tcolor)
		self:SetBGColor(color)
		local s = math.floor(self:GetTall() * 0.5)
		self.Up:SetSize(s, s - 1)
		self.Up:AlignRight(3)
		self.Up:AlignTop(0)
		self.Down:SetSize(s, s - 1)
		self.Down:AlignRight(3)
		self.Down:AlignBottom(2)
	end

	function self.numberwang:OnValueChanged(val)
		val = tonumber(string.format("%0.2f", val))
		local newval = math.Clamp(val, self:GetMin(), self:GetMax())
		if newval == val then
			self.main:OnValueChanged(newval)
		else
			self:SetValue(newval)
			self:SetText(newval)
		end
	end
end

vgui.Register("YNumberWang", PANEL, "DPanel")

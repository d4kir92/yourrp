--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
local PANEL = {}
function PANEL:Init()
	self.header = YRPCreateD("DButton", self, 100, 50, 0, 0)
	self.header:SetText("")
	self.content = YRPCreateD("DPanelList", self, 100, 50, 0, 100)
	self.color = Color(0, 255, 0)
	self.color2 = Color(0, 255, 0)
	self.header:SetTall(self:GetHeaderHeight())
	self:SetTall(self:GetHeaderHeight())
	self.open = false
	self.panels = {}
	self.headerheight = 30
	self.spacing = 10
	self.headertext = "Header"
	self.locked = false
	function self:PaintHeader(pw, ph)
		local br = YRP.ctr(20)
		local _hl = 0
		if self.header:IsHovered() then
			_hl = 70
		end

		draw.RoundedBoxEx(0, 0, 0, pw, ph, Color(self.color.r + _hl, self.color.g + _hl, self.color.b + _hl, self.color.a), true, true, not self:IsOpen(), not self:IsOpen())
		draw.SimpleText(self.headertext, "Y_24_500", ph / 2, ph / 2, Color(255, 255, 255, 255), 0, 1)
		local icon = YRP.GetDesignIcon("64_angle-down")
		if self:IsOpen() then
			icon = YRP.GetDesignIcon("64_angle-up")
		end

		if IsNotNilAndNotFalse(icon) then
			surface.SetMaterial(icon)
			surface.SetDrawColor(Color(255, 255, 255, 255))
			surface.DrawTexturedRect(pw - ph, br, ph - 2 * br, ph - 2 * br)
		end

		if tobool(self.locked) then
			YRP.DrawIcon(YRP.GetDesignIcon("lock"), ph - YRP.ctr(8), ph - YRP.ctr(8), pw - 2 * ph, YRP.ctr(4), Color(0, 255, 0))
		end
	end

	function self.header:Paint(w, h)
		self:GetParent():PaintHeader(w, h)
	end

	function self.header:DoClick()
		if YRPPanelAlive(self:GetParent(), "self.header") and not self:GetParent().locked then
			self:GetParent().open = not self:GetParent().open
			self:GetParent():ReSize()
			self:GetParent():DoClick()
			self:GetParent():ClearContent()
		end
	end

	function self:PaintContent(w, h)
		draw.RoundedBox(0, 0, 0, w, h, self.color2)
	end

	function self.content:Paint(w, h)
		self:GetParent():PaintContent(w, h)
	end
end

function PANEL:ClearContent()
	local pnls = self:GetPanels()
	for i, panel in pairs(pnls) do
		table.RemoveByValue(pnls, panel)
		panel:Remove()
	end
end

function PANEL:IsOpen()
	return self.open
end

function PANEL:SetSpacing(num)
	self.spacing = num
end

function PANEL:GetSpacing()
	return self.spacing
end

function PANEL:ReSize()
	local _tab = self:GetPanels()
	self.height = 0
	for i, panel in pairs(_tab) do
		if i > 1 then
			self.height = self.height + panel:GetTall() + ctrb(self:GetSpacing())
		else
			self.height = self.height + panel:GetTall() + ctrb(2 * self:GetSpacing())
		end

		panel:SetPos(ctrb(self:GetSpacing()), self.height - panel:GetTall() - ctrb(self:GetSpacing()))
	end

	if self.open then
		self.content:SetPos(0, self:GetHeaderHeight())
		self.content:SetTall(self.height)
		self:SetTall(self:GetHeaderHeight() + self.height)
	else
		self.content:SetPos(0, self:GetHeaderHeight())
		self:SetTall(self:GetHeaderHeight())
	end

	local _grandparent = self:GetParent():GetParent()
	if _grandparent ~= nil then
		if _grandparent.ReSize ~= nil then
			_grandparent:ReSize()
		elseif _grandparent.Rebuild ~= nil then
			_grandparent:Rebuild()
		end
	end
end

function PANEL:GetHeaderHeight()
	return self.headerheight
end

function PANEL:SetHeaderHeight(height)
	self.headerheight = height
	self:ReSize()
end

function PANEL:GetHeader()
	return self.headertext
end

function PANEL:SetHeader(text)
	self.headertext = text
end

function PANEL:GetPanels()
	return self.panels
end

function PANEL:Add(panel)
	panel:SetParent(self.content)
	table.insert(self.panels, panel)
	self:ReSize()
end

function PANEL:Think()
	if self:GetWide() ~= self.content:GetWide() then
		self.content:SetWide(self:GetWide())
	end

	if self:GetWide() ~= self.header:GetWide() then
		self.header:SetWide(self:GetWide())
	end

	if self:GetTall() - self:GetHeaderHeight() ~= self.content:GetTall() or self.content:GetTall() < 0 then
		self.content:SetTall(self:GetTall() - self:GetHeaderHeight())
	end

	if self:GetHeaderHeight() ~= self.header:GetTall() then
		self.header:SetTall(self:GetHeaderHeight())
	end
end

function PANEL:Paint(w, h)
end

--draw.RoundedBox(0, 0, 0, w, h, Color( 0, 255, 0 ) )
vgui.Register("DYRPCollapsibleCategory", PANEL, "Panel")
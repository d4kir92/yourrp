--Copyright (C) 2017-2022 D4KiR (https://www.gnu.org/licenses/gpl.txt)
local PANEL = {}

function paintDBButton(self, pw, ph, color, text)
	local _color = color

	if self:IsHovered() then
		_color = Color( 255, 255, 0)
	end

	draw.RoundedBox(0, 0, 0, pw, ph, _color)
	surfaceText(text, "Y_24_500", pw / 2, ph / 2, Color( 255, 255, 255), 1, 1)
end

function PANEL:Init()
	local _pnl = self
	--[[ Header ]]
	--
	self.header = createD( "DPanel", self, self:GetWide(), YRP.ctr(50), 0, 0)

	function self.header:Paint(pw, ph)
		--draw.RoundedBox(0, 0, 0, pw, ph, Color( 255, 255, 0) )
	end

	self.panels = {}
	self.header.add = createD( "DButton", self.header, self:GetWide() / 5, self:GetTall(), 0, 0)
	self.header.add:SetText( "" )

	function self.header.add:Paint(pw, ph)
		paintDBButton(self, pw, ph, Color( 0, 255, 0), "+" )
	end

	function self.header.add:DoClick()
		_pnl:AddFunction()
	end

	self.header.rem = createD( "DButton", self.header, self:GetWide() / 5, self:GetTall(), 4 * (self:GetWide() / 5), 0)
	self.header.rem:SetText( "" )

	function self.header.rem:Paint(pw, ph)
		if _pnl.uid ~= nil then
			paintDBButton(self, pw, ph, Color( 255, 0, 0), "-" )
		end
	end

	function self.header.rem:DoClick()
		if _pnl.uid ~= nil then
			_pnl:RemoveFunction()
			_pnl.uid = nil
		end
	end

	function self.header:Think()
		local _w = self:GetWide()
		local _x = self.rem:GetPos()

		if _x ~= 3 * (_w / 5) then
			self.rem:SetPos(4 * (_w / 5), 0)
		end

		if self.add:GetWide() ~= _w / 5 then
			self.add:SetWide(_w / 5)
		end

		if self.rem:GetWide() ~= _w / 5 then
			self.rem:SetWide(_w / 5)
		end

		if self.add:GetTall() ~= self:GetTall() then
			self.add:SetTall(self:GetTall() )
		end

		if self.rem:GetTall() ~= self:GetTall() then
			self.rem:SetTall(self:GetTall() )
		end
	end

	--[[ List Header ]]
	--
	self.listheader = createD( "DPanel", self, self:GetWide(), YRP.ctr(50), 0, 0)
	self.listheader.textpre = ""
	self.listheader.text = "UNNAMED"
	self.listheader.textpos = ""

	function self.listheader:Paint(pw, ph)
		local color = Color( 0, 255, 0)
		draw.RoundedBox(0, 0, 0, pw, ph, Color( 0, 255, 0) )
		surfaceText(self.textpre .. " " .. YRP.lang_string(self.text) .. " " .. self.textpos, "Y_24_500", pw / 2, ph / 2, TextColor( color ), 1, 1)
	end

	--[[ List ]]
	--
	self.list = createD( "DPanelList", self, self:GetWide(), self:GetTall() - YRP.ctr(110), 0, 0)
	self.list:EnableVerticalScrollbar(true)
	self.list:SetSpacing(2)

	--self.list:SetNoSizing(true)
	function self.list:Paint(pw, ph)
		draw.RoundedBox(0, 0, 0, pw, ph, Color( 100, 100, 100) )
	end

	--[[ Public functions ]]
	--
	function self:SetListHeader(text, pre, pos)
		self.listheader.text = text

		if pre ~= nil then
			self.listheader.textpre = pre
		end

		if pos ~= nil then
			self.listheader.textpos = pos
		end
	end

	function self:ReSize()
		local _tab = self.panels
		self.height = 0

		for i, panel in pairs(_tab) do
			if i > 1 then
				self.height = self.height + panel:GetTall()
			else
				self.height = self.height + panel:GetTall()
			end

			panel:SetPos(0, self.height - panel:GetTall() )
		end
	end

	function self:Add(panel)
		panel:SetParent(self.list)
		self.list:AddItem(panel)
	end

	function self:AddEntry(tbl)
		local _new = createD( "DButton", nil, self:GetWide(), YRP.ctr(50), 0, 0)
		_new:SetText( "" )
		_new.tbl = tbl

		function _new:Paint(pw, ph)
			local _color = Color( 255, 255, 255)

			if self:IsHovered() or _pnl.uid == self.tbl.uniqueID then
				_color = Color( 255, 255, 0)
			end

			draw.RoundedBox(0, 0, 0, pw, ph, _color)
			surfaceText(self.tbl.name, "Y_24_500", pw / 2, ph / 2, TextColor( _color ), 1, 1)
		end

		function _new:DoClick()
			_pnl.edf(self.tbl)
			_pnl.uid = self.tbl.uniqueID
			_pnl.name = self.tbl.name or "unnamed"
		end

		self:Add(_new)
	end

	function self:GetEditFunc()
		return self.edf
	end

	function self:SetEditFunc(func)
		self.edf = func
	end

	function self:GetEditArea()
		return self.editarea
	end

	function self:SetEditArea(panel)
		self.editarea = panel
	end
end

function PANEL:Think()
	local _x = self.listheader:GetPos()

	if YRP.ctr(60) ~= _x then
		self.listheader:SetPos(0, YRP.ctr(60) )
	end

	_x = self.list:GetPos()

	if YRP.ctr(110) ~= _x then
		self.list:SetPos(0, YRP.ctr(110) )
	end

	if self:GetWide() ~= self.header:GetWide() then
		self.header:SetWide(self:GetWide() )
	end

	if self:GetWide() ~= self.listheader:GetWide() then
		self.listheader:SetWide(self:GetWide() )
	end

	if self:GetWide() ~= self.list:GetWide() then
		self.list:SetWide(self:GetWide() )
	end

	if self.list:GetTall() ~= self:GetTall() - YRP.ctr(120) then
		self.list:SetTall(self:GetTall() - YRP.ctr(120) )
	end
end

function PANEL:Paint(w, h)
	--draw.RoundedBox(0, 0, 0, w, h, Color( 255, 0, 0) )
end

vgui.Register( "DYRPDBList", PANEL, "Panel" )

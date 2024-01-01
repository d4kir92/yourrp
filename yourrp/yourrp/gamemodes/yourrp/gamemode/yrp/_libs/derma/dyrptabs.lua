--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
local PANEL = {}
function PANEL:Init()
	self.color_sel = Color(0, 0, 255, 255)
	self.color_uns = Color(255, 255, 0)
	function self:SetSelectedColor(col)
		self.color_sel = col
	end

	function self:SetUnselectedColor(col)
		self.color_uns = col
	end

	self.tabs = {}
	self.slider = YRPCreateD("DHorizontalScroller", self, self:GetWide(), self:GetTall(), 0, 0)
	self.OldSetSize = self.OldSetSize or self.SetSize
	function self:SetSize(w, h)
		self:OldSetSize(w, h)
		self.slider:SetSize(w, h)
	end

	function self.slider:Paint(pw, ph)
	end

	--draw.RoundedBox(0, 0, 0, pw, ph, Color( 0, 255, 0 ) )
	function self:AddTab(str, tbl)
		surface.SetFont("Y_24_500")
		local _tw, _th = surface.GetTextSize(str)
		local _w = self:GetTall()
		if _tw > _w then
			_w = _tw
		end

		_w = _w * 1.4
		local _tmp = YRPCreateD("DButton", self, _w, self:GetTall(), _x, ctrb(0))
		_tmp.tbl = tbl
		_tmp:SetText("")
		_tmp.name = str
		_tmp.selected = false
		_tmp.base = self
		function _tmp:Paint(pw, ph)
			if self:IsHovered() then
				draw.RoundedBoxEx(0, 0, 0, pw, ph, Color(255, 255, 255, 254), true, true)
			end

			draw.RoundedBoxEx(0, 0, 0, pw, ph, YRPInterfaceValue("YFrame", "HB"), true, true)
			local _color = Color(255, 255, 255, 255)
			local font = "Y_24_500"
			if self.selected then
				font = "Y_24_500"
				_color = YRPInterfaceValue("YButton", "SC")
				draw.RoundedBox(0, YRP.ctr(2), ph - YRP.ctr(4 + 2), pw - 2 * YRP.ctr(2), YRP.ctr(4), _color)
			end

			draw.SimpleText(self.name, font, pw / 2, ph / 2, _color, 1, 1)
		end

		function _tmp:DoClick()
			for i, tab in pairs(_tmp.base.tabs) do
				tab.selected = false
			end

			self.selected = true
			self:Click()
		end

		table.insert(self.tabs, _tmp)
		self.slider:AddPanel(_tmp)

		return _tmp
	end
end

function PANEL:Think()
end

function PANEL:Paint(w, h)
end

--draw.RoundedBox(0, 0, 0, w, h, Color( 0, 255, 0 ) )
vgui.Register("DYRPTabs", PANEL, "Panel")
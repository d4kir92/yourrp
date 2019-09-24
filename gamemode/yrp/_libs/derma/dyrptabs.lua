--Copyright (C) 2017-2019 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

local PANEL = {}

function PANEL:Init()
	self.color_sel = Color(0, 0, 255)
	self.color_uns = Color(255, 255, 0)

	function self:SetSelectedColor(col)
		self.color_sel = col
	end

	function self:SetUnselectedColor(col)
		self.color_uns = col
	end

	self.tabs = {}

	self.slider = createD("DHorizontalScroller", self, self:GetWide(), self:GetTall(), 0, 0)

	self.OldSetSize = self.OldSetSize or self.SetSize
	function self:SetSize(w, h)
		self:OldSetSize(w, h)
		self.slider:SetSize(w, h)
	end

	function self.slider:Paint(pw, ph)
		--draw.RoundedBox(0, 0, 0, pw, ph, Color(255, 0, 0))
	end

	function self:AddTab(str, tbl)
		surface.SetFont("roleInfoHeader")
		local _tw, _th = surface.GetTextSize(str)
		local _w = self:GetTall()

		if _tw > _w then
			_w = _tw
		end

		_w = _w * 1.4
		local _tmp = createD("DButton", self, _w, self:GetTall(), _x, ctrb(0))
		_tmp.tbl = tbl
		_tmp:SetText("")
		_tmp.name = str
		_tmp.selected = false
		_tmp.base = self
		function _tmp:Paint(pw, ph)
			local _br = 4
			local _color = _tmp.base.color_uns

			if self.selected then
				_color = _tmp.base.color_sel
			end

			if self:IsHovered() then
				draw.RoundedBoxEx((ph / 2) - ctrb(_br), ctrb(_br), ctrb(_br), pw - ctrb(2 * _br), ph - ctrb(_br), Color(255, 255, 255, 254), true, true)
			end

			draw.RoundedBoxEx((ph / 2) - ctrb(_br), ctrb(_br), ctrb(_br), pw - ctrb(2 * _br), ph - ctrb(_br), _color, true, true)
			surfaceText(self.name, "roleInfoHeader", pw / 2, ph / 2, Color(255, 255, 255), 1, 1)
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
	--draw.RoundedBox(0, 0, 0, w, h, Color(255, 0, 0))
end

vgui.Register("DYRPTabs", PANEL, "Panel")

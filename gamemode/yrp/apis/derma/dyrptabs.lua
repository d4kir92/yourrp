--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )
local PANEL = {}

function PANEL:Init()
	self.tabx = 0
	self.color_sel = Color(0, 0, 255)
	self.color_uns = Color(255, 255, 0)

	function self:SetSelectedColor(col)
		self.color_sel = col
	end

	function self:SetUnselectedColor(col)
		self.color_uns = col
	end

	self.tabs = {}

	function self:AddTab(str, tbl)
		local _x = 0

		for i, tab in pairs(self.tabs) do
			_x = _x + tab:GetWide()
		end

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

		if _x == 0 then
			_tmp.selected = true
		end

		self.tabx = _x + _w

		function _tmp:Paint(pw, ph)
			local _br = 4
			local _color = self:GetParent().color_uns

			if self.selected then
				_color = self:GetParent().color_sel
			end

			if self:IsHovered() then
				draw.RoundedBox((ph / 2) - ctrb(_br), ctrb(_br), ctrb(_br), pw - ctrb(2 * _br), ph - ctrb(_br), Color(255, 255, 255, 254), true, true)
			end

			draw.RoundedBoxEx((ph / 2) - ctrb(_br), ctrb(_br), ctrb(_br), pw - ctrb(2 * _br), ph - ctrb(_br), _color, true, true)
			surfaceText(self.name, "roleInfoHeader", pw / 2, ph / 2, Color(255, 255, 255), 1, 1)
		end

		function _tmp:DoClick()
			for i, tab in pairs(self:GetParent().tabs) do
				tab.selected = false
			end

			self.selected = true
			self:Click()
		end

		table.insert(self.tabs, _tmp)

		return _tmp
	end
end

function PANEL:Think()
end

function PANEL:Paint(w, h)
	--draw.RoundedBox( 0, 0, 0, w, h, Color( 255, 0, 0 ) )
end

vgui.Register("DYRPTabs", PANEL, "Panel")

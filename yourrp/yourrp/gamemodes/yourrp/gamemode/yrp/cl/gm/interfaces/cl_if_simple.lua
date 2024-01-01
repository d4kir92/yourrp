--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
local yrpr = 16
hook.Add(
	"YFramePaint",
	"YFrame_Material",
	function(self, pw, ph, tab)
		tab = tab or {}
		if YRPGetInterfaceDesign() == "Material" then
			local hh = 24
			if self.GetHeaderHeight ~= nil then
				hh = self:GetHeaderHeight()
			end

			local r = YRP.ctr(yrpr)
			if self.rad then
				r = self.rad
			end

			draw.RoundedBoxEx(r, 0, 0, pw, hh, YRPInterfaceValue("YFrame", "HB"), true, true)
			draw.RoundedBoxEx(r, 0, hh, pw, ph - hh, YRPInterfaceValue("YFrame", "BG"), false, false, true, true) --YRPInterfaceValue( "YFrame", "BG" ) )
			if self.GetTitle ~= nil then
				draw.SimpleText(YRP.trans(self:GetTitle()), "Y_18_500", hh / 2, hh / 2, YRPInterfaceValue("YFrame", "HT"), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			end

			return true
		end
	end
)

hook.Add(
	"YButtonPaint",
	"YButton_Material",
	function(self, pw, ph, tab)
		tab = tab or {}
		tab.x = tab.x or 0
		tab.y = tab.y or 0
		if YRPGetInterfaceDesign() == "Material" then
			local color = YRPInterfaceValue("YButton", "NC")
			local tcolor = YRPInterfaceValue("YButton", "NT")
			if self:IsDown() or self:IsPressed() then
				if not self.clicked then
					self.clicked = true
					surface.PlaySound("garrysmod/ui_click.wav")
				end

				color.r = color.r - 50
				color.g = color.g - 50
				color.b = color.b - 50
			elseif self:IsHovered() then
				if not self.hovering then
					self.hovering = true
					surface.PlaySound("garrysmod/ui_hover.wav")
				end

				color.r = color.r + 50
				color.g = color.g + 50
				color.b = color.b + 50
			else
				tcolor.r = 255
				tcolor.g = 255
				tcolor.b = 255
				if tab.force then
					color = Color(255, 255, 255, 0)
				end

				self.hovering = false
				self.clicked = false
			end

			color = tab.color or color
			tcolor = tab.tcolor or tcolor
			local r = YRP.ctr(yrpr)
			if self.rad then
				r = self.rad
			end

			draw.RoundedBox(r, tab.x, tab.y, pw, ph, Color(color.r, color.g, color.b, color.a))
			draw.SimpleText(YRP.trans(tab.text or self:GetText()), "Y_18_500", tab.x + pw / 2, tab.y + ph / 2, YRPTextColor(color), tab.ax or TEXT_ALIGN_CENTER, tab.ay or TEXT_ALIGN_CENTER)

			return true
		end
	end
)

local col1 = Color(197, 52, 52)
local col2 = Color(206, 111, 111)
hook.Add(
	"YButtonRPaint",
	"YButtonR_Material",
	function(self, pw, ph, tab)
		tab = tab or {}
		tab.x = tab.x or 0
		tab.y = tab.y or 0
		if YRPGetInterfaceDesign() == "Material" then
			local color = Color(126, 126, 126)
			local tcolor = YRPInterfaceValue("YButton", "NT")
			if self:IsDown() or self:IsPressed() then
				if not self.clicked then
					self.clicked = true
					surface.PlaySound("garrysmod/ui_click.wav")
				end

				color = col1
			elseif self:IsHovered() then
				if not self.hovering then
					self.hovering = true
					surface.PlaySound("garrysmod/ui_hover.wav")
				end

				color = col2
			else
				tcolor.r = 255
				tcolor.g = 255
				tcolor.b = 255
				if tab.force then
					color = Color(255, 255, 255, 0)
				end

				self.hovering = false
				self.clicked = false
			end

			color = tab.color or color
			tcolor = tab.tcolor or tcolor
			local r = YRP.ctr(yrpr)
			if self.rad then
				r = self.rad
			end

			draw.RoundedBox(r, tab.x, tab.y, pw, ph, Color(color.r, color.g, color.b, color.a))
			draw.SimpleText(YRP.trans(tab.text or self:GetText()), "Y_18_500", tab.x + pw / 2, tab.y + ph / 2, YRPTextColor(color), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

			return true
		end
	end
)

local col3 = Color(126, 126, 126)
local col4 = Color(38, 222, 129)
local col5 = Color(111, 206, 111)
hook.Add(
	"YButtonAPaint",
	"YButtonA_Material",
	function(self, pw, ph, tab)
		tab = tab or {}
		if YRPGetInterfaceDesign() == "Material" then
			local color = col3
			local tcolor = tab.tcolor
			if self:IsDown() or self:IsPressed() then
				if not self.clicked then
					self.clicked = true
					surface.PlaySound("garrysmod/ui_click.wav")
				end

				color = col4
			elseif self:IsHovered() then
				if not self.hovering then
					self.hovering = true
					surface.PlaySound("garrysmod/ui_hover.wav")
				end

				color = col5
			else
				if tab.force then
					color = Color(255, 255, 255, 0)
				end

				self.hovering = false
				self.clicked = false
			end

			color = tab.color or color
			if tcolor == nil then
				tcolor = YRPTextColor(color) -- YRPInterfaceValue( "YButton", "NT" )
			end

			local r = YRP.ctr(yrpr)
			if self.rad then
				r = self.rad
			end

			draw.RoundedBox(r, 0, 0, pw, ph, Color(color.r, color.g, color.b, color.a))
			draw.SimpleText(YRP.trans(tab.text or self:GetText()), "Y_18_500", pw / 2, ph / 2, tcolor or Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

			return true
		end
	end
)

hook.Add(
	"YLabelPaint",
	"YLabel_Material",
	function(self, pw, ph, tab)
		tab = tab or {}
		if YRPGetInterfaceDesign() == "Material" then
			local color = YRPInterfaceValue("YFrame", "HI")
			local tcolor = YRPInterfaceValue("YFrame", "HT")
			local r = YRP.ctr(yrpr)
			if self.rad then
				r = self.rad
			end

			draw.RoundedBox(r, 0, 0, pw, ph, Color(color.r, color.g, color.b, 255))
			local ax = tab.ax or TEXT_ALIGN_CENTER
			local ay = tab.ay or TEXT_ALIGN_CENTER
			local tx = pw / 2
			if ax == 0 then
				tx = YRP.ctr(20)
			end

			local ty = ph / 2
			if ay == 3 then
				ty = YRP.ctr(20)
			end

			draw.SimpleText(YRP.trans(self:GetText()), "Y_24_500", tx, ty, tcolor, ax, ay)

			return true
		end
	end
)

local col6 = Color(50, 50, 50)
hook.Add(
	"YTextFieldPaint",
	"YTextFieldPaint_Material",
	function(self, pw, ph, tab)
		tab = tab or {}
		if YRPGetInterfaceDesign() == "Material" then
			local color = col6
			local tcolor = YRPInterfaceValue("YFrame", "HT")
			draw.RoundedBox(0, 0, 0, pw, ph, Color(color.r, color.g, color.b, 255))
			local ax = tab.ax or TEXT_ALIGN_CENTER
			local ay = tab.ay or TEXT_ALIGN_CENTER
			local tx = pw / 2
			if ax == 0 then
				tx = YRP.ctr(20)
			end

			local ty = ph / 2
			if ay == 3 then
				ty = YRP.ctr(20)
			end

			draw.SimpleText(YRP.trans(self:GetText()), "Y_18_500", tx, ty, tcolor, ax, ay)

			return true
		end
	end
)

hook.Add(
	"YPanelPaint",
	"YPanel_Material",
	function(self, pw, ph, tab)
		tab = tab or {}
		if YRPGetInterfaceDesign() == "Material" then
			local color = tab.color or YRPInterfaceValue("YFrame", "HI")
			local r = YRP.ctr(yrpr)
			if self.rad then
				r = self.rad
			end

			draw.RoundedBox(r, 0, 0, pw, ph, Color(color.r, color.g, color.b, 255))

			return true
		end
	end
)

hook.Add(
	"YAddPaint",
	"YAdd_Material",
	function(self, pw, ph, tab)
		tab = tab or {}
		if YRPGetInterfaceDesign() == "Material" then
			local color = Color(100, 205, 100)
			if self:IsDown() or self:IsPressed() then
				color.r = color.r - 50
				color.g = color.g - 50
				color.b = color.b - 50
			elseif self:IsHovered() then
				color.r = color.r + 50
				color.g = color.g + 50
				color.b = color.b + 50
			end

			if YRP.GetDesignIcon("circle") ~= nil then
				surface.SetDrawColor(color)
				surface.SetMaterial(YRP.GetDesignIcon("circle"))
				surface.DrawTexturedRect(0, 0, pw, ph)
			end

			local br = ph * 0.1
			if YRP.GetDesignIcon("add") ~= nil then
				surface.SetDrawColor(Color(255, 255, 255, 255))
				surface.SetMaterial(YRP.GetDesignIcon("add"))
				surface.DrawTexturedRect(br, br, pw - br * 2, ph - br * 2)
			end

			return true
		end
	end
)

hook.Add(
	"YRemovePaint",
	"YRemove_Material",
	function(self, pw, ph, tab)
		tab = tab or {}
		if YRPGetInterfaceDesign() == "Material" then
			local color = Color(126, 126, 126)
			if self:IsDown() or self:IsPressed() then
				color = Color(197, 52, 52)
			elseif self:IsHovered() then
				color = Color(206, 111, 111)
			end

			if YRP.GetDesignIcon("circle") ~= nil then
				surface.SetDrawColor(color)
				surface.SetMaterial(YRP.GetDesignIcon("circle"))
				surface.DrawTexturedRect(0, 0, pw, ph)
			end

			local br = ph * 0.1
			if YRP.GetDesignIcon("remove") ~= nil then
				surface.SetDrawColor(Color(255, 255, 255, 255))
				surface.SetMaterial(YRP.GetDesignIcon("remove"))
				surface.DrawTexturedRect(br, br, pw - br * 2, ph - br * 2)
			end

			return true
		end
	end
)

hook.Add(
	"YClosePaint",
	"YClose_Material",
	function(self, pw, ph, tab)
		tab = tab or {}
		if YRPGetInterfaceDesign() == "Material" then
			self.color = Color(205, 100, 100)
			if self:IsDown() or self:IsPressed() then
				self.color.r = self.color.r - 50
				self.color.g = self.color.g - 50
				self.color.b = self.color.b - 50
			elseif self:IsHovered() then
				self.color.r = self.color.r + 50
				self.color.g = self.color.g + 50
				self.color.b = self.color.b + 50
			else
				self.color = Color(255, 255, 255, 0)
			end

			if YRP.GetDesignIcon("circle") ~= nil then
				surface.SetDrawColor(self.color)
				surface.SetMaterial(YRP.GetDesignIcon("circle"))
				surface.DrawTexturedRect(0, 0, pw, ph)
			end

			local br = ph * 0.1
			if YRP.GetDesignIcon("clear") ~= nil then
				surface.SetDrawColor(Color(255, 255, 255, 255))
				surface.SetMaterial(YRP.GetDesignIcon("clear"))
				surface.DrawTexturedRect(br, br, pw - br * 2, ph - br * 2)
			end

			return true
		end
	end
)

hook.Add(
	"YMaxPaint",
	"YMax_Material",
	function(self, pw, ph, tab)
		tab = tab or {}
		if YRPGetInterfaceDesign() == "Material" then
			local color = Color(205, 205, 100)
			if self:IsDown() or self:IsPressed() then
				color.r = color.r - 50
				color.g = color.g - 50
				color.b = color.b - 50
			elseif self:IsHovered() then
				color.r = color.r + 50
				color.g = color.g + 50
				color.b = color.b + 50
			else
				color = Color(255, 255, 255, 0)
			end

			if YRP.GetDesignIcon("circle") ~= nil then
				surface.SetDrawColor(color)
				surface.SetMaterial(YRP.GetDesignIcon("circle"))
				surface.DrawTexturedRect(0, 0, pw, ph)
			end

			local br = ph * 0.1
			if YRP.GetDesignIcon("mat_square") ~= nil then
				surface.SetDrawColor(Color(255, 255, 255, 255))
				surface.SetMaterial(YRP.GetDesignIcon("mat_square"))
				surface.DrawTexturedRect(br, br, pw - br * 2, ph - br * 2)
			end

			return true
		end
	end
)

local color1 = Color(40, 40, 40, 255)
local color2 = Color(60, 60, 60, 255)
local color3 = Color(20, 20, 20, 255)
hook.Add(
	"YGroupBoxPaint",
	"YGroupBox_Material",
	function(self, pw, ph, tab)
		tab = tab or {}
		if YRPGetInterfaceDesign() == "Material" then
			draw.RoundedBox(0, 0, 0, pw, ph, color1)
			draw.RoundedBox(0, 0, 0, pw, self:GetHeaderHeight(), color2)
			local x, y = self.con:GetPos()
			draw.RoundedBox(0, x, y, self.con:GetWide(), self.con:GetTall(), color3)
			draw.SimpleText(YRP.trans(tab.text or self:GetText()), "Y_18_500", pw / 2, self:GetHeaderHeight() / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

			return true
		end
	end
)
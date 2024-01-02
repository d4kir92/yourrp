--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
local yrpr = 21
hook.Add(
	"YFramePaint",
	"YFrame_Blur",
	function(self, pw, ph, tab)
		tab = tab or {}
		if YRPGetInterfaceDesign() == "Blur" then
			local hh = 24
			if self.GetHeaderHeight ~= nil then
				hh = self:GetHeaderHeight()
			end

			YRPDrawRectBlur(self, 0, 0, pw, ph, 5) --draw.RoundedBox(0, 0, 0, pw, hh, YRPInterfaceValue( "YFrame", "HB" ) )
			draw.RoundedBox(0, 0, 0, pw, hh, YRPInterfaceValue("YFrame", "HB")) --YRPInterfaceValue( "YFrame", "BG" ) )
			if self.GetTitle ~= nil then
				draw.SimpleText(YRP.trans(self:GetTitle()), "Y_18_500", hh / 2, hh / 2, YRPInterfaceValue("YFrame", "HT"), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			end

			return true
		end
	end
)

hook.Add(
	"YButtonPaint",
	"YButton_Blur",
	function(self, pw, ph, tab)
		tab = tab or {}
		if YRPGetInterfaceDesign() == "Blur" then
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
				self.hovering = false
				self.clicked = false
			end

			color = tab.color or color
			tcolor = tab.tcolor or tcolor
			draw.RoundedBox(YRP.ctr(yrpr), 0, 0, pw, ph, Color(color.r, color.g, color.b, color.a))
			draw.SimpleText(YRP.trans(tab.text or self:GetText()), "Y_18_500", pw / 2, ph / 2, tcolor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

			return true
		end
	end
)

hook.Add(
	"YButtonAPaint",
	"YButtonA_Blur",
	function(self, pw, ph, tab)
		tab = tab or {}
		if YRPGetInterfaceDesign() == "Blur" then
			local color = Color(126, 126, 126)
			local tcolor = YRPInterfaceValue("YButton", "NT")
			if self:IsDown() or self:IsPressed() then
				if not self.clicked then
					self.clicked = true
					surface.PlaySound("garrysmod/ui_click.wav")
				end

				color = Color(52, 197, 52)
			elseif self:IsHovered() then
				if not self.hovering then
					self.hovering = true
					surface.PlaySound("garrysmod/ui_hover.wav")
				end

				color = Color(111, 206, 111)
			else
				self.hovering = false
				self.clicked = false
			end

			color = tab.color or color
			tcolor = tab.tcolor or tcolor
			draw.RoundedBox(YRP.ctr(yrpr), 0, 0, pw, ph, Color(color.r, color.g, color.b, 255))
			draw.SimpleText(YRP.trans(tab.text or self:GetText()), "Y_18_500", pw / 2, ph / 2, tcolor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

			return true
		end
	end
)

hook.Add(
	"YButtonRPaint",
	"YButtonR_Blur",
	function(self, pw, ph, tab)
		tab = tab or {}
		if YRPGetInterfaceDesign() == "Blur" then
			local color = Color(126, 126, 126)
			local tcolor = YRPInterfaceValue("YButton", "NT")
			if self:IsDown() or self:IsPressed() then
				if not self.clicked then
					self.clicked = true
					surface.PlaySound("garrysmod/ui_click.wav")
				end

				color = Color(197, 52, 52)
			elseif self:IsHovered() then
				if not self.hovering then
					self.hovering = true
					surface.PlaySound("garrysmod/ui_hover.wav")
				end

				color = Color(206, 111, 111)
			else
				self.hovering = false
				self.clicked = false
			end

			color = tab.color or color
			tcolor = tab.tcolor or tcolor
			draw.RoundedBox(YRP.ctr(yrpr), 0, 0, pw, ph, Color(color.r, color.g, color.b, color.a))
			draw.SimpleText(YRP.trans(tab.text or self:GetText()), "Y_18_500", pw / 2, ph / 2, tcolor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

			return true
		end
	end
)

hook.Add(
	"YLabelPaint",
	"YLabel_Blur",
	function(self, pw, ph, tab)
		tab = tab or {}
		if YRPGetInterfaceDesign() == "Blur" then
			local tcolor = YRPInterfaceValue("YFrame", "HT")
			draw.RoundedBox(0, 0, 0, pw, ph, Color(255, 255, 255, 10))
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
	"YTextFieldPaint",
	"YTextFieldPaint_Blur",
	function(self, pw, ph, tab)
		tab = tab or {}
		if YRPGetInterfaceDesign() == "Blur" then
			local tcolor = YRPInterfaceValue("YFrame", "HT")
			draw.RoundedBox(0, 0, 0, pw, ph, Color(255, 255, 255, 10))
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
	"YPanel_Blur",
	function(self, pw, ph, tab)
		tab = tab or {}
		if YRPGetInterfaceDesign() == "Blur" then
			draw.RoundedBox(0, 0, 0, pw, ph, Color(255, 255, 255, 10))

			return true
		end
	end
)

hook.Add(
	"YAddPaint",
	"YAdd_Blur",
	function(self, pw, ph, tab)
		tab = tab or {}
		if YRPGetInterfaceDesign() == "Blur" then
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

			surface.SetDrawColor(color)
			surface.SetMaterial(YRP.GetDesignIcon("circle"))
			surface.DrawTexturedRect(0, 0, pw, ph)
			local br = ph * 0.1
			surface.SetDrawColor(Color(255, 255, 255, 255))
			surface.SetMaterial(YRP.GetDesignIcon("add"))
			surface.DrawTexturedRect(br, br, pw - br * 2, ph - br * 2)

			return true
		end
	end
)

hook.Add(
	"YRemovePaint",
	"YRemove_Blur",
	function(self, pw, ph, tab)
		tab = tab or {}
		if YRPGetInterfaceDesign() == "Blur" then
			local color = Color(205, 100, 100)
			if self:IsDown() or self:IsPressed() then
				color.r = color.r - 50
				color.g = color.g - 50
				color.b = color.b - 50
			elseif self:IsHovered() then
				color.r = color.r + 50
				color.g = color.g + 50
				color.b = color.b + 50
			end

			surface.SetDrawColor(color)
			surface.SetMaterial(YRP.GetDesignIcon("circle"))
			surface.DrawTexturedRect(0, 0, pw, ph)
			local br = ph * 0.1
			surface.SetDrawColor(Color(255, 255, 255, 255))
			surface.SetMaterial(YRP.GetDesignIcon("remove"))
			surface.DrawTexturedRect(br, br, pw - br * 2, ph - br * 2)

			return true
		end
	end
)

local color3 = Color(205, 100, 100)
hook.Add(
	"YClosePaint",
	"YClose_Blur",
	function(self, pw, ph, tab)
		tab = tab or {}
		if YRPGetInterfaceDesign() == "Blur" then
			local color = color3
			if self:IsDown() or self:IsPressed() then
				color.r = color.r - 50
				color.g = color.g - 50
				color.b = color.b - 50
			elseif self:IsHovered() then
				color.r = color.r + 50
				color.g = color.g + 50
				color.b = color.b + 50
			end

			surface.SetDrawColor(color)
			surface.SetMaterial(YRP.GetDesignIcon("circle"))
			surface.DrawTexturedRect(0, 0, pw, ph)
			local br = ph * 0.1
			surface.SetDrawColor(Color(255, 255, 255, 255))
			surface.SetMaterial(YRP.GetDesignIcon("clear"))
			surface.DrawTexturedRect(br, br, pw - br * 2, ph - br * 2)

			return true
		end
	end
)

hook.Add(
	"YMaxPaint",
	"YMax_Blur",
	function(self, pw, ph, tab)
		tab = tab or {}
		if YRPGetInterfaceDesign() == "Blur" then
			local color = Color(205, 205, 100)
			if self:IsDown() or self:IsPressed() then
				color.r = color.r - 50
				color.g = color.g - 50
				color.b = color.b - 50
			elseif self:IsHovered() then
				color.r = color.r + 50
				color.g = color.g + 50
				color.b = color.b + 50
			end

			surface.SetDrawColor(color)
			surface.SetMaterial(YRP.GetDesignIcon("circle"))
			surface.DrawTexturedRect(0, 0, pw, ph)
			local br = ph * 0.1
			surface.SetDrawColor(Color(255, 255, 255, 255))
			surface.SetMaterial(YRP.GetDesignIcon("mat_square"))
			surface.DrawTexturedRect(br, br, pw - br * 2, ph - br * 2)

			return true
		end
	end
)

hook.Add(
	"YGroupBoxPaint",
	"YGroupBox_Blur",
	function(self, pw, ph, tab)
		tab = tab or {}
		if YRPGetInterfaceDesign() == "Blur" then
			draw.RoundedBox(0, 0, 0, pw, ph, Color(40, 40, 40, 60))
			draw.RoundedBox(0, 0, 0, pw, self:GetHeaderHeight(), Color(60, 60, 60, 60))
			local x, y = self.con:GetPos()
			draw.RoundedBox(0, x, y, self.con:GetWide(), self.con:GetTall(), Color(20, 20, 20, 60))
			draw.SimpleText(YRP.trans(tab.text or self:GetText()), "Y_18_500", pw / 2, self:GetHeaderHeight() / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

			return true
		end
	end
)
--Copyright (C) 2017-2020 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

hook.Add("YFramePaint", "YFrame_Blur", function(self, pw, ph, tab)
	tab = tab or {}

	local lply = LocalPlayer()
	if GetGlobalDString("string_interface_design") == "Blur" then
		local hh = 24
		if self.GetHeaderHeight != nil then
			hh = self:GetHeaderHeight()
		end

		DrawRectBlur(self, 0, 0, pw, ph, 5) --draw.RoundedBox(0, 0, 0, pw, hh, lply:InterfaceValue("YFrame", "HB"))

		draw.RoundedBox(0, 0, 0, pw, hh, lply:InterfaceValue("YFrame", "HB")) --lply:InterfaceValue("YFrame", "BG"))

		if self.GetTitle != nil then
			draw.SimpleText(YRP.lang_string(self:GetTitle()), "Y_18_500", hh / 2, hh / 2, lply:InterfaceValue("YFrame", "HT"), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		end
		return true
	end
end)

hook.Add("YButtonPaint", "YButton_Blur", function(self, pw, ph, tab)
	tab = tab or {}

	local lply = LocalPlayer()
	if GetGlobalDString("string_interface_design") == "Blur" then
		local color = lply:InterfaceValue("YButton", "NC")
		local tcolor = lply:InterfaceValue("YButton", "NT")
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
		draw.RoundedBox(0, 0, 0, pw, ph, Color(color.r, color.g, color.b, color.a))

		draw.SimpleText(YRP.lang_string(tab.text or self:GetText()), "Y_18_500", pw / 2, ph / 2, tcolor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		return true
	end
end)

hook.Add("YButtonRPaint", "YButtonR_Blur", function(self, pw, ph, tab)
	tab = tab or {}

	local lply = LocalPlayer()
	if GetGlobalDString("string_interface_design") == "Blur" then
		local color = Color(126, 126, 126)
		local tcolor = lply:InterfaceValue("YButton", "NT")
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
		draw.RoundedBox(0, 0, 0, pw, ph, Color(color.r, color.g, color.b, color.a))

		draw.SimpleText(YRP.lang_string(tab.text or self:GetText()), "Y_18_500", pw / 2, ph / 2, tcolor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		return true
	end
end)

hook.Add("YLabelPaint", "YLabel_Blur", function(self, pw, ph, tab)
	tab = tab or {}

	local lply = LocalPlayer()
	if GetGlobalDString("string_interface_design") == "Blur" then
		local color = lply:InterfaceValue("YFrame", "BG")
		local tcolor = lply:InterfaceValue("YFrame", "HT")

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

		draw.SimpleText(YRP.lang_string(self:GetText()), "Y_18_500", tx, ty, tcolor, ax, ay)
		return true
	end
end)

hook.Add("YTextFieldPaint", "YTextFieldPaint_Blur", function(self, pw, ph, tab)
	tab = tab or {}

	local lply = LocalPlayer()
	if GetGlobalDString("string_interface_design") == "Blur" then
		local color = lply:InterfaceValue("YFrame", "NC")
		local tcolor = lply:InterfaceValue("YFrame", "HT")

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

		draw.SimpleText(YRP.lang_string(self:GetText()), "Y_16_500", tx, ty, tcolor, ax, ay)
		return true
	end
end)

hook.Add("YPanelPaint", "YPanel_Blur", function(self, pw, ph, tab)
	tab = tab or {}

	local lply = LocalPlayer()
	if GetGlobalDString("string_interface_design") == "Blur" then
		local color = lply:InterfaceValue("YFrame", "HI")

		draw.RoundedBox(0, 0, 0, pw, ph, Color(255, 255, 255, 10))
		return true
	end
end)

hook.Add("YAddPaint", "YAdd_Blur", function(self, pw, ph, tab)
	tab = tab or {}

	if GetGlobalDString("string_interface_design") == "Blur" then
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
		surface.SetDrawColor(255, 255, 255, 255)
		surface.SetMaterial(YRP.GetDesignIcon("add"))
		surface.DrawTexturedRect(br, br, pw - br * 2, ph - br * 2)
		return true
	end
end)

hook.Add("YRemovePaint", "YRemove_Blur", function(self, pw, ph, tab)
	tab = tab or {}

	if GetGlobalDString("string_interface_design") == "Blur" then
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
		surface.SetDrawColor(255, 255, 255, 255)
		surface.SetMaterial(YRP.GetDesignIcon("remove"))
		surface.DrawTexturedRect(br, br, pw - br * 2, ph - br * 2)
		return true
	end
end)

hook.Add("YClosePaint", "YClose_Blur", function(self, pw, ph, tab)
	tab = tab or {}

	if GetGlobalDString("string_interface_design") == "Blur" then
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
		surface.SetDrawColor(255, 255, 255, 255)
		surface.SetMaterial(YRP.GetDesignIcon("clear"))
		surface.DrawTexturedRect(br, br, pw - br * 2, ph - br * 2)
		return true
	end
end)

hook.Add("YMaxPaint", "YMax_Blur", function(self, pw, ph, tab)
	tab = tab or {}

	if GetGlobalDString("string_interface_design") == "Blur" then
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
		surface.SetDrawColor(255, 255, 255, 255)
		surface.SetMaterial(YRP.GetDesignIcon("square"))
		surface.DrawTexturedRect(br, br, pw - br * 2, ph - br * 2)
		return true
	end
end)

hook.Add("YGroupBoxPaint", "YGroupBox_Blur", function(self, pw, ph, tab)
	tab = tab or {}

	if GetGlobalDString("string_interface_design") == "Blur" then
		draw.RoundedBox(0, 0, 0, pw, ph, Color(40, 40, 40, 60))

		draw.RoundedBox(0, 0, 0, pw, self:GetHeaderHeight(), Color(60, 60, 60, 60))

		local x, y = self.con:GetPos()
		draw.RoundedBox(0, x, y, self.con:GetWide(), self.con:GetTall(), Color(20, 20, 20, 60))

		draw.SimpleText(YRP.lang_string(tab.text or self:GetText()), "Y_18_500", pw / 2, self:GetHeaderHeight() / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		return true
	end
end)

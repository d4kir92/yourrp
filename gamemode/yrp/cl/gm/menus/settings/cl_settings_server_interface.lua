--Copyright (C) 2017-2018 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

net.Receive("get_interface_settings", function(len)
	local ply = LocalPlayer()
	local _tbl = net.ReadTable()

	if pa(settingsWindow.window) then

		function settingsWindow.window.site:Paint(w, h)
			--[[ Left ]]--
			surfaceBox(0, 0, w/2, h, Color(0, 0, 0, 240))
			surfaceText(YRP.lang_string("settings_surface"), "SettingsHeader", ctr(20), ctr(10), Color(255, 255, 255), 0, 0)

			--[[ Right ]]--
			surfaceText(YRP.lang_string("preview"), "SettingsHeader", ScrW2() + ctr(20), ctr(10), Color(255, 255, 255), 0, 0)
		end

		local _dframe = createD("DFrame", settingsWindow.window.site, ScrW2() - ctr(200), ScrH2() - ctr(200), ScrW2() + ctr(100), ctr(100))
		_dframe:SetTitle("")
		function _dframe:Paint(pw, ph)
			surfaceWindow(self, pw, ph, YRP.lang_string("dframe"))
		end

		local _dpanel = createD("DPanel", _dframe, _dframe:GetWide() - ctr(100), ctr(200), ctr(50), ctr(60))
		function _dpanel:Paint(pw, ph)
			surfacePanel(self, pw, ph, YRP.lang_string("dpanel"))
		end

		local _dbutton = createD("DButton", _dframe, ctr(200), ctr(50), ctr(50), ctr(270))
		_dbutton:SetText("")
		function _dbutton:Paint(pw, ph)
			surfaceButton(self, pw, ph, YRP.lang_string("dbutton"))
		end

		local _parent = settingsWindow.window.site

		--[[ Color ]]--
		local _p_color = createD("DPanel", _parent, ctr(600), ctr(50), ctr(10), ctr(110))
		function _p_color:Paint(pw, ph)
			surfaceBox(0, 0, pw, ph, Color(100, 100, 255, 255))
			surfaceText(YRP.lang_string("color"), "SettingsNormal", ctr(10), ph/2, Color(255, 255, 255), 0, 1)
		end
		local _color = createD("DComboBox", _parent, ctr(600), ctr(50), ctr(10), ctr(160))
		local _colors = {}
		table.insert(_colors, "blue")
		table.insert(_colors, "red")
		table.insert(_colors, "green")
		table.insert(_colors, "yellow")
		table.insert(_colors, "brown")
		table.insert(_colors, "orange")
		table.insert(_colors, "purple")
		for i, col in pairs(_colors) do
			local _bool = false
			if col == _tbl.color then
				_bool = true
			end
			_color:AddChoice(string.upper(YRP.lang_string(col)), col, _bool)
		end
		function _color:OnSelect(index, value, data)
			net.Start("set_interface_color")
				net.WriteString(data)
			net.SendToServer()
		end

		--[[ Style ]]--
		local _p_style = createD("DPanel", _parent, ctr(600), ctr(50), ctr(10), ctr(220))
		function _p_style:Paint(pw, ph)
			surfaceBox(0, 0, pw, ph, Color(100, 100, 255, 255))
			surfaceText(YRP.lang_string("style"), "SettingsNormal", ctr(10), ph/2, Color(255, 255, 255), 0, 1)
		end
		local _style = createD("DComboBox", _parent, ctr(600), ctr(50), ctr(10), ctr(270))
		local _styles = {}
		table.insert(_styles, "dark")
		table.insert(_styles, "light")
		for i, sty in pairs(_styles) do
			local _bool = false
			if sty == _tbl.style then
				_bool = true
			end
			_style:AddChoice(string.upper(YRP.lang_string(sty)), sty, _bool)
		end
		function _style:OnSelect(index, value, data)
			net.Start("set_interface_style")
				net.WriteString(data)
			net.SendToServer()
		end

		--[[ Rounded ]]--
		local _p_rounded = createD("DPanel", _parent, ctr(600), ctr(50), ctr(10), ctr(330))
		function _p_rounded:Paint(pw, ph)
			surfaceBox(0, 0, pw, ph, Color(100, 100, 255, 255))
			surfaceText(YRP.lang_string("rounded"), "SettingsNormal", ctr(10), ph/2, Color(255, 255, 255), 0, 1)
		end
		local _rounded = createD("DCheckBox", _parent, ctr(50), ctr(50), ctr(10), ctr(380))
		_rounded:SetValue(_tbl.rounded)
		function _rounded:OnChange(bVal)
			local _num = 0
			if (bVal) then
				_num = 1
			end
			net.Start("set_interface_rounded")
				net.WriteString(_num)
			net.SendToServer()
		end

		--[[ Transparent ]]--
		local _p_transparent = createD("DPanel", _parent, ctr(600), ctr(50), ctr(10), ctr(440))
		function _p_transparent:Paint(pw, ph)
			surfaceBox(0, 0, pw, ph, Color(100, 100, 255, 255))
			surfaceText(YRP.lang_string("transparent"), "SettingsNormal", ctr(10), ph/2, Color(255, 255, 255), 0, 1)
		end
		local _transparent = createD("DCheckBox", _parent, ctr(50), ctr(50), ctr(10), ctr(490))
		_transparent:SetValue(_tbl.transparent)
		function _transparent:OnChange(bVal)
			local _num = 0
			if (bVal) then
				_num = 1
			end
			net.Start("set_interface_transparent")
				net.WriteString(_num)
			net.SendToServer()
		end

		--[[ Border ]]--
		local _p_border = createD("DPanel", _parent, ctr(600), ctr(50), ctr(10), ctr(550))
		function _p_border:Paint(pw, ph)
			surfaceBox(0, 0, pw, ph, Color(100, 100, 255, 255))
			surfaceText(YRP.lang_string("border"), "SettingsNormal", ctr(10), ph/2, Color(255, 255, 255), 0, 1)
		end
		local _border = createD("DCheckBox", _parent, ctr(50), ctr(50), ctr(10), ctr(600))
		_border:SetValue(_tbl.border)
		function _border:OnChange(bVal)
			local _num = 0
			if (bVal) then
				_num = 1
			end
			net.Start("set_interface_border")
				net.WriteString(_num)
			net.SendToServer()
		end

		--[[ Design ]]--
		local _p_design = createD("DPanel", _parent, ctr(600), ctr(50), ctr(10), ctr(660))
		function _p_design:Paint(pw, ph)
			surfaceBox(0, 0, pw, ph, Color(100, 100, 255, 255))
			surfaceText(YRP.lang_string("design"), "SettingsNormal", ctr(10), ph/2, Color(255, 255, 255), 0, 1)
		end
		local _design = createD("DComboBox", _parent, ctr(600), ctr(50), ctr(10), ctr(710))
		for i, design in pairs(GetDesigns()) do
			local _bool = false
			if design.name == _tbl.design then
				_bool = true
			end
			_design:AddChoice(design.name .. " by " .. design.author, design.name, _bool)
		end
		function _design:OnSelect(index, value, data)
			net.Start("set_interface_design")
				net.WriteString(data)
			net.SendToServer()
		end
	end
end)

hook.Add("open_server_interface", "open_server_interface", function()
	SaveLastSite()
	local ply = LocalPlayer()

	local w = settingsWindow.window.sitepanel:GetWide()
	local h = settingsWindow.window.sitepanel:GetTall()

	settingsWindow.window.site = createD("DPanel", settingsWindow.window.sitepanel, w, h, 0, 0)

	net.Start("get_interface_settings")
	net.SendToServer()
end)

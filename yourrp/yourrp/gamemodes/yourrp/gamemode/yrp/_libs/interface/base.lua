--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
local _type = type
function DHr(tab)
	tab = tab or {}
	tab.parent = tab.parent or nil
	if tab.parent ~= nil then
		tab.w = tab.w or tab.parent:GetWide() or 300
	else
		tab.w = tab.w or 300
	end

	tab.h = tab.h or YRP.ctr(100)
	tab.x = tab.x or 0
	tab.y = tab.y or 0
	tab.color = tab.color or Color(0, 0, 0, 255)
	local pnl = {}
	pnl.line = YRPCreateD("DPanel", tab.parent, tab.w, tab.h, tab.x, tab.x)
	function pnl.line:Paint(pw, ph)
		draw.RoundedBox(0, 0, 0, pw, ph, Color(255, 255, 255, 255))
		draw.RoundedBox(0, 0, ph / 4, pw, ph / 2, tab.color)
	end

	if tab.parent ~= nil and tab.parent.AddItem ~= nil then
		tab.parent:AddItem(pnl.line)
	end

	return pnl
end

function YRPDCheckBoxes(tab)
	tab = tab or {}
	tab.parent = tab.parent or nil
	if tab.parent ~= nil then
		tab.w = tab.w or tab.parent:GetWide() or 300
	else
		tab.w = tab.w or 300
	end

	tab.h = tab.h or YRP.ctr(100)
	tab.x = tab.x or 0
	tab.y = tab.y or 0
	tab.color = tab.color or Color(255, 255, 255, 255)
	tab.header = tab.header or "NOHEADER"
	tab.value = tab.value or "NOTEXT"
	tab.lforce = tab.lforce or true
	local pnl = {}
	pnl.line = YRPCreateD("DPanel", tab.parent, tab.w, tab.h, tab.x, tab.x)
	function pnl.line:Paint(pw, ph)
		draw.RoundedBox(0, 0, 0, pw, ph, tab.color)
		local text = {}
		if tab.lforce then
			text.text = YRP.trans(tab.header) .. ":"
		else
			text.text = tab.header .. ":"
		end

		text.x = YRP.ctr(10)
		text.y = ph / 4
		text.font = "Y_18_700"
		text.color = Color(255, 255, 255, 255)
		text.br = 1
		text.ax = 0
		YRPDrawText(text)
	end

	pnl.DButton = YRPCreateD("DButton", pnl.line, tab.w, tab.h / 2, tab.brx, tab.h / 2)
	pnl.DButton:SetText("")
	pnl.DButton.serverside = false
	function pnl.DButton:Paint(pw, ph)
		draw.RoundedBox(0, 0, 0, pw, ph, Color(255, 255, 255, 255))
		local change = {}
		change.text = "[" .. YRP.trans("LID_change") .. "] ( " .. tab.value .. " )"
		change.font = "Y_22_700"
		change.x = YRP.ctr(10)
		change.y = ph / 2
		change.ax = 0
		YRPDrawText(change)
	end

	if tab.netstr ~= nil and tab.uniqueID ~= nil then
		function pnl.DButton:DoClick()
			local window = YRPCreateD("DFrame", nil, YRP.ctr(20 + 500 + 20), YRP.ctr(50 + 20 + 500 + 20), 0, 0)
			window:Center()
			window:MakePopup()
			window:SetTitle("")
			function window:Paint(pw, ph)
				surfaceWindow(self, pw, ph, YRP.trans("LID_usergroups"))
			end

			window.cm = YRPCreateD("DPanelList", window, YRP.ctr(500), YRP.ctr(500), YRP.ctr(20), YRP.ctr(50 + 20))
			window.cm:EnableVerticalScrollbar()
			function window:sendtoserver()
				local str = {}
				for i, choice in pairs(tab.choices) do
					if choice.checked then
						table.insert(str, i)
					end

					for j, cho in pairs(choice.choices) do
						if cho.checked then
							table.insert(str, j)
						end
					end
				end

				str = table.concat(str, ",")
				tab.value = str
				net.Start(tab.netstr)
				net.WriteString(tab.uniqueID)
				net.WriteString(str)
				net.SendToServer()
			end

			for i, choice in pairs(tab.choices) do
				local ch = YRPCreateD("DPanel", window.cm, YRP.ctr(500), YRP.ctr(50), 0, 0)
				function ch:Paint(pw, ph)
					draw.RoundedBox(0, 0, 0, pw, ph, Color(255, 255, 255, 255))
					local ta = {}
					ta.text = i
					ta.font = "Y_22_700"
					ta.x = YRP.ctr(60)
					ta.y = ph / 2
					ta.ax = 0
					YRPDrawText(ta)
				end

				ch.ch = YRPCreateD("DCheckBox", ch, YRP.ctr(50), YRP.ctr(50), 0, 0)
				ch.ch:SetChecked(choice.checked)
				function ch.ch:OnChange(bo)
					choice.checked = bo
					for j, cho in pairs(choice.choices) do
						cho.checked = bo
						ch.subchoices[j].ch:SetChecked(bo)
					end

					window:sendtoserver()
				end

				window.cm:AddItem(ch)
				ch.subchoices = {}
				for j, cho in pairs(choice.choices) do
					ch.subchoices[j] = YRPCreateD("DPanel", window.cm, YRP.ctr(500), YRP.ctr(50), 0, 0)
					local sch = ch.subchoices[j]
					function sch:Paint(pw, ph)
						draw.RoundedBox(0, 0, 0, pw, ph, Color(255, 255, 255, 255))
						local ta = {}
						ta.text = j
						ta.font = "Y_22_700"
						ta.x = YRP.ctr(110)
						ta.y = ph / 2
						ta.ax = 0
						ta.lforce = false
						YRPDrawText(ta)
					end

					sch.ch = YRPCreateD("DCheckBox", sch, YRP.ctr(50), YRP.ctr(50), YRP.ctr(50), 0)
					sch.ch:SetChecked(cho.checked)
					function sch.ch:OnChange(bo)
						cho.checked = bo
						if not bo then
							choice.checked = false
							ch.ch:SetChecked(false)
						end

						window:sendtoserver()
					end

					window.cm:AddItem(sch)
				end
			end
		end

		net.Receive(
			tab.netstr,
			function(len)
				local _uid = tonumber(net.ReadString())
				local _str = net.ReadString()
				if YRPPanelAlive(pnl.DButton, "pnl.DButton") then
					pnl.DButton.serverside = true
					tab.value = _str
					pnl.DButton.serverside = false
				end
			end
		)
	end

	if tab.parent ~= nil and tab.parent.AddItem ~= nil then
		tab.parent:AddItem(pnl.line)
	end

	return pnl
end

function YRPDCheckBox(tab)
	tab = tab or {}
	tab.parent = tab.parent or nil
	if tab.parent ~= nil then
		tab.w = tab.w or tab.parent:GetWide() or 300
	else
		tab.w = tab.w or 300
	end

	tab.h = tab.h or YRP.ctr(50)
	tab.x = tab.x or 0
	tab.y = tab.y or 0
	tab.color = tab.color or Color(255, 255, 255, 255)
	tab.header = tab.header or "NOHEADER"
	tab.value = tonumber(tab.value) or 1
	tab.lforce = tab.lforce or true
	local pnl = {}
	pnl.line = YRPCreateD("DPanel", tab.parent, tab.w, tab.h, tab.x, tab.x)
	function pnl.line:Paint(pw, ph)
		draw.RoundedBox(0, 0, 0, pw, ph, tab.color)
		local text = {}
		if tab.lforce then
			text.text = YRP.trans(tab.header)
		else
			text.text = tab.header
		end

		text.x = YRP.ctr(60)
		text.y = ph / 2
		text.font = "Y_18_700"
		text.color = Color(255, 255, 255, 255)
		text.br = 1
		text.ax = 0
		YRPDrawText(text)
	end

	pnl.DCheckBox = YRPCreateD("DCheckBox", pnl.line, tab.h, tab.h, 0, 0)
	pnl.DCheckBox:SetValue(tab.value)
	pnl.DCheckBox.serverside = false
	function pnl.DCheckBox:Paint(pw, ph)
		surfaceCheckBox(self, pw, ph, "done")
	end

	if tab.netstr ~= nil and tab.uniqueID ~= nil then
		function pnl.DCheckBox:OnChange(bo)
			local int = 0
			if bo then
				int = 1
			end

			net.Start(tab.netstr)
			net.WriteString(tab.uniqueID)
			net.WriteString(int)
			net.SendToServer()
		end

		net.Receive(
			tab.netstr,
			function(len)
				local _uid = tonumber(net.ReadString())
				local _int = tonumber(net.ReadString())
				if YRPPanelAlive(pnl.DButton, "pnl.DButton") then
					pnl.DButton.serverside = true
					tab.value = _int
					pnl.DButton.serverside = false
				end
			end
		)
	end

	if tab.parent ~= nil and tab.parent.AddItem ~= nil then
		tab.parent:AddItem(pnl.line)
	end

	return pnl
end

function YRPDComboBox(tab)
	tab = tab or {}
	tab.parent = tab.parent or nil
	if tab.parent ~= nil then
		tab.w = tab.w or tab.parent:GetWide() or 300
	else
		tab.w = tab.w or 300
	end

	tab.h = tab.h or YRP.ctr(100)
	tab.x = tab.x or 0
	tab.y = tab.y or 0
	tab.color = tab.color or Color(255, 255, 255, 255)
	tab.header = tab.header or "NOHEADER"
	tab.value = tab.value or "NOTEXT"
	tab.lforce = tab.lforce or true
	local pnl = {}
	pnl.line = YRPCreateD("DPanel", tab.parent, tab.w, tab.h, tab.x, tab.x)
	function pnl.line:Paint(pw, ph)
		draw.RoundedBox(0, 0, 0, pw, ph, tab.color)
		local text = {}
		if tab.lforce then
			text.text = YRP.trans(tab.header) .. ":"
		else
			text.text = tab.header .. ":"
		end

		text.x = YRP.ctr(10)
		text.y = ph / 4
		text.font = "Y_18_700"
		text.color = Color(255, 255, 255, 255)
		text.br = 1
		text.ax = 0
		YRPDrawText(text)
	end

	pnl.DComboBox = YRPCreateD("DComboBox", pnl.line, tab.w, tab.h / 2, tab.brx, tab.h / 2)
	pnl.DComboBox:SetSortItems(false)
	for i, v in pairs(tab.choices) do
		if tab.value == i then
			pnl.DComboBox:AddChoice(v, i, true)
		else
			pnl.DComboBox:AddChoice(v, i)
		end
	end

	pnl.DComboBox.serverside = false
	if tab.netstr ~= nil and tab.uniqueID ~= nil then
		function pnl.DComboBox:OnSelect(index, value, data)
			net.Start(tab.netstr)
			net.WriteString(tab.uniqueID)
			net.WriteString(pnl.DComboBox:GetOptionData(pnl.DComboBox:GetSelectedID()))
			net.SendToServer()
		end

		net.Receive(
			tab.netstr,
			function(len)
				local _uid = tonumber(net.ReadString())
				local _str = net.ReadString()
				if YRPPanelAlive(pnl.DComboBox, "pnl.DComboBox") then
					pnl.DComboBox.serverside = true
					pnl.DComboBox:SetText(_str)
					pnl.DComboBox.serverside = false
				end
			end
		)
	end

	if tab.parent ~= nil and tab.parent.AddItem ~= nil then
		tab.parent:AddItem(pnl.line)
	end

	return pnl
end

function YRPDComboBoxHUD(tab)
	tab = tab or {}
	tab.parent = tab.parent or nil
	if tab.parent ~= nil then
		tab.w = tab.w or tab.parent:GetWide() or 300
	else
		tab.w = tab.w or 300
	end

	tab.h = tab.h or YRP.ctr(100)
	tab.x = tab.x or 0
	tab.y = tab.y or 0
	tab.color = tab.color or Color(255, 255, 255, 255)
	tab.header = tab.header or "NOHEADER"
	tab.value = tab.value or "NOTEXT"
	tab.lforce = tab.lforce or true
	local pnl = {}
	pnl.line = YRPCreateD("DPanel", tab.parent, tab.w, tab.h, tab.x, tab.x)
	function pnl.line:Paint(pw, ph)
		draw.RoundedBox(0, 0, 0, pw, ph, tab.color)
		local text = {}
		if tab.lforce then
			text.text = YRP.trans(tab.header) .. ":"
		else
			text.text = tab.header .. ":"
		end

		text.x = YRP.ctr(10)
		text.y = ph / 4
		text.font = "Y_18_700"
		text.color = Color(255, 255, 255, 255)
		text.br = 1
		text.ax = 0
		YRPDrawText(text)
	end

	pnl.DComboBox = YRPCreateD("DComboBox", pnl.line, tab.w, tab.h / 2, tab.brx, tab.h / 2)
	pnl.DComboBox:SetSortItems(false)
	for i, v in pairs(tab.choices) do
		if tab.value == v then
			pnl.DComboBox:AddChoice(v, i, true)
		else
			pnl.DComboBox:AddChoice(v, i)
		end
	end

	pnl.DComboBox.serverside = false
	if tab.netstr ~= nil and tab.uniqueID ~= nil then
		function pnl.DComboBox:OnSelect(index, value, data)
			net.Start(tab.netstr)
			net.WriteString(tab.uniqueID)
			net.WriteString(value)
			net.SendToServer()
		end

		net.Receive(
			tab.netstr,
			function(len)
				local _uid = tonumber(net.ReadString())
				local _str = net.ReadString()
				if YRPPanelAlive(pnl.DComboBox, "pnl.DComboBox 2") then
					pnl.DComboBox.serverside = true
					pnl.DComboBox:SetText(_str)
					pnl.DComboBox.serverside = false
				end
			end
		)
	end

	if tab.parent ~= nil and tab.parent.AddItem ~= nil then
		tab.parent:AddItem(pnl.line)
	end

	return pnl
end

function DColor(tab)
	tab = tab or {}
	tab.parent = tab.parent or nil
	if tab.parent ~= nil then
		tab.w = tab.w or tab.parent:GetWide() or 300
	else
		tab.w = tab.w or 300
	end

	tab.h = tab.h or YRP.ctr(100)
	tab.x = tab.x or 0
	tab.y = tab.y or 0
	tab.color = tab.color or Color(255, 255, 255, 255)
	tab.header = tab.header or "NOHEADER"
	tab.value = tab.value or "NOTEXT"
	tab.lforce = tab.lforce or true
	local pnl = {}
	pnl.line = YRPCreateD("DPanel", tab.parent, tab.w, tab.h, tab.x, tab.x)
	function pnl.line:Paint(pw, ph)
		draw.RoundedBox(0, 0, 0, pw, ph, tab.color)
		local text = {}
		if tab.lforce then
			text.text = YRP.trans(tab.header) .. ":"
		else
			text.text = tab.header .. ":"
		end

		text.x = YRP.ctr(10)
		text.y = ph / 4
		text.font = "Y_18_700"
		text.color = tab.color
		text.br = 1
		text.ax = 0
		YRPDrawText(text)
	end

	pnl.DButton = YRPCreateD("DButton", pnl.line, tab.w, tab.h / 2, tab.brx, tab.h / 2)
	pnl.DButton:SetText("")
	pnl.DButton.serverside = false
	pnl.DButton.color = stc(tab.value)
	function pnl.DButton:Paint(pw, ph)
		draw.RoundedBox(0, 0, 0, pw, ph, self.color)
		local change = {}
		change.text = "LID_change"
		change.font = "Y_22_700"
		change.x = pw / 2
		change.y = ph / 2
		change.color = self.color
		YRPDrawText(change)
	end

	if tab.netstr ~= nil and tab.uniqueID ~= nil then
		function pnl.DButton:DoClick()
			local window = YRPCreateD("DFrame", nil, YRP.ctr(20 + 500 + 20), YRP.ctr(50 + 20 + 500 + 20), 0, 0)
			window:Center()
			window:MakePopup()
			window:SetTitle("")
			function window:Paint(pw, ph)
				surfaceWindow(self, pw, ph, YRP.trans("LID_color"))
			end

			window.cm = YRPCreateD("DColorMixer", window, YRP.ctr(500), YRP.ctr(500), YRP.ctr(20), YRP.ctr(50 + 20))
			function window.cm:ValueChanged(col)
				local colstr = YRPTableToColorStr(col)
				if pnl.DButton:IsValid() then
					pnl.DButton.tabcolor = colstr
					pnl.DButton.color = StringToColor(pnl.DButton.tabcolor)
				end

				net.Start(tab.netstr)
				net.WriteString(tab.uniqueID)
				net.WriteString(colstr)
				net.SendToServer()
			end
		end

		net.Receive(
			tab.netstr,
			function(len)
				local _uid = tonumber(net.ReadString())
				local _str = net.ReadString()
				if YRPPanelAlive(pnl.DButton, "pnl.DButton") then
					pnl.DButton.serverside = true
					pnl.DButton.color = stc(_str)
					pnl.DButton.serverside = false
				end
			end
		)
	end

	if tab.parent ~= nil and tab.parent.AddItem ~= nil then
		tab.parent:AddItem(pnl.line)
	end

	return pnl
end

function DIntBox(tab)
	tab = tab or {}
	tab.parent = tab.parent or nil
	if tab.parent ~= nil then
		tab.w = tab.w or tab.parent:GetWide() or 300
	else
		tab.w = tab.w or 300
	end

	tab.h = tab.h or YRP.ctr(100)
	tab.x = tab.x or 0
	tab.y = tab.y or 0
	tab.color = tab.color or Color(255, 255, 255, 255)
	tab.header = tab.header or "NOHEADER"
	tab.value = tab.value or -1
	tab.lforce = tab.lforce or true
	tab.min = tonumber(tab.min) or 0
	tab.max = tonumber(tab.max) or 100
	local pnl = {}
	pnl.line = YRPCreateD("DPanel", tab.parent, tab.w, tab.h, tab.x, tab.x)
	function pnl.line:Paint(pw, ph)
		draw.RoundedBox(0, 0, 0, pw, ph, tab.color)
		local text = {}
		if tab.lforce then
			text.text = YRP.trans(tab.header) .. ":"
		else
			text.text = tab.header .. ":"
		end

		text.x = YRP.ctr(10)
		text.y = ph / 4
		text.font = "Y_18_700"
		text.color = Color(255, 255, 255, 255)
		text.br = 1
		text.ax = 0
		YRPDrawText(text)
	end

	pnl.DNumberWang = YRPCreateD("DNumberWang", pnl.line, tab.w, tab.h / 2, tab.brx, tab.h / 2)
	pnl.DNumberWang:SetMin(tab.min)
	pnl.DNumberWang:SetMax(tab.max)
	pnl.DNumberWang:SetValue(tab.value)
	pnl.DNumberWang.serverside = false
	if tab.netstr ~= nil and tab.uniqueID ~= nil then
		function pnl.DNumberWang:OnValueChanged(val)
			val = tonumber(val)
			if val <= self:GetMax() and val >= self:GetMin() then
				net.Start(tab.netstr)
				net.WriteString(tab.uniqueID)
				net.WriteString(val)
				net.SendToServer()
			elseif val > self:GetMax() then
				self:SetValue(self:GetMax())
				self:SetText(self:GetMax())
			elseif val < self:GetMin() then
				self:SetValue(self:GetMin())
				self:SetText(self:GetMin())
			end
		end

		net.Receive(
			tab.netstr,
			function(len)
				local _uid = tonumber(net.ReadString())
				local _val = tonumber(net.ReadString())
				if YRPPanelAlive(pnl.DNumberWang, "pnl.DNumberWang") then
					pnl.DNumberWang.serverside = true
					pnl.DNumberWang:SetValue(_val)
					pnl.DNumberWang.serverside = false
				end
			end
		)
	end

	if tab.parent ~= nil and tab.parent.AddItem ~= nil then
		tab.parent:AddItem(pnl.line)
	end

	return pnl
end

function DTextBox(tab)
	tab = tab or {}
	tab.parent = tab.parent or nil
	if tab.parent ~= nil then
		tab.w = tab.w or tab.parent:GetWide() or 300
	else
		tab.w = tab.w or 300
	end

	tab.h = tab.h or YRP.ctr(100)
	tab.x = tab.x or 0
	tab.y = tab.y or 0
	tab.color = tab.color or Color(255, 255, 255, 255)
	tab.header = tab.header or "NOHEADER"
	tab.value = tab.value or "NOTEXT"
	tab.lforce = tab.lforce or true
	tab.placeholder = tab.placeholder or ""
	tab.hardmode = tab.hardmode or false
	local pnl = {}
	pnl.line = YRPCreateD("DPanel", tab.parent, tab.w, tab.h, tab.x, tab.x)
	function pnl.line:Paint(pw, ph)
		draw.RoundedBox(0, 0, 0, pw, ph, tab.color)
		local text = {}
		if tab.lforce then
			text.text = YRP.trans(tab.header) .. ":"
		else
			text.text = tab.header .. ":"
		end

		text.x = YRP.ctr(10)
		text.y = YRP.ctr(25)
		text.font = "Y_18_700"
		text.color = Color(255, 255, 255, 255)
		text.br = 1
		text.ax = 0
		YRPDrawText(text)
		if dmg ~= nil and pnl.dtextentry ~= nil then
			local DMG = {}
			DMG.text = dmg:GetValue() * pnl.dtextentry:GetValue() .. " " .. YRP.trans("LID_damage")
			DMG.x = pw - YRP.ctr(10)
			DMG.y = ph / 2
			DMG.font = "Y_22_700"
			DMG.color = Color(0, 0, 0, 255)
			DMG.br = 1
			DMG.ax = 2
			YRPDrawText(DMG)
		end
	end

	function pnl:GetText()
		return pnl.DTextEntry:GetText()
	end

	pnl.DTextEntry = YRPCreateD("DTextEntry", pnl.line, tab.w, tab.h - YRP.ctr(50), tab.brx, YRP.ctr(50))
	pnl.DTextEntry:SetText(tab.value)
	pnl.DTextEntry:SetMultiline(tab.multiline or false)
	pnl.DTextEntry.serverside = false
	if tab.netstr ~= nil and tab.uniqueID ~= nil then
		function pnl.DTextEntry:OnChange()
			if tab.hardmode and string.find(self:GetText(), "^[a-zA-Z0-9_]*$") == nil then
				self:SetPlaceholderText("ONLY: a-z, A-Z, _")
				self:SetText("")
			end

			net.Start(tab.netstr)
			net.WriteString(tab.uniqueID)
			net.WriteString(self:GetText())
			net.SendToServer()
			if pnl.OnChange then
				pnl:OnChange()
			end

			if tab.testCode then
				tab:testCode()
			end
		end

		net.Receive(
			tab.netstr,
			function(len)
				local _uid = tonumber(net.ReadString())
				local _str = net.ReadString()
				if YRPPanelAlive(pnl.DTextEntry, "pnl.DTextEntry") then
					pnl.DTextEntry.serverside = true
					pnl.DTextEntry:SetText(_str)
					pnl.DTextEntry.serverside = false
				end
			end
		)
	end

	pnl.DTextEntry:SetPlaceholderText(tab.placeholder)
	if tab.parent ~= nil and tab.parent.AddItem ~= nil then
		tab.parent:AddItem(pnl.line)
	end

	return pnl
end

function YRPDNumberWang(tab)
	tab = tab or {}
	tab.w = tab.w or 10
	tab.h = tab.h or 10
	tab.min = tonumber(tab.min) or 0
	tab.max = tonumber(tab.max) or 100
	local dnw = YRPCreateD("DNumberWang", tab.parent, tab.w, tab.h / 2, tab.x, tab.h / 2)
	dnw:SetMin(tab.min)
	dnw:SetMax(tab.max)
	dnw:SetValue(tab.value)
	dnw.serverside = false
	if tab.netstr ~= nil and tab.uniqueID ~= nil then
		function dnw:OnValueChanged(val)
			val = tonumber(val)
			if val <= tab.max and val >= tab.min then
				net.Start(tab.netstr)
				net.WriteString(tab.uniqueID)
				net.WriteString(val)
				net.SendToServer()
			elseif val > tab.max then
				self:SetValue(tab.max)
				self:SetText(tab.max)
			elseif val < tab.min then
				self:SetValue(tab.min)
				self:SetText(tab.min)
			end
		end

		net.Receive(
			tab.netstr,
			function(len)
				local _uid = tonumber(net.ReadString())
				local _val = tonumber(net.ReadString())
				if YRPPanelAlive(dnw, "dnw") then
					dnw.serverside = true
					dnw:SetValue(_val)
					dnw.serverside = false
				end
			end
		)
	end

	return dnw
end

function DAttributeBar(tab)
	tab = tab or {}
	tab.parent = tab.parent or nil
	if tab.parent ~= nil then
		tab.w = tab.w or tab.parent:GetWide() or 300
	else
		tab.w = tab.w or 300
	end

	tab.h = tab.h or YRP.ctr(120)
	tab.x = tab.x or 0
	tab.y = tab.y or 0
	tab.color = tab.color or Color(255, 255, 255, 255)
	tab.len = table.Count(tab.dnw)
	tab.header = tab.header or "NOHEADER"
	tab.value = tab.value or "NOTEXT"
	tab.lforce = tab.lforce or true
	tab.min = tonumber(tab.min) or 0
	tab.max = tonumber(tab.max) or 100
	local pnl = {}
	pnl.line = YRPCreateD("DPanel", tab.parent, tab.w, tab.h, tab.x, tab.x)
	pnl.val3 = 0
	pnl.val4 = 0
	pnl.delay = 0
	function pnl.line:Paint(pw, ph)
		ph = ph / 2
		pnl.refresh = false
		if CurTime() > pnl.delay then
			pnl.delay = CurTime() + 1
			pnl.refresh = true
		end

		if pnl.cu ~= nil and pnl.ma ~= nil then
			tab.dnw[1].value = pnl.cu:GetValue() or tab.dnw[1].value
			tab.dnw[2].value = pnl.ma:GetValue() or tab.dnw[2].value
			if tab.dnw[3] ~= nil then
				tab.dnw[3].value = pnl.up:GetValue() or tab.dnw[3].value
				if pnl.refresh then
					pnl.val3 = pnl.val3 + tab.dnw[3].value
					if pnl.val3 > tab.dnw[2].value then
						pnl.val3 = 0
					elseif pnl.val3 < 0 then
						if tab.dnw[4] ~= nil then
							pnl.val3 = tab.dnw[4].value
						end
					end
				end

				if tab.dnw[4] ~= nil then
					tab.dnw[4].value = pnl.dn:GetValue() or tab.dnw[4].value
					if pnl.refresh then
						pnl.val4 = pnl.val4 + tab.dnw[4].value
						if pnl.val4 > tab.dnw[2].value then
							pnl.val4 = 0
						elseif pnl.val4 < 0 then
							pnl.val4 = tab.dnw[2].value
						end
					end
				end
			end

			draw.RoundedBox(0, 0, 0, pw * tab.dnw[1].value / tab.dnw[2].value, ph, tab.color)
			if tab.dnw[3] ~= nil then
				draw.RoundedBox(0, 0, ph / 4 * 3, pw * pnl.val3 / tab.dnw[2].value, ph / 4, tab.color2)
				if tab.dnw[4] ~= nil then
					draw.RoundedBox(0, 0, ph / 4 * 2, pw * pnl.val4 / tab.dnw[2].value, ph / 4, tab.color3)
				end
			end

			local text = {}
			if tab.lforce then
				text.text = YRP.trans(tab.header) .. ": " .. tab.dnw[1].value .. "/" .. tab.dnw[2].value
				if tab.dnw[3] ~= nil then
					text.text = text.text .. " ( " .. tab.dnw[3].value
					if tab.dnw[4] ~= nil then
						text.text = text.text .. " | " .. tab.dnw[4].value
					end
				end

				text.text = text.text .. " )"
			else
				text.text = tab.header .. ":"
			end

			text.x = YRP.ctr(10)
			text.y = ph / 2
			text.font = "Y_18_700"
			text.color = Color(255, 255, 255, 255)
			text.br = 1
			text.ax = 0
			YRPDrawText(text)
		end
	end

	tab.par = tab.parent
	tab.parent = pnl.line
	tab.dnw[1].uniqueID = tab.uniqueID
	tab.dnw[1].parent = tab.parent
	tab.dnw[1].w = tab.w / tab.len
	tab.dnw[1].h = tab.h
	tab.dnw[1].len = tab.len
	pnl.cu = YRPDNumberWang(tab.dnw[1])
	tab.dnw[2].uniqueID = tab.uniqueID
	tab.dnw[2].parent = tab.parent
	tab.dnw[2].w = tab.w / tab.len
	tab.dnw[2].h = tab.h
	tab.dnw[2].len = tab.len
	tab.dnw[2].x = tab.w / tab.len
	pnl.ma = YRPDNumberWang(tab.dnw[2])
	if tab.dnw[3] ~= nil then
		tab.dnw[3].uniqueID = tab.uniqueID
		tab.dnw[3].parent = tab.parent
		tab.dnw[3].w = tab.w / tab.len
		tab.dnw[3].h = tab.h
		tab.dnw[3].len = tab.len
		tab.dnw[3].x = tab.w / tab.len * 2
		pnl.up = YRPDNumberWang(tab.dnw[3])
	end

	if tab.dnw[4] ~= nil then
		tab.dnw[4].uniqueID = tab.uniqueID
		tab.dnw[4].parent = tab.parent
		tab.dnw[4].w = tab.w / tab.len
		tab.dnw[4].h = tab.h
		tab.dnw[4].len = tab.len
		tab.dnw[4].x = tab.w / tab.len * 3
		pnl.dn = YRPDNumberWang(tab.dnw[4])
	end

	if tab.par ~= nil and tab.par.AddItem ~= nil then
		tab.par:AddItem(pnl.line)
	end

	return pnl
end

function DStringListBox(tab)
	tab = tab or {}
	tab.parent = tab.parent or nil
	tab.w = tab.w or YRP.ctr(300)
	tab.h = tab.h or YRP.ctr(120)
	tab.x = tab.x or 0
	tab.y = tab.y or 0
	tab.color = tab.color or Color(255, 255, 255, 255)
	tab.header = tab.header or "NOHEADER"
	tab.value = tab.value or "NOTEXT"
	tab.lforce = tab.lforce or true
	local pnl = {}
	pnl.bg = YRPCreateD("DPanel", tab.parent, tab.w, tab.h, tab.x, tab.y)
	function pnl.bg:Paint(pw, ph)
		draw.RoundedBox(0, 0, 0, pw, ph, tab.color)
		local text = {}
		if tab.lforce then
			text.text = YRP.trans(tab.header) .. ":"
		else
			text.text = tab.header .. ":"
		end

		text.x = YRP.ctr(10)
		text.y = YRP.ctr(25)
		text.font = "Y_18_700"
		text.color = Color(255, 255, 255, 255)
		text.br = 1
		text.ax = 0
		YRPDrawText(text)
	end

	pnl.add = YRPCreateD("DButton", pnl.bg, YRP.ctr(50), YRP.ctr(50), tab.w - YRP.ctr(50), 0)
	pnl.add:SetText("")
	function pnl.add:Paint(pw, ph)
		self.color = Color(80, 255, 80)
		if self:IsHovered() then
			self.color = Color(100, 255, 100)
		end

		draw.RoundedBox(0, 0, 0, pw, ph, self.color)
		draw.SimpleText("+", "DermaDefault", pw / 2, ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

	function pnl.add:DoClick()
		tab.doclick()
	end

	pnl.dpl = YRPCreateD("DPanelList", pnl.bg, tab.w, tab.h - YRP.ctr(50), 0, YRP.ctr(50))
	pnl.dpl:EnableVerticalScrollbar(true)
	pnl.dpl:SetSpacing(1)
	function pnl.dpl:Paint(pw, ph)
		draw.RoundedBox(0, 0, 0, pw, ph, Color(80, 80, 80))
	end

	function pnl.dpl:AddLines(t)
		pnl.dpl:Clear()
		for i, v in pairs(t) do
			if _type(v) == "table" then
				v.h = v.h or YRP.ctr(70)
				v.br = v.br or YRP.ctr(10)
				local line = YRPCreateD("DButton", nil, pnl.dpl:GetWide(), v.h, 0, 0)
				line:SetText("")
				line.uniqueID = v.uniqueID
				line.models = string.Explode(",", v.string_models or "")
				line.pmid = 1
				if table.Count(line.models) > 1 or not strEmpty(line.models[1]) then
					line.mod = YRPCreateD("DModelPanel", line, v.h - 2 * v.br, v.h - 2 * v.br, YRP.ctr(40) + v.br, v.br)
				end

				local text = ""
				if v.slots then
					local test = {}
					if tobool(v.slots.slot_primary) then
						table.insert(test, YRP.trans("LID_primary"))
					end

					if tobool(v.slots.slot_secondary) then
						table.insert(test, YRP.trans("LID_secondary"))
					end

					if tobool(v.slots.slot_sidearm) then
						table.insert(test, YRP.trans("LID_sidearm"))
					end

					if tobool(v.slots.slot_gadget) then
						table.insert(test, YRP.trans("LID_gadget"))
					end

					if tobool(v.slots.slot_no) then
						table.insert(test, YRP.trans("LID_noslot"))
					end

					text = table.concat(test, ", ")
					if strEmpty(text) then
						text = "WEAPON NEED CONFIGURATION!"
					end
				end

				function line:Paint(pw, ph)
					draw.RoundedBox(0, 0, 0, pw, ph, Color(255, 255, 255, 255))
					if self.mod ~= nil and self.oldpmid ~= self.pmid then
						self.oldpmid = self.pmid
						line.mod:SetModel(line.models[line.pmid])
					end

					local name = v.string_name
					if table.Count(self.models) > 1 then
						name = name .. " ( " .. self.pmid .. "/" .. table.Count(self.models) .. " )"
					end

					draw.SimpleText(name, "DermaDefault", YRP.ctr(40) + v.h + YRP.ctr(40) + YRP.ctr(20), ph / 2 - YRP.ctr(25), Color(0, 0, 0, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
					if v.slots then
						draw.SimpleText(text, "DermaDefault", YRP.ctr(40) + v.h + YRP.ctr(40) + YRP.ctr(20), ph / 2 + YRP.ctr(25), Color(0, 0, 0, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
					else
						draw.SimpleText(line.models[line.pmid], "DermaDefault", YRP.ctr(40) + v.h + YRP.ctr(40) + YRP.ctr(20), ph / 2 + YRP.ctr(25), Color(0, 0, 0, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
					end
				end

				line.rem = YRPCreateD("DButton", line, v.h - 2 * v.br, v.h - 2 * v.br, line:GetWide() - v.h - v.br, v.br)
				line.rem:SetText("")
				function line.rem:Paint(pw, ph)
					draw.RoundedBox(0, 0, 0, pw, ph, Color(0, 255, 0))
					draw.SimpleText("-", "DermaDefault", pw / 2, ph / 2, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				end

				function line.rem:DoClick()
					v.doclick()
				end

				line.next = YRPCreateD("DButton", line, YRP.ctr(40), v.h - 2 * v.br, YRP.ctr(40) + v.h, v.br)
				line.next:SetText("")
				function line.next:Paint(pw, ph)
					if line.pmid < table.Count(line.models) then
						draw.RoundedBox(0, 0, 0, pw, ph, Color(0, 255, 0, 200))
						draw.SimpleText(">", "DermaDefault", pw / 2, ph / 2, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
					end
				end

				function line.next:DoClick()
					if line.pmid < table.Count(line.models) then
						line.pmid = line.pmid + 1
					end
				end

				line.prev = YRPCreateD("DButton", line, YRP.ctr(40), v.h - 2 * v.br, 0, v.br)
				line.prev:SetText("")
				function line.prev:Paint(pw, ph)
					if line.pmid > 1 then
						draw.RoundedBox(0, 0, 0, pw, ph, Color(0, 255, 0, 200))
						draw.SimpleText("<", "DermaDefault", pw / 2, ph / 2, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
					end
				end

				function line.prev:DoClick()
					if line.pmid > 1 then
						line.pmid = line.pmid - 1
					end
				end

				self:AddItem(line)
			end
		end
	end

	tab.par = tab.parent
	if tab.par ~= nil and tab.par.AddItem ~= nil then
		tab.par:AddItem(pnl.bg)
	end

	return pnl
end
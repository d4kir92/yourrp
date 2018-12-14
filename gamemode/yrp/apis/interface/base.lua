--Copyright (C) 2017-2018 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

function DHr(tab)
	tab = tab or {}
	tab.parent = tab.parent or nil
	if tab.parent != nil then
		tab.w = tab.w or tab.parent:GetWide() or 300
	else
		tab.w = tab.w or 300
	end
	tab.h = tab.h or ctr(100)
	tab.x = tab.x or 0
	tab.y = tab.y or 0
	tab.color = tab.color or Color(0, 0, 0)

	local pnl = {}

	pnl.line = createD("DPanel", tab.parent, tab.w, tab.h, tab.x, tab.x)
	function pnl.line:Paint(pw, ph)
		draw.RoundedBox(0, 0, 0, pw, ph, Color(255, 255, 255))
		draw.RoundedBox(0, 0, ph / 4, pw, ph / 2, tab.color)
	end

	if tab.parent != nil and tab.parent.AddItem != nil then
		tab.parent:AddItem(pnl.line)
	end
	return pnl
end

function DCheckBoxes(tab)
	tab = tab or {}
	tab.parent = tab.parent or nil
	if tab.parent != nil then
		tab.w = tab.w or tab.parent:GetWide() or 300
	else
		tab.w = tab.w or 300
	end
	tab.h = tab.h or ctr(100)
	tab.x = tab.x or 0
	tab.y = tab.y or 0
	tab.color = tab.color or Color(255, 255, 255)

	tab.header = tab.header or "NOHEADER"
	tab.value = tab.value or "NOTEXT"
	tab.lforce = tab.lforce or true

	local pnl = {}

	pnl.line = createD("DPanel", tab.parent, tab.w, tab.h, tab.x, tab.x)
	function pnl.line:Paint(pw, ph)
		draw.RoundedBox(0, 0, 0, pw, ph, tab.color)
		local text = {}
		if tab.lforce then
			text.text = YRP.lang_string(tab.header) .. ":"
		else
			text.text = tab.header .. ":"
		end
		text.x = ctr(10)
		text.y = ph / 4
		text.font = "mat1text"
		text.color = Color(255, 255, 255, 255)
		text.br = 1
		text.ax = 0
		DrawText(text)
	end

	pnl.DButton = createD("DButton", pnl.line, tab.w, tab.h / 2, tab.brx, tab.h / 2)
	pnl.DButton:SetText("")
	pnl.DButton.serverside = false
	function pnl.DButton:Paint(pw, ph)
		draw.RoundedBox(0, 0, 0, pw, ph, Color(255, 255, 255))
		local change = {}
		change.text = "[" .. YRP.lang_string("LID_change") .. "] (" .. tab.value .. ")"
		change.font = "mat1header"
		change.x = ctr(10)
		change.y = ph / 2
		change.ax = 0
		DrawText(change)
	end
	if tab.netstr != nil and tab.uniqueID != nil then
		function pnl.DButton:DoClick()
			local window = createD("DFrame", nil, ctr(20 + 500 + 20), ctr(50 + 20 + 500 + 20), 0, 0)
			window:Center()
			window:MakePopup()
			window:SetTitle("")
			function window:Paint(pw, ph)
				surfaceWindow(self, pw, ph, YRP.lang_string("LID_usergroups"))
			end
			window.cm = createD("DPanelList", window, ctr(500), ctr(500), ctr(20), ctr(50 + 20))

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
				local ch = createD("DPanel", window.cm, ctr(500), ctr(50), 0, 0)
				function ch:Paint(pw, ph)
					draw.RoundedBox(0, 0, 0, pw, ph, Color(255, 255, 255))
					local ta = {}
					ta.text = i
					ta.font = "mat1header"
					ta.x = ctr(60)
					ta.y = ph / 2
					ta.ax = 0
					DrawText(ta)
				end
				ch.ch = createD("DCheckBox", ch, ctr(50), ctr(50), 0, 0)
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
					ch.subchoices[j] = createD("DPanel", window.cm, ctr(500), ctr(50), 0, 0)
					local sch = ch.subchoices[j]
					function sch:Paint(pw, ph)
						draw.RoundedBox(0, 0, 0, pw, ph, Color(255, 255, 255))
						local ta = {}
						ta.text = j
						ta.font = "mat1header"
						ta.x = ctr(110)
						ta.y = ph / 2
						ta.ax = 0
						ta.lforce = false
						DrawText(ta)
					end
					sch.ch = createD("DCheckBox", sch, ctr(50), ctr(50), ctr(50), 0)
					sch.ch:SetChecked(cho.checked)
					function sch.ch:OnChange(bo)
						cho.checked = bo
						if !bo then
							choice.checked = false
							ch.ch:SetChecked(false)
						end
						window:sendtoserver()
					end
					window.cm:AddItem(sch)
				end
			end
		end
		net.Receive(tab.netstr, function(len)
			local _uid = tonumber(net.ReadString())
			local _str = net.ReadString()
			if pa(pnl.DButton) then
				pnl.DButton.serverside = true
				tab.value = _str
				pnl.DButton.serverside = false
			end
		end)
	end

	if tab.parent != nil and tab.parent.AddItem != nil then
		tab.parent:AddItem(pnl.line)
	end
	return pnl
end

function DCheckBox(tab)
	tab = tab or {}
	tab.parent = tab.parent or nil
	if tab.parent != nil then
		tab.w = tab.w or tab.parent:GetWide() or 300
	else
		tab.w = tab.w or 300
	end
	tab.h = tab.h or ctr(50)
	tab.x = tab.x or 0
	tab.y = tab.y or 0
	tab.color = tab.color or Color(255, 255, 255)

	tab.header = tab.header or "NOHEADER"
	tab.value = tonumber(tab.value) or 1
	tab.lforce = tab.lforce or true

	local pnl = {}

	pnl.line = createD("DPanel", tab.parent, tab.w, tab.h, tab.x, tab.x)
	function pnl.line:Paint(pw, ph)
		draw.RoundedBox(0, 0, 0, pw, ph, tab.color)
		local text = {}
		if tab.lforce then
			text.text = YRP.lang_string(tab.header)
		else
			text.text = tab.header
		end
		text.x = ctr(60)
		text.y = ph / 2
		text.font = "mat1text"
		text.color = Color(255, 255, 255, 255)
		text.br = 1
		text.ax = 0
		DrawText(text)
	end

	pnl.DCheckBox = createD("DCheckBox", pnl.line, tab.h, tab.h, 0, 0)
	pnl.DCheckBox:SetValue(tab.value)
	pnl.DCheckBox.serverside = false
	function pnl.DCheckBox:Paint(pw, ph)
		surfaceCheckBox(self, pw, ph, "done")
	end
	if tab.netstr != nil and tab.uniqueID != nil then
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
		net.Receive(tab.netstr, function(len)
			local _uid = tonumber(net.ReadString())
			local _int = tonumber(net.ReadString())
			if pa(pnl.DButton) then
				pnl.DButton.serverside = true
				tab.value = _int
				pnl.DButton.serverside = false
			end
		end)
	end

	if tab.parent != nil and tab.parent.AddItem != nil then
		tab.parent:AddItem(pnl.line)
	end
	return pnl
end

function DComboBox(tab)
	tab = tab or {}
	tab.parent = tab.parent or nil
	if tab.parent != nil then
		tab.w = tab.w or tab.parent:GetWide() or 300
	else
		tab.w = tab.w or 300
	end
	tab.h = tab.h or ctr(100)
	tab.x = tab.x or 0
	tab.y = tab.y or 0
	tab.color = tab.color or Color(255, 255, 255)

	tab.header = tab.header or "NOHEADER"
	tab.value = tab.value or "NOTEXT"
	tab.lforce = tab.lforce or true

	local pnl = {}

	pnl.line = createD("DPanel", tab.parent, tab.w, tab.h, tab.x, tab.x)
	function pnl.line:Paint(pw, ph)
		draw.RoundedBox(0, 0, 0, pw, ph, tab.color)
		local text = {}
		if tab.lforce then
			text.text = YRP.lang_string(tab.header) .. ":"
		else
			text.text = tab.header .. ":"
		end
		text.x = ctr(10)
		text.y = ph / 4
		text.font = "mat1text"
		text.color = Color(255, 255, 255, 255)
		text.br = 1
		text.ax = 0
		DrawText(text)
	end

	pnl.DComboBox = createD("DComboBox", pnl.line, tab.w, tab.h / 2, tab.brx, tab.h / 2)
	for i, v in pairs(tab.choices) do
		if tab.value == i then
			pnl.DComboBox:AddChoice(v, i, true)
		else
			pnl.DComboBox:AddChoice(v, i)
		end
	end
	pnl.DComboBox.serverside = false
	if tab.netstr != nil and tab.uniqueID != nil then
		function pnl.DComboBox:OnSelect(index, value, data)
			net.Start(tab.netstr)
				net.WriteString(tab.uniqueID)
				net.WriteString(pnl.DComboBox:GetOptionData(pnl.DComboBox:GetSelectedID()))
			net.SendToServer()
		end
		net.Receive(tab.netstr, function(len)
			local _uid = tonumber(net.ReadString())
			local _str = net.ReadString()
			if pa(pnl.DComboBox) then
				pnl.DComboBox.serverside = true
				pnl.DComboBox:SetText(_str)
				pnl.DComboBox.serverside = false
			end
		end)
	end

	if tab.parent != nil and tab.parent.AddItem != nil then
		tab.parent:AddItem(pnl.line)
	end
	return pnl
end

function DColor(tab)
	tab = tab or {}
	tab.parent = tab.parent or nil
	if tab.parent != nil then
		tab.w = tab.w or tab.parent:GetWide() or 300
	else
		tab.w = tab.w or 300
	end
	tab.h = tab.h or ctr(100)
	tab.x = tab.x or 0
	tab.y = tab.y or 0
	tab.color = tab.color or Color(255, 255, 255)

	tab.header = tab.header or "NOHEADER"
	tab.value = tab.value or "NOTEXT"
	tab.lforce = tab.lforce or true

	local pnl = {}

	pnl.line = createD("DPanel", tab.parent, tab.w, tab.h, tab.x, tab.x)
	function pnl.line:Paint(pw, ph)
		draw.RoundedBox(0, 0, 0, pw, ph, tab.color)
		local text = {}
		if tab.lforce then
			text.text = YRP.lang_string(tab.header) .. ":"
		else
			text.text = tab.header .. ":"
		end
		text.x = ctr(10)
		text.y = ph / 4
		text.font = "mat1text"
		text.color = Color(255, 255, 255, 255)
		text.br = 1
		text.ax = 0
		DrawText(text)
	end

	pnl.DButton = createD("DButton", pnl.line, tab.w, tab.h / 2, tab.brx, tab.h / 2)
	pnl.DButton:SetText("")
	pnl.DButton.serverside = false
	pnl.DButton.color = stc(tab.value)
	function pnl.DButton:Paint(pw, ph)
		draw.RoundedBox(0, 0, 0, pw, ph, self.color)
		local change = {}
		change.text = "change"
		change.font = "mat1header"
		change.x = pw / 2
		change.y = ph / 2
		DrawText(change)
	end
	if tab.netstr != nil and tab.uniqueID != nil then
		function pnl.DButton:DoClick()
			local window = createD("DFrame", nil, ctr(20 + 500 + 20), ctr(50 + 20 + 500 + 20), 0, 0)
			window:Center()
			window:MakePopup()
			window:SetTitle("")
			function window:Paint(pw, ph)
				surfaceWindow(self, pw, ph, YRP.lang_string("LID_color"))
			end
			window.cm = createD("DColorMixer", window, ctr(500), ctr(500), ctr(20), ctr(50 + 20))
			function window.cm:ValueChanged(col)
				pnl.DButton.tabcolor = TableToColorStr(col)
				pnl.DButton.color = StringToColor(pnl.DButton.tabcolor)
				net.Start(tab.netstr)
					net.WriteString(tab.uniqueID)
					net.WriteString(pnl.DButton.tabcolor)
				net.SendToServer()
			end
		end
		net.Receive(tab.netstr, function(len)
			local _uid = tonumber(net.ReadString())
			local _str = net.ReadString()
			if pa(pnl.DButton) then
				pnl.DButton.serverside = true
				pnl.DButton.color = stc(_str)
				pnl.DButton.serverside = false
			end
		end)
	end

	if tab.parent != nil and tab.parent.AddItem != nil then
		tab.parent:AddItem(pnl.line)
	end
	return pnl
end

function DIntBox(tab)
	tab = tab or {}
	tab.parent = tab.parent or nil
	if tab.parent != nil then
		tab.w = tab.w or tab.parent:GetWide() or 300
	else
		tab.w = tab.w or 300
	end
	tab.h = tab.h or ctr(100)
	tab.x = tab.x or 0
	tab.y = tab.y or 0
	tab.color = tab.color or Color(255, 255, 255)

	tab.header = tab.header or "NOHEADER"
	tab.value = tab.value or -1
	tab.lforce = tab.lforce or true

	tab.min = tonumber(tab.min) or 0
	tab.max = tonumber(tab.max) or 100

	local pnl = {}

	pnl.line = createD("DPanel", tab.parent, tab.w, tab.h, tab.x, tab.x)
	function pnl.line:Paint(pw, ph)
		draw.RoundedBox(0, 0, 0, pw, ph, tab.color)
		local text = {}
		if tab.lforce then
			text.text = YRP.lang_string(tab.header) .. ":"
		else
			text.text = tab.header .. ":"
		end
		text.x = ctr(10)
		text.y = ph / 4
		text.font = "mat1text"
		text.color = Color(255, 255, 255, 255)
		text.br = 1
		text.ax = 0
		DrawText(text)
	end

	pnl.DNumberWang = createD("DNumberWang", pnl.line, tab.w, tab.h / 2, tab.brx, tab.h / 2)
	pnl.DNumberWang:SetMin(tab.min)
	pnl.DNumberWang:SetMax(tab.max)
	pnl.DNumberWang:SetValue(tab.value)
	pnl.DNumberWang.serverside = false
	if tab.netstr != nil and tab.uniqueID != nil then
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
		net.Receive(tab.netstr, function(len)
			local _uid = tonumber(net.ReadString())
			local _val = tonumber(net.ReadString())
			if pa(pnl.DNumberWang) then
				pnl.DNumberWang.serverside = true
				pnl.DNumberWang:SetValue(_val)
				pnl.DNumberWang.serverside = false
			end
		end)
	end

	if tab.parent != nil and tab.parent.AddItem != nil then
		tab.parent:AddItem(pnl.line)
	end
	return pnl
end

function DTextBox(tab)
	tab = tab or {}
	tab.parent = tab.parent or nil
	if tab.parent != nil then
		tab.w = tab.w or tab.parent:GetWide() or 300
	else
		tab.w = tab.w or 300
	end
	tab.h = tab.h or ctr(100)
	tab.x = tab.x or 0
	tab.y = tab.y or 0
	tab.color = tab.color or Color(255, 255, 255)

	tab.header = tab.header or "NOHEADER"
	tab.value = tab.value or "NOTEXT"
	tab.lforce = tab.lforce or true

	local pnl = {}

	pnl.line = createD("DPanel", tab.parent, tab.w, tab.h, tab.x, tab.x)
	function pnl.line:Paint(pw, ph)
		draw.RoundedBox(0, 0, 0, pw, ph, tab.color)
		local text = {}
		if tab.lforce then
			text.text = YRP.lang_string(tab.header) .. ":"
		else
			text.text = tab.header .. ":"
		end
		text.x = ctr(10)
		text.y = ph / 4
		text.font = "mat1text"
		text.color = Color(255, 255, 255, 255)
		text.br = 1
		text.ax = 0
		DrawText(text)

		if dmg != nil and pnl.dtextentry != nil then
			local DMG = {}
			DMG.text = dmg:GetValue() * pnl.dtextentry:GetValue() .. " " .. YRP.lang_string("LID_damage")
			DMG.x = pw - ctr(10)
			DMG.y = ph / 2
			DMG.font = "mat1header"
			DMG.color = Color(0, 0, 0, 255)
			DMG.br = 1
			DMG.ax = 2
			DrawText(DMG)
		end
	end

	pnl.DTextEntry = createD("DTextEntry", pnl.line, tab.w, tab.h / 2, tab.brx, tab.h / 2)
	pnl.DTextEntry:SetText(tab.value)
	pnl.DTextEntry.serverside = false
	if tab.netstr != nil and tab.uniqueID != nil then
		function pnl.DTextEntry:OnChange()
			net.Start(tab.netstr)
				net.WriteString(tab.uniqueID)
				net.WriteString(self:GetText())
			net.SendToServer()
		end
		net.Receive(tab.netstr, function(len)
			local _uid = tonumber(net.ReadString())
			local _str = net.ReadString()
			if pa(pnl.DTextEntry) then
				pnl.DTextEntry.serverside = true
				pnl.DTextEntry:SetText(_str)
				pnl.DTextEntry.serverside = false
			end
		end)
	end

	if tab.parent != nil and tab.parent.AddItem != nil then
		tab.parent:AddItem(pnl.line)
	end
	return pnl
end

function DNumberWang(tab)
	tab = tab or {}
	tab.w = tab.w or 10
	tab.h = tab.h or 10
	tab.min = tonumber(tab.min) or 0
	tab.max = tonumber(tab.max) or 100
	local dnw = createD("DNumberWang", tab.parent, tab.w, tab.h / 2, tab.x, tab.h / 2)
	dnw:SetMin(tab.min)
	dnw:SetMax(tab.max)
	dnw:SetValue(tab.value)
	dnw.serverside = false
	if tab.netstr != nil and tab.uniqueID != nil then
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
		net.Receive(tab.netstr, function(len)
			local _uid = tonumber(net.ReadString())
			local _val = tonumber(net.ReadString())
			if pa(dnw) then
				dnw.serverside = true
				dnw:SetValue(_val)
				dnw.serverside = false
			end
		end)
	end
	return dnw
end

function DAttributeBar(tab)
	tab = tab or {}
	tab.parent = tab.parent or nil
	if tab.parent != nil then
		tab.w = tab.w or tab.parent:GetWide() or 300
	else
		tab.w = tab.w or 300
	end
	tab.h = tab.h or ctr(120)
	tab.x = tab.x or 0
	tab.y = tab.y or 0
	tab.color = tab.color or Color(255, 255, 255)
	tab.len = table.Count(tab.dnw)

	tab.header = tab.header or "NOHEADER"
	tab.value = tab.value or "NOTEXT"
	tab.lforce = tab.lforce or true

	tab.min = tonumber(tab.min) or 0
	tab.max = tonumber(tab.max) or 100

	local pnl = {}

	pnl.line = createD("DPanel", tab.parent, tab.w, tab.h, tab.x, tab.x)
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

		if pnl.cu != nil and pnl.ma != nil then
			tab.dnw[1].value = pnl.cu:GetValue() or tab.dnw[1].value
			tab.dnw[2].value = pnl.ma:GetValue() or tab.dnw[2].value
			if tab.dnw[3] != nil then
				tab.dnw[3].value = pnl.up:GetValue() or tab.dnw[3].value
				if pnl.refresh then
					pnl.val3 = pnl.val3 + tab.dnw[3].value
					if pnl.val3 > tab.dnw[2].value then
						pnl.val3 = 0
					elseif pnl.val3 < 0 then
						pnl.val3 = tab.dnw[4].value
					end
				end
				if tab.dnw[4] != nil then
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
			if tab.dnw[3] != nil then
				draw.RoundedBox(0, 0, ph / 4 * 3, pw * pnl.val3 / tab.dnw[2].value, ph / 4, tab.color2)
				if tab.dnw[4] != nil then
					draw.RoundedBox(0, 0, ph / 4 * 2, pw * pnl.val4 / tab.dnw[2].value, ph / 4, tab.color3)
				end
			end
			local text = {}
			if tab.lforce then
				text.text = YRP.lang_string(tab.header) .. ": " .. tab.dnw[1].value .. "/" .. tab.dnw[2].value
				if tab.dnw[3] != nil then
					text.text = text.text .. " (" .. tab.dnw[3].value
					if tab.dnw[4] != nil then
						text.text = text.text .. " | " .. tab.dnw[4].value
					end
				end
				text.text = text.text .. ")"
			else
				text.text = tab.header .. ":"
			end
			text.x = ctr(10)
			text.y = ph / 2
			text.font = "mat1text"
			text.color = Color(255, 255, 255, 255)
			text.br = 1
			text.ax = 0
			DrawText(text)
		end

	end

	tab.par = tab.parent

	tab.parent = pnl.line

	tab.dnw[1].uniqueID = tab.uniqueID
	tab.dnw[1].parent = tab.parent
	tab.dnw[1].w = tab.w / tab.len
	tab.dnw[1].h = tab.h
	tab.dnw[1].len = tab.len
	pnl.cu = DNumberWang(tab.dnw[1])

	tab.dnw[2].uniqueID = tab.uniqueID
	tab.dnw[2].parent = tab.parent
	tab.dnw[2].w = tab.w / tab.len
	tab.dnw[2].h = tab.h
	tab.dnw[2].len = tab.len
	tab.dnw[2].x = tab.w / tab.len
	pnl.ma = DNumberWang(tab.dnw[2])

	tab.dnw[3].uniqueID = tab.uniqueID
	tab.dnw[3].parent = tab.parent
	tab.dnw[3].w = tab.w / tab.len
	tab.dnw[3].h = tab.h
	tab.dnw[3].len = tab.len
	tab.dnw[3].x = tab.w / tab.len * 2
	pnl.up = DNumberWang(tab.dnw[3])

	if tab.dnw[4] != nil then
		tab.dnw[4].uniqueID = tab.uniqueID
		tab.dnw[4].parent = tab.parent
		tab.dnw[4].w = tab.w / tab.len
		tab.dnw[4].h = tab.h
		tab.dnw[4].len = tab.len
		tab.dnw[4].x = tab.w / tab.len * 3
		pnl.dn = DNumberWang(tab.dnw[4])
	end

	if tab.par != nil and tab.par.AddItem != nil then
		tab.par:AddItem(pnl.line)
	end
	return pnl
end

function DStringListBox(tab)
	tab = tab or {}
	tab.parent = tab.parent or nil
	tab.w = tab.w or ctr(300)
	tab.h = tab.h or ctr(120)
	tab.x = tab.x or 0
	tab.y = tab.y or 0
	tab.color = tab.color or Color(255, 255, 255)

	tab.header = tab.header or "NOHEADER"
	tab.value = tab.value or "NOTEXT"
	tab.lforce = tab.lforce or true

	local pnl = {}
	pnl.bg = createD("DPanel", tab.parent, tab.w, tab.h, tab.x, tab.y)
	function pnl.bg:Paint(pw, ph)
		draw.RoundedBox(0, 0, 0, pw, ph, tab.color)
		local text = {}
		if tab.lforce then
			text.text = YRP.lang_string(tab.header) .. ":"
		else
			text.text = tab.header .. ":"
		end
		text.x = ctr(10)
		text.y = ctr(25)
		text.font = "mat1text"
		text.color = Color(255, 255, 255, 255)
		text.br = 1
		text.ax = 0
		DrawText(text)
	end

	pnl.add = createD("DButton", pnl.bg, ctr(50), ctr(50), tab.w - ctr(50), 0)
	pnl.add:SetText("")
	function pnl.add:Paint(pw, ph)
		self.color = Color(0, 255, 0)
		if self:IsHovered() then
			self.color = Color(100, 255, 100)
		end
		draw.RoundedBox(0, 0, 0, pw, ph, self.color)
		draw.SimpleText("+", "DermaDefault", pw / 2, ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
	function pnl.add:DoClick()
		tab.doclick()
	end

	pnl.dpl = createD("DPanelList", pnl.bg, tab.w, tab.h - ctr(50), 0, ctr(50))
	pnl.dpl:EnableVerticalScrollbar(true)
	pnl.dpl:SetSpacing(0)
	function pnl.dpl:Paint(pw, ph)
		draw.RoundedBox(0, 0, 0, pw, ph, Color(255, 0, 0))
	end
	function pnl.dpl:AddLines(t)
		pnl.dpl:Clear()
		for i, v in pairs(t) do
			local line = createD("DButton", nil, pnl.dpl:GetWide(), ctr(70), 0, 0)
			line:SetText(v.string_name)
			line.uniqueID = v.uniqueID

			line.rem = createD("DButton", line, ctr(50), ctr(50), line:GetWide() - ctr(60 + 25), ctr(10))
			line.rem:SetText("-")
			function line.rem:DoClick()
				v.doclick()
			end

			self:AddItem(line)
		end
	end

	tab.par = tab.parent

	if tab.par != nil and tab.par.AddItem != nil then
		tab.par:AddItem(pnl.bg)
	end
	return pnl
end

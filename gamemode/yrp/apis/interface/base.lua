--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

function DHr(tab)
	tab = tab or {}
	tab.parent = tab.parent or nil
	if tab.parent != nil then
		tab.w = tab.w or tab.parent:GetWide() or 300
	else
		tab.w = tab.w or 300
	end
	tab.h = tab.h or ctr( 100 )
	tab.x = tab.x or 0
	tab.y = tab.y or 0
	tab.color = tab.color or Color( 0, 0, 0 )

	local pnl = {}

	pnl.line = createD( "DPanel", tab.parent, tab.w, tab.h, tab.x, tab.x )
	function pnl.line:Paint( pw, ph )
		draw.RoundedBox( 0, 0, 0, pw, ph, Color(255, 255, 255) )
		draw.RoundedBox( 0, 0, ph / 4, pw, ph / 2, tab.color )
	end

	if tab.parent != nil and tab.parent.AddItem != nil then
		tab.parent:AddItem( pnl.line )
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
	tab.h = tab.h or ctr( 100 )
	tab.x = tab.x or 0
	tab.y = tab.y or 0
	tab.color = tab.color or Color( 255, 255, 255 )

	tab.header = tab.header or "NOHEADER"
	tab.value = tab.value or "NOTEXT"
	tab.lforce = tab.lforce or true

	local pnl = {}

	pnl.line = createD( "DPanel", tab.parent, tab.w, tab.h, tab.x, tab.x )
	function pnl.line:Paint( pw, ph )
		draw.RoundedBox( 0, 0, 0, pw, ph, tab.color )
		local text = {}
		if tab.lforce then
			text.text = lang_string( tab.header ) .. ":"
		else
			text.text = tab.header .. ":"
		end
		text.x = ctr( 10 )
		text.y = ph / 4
		text.font = "mat1text"
		text.color = Color( 255, 255, 255, 255 )
		text.br = 1
		text.ax = 0
		DrawText( text )
	end

	pnl.DButton = createD("DButton", pnl.line, tab.w, tab.h / 2, tab.brx, tab.h / 2)
	pnl.DButton:SetText("")
	pnl.DButton.serverside = false
	function pnl.DButton:Paint(pw, ph)
		draw.RoundedBox(0, 0, 0, pw, ph, Color(255, 255, 255))
		local change = {}
		change.text = "[" .. lang_string("change") .. "] (" .. tab.value .. ")"
		change.font = "mat1header"
		change.x = ctr(10)
		change.y = ph / 2
		change.ax = 0
		DrawText( change )
	end
	if tab.netstr != nil and tab.uniqueID != nil then
		function pnl.DButton:DoClick()
			local window = createD("DFrame", nil, ctr( 20 + 500 + 20 ), ctr( 50 + 20 + 500 + 20 ), 0, 0)
			window:Center()
			window:MakePopup()
			window:SetTitle( "" )
			function window:Paint( pw, ph )
				surfaceWindow( self, pw, ph, lang_string( "usergroups" ) )
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
		net.Receive(tab.netstr, function( len )
			local _uid = tonumber(net.ReadString())
			local _str = net.ReadString()
			if pa( pnl.DButton ) then
				pnl.DButton.serverside = true
				tab.value = _str
				pnl.DButton.serverside = false
			end
		end)
	end

	if tab.parent != nil and tab.parent.AddItem != nil then
		tab.parent:AddItem( pnl.line )
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
	tab.h = tab.h or ctr( 50 )
	tab.x = tab.x or 0
	tab.y = tab.y or 0
	tab.color = tab.color or Color( 255, 255, 255 )

	tab.header = tab.header or "NOHEADER"
	tab.value = tonumber(tab.value) or 1
	tab.lforce = tab.lforce or true

	local pnl = {}

	pnl.line = createD( "DPanel", tab.parent, tab.w, tab.h, tab.x, tab.x )
	function pnl.line:Paint( pw, ph )
		draw.RoundedBox( 0, 0, 0, pw, ph, tab.color )
		local text = {}
		if tab.lforce then
			text.text = lang_string( tab.header )
		else
			text.text = tab.header
		end
		text.x = ctr( 60 )
		text.y = ph / 2
		text.font = "mat1text"
		text.color = Color( 255, 255, 255, 255 )
		text.br = 1
		text.ax = 0
		DrawText( text )
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
		net.Receive(tab.netstr, function( len )
			local _uid = tonumber(net.ReadString())
			local _int = tonumber(net.ReadString())
			if pa( pnl.DButton ) then
				pnl.DButton.serverside = true
				tab.value = _int
				pnl.DButton.serverside = false
			end
		end)
	end

	if tab.parent != nil and tab.parent.AddItem != nil then
		tab.parent:AddItem( pnl.line )
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
	tab.h = tab.h or ctr( 100 )
	tab.x = tab.x or 0
	tab.y = tab.y or 0
	tab.color = tab.color or Color( 255, 255, 255 )

	tab.header = tab.header or "NOHEADER"
	tab.value = tab.value or "NOTEXT"
	tab.lforce = tab.lforce or true

	local pnl = {}

	pnl.line = createD( "DPanel", tab.parent, tab.w, tab.h, tab.x, tab.x )
	function pnl.line:Paint( pw, ph )
		draw.RoundedBox( 0, 0, 0, pw, ph, tab.color )
		local text = {}
		if tab.lforce then
			text.text = lang_string( tab.header ) .. ":"
		else
			text.text = tab.header .. ":"
		end
		text.x = ctr( 10 )
		text.y = ph / 4
		text.font = "mat1text"
		text.color = Color( 255, 255, 255, 255 )
		text.br = 1
		text.ax = 0
		DrawText( text )
	end

	pnl.DComboBox = createD( "DComboBox", pnl.line, tab.w, tab.h / 2, tab.brx, tab.h / 2 )
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
		net.Receive(tab.netstr, function( len )
			local _uid = tonumber(net.ReadString())
			local _str = net.ReadString()
			if pa( pnl.DComboBox ) then
				pnl.DComboBox.serverside = true
				pnl.DComboBox:SetText( _str )
				pnl.DComboBox.serverside = false
			end
		end)
	end

	if tab.parent != nil and tab.parent.AddItem != nil then
		tab.parent:AddItem( pnl.line )
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
	tab.h = tab.h or ctr( 100 )
	tab.x = tab.x or 0
	tab.y = tab.y or 0
	tab.color = tab.color or Color( 255, 255, 255 )

	tab.header = tab.header or "NOHEADER"
	tab.value = tab.value or "NOTEXT"
	tab.lforce = tab.lforce or true

	local pnl = {}

	pnl.line = createD( "DPanel", tab.parent, tab.w, tab.h, tab.x, tab.x )
	function pnl.line:Paint( pw, ph )
		draw.RoundedBox( 0, 0, 0, pw, ph, tab.color )
		local text = {}
		if tab.lforce then
			text.text = lang_string( tab.header ) .. ":"
		else
			text.text = tab.header .. ":"
		end
		text.x = ctr( 10 )
		text.y = ph / 4
		text.font = "mat1text"
		text.color = Color( 255, 255, 255, 255 )
		text.br = 1
		text.ax = 0
		DrawText( text )
	end

	pnl.DButton = createD( "DButton", pnl.line, tab.w, tab.h / 2, tab.brx, tab.h / 2 )
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
		DrawText( change )
	end
	if tab.netstr != nil and tab.uniqueID != nil then
		function pnl.DButton:DoClick()
			local window = createD( "DFrame", nil, ctr( 20 + 500 + 20 ), ctr( 50 + 20 + 500 + 20 ), 0, 0 )
			window:Center()
			window:MakePopup()
			window:SetTitle( "" )
			function window:Paint( pw, ph )
				surfaceWindow( self, pw, ph, lang_string( "color" ) )
			end
			window.cm = createD( "DColorMixer", window, ctr( 500 ), ctr( 500 ), ctr( 20 ), ctr( 50 + 20 ) )
			function window.cm:ValueChanged(col)
				pnl.DButton.tabcolor = TableToColorStr(col)
				pnl.DButton.color = StringToColor(pnl.DButton.tabcolor)
				net.Start(tab.netstr)
					net.WriteString(tab.uniqueID)
					net.WriteString(pnl.DButton.tabcolor)
				net.SendToServer()
			end
		end
		net.Receive(tab.netstr, function( len )
			local _uid = tonumber(net.ReadString())
			local _str = net.ReadString()
			if pa( pnl.DButton ) then
				pnl.DButton.serverside = true
				pnl.DButton.color = stc(_str)
				pnl.DButton.serverside = false
			end
		end)
	end

	if tab.parent != nil and tab.parent.AddItem != nil then
		tab.parent:AddItem( pnl.line )
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
	tab.h = tab.h or ctr( 100 )
	tab.x = tab.x or 0
	tab.y = tab.y or 0
	tab.color = tab.color or Color( 255, 255, 255 )

	tab.header = tab.header or "NOHEADER"
	tab.value = tab.value or "NOTEXT"
	tab.lforce = tab.lforce or true

	tab.min = tonumber(tab.min) or 0
	tab.max = tonumber(tab.max) or 100

	local pnl = {}

	pnl.line = createD( "DPanel", tab.parent, tab.w, tab.h, tab.x, tab.x )
	function pnl.line:Paint( pw, ph )
		draw.RoundedBox( 0, 0, 0, pw, ph, tab.color )
		local text = {}
		if tab.lforce then
			text.text = lang_string( tab.header ) .. ":"
		else
			text.text = tab.header .. ":"
		end
		text.x = ctr( 10 )
		text.y = ph / 4
		text.font = "mat1text"
		text.color = Color( 255, 255, 255, 255 )
		text.br = 1
		text.ax = 0
		DrawText( text )
	end

	pnl.DNumberWang = createD( "DNumberWang", pnl.line, tab.w, tab.h / 2, tab.brx, tab.h / 2 )
	pnl.DNumberWang:SetValue(tab.value)
	pnl.DNumberWang:SetMin(tab.min)
	pnl.DNumberWang:SetMax(tab.max)
	pnl.DNumberWang.serverside = false
	if tab.netstr != nil and tab.uniqueID != nil then
		function pnl.DNumberWang:OnValueChanged(val)
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
		net.Receive(tab.netstr, function( len )
			local _uid = tonumber(net.ReadString())
			local _val = tonumber(net.ReadString())
			if pa( pnl.DNumberWang ) then
				pnl.DNumberWang.serverside = true
				pnl.DNumberWang:SetValue( _val )
				pnl.DNumberWang.serverside = false
			end
		end)
	end

	if tab.parent != nil and tab.parent.AddItem != nil then
		tab.parent:AddItem( pnl.line )
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
	tab.h = tab.h or ctr( 100 )
	tab.x = tab.x or 0
	tab.y = tab.y or 0
	tab.color = tab.color or Color( 255, 255, 255 )

	tab.header = tab.header or "NOHEADER"
	tab.value = tab.value or "NOTEXT"
	tab.lforce = tab.lforce or true

	local pnl = {}

	pnl.line = createD( "DPanel", tab.parent, tab.w, tab.h, tab.x, tab.x )
	function pnl.line:Paint( pw, ph )
		draw.RoundedBox( 0, 0, 0, pw, ph, tab.color )
		local text = {}
		if tab.lforce then
			text.text = lang_string( tab.header ) .. ":"
		else
			text.text = tab.header .. ":"
		end
		text.x = ctr( 10 )
		text.y = ph / 4
		text.font = "mat1text"
		text.color = Color( 255, 255, 255, 255 )
		text.br = 1
		text.ax = 0
		DrawText( text )

		if dmg != nil and pnl.dtextentry != nil then
			local DMG = {}
			DMG.text = dmg:GetValue() * pnl.dtextentry:GetValue() .. " " .. lang_string( "damage" )
			DMG.x = pw - ctr( 10 )
			DMG.y = ph / 2
			DMG.font = "mat1header"
			DMG.color = Color( 0, 0, 0, 255 )
			DMG.br = 1
			DMG.ax = 2
			DrawText( DMG )
		end
	end

	pnl.DTextEntry = createD( "DTextEntry", pnl.line, tab.w, tab.h / 2, tab.brx, tab.h / 2 )
	pnl.DTextEntry:SetText( tab.value )
	pnl.DTextEntry.serverside = false
	if tab.netstr != nil and tab.uniqueID != nil then
		function pnl.DTextEntry:OnChange()
			net.Start(tab.netstr)
				net.WriteString(tab.uniqueID)
				net.WriteString(self:GetText())
			net.SendToServer()
		end
		net.Receive(tab.netstr, function( len )
			local _uid = tonumber(net.ReadString())
			local _str = net.ReadString()
			if pa( pnl.DTextEntry ) then
				pnl.DTextEntry.serverside = true
				pnl.DTextEntry:SetText( _str )
				pnl.DTextEntry.serverside = false
			end
		end)
	end

	if tab.parent != nil and tab.parent.AddItem != nil then
		tab.parent:AddItem( pnl.line )
	end
	return pnl
end

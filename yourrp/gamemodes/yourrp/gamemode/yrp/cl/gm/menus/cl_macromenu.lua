--Copyright (C) 2017-2022 D4KiR (https://www.gnu.org/licenses/gpl.txt)

--#MACROMENU

local _mm = {}

function YRPToggleMacroMenu()
	if YRPIsNoMenuOpen() then
		OpenMacroMenu()
	end
end

function CloseMacroMenu()
	if _mm.window != nil then
		closeMenu()
		_mm.window:Remove()
		_mm.window = nil
	end
end

function UseMacro(uid)
	if wk(uid) and wk(_mm.tab) and wk(_mm.tab[uid]) and wk(_mm.tab[uid].value) then
		local mtext = _mm.tab[uid].value
		local tim = 0

		local tab = string.Explode( "\n", mtext)
		for i, v in pairs(tab) do
			if strEmpty( v) then
				table.RemoveByValue(tab, v)
			end
		end

		for i, v in pairs(tab) do
			if !strEmpty( v) then
				if string.StartWith( v, "#" ) then
				elseif string.StartWith( v, "/timer" ) then
					local cd = tonumber(string.sub( v, 7) )
					tim = tim + cd
				else
					timer.Simple(tim, function()
						LocalPlayer():ConCommand( "say \"" .. v .. "\"" )
					end)
				end
			end
		end
	end
end

net.Receive( "yrp_get_macros", function(len)
	local lply = LocalPlayer()
	_mm.tab = net.ReadTable()

	if pa(_mm.content) then
		local content = _mm.content

		_mm.uid = 1

		_mm.list = createD( "DScrollPanel", content, YRP.ctr(80 * 7 + 20 * 6 + 36), YRP.ctr(80 * 3 + 20 * 2), 0, 0)

		_mm.tf = createD( "DTextEntry", content, YRP.ctr(80 * 7 + 20 * 6 + 36), YRP.ctr(80 * 3 + 20 * 2), 0, YRP.ctr(80 * 3 + 20 * 3) )
		_mm.tf:SetMultiline(true)
		function _mm.tf:OnTextChanged()
			if _mm.uid then
				net.Start( "yrp_update_macro" )
					net.WriteString(_mm.uid)
					net.WriteString(self:GetText() )
				net.SendToServer()
				_mm.tab[_mm.uid].value = self:GetText()
			end
		end

		_mm.use = createD( "YButton", content, YRP.ctr(300), YRP.ctr(60), YRP.ctr(0), YRP.ctr(600) )
		_mm.use:SetText( "LID_use" )
		function _mm.use:DoClick()
			UseMacro(_mm.uid)
		end

		_mm.bind = createD( "DBinder", content, YRP.ctr(300), YRP.ctr(60), YRP.ctr(320), YRP.ctr(600) )
		_mm.bind.keybind = nil
		function _mm.bind:OnChange(num)
			if num != -1 and YRPGetKeybind(self.keybind) != nil then
				if self.keybind != nil and !YRPSetKeybind(self.keybind, num) and num != 0 then
					_mm.bind:SetSelectedNumber(YRPGetKeybind(self.keybind) )
					Derma_Message(YRP.lang_string( "LID_hotkeyinuse" ) .. "!", YRP.lang_string( "LID_error" ), YRP.lang_string( "LID_ok" ) )
				end
			end
		end

		local c = 1
		for y = 0, 6 do
			for x = 0, 6 do
				local m = createD( "DButton", nil, YRP.ctr(80), YRP.ctr(80), x * YRP.ctr(80 + 20), y * YRP.ctr(80 + 20) )
				m:SetText( "" )
				m.name = _mm.tab[c].name
				m.value = _mm.tab[c].value
				m.uid = c
				function m:Paint(pw, ph)
					if self.uid == _mm.uid then
						draw.RoundedBox(YRP.ctr(10), 0, 0, pw, ph, YRPInterfaceValue( "YButton", "SC" ) )
					else
						draw.RoundedBox(YRP.ctr(10), 0, 0, pw, ph, YRPInterfaceValue( "YFrame", "HI" ) )
					end

					draw.SimpleText(self.name, "Y_12_500", pw / 2, ph / 2, Color( 255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				end
				function m:DoClick()
					_mm.tf:SetText(self.value)
					_mm.uid = self.uid
					_mm.bind.keybind = "m_" .. self.uid

					local keybind = YRPGetKeybind(_mm.bind.keybind)

					if keybind != nil then
						_mm.bind:SetValue(keybind)
					end
				end

				_mm.list:AddItem(m)

				c = c + 1
			end
		end
	end
end)

timer.Simple( 10, function()
	net.Start( "yrp_get_macros" )
	net.SendToServer()
end )

function OpenMacroMenu()
	openMenu()

	_mm.window = createD( "YFrame", nil, YRP.ctr(720 + 36), YRP.ctr(820), 0, 0)
	_mm.window:Center()
	_mm.window:MakePopup()
	_mm.window:SetTitle(YRP.lang_string( "LID_macromenu" ) )
	_mm.window:SetHeaderHeight(YRP.ctr(100) )

	_mm.content = _mm.window:GetContent()

	net.Start( "yrp_get_macros" )
	net.SendToServer()
end

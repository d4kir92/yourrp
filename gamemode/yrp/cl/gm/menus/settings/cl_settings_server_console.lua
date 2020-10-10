--Copyright (C) 2017-2020 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

net.Receive("Connect_Settings_Console", function(len)
	local PARENT = GetSettingsSite()
	
	if pa(PARENT) then

		PARENT.consolebackground = createD("DPanel", PARENT, YRP.ctr(1000), PARENT:GetTall() - YRP.ctr(40), YRP.ctr(20), YRP.ctr(20))

		function PARENT.consolebackground:OnRemove()
			net.Start("Disconnect_Settings_Console")
			net.SendToServer()
		end

		PARENT.console = createD("RichText", PARENT.consolebackground, YRP.ctr(1000), PARENT:GetTall() - YRP.ctr(40) - YRP.ctr(50), 0, 0)
		if PARENT.console.SetUnderlineFont != nil then
			PARENT.console:SetUnderlineFont("Y_18_500")
		end
		PARENT.console:SetFontInternal("Y_18_500")
		PARENT.console:InsertColorChange(0, 0, 0, 255)

		PARENT.consoletext = createD("DTextEntry", PARENT.consolebackground, YRP.ctr(1000), YRP.ctr(50), 0, PARENT:GetTall() - YRP.ctr(40) - YRP.ctr(50))
		function PARENT.consoletext:OnEnter()
			net.Start("send_console_command")
				net.WriteString(self:GetText())
			net.SendToServer()
			self:SetText("")
			self:RequestFocus()
		end
	end
end)

net.Receive("get_console_line", function(len)
	local str = net.ReadString()

	local PARENT = GetSettingsSite()
	
	if pa(PARENT) and pa(PARENT.console) then
		PARENT.console:AppendText(str)
		PARENT.console:AppendText("\n")
	end
end)

function OpenSettingsConsole()
	net.Start("Connect_Settings_Console")
	net.SendToServer()
end

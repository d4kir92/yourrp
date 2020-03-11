--Copyright (C) 2017-2020 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

net.Receive("Connect_Settings_Console", function(len)
	if pa(settingsWindow) then

		local PARENT = settingsWindow.window.site

		PARENT.consolebackground = createD("DPanel", PARENT, YRP.ctr(1000), PARENT:GetTall() - YRP.ctr(40), YRP.ctr(20), YRP.ctr(20))

		function PARENT.consolebackground:OnRemove()
			net.Start("Disconnect_Settings_Console")
			net.SendToServer()
		end

		PARENT.console = createD("RichText", PARENT.consolebackground, YRP.ctr(1000), PARENT:GetTall() - YRP.ctr(40) - YRP.ctr(50), 0, 0)
		if PARENT.console.SetUnderlineFont != nil then
			PARENT.console:SetUnderlineFont("Y_18_700")
		end
		PARENT.console:SetFontInternal("Y_18_700")
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
	if pa(settingsWindow) and pa(settingsWindow.window) and pa(settingsWindow.window.site.console) then
		settingsWindow.window.site.console:AppendText(str)
		settingsWindow.window.site.console:AppendText("\n")
	end
end)

hook.Add("open_server_console", "open_server_console", function()
	SaveLastSite()
	
	net.Start("Connect_Settings_Console")
	net.SendToServer()
end)

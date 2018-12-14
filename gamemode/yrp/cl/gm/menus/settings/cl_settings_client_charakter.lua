--Copyright (C) 2017-2018 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

net.Receive("getrpdescription", function()
	local rpdescription = net.ReadString()
	if pa(settingsWindow) then
		local cl_rpDescription = createVGUI("DTextEntry", settingsWindow.window.site, 1200, 400, 10, 200)
		cl_rpDescription:SetMultiline(true)
		if rpdescription != nil then
			cl_rpDescription:SetText(rpdescription)
		end
		function cl_rpDescription:OnChange()
			net.Start("change_rpdescription")
				net.WriteString(cl_rpDescription:GetText())
			net.SendToServer()
		end
	end
end)

net.Receive("getCharakterList", function()
	local _charTab = net.ReadTable()

	if pa(settingsWindow) then
		local cl_rpName = createVGUI("DTextEntry", settingsWindow.window.site, 400, 50, 10, 50)
		if _charTab.rpname != nil then
			cl_rpName:SetText(_charTab.rpname)
		end
		function cl_rpName:OnChange()
			net.Start("change_rpname")
				net.WriteString(cl_rpName:GetText())
			net.SendToServer()
		end
	end
end)

hook.Add("open_client_character", "open_client_character", function()
	SaveLastSite()
	local w = settingsWindow.window.sitepanel:GetWide()
	local h = settingsWindow.window.sitepanel:GetTall()

	settingsWindow.window.site = createD("DPanel", settingsWindow.window.sitepanel, w, h, 0, 0)
	function settingsWindow.window.site:Paint(pw, ph)
		draw.SimpleTextOutlined(YRP.lang_string("LID_name") .. ":", "sef", ctr(10), ctr(50), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM, 1, Color(0, 0, 0))

		draw.SimpleTextOutlined(YRP.lang_string("LID_description") .. ":", "sef", ctr(10), ctr(45 + 150), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM, 1, Color(0, 0, 0))
	end

	net.Start("getCharakterList")
	net.SendToServer()
end)

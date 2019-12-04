--Copyright (C) 2017-2019 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

hook.Add("open_client_keybinds", "open_client_keybinds", function()
	SaveLastSite()
	local w = settingsWindow.window.sitepanel:GetWide()
	local h = settingsWindow.window.sitepanel:GetTall()

	local _wide = 800

	settingsWindow.window.site = createD("DPanel", settingsWindow.window.sitepanel, w, h, 0, 0)
	--sheet:AddSheet(YRP.lang_string("LID_character"), cl_charPanel, "icon16/user_edit.png")
	function settingsWindow.window.site:Paint(pw, ph)
		draw.RoundedBox(0, 0, 0, pw, ph, Color(0, 0, 0, 255))
		draw.SimpleTextOutlined("MOVED TO F4/J", "sef", YRP.ctr(100), YRP.ctr(100), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM, 1, Color(0, 0, 0))
	end
end)

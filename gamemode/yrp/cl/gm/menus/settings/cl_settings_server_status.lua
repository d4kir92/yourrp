--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

net.Receive("Connect_Settings_Status", function(len)
	if pa(settingsWindow) then
		function settingsWindow.window.site:Paint(pw, ph)
			draw.RoundedBox(4, 0, 0, pw, ph, Color(0, 0, 0, 254))

			local wip = {}
			wip.text = "wip"
			wip.x = pw / 2
			wip.y = ph / 2
			wip.font = "mat1header"
			DrawText(wip)
		end

		local PARENT = settingsWindow.window.site

		function PARENT:OnRemove()
			net.Start("Disconnect_Settings_Status")
			net.SendToServer()
		end

		local ST = net.ReadTable()
		printTab(ST)
	end
end)

hook.Add("open_server_status", "open_server_status", function()
	SaveLastSite()
	local w = settingsWindow.window.sitepanel:GetWide()
	local h = settingsWindow.window.sitepanel:GetTall()
	settingsWindow.window.site = createD("DPanel", settingsWindow.window.sitepanel, w, h, 0, 0)
	net.Start("Connect_Settings_Status")
	net.SendToServer()
end)

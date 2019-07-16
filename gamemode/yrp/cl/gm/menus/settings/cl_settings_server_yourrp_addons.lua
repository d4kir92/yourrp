--Copyright (C) 2017-2019 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

function AddYRPAddon(parent, tab)
	local _add_on = createD("DPanel", parent, YRP.ctr(1600), YRP.ctr(4 * 100 + 5 * 20), 0, 0)
	function _add_on:Paint(pw, ph)
		draw.RoundedBox(0, 0, 0, pw, ph, Color(255, 255, 255))
	end

	_add_on.icon = createD("DHTML", _add_on, YRP.ctr(100), YRP.ctr(100), YRP.ctr(20), YRP.ctr(20))
	if tab.icon == "" then
		tab.icon = "http://www.famfamfam.com/lab/icons/silk/icons/plugin.png"
	end
	_add_on.icon:SetHTML(GetHTMLImage(tab.icon, YRP.ctr(100), YRP.ctr(100)))

	if tab.workshopid != "" then
		_add_on.workshop = createD("DHTML", _add_on, YRP.ctr(100), YRP.ctr(100), YRP.ctr(20), YRP.ctr(140))
		_add_on.workshop:SetHTML(GetHTMLImage("https://upload.wikimedia.org/wikipedia/commons/thumb/8/83/Steam_icon_logo.svg/120px-Steam_icon_logo.svg.png", YRP.ctr(100), YRP.ctr(100)))
		_add_on.workshopbutton = createD("DButton", _add_on.workshop, YRP.ctr(100), YRP.ctr(100), 0, 0)
		_add_on.workshopbutton:SetText("")
		function _add_on.workshopbutton:Paint(pw, ph)
			local box = {}
			box.color = Color(0, 0, 0, 0)
			box.hovercolor = Color(255, 255, 255, 100)
			box.text = {}
			box.text.text = ""
			DrawButton(self, box)
		end
		function _add_on.workshopbutton:DoClick()
			gui.OpenURL("https://steamcommunity.com/sharedfiles/filedetails/?id=" .. tab.workshopid)
		end
	end

	if tab.discord != "" then
		_add_on.discord = createD("DHTML", _add_on, YRP.ctr(100), YRP.ctr(100), YRP.ctr(20), YRP.ctr(260))
		_add_on.discord:SetHTML(GetHTMLImage("https://discordapp.com/assets/f8389ca1a741a115313bede9ac02e2c0.svg", YRP.ctr(100), YRP.ctr(100)))
		_add_on.discordbutton = createD("DButton", _add_on.discord, YRP.ctr(100), YRP.ctr(100), 0, 0)
		_add_on.discordbutton:SetText("")
		function _add_on.discordbutton:Paint(pw, ph)
			local box = {}
			box.color = Color(0, 0, 0, 0)
			box.hovercolor = Color(255, 255, 255, 100)
			box.text = {}
			box.text.text = ""
			DrawButton(self, box)
		end
		function _add_on.discordbutton:DoClick()
			gui.OpenURL(tab.discord)
		end
	end

	if tab.settings != "" then
		_add_on.settings = createD("DButton", _add_on, YRP.ctr(100), YRP.ctr(100), YRP.ctr(20), YRP.ctr(380))
		_add_on.settings:SetText("")
		function _add_on.settings:Paint(pw, ph)
			surface.SetDrawColor(0, 0, 0, 255)
			surface.SetMaterial(YRP.GetDesignIcon("settings"))
			surface.DrawTexturedRect(0, 0, pw, ph)

			local box = {}
			box.color = Color(0, 0, 0, 0)
			box.hovercolor = Color(255, 255, 255, 100)
			box.text = {}
			box.text.text = ""
			DrawButton(self, box)
		end
		function _add_on.settings:DoClick()
			hook.Call(tab.settings)
			CloseSettings()
		end
	end

	if tab.name != "" then
		_add_on.name = createD("DTextEntry", _add_on, _add_on:GetWide() - YRP.ctr(160), YRP.ctr(100), YRP.ctr(140), YRP.ctr(20))
		_add_on.name:SetEditable(false)
		_add_on.name:SetText(YRP.lang_string("LID_name") .. ": " .. tab.name)
	end

	if tab.author != "" then
		_add_on.author = createD("DTextEntry", _add_on, _add_on:GetWide() - YRP.ctr(160), YRP.ctr(100), YRP.ctr(140), YRP.ctr(140))
		_add_on.author:SetEditable(false)
		_add_on.author:SetText(YRP.lang_string("LID_s_author") .. ": " .. tab.author)
	end

	if tab.description != "" then
		_add_on.description = createD("DTextEntry", _add_on, _add_on:GetWide() - YRP.ctr(160), YRP.ctr(220), YRP.ctr(140), YRP.ctr(260))
		_add_on.description:SetEditable(false)
		_add_on.description:SetMultiline(true)
		_add_on.description:SetText(YRP.lang_string("LID_description") .. ":\n" .. tab.description)
	end

	parent:AddItem(_add_on)
	return _add_on
end

net.Receive("Connect_Settings_YourRP_Addons", function(len)
	if pa(settingsWindow) then
		function settingsWindow.window.site:Paint(pw, ph)
			draw.RoundedBox(4, 0, 0, pw, ph, Color(0, 0, 0, 254))
		end

		local PARENT = settingsWindow.window.site

		function PARENT:OnRemove()
			net.Start("Disconnect_Settings_YourRP_Addons")
			net.SendToServer()
		end

		local YRPA = net.ReadTable()

		local yrp_addons = createD("DPanelList", PARENT, YRP.ctr(1600), ScrH() - YRP.ctr(140), YRP.ctr(20), YRP.ctr(20))
		yrp_addons:EnableVerticalScrollbar(true)
		yrp_addons:SetSpacing(10)
		function yrp_addons:Paint(pw, ph)
			local box = {}
			box.w = pw
			box.h = ph
			box.color = Color(80, 80, 80)
			DrawBox(box)
		end

		if table.Count(YRPA) > 0 then
			for i, addon in pairs(YRPA) do
				AddYRPAddon(yrp_addons, addon)
			end
		else
			local _empty = createD("DPanel", yrp_addons, YRP.ctr(1600), YRP.ctr(4 * 100 + 5 * 20), 0, 0)
			function _empty:Paint(pw, ph)
				draw.RoundedBox(0, 0, 0, pw, ph, Color(255, 255, 255))
				local tab = {}
				tab.x = pw / 2
				tab.y = ph / 2
				tab.ax = 1
				tab.ay = 1
				tab.font = "mat1text"
				tab.text = "empty"
				DrawText(tab)
			end
			yrp_addons:AddItem(_empty)
		end
	end
end)

hook.Add("open_server_yourrp_addons", "open_server_yourrp_addons", function()
	SaveLastSite()
	local w = settingsWindow.window.sitepanel:GetWide()
	local h = settingsWindow.window.sitepanel:GetTall()
	settingsWindow.window.site = createD("DPanel", settingsWindow.window.sitepanel, w, h, 0, 0)
	net.Start("Connect_Settings_YourRP_Addons")
	net.SendToServer()
end)

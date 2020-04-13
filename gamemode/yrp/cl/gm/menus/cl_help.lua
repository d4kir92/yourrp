--Copyright (C) 2017-2020 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

--#help #keybinds #website

HELPMENU = HELPMENU or {}
HELPMENU.open = false

function ToggleHelpMenu()
	if !HELPMENU.open and YRPIsNoMenuOpen() then
		OpenHelpMenu()
	else
		CloseHelpMenu()
	end
end

function CloseHelpMenu()
	HELPMENU.open = false
	if HELPMENU.window != nil then
		closeMenu()
		HELPMENU.window:Remove()
		HELPMENU.window = nil
	end
end

function replaceKeyName(str)
	if str == "uparrow" or str == "pgup" then
		return "↑"
	elseif str == "downarrow" or str == "pgdn" then
		return "↓"
	elseif str == "rightarrow" then
		return "→"
	elseif str == "leftarrow" then
		return "←"
	elseif str == "home" then
		return YRP.lang_string("LID_numpadhome")
	elseif str == "plus" then
		return "+"
	elseif str == "minus" then
		return "-"
	elseif str == "ins" then
		return YRP.lang_string("LID_keyinsert")
	else
		return str
	end
end

function nicekey(key_str)
	local _str = string.lower(tostring(key_str))

	if _str != nil then
		if string.find(_str, "kp_") then
			local _end = string.sub(_str, 4)
			_end = replaceKeyName(_end)

			return YRP.lang_string("LID_keynumpad") .. " " .. _end
		elseif string.find(_str, "pg") then
			return YRP.lang_string("LID_keypage") .. " " .. replaceKeyName(_str)
		end

		_str = replaceKeyName(_str)
	end

	return tostring(_str)
end

function AddKeybind(plist, keybind, lstr, icon, disabled)
	local lply = LocalPlayer()
	if disabled and !lply:HasAccess() then return end
	local kb = createD("DPanel", nil, YRP.ctr(100), YRP.ctr(50), 0, 0)
	kb.key = keybind

	function kb:Paint(pw, ph)
		draw.SimpleText(string.upper("[" .. nicekey(self.key) .. "]"), "Y_18_500", ph + YRP.ctr(10), ph / 2, Color(255, 255, 255, 255), 0, 1)
		local text = ""
		local color = Color(255, 255, 255, 255)

		if disabled != nil and !GetGlobalDBool(disabled) then
			text = "[" .. YRP.lang_string("LID_disabled") .. "] "
			color = Color(255, 255, 100, 255)
		end

		text = text .. YRP.lang_string(lstr)
		draw.SimpleText(string.upper("[" .. nicekey(self.key) .. "]"), "Y_18_500", ph + YRP.ctr(10), ph / 2, color, 0, 1)
		draw.SimpleText(text, "Y_18_500", ph + YRP.ctr(300), ph / 2, color, 0, 1)
		YRP.DrawIcon(YRP.GetDesignIcon(icon), ph - YRP.ctr(4), ph - YRP.ctr(4), YRP.ctr(2), YRP.ctr(2), color)
	end

	plist:AddItem(kb)
end

function AddKeybindBr(plist)
	local kb = createD("DPanel", nil, YRP.ctr(100), YRP.ctr(4), 0, 0)

	function kb:Paint(pw, ph)
		draw.RoundedBox(0, 0, ph / 4, pw, ph / 2, Color(255, 255, 255, 255))
	end

	plist:AddItem(kb)
end

net.Receive("getsitehelp", function(len)
	if pa(HELPMENU.mainmenu.site) then
		local welcome_message = net.ReadString()
		local motd = net.ReadString()
		local posy = 0

		if !strEmpty(welcome_message) then
			local wm = createD("DPanel", HELPMENU.mainmenu.site, HELPMENU.content:GetWide() - YRP.ctr(2 * 20), YRP.ctr(60), 0, posy)

			function wm:Paint(pw, ph)
				draw.SimpleText(welcome_message, "Y_22_500", 0, ph / 2, Color(255, 255, 255, 255), 0, 1)
			end

			posy = posy + wm:GetTall() + YRP.ctr(20)
		end

		if !strEmpty(motd) then
			local mo = createD("DPanel", HELPMENU.mainmenu.site, HELPMENU.content:GetWide() - YRP.ctr(2 * 20), YRP.ctr(60), 0, posy)

			function mo:Paint(pw, ph)
				draw.SimpleText(YRP.lang_string("LID_motd") .. ": " .. motd, "Y_22_500", 0, ph / 2, Color(255, 255, 255, 255), 0, 1)
			end

			posy = posy + mo:GetTall() + YRP.ctr(20)
		end

		local keybinds = createD("DPanelList", HELPMENU.mainmenu.site, YRP.ctr(1200), HELPMENU.content:GetTall(), 0, posy)
		keybinds:SetSpacing(YRP.ctr(6))

		AddKeybind(keybinds, "F1", "LID_help", "help")
		AddKeybind(keybinds, GetKeybindName("menu_role"), "LID_rolemenu", "role", "bool_players_can_switch_role")
		AddKeybind(keybinds, GetKeybindName("menu_buy"), "LID_buymenu", "shop")
		AddKeybind(keybinds, "F7", "LID_sendticket", "feedback")

		AddKeybind(keybinds, GetKeybindName("menu_character_selection"), "LID_characterselection", "character")
		AddKeybind(keybinds, GetKeybindName("toggle_mouse"), "LID_togglemouse", "mouse")
		AddKeybind(keybinds, GetKeybindName("menu_settings"), "LID_settings", "settings")
		AddKeybind(keybinds, GetKeybindName("toggle_map"), "LID_map", "map", "bool_map_system")
		--AddKeybind(keybinds, GetKeybindName("menu_inventory"), "LID_inventory", "work", "bool_inventory_system")
		AddKeybind(keybinds, GetKeybindName("menu_appearance"), "LID_appearance", "face", "bool_appearance_system")
		AddKeybind(keybinds, GetKeybindName("menu_emotes"), "LID_emotes", "smile")
		AddKeybind(keybinds, GetKeybindName("menu_laws"), "LID_laws", "list")
		AddKeybindBr(keybinds)
		AddKeybind(keybinds, GetKeybindName("menu_interact"), "LID_interact", "role")
		AddKeybind(keybinds, GetKeybindName("drop_item"), "LID_drop", "pin_drop", "bool_players_can_drop_weapons")
		AddKeybindBr(keybinds)
		AddKeybind(keybinds, GetKeybindName("view_switch"), "LID_switchview", "3d_rotation")
		AddKeybind(keybinds, GetKeybindName("view_up"), "LID_increaseviewingheight", "64_angle-up")
		AddKeybind(keybinds, GetKeybindName("view_down"), "LID_decreaseviewingheight", "64_angle-down")
		AddKeybind(keybinds, GetKeybindName("view_right"), "LID_viewingpositiontotheright", "64_angle-right")
		AddKeybind(keybinds, GetKeybindName("view_left"), "LID_viewingpositiontotheleft", "64_angle-left")
		AddKeybind(keybinds, GetKeybindName("view_spin_right"), "LID_turnviewingangletotheright", "rotate_right")
		AddKeybind(keybinds, GetKeybindName("view_spin_left"), "LID_turnviewingangletotheleft", "rotate_left")
		AddKeybind(keybinds, GetKeybindName("view_zoom_out"), "LID_holdtozoomoutview", "unfold_more")
		AddKeybind(keybinds, GetKeybindName("view_zoom_in"), "LID_holdtozoominview", "unfold_less")
		AddKeybindBr(keybinds)
		AddKeybind(keybinds, GetKeybindName("sp_open"), "LID_presstoopensmartphone", "smartphone", "bool_smartphone_system")
		AddKeybind(keybinds, GetKeybindName("sp_close"), "LID_presstoclosesmartphone", "system_update", "bool_smartphone_system")
		AddKeybindBr(keybinds)
		AddKeybind(keybinds, GetKeybindName("speak_next"), "LID_nextvoicechannel", "record_voice_over", "bool_voice_channels")
		AddKeybind(keybinds, GetKeybindName("speak_prev"), "LID_previousvoicechannel", "record_voice_over", "bool_voice_channels")
		AddKeybind(keybinds, GetKeybindName("mute_voice"), "LID_mutevoice", "")

		HELPMENU.discord = createD("YButton", HELPMENU.mainmenu.site, YRP.ctr(500), YRP.ctr(50), HELPMENU.content:GetWide() - YRP.ctr(560), YRP.ctr(20 + 50 + 20))
		HELPMENU.discord:SetText("Get Live Support")

		function HELPMENU.discord:Paint(pw, ph)
			hook.Run("YButtonPaint", self, pw, ph)
		end

		function HELPMENU.discord:DoClick()
			gui.OpenURL("https://discord.gg/sEgNZxg")
		end

		local version = createD("DPanel", HELPMENU.mainmenu.site, HELPMENU.content:GetWide() - YRP.ctr(2 * 20), YRP.ctr(50), 0, HELPMENU.mainmenu.site:GetTall() - YRP.ctr(50))

		function version:Paint(pw, ph)
			draw.SimpleText("(" .. string.upper(GAMEMODE.dedicated) .. " Server) (" .. string.upper(GAMEMODE.Art) .. ") YourRP V.: " .. GAMEMODE.Version .. " by D4KiR", "Y_22_500", pw, ph / 2, GetVersionColor(), 2, 1)
		end
		YRPCheckVersion()
	end
end)

net.Receive("getsitestaff", function(len)
	if pa(HELPMENU.mainmenu.site) then
		local staff = net.ReadTable()
		local stafflist = createD("DPanelList", HELPMENU.mainmenu.site, YRP.ctr(800), HELPMENU.content:GetTall() - YRP.ctr(100 + 20 + 20), 0, 0)
		stafflist:SetSpacing(YRP.ctr(10))

		for i, pl in pairs(staff) do
			local tmp = createD("DButton", stafflist, YRP.ctr(800), YRP.ctr(200), 0, 0)
			tmp:SetText("")

			function tmp:Paint(pw, ph)
				draw.RoundedBox(0, 0, 0, pw, ph, Color(0, 255, 255, 200))
				if ea(pl) then
					draw.SimpleText(YRP.lang_string("LID_name") .. ": " .. pl:RPName(), "Y_18_500", ph + YRP.ctr(10), YRP.ctr(25), Color(255, 255, 255, 255), 0, 1)
					draw.SimpleText(YRP.lang_string("LID_usergroup") .. ": " .. string.upper(pl:GetUserGroup()), "Y_18_500", ph + YRP.ctr(10), YRP.ctr(50 + 25), Color(255, 255, 255, 255), 0, 1)
				end
			end

			tmp.avatar = createD("AvatarImage", tmp, YRP.ctr(200 - 8), YRP.ctr(200 - 8), YRP.ctr(4), YRP.ctr(4))
			tmp.avatar:SetPlayer(pl, YRP.ctr(200))
			local steamsize = 50
			tmp.steam = createD("DButton", tmp, YRP.ctr(steamsize), YRP.ctr(steamsize), YRP.ctr(200 + 10), YRP.ctr(200 - steamsize - 10))
			tmp.steam:SetText("")

			function tmp.steam:Paint(pw, ph)
				surfaceButton(self, pw, ph, "")
				YRP.DrawIcon(YRP.GetDesignIcon("steam"), pw - YRP.ctr(4), ph - YRP.ctr(4), YRP.ctr(2), YRP.ctr(2), YRPGetColor("6"))
			end

			function tmp.steam:DoClick()
				pl:ShowProfile()
			end

			stafflist:AddItem(tmp)
		end
	end
end)

net.Receive("getsiteserverrules", function(len)
	if pa(HELPMENU) then
		local serverrules = net.ReadString()
		local page = createD("DPanel", HELPMENU.mainmenu.site, HELPMENU.content:GetWide() - YRP.ctr(20 + 20), HELPMENU.content:GetTall() - YRP.ctr(100 + 20 + 20), 0, 0)

		function page:Paint(pw, ph)
			draw.SimpleText(YRP.lang_string("LID_rules"), "Y_22_500", 0, 0, Color(255, 255, 255, 255), 0, 0)
		end

		page.serverrules = createD("RichText", page, page:GetWide(), page:GetTall() - YRP.ctr(50), 0, YRP.ctr(50))

		function page.serverrules:PerformLayout()
			if self.SetUnderlineFont != nil then
				self:SetUnderlineFont("Y_18_500")
			end
			self:SetFontInternal("Y_18_500")
		end

		page.serverrules:InsertColorChange(255, 255, 255, 255)
		page.serverrules:AppendText(serverrules)
	end
end)

net.Receive("getsitecollection", function(len)
	if pa(HELPMENU.mainmenu.site) then
		local collectionid = tonumber(net.ReadString())

		if collectionid > 0 then
			local link = "https://steamcommunity.com/sharedfiles/filedetails/?id=" .. collectionid
			local WorkshopPage = createD("DHTML", HELPMENU.mainmenu.site, HELPMENU.content:GetWide() - YRP.ctr(20 + 20), HELPMENU.content:GetTall() - YRP.ctr(100 + 20 + 20), 0, 0)

			function WorkshopPage:Paint(pw, ph)
				surfaceBox(0, 0, pw, ph, Color(255, 255, 255, 255))
			end

			WorkshopPage:OpenURL(link)
			local openLink = createD("DButton", WorkshopPage, YRP.ctr(100), YRP.ctr(100), HELPMENU.content:GetWide() - YRP.ctr(100 + 20 + 20), 0)
			openLink:SetText("")

			function openLink:Paint(pw, ph)
				surfaceButton(self, pw, ph, "")
				YRP.DrawIcon(YRP.GetDesignIcon("launch"), ph, ph, 0, 0, YRPGetColor("6"))
			end

			function openLink:DoClick()
				gui.OpenURL(link)
			end
		end
	end
end)

net.Receive("getsitecommunitywebsite", function(len)
	if pa(HELPMENU.mainmenu.site) then
		local link = net.ReadString()
		if !strEmpty(link) then
			local page = createD("DHTML", HELPMENU.mainmenu.site, HELPMENU.content:GetWide() - YRP.ctr(20 + 20), HELPMENU.content:GetTall() - YRP.ctr(100 + 20 + 20), 0, 0)

			function page:Paint(pw, ph)
				surfaceBox(0, 0, pw, ph, Color(255, 255, 255, 255))
			end

			page:OpenURL(link)
			local openLink = createD("DButton", page, YRP.ctr(100), YRP.ctr(100), HELPMENU.content:GetWide() - YRP.ctr(100 + 20 + 20), 0)
			openLink:SetText("")

			function openLink:Paint(pw, ph)
				surfaceButton(self, pw, ph, "")
				YRP.DrawIcon(YRP.GetDesignIcon("launch"), ph, ph, 0, 0, YRPGetColor("6"))
			end

			function openLink:DoClick()
				gui.OpenURL(link)
			end
		end
	end
end)

net.Receive("getsitecommunityforum", function(len)
	if pa(HELPMENU.mainmenu.site) then
		local link = net.ReadString()

		if !strEmpty(link) then
			local page = createD("DHTML", HELPMENU.mainmenu.site, HELPMENU.content:GetWide() - YRP.ctr(20 + 20), HELPMENU.content:GetTall() - YRP.ctr(100 + 20 + 20), 0, 0)

			function page:Paint(pw, ph)
				surfaceBox(0, 0, pw, ph, Color(255, 255, 255, 255))
			end

			page:OpenURL(link)
			local openLink = createD("DButton", page, YRP.ctr(100), YRP.ctr(100), HELPMENU.content:GetWide() - YRP.ctr(100 + 20 + 20), 0)
			openLink:SetText("")

			function openLink:Paint(pw, ph)
				surfaceButton(self, pw, ph, "")
				YRP.DrawIcon(YRP.GetDesignIcon("launch"), ph, ph, 0, 0, YRPGetColor("6"))
			end

			function openLink:DoClick()
				gui.OpenURL(link)
			end
		end
	end
end)

net.Receive("getsitecommunitydiscord", function(len)
	if pa(HELPMENU.mainmenu.site) then
		local link = net.ReadString()
		local widgetid = net.ReadString()

		if !strEmpty(widgetid) then
			local page = createD("DHTML", HELPMENU.mainmenu.site, HELPMENU.content:GetWide() - YRP.ctr(20 + 20), HELPMENU.content:GetTall() - YRP.ctr(100 + 20 + 20), 0, 0)

			function page:Paint(pw, ph)
				--surfaceBox(0, 0, YRP.ctr(1000 + 2 * 20), ph, Color(255, 255, 255, 255))
			end

			local widgetlink = "<iframe src=\"https://canary.discordapp.com/widget?id=" .. widgetid .. "&theme=dark\" width=\"" .. YRP.ctr(1000) .. "\" height=\"" .. page:GetTall() - YRP.ctr(2 * 20) .. "\" allowtransparency=\"true\" frameborder=\"0\"></iframe>"
			page:SetHTML(widgetlink)

			local openLink = createD("DButton", page, YRP.ctr(240), YRP.ctr(54), YRP.ctr(760), page:GetTall() - YRP.ctr(92))
			openLink:SetText("")
			function openLink:Paint(pw, ph)
				surfaceButton(self, pw, ph, "")
				YRP.DrawIcon(YRP.GetDesignIcon("launch"), ph, ph, 0, 0, YRPGetColor("6"))
				draw.SimpleText("Connect", "DermaDefault", pw / 2, ph / 2, Color(255, 255, 255, 255), 1, 1)
			end

			function openLink:DoClick()
				gui.OpenURL(link)
			end
		end
	end
end)

net.Receive("getsitecommunityteamspeak", function(len)
	if pa(HELPMENU.mainmenu.site) then
		local ip = net.ReadString()
		local port = net.ReadString()
		local query_port = net.ReadString()
		printGM("gm", "TS: " .. ip .. ":" .. port .. " | QPort: " .. query_port)

		if !strEmpty(ip) then
			if !strEmpty(port) and !strEmpty(query_port) then
				local page = createD("DHTML", HELPMENU.mainmenu.site, YRP.ctr(1000), HELPMENU.content:GetTall() - YRP.ctr(100 + 20 + 20), 0, 0)

				function page:Paint(pw, ph)
					surfaceBox(0, 0, YRP.ctr(1000 + 2 * 20), ph, Color(40, 40, 40, 255))
				end

				local widgetlink = "<span id=\"its402545\"><a href=\"https://www.teamspeak3.com/\">teamspeak</a> Hosting by TeamSpeak3.com</span><script type=\"text/javascript\" src=\"https://view.light-speed.com/teamspeak3.php?IP=" .. ip .. "&PORT=" .. port .. "&QUERY= " .. query_port .. "&UID=402545&display=block&font=11px&background=transparent&server_info_background=transparent&server_info_text=%23ffffff&server_name_background=transparent&server_name_text=%23ffffff&info_background=transparent&channel_background=transparent&channel_text=%23ffffff&username_background=transparent&username_text=%23ffffff\"></script>"
				page:SetHTML(widgetlink)

				local ipport = createD("DTextEntry", HELPMENU.mainmenu.site, YRP.ctr(400), YRP.ctr(50), page:GetWide() + YRP.ctr(20), 0)
				ipport:SetText(ip .. ":" .. port)
				ipport:SetEditable(false)
			else
				printGM("note", "missing Port and QueryPort")
			end
		end
	end
end)

net.Receive("getsitecommunitytwitter", function(len)
	if pa(HELPMENU.mainmenu.site) then
		local link = net.ReadString()

		if !strEmpty(link) then
			local page = createD("DHTML", HELPMENU.mainmenu.site, HELPMENU.content:GetWide() - YRP.ctr(20 + 20), HELPMENU.content:GetTall() - YRP.ctr(100 + 20 + 20), 0, 0)

			function page:Paint(pw, ph)
				surfaceBox(0, 0, pw, ph, Color(255, 255, 255, 255))
			end

			page:OpenURL(link)
			local openLink = createD("DButton", page, YRP.ctr(100), YRP.ctr(100), HELPMENU.content:GetWide() - YRP.ctr(100 + 20 + 20), 0)
			openLink:SetText("")

			function openLink:Paint(pw, ph)
				surfaceButton(self, pw, ph, "")
				YRP.DrawIcon(YRP.GetDesignIcon("launch"), ph, ph, 0, 0, YRPGetColor("6"))
			end

			function openLink:DoClick()
				gui.OpenURL(link)
			end
		end
	end
end)

net.Receive("getsitecommunityyoutube", function(len)
	if pa(HELPMENU.mainmenu.site) then
		local link = net.ReadString()

		if !strEmpty(link) then
			local page = createD("DHTML", HELPMENU.mainmenu.site, HELPMENU.content:GetWide() - YRP.ctr(20 + 20), HELPMENU.content:GetTall() - YRP.ctr(100 + 20 + 20), 0, 0)

			function page:Paint(pw, ph)
				surfaceBox(0, 0, pw, ph, Color(255, 255, 255, 255))
			end

			page:OpenURL(link)
			local openLink = createD("DButton", page, YRP.ctr(100), YRP.ctr(100), HELPMENU.content:GetWide() - YRP.ctr(100 + 20 + 20), 0)
			openLink:SetText("")

			function openLink:Paint(pw, ph)
				surfaceButton(self, pw, ph, "")
				YRP.DrawIcon(YRP.GetDesignIcon("launch"), ph, ph, 0, 0, YRPGetColor("6"))
			end

			function openLink:DoClick()
				gui.OpenURL(link)
			end
		end
	end
end)

net.Receive("getsitecommunityfacebook", function(len)
	if pa(HELPMENU.mainmenu.site) then
		local link = net.ReadString()

		if !strEmpty(link) then
			local page = createD("DHTML", HELPMENU.mainmenu.site, HELPMENU.content:GetWide() - YRP.ctr(20 + 20), HELPMENU.content:GetTall() - YRP.ctr(100 + 20 + 20), 0, 0)

			function page:Paint(pw, ph)
				surfaceBox(0, 0, pw, ph, Color(255, 255, 255, 255))
			end

			page:OpenURL(link)
			local openLink = createD("DButton", page, YRP.ctr(100), YRP.ctr(100), HELPMENU.content:GetWide() - YRP.ctr(100 + 20 + 20), 0)
			openLink:SetText("")

			function openLink:Paint(pw, ph)
				surfaceButton(self, pw, ph, "")
				YRP.DrawIcon(YRP.GetDesignIcon("launch"), ph, ph, 0, 0, YRPGetColor("6"))
			end

			function openLink:DoClick()
				gui.OpenURL(link)
			end
		end
	end
end)

net.Receive("getsitecommunitysteamgroup", function(len)
	if pa(HELPMENU.mainmenu.site) then
		local link = net.ReadString()

		if !strEmpty(link) then
			local page = createD("DHTML", HELPMENU.mainmenu.site, HELPMENU.content:GetWide() - YRP.ctr(20 + 20), HELPMENU.content:GetTall() - YRP.ctr(100 + 20 + 20), 0, 0)

			function page:Paint(pw, ph)
				surfaceBox(0, 0, pw, ph, Color(255, 255, 255, 255))
			end

			page:OpenURL(link)
			local openLink = createD("DButton", page, YRP.ctr(100), YRP.ctr(100), HELPMENU.content:GetWide() - YRP.ctr(100 + 20 + 20), 0)
			openLink:SetText("")

			function openLink:Paint(pw, ph)
				surfaceButton(self, pw, ph, "")
				YRP.DrawIcon(YRP.GetDesignIcon("launch"), ph, ph, 0, 0, YRPGetColor("6"))
			end

			function openLink:DoClick()
				gui.OpenURL(link)
			end
		end
	end
end)

net.Receive("getsiteyourrpwhatsnew", function(len)
	if pa(HELPMENU.mainmenu.site) then
		local link = "https://steamcommunity.com/sharedfiles/filedetails/changelog/1114204152"

		if !strEmpty(link) then
			local posy = YRP.ctr(220)
			local page = createD("HTML", HELPMENU.mainmenu.site, HELPMENU.content:GetWide() - YRP.ctr(20 + 20), HELPMENU.content:GetTall() - YRP.ctr(100 + 20 + 20) + posy, 0, -posy)
			page:OpenURL(link)

			local openLink = createD("DButton", page, YRP.ctr(100), YRP.ctr(100), HELPMENU.content:GetWide() - YRP.ctr(100 + 20 + 20), 0)
			openLink:SetText("")

			function openLink:Paint(pw, ph)
				surfaceButton(self, pw, ph, "")
				YRP.DrawIcon(YRP.GetDesignIcon("launch"), ph, ph, 0, 0, YRPGetColor("6"))
			end

			function openLink:DoClick()
				gui.OpenURL(link)
			end
		end
	end
end)

net.Receive("getsiteyourrproadmap", function(len)
	if pa(HELPMENU.mainmenu.site) then
		local link = "https://docs.google.com/spreadsheets/d/e/2PACX-1vQaL9ciXYnStYesglG7-zkRr1PdLNz1rbKgp5gF2EsGNfRAKkT3fBOYrGxyRYOEOg4khoQZh88ZxrBB/pubhtml"

		local page = createD("DHTML", HELPMENU.mainmenu.site, HELPMENU.content:GetWide() - YRP.ctr(20 + 20), HELPMENU.content:GetTall(), 0, 0)
		function page:Paint(pw, ph)
			surfaceBox(0, 0, pw, ph, Color(255, 255, 255, 255))
		end
		page:OpenURL(link)

		local openLink = createD("DButton", page, YRP.ctr(100), YRP.ctr(100), HELPMENU.content:GetWide() - YRP.ctr(100 + 20 + 20), 0)
		openLink:SetText("")

		function openLink:Paint(pw, ph)
			surfaceButton(self, pw, ph, "")
			YRP.DrawIcon(YRP.GetDesignIcon("launch"), ph, ph, 0, 0, YRPGetColor("6"))
		end

		function openLink:DoClick()
			gui.OpenURL(link)
		end
	end
end)

net.Receive("getsiteyourrpnews", function(len)
	if pa(HELPMENU.mainmenu.site) then
		local link = "https://docs.google.com/document/d/e/2PACX-1vRcuPnvnAqRD7dQFOkH9d0Q1G3qXFn6rAHJWAAl7wV2TEABGhDdJK9Y-LCONFKTiAWmJJZpsTcDnz5W/pub"

		local page = createD("DHTML", HELPMENU.mainmenu.site, HELPMENU.content:GetWide() - YRP.ctr(20 + 20), HELPMENU.content:GetTall(), 0, 0)
		function page:Paint(pw, ph)
			surfaceBox(0, 0, pw, ph, Color(255, 255, 255, 255))
		end
		page:OpenURL(link)

		local openLink = createD("DButton", page, YRP.ctr(100), YRP.ctr(100), HELPMENU.content:GetWide() - YRP.ctr(100 + 20 + 20), 0)
		openLink:SetText("")

		function openLink:Paint(pw, ph)
			surfaceButton(self, pw, ph, "")
			YRP.DrawIcon(YRP.GetDesignIcon("launch"), ph, ph, 0, 0, YRPGetColor("6"))
		end

		function openLink:DoClick()
			gui.OpenURL(link)
		end
	end
end)

net.Receive("getsiteyourrpdiscord", function(len)
	if pa(HELPMENU.mainmenu.site) then
		local link = "https://discord.gg/sEgNZxg"

		if !strEmpty(link) then
			local page = createD("DHTML", HELPMENU.mainmenu.site, YRP.ctr(1040), HELPMENU.content:GetTall() - YRP.ctr(100 + 20 + 20), 0, 0)

			function page:Paint(pw, ph)
				--surfaceBox(0, 0, pw, ph, Color(255, 0, 0, 255))
			end

			local widgetlink = "<iframe src=\"https://canary.discordapp.com/widget?id=322771229213851648&theme=dark\" width=\"" .. YRP.ctr(1000) .. "\" height=\"" .. page:GetTall() - YRP.ctr(2 * 20) .. "\" allowtransparency=\"true\" frameborder=\"0\"></iframe>"
			page:SetHTML(widgetlink)

			local openLink = createD("DButton", page, YRP.ctr(240), YRP.ctr(54), YRP.ctr(760), page:GetTall() - YRP.ctr(92))
			openLink:SetText("")
			function openLink:Paint(pw, ph)
				surfaceButton(self, pw, ph, "")
				YRP.DrawIcon(YRP.GetDesignIcon("launch"), ph, ph, 0, 0, YRPGetColor("6"))
				draw.SimpleText("Connect", "DermaDefault", pw / 2, ph / 2, Color(255, 255, 255, 255), 1, 1)
			end

			function openLink:DoClick()
				gui.OpenURL(link)
			end

			local page2 = createD("DHTML", HELPMENU.mainmenu.site, HELPMENU.content:GetWide() - YRP.ctr(1040), HELPMENU.content:GetTall() - YRP.ctr(100 + 20 + 20), YRP.ctr(1060), 0)
			page2:OpenURL(link)

		end
	end
end)

net.Receive("getsiteyourrpserverlist", function(len)
	if pa(HELPMENU.mainmenu.site) then
		local link = "https://docs.google.com/spreadsheets/d/e/2PACX-1vQjN_z15gn7zQo-t6om2xArokvemGMs4pN2VasSuBNmzbEc7a0eUxG8lF5JZlT1l844LDhgJgrW52SJ/pubhtml?gid=0&single=true"

		local page = createD("DHTML", HELPMENU.mainmenu.site, HELPMENU.content:GetWide() - YRP.ctr(20 + 20), HELPMENU.content:GetTall(), 0, 0)
		page:OpenURL(link)

		local openLink = createD("DButton", page, YRP.ctr(100), YRP.ctr(100), HELPMENU.content:GetWide() - YRP.ctr(100 + 20 + 20), 0)
		openLink:SetText("")

		function openLink:Paint(pw, ph)
			surfaceButton(self, pw, ph, "")
			YRP.DrawIcon(YRP.GetDesignIcon("launch"), ph, ph, 0, 0, YRPGetColor("6"))
		end

		function openLink:DoClick()
			gui.OpenURL(link)
		end
	end
end)

net.Receive("getsiteyourrptranslations", function(len)
	if pa(HELPMENU.mainmenu.site) then
		local Parent = HELPMENU.mainmenu.site
		--local page = createD("DPanel", HELPMENU.mainmenu.site, HELPMENU.content:GetWide() - YRP.ctr(20 + 20), HELPMENU.content:GetTall() - YRP.ctr(100 + 20 + 20), 0, 0)

		--function page:Paint(pw, ph)
			--surfacePanel(self, pw, ph, "")
		--end

		local _longestProgressText = 0
		local _allProgressTexts = {}

		for sho, language in SortedPairs(YRP.GetAllLanguages()) do
			local text = language.language .. "/" .. language.inenglish

			if language.percentage != nil then
				language.percentage = tonumber(language.percentage)
				text = text .. " (" .. language.percentage .. "%)"
			end

			_allProgressTexts[sho] = text
			surface.SetFont(GetFont())
			local width = surface.GetTextSize(text)

			if (width > _longestProgressText) then
				_longestProgressText = width
			end
		end

		local _br = 4
		local _h = 74
		local _icon_h = _h - _br
		local _icon_w = _icon_h * 1.478
		local _w = YRP.ctr(800) -- _longestProgressText + YRP.ctr(_icon_w + 20 + 20)

		local LANGUAGES = createD("YGroupBox", Parent, _w, Parent:GetTall() - YRP.ctr(25), Parent:GetWide() / 2 - _w / 2, 0)
		LANGUAGES:SetText("Languages")
		function LANGUAGES:Paint(pw, ph)
			hook.Run("YGroupBoxPaint", self, pw, ph)
		end
		LANGUAGES:SetSpacing(YRP.ctr(10))

		--page.panellist = createD("DPanelList", page, _w, page:GetTall(), page:GetWide() / 2 - _w / 2, YRP.ctr(100))
		--page.panellist:SetSpacing(_br)

		for sho, language in SortedPairs(YRP.GetAllLanguages()) do
			local lan = createD("YButton", nil, LANGUAGES:GetContent():GetWide(), YRP.ctr(_h), 0, 0)
			lan:SetText("")
			lan.language = language

			function lan:Paint(pw, ph)
				self.textcol = Color(255, 255, 255)

				if language.percentage != nil then
					local colper = 255 / 100 * language.percentage
					if colper < 120 then
						colper = 120
					end
					self.textcol = Color(255 - colper, colper, 0)
				end
				if language.author == "" then
					self.textcol = Color(255, 255, 0)
				end

				hook.Run("YButtonPaint", self, pw, ph)
				--surfaceButton(self, pw, ph, "")
				draw.SimpleText(_allProgressTexts[sho], "Y_18_500", YRP.ctr(_icon_w + 4 + 10), ph / 2, self.textcol, 0, 1)
				YRP.DrawIcon(YRP.GetDesignIcon("lang_" .. tostring(self.language.short)), YRP.ctr(_icon_w), YRP.ctr(_icon_h), YRP.ctr(_br), YRP.ctr((_h - _icon_h) / 2), Color(255, 255, 255, 255))
			end

			function lan:DoClick()
				if self.language.author == "" then
					OpenHelpTranslatingWindow()
				else
					local win = createD("YFrame", nil, YRP.ctr(1000), YRP.ctr(1600), 0, 0)
					win:SetTitle(language.inenglish)
					win:MakePopup()
					function win:Paint(pw, ph)
						hook.Run("YFramePaint", self, pw, ph)
					end
					win:Center()
					win:SetHeaderHeight(YRP.ctr(100))

					for i, steamid64 in pairs(string.Explode(",", language.steamid64)) do
						if !strEmpty(steamid64) then
							local plink = "http://steamcommunity.com/profiles/" .. steamid64
							local bg = createD("DPanel", win:GetContent(), win:GetContent():GetWide() - YRP.ctr(40), YRP.ctr(338), YRP.ctr(20), YRP.ctr(20) + (i - 1) * YRP.ctr(338 + 20))
							local p = createD("DHTML", bg, YRP.ctr(1000), YRP.ctr(800), YRP.ctr(-26), YRP.ctr(-272))
							p:OpenURL(plink)
							local pb = createD("YButton", bg, bg:GetWide(), bg:GetTall(), 0, 0)
							pb:SetText("")
							function pb:DoClick()
								gui.OpenURL(plink)
							end
							function pb:Paint(pw, ph)
								--
							end
						end
					end
				end
			end

			LANGUAGES:AddItem(lan)
		end

		local _helplanWidth = YRP.ctr(400)
		local _helplanX = 0

		if ((_longestProgressText + YRP.ctr(2 * (68 + 4 + 10))) > (ScrW() / 2 - _helplanWidth / 2)) then
			_helplanX = (_longestProgressText + 30) + YRP.ctr(2 * (68 + 4 + 10))
		else
			_helplanX = ScrW() / 2 - _helplanWidth / 2
		end

		local helplan = createD("YButton", Parent, YRP.ctr(400), YRP.ctr(50), Parent:GetWide() - YRP.ctr(400), 0)
		helplan:SetText("Help translating")
		function helplan:Paint(pw, ph)
			hook.Run("YButtonPaint", self, pw, ph)
		end
		function helplan:DoClick()
			OpenHelpTranslatingWindow()
		end
	end
end)

function OpenHelpMenu()
	openMenu()

	HELPMENU.open = true
	HELPMENU.window = createD("YFrame", nil, BFW(), BFH(), BPX(), BPY()) --ScW(), ScrH(), 0, 0)
	HELPMENU.window:MakePopup()
	HELPMENU.window:Center()
	HELPMENU.window:SetTitle("LID_helpmenu")
	HELPMENU.window:SetDraggable(false)

	HELPMENU.window:SetHeaderHeight(YRP.ctr(100))
	HELPMENU.window:SetBackgroundBlur(true)
	HELPMENU.window.systime = SysTime()

	function HELPMENU.window:Paint(pw, ph)
		Derma_DrawBackgroundBlur(self, self.systime)
		--surfaceBox(0, 0, pw, ph, Color(90, 90, 90, 200))
		hook.Run("YFramePaint", self, pw, ph)
	end

	CreateHelpMenuContent(HELPMENU.window.con)
end

function CreateHelpMenuContent(parent)
	HELPMENU.content = parent
	HELPMENU.standalone = standalone or false
	HELPMENU.mainmenu = createD("DYRPHorizontalMenu", HELPMENU.content, HELPMENU.content:GetWide(), HELPMENU.content:GetTall(), 0, 0)
	HELPMENU.mainmenu:GetMenuInfo("gethelpmenu")
	HELPMENU.mainmenu:SetStartTab("LID_help")
	HELPMENU.mainmenu:SetHeaderHeight(YRP.ctr(100))
end

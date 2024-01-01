--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
local cm = {}
cm.open = false
cm.currentsite = 0
function YRPToggleCombinedMenu(id)
	id = tonumber(id)
	cm.currentsite = id
	if not cm.open and YRPIsNoMenuOpen() then
		YRPOpenCombinedMenu()
	elseif cm.open and cm.currentsite ~= 4 and cm.currentsite ~= 5 then
		YRPCloseCombinedMenu()
	end
end

function YRPCloseCombinedMenu()
	cm.open = false
	if cm and YRPPanelAlive(cm.win) and cm.win and cm.win.Hide then
		cm.win:Hide()
	end
end

function YRPCreateWebsiteContent(PARENT)
	local site = YRPCreateD("DHTML", PARENT, PARENT:GetWide(), PARENT:GetTall(), 0, 0)
	site:OpenURL(GetGlobalYRPString("text_social_website", ""))
end

function YRPCreateForumContent(PARENT)
	local site = YRPCreateD("DHTML", PARENT, PARENT:GetWide(), PARENT:GetTall(), 0, 0)
	site:OpenURL(GetGlobalYRPString("text_social_forum", ""))
end

function YRPCreateRulesContent(PARENT)
	local serverrules = table.concat(GetGlobalYRPTable("text_server_rules", ""), "\n")
	serverrules = YRP_SQL_STR_OUT(serverrules)
	local page = YRPCreateD("DPanel", PARENT, PARENT:GetWide() - YRP.ctr(20 + 20), PARENT:GetTall() - YRP.ctr(20 + 20), YRP.ctr(20), YRP.ctr(20))
	function page:Paint(pw, ph)
		draw.SimpleText(YRP.trans("LID_rules"), "Y_22_500", 0, YRP.ctr(50), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
	end

	page.serverrules = YRPCreateD("RichText", page, page:GetWide(), page:GetTall() - YRP.ctr(70), 0, YRP.ctr(70))
	function page.serverrules:PerformLayout()
		if self.SetUnderlineFont ~= nil then
			self:SetUnderlineFont("Y_18_500")
		end

		self:SetFontInternal("Y_18_500")
	end

	page.serverrules:InsertColorChange(255, 255, 255, 255)
	page.serverrules:AppendText(serverrules)
end

function YRPCreateDiscordContent(PARENT)
	local link = GetGlobalYRPString("text_social_discord", "")
	local widgetid = GetGlobalYRPString("text_social_discord_widgetid", "")
	local page = YRPCreateD("DHTML", PARENT, PARENT:GetWide(), PARENT:GetTall(), 0, 0)
	function page:Paint(pw, ph)
	end

	--draw.RoundedBox( 0, 0, 0, YRP.ctr(1000 + 2 * 20), ph, Color( 255, 255, 255, 255 ) )
	local widgetlink = "<iframe src=\"https://canary.discordapp.com/widget?id=" .. widgetid .. "&theme=dark\" width=\"" .. PARENT:GetWide() - YRP.ctr(2 * 20) .. "\" height=\"" .. page:GetTall() - YRP.ctr(2 * 20) .. "\" allowtransparency=\"true\" frameborder=\"0\"></iframe>"
	page:SetHTML(widgetlink)
	local openLink = YRPCreateD("YButton", page, YRP.ctr(240), YRP.ctr(54), PARENT:GetWide() - YRP.ctr(280), page:GetTall() - YRP.ctr(92))
	openLink:SetText("")
	function openLink:Paint(pw, ph)
		hook.Run("YButtonPaint", self, pw, ph)
		if YRP.GetDesignIcon("launch") ~= nil then
			YRP.DrawIcon(YRP.GetDesignIcon("launch"), ph, ph, 0, 0, YRPGetColor("6"))
		end

		draw.SimpleText("Connect", "DermaDefault", pw / 2, ph / 2, Color(255, 255, 255, 255), 1, 1)
	end

	function openLink:DoClick()
		gui.OpenURL(link)
	end
end

function YRPCreateTeamspeakContent(PARENT)
	local ip = GetGlobalYRPString("text_social_teamspeak_ip", "")
	local port = GetGlobalYRPString("text_social_teamspeak_port", "")
	local query_port = GetGlobalYRPString("text_social_teamspeak_query_port", "")
	YRP.msg("gm", "TS: " .. ip .. ":" .. port .. " | QPort: " .. query_port)
	if not strEmpty(ip) then
		if not strEmpty(port) and not strEmpty(query_port) then
			local page = YRPCreateD("DHTML", PARENT, PARENT:GetWide(), PARENT:GetTall(), 0, 0)
			function page:Paint(pw, ph)
			end

			--draw.RoundedBox( 0, 0, 0, pw, ph, Color(40, 40, 40, 255) )
			local widgetlink = "<span id=\"its402545\"><a href=\"https://www.teamspeak3.com/\">teamspeak</a> Hosting by TeamSpeak3.com</span><script type=\"text/javascript\" src=\"https://view.light-speed.com/teamspeak3.php?IP=" .. ip .. "&PORT=" .. port .. "&QUERY= " .. query_port .. "&UID=402545&display=block&font=11px&background=transparent&server_info_background=transparent&server_info_text=%23ffffff&server_name_background=transparent&server_name_text=%23ffffff&info_background=transparent&channel_background=transparent&channel_text=%23ffffff&username_background=transparent&username_text=%23ffffff\"></script>"
			page:SetHTML(widgetlink)
			local ipport = YRPCreateD("DTextEntry", PARENT, YRP.ctr(400), YRP.ctr(50), PARENT:GetWide() - YRP.ctr(420), YRP.ctr(20))
			ipport:SetText(ip .. ":" .. port)
			ipport:SetEditable(true)
		else
			YRP.msg("note", "missing Port and QueryPort")
		end
	end
end

function YRPCreateCollectionContent(PARENT)
	local collectionid = YRPCollectionID()
	if collectionid ~= "0" then
		local link = "https://steamcommunity.com/sharedfiles/filedetails/?id=" .. collectionid
		local WorkshopPage = YRPCreateD("DHTML", PARENT, PARENT:GetWide(), PARENT:GetTall(), 0, 0)
		function WorkshopPage:Paint(pw, ph)
			draw.RoundedBox(0, 0, 0, pw, ph, Color(255, 255, 255, 255))
		end

		WorkshopPage:OpenURL(link)
		local openLink = YRPCreateD("YButton", WorkshopPage, YRP.ctr(100), YRP.ctr(100), PARENT:GetWide() - YRP.ctr(100 + 20 + 20), 0)
		openLink:SetText("")
		function openLink:Paint(pw, ph)
			hook.Run("YButtonPaint", self, pw, ph)
			if YRP.GetDesignIcon("launch") ~= nil then
				YRP.DrawIcon(YRP.GetDesignIcon("launch"), ph, ph, 0, 0, YRPGetColor("6"))
			end
		end

		function openLink:DoClick()
			gui.OpenURL(link)
		end
	end
end

function YRPCreateTwitchContent(PARENT)
	local link = GetGlobalYRPString("text_social_twitch", "")
	local WorkshopPage = YRPCreateD("DHTML", PARENT, PARENT:GetWide(), PARENT:GetTall(), 0, 0)
	function WorkshopPage:Paint(pw, ph)
	end

	--draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 255, 255, 255 ) )
	WorkshopPage:OpenURL(link)
	local openLink = YRPCreateD("YButton", WorkshopPage, YRP.ctr(100), YRP.ctr(100), PARENT:GetWide() - YRP.ctr(100 + 20), YRP.ctr(20))
	openLink:SetText("")
	function openLink:Paint(pw, ph)
		hook.Run("YButtonPaint", self, pw, ph)
		if YRP.GetDesignIcon("launch") ~= nil then
			YRP.DrawIcon(YRP.GetDesignIcon("launch"), ph, ph, 0, 0, YRPGetColor("6"))
		end
	end

	function openLink:DoClick()
		gui.OpenURL(link)
	end
end

function YRPCreateYoutubeContent(PARENT)
	local link = GetGlobalYRPString("text_social_youtube", "")
	local WorkshopPage = YRPCreateD("DHTML", PARENT, PARENT:GetWide(), PARENT:GetTall(), 0, 0)
	function WorkshopPage:Paint(pw, ph)
	end

	--draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 255, 255, 255 ) )
	WorkshopPage:OpenURL(link)
	local openLink = YRPCreateD("YButton", WorkshopPage, YRP.ctr(100), YRP.ctr(100), PARENT:GetWide() - YRP.ctr(100 + 20), YRP.ctr(20))
	openLink:SetText("")
	function openLink:Paint(pw, ph)
		hook.Run("YButtonPaint", self, pw, ph)
		YRP.DrawIcon(YRP.GetDesignIcon("launch"), ph, ph, 0, 0, YRPGetColor("6"))
	end

	function openLink:DoClick()
		gui.OpenURL(link)
	end
end

function YRPCreateTwitterContent(PARENT)
	local link = GetGlobalYRPString("text_social_twitter", "")
	local WorkshopPage = YRPCreateD("DHTML", PARENT, PARENT:GetWide(), PARENT:GetTall(), 0, 0)
	function WorkshopPage:Paint(pw, ph)
	end

	--draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 255, 255, 255 ) )
	WorkshopPage:OpenURL(link)
	local openLink = YRPCreateD("YButton", WorkshopPage, YRP.ctr(100), YRP.ctr(100), PARENT:GetWide() - YRP.ctr(100 + 20), YRP.ctr(20))
	openLink:SetText("")
	function openLink:Paint(pw, ph)
		hook.Run("YButtonPaint", self, pw, ph)
		if YRP.GetDesignIcon("launch") ~= nil then
			YRP.DrawIcon(YRP.GetDesignIcon("launch"), ph, ph, 0, 0, YRPGetColor("6"))
		end
	end

	function openLink:DoClick()
		gui.OpenURL(link)
	end
end

function YRPCreateSteamGroupContent(PARENT)
	local link = GetGlobalYRPString("text_social_steamgroup", "")
	local WorkshopPage = YRPCreateD("DHTML", PARENT, PARENT:GetWide(), PARENT:GetTall(), 0, 0)
	function WorkshopPage:Paint(pw, ph)
	end

	--draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 255, 255, 255 ) )
	WorkshopPage:OpenURL(link)
	local openLink = YRPCreateD("YButton", WorkshopPage, YRP.ctr(100), YRP.ctr(100), PARENT:GetWide() - YRP.ctr(100 + 20), YRP.ctr(20))
	openLink:SetText("")
	function openLink:Paint(pw, ph)
		hook.Run("YButtonPaint", self, pw, ph)
		if YRP.GetDesignIcon("launch") ~= nil then
			YRP.DrawIcon(YRP.GetDesignIcon("launch"), ph, ph, 0, 0, YRPGetColor("6"))
		end
	end

	function openLink:DoClick()
		gui.OpenURL(link)
	end
end

function YRPCreateFacebookContent(PARENT)
	local link = GetGlobalYRPString("text_social_facebook", "")
	local WorkshopPage = YRPCreateD("DHTML", PARENT, PARENT:GetWide(), PARENT:GetTall(), 0, 0)
	function WorkshopPage:Paint(pw, ph)
	end

	--draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 255, 255, 255 ) )
	WorkshopPage:OpenURL(link)
	local openLink = YRPCreateD("YButton", WorkshopPage, YRP.ctr(100), YRP.ctr(100), PARENT:GetWide() - YRP.ctr(100 + 20), YRP.ctr(20))
	openLink:SetText("")
	function openLink:Paint(pw, ph)
		hook.Run("YButtonPaint", self, pw, ph)
		if YRP.GetDesignIcon("launch") ~= nil then
			YRP.DrawIcon(YRP.GetDesignIcon("launch"), ph, ph, 0, 0, YRPGetColor("6"))
		end
	end

	function openLink:DoClick()
		gui.OpenURL(link)
	end
end

function YRPCreateInstagramContent(PARENT)
	local link = GetGlobalYRPString("text_social_instagram", "")
	local WorkshopPage = YRPCreateD("DHTML", PARENT, PARENT:GetWide(), PARENT:GetTall(), 0, 0)
	function WorkshopPage:Paint(pw, ph)
	end

	--draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 255, 255, 255 ) )
	WorkshopPage:OpenURL(link)
	local openLink = YRPCreateD("YButton", WorkshopPage, YRP.ctr(100), YRP.ctr(100), PARENT:GetWide() - YRP.ctr(100 + 20), YRP.ctr(20))
	openLink:SetText("")
	function openLink:Paint(pw, ph)
		hook.Run("YButtonPaint", self, pw, ph)
		if YRP.GetDesignIcon("launch") ~= nil then
			YRP.DrawIcon(YRP.GetDesignIcon("launch"), ph, ph, 0, 0, YRPGetColor("6"))
		end
	end

	function openLink:DoClick()
		gui.OpenURL(link)
	end
end

function YRPOpenCombinedMenu()
	local lply = LocalPlayer()
	cm.open = true
	local br = YRP.ctr(20)
	if YRPPanelAlive(cm.win) == false then
		local sites = {}
		local c = 1
		sites[c] = {}
		sites[c].name = "LID_dashboard"
		sites[c].icon = "dashboard"
		sites[c].content = CreateHelpMenuContent
		c = c + 1
		if GetGlobalYRPBool("bool_yrp_role_menu", false) then
			sites[c] = {}
			sites[c].name = "LID_roles"
			sites[c].icon = "person_pin"
			sites[c].content = CreateRoleMenuContent
			c = c + 1
		end

		if GetGlobalYRPBool("bool_yrp_buy_menu", false) then
			sites[c] = {}
			sites[c].name = "LID_shop"
			sites[c].icon = "shopping_cart"
			sites[c].content = CreateBuyMenuContent
			c = c + 1
		end

		if GetGlobalYRPBool("bool_yrp_char_menu", false) then
			sites[c] = {}
			sites[c].name = "LID_character"
			sites[c].icon = "accessibility"
			sites[c].content = CreateCharContent
			c = c + 1
		end

		if not strEmpty(GetGlobalYRPString("sting_laws", "")) or lply:GetYRPBool("bool_" .. "ismayor", false) then
			sites[c] = {}
			sites[c].name = "LID_laws"
			sites[c].icon = "gavel"
			sites[c].content = CreateLawsContent
			c = c + 1
		end

		sites[c] = {}
		sites[c].name = "hr"
		c = c + 1
		local community = false
		if not strEmpty(GetGlobalYRPString("text_social_website", "")) then
			sites[c] = {}
			sites[c].name = "LID_website"
			sites[c].icon = "web"
			sites[c].content = YRPCreateWebsiteContent
			c = c + 1
			community = true
		end

		if not strEmpty(GetGlobalYRPString("text_social_forum", "")) then
			sites[c] = {}
			sites[c].name = "LID_forum"
			sites[c].icon = "forum"
			sites[c].content = YRPCreateForumContent
			c = c + 1
			community = true
		end

		if table.Count(GetGlobalYRPTable("text_server_rules", {})) > 1 then
			sites[c] = {}
			sites[c].name = "LID_rules"
			sites[c].icon = "policy"
			sites[c].content = YRPCreateRulesContent
			c = c + 1
			community = true
		end

		if not strEmpty(GetGlobalYRPString("text_social_discord", "")) then
			sites[c] = {}
			sites[c].name = "LID_discord"
			sites[c].icon = "discord_white"
			sites[c].content = YRPCreateDiscordContent
			c = c + 1
			community = true
		end

		if not strEmpty(GetGlobalYRPString("text_social_teamspeak_ip", "")) then
			sites[c] = {}
			sites[c].name = "LID_teamspeak"
			sites[c].icon = "ts_white"
			sites[c].content = YRPCreateTeamspeakContent
			c = c + 1
			community = true
		end

		if YRPCollectionID() ~= "0" then
			sites[c] = {}
			sites[c].name = "LID_collection"
			sites[c].icon = "web"
			sites[c].content = YRPCreateCollectionContent
			c = c + 1
			community = true
		end

		if not strEmpty(GetGlobalYRPString("text_social_youtube", "")) then
			sites[c] = {}
			sites[c].name = "LID_youtube"
			sites[c].icon = "64_youtube"
			sites[c].content = YRPCreateYoutubeContent
			c = c + 1
			community = true
		end

		if not strEmpty(GetGlobalYRPString("text_social_twitch", "")) then
			sites[c] = {}
			sites[c].name = "LID_twitch"
			sites[c].icon = "64_twitch"
			sites[c].content = YRPCreateTwitchContent
			c = c + 1
			community = true
		end

		if not strEmpty(GetGlobalYRPString("text_social_twitter", "")) then
			sites[c] = {}
			sites[c].name = "LID_twitter"
			sites[c].icon = "64_twitter-square"
			sites[c].content = YRPCreateTwitterContent
			c = c + 1
			community = true
		end

		if not strEmpty(GetGlobalYRPString("text_social_steamgroup", "")) then
			sites[c] = {}
			sites[c].name = "LID_steamgroup"
			sites[c].icon = "64_steam-square"
			sites[c].content = YRPCreateSteamGroupContent
			c = c + 1
			community = true
		end

		if not strEmpty(GetGlobalYRPString("text_social_facebook", "")) then
			sites[c] = {}
			sites[c].name = "LID_facebook"
			sites[c].icon = "64_facebook-square"
			sites[c].content = YRPCreateFacebookContent
			c = c + 1
			community = true
		end

		if not strEmpty(GetGlobalYRPString("text_social_instagram", "")) then
			sites[c] = {}
			sites[c].name = "Instagram"
			sites[c].icon = "64_instagram"
			sites[c].content = YRPCreateInstagramContent
			c = c + 1
			community = true
		end

		if community then
			sites[c] = {}
			sites[c].name = "hr"
			c = c + 1
		end

		if GetGlobalYRPBool("bool_yrp_keybinds_menu", false) then
			sites[c] = {}
			sites[c].name = "LID_keybinds"
			sites[c].icon = "keyboard"
			sites[c].content = CreateKeybindsContent
			c = c + 1
			sites[c] = {}
			sites[c].name = "hr"
			c = c + 1
		end

		if GetGlobalYRPBool("bool_yrp_tickets_menu", false) then
			sites[c] = {}
			sites[c].name = "LID_ticket"
			sites[c].icon = "feedback"
			sites[c].content = CreateTicketContent
			c = c + 1
		end

		cm.win = YRPCreateD("YFrame", nil, BFW(), BFH(), BPX(), BPY())
		cm.win:SetTitle(GetGlobalYRPString("text_server_name", ""))
		cm.win:MakePopup()
		--cm.win:SetHeaderHeight(YRP.ctr(100) )
		cm.win:SetBorder(0)
		function cm.win:Paint(pw, ph)
			if GetGlobalYRPString("text_server_name", "") ~= self:GetTitle() then
				self:SetTitle(GetGlobalYRPString("text_server_name", ""))
			end

			hook.Run("YFramePaint", self, pw, ph)
		end

		if LocalPlayer().combinedmaximised == nil then
			LocalPlayer().combinedmaximised = false
		end

		cm.win:CanMaximise()
		cm.win:SetMaximised(LocalPlayer().combinedmaximised, "COMBINED")
		cm.win:SetSizable(true)
		cm.win:SetMinWidth(700)
		cm.win:SetMinHeight(700)
		local content = cm.win:GetContent()
		-- MENU
		cm.menu = YRPCreateD("DPanelList", content, 10, BFH() - cm.win:GetHeaderHeight() - YRP.ctr(64) - 2 * br, 0, 0)
		cm.menu:EnableVerticalScrollbar()
		local sbar = cm.menu.VBar
		function sbar:Paint(w, h)
			draw.RoundedBox(0, 0, 0, w, h, YRPInterfaceValue("YFrame", "NC"), 0)
		end

		function sbar.btnUp:Paint(w, h)
			draw.RoundedBox(0, 0, 0, w, h, Color(60, 60, 60))
		end

		function sbar.btnDown:Paint(w, h)
			draw.RoundedBox(0, 0, 0, w, h, Color(60, 60, 60))
		end

		function sbar.btnGrip:Paint(w, h)
			draw.RoundedBox(w / 2, 0, 0, w, h, YRPInterfaceValue("YFrame", "HI"))
		end

		cm.menu:SetText("")
		cm.menu.pw = 10
		cm.menu.ph = YRP.ctr(64) + 2 * br
		cm.menu.expanded = lply.combined_expanded or true
		local font = "Y_" .. math.Clamp(math.Round(cm.menu.ph - 2 * br), 4, 100) .. "_500"
		function cm.menu:Paint(pw, ph)
			draw.RoundedBox(0, 0, 0, pw, ph, YRPInterfaceValue("YFrame", "HB"))
		end

		cm.menu:SetSpacing(YRP.ctr(10))
		if cm.menu.expanded then
			cm.win:UpdateSize(cm.menu.ph)
		else
			cm.win:UpdateSize()
		end

		cm.menu.expander = YRPCreateD("DButton", cm.win, cm.menu.ph, cm.menu.ph, 0, cm.win:GetHeaderHeight() + cm.menu:GetTall())
		cm.menu.expander:SetText("")
		function cm.menu.expander:DoClick()
			if cm.menu.expanded then
				cm.win:UpdateSize(cm.menu.ph)
				cm.menu.expanded = false
			else
				cm.win:UpdateSize()
				cm.menu.expanded = true
			end

			lply.combined_expanded = cm.menu.expanded
		end

		function cm.menu.expander:Paint(pw, ph)
			draw.RoundedBoxEx(YRP.ctr(10), 0, 0, pw, ph, YRPInterfaceValue("YFrame", "HB"), false, false, true, false)
			if cm.menu.expanded then
				if YRP.GetDesignIcon("64_angle-left") ~= nil then
					surface.SetMaterial(YRP.GetDesignIcon("64_angle-left"))
				end
			else
				if YRP.GetDesignIcon("64_angle-right") ~= nil then
					surface.SetMaterial(YRP.GetDesignIcon("64_angle-right"))
				end
			end

			surface.SetDrawColor(Color(255, 255, 255, 255))
			surface.DrawTexturedRect(br, br, ph - 2 * br, ph - 2 * br)
			draw.SimpleText("YourRP by D4KiR", "Y_20_500", ph, ph / 2, Color(255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		end

		-- SITE
		cm.site = YRPCreateD("YPanel", content, BFW() - 10, BFH() - cm.win:GetHeaderHeight(), 10, 0)
		cm.site:SetText("")
		cm.site:SetHeaderHeight(cm.win:GetHeaderHeight())
		function cm.site:Paint(pw, ph)
			local tab = {}
			tab.color = YRPInterfaceValue("YFrame", "BG")
			hook.Run("YPanelPaint", self, pw, ph, tab) --draw.RoundedBox(0, 0, 0, pw, ph, Color(60, 60, 60, 255) )
			--draw.RoundedBox(0, 0, 0, pw, ph, Color( 255, 0, 0, 255) )
		end

		-- SITES
		cm.sites = {}
		function cm.menu:ClearSelection()
			for i, child in pairs(cm.site:GetChildren()) do
				child:Remove()
			end

			for i, v in pairs(cm.sites) do
				v.selected = false
			end
		end

		function cm.win:UpdateSize(pw)
			cm.menu.pw = 240
			local sw = pw or cm.menu.pw + cm.menu.ph + 2 * br
			cm.menu:SetWide(sw)
			cm.menu:SetTall(cm.win:GetTall() - cm.win:GetHeaderHeight() - YRP.ctr(64) - 2 * br)
			cm.menu.expander:SetPos(0, cm.win:GetHeaderHeight() + cm.menu:GetTall())
			cm.menu.expander:SetWide(sw)
			cm.site:SetPos(cm.menu:GetWide(), 0)
			cm.site:SetWide(cm.win:GetWide() - cm.menu:GetWide())
			cm.site:SetTall(cm.win:GetTall() - cm.win:GetHeaderHeight())
		end

		surface.SetFont(font)
		for i, v in pairs(sites) do
			if v.name ~= "hr" then
				local tw, _ = surface.GetTextSize(YRP.trans(v.name))
				if tw > cm.menu.pw then
					cm.menu.pw = tw
				end

				cm.sites[v.name] = YRPCreateD("YButton", cm.menu, cm.menu.pw, cm.menu.ph, 0, 0)
				local site = cm.sites[v.name]
				site:SetText("")
				site.id = tonumber(i)
				function site:Paint(pw, ph)
					self.aw = self.aw or 0
					local target = pw
					local color = YRPInterfaceValue("YFrame", "HB")
					if self:IsHovered() then
						color = YRPInterfaceValue("YButton", "SC")
						color.a = 120
					elseif self.selected then
						color = YRPInterfaceValue("YButton", "SC")
					else
						target = 0
					end

					self.aw = Lerp(10 * FrameTime(), self.aw, target)
					draw.RoundedBox(0, 0, 0, self.aw, ph, color)
					if YRP.GetDesignIcon(v.icon) ~= nil then
						surface.SetDrawColor(Color(255, 255, 255, 255))
						surface.SetMaterial(YRP.GetDesignIcon(v.icon))
						surface.DrawTexturedRect(br, br, ph - 2 * br, ph - 2 * br)
					end

					surface.SetFont(font)
					local tw2, _ = surface.GetTextSize(YRP.trans(v.name))
					if tw2 > cm.menu.pw then
						cm.menu.pw = tw2
						--cm.win:UpdateSize()
					end

					draw.SimpleText(YRP.trans(v.name), font, ph, ph / 2, YRPInterfaceValue("YFrame", "HT"), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
				end

				function site:DoClick()
					cm.menu:ClearSelection()
					cm.currentsite = self.id
					self.selected = true
					if v.content ~= nil then
						v.content(cm.site) --CreateHelpMenuContent( cm.site)
					end
				end

				if cm.currentsite == site.id then
					site:DoClick()
				end

				cm.menu:AddItem(site)
			else
				cm.sites[v.name] = YRPCreateD("DPanel", cm.menu, cm.menu.pw, YRP.ctr(20), 0, 0)
				local site = cm.sites[v.name]
				function site:Paint(pw, ph)
					local hr = YRP.ctr(2)
					draw.RoundedBox(0, br, ph / 2 - hr / 2, pw - br * 2, hr, Color(255, 255, 255, 255))
				end

				cm.menu:AddItem(site)
			end
		end

		if cm.menu.expanded == true then
			cm.win:UpdateSize()
		else
			cm.win:UpdateSize(cm.menu.ph)
		end
	elseif YRPPanelAlive(cm.win) and cm.win and cm.win.Show then
		cm.win:Show()
		for i, site in pairs(cm.sites) do
			if cm.currentsite == site.id then
				site:DoClick()
			end
		end
	end
end
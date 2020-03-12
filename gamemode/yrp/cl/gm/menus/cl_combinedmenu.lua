--Copyright (C) 2017-2020 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

local cm = {}
cm.open = false
cm.currentsite = 0
function ToggleCombinedMenu(id)
	id = tonumber(id)
	cm.currentsite = id
	if !cm.open and YRPIsNoMenuOpen() then
		OpenCombinedMenu()
	elseif cm.open and cm.currentsite != 4 and cm.currentsite != 5 then
		CloseCombinedMenu()
	end
end

function CloseCombinedMenu()
	cm.open = false
	if pa(cm.win) then
		cm.win:Hide()
	end
end

function OpenCombinedMenu()
	cm.open = true
	local br = YRP.ctr(20)
	local menuw = YRP.ctr(400)
	if pa(cm.win) == false then

		-- HELP
		local sites = {}
		sites.help = {}
		sites.help.id = 1
		sites.help.name = "LID_help"
		sites.help.content = CreateHelpMenuContent
		sites.roles = {}
		sites.roles.id = 2
		sites.roles.name = "LID_roles"
		sites.roles.content = CreateRoleMenuContent
		sites.shops = {}
		sites.shops.id = 3
		sites.shops.name = "LID_settings_shops"
		sites.shops.content = CreateBuyMenuContent
		sites.character = {}
		sites.character.id = 4
		sites.character.name = "LID_character"
		sites.character.content = CreateCharContent
		sites.keybinds = {}
		sites.keybinds.id = 5
		sites.keybinds.name = "LID_keybinds"
		sites.keybinds.content = CreateKeybindsContent
		sites.feedback = {}
		sites.feedback.id = 6
		sites.feedback.name = "LID_feedback"
		sites.feedback.content = CreateFeedbackContent
		-- HELP

		cm.win = createD("YFrame", nil, BFW(), BFH(), BPX(), BPY())
		cm.win:SetTitle(SQL_STR_OUT(GetGlobalDString("text_server_name", "")))
		cm.win:MakePopup()
		--cm.win:SetHeaderHeight(YRP.ctr(100))
		cm.win:SetBorder(0)
		function cm.win:Paint(pw, ph)
			if SQL_STR_OUT(GetGlobalDString("text_server_name", "")) != self:GetTitle() then
				self:SetTitle(SQL_STR_OUT(GetGlobalDString("text_server_name", "")))
			end
			hook.Run("YFramePaint", self, pw, ph)
		end

		local content = cm.win:GetContent()
		-- MENU
		cm.menu = createD("YPanel", content, menuw, BFH() - cm.win:GetHeaderHeight(), 0, 0)
		cm.menu:SetText("")
		function cm.menu:Paint(pw, ph)
			--draw.RoundedBox(0, 0, 0, pw, ph, Color(40, 40, 40, 255))
			--hook.Run("YPanelPaint", self, pw, ph)

			local gm = "YourRP by D4KiR"
			draw.SimpleText(gm, "Y_18_500", br, ph - br - YRP.ctr(40), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
			local vert = "Version:"
			local vern = GAMEMODE.Version
			draw.SimpleText(vert, "Y_18_500", br, ph - br, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
			draw.SimpleText(vern, "Y_18_500", br + YRP.ctr(120), ph - br, GetVersionColor(), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
		end

		cm.logo = createD("DHTML", cm.menu, menuw, menuw, br, br)
		cm.logo:SetHTML(GetHTMLImage(GetGlobalDString("text_server_logo", ""), menuw - br * 2, menuw - br * 2))
		TestHTML(cm.logo, GetGlobalDString("text_server_logo", ""), false)

		-- SITE
		local visi = nil
		cm.site = createD("YPanel", content, BFW() - menuw, BFH() - cm.win:GetHeaderHeight(), menuw, 0)
		cm.site:SetText("")
		cm.site:SetHeaderHeight(cm.win:GetHeaderHeight())
		function cm.site:Paint(pw, ph)
			--draw.RoundedBox(0, 0, 0, pw, ph, Color(120, 120, 120, 255))
			local tab = {}
			tab.color = Color(60, 60, 60, 255)
			hook.Run("YPanelPaint", self, pw, ph, tab) --draw.RoundedBox(0, 0, 0, pw, ph, Color(60, 60, 60, 255))

			if visi != cm.logo:IsVisible() then
				visi = cm.logo:IsVisible()
				if cm.logo:IsVisible() then
					for name, site in SortedPairsByMemberValue(sites, "id", false) do
						cm.sites[name]:SetPos(0, menuw + (site.id - 1) * (YRP.ctr(80) + br))
					end
				else
					for name, site in SortedPairsByMemberValue(sites, "id", false) do
						cm.sites[name]:SetPos(0, br + (site.id - 1) * (YRP.ctr(80) + br))
					end
				end
			end
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

		local id = 0
		for name, v in SortedPairsByMemberValue(sites, "id", false) do
			cm.sites[name] = createD("YButton", cm.menu, menuw, YRP.ctr(80), 0, menuw + id * (YRP.ctr(80) + br))
			local site = cm.sites[name]
			site:SetText("")
			site.id = tonumber(v.id)
			function site:Paint(pw, ph)
				local lply = LocalPlayer()
				local color = lply:InterfaceValue("YFrame", "HB")
				if self:IsHovered() then
					color = lply:InterfaceValue("YFrame", "HI")
				elseif self.selected then
					color = lply:InterfaceValue("YFrame", "HI")
				end
				draw.RoundedBox(0, 0, 0, pw, ph, color)
				draw.SimpleText(YRP.lang_string(v.name), "Y_18_500", br + br, ph / 2, lply:InterfaceValue("YFrame", "HT"), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

				if self.selected then
					draw.RoundedBox(0, 0, 0, YRP.ctr(10), ph, Color(140, 140, 255, 255))
				end
			end
			function site:DoClick()
				cm.menu:ClearSelection()
				cm.currentsite = self.id
				self.selected = true
				v.content(cm.site) --CreateHelpMenuContent(cm.site)
			end

			if cm.currentsite == site.id then
				site:DoClick()
			end

			id = id + 1
		end
	elseif pa(cm.win) then
		cm.win:Show()
		for i, site in pairs(cm.sites) do
			if cm.currentsite == site.id then
				site:DoClick()
			end
		end
	end
end

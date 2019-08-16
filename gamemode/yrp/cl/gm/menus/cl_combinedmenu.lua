--Copyright (C) 2017-2019 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

local cm = {}
cm.open = false
cm.currentsite = "help"
function ToggleCombinedMenu()
	if !cm.open and isNoMenuOpen() then
		OpenCombinedMenu()
	elseif cm.open then
		CloseCombinedMenu()
	end
end

function CloseCombinedMenu()
	cm.open = false
	if cm.win != nil then
		cm.win:Remove()
		cm.win = nil
	end
end

function OpenCombinedMenu()
	cm.open = true

	local br = YRP.ctr(20)
	local menuw = YRP.ctr(400)

	cm.win = createD("YFrame", nil, BFW(), BFH(), BPX(), BPY())
	cm.win:SetTitle(GetGlobalDString("text_server_name", ""))
	cm.win:MakePopup()
	cm.win:SetHeaderHeight(YRP.ctr(100))
	function cm.win:Paint(pw, ph)
		--draw.RoundedBox(0, 0, 0, pw, ph, Color(60, 60, 60, 255))
		--draw.RoundedBox(0, 0, 0, pw, self:GetHeaderHeight(), Color(40, 40, 40, 255))

		--draw.SimpleText(self:GetTitle(), "YRP_18_500", self:GetHeaderHeight() / 2, self:GetHeaderHeight() / 2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

		hook.Run("YFramePaint", self, pw, ph)

		--draw.RoundedBox(0, 0, self:GetHeaderHeight(), pw, ph - self:GetHeaderHeight(), Color(60, 60, 60, 255))
	end

	-- MENU
	cm.menu = createD("YPanel", cm.win, menuw, BFH() - cm.win:GetHeaderHeight(), 0, cm.win:GetHeaderHeight())
	cm.menu:SetText("")
	function cm.menu:Paint(pw, ph)
		draw.RoundedBox(0, 0, 0, pw, ph, Color(40, 40, 40, 255))

		local gm = "YourRP by D4KiR"
		draw.SimpleText(gm, "YRP_18_500", br, ph - br - YRP.ctr(40), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
		local vert = "Version:"
		local vern = GAMEMODE.Version
		draw.SimpleText(vert, "YRP_18_500", br, ph - br, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
		draw.SimpleText(vern, "YRP_18_500", br + YRP.ctr(120), ph - br, GetVersionColor(), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
	end

	cm.logo = createD("DHTML", cm.menu, menuw, menuw, br, br)
	cm.logo:SetHTML(GetHTMLImage(GetGlobalDString("text_server_logo", ""), menuw - br * 2, menuw - br * 2))

	-- SITE
	cm.site = createD("YPanel", cm.win, BFW() - menuw, BFH() - cm.win:GetHeaderHeight(), menuw, cm.win:GetHeaderHeight())
	cm.site:SetText("")
	cm.site:SetHeaderHeight(cm.win:GetHeaderHeight())
	function cm.site:Paint(pw, ph)
		--draw.RoundedBox(0, 0, 0, pw, ph, Color(120, 120, 120, 255))

		draw.RoundedBox(0, 0, 0, pw, ph, Color(60, 60, 60, 255))
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
	sites.feedback = {}
	sites.feedback.id = 4
	sites.feedback.name = "LID_feedback"
	sites.feedback.content = CreateFeedbackContent

	local id = 0
	for name, v in SortedPairsByMemberValue(sites, "id", false) do
		cm.sites[name] = createD("YButton", cm.menu, menuw, YRP.ctr(80), 0, menuw + id * (YRP.ctr(80) + br))
		local site = cm.sites[name]
		site:SetText("")
		function site:Paint(pw, ph)
			local color = Color(40, 40, 40, 255)
			if self:IsHovered() then
				color = Color(80, 80, 80, 255)
			elseif self.selected then
				color = Color(60, 60, 60, 255)
			end
			draw.RoundedBox(0, 0, 0, pw, ph, color)
			draw.SimpleText(YRP.lang_string(v.name), "YRP_18_500", br + br, ph / 2, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

			if self.selected then
				draw.RoundedBox(0, 0, 0, YRP.ctr(10), ph, Color(140, 140, 255, 255))
			end
		end
		function site:DoClick()
			cm.menu:ClearSelection()
			cm.currentsite = name
			self.selected = true
			v.content(cm.site) --CreateHelpMenuContent(cm.site)
		end

		if cm.currentsite == name then
			site:DoClick()
		end

		id = id + 1
	end
end

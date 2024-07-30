--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
function DrawSelector(btn, w, h, text, selected, hassubtabs)
	local spacer = 0
	if hassubtabs then
		spacer = YRP:ctr(100)
	end

	draw.SimpleText(text, "Y_22_500", w / 2 - spacer / 2, h / 2, Color(255, 255, 255, 255), 1, 1)
	if btn.ani_h == nil then
		btn.ani_h = 0
	end

	if btn:IsHovered() or selected then
		if btn.ani_h < 10 then
			btn.ani_h = btn.ani_h + 1
		end
	else
		if btn.ani_h > 0 then
			btn.ani_h = btn.ani_h - 1
		end
	end

	local color = YRPGetColor("2")
	if btn:IsHovered() then
		color = YRPGetColor("1")
	elseif selected then
		color = YRPGetColor("3")
	end

	draw.RoundedBox(0, 0, h - YRP:ctr(btn.ani_h), w, YRP:ctr(btn.ani_h), color)
end

local PANEL = {}
local color_red = Color(255, 0, 0, 100)
function PANEL:Init()
	self.tabs = {}
	self.hscroller = YRPCreateD("DHorizontalScroller", self, self:GetWide(), YRP:ctr(100), 0, 0)
	function self.hscroller:Paint(pw, ph)
	end

	--draw.RoundedBox( 0, 0, 0, pw, ph, Color( 255, 255, 255, 255 ) )
	self.w = 0
	self.h = 0
	self.site = YRPCreateD("DPanel", self, 0, 0, 0, 0)
	function self.site:Paint(pw, ph)
		draw.RoundedBox(0, 0, 0, pw, ph, color_red)
	end
end

function PANEL:AddPanel(pnl)
	table.insert(self.tabs, pnl)
	self.hscroller:AddPanel(pnl)
	self.w = 0
	self.x = 0
	for i, tab in pairs(self.tabs) do
		self.w = self.w + tab:GetWide()
	end

	self.hscroller:SetSize(self.w, YRP:ctr(100))
	self.hscroller:SetPos(self:GetWide() / 2 - self.w / 2, 0)
end

function PANEL:MakeSpacer()
	local spacer = YRPCreateD("YButton", self, YRP:ctr(30), YRP:ctr(100), 0, 0)
	spacer:SetText("")
	function spacer:Paint(pw, ph)
	end

	self:AddPanel(spacer)
end

function PANEL:ClearSite()
	for i, child in pairs(self.site:GetChildren()) do
		child:Remove()
	end

	function self.site:Paint(pw, ph)
	end
	--
end

function PANEL:SiteNotFound()
	self:ClearSite()
	function self.site:Paint(pw, ph)
		draw.SimpleText("[Site Not Found]", "Y_18_500", pw / 2, ph / 2, Color(255, 255, 0, 255), 1, 1)
		draw.SimpleText("[" .. YRP:trans("LID_wip") .. "]", "Y_18_500", pw / 2, ph / 2 + YRP:ctr(50), Color(255, 255, 0, 255), 1, 1)
	end
end

function PANEL:AddTab(name, netstr, starttab, hassubtabs)
	if #self.tabs > 0 then
		self:MakeSpacer()
	end

	local spacer = 0
	if hassubtabs then
		spacer = YRP:ctr(100)
	end

	local TAB = YRPCreateD("YButton", self, YRPGetTextLength(YRP:trans(name), "Y_22_500") + YRP:ctr(30 * 2) + spacer, YRP:ctr(100), YRP:ctr(400), 0)
	TAB.menu = self
	TAB.name = name
	TAB.netstr = netstr
	TAB:SetText("")
	TAB.subtabs = {}
	function TAB:HideSubTabs()
		if self.stabs ~= nil then
			self.stabs:Remove()
			self.stabs = nil
		end
	end

	function TAB:ShowSubTabs()
		if self.stabs == nil then
			local posx, posy = self:LocalToScreen(0, 0)
			self.stabs = YRPCreateD("DFrame", self, YRP:ctr(400), self:GetTall() * table.Count(self.subtabs), posx, posy + self:GetTall())
			self.stabs:SetTitle("")
			self.stabs:ShowCloseButton(false)
			self.stabs:SetDraggable(false)
			function self.stabs:Paint(pw, ph)
				if not YRPPanelAlive(self:GetParent(), "ShowSubTabs") then
					self:HideSubTabs()
				end

				local mx, my = gui.MousePos()
				local px, py = self:GetPos()
				if mx > px + pw then
					self:GetParent():HideSubTabs()
				elseif mx < px then
					self:GetParent():HideSubTabs()
				elseif my > py + ph then
					self:GetParent():HideSubTabs()
				elseif my < py and mx > px + self:GetParent():GetWide() then
					self:GetParent():HideSubTabs()
				end
				--draw.RoundedBox( 0, 0, YRP:ctr(4), pw, ph - YRP:ctr(8), Color( 0, 0, 255, 255) )
			end

			self.stabs.pl = YRPCreateD("DPanelList", self.stabs, self.stabs:GetWide(), self.stabs:GetTall(), 0, 0)
			for i, subtab in pairs(self.subtabs) do
				local st = YRPCreateD("YButton", self.stabs.pl, self.stabs:GetWide(), self:GetTall(), 0, 0)
				st:SetText("")
				st.menu = TAB
				st.name = subtab.name
				st.netstr = subtab.netstr or ""
				st.url = subtab.url or ""
				st.func = subtab.func or nil
				st.tab = {
					["text"] = self.name
				}

				function st:Paint(pw, ph)
					hook.Run("YButtonPaint", self, pw, ph, self.tab)
					if self.url ~= "" or self.func ~= nil then
						local br = YRP:ctr(10)
						local size = ph - 2 * YRP:ctr(20)
						YRP:DrawIcon(YRP:GetDesignIcon("launch"), size, size, pw - size - br, ph / 2 - size / 2, YRPGetColor("6"))
					end

					local icon = ""
					if string.find(string.lower(subtab.name), "discord", 1, true) then
						icon = "discord"
					elseif string.find(string.lower(subtab.name), "teamspeak", 1, true) then
						icon = "ts"
					elseif string.find(string.lower(subtab.name), "translations", 1, true) then
						icon = "language"
					elseif string.find(string.lower(subtab.name), "steam", 1, true) then
						icon = "steam"
					end

					if not strEmpty(icon) then
						local br = YRP:ctr(20)
						YRP:DrawIcon(YRP:GetDesignIcon(icon), ph - 2 * br, ph - 2 * br, br, br, YRPGetColor("6"))
					end
				end

				function st:DoClick()
					if self.netstr ~= "" then
						TAB.menu.current_site = self.menu.name
						TAB.menu:ClearSite()
						st.menu:HideSubTabs()
						net.Start(self.netstr)
						net.SendToServer()
					elseif self.url ~= "" then
						gui.OpenURL(self.url)
					elseif self.func ~= nil then
						self.func()
					end
				end

				self.stabs.pl:AddItem(st)
			end

			self.stabs:MakePopup()
		end
	end

	function TAB:Paint(pw, ph)
		if self.menu.current_site == self.name then
			self.selected = true
		else
			self.selected = false
		end

		DrawSelector(self, pw, ph, YRP:trans(self.name), self.selected, hassubtabs)
		if self.hassubtabs then
			local br = YRP:ctr(20)
			YRP:DrawIcon(YRP:GetDesignIcon("64_angle-down"), ph - br * 2, ph - br * 2, pw - br - ph / 2 - br, br, YRPGetColor("6"))
		end

		if self:IsHovered() then
			self:GetParent().hovered = TAB.name
			self:ShowSubTabs()
			--elseif self:GetParent().hovered ~= TAB.name then
		end
		-- self:HideSubTabs()
	end

	function TAB:DoClick()
		self.menu.current_site = self.name
		if self.netstr ~= "" then
			self.menu:ClearSite()
			net.Start(self.netstr)
			net.SendToServer()
		else
			self:HideSubTabs()
			if self.subtabs[1].netstr ~= "" then
				net.Start(self.subtabs[1].netstr)
				net.SendToServer()
			end
		end
	end

	function TAB:AddToTab(_name, _netstr, url, func)
		local entry = {}
		entry.name = _name
		entry.netstr = _netstr or ""
		entry.url = url or ""
		entry.func = func or nil
		table.insert(self.subtabs, entry)
	end

	if starttab then
		TAB:DoClick()
	end

	self:AddPanel(TAB)

	return TAB
end

function PANEL:SetStartTab(name)
	self.starttab = name
	for i, tab in pairs(self.tabs) do
		if tab.name == name then
			tab:DoClick()
			break
		end
	end
end

function PANEL:GetMenuInfo(netstr)
	net.Start(netstr)
	net.SendToServer()
	net.Receive(
		netstr,
		function(len)
			if YRPPanelAlive(self, "GetMenuInfo") then
				local tabs = net.ReadTable()
				local subtabs = net.ReadTable()
				for i, tab in pairs(tabs) do
					local starttab = false
					if tab.name == self.starttab then
						starttab = true
					end

					local hassubtabs = false
					for _i, subtab in pairs(subtabs) do
						if subtab.parent == tab.name then
							hassubtabs = true
						end
					end

					local pnl = self:AddTab(tab.name, tab.netstr, starttab, hassubtabs)
					for _i, subtab in pairs(subtabs) do
						if subtab.parent == tab.name then
							pnl.hassubtabs = true
							pnl:AddToTab(subtab.name, subtab.netstr, subtab.url, subtab.func)
						end
					end
				end
			end
		end
	)
end

function PANEL:Think()
	local _mx, _my = gui.MousePos()
	if self.w ~= self:GetWide() or self.h ~= self:GetTall() then
		self.w = self:GetWide()
		self.h = self:GetTall()
		self.site:SetSize(self:GetWide() - YRP:ctr(2 * 20), self:GetTall() - YRP:ctr(100 + 20 + 20))
		self.site:SetPos(YRP:ctr(20), YRP:ctr(100 + 20))
	end
end

function PANEL:SetHeaderHeight(h)
	self.headerh = h
end

function PANEL:GetHeaderHeight()
	return self.headerh
end

function PANEL:Paint(w, h)
	local col = YRPInterfaceValue("YFrame", "HI")
	draw.RoundedBox(0, 0, 0, w, self:GetHeaderHeight() or h, col or Color(255, 0, 0))
end

vgui.Register("DYRPHorizontalMenu", PANEL, "Panel")

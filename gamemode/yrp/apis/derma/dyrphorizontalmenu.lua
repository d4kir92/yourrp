--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )
function DrawSelector(btn, w, h, text, selected)
	draw.SimpleTextOutlined(text, "mat1header", w / 2, h / 2, Color(255, 255, 255, 255), 1, 1, ctr(1), Color(0, 0, 0, 255))

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

	surfaceBox(0, h - ctr(btn.ani_h), w, ctr(btn.ani_h), color)
end

local PANEL = {}

function PANEL:Init()
	self.tabs = {}
	self.hscroller = createD("DHorizontalScroller", self, self:GetWide(), ctr(100), 0, 0)

	function self.hscroller:Paint(pw, ph)
		--surfaceBox( 0, 0, pw, ph, Color( 255, 255, 255, 255 ) )
	end

	self.w = 0
	self.h = 0
	self.site = createD("DPanel", self, 0, 0, 0, 0)

	function self.site:Paint(pw, ph)
		surfaceBox(0, 0, pw, ph, Color(255, 0, 0, 100))
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

	self.hscroller:SetSize(self.w, ctr(100))
	self.hscroller:SetPos(self:GetWide() / 2 - self.w / 2, 0)
end

function PANEL:MakeSpacer()
	local spacer = createD("DButton", self, ctr(30), ctr(100), 0, 0)
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
		--
	end
end

function PANEL:SiteNotFound()
	self:ClearSite()

	function self.site:Paint(pw, ph)
		draw.SimpleTextOutlined("[Site Not Found]", "mat1text", pw / 2, ph / 2, Color(255, 255, 0, 255), 1, 1, ctr(1), Color(0, 0, 0))
		draw.SimpleTextOutlined("[" .. lang_string("wip") .. "]", "mat1text", pw / 2, ph / 2 + ctr(50), Color(255, 255, 0, 255), 1, 1, ctr(1), Color(0, 0, 0))
	end
end

function PANEL:AddTab(name, netstr, starttab)
	if #self.tabs > 0 then
		self:MakeSpacer()
	end

	local TAB = createD("DButton", self, GetTextLength(lang_string(name), "mat1header") + ctr(30 * 2), ctr(100), ctr(400), 0)
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
			self.stabs = createD("DFrame", self, ctr(400), self:GetTall() * table.Count(self.subtabs), posx, posy + self:GetTall())
			self.stabs:SetTitle("")
			self.stabs:ShowCloseButton(false)
			self.stabs:SetDraggable(false)

			function self.stabs:Paint(pw, ph)
				if not pa(self:GetParent()) then
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
				--surfaceBox( 0, ctr( 4 ), pw, ph - ctr( 8 ), Color( 0, 0, 255, 255 ) )
			end

			self.stabs.pl = createD("DPanelList", self.stabs, self.stabs:GetWide(), self.stabs:GetTall(), 0, 0)

			for i, subtab in pairs(self.subtabs) do
				local st = createD("DButton", self.stabs.pl, self.stabs:GetWide(), self:GetTall(), 0, 0)
				st:SetText("")
				st.menu = TAB
				st.name = subtab.name
				st.netstr = subtab.netstr or ""
				st.url = subtab.url or ""
				st.func = subtab.func or nil

				function st:Paint(pw, ph)
					surfaceButton(self, pw, ph, self.name)

					if self.url ~= "" or self.func ~= nil then
						local br = ctr(10)
						local size = ph - 2 * ctr(20)
						DrawIcon(GetDesignIcon("launch"), size, size, pw - size - br, ph / 2 - size / 2, YRPGetColor("6"))
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

		DrawSelector(self, pw, ph, lang_string(self.name), self.selected)

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

	function TAB:AddToTab(_name,_netstr, url, func)
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

	net.Receive(netstr, function(len)
		if pa(self) then
			local tabs = net.ReadTable()
			local subtabs = net.ReadTable()

			for i, tab in pairs(tabs) do
				local starttab = false

				if tab.name == self.starttab then
					starttab = true
				end

				local pnl = self:AddTab(tab.name, tab.netstr, starttab)

				for _i, subtab in pairs(subtabs) do
					if subtab.parent == tab.name then
						pnl:AddToTab(subtab.name, subtab.netstr, subtab.url, subtab.func)
					end
				end
			end
		end
	end)
end

function PANEL:Think()
	local _mx, _my = gui.MousePos()

	if self.w ~= self:GetWide() or self.h ~= self:GetTall() then
		self.w = self:GetWide()
		self.h = self:GetTall()
		self.site:SetSize(self:GetWide() - ctr(2 * 20), self:GetTall() - ctr(100 + 20 + 20))
		self.site:SetPos(ctr(20), ctr(100 + 20))
	end
end

function PANEL:Paint(w, h)
	surfaceBox(0, 0, w, ctr(100), Color(255, 255, 255, 10))
	--surfaceBox( 0, 0, w, h, Color( 255, 255, 0, 100 ) )
end

vgui.Register("DYRPHorizontalMenu", PANEL, "Panel")

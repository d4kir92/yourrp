--Copyright (C) 2017-2020 Arno Zura (https://www.gnu.org/licenses/gpl.txt)
local PANEL = {}

function PANEL:UPDATESIZE()
	self.hs:SetSize(self:GetWide(), YRP.ctr(self.height))
	self.site:SetSize(self:GetWide(), self:GetTall() - YRP.ctr(self.height))

	self.site:SetPos(0, YRP.ctr(self.height))
end

function PANEL:Init()
	self.hs = createD("DHorizontalScroller", self, 0, 0, 0, 0)
	self.hs:SetOverlap(-YRP.ctr(20))
	self.site = createD("DPanel", self, 0, 0, 0, 0)
	function self.site:Paint(pw, ph)
		--draw.RoundedBox(0, 0, 0, pw, ph, Color(255, 100, 100, 200))
	end

	self.auto = true
	self.tabwide = 400

	self.tabs = {}
end

function PANEL:SetTabWide(num)
	self.tabwide = num
end

function PANEL:SetAutoTab(b)
	self.auto = b
end

function PANEL:AddOption(name, func, height)
	height = height or 100
	self.height = height
	self:UPDATESIZE()
	print("height", height)
	local tab = createD("DButton", nil, YRP.ctr(400), YRP.ctr(height), 0, 0)
	tab:SetText("")
	tab.tabs = self
	function tab:DoClick()
		self.tabs:GoToSite(name)
	end
	function tab:Paint(pw, ph)
		if self.tabs.auto then
			surface.SetFont("Y_25_500")
			local tw, th = surface.GetTextSize(YRP.lang_string(name))
			self:SetWide(tw + YRP.ctr(80))
		else
			self:SetWide(YRP.ctr(self.tabs.tabwide))
		end
		self.color = Color(100, 100, 255)
		self.h = self.h or 0
		self.delay = 0.8
		if self.tabs.current == name then
			self.h = self.h + self.delay
			self.color = Color(100, 100, 255)
		elseif self:IsHovered() then
			self.h = self.h + self.delay
			self.color = Color(200, 200, 255)
		else
			self.h = self.h - self.delay
		end
		self.h = math.Clamp(self.h, 0, 10)
	
		--draw.RoundedBox(0, 0, 0, pw, ph, Color(255, 0, 0, 100))

		draw.RoundedBox(0, YRP.ctr(20), ph - YRP.ctr(self.h), pw - YRP.ctr(40), YRP.ctr(self.h), self.color)

		draw.SimpleText(YRP.lang_string(name), "Y_25_500", pw / 2, ph / 2, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

	self.tabs[name] = func
	self.hs:AddPanel(tab)
end

function PANEL:GoToSite(name)
	self.site:Clear()
	self.current = name
	self.tabs[name](self.site)
end

function PANEL:Paint(w, h)
	local x, y = self:GetPos()
	if self.sw != w or self.sh != h or self.px != x or self.py != y then
		self.sw = w
		self.sh = h
		self.px = x
		self.py = y

		self:UPDATESIZE()
	end
end

vgui.Register("YTabs", PANEL, "Panel")

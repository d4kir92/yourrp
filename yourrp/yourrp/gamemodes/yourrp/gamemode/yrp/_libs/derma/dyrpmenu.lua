--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
local PANEL = {}
function PANEL:Init()
	self.content = {}
	self.lastheight = 0
end

function PANEL:Think()
	local _mx, _my = gui.MousePos()
	local _px, _py = self:GetPos()
	if _mx < _px then
		self:Remove()
	end

	if _my < _py then
		self:Remove()
	end

	if _mx > _px + self:GetWide() then
		self:Remove()
	end

	if _my > _py + self:GetTall() then
		self:Remove()
	end
end

function PANEL:UpdateMenu()
	local Height = 0
	for i, ele in pairs(self.content) do
		Height = Height + ele.size
	end

	self:SetTall(YRP:ctr(Height))
	local _x, _y = self:GetPos()
	if _y + self:GetTall() > ScrH() then
		self:SetPos(_x, ScrH() - self:GetTall())
	end
end

function PANEL:AddSpacer()
	local Entry = {}
	Entry.size = 10
	Entry.spacer = YRPCreateD("DPanel", self, self:GetWide(), YRP:ctr(Entry.size), 0, YRP:ctr(self.lastheight))
	function Entry.spacer:Paint(pw, ph)
		draw.RoundedBox(0, 0, ph / 4, pw, ph / 2, Color(0, 0, 0, 255))
	end

	self.lastheight = self.lastheight + Entry.size
	table.insert(self.content, Entry)
	self:UpdateMenu()
end

function PANEL:AddOption(name, icon)
	local Entry = {}
	Entry.name = name
	Entry.iconpng = icon or ""
	if Entry.iconpng ~= "" then
		Entry.iconmat = Material(Entry.iconpng)
	end

	Entry.size = 50
	Entry.icon = YRPCreateD("YPanel", self, YRP:ctr(Entry.size), YRP:ctr(Entry.size), 0, YRP:ctr(self.lastheight))
	function Entry.icon:Paint(pw, ph)
		if Entry.iconpng ~= "" then
			surface.SetDrawColor(Color(255, 255, 255, 255))
			surface.SetMaterial(Entry.iconmat)
			surface.DrawTexturedRect(YRP:ctr(9), YRP:ctr(9), YRP:ctr(32), YRP:ctr(32))
		end
	end

	Entry.button = YRPCreateD("YButton", self, self:GetWide() - YRP:ctr(Entry.size), YRP:ctr(Entry.size), YRP:ctr(Entry.size), YRP:ctr(self.lastheight))
	Entry.button:SetText(Entry.name)
	function Entry.button:Paint(pw, ph)
		hook.Run("YButtonPaint", self, pw, ph)
	end

	self.lastheight = self.lastheight + Entry.size
	table.insert(self.content, Entry)
	self:UpdateMenu()

	return Entry.button
end

vgui.Register("DYRPMenu", PANEL, "YPanel")

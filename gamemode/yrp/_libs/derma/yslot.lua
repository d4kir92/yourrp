--Copyright (C) 2017-2019 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

local PANEL = {}

itemsize = itemsize or 100

function PANEL:Paint(pw, ph)
	draw.RoundedBox(5, 0, 0, pw, ph, Color(80, 80, 80, 255))
	if self.name != nil then
		draw.SimpleText(self.name, "DermaDefault", pw / 2, ph / 2, Color(255, 0, 0, 200), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
end

function PANEL:AllowedToDrop(item)
	return table.HasValue(self.allowed, item.typ)
end

function PANEL:AddAllowed(a)
	table.insert(self.allowed, a)
end

function PANEL:RemoveAllowed(a)
	table.RemoveByValue(self.allowed, a)
end

function PANEL:SetSlot(name)
	self.name = name
end

function PANEL:Init()
	self.allowed = {}
	self:AddAllowed("item")

	self:SetText("")

	self:Receiver("yrp_slot",
	function(receiver, panels, bDoDrop, Command, x, y)
		if bDoDrop then
			local item = panels[1]
			if !item:GetFixed() and self:AllowedToDrop(item) then
				receiver:AddItem(item)
			end
		end
	end, {})
end

vgui.Register("YSlot", PANEL, "DScrollPanel")

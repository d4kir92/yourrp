--Copyright (C) 2017-2019 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

local PANEL = {}

itemsize = itemsize or 100

function PANEL:Paint(pw, ph)
	draw.RoundedBox(5, 0, 0, pw, ph, Color(80, 80, 80, 255))
	if self.name != nil then
		--draw.SimpleText(self.name, "DermaDefault", pw / 2, ph / 2, Color(255, 0, 0, 200), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
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

local SLOTS = SLOTS or {}

function PANEL:SetSlot(name)
	self.name = name
	SLOTS[self.name] = self
	net.Start("join_slot")
		net.WriteString(self.name)
	net.SendToServer()
end
net.Receive("send_slot_content", function(len)
	local slot = net.ReadString()
	local yrp_slot = SLOTS[slot]
	local items = net.ReadTable()
	for i, item in pairs(items) do
		local yitem = createD("YItem", nil, ItemSize(), ItemSize(), 0, 0)
		yitem:SetText("") --item.text_printname)
		yitem:SetTyp("bag")
		if slot == "bag0" then
			yitem:SetFixed(true)
		end
		item.text_storage = tonumber(item.text_storage)
		if item.text_storage > 0 then
			yitem:SetStorage(item.text_storage)
		end

		yitem:SetModel(item.text_worldmodel)
		yrp_slot:AddItem(yitem)
	end
end)

function PANEL:OnRemove()
	net.Start("leave_slot")
		net.WriteString(self.name)
	net.SendToServer()
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

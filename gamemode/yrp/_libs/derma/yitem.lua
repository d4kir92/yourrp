--Copyright (C) 2017-2020 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

local PANEL = {}

function PANEL:Paint(pw, ph)
	draw.RoundedBox(5, 0, 0, pw, ph, Color(255, 255, 255, 100))

	if self.mdl:GetWide() != pw or self.mdl:GetTall() != ph then
		self.mdl:SetSize(pw, ph)
	end
	if self._world then
		if !IsValid(self:GetE()) then
			self:Remove()
		end
	end
end

function PANEL:GetItemID()
	return self._itemID
end

function PANEL:SetItemID(itemID)
	self._itemID = itemID
end

function PANEL:SetModel(mdl)
	self.mdl:SetModel(mdl)
end

function PANEL:GetE()
	return self._e
end

function PANEL:SetE(e)
	self._e = e
	self._world = true
end

function PANEL:Init()
	self:SetText("")

	self._world = false

	self.mdl = createD("SpawnIcon", self, self:GetWide(), self:GetTall(), 0, 0)
	self.mdl.main = self
	function self:DoClick()
		net.Start("yrp_item_clicked")
			net.WriteString(self:GetItemID())
		net.SendToServer()
	end
	function self.mdl:DoClick()
		self.main:DoClick()
	end
	function self.mdl:DoRightClick()
		-- RIGHTCLICK
	end

	function self.mdl:PaintOver(pw, ph)
		draw.RoundedBox(5, 0, 0, pw, ph, Color(255, 255, 255, 1))
	end

	self.mdl:Droppable("yrp_slot")
end

net.Receive("yrp_storage_open", function(len)
	local lply = LocalPlayer()

	local storage = net.ReadTable()
	local isinv = net.ReadBool()

	local sto = GetStoragePanel(storage.uniqueID)

	if sto != nil then
		sto:GetParent():Remove()
	else
		local br = YRP.ctr(20)
		local sp = YRP.ctr(10)

		local ww = ItemSize() * 4 + br * 2 + sp * 3
		local wh = ItemSize() * 4 + br * 2 + sp * 3 + YRP.ctr(50)

		local bag = createD("DFrame", nil, ww, wh, 0, 0)
		if isinv then
			bag:SetPos(lply.invx - ww, lply.invy - wh)

			lply.invy = lply.invy - wh - YRP.ctr(20)
		else
			bag:Center()
		end
		bag:MakePopup()
		bag:SetTitle("BAG")
		function bag:Paint(pw, ph)
			draw.RoundedBox(0, 0, 0, pw, ph, lply:InterfaceValue("YFrame", "NC"))
			if Inventory() == nil then
				self:Remove()
			end
		end
		
		local sw = ItemSize() * 4 + sp * 3
		local sh = ItemSize() * 4 + sp * 3

		bag.storage = createD("YStorage", bag, sw, sh, br, br + YRP.ctr(50))
		bag.storage:SetStorageID(storage.uniqueID)
	end
end)

vgui.Register("YItem", PANEL, "DButton")

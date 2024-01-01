--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
local PANEL = {}
function PANEL:Paint(pw, ph)
	--draw.RoundedBox(5, 0, 0, pw, ph, Color( 255, 255, 255, 100) )
	if self.mdl:GetWide() ~= pw or self.mdl:GetTall() ~= ph then
		self.mdl:SetSize(pw, ph)
	end

	if self._world and not IsValid(self:GetE()) then
		self:Remove()
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
	self.mdl = YRPCreateD("SpawnIcon", self, self:GetWide(), self:GetTall(), 0, 0)
	self.mdl.main = self
	function self:DoClick()
		if self:GetItemID() ~= nil then
			net.Start("nws_yrp_item_clicked")
			net.WriteString(self:GetItemID())
			net.SendToServer()
		else
			YRP.msg("note", "[YItem] self:GetItemID() == nil")
		end
	end

	function self.mdl:DoClick()
		self.main:DoClick()
	end

	function self.mdl:DoRightClick()
	end

	-- RIGHTCLICK
	function self.mdl:PaintOver(pw, ph)
	end

	--draw.RoundedBox(5, 0, 0, pw, ph, Color( 255, 255, 255, 1) )
	self.mdl:Droppable("yrp_slot")
end

net.Receive(
	"nws_yrp_storage_open",
	function(len)
		local lply = LocalPlayer()
		local storage = net.ReadTable()
		local isinv = net.ReadBool()
		local sto = GetStoragePanel(storage.uniqueID)
		if sto ~= nil then
			sto:GetParent():Remove()
		else
			local br = YRP.ctr(20)
			local sp = YRP.ctr(10)
			local cols = 4
			local sh = tonumber(storage.int_storage_size)
			sh = math.ceil(sh / cols)
			local ww = YRPItemSize() * cols + br * 2 + sp * (cols - 1)
			local wh = YRPItemSize() * sh + br * 2 + sp * (sh - 1) + YRP.ctr(50)
			local bag = YRPCreateD("DFrame", nil, ww, wh, 0, 0)
			if isinv then
				bag:SetPos(lply.invx - ww, lply.invy - wh)
				if lply.invy - wh - YRP.ctr(20) < YRP.ctr(20) then
					lply.invx = lply.invx - ww - YRP.ctr(20)
					lply.invy = ScH() - (YRPItemSize() + YRP.ctr(60))
					bag:SetPos(lply.invx - ww, lply.invy - wh)
					lply.invy = lply.invy - wh - YRP.ctr(20)
				else
					lply.invy = lply.invy - wh - YRP.ctr(20)
				end
			else
				bag:Center()
			end

			bag:MakePopup()
			bag:SetTitle("")
			function bag:Paint(pw, ph)
				draw.RoundedBox(0, 0, 0, pw, ph, YRPInterfaceValue("YFrame", "NC"))
				draw.SimpleText(YRP.trans("LID_bag"), "Y_18_500", YRP.ctr(20), YRP.ctr(30), Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
				if YRPInventory() == nil then
					self:Remove()
				end
			end

			local psw = YRPItemSize() * cols + sp * (cols - 1)
			local psh = YRPItemSize() * cols + sp * (cols - 1)
			bag.storage = YRPCreateD("YStorage", bag, psw, psh, br, br + YRP.ctr(50))
			bag.storage:SetStorageID(storage.uniqueID)
		end
	end
)

vgui.Register("YItem", PANEL, "DButton")
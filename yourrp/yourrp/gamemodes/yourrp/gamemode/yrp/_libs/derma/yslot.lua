--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
local PANEL = {}
function PANEL:Paint(pw, ph)
	draw.RoundedBox(5, 0, 0, pw, ph, Color(80, 80, 80, 255))
end

local YRP_SLOTS = YRP_SLOTS or {}
function GetSlotPanel(slotID)
	if IsNotNilAndNotFalse(slotID) then
		slotID = tonumber(slotID)
		if IsNotNilAndNotFalse(YRP_SLOTS[slotID]) then
			return YRP_SLOTS[slotID]
		else
			return nil
		end
		--YRP.msg( "note", "[GetSlotPanel] no panel with: " .. tostring(slotID) )
	else
		YRP.msg("note", "[GetSlotPanel] slotID is invalid: " .. tostring(slotID))
	end
end

function SetSlotPanel(slotID, pnl)
	if IsNotNilAndNotFalse(slotID) then
		slotID = tonumber(slotID)
		if not IsNotNilAndNotFalse(YRP_SLOTS[slotID]) then
			YRP_SLOTS[slotID] = pnl
		else
			YRP.msg("note", "[SetSlotPanel] there is already a Slot with slotID: " .. tostring(slotID))
		end
	else
		YRP.msg("note", "[SetSlotPanel] slotID is invalid: " .. tostring(slotID))
	end
end

function RemoveSlotPanel(slotID, pnl)
	if IsNotNilAndNotFalse(YRP_SLOTS[slotID]) then
		YRP_SLOTS[slotID] = nil
	end
end

function PANEL:GetSlotID()
	return self._slotID
end

function PANEL:SetSlotID(slotID)
	if IsNotNilAndNotFalse(slotID) then
		slotID = tonumber(slotID)
		self._slotID = slotID
		SetSlotPanel(self._slotID, self)
		self.name = "ID: " .. slotID -- REMOVEME
		net.Start("nws_yrp_slot_connect")
		net.WriteString(self._slotID)
		net.SendToServer()
	end
end

function PANEL:OnRemove()
	if IsNotNilAndNotFalse(self._slotID) then
		net.Start("nws_yrp_slot_disconnect")
		net.WriteString(self._slotID)
		net.SendToServer()
		RemoveSlotPanel(self:GetSlotID(), self)
	end
end

function PANEL:Init()
	--[[self:SetText( "" )

	self._slotid = 0
	]]
	self:Receiver(
		"yrp_slot",
		function(receiver, panels, bDoDrop, Command, x, y)
			if bDoDrop then
				local item = panels[1]
				local itemID = item.main:GetItemID()
				local slotID = receiver:GetSlotID()
				local e = item.main:GetE()
				if slotID ~= nil then
					net.Start("nws_yrp_item_move")
					net.WriteString(itemID or "0")
					net.WriteString(slotID)
					net.WriteEntity(e)
					net.SendToServer()
				elseif itemID ~= nil then
					net.Start("nws_yrp_item_drop")
					net.WriteString(itemID)
					net.SendToServer()
					receiver:AddItem(item.main)
				end
			end
		end, {}
	)
end

net.Receive(
	"nws_yrp_item_store",
	function(len)
		local slotID = net.ReadString()
		local item = net.ReadTable()
		slotID = tonumber(slotID)
		local slot = GetSlotPanel(slotID)
		if YRPPanelAlive(slot, "slot") then
			local i = YRPCreateD("YItem", nil, YRPItemSize(), YRPItemSize(), 0, 0)
			i:SetItemID(item.uniqueID)
			i:SetModel(item.text_worldmodel)
			if item.isinv then
				i:DoClick()
			end

			slot:AddItem(i)
		end
	end
)

net.Receive(
	"nws_yrp_item_unstore",
	function(len)
		local slotID = net.ReadString()
		slotID = tonumber(slotID)
		local slot = GetSlotPanel(slotID)
		if slot then
			slot:Clear()
		end
	end
)

vgui.Register("YSlot", PANEL, "DScrollPanel")
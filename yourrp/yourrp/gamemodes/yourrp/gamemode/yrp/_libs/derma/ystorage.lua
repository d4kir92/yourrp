--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
local PANEL = {}
function PANEL:Paint(pw, ph)
end

--draw.RoundedBox(0, 0, 0, pw, ph, Color( 255, 0, 0, 200) )
local YRP_STORAGES = YRP_STORAGES or {}
function GetStoragePanel(storageID)
	if IsNotNilAndNotFalse(storageID) then
		storageID = tonumber(storageID)
		if IsNotNilAndNotFalse(YRP_STORAGES[storageID]) then
			return YRP_STORAGES[storageID]
		else
			YRP.msg("note", "[GetStoragePanel] no panel with: " .. tostring(storageID))
		end
	else
		YRP.msg("note", "[GetStoragePanel] storageID is invalid: " .. tostring(storageID))
	end
end

function SetStoragePanel(storageID, pnl)
	if IsNotNilAndNotFalse(storageID) then
		storageID = tonumber(storageID)
		if not IsNotNilAndNotFalse(YRP_STORAGES[storageID]) then
			YRP_STORAGES[storageID] = pnl
		else
			YRP.msg("note", "[SetStoragePanel] there is already a storage with storageID: " .. tostring(storageID))
		end
	else
		YRP.msg("note", "[SetStoragePanel] storageID is invalid: " .. tostring(storageID))
	end
end

function RemoveStoragePanel(storageID, pnl)
	if IsNotNilAndNotFalse(YRP_STORAGES[storageID]) then
		YRP_STORAGES[storageID] = nil
	end
end

function PANEL:GetStorageID()
	return self._storageID
end

function PANEL:SetStorageID(storageID, slots)
	if IsNotNilAndNotFalse(storageID) then
		storageID = tonumber(storageID)
		if storageID ~= 0 then
			self._storageID = storageID
			SetStoragePanel(storageID, self)
			net.Start("nws_yrp_storage_get_slots")
			net.WriteString(self._storageID)
			net.SendToServer()
		else
			local c = 1
			local sp = (self:GetWide() - self:GetCols() * YRPItemSize()) / (self:GetCols() - 1)
			self:SetSpacing(sp)
			for y = 1, 32 do
				if slots[c] == nil then break end
				local line = YRPCreateD("DHorizontalScroller", nil, YRPItemSize(), YRPItemSize(), 0, 0)
				line:SetOverlap(-sp)
				self:AddItem(line)
				for x = 1, self:GetCols() do
					if slots[c] == nil then break end
					local s = slots[c]
					--if s.uniqueID then
					local slot = YRPCreateD("YSlot", nil, YRPItemSize(), YRPItemSize(), 0, 0)
					--slot:SetSlotID()
					line:AddPanel(slot)
					c = c + 1
					if YRPEntityAlive(s) then
						local i = YRPCreateD("YItem", nil, YRPItemSize(), YRPItemSize(), 0, 0)
						i:SetModel(s:GetModel())
						i:SetE(s)
						slot:AddItem(i)
					end
					--end
				end
			end
		end
	else
		YRP.msg("note", "[SetStorageID] storageID is invalid: " .. tostring(storageID))
	end
end

function PANEL:SetCols(cols)
	self._cols = cols
end

function PANEL:GetCols()
	return self._cols or 4
end

function PANEL:OnRemove()
	RemoveStoragePanel(self:GetStorageID(), self)
end

function PANEL:Init()
end

vgui.Register("YStorage", PANEL, "DPanelList")
-- Networking
net.Receive(
	"nws_yrp_storage_get_slots",
	function(len)
		local storageID = net.ReadString()
		local slots = net.ReadTable()
		storageID = tonumber(storageID)
		local storage = GetStoragePanel(storageID)
		BuildStorage(storage, slots)
	end
)

function BuildStorage(storage, slots)
	if YRPPanelAlive(storage, "storage") then
		local c = 1
		local sp = (storage:GetWide() - storage:GetCols() * YRPItemSize()) / (storage:GetCols() - 1)
		storage:SetSpacing(sp)
		for y = 1, 32 do
			if slots[c] == nil then break end
			local line = YRPCreateD("DHorizontalScroller", nil, YRPItemSize(), YRPItemSize(), 0, 0)
			line:SetOverlap(-sp)
			storage:AddItem(line)
			for x = 1, storage:GetCols() do
				if slots[c] == nil then break end
				local s = slots[c]
				local slot = YRPCreateD("YSlot", nil, YRPItemSize(), YRPItemSize(), 0, 0)
				slot:SetSlotID(s.uniqueID)
				line:AddPanel(slot)
				c = c + 1
			end
		end

		storage:EnableVerticalScrollbar()
		local ph = math.Round(c / 4)
		storage:SetTall(ph * YRPItemSize() + (ph - 1) * sp)
		storage:GetParent():SetTall(storage:GetTall() + YRP.ctr(50 + 20 + 20))
	else
		YRP.msg("note", "Storage is closed.")
	end
end

net.Receive(
	"yrpclosebag",
	function(len)
		local storID = net.ReadString()
		local storage = GetStoragePanel(storID)
		if IsNotNilAndNotFalse(storage) then
			storage:GetParent():Remove()
		end
	end
)
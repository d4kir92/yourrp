--Copyright (C) 2017-2021 D4KiR (https://www.gnu.org/licenses/gpl.txt)

local DATABASE_NAME = "yrp_inventory_slots"

SQL_ADD_COLUMN(DATABASE_NAME, "int_storageID", "INT DEFAULT 0")
SQL_ADD_COLUMN(DATABASE_NAME, "text_type", "TEXT DEFAULT 'item'")
--SQL_DROP_TABLE(DATABASE_NAME)



function CreateSlot(storageID, inv)
	storageID = tonumber(storageID)
	if wk(storageID) then
		if inv then
			SQL_INSERT_INTO(DATABASE_NAME, "int_storageID, text_type", "'" .. storageID .. "', '" .. "bag" .. "'")
		else
			SQL_INSERT_INTO(DATABASE_NAME, "int_storageID", "'" .. storageID .. "'")
		end
	else
		YRP.msg("db", "[CreateSlot] storageID is invalid")
	end
end

function GetStorageSlots(storageID)
	storageID = tonumber(storageID)
	if wk(storageID) then
		local slots = {}

		local yrp_slots = SQL_SELECT(DATABASE_NAME, "*", "int_storageID = '" .. storageID .. "'")
		if wk(yrp_slots) then
			slots = yrp_slots
		else
			YRP.msg("db", "[GetStorageSlots] there are no slots")
		end
		return slots
	else
		YRP.msg("db", "[GetStorageSlots] storageID invalid")
		return {}
	end
end



-- Connections
local YRP_SLOTS_PLYS = YRP_SLOTS_PLYS or {}
function GetPlayersFromSlot(slotID)
	slotID = tonumber(slotID)
	YRP_SLOTS_PLYS[slotID] = YRP_SLOTS_PLYS[slotID] or {}
	return YRP_SLOTS_PLYS[slotID]
end

function IsConnectedToSlot(ply, slotID)
	slotID = tonumber(slotID)
	YRP_SLOTS_PLYS[slotID] = YRP_SLOTS_PLYS[slotID] or {}
	return table.HasValue(YRP_SLOTS_PLYS[slotID], ply)
end

function ConnectToSlot(ply, slotID)
	slotID = tonumber(slotID)
	YRP_SLOTS_PLYS[slotID] = YRP_SLOTS_PLYS[slotID] or {}
	
	if !IsConnectedToSlot(ply, slotID) then
		--YRP.msg("db", ply:RPName() .. " connected to SLOT " .. slotID)
		table.insert(YRP_SLOTS_PLYS[slotID], ply)

		local item = GetItem(slotID)
		if wk(item) then
			StoreItem(slotID, GetItem(slotID), ply)
		end
	else
		YRP.msg("db", ply:RPName() .. " is already connected to SLOT " .. slotID)
	end
end

function DisconnectFromSlot(ply, slotID)
	slotID = tonumber(slotID)
	YRP_SLOTS_PLYS[slotID] = YRP_SLOTS_PLYS[slotID] or {}

	if IsConnectedToSlot(ply, slotID) then
		--YRP.msg("db", ply:RPName() .. " disconnected to SLOT " .. slotID)
		table.RemoveByValue(YRP_SLOTS_PLYS[slotID], ply)
	else
		YRP.msg("db", ply:RPName() .. " is not connected to SLOT " .. slotID)
	end
end



-- Networking
util.AddNetworkString("yrp_storage_get_slots")
net.Receive("yrp_storage_get_slots", function(len, ply)
	local storageID = net.ReadString()
	storageID = tonumber(storageID)

	local slots = GetStorageSlots(storageID)
	if wk(slots) then
		if slots[5] then
			local bp = slots[5]
		
			if wk(bp) and bp.uniqueID and !wk(GetItem(bp.uniqueID)) and table.Count(slots) == 5 then
				local tab = {}
				tab.text_classname = "bag"
				tab.text_printname = "bag"
				tab.text_worldmodel = "models/props_junk/garbage_takeoutcarton001a.mdl"
				tab.text_type = "bag"
				tab.int_fixed = "1"

				local storage = CreateStorage(16)
				if wk(storage) then
					tab.int_storageID = storage.uniqueID
					CreateItem(bp.uniqueID, tab)
				else
					YRP.msg("db", "Failed to create backpack")
				end
			end
		end
	
		net.Start("yrp_storage_get_slots")
			net.WriteString(storageID)
			net.WriteTable(slots)
		net.Send(ply)
	else
		YRP.msg("db", "yrp_storage_get_slots failed")
	end
end)

util.AddNetworkString("yrp_slot_connect")
net.Receive("yrp_slot_connect", function(len, ply)
	local slotID = net.ReadString()

	ConnectToSlot(ply, slotID)
end)

util.AddNetworkString("yrp_slot_disconnect")
net.Receive("yrp_slot_disconnect", function(len, ply)
	local slotID = net.ReadString()

	DisconnectFromSlot(ply, slotID)
end)
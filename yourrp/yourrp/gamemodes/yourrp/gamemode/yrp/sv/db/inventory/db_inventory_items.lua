--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
local DATABASE_NAME = "yrp_inventory_items"
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "int_slotID", "INT DEFAULT 0")
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "text_type", "TEXT DEFAULT 'item'")
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "int_fixed", "INT DEFAULT 0") -- Fixed = not moveable
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "int_storageID", "INT DEFAULT 0") -- storageID
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "text_printname", "TEXT DEFAULT 'Unnamed'")
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "text_classname", "TEXT DEFAULT 'yrp_money_printer'")
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "text_worldmodel", "TEXT DEFAULT 'models/props_junk/garbage_takeoutcarton001a.mdl'")
--YRP_SQL_ADD_COLUMN(DATABASE_NAME, "tab_properties", "TEXT DEFAULT ''" )
--YRP_SQL_DROP_TABLE(DATABASE_NAME)
function InventoryBlacklisted(cname)
	local blacklist = GetGlobalYRPTable("yrp_blacklist_inventory", {})
	for i, black in pairs(blacklist) do
		if string.find(cname, black.value, 1, true) then
			YRP:msg("note", "Blacklisted for inventory: " .. cname)

			return true
		end
	end

	return false
end

function CreateItem(slotID, tab)
	slotID = tonumber(slotID)
	tab = tab or {}
	if istable(tab) then
		tab.text_classname = tab.text_classname or "Unnamed"
		tab.text_printname = tab.text_printname or "yrp_money_printer"
		tab.text_worldmodel = tab.text_worldmodel or "models/props_junk/garbage_takeoutcarton001a.mdl"
		tab.text_classname = tab.text_classname
		tab.text_printname = tab.text_printname
		tab.text_worldmodel = tab.text_worldmodel
		tab.int_storageID = tab.int_storageID or 0
		tab.text_type = tab.text_type or "item"
		tab.int_fixed = tab.int_fixed or "0"
		if InventoryBlacklisted(tab.text_classname) or InventoryBlacklisted(tab.text_worldmodel) then
			YRP:msg("note", "[CreateItem] blacklisted item!")

			return false
		end

		YRP_SQL_INSERT_INTO(DATABASE_NAME, "int_slotID, text_classname, text_printname, text_worldmodel, int_storageID, text_type, int_fixed", "'" .. slotID .. "', '" .. tab.text_classname .. "', '" .. tab.text_printname .. "', '" .. tab.text_worldmodel .. "', '" .. tab.int_storageID .. "', '" .. tab.text_type .. "', '" .. tab.int_fixed .. "'")
	else
		YRP:msg("db", "[CreateItem] tab is wrong!")

		return false
	end

	local last = YRP_SQL_SELECT(DATABASE_NAME, "*", nil, "ORDER BY uniqueID DESC LIMIT 1")
	if IsNotNilAndNotFalse(last) then
		last = last[1]
		StoreItem(slotID, last)
	else
		YRP:msg("note", "[CreateItem] not worked")

		return false
	end

	return true
end

function CreateItemByEntity(slotID, entity)
	if entity == NULL then
		YRP:msg("db", "[CreateItemByEntity] ENTITY is NULL (not exists anymore)")

		return false
	end

	if entity:IsPlayer() or entity:IsWorld() or entity:CreatedByMap() or entity:GetOwner():IsPlayer() or strEmpty(entity:GetModel()) or entity:IsVehicle() then
		YRP:msg("db", "[CreateItemByEntity] INVALID")

		return false
	end

	local tab = {}
	tab.text_classname = entity:GetClass()
	tab.text_printname = entity:GetName()
	tab.text_worldmodel = entity:GetModel()
	tab.text_type = entity.text_type or "item"
	if tab.text_type == "bag" then
		tab.int_storageID = entity._suid
		if tab.int_storageID == nil then
			local storage = CreateStorage(entity.bag_size)
			if IsNotNilAndNotFalse(storage) then
				tab.int_storageID = storage.uniqueID

				return CreateItem(slotID, tab)
			else
				YRP:msg("db", "Failed to create backpack")

				return false
			end
		else
			return CreateItem(slotID, tab)
		end
	elseif tab.text_type ~= "chest" then
		return CreateItem(slotID, tab)
	end
end

function GetItem(slotID)
	local item = YRP_SQL_SELECT(DATABASE_NAME, "*", "int_slotID = '" .. slotID .. "'")
	if IsNotNilAndNotFalse(item) then
		item = item[1]
		if item.text_type == "bag" then
			local storage = YRP_SQL_SELECT("yrp_inventory_storages", "*", "uniqueID = '" .. item.int_storageID .. "'")
			if not IsNotNilAndNotFalse(storage) then
				YRP_SQL_DELETE_FROM(DATABASE_NAME, "uniqueID = '" .. item.uniqueID .. "'")

				return false
			end
		end

		return item
	end
	--YRP:msg( "db", "[GetItem] No item in " .. tostring(slotID) )

	return false
end

YRP:AddNetworkString("nws_yrp_item_unstore")
function UnstoreItem(slotID, ply)
	slotID = tonumber(slotID)
	if ply ~= nil then
		net.Start("nws_yrp_item_unstore")
		net.WriteString(slotID)
		net.Send(ply)
	else
		for i, p in pairs(GetPlayersFromSlot(slotID)) do
			net.Start("nws_yrp_item_unstore")
			net.WriteString(slotID)
			net.Send(p)
		end
	end
end

YRP:AddNetworkString("nws_yrp_item_store")
function StoreItem(slotID, itemTable, ply)
	slotID = tonumber(slotID)
	itemTable.isinv = false
	if ply then
		itemTable.int_slotID = tonumber(itemTable.int_slotID)
		local invstor = GetCharacterStorage(ply)
		local invslots = YRP_SQL_SELECT("yrp_inventory_slots", "*", "int_storageID = '" .. invstor.uniqueID .. "'")
		for i, v in pairs(invslots) do
			v.uniqueID = tonumber(v.uniqueID)
			if itemTable.int_slotID == v.uniqueID then
				itemTable.isinv = true
			end
		end
	end

	if istable(itemTable) then
		if ply ~= nil then
			net.Start("nws_yrp_item_store")
			net.WriteString(slotID)
			net.WriteTable(itemTable)
			net.Send(ply)
		else
			for i, p in pairs(GetPlayersFromSlot(slotID)) do
				net.Start("nws_yrp_item_store")
				net.WriteString(slotID)
				net.WriteTable(itemTable)
				net.Send(p)
			end
		end
	end
end

function RemoveItem(itemID)
	itemID = tonumber(itemID)
	YRP_SQL_DELETE_FROM(DATABASE_NAME, "uniqueID = '" .. itemID .. "'")
end

function DropItem(ply, slotID)
	slotID = tonumber(slotID)
	local item = GetItem(slotID)
	item.int_fixed = tonumber(item.int_fixed)
	if item.int_fixed == 1 then return end
	UnstoreItem(slotID)
	RemoveItem(item.uniqueID)
	local e = ents.Create(item.text_classname)
	if IsValid(e) then
		e:SetModel(item.text_worldmodel)
		if item.text_type == "bag" then
			e:SetStorage(item.int_storageID)
		end

		e:SetPos(ply:GetPos() + ply:GetForward() * 64)
		e:Spawn()
	else
		YRP:msg("note", item.text_classname .. " is not a valid classname")
	end
end

YRP:AddNetworkString("yrpclosebag")
function CloseBag(storID)
	net.Start("yrpclosebag")
	net.WriteString(storID)
	net.Broadcast()
end

function MoveItem(itemID, slotID)
	itemID = tonumber(itemID)
	slotID = tonumber(slotID)
	local item = YRP_SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '" .. itemID .. "'")
	local slot = YRP_SQL_SELECT("yrp_inventory_slots", "*", "uniqueID = '" .. slotID .. "'")
	-- if both exists
	if IsNotNilAndNotFalse(item) and IsNotNilAndNotFalse(slot) then
		item = item[1]
		slot = slot[1]
		slot.int_storageID = tonumber(slot.int_storageID)
		item.int_fixed = tonumber(item.int_fixed)
		item.int_storageID = tonumber(item.int_storageID)
		if item.int_fixed == 1 then
			YRP:msg("db", "[MoveItem] Item is fixed")

			return
		end

		if slot.text_type == "bag" and item.text_type ~= "bag" then
			YRP:msg("db", "[MoveItem] Only Bags are allowed here")

			return
		end

		if slot.int_storageID == item.int_storageID then
			YRP:msg("db", "You cant put bag into bag (self)")

			return
		end

		if item.text_type == "bag" then
			for i, slot2 in pairs(GetStorageSlots(item.int_storageID)) do
				local ite = YRP_SQL_SELECT(DATABASE_NAME, "*", "int_slotID = '" .. slot2.uniqueID .. "'")
				if IsNotNilAndNotFalse(ite) then
					YRP:msg("db", "Bag is not empty")

					return
				end
			end
		end

		local oldslot = item.int_slotID
		local newslot = slot.uniqueID
		-- when no item in target
		if not GetItem(slotID) then
			if item.text_type == "bag" then
				CloseBag(item.int_storageID)
			end

			YRP_SQL_UPDATE(
				DATABASE_NAME,
				{
					["int_slotID"] = newslot
				}, "uniqueID = '" .. item.uniqueID .. "'"
			)

			UnstoreItem(oldslot)
			StoreItem(newslot, item)
		else
			YRP:msg("db", "Cant move")
		end
	else
		local e = net.ReadEntity()
		local added = CreateItemByEntity(slotID, e)
		if IsNotNilAndNotFalse(e) and added then
			e:Remove()
		else
			YRP:msg("db", "Item or Slot not exists")
		end
	end
end

-- Networking
YRP:AddNetworkString("nws_yrp_item_clicked")
net.Receive(
	"nws_yrp_item_clicked",
	function(len, ply)
		local itemID = net.ReadString()
		itemID = tonumber(itemID)
		local item = YRP_SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '" .. itemID .. "'")
		if IsNotNilAndNotFalse(item) then
			item = item[1]
			item.int_storageID = tonumber(item.int_storageID)
			if item.int_storageID ~= 0 then
				OpenStorage(ply, item.int_storageID)
			else
				YRP:msg("db", "[yrp_item_clicked] item is not a storage")
			end
		else
			YRP:msg("db", "[yrp_item_clicked] item not exists")
		end
	end
)

YRP:AddNetworkString("nws_yrp_item_move")
net.Receive(
	"nws_yrp_item_move",
	function(len, ply)
		local itemID = net.ReadString()
		local slotID = net.ReadString()
		itemID = tonumber(itemID)
		slotID = tonumber(slotID)
		MoveItem(itemID, slotID)
	end
)

YRP:AddNetworkString("nws_yrp_item_drop")
net.Receive(
	"nws_yrp_item_drop",
	function(len, ply)
		local itemID = net.ReadString()
		itemID = tonumber(itemID)
		local item = YRP_SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '" .. itemID .. "'")
		if IsNotNilAndNotFalse(item) then
			item = item[1]
			DropItem(ply, item.int_slotID)
		end
	end
)

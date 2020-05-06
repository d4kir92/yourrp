--Copyright (C) 2017-2020 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

local DATABASE_NAME = "yrp_inventory_items"

SQL.ADD_COLUMN(DATABASE_NAME, "int_slotID", "INT DEFAULT 0")

SQL.ADD_COLUMN(DATABASE_NAME, "text_type", "TEXT DEFAULT 'item'")

SQL.ADD_COLUMN(DATABASE_NAME, "int_fixed", "INT DEFAULT 0")		-- Fixed = not moveable

SQL.ADD_COLUMN(DATABASE_NAME, "int_storageID", "INT DEFAULT 0")		-- storageID

SQL.ADD_COLUMN(DATABASE_NAME, "text_printname", "TEXT DEFAULT 'Unnamed'")
SQL.ADD_COLUMN(DATABASE_NAME, "text_classname", "TEXT DEFAULT 'yrp_money_printer'")
SQL.ADD_COLUMN(DATABASE_NAME, "text_worldmodel", "TEXT DEFAULT 'models/props_junk/garbage_takeoutcarton001a.mdl'")
--SQL.ADD_COLUMN(DATABASE_NAME, "tab_properties", "TEXT DEFAULT ''")

--SQL_DROP_TABLE(DATABASE_NAME)



function InventoryBlacklisted(cname)
	local blacklist = GetGlobalDTable("yrp_blacklist_inventory", {})
	
	for i, black in pairs(blacklist) do
		if string.find(cname, black.value) then
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

		tab.text_classname = SQL_STR_IN(tab.text_classname)
		tab.text_printname = SQL_STR_IN(tab.text_printname)
		tab.text_worldmodel = SQL_STR_IN(tab.text_worldmodel)

		tab.int_storageID = tab.int_storageID or 0
		tab.text_type = tab.text_type or "item"
		tab.int_fixed = tab.int_fixed or "0"
		
		if InventoryBlacklisted(tab.text_classname) then
			YRP.msg("note", "[CreateItem] blacklisted item! " .. tab.text_classname)
			return false
		end
	
		SQL_INSERT_INTO(
			DATABASE_NAME,
			"int_slotID, text_classname, text_printname, text_worldmodel, int_storageID, text_type, int_fixed",
			"'" .. slotID .. "', '" .. tab.text_classname .. "', '" .. tab.text_printname .. "', '" .. tab.text_worldmodel .. "', '" .. tab.int_storageID .. "', '" .. tab.text_type .. "', '" .. tab.int_fixed .. "'"
		)
	else
		YRP.msg("db", "[CreateItem] tab is wrong!")
		return false
	end

	local last = {}
	last.table = DATABASE_NAME
	last.cols = {}
	last.cols[1] = "*"
	last.manual = "ORDER BY uniqueID DESC LIMIT 1"
	last = SQL.SELECT(last)
	if wk(last) then
		last = last[1]
		StoreItem(slotID, last)
	else
		YRP.msg("note", "[CreateItem] not worked")
		return false
	end
	return true
end

function CreateItemByEntity(slotID, entity)
	if entity:IsPlayer() or entity:IsWorld() or entity:CreatedByMap() or entity:GetOwner():IsPlayer() or strEmpty(entity:GetModel()) or entity:IsVehicle() then
		YRP.msg("db", "[CreateItemByEntity] INVALID")
		return false
	end

	local tab = {}
	tab.text_classname = SQL_STR_IN(entity:GetClass())
	tab.text_printname = SQL_STR_IN(entity:GetName())
	tab.text_worldmodel = SQL_STR_IN(entity:GetModel())
	tab.text_type = entity.text_type or "item"

	if tab.text_type == "bag" then
		tab.int_storageID = entity._suid
		if tab.int_storageID == nil then
			local storage = CreateStorage(entity.bag_size)
			if wk(storage) then
				tab.int_storageID = storage.uniqueID
				return CreateItem(slotID, tab)
			else
				YRP.msg("db", "Failed to create backpack")
				return false
			end
		else
			return CreateItem(slotID, tab)
		end
	elseif tab.text_type != "chest" then
		return CreateItem(slotID, tab)
	end
end

function GetItem(slotID)
	local item = SQL_SELECT(DATABASE_NAME, "*", "int_slotID = '" .. slotID .. "'")
	if wk(item) then
		return item[1]
	end
	--YRP.msg("db", "[GetItem] No item in " .. tostring(slotID))
	return false
end

util.AddNetworkString("yrp_item_unstore")
function UnstoreItem(slotID, ply)
	slotID = tonumber(slotID)

	if ply != nil then
		net.Start("yrp_item_unstore")
			net.WriteString(slotID)
		net.Send(ply)
	else
		for i, p in pairs(GetPlayersFromSlot(slotID)) do
			net.Start("yrp_item_unstore")
				net.WriteString(slotID)
			net.Send(p)
		end
	end
end	

util.AddNetworkString("yrp_item_store")
function StoreItem(slotID, itemTable, ply)
	slotID = tonumber(slotID)

	itemTable.isinv = false
	if ply then
		itemTable.int_slotID = tonumber(itemTable.int_slotID)
		local invstor = GetCharacterStorage(ply)
		local invslots = SQL_SELECT("yrp_inventory_slots", "*", "int_storageID = '" .. invstor.uniqueID .. "'")
		for i, v in pairs(invslots) do
			v.uniqueID = tonumber(v.uniqueID)
			if itemTable.int_slotID == v.uniqueID then
				itemTable.isinv = true
			end
		end
	end

	if istable(itemTable) then
		if ply != nil then
			net.Start("yrp_item_store")
				net.WriteString(slotID)
				net.WriteTable(itemTable)
			net.Send(ply)
		else
			for i, p in pairs(GetPlayersFromSlot(slotID)) do
				net.Start("yrp_item_store")
					net.WriteString(slotID)
					net.WriteTable(itemTable)
				net.Send(p)
			end
		end
	end
end

function RemoveItem(itemID)
	itemID = tonumber(itemID)

	SQL_DELETE_FROM(DATABASE_NAME, "uniqueID = '" .. itemID .. "'")
end

function DropItem(ply, slotID)
	slotID = tonumber(slotID)

	local item = GetItem(slotID)

	item.int_fixed = tonumber(item.int_fixed)
	if item.int_fixed == 1 then
		return
	end

	UnstoreItem(slotID)

	RemoveItem(item.uniqueID)

	local e = ents.Create(SQL_STR_OUT(item.text_classname))
	e:SetModel(SQL_STR_OUT(item.text_worldmodel))
	local pos = ply:GetPos() + ply:GetForward() * 64
	local mins = e:OBBMins()
	local maxs = e:OBBMaxs()

	if item.text_type == "bag" then
		e:SetStorage(item.int_storageID)
	end

	e:SetPos(ply:GetPos() + ply:GetForward() * 64)
	e:Spawn()
end	



function MoveItem(itemID, slotID)
	itemID = tonumber(itemID)
	slotID = tonumber(slotID)

	local item = SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '" .. itemID .. "'")

	local slot = SQL_SELECT("yrp_inventory_slots", "*", "uniqueID = '" .. slotID .. "'")

	if wk(item) and wk(slot) then -- if both exists
		item = item[1]
		slot = slot[1]

		slot.int_storageID = tonumber(slot.int_storageID )
		item.int_fixed = tonumber(item.int_fixed)
		item.int_storageID = tonumber(item.int_storageID)

		if item.int_fixed == 1 then
			YRP.msg("db", "[MoveItem] Item is fixed")
			return
		end
	
		if slot.text_type == "bag" and item.text_type != "bag" then
			YRP.msg("db", "[MoveItem] Only Bags are allowed here")
			return
		end

		if slot.int_storageID == item.int_storageID then
			YRP.msg("db", "You cant put bag into bag (self)")
			return
		end
	
		local oldslot = item.int_slotID
		local newslot = slot.uniqueID

		if !GetItem(slotID) then -- when no item in target

			SQL_UPDATE(DATABASE_NAME, "int_slotID = '" .. newslot .. "'", "uniqueID = '" .. item.uniqueID .. "'")

			UnstoreItem(oldslot)
			StoreItem(newslot, item)
		else
			YRP.msg("db", "Cant move")
		end
	else
		local e = net.ReadEntity()

		local added = CreateItemByEntity(slotID, e)

		if wk(e) and added then
			e:Remove()
		else
			YRP.msg("db", "Item or Slot not exists")
		end
	end
end



-- Networking
util.AddNetworkString("yrp_item_clicked")
net.Receive("yrp_item_clicked", function(len, ply)
	local itemID = net.ReadString()

	itemID = tonumber(itemID)

	local item = SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '" .. itemID .. "'")

	if wk(item) then
		item = item[1]

		item.int_storageID = tonumber(item.int_storageID)

		if item.int_storageID != 0 then
			OpenStorage(ply, item.int_storageID)
		else
			YRP.msg("db", "[yrp_item_clicked] item is not a storage")
		end
	else
		YRP.msg("db", "[yrp_item_clicked] item not exists")
	end
end)

util.AddNetworkString("yrp_item_move")
net.Receive("yrp_item_move", function(len, ply)
	local itemID = net.ReadString()
	local slotID = net.ReadString()

	itemID = tonumber(itemID)
	slotID = tonumber(slotID)

	MoveItem(itemID, slotID)
end)

util.AddNetworkString("yrp_item_drop")
net.Receive("yrp_item_drop", function(len, ply)
	local itemID = net.ReadString()

	itemID = tonumber(itemID)

	local item = SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '" .. itemID .. "'")
	if wk(item) then
		item = item[1]
		DropItem(ply, item.int_slotID)
	end
end)

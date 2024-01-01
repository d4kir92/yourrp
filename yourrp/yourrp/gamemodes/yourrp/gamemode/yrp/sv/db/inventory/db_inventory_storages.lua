--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
local DATABASE_NAME = "yrp_inventory_storages"
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "int_storage_size", "INT DEFAULT 1")
--YRP_SQL_DROP_TABLE(DATABASE_NAME)
function CreateStorage(size, inv)
	if not IsNotNilAndNotFalse(size) then return end
	local result = YRP_SQL_INSERT_INTO(DATABASE_NAME, "int_storage_size", "'" .. size .. "'")
	if result == nil then
		YRP.msg("db", "Created Storage")
		local last = YRP_SQL_SELECT(DATABASE_NAME, "*", nil, "ORDER BY uniqueID DESC LIMIT 1")
		if IsNotNilAndNotFalse(last) then
			last = last[1]
			for i = 1, size do
				CreateSlot(last.uniqueID, inv)
			end

			return last
		else
			YRP.msg("note", "Failed to get last storage: " .. tostring(last))
		end
	else
		YRP.msg("note", "Failed to create storage: " .. tostring(result))
	end
end

function GetCharacterStorage(ply, retry)
	retry = retry or false
	local chaTab = ply:YRPGetCharacterTable()
	if IsNotNilAndNotFalse(chaTab) then
		local storage = YRP_SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '" .. chaTab.int_storageID .. "'")
		if IsNotNilAndNotFalse(storage) then
			storage = storage[1]

			return storage
		else
			if retry == false then
				retry = true
				YRPCreateCharacterStorages(true)

				return GetCharacterStorage(ply, retry)
			else
				ply:PrintMessage(HUD_PRINTCENTER, "No Storage for this Character (Inventory)")
				YRP.msg("note", "[GetCharacterStorage] (Inventory) no storage")
			end
		end
	end

	ply:PrintMessage(HUD_PRINTCENTER, "Failed to Get Storage for this Character (Inventory)")
	YRP.msg("note", "[GetCharacterStorage] (Inventory) FAILED!")

	return {}
end

function YRPCreateCharacterStorages(retry)
	if retry then
		YRP.msg("note", "[CreateCharacterStorages] (Inventory) RETRY!")
	end

	local chars = YRP_SQL_SELECT("yrp_characters", "*", nil)
	if IsNotNilAndNotFalse(chars) then
		for _, char in pairs(chars) do
			-- Remove wrong ones
			if isnumber(tonumber(char.int_storageID)) then
				local tab = YRP_SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '" .. char.int_storageID .. "'")
				if IsNotNilAndNotFalse(tab) then
					tab = tab[1]
					local slots = YRP_SQL_SELECT("yrp_inventory_slots", "*", "int_storageID = '" .. tab.uniqueID .. "'")
					if IsNotNilAndNotFalse(slots) and (#slots < 5 or #slots > 5) then
						YRP_SQL_DELETE_FROM(DATABASE_NAME, "uniqueID = '" .. char.int_storageID .. "'")
						YRP_SQL_DELETE_FROM("yrp_inventory_slots", "int_storageID = '" .. tab.uniqueID .. "'")
						YRP_SQL_UPDATE(
							"yrp_characters",
							{
								["int_storageID"] = 0
							}, "uniqueID = '" .. char.uniqueID .. "'"
						)
					end
				end
			end

			-- Create storage if not exists
			if strEmpty(char.int_storageID) or tonumber(char.int_storageID) == 0 then
				YRP.msg("db", "YRPCreateCharacterStorages empty or 0")
				local bagsStorage = CreateStorage(5, true)
				if IsNotNilAndNotFalse(bagsStorage) then
					YRP_SQL_UPDATE(
						"yrp_characters",
						{
							["int_storageID"] = bagsStorage.uniqueID
						}, "uniqueID = '" .. char.uniqueID .. "'"
					)
				end
			elseif not IsNotNilAndNotFalse(YRP_SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '" .. char.int_storageID .. "'")) then
				YRP.msg("db", "YRPCreateCharacterStorages WRONG")
				local bagsStorage = CreateStorage(5, true)
				if IsNotNilAndNotFalse(bagsStorage) then
					YRP_SQL_UPDATE(
						"yrp_characters",
						{
							["int_storageID"] = bagsStorage.uniqueID
						}, "uniqueID = '" .. char.uniqueID .. "'"
					)
				end
			end
		end
	end
end

timer.Simple(
	3,
	function()
		YRPCreateCharacterStorages(false)
	end
)

-- Networking
util.AddNetworkString("nws_yrp_get_inventory")
net.Receive(
	"nws_yrp_get_inventory",
	function(len, ply)
		local storage = GetCharacterStorage(ply)
		if IsNotNilAndNotFalse(storage) and storage.uniqueID ~= nil then
			local nettab = {}
			local es = ents.FindInSphere(ply:GetPos(), 100)
			for i, ent in pairs(es) do
				if not ent:IsPlayer() and not ent:IsWorld() and not ent:IsRagdoll() and not ent:IsNPC() and not ent.PermaProps and not ent:CreatedByMap() and not ent:GetOwner():IsPlayer() and not strEmpty(ent:GetModel()) and ent:GetModel() ~= "models/error.mdl" and not ent:IsVehicle() then
					ent.text_type = ent.text_type or "item"
					if not InventoryBlacklisted(ent:GetClass()) and not InventoryBlacklisted(ent:GetModel()) and ent.text_type ~= "chest" then
						table.insert(nettab, ent)
					end
				end
			end

			net.Start("nws_yrp_get_inventory")
			net.WriteString(storage.uniqueID)
			net.WriteTable(nettab)
			net.Send(ply)
		else
			ply:PrintMessage(HUD_PRINTCENTER, "Failed to Get Storage-Info for this Character (Inventory)")
			YRP.msg("note", "[get_inventory] No GetCharacterStorage")
		end
	end
)

util.AddNetworkString("nws_yrp_storage_open")
function OpenStorage(ply, storageID)
	storageID = tonumber(storageID)
	local storage = YRP_SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '" .. storageID .. "'")
	if IsNotNilAndNotFalse(storage) then
		storage = storage[1]
		local isinv = false
		local item = YRP_SQL_SELECT("yrp_inventory_items", "*", "int_storageID = '" .. storage.uniqueID .. "'")
		if IsNotNilAndNotFalse(item) then
			item = item[1]
			item.int_slotID = tonumber(item.int_slotID)
			local invstor = GetCharacterStorage(ply)
			local invslots = YRP_SQL_SELECT("yrp_inventory_slots", "*", "int_storageID = '" .. invstor.uniqueID .. "'")
			for i, v in pairs(invslots) do
				v.uniqueID = tonumber(v.uniqueID)
				if item.int_slotID == v.uniqueID then
					isinv = true
				end
			end
		end

		net.Start("nws_yrp_storage_open")
		net.WriteTable(storage)
		net.WriteBool(isinv)
		net.Send(ply)
	else
		YRP.msg("db", "[yrp_storage_open] Storage not exists.")
	end
end
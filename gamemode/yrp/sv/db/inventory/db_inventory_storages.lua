--Copyright (C) 2017-2020 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

local DATABASE_NAME = "yrp_inventory_storages"

SQL.ADD_COLUMN(DATABASE_NAME, "int_storage_size", "INT DEFAULT 1")

--SQL_DROP_TABLE(DATABASE_NAME)



function CreateStorage(size, inv)
	local result = SQL_INSERT_INTO(DATABASE_NAME, "int_storage_size", "'" .. size .. "'")

	if result == nil then
		YRP.msg("db", "Created Storage")

		local last = {}
		last.table = DATABASE_NAME
		last.cols = {}
		last.cols[1] = "*"
		last.manual = "ORDER BY uniqueID DESC LIMIT 1"
		last = SQL.SELECT(last)
		if wk(last) then
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

function GetCharacterStorage(ply)
	local chaTab = ply:GetChaTab()
	if wk(chaTab) then
		local storage = SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '" .. chaTab.int_storageID .. "'")
		if wk(storage) then
			storage = storage[1]
			return storage
		else
			YRP.msg("db", "[GetCharacterStorage] no storage")
		end
	end
	YRP.msg("db", "[GetCharacterStorage] FAILED")
	return {}
end

function CreateCharacterStorages()
	local chars = SQL_SELECT("yrp_characters", "*", nil)
	if wk(chars) then
		for _, char in pairs(chars) do
			if strEmpty(char.int_storageID) or tonumber(char.int_storageID) == 0 then
				YRP.msg("db", "CreateCharacterStorages empty or 0")
				local bagsStorage = CreateStorage(5, true)
				if wk(bagsStorage) then
					SQL_UPDATE("yrp_characters", "int_storageID = '" .. bagsStorage.uniqueID .. "'", "uniqueID = '" .. char.uniqueID .. "'")
				end
			elseif !wk(SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '" .. char.int_storageID .. "'")) then
				YRP.msg("db", "CreateCharacterStorages WRONG")
				local bagsStorage = CreateStorage(5, true)
				if wk(bagsStorage) then
					SQL_UPDATE("yrp_characters", "int_storageID = '" .. bagsStorage.uniqueID .. "'", "uniqueID = '" .. char.uniqueID .. "'")
				end
			end
		end
	end
end
timer.Simple(4, function()
	CreateCharacterStorages()
end)



-- Networking
util.AddNetworkString("get_inventory")
net.Receive("get_inventory", function(len, ply)
	local storage = GetCharacterStorage(ply)

	local nettab = {}
	local es = ents.FindInSphere(ply:GetPos(), 100)
	for i, ent in pairs(es) do
		if !ent:IsPlayer() and !ent:IsWorld() and !ent:CreatedByMap() and !ent:GetOwner():IsPlayer() and !strEmpty(ent:GetModel()) and ent:GetModel() != "models/error.mdl" and !ent:IsVehicle() then
			table.insert(nettab, ent)
		end
	end

	net.Start("get_inventory")
		net.WriteString(storage.uniqueID)
		net.WriteTable(nettab)
	net.Send(ply)
end)

util.AddNetworkString("yrp_storage_open")
function OpenStorage(ply, storageID)
	storageID = tonumber(storageID)

	local storage = SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '" .. storageID .. "'")

	if wk(storage) then
		storage = storage[1]

		local isinv = false
		local item = SQL_SELECT("yrp_inventory_items", "*", "int_storageID = '" .. storage.uniqueID .. "'")
		if wk(item) then
			item = item[1]

			item.int_slotID = tonumber(item.int_slotID)
			local invstor = GetCharacterStorage(ply)
			local invslots = SQL_SELECT("yrp_inventory_slots", "*", "int_storageID = '" .. invstor.uniqueID .. "'")
			for i, v in pairs(invslots) do
				v.uniqueID = tonumber(v.uniqueID)
				if item.int_slotID == v.uniqueID then
					isinv = true
				end
			end
		end

		net.Start("yrp_storage_open")
			net.WriteTable(storage)
			net.WriteBool(isinv)
		net.Send(ply)
	else
		YRP.msg("db", "[yrp_storage_open] Storage not exists.")
	end
end
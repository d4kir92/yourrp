--Copyright (C) 2017-2019 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

local DATABASE_NAME = "yrp_i_storages"

SQL = SQL or {}

SQL.ADD_COLUMN(DATABASE_NAME, "text_name", "INT DEFAULT 'Unnamed'")
SQL.ADD_COLUMN(DATABASE_NAME, "int_size", "INT DEFAULT 1")
SQL.ADD_COLUMN(DATABASE_NAME, "text_character", "TEXT DEFAULT '0'")
SQL.ADD_COLUMN(DATABASE_NAME, "text_slotname", "TEXT DEFAULT '-'")

--SQL_DROP_TABLE(DATABASE_NAME)

function LoadSlot(cuid, SName)
	local stortab = {}
	stortab.table = DATABASE_NAME
	stortab.cols = {}
	stortab.cols[1] = "*"
	stortab.where = "text_character = '" .. cuid .. "' AND text_slotname = '" .. SName .. "'"
	local stor = SQL.SELECT(stortab)
	if wk(stor) then
		stor = stor[1]
	else
		local instab = {}
		instab.table = DATABASE_NAME
		instab.cols = {}
		instab.cols["text_character"] = cuid
		instab.cols["text_slotname"] = SName

		local result = SQL.INSERT_INTO(instab)
		if result == nil then
			return LoadSlot(cuid, SName)
		end
	end
	return stor or {}
end

SLOTS = SLOTS or {}
function GetSlotClients(CharID, SName)
	SLOTS[CharID] = SLOTS[CharID] or {}
	SLOTS[CharID][SName] = SLOTS[CharID][SName] or {}
	return SLOTS[CharID][SName]
end

util.AddNetworkString("send_slot_content")
function SendSlotContent(ply, CharID, SName)
	--print("SendSlotContent", ply, CharID, SName)
	local storage = LoadSlot(CharID, SName) -- Create / Get Storage
	local items = LoadSlotItems(storage.uniqueID)
	if SName == "bag0" and table.Count(items) <= 0 then
		CreateBag("yrp_mainbag", storage.uniqueID)
		items = LoadSlotItems(storage.uniqueID)
	end
	net.Start("send_slot_content")
		net.WriteString(SName)
		net.WriteTable(items)
	net.Send(ply)
end

function JoinSlot(ply, CharID, SName)
	if !table.HasValue(GetSlotClients(CharID, SName), ply) then
		table.insert(GetSlotClients(CharID, SName), ply)
		YRP.msg("note", "[" .. ply:RPName() .. "] joined slot: " .. SName .. " (CharID: " .. CharID .. ")")
		SendSlotContent(ply, CharID, SName)
	end
end

util.AddNetworkString("join_slot")
net.Receive("join_slot", function(len, ply)
	local CharID = ply:CharID()
	local SName = net.ReadString()
	JoinSlot(ply, CharID, SName)
end)

function LeaveSlot(ply, CharID, SName)
	if table.HasValue(GetSlotClients(CharID, SName), ply) then
		table.RemoveByValue(GetSlotClients(CharID, SName), ply)
		YRP.msg("note", "[" .. ply:RPName() .. "] leaved slot: " .. SName .. " (CharID: " .. CharID .. ")")
	end
end

util.AddNetworkString("leave_slot")
net.Receive("leave_slot", function(len, ply)
	local CharID = ply:CharID()
	local SName = net.ReadString()
	LeaveSlot(ply, CharID, SName)
end)

util.AddNetworkString("open_slot")
net.Receive("open_slot", function(len, ply)
	local CharID = ply:CharID()
	local suid = net.ReadString()
	local stortab = {}
	stortab.table = DATABASE_NAME
	stortab.cols = {}
	stortab.cols[1] = "*"
	stortab.where = "text_character = '" .. CharID .. "' AND uniqueID = '" .. suid .. "'"
	local stor = SQL.SELECT(stortab)
	if wk(stor) then
		stor = stor[1]
	end

	net.Start("open_slot")
		net.WriteTable(stor)
	net.Send(ply)
end)


-- STORAGE
function CreateStorage(tab)
	tab.text_character = tab.text_character or 0
	tab.int_size = tonumber(tab.int_size)

	--[[
	SQL.ADD_COLUMN(DATABASE_NAME, "text_name", "INT DEFAULT 'Unnamed'")
	SQL.ADD_COLUMN(DATABASE_NAME, "int_size", "INT DEFAULT 1")
	SQL.ADD_COLUMN(DATABASE_NAME, "text_character", "TEXT DEFAULT '0'")
	SQL.ADD_COLUMN(DATABASE_NAME, "text_slotname", "TEXT DEFAULT '-'")
	]]

	local instab = {}
	instab.table = DATABASE_NAME
	instab.cols = {}
	instab.cols["text_character"] = tab.text_character
	instab.cols["int_size"] = tab.int_size

	SQL.INSERT_INTO(instab)

	local lastentry = {}
	lastentry.table = DATABASE_NAME
	lastentry.cols = {}
	lastentry.cols[1] = "*"
	lastentry.manual = "ORDER BY uniqueID DESC LIMIT 1"
	local laststor = SQL.SELECT(lastentry)
	if wk(laststor) then
		laststor = laststor[1]
	end

	return laststor
end

function LoadStorage(suid)
	suid = tonumber(suid)
	local stortab = {}
	stortab.table = DATABASE_NAME
	stortab.cols = {}
	stortab.cols[1] = "*"
	stortab.where = "uniqueID = '" .. suid .. "'"
	local stor = SQL.SELECT(stortab)
	--print(stor)
	if wk(stor) then
		stor = stor[1]
	end
	return stor or {}
end

STORAGES = STORAGES or {}
function GetStorageClients(suid)
	STORAGES[suid] = STORAGES[suid] or {}
	return STORAGES[suid]
end

util.AddNetworkString("send_storage_content")
function SendStorageContent(ply, suid)
	--print("SendStorageContent", ply, suid)
	local storage = LoadStorage(suid) -- Create / Get Storage

	local items = LoadStorageItems(storage.uniqueID)
	net.Start("send_storage_content")
		net.WriteString(suid)
		net.WriteTable(storage)
		net.WriteTable(items)
	net.Send(ply)
end

function JoinStorage(ply, suid)
	if !table.HasValue(GetStorageClients(suid), ply) then
		table.insert(GetStorageClients(suid), ply)
		YRP.msg("note", "[" .. ply:RPName() .. "] joined storage: " .. suid)
		SendStorageContent(ply, suid)
	end
end

util.AddNetworkString("join_storage")
net.Receive("join_storage", function(len, ply)
	local suid = net.ReadString()
	JoinStorage(ply, suid)
end)

function LeaveStorage(ply, suid)
	if table.HasValue(GetStorageClients(suid), ply) then
		table.RemoveByValue(GetStorageClients(suid), ply)
		YRP.msg("note", "[" .. ply:RPName() .. "] leaved storage: " .. suid)
	end
end

util.AddNetworkString("leave_storage")
net.Receive("leave_storage", function(len, ply)
	local suid = net.ReadString()
	LeaveStorage(ply, suid)
end)

util.AddNetworkString("open_storage")
net.Receive("open_storage", function(len, ply)
	local suid = net.ReadString()
	local stortab = {}
	stortab.table = DATABASE_NAME
	stortab.cols = {}
	stortab.cols[1] = "*"
	stortab.where = "uniqueID = '" .. suid .. "'"
	local stor = SQL.SELECT(stortab)
	if wk(stor) then
		stor = stor[1]
	end

	net.Start("open_storage")
		net.WriteTable(stor)
	net.Send(ply)
end)

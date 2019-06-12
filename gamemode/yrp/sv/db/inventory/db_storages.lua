--Copyright (C) 2017-2019 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

local DATABASE_NAME = "yrp_inv_storages"

SQL = SQL or {}

SQL.ADD_COLUMN(DATABASE_NAME, "text_name", "INT DEFAULT 'Unnamed'")
SQL.ADD_COLUMN(DATABASE_NAME, "int_size", "INT DEFAULT 1")
SQL.ADD_COLUMN(DATABASE_NAME, "text_steamid", "TEXT DEFAULT ''")

local BP = {}
BP.int_size = 16

local Player = FindMetaTable("Player")

local STO = {}
function Player:JoinStorage(uid)
	STO[uid] = STO[uid] or {}
	if !table.HasValue(STO[uid], self) then
		table.insert(STO[uid], self)
	end

	local tab = {}
	tab.table = DATABASE_NAME
	tab.cols = {}
	tab.cols[1] = "*"
	tab.where = "uniqueID = '" .. uid .. "'"

	local storage = SQL.SELECT(tab)

	if wk(storage) then
		YRP.msg("db", "Storage exists")
		storage = storage[1]
		net.Start("yrp_join_storage")
			net.WriteTable(storage)
		net.Send(self)
	else
		YRP.msg("note", "Storage not exists!")
		local newstorage = {}
		newstorage.table = "yrp_inv_storages"
		newstorage.cols = {}
		newstorage.cols["text_name"] = self:Nick()
		newstorage.cols["int_size"] = 31
		newstorage.cols["text_steamid"] = self:SteamID()
		newstorage.cols["uniqueID"] = uid
		SQL.INSERT_INTO(newstorage)

		self:JoinStorage(uid)
	end
end

function Player:LeaveStorage(uid)
	STO[uid] = STO[uid] or {}
	if table.HasValue(STO[uid], self) then
		table.RemoveByValue(STO[uid], self)
	end
end

util.AddNetworkString("yrp_join_storage")
net.Receive("yrp_join_storage", function(len, ply)
	local uid = tonumber(net.ReadString())
	ply:JoinStorage(uid)
end)

util.AddNetworkString("yrp_leave_storage")
net.Receive("yrp_leave_storage", function(len, ply)
	local uid = tonumber(net.ReadString())
	ply:LeaveStorage(uid)
end)

function Player:GetBackpack()
	local tab = {}
	tab.table = DATABASE_NAME
	tab.cols = {}
	tab.cols[1] = "*"
	tab.where = "text_steamid = '" .. self:SteamID() .. "'"

	local bp = SQL.SELECT(tab)
	if wk(bp) then
		--YRP.msg("db", "Backpack exists")
		bp = bp[1]
		return bp
	else
		--YRP.msg("db", "Backpack not exists")

		local newbp = {}
		newbp.table = DATABASE_NAME
		newbp.cols = {}
		newbp.cols["text_name"] = self:Nick()
		newbp.cols["int_size"] = BP.int_size
		newbp.cols["text_steamid"] = self:SteamID()

		SQL.INSERT_INTO(newbp)

		return self:GetBackpack()
	end
end

util.AddNetworkString("get_inventory")
net.Receive("get_inventory", function(len, ply)
	net.Start("get_inventory")
		net.WriteTable(ply:GetBackpack())
	net.Send(ply)
end)

-- ADD ITEM
util.AddNetworkString("yrp_place_item")
function PlaceItem(suid, iuid)
	local tab = {}
	tab.table = "yrp_inv_items"
	tab.cols = {}
	tab.cols[1] = "*"
	tab.where = "uniqueID = '" .. iuid .. "'"
	local item = SQL.SELECT(tab)
	if wk(item) then
		item = item[1]
		STO[suid] = STO[suid] or {}
		for i, p in pairs(STO[suid]) do
			net.Start("yrp_place_item")
				net.WriteTable(item)
			net.Send(p)
		end
	end
end

-- REM ITEM
util.AddNetworkString("yrp_misplace_item")
function MisplaceItem(suid, iuid)
	local tab = {}
	tab.table = "yrp_inv_items"
	tab.cols = {}
	tab.cols[1] = "*"
	tab.where = "uniqueID = '" .. iuid .. "'"
	local item = SQL.SELECT(tab)
	if wk(item) then
		item = item[1]
		STO[suid] = STO[suid] or {}
		for i, p in pairs(STO[suid]) do
			net.Start("yrp_misplace_item")
				net.WriteTable(item)
			net.Send(p)
		end
	end
end

-- GET ITEMS
util.AddNetworkString("yrp_get_items")
net.Receive("yrp_get_items", function(len, ply)
	local suid = tonumber(net.ReadString())

	local tab = {}
	tab.table = "yrp_inv_items"
	tab.cols = {}
	tab.cols[1] = "*"
	tab.where = "int_storage = '" .. suid .. "'"
	local items = SQL.SELECT(tab)
	if wk(items) then
		for i, item in pairs(items) do
			PlaceItem(suid, item.uniqueID)
		end
	end
end)

-- MOVE ITEM
util.AddNetworkString("yrp_move_item")
net.Receive("yrp_move_item", function(len, ply)
	local suid = tonumber(net.ReadString())
	local int_position = tonumber(net.ReadInt(16))
	local iuid = tonumber(net.ReadString())
	local entity = net.ReadEntity()
	if iuid > 0 then
		MisplaceItem(suid, iuid)

		local tab = {}
		tab.table = "yrp_inv_items"
		tab.sets = {}
		tab.sets["int_position"] = int_position
		tab.where = "uniqueID = '" .. iuid .. "'"
		SQL.UPDATE(tab)
	else
		local newitem = {}
		newitem.table = "yrp_inv_items"
		newitem.cols = {}
		newitem.cols["text_printname"] = entity.PrintName or entity:GetClass()
		newitem.cols["text_classname"] = entity:GetClass()
		newitem.cols["text_worldmodel"] = entity:GetModel()
		newitem.cols["int_storage"] = suid
		newitem.cols["int_position"] = int_position
		entity:Remove()
		SQL.INSERT_INTO(newitem)

		local result = SQL.QUERY("SELECT * FROM yrp_inv_items WHERE uniqueID=(SELECT max(uniqueID) FROM yrp_inv_items);")
		result = result[1]

		iuid = tonumber(result.uniqueID)
	end

	PlaceItem(suid, iuid)
end)

-- Surrounding
util.AddNetworkString("get_surrounding_items")
net.Receive("get_surrounding_items", function(len, ply)
	local suritems = ents.FindInSphere(ply:GetPos(), 300)
	local rettab = {}
	for i, e in pairs(suritems) do
		if !e:IsPlayer() and e != ply and e:GetParent() != ply and e:GetOwner() != ply then
			table.insert(rettab, e)
		end
	end

	net.Start("get_surrounding_items")
		net.WriteTable(rettab)
	net.Send(ply)
end)

-- To world
util.AddNetworkString("yrp_move_to_world")
net.Receive("yrp_move_to_world", function(len, ply)
	local suid = tonumber(net.ReadString())
	local iuid = tonumber(net.ReadString())

	local t = {}
	t.table = "yrp_inv_items"
	t.cols = {}
	t.cols[1] = "*"
	t.where = "uniqueID = '" .. iuid .. "'"
	local ent = SQL.SELECT(t)
	ent = ent[1]

	MisplaceItem(suid, iuid)

	local tab = {}
	tab.table = "yrp_inv_items"
	tab.where = "uniqueID = '" .. iuid .. "'"
	SQL.DELETE_FROM(tab)

	local e = ents.Create(ent.text_classname)
	e:SetModel(ent.text_worldmodel)
	e:SetPos(ply:GetPos() + ply:GetForward() * 40)
	e:Spawn()
end)

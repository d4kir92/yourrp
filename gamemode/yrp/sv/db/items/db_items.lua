--Copyright (C) 2017-2018 Arno Zura (https://www.gnu.org/licenses/gpl.txt )

-- DO NOT TOUCH THE DATABASE FILES! If you have errors, report them here:
-- https://discord.gg/sEgNZxg

local _db_name = "yrp_items"

--[[ ITEM ]]--
SQL_ADD_COLUMN(_db_name, "ClassName", "TEXT DEFAULT ' '" )
SQL_ADD_COLUMN(_db_name, "PrintName", "TEXT DEFAULT ' '" )
SQL_ADD_COLUMN(_db_name, "WorldModel", "TEXT DEFAULT ' '" )
SQL_ADD_COLUMN(_db_name, "storageID", "TEXT DEFAULT '0'" )
SQL_ADD_COLUMN(_db_name, "posx", "TEXT DEFAULT '0'" )
SQL_ADD_COLUMN(_db_name, "posy", "TEXT DEFAULT '0'" )
SQL_ADD_COLUMN(_db_name, "sizew", "TEXT DEFAULT '1'" )
SQL_ADD_COLUMN(_db_name, "sizeh", "TEXT DEFAULT '1'" )
SQL_ADD_COLUMN(_db_name, "type", "TEXT DEFAULT 'entity'" )
SQL_ADD_COLUMN(_db_name, "intern_storageID", "TEXT DEFAULT ' '" )

--db_drop_table(_db_name )

local _storage_client_handler = {}

function AddToStorageClientHandler(ply, uid )
	if tonumber(uid) != 0 then
		if _storage_client_handler[tonumber(uid)] == nil then
			_storage_client_handler[tonumber(uid)] = {}
		end
		if !table.HasValue(_storage_client_handler[tonumber(uid)], ply:SteamID() ) then
			table.insert(_storage_client_handler[tonumber(uid)], ply:SteamID() )
		end
	end
end

function RemoveFromStorageClientHandler(ply )
	for i, handler in pairs(_storage_client_handler ) do
		if table.HasValue(handler, ply:SteamID() ) then
			table.RemoveByValue(handler, ply:SteamID() )
		end
	end
end

function GetStorageClients(uid )
	return _storage_client_handler[tonumber(uid)]
end

util.AddNetworkString("yrp_close_storages" )
net.Receive("yrp_close_storages", function(len, ply )
	RemoveFromStorageClientHandler(ply, uid )
end)

function TeleportEntityTo(ent, pos )
	local _pos = Vector(pos[1], pos[2], pos[3] )
	local _angle = ent:GetAngles()

	if enough_space(ent, _pos + Vector(0, 0, 2 ) ) then
		local __pos = get_ground_pos(ent, _pos + Vector(0, 0, 2 ) )
		ent:SetPos(__pos )
	else
		for i = 1, 3 do
			for j = 0, 360, 45 do
				_angle:RotateAroundAxis(ent:GetForward(), 45 )
				local _enough_space = enough_space(ent, _pos + Vector(0, 0, 2 ) + _angle:Forward() * 44 * i )
				if _enough_space then
					local __pos = get_ground_pos(ent, _pos + Vector(0, 0, 2 ) + _angle:Forward() * 44 * i )
					ent:SetPos(__pos )
					return
				end
			end
		end
	end
end

function ItemToEntity(item, ply )
	local _ent = ents.Create(item.ClassName )
	if _ent == NULL then return end
	_ent:SetModel(item.WorldModel )
	_ent:Spawn()
	if item.intern_storageID != "" then
		_ent:SetNWString("storage_uid", item.intern_storageID )
	end
	TeleportEntityTo(_ent, ply:GetPos() )
	return item
end

util.AddNetworkString("additemtostorage" )
util.AddNetworkString("getstorageitems" )
net.Receive("getstorageitems", function(len, ply )
	local _uid = tonumber(net.ReadString() )
	AddToStorageClientHandler(ply, _uid )
	local _items = {}
	if _uid != 0 then
		_items = SQL_SELECT(_db_name, "*", "storageID = '" .. _uid .. "'" )
		if _items == nil or _item == false then
			_items = {}
		end
	end

	for i, item in pairs(_items ) do
		net.Start("additemtostorage" )
			net.WriteTable(item )
		net.Send(ply )
	end
end)

function CreateItem(item, slot )
	local _size = GetEntityItemSize(item.entity )

	local _type = "entity"
	if item.entity:IsWeapon() then
		_type = "weapon"
	end
	item.storageID = slot.uniqueID or item.storageID
	SQL_INSERT_INTO(_db_name, "intern_storageID, ClassName, WorldModel, PrintName, storageID, sizew, sizeh, posx, posy, type", "'" .. item.entity:GetNWString("storage_uid", "" ) .. "', '" .. item.ClassName .. "', '" .. item.WorldModel .. "', '" .. SQL_STR_IN(item.PrintName ) .. "', '" .. item.storageID .. "', " .. _size.sizew .. ", " .. _size.sizeh .. ", " .. item.posx .. ", " .. item.posy .. ", '" .. _type .. "'" )
	local _items = SQL_SELECT(_db_name, "*", nil )
	local _item = _items[#_items]
	return _item
end

local Player = FindMetaTable("Player" )
function Player:MoveItem(_slot1, _slot2, _item )
	--[[
	printTab(_slot1, "SLOT1" )
	printTab(_slot2, "SLOT2" )
	printTab(_item, "ITEM" )
	]]--

	local _stor1 = {}
	if _slot1.storageID != 0 then
		_stor1 = SQL_SELECT("yrp_storages", "*", "uniqueID = '" .. _slot1.storageID .. "'" )
		if wk(_stor1 ) then
			_stor1 = _stor1[1]
		else
			return false
		end
	end
	local _stor2 = {}
	if _slot2.storageID != 0 then
		_stor2 = SQL_SELECT("yrp_storages", "*", "uniqueID = '" .. _slot2.storageID .. "'" )
		if wk(_stor2 ) then
			_stor2 = _stor2[1]
		else
			return false
		end
	end

	if tonumber(_item.intern_storageID ) == tonumber(_slot2.storageID ) then
		printGM("note", "[moveitem] " .. tostring(_item.ClassName ) .. " (CANT PUT SELF INSIDE SELF)")
		return false
	end

	local _i = {}
	if _slot1.storageID == 0 then
		_i = _item
		_i.storageID = _slot2.storageID
		_i.posx = _slot2.posx
		_i.posy = _slot2.posy
		if _i.entity:IsWeapon() then
			_i.entity:SetNWString("eqtype", "weapon" )
		end

		if _slot2.storageID == 0 then
			printGM("db", "[moveitem] FROM NEARBY TO NEARBY" )
			--
		elseif _slot2.storageID != 0 then
			printGM("db", "[moveitem] FROM NEARBY TO STORAGE", _slot2.storageID )
			local _storage = SQL_SELECT("yrp_storages", "*", "uniqueID = " .. _i.storageID )
			if _storage != nil then
				_storage = _storage[1]
				local _stor = {}
				for y = 1, _storage.sizeh do
					_stor[y] = {}
					for x = 1, _storage.sizew do
						_stor[y][x] = {}
						_stor[y][x].value = ""
					end
				end

				local _stor_items = SQL_SELECT(_db_name, "*" , "uniqueID = " .. _i.storageID )
				if _stor_items != nil and _stor_items != false then
					for i, item in pairs(_stor_items ) do
						AddItemToTable(_stor, item )
					end
				end

				if IsEnoughSpace(_stor, _i.sizew, _i.sizeh, _i.posx, _i.posy, _i.uniqueID ) then
					if !IsRightInventoryType(_storage.type, _item.entity:GetNWString("eqtype", "world" ) ) then
						printGM("note", "[moveitem] Item is not right inventory type | storage: " .. _storage.type .. " | item: " .. _item.entity:GetNWString("eqtype", "world" ) )
						return "notrighttype"
					end

					--printGM("db", "[moveitem] ENOUGH SPACE")
					local _result = CreateItem(_item, _slot2 )
					_item.entity:Remove()
					_item.uniqueID = _result.uniqueID

					if _storage.type == "eqbp" then
						local _uid = SQL_SELECT("yrp_characters", "eqbp", "uniqueID = '" .. self:CharID() .. "'" )
						_uid = _uid[1].eqbp

						-- Parent Backpack to Character
						local _bp = SQL_SELECT("yrp_items", "*", "storageID = '" .. _uid .. "'" )
						if _bp != nil then
							_bp = _bp[1]
							SQL_UPDATE("yrp_storages", "ParentID = '" .. self:CharID() .. "'", "uniqueID = '" .. _bp.intern_storageID .. "'" )
						end
					end
				else
					printGM("db", "[moveitem] FROM NEARBY TO STORAGE: Not Enough Space!" )
					return "e1"
				end
			end
		else
			printGM("error", "[moveitem] FROM NEARBY TO ERROR" )
			return false
		end
	elseif _slot1.storageID != 0 then
		_i = SQL_SELECT(_db_name, "*", "uniqueID = " .. _item.uniqueID )
		if _i != nil then
			_i = _i[1]
			_i.storageID = _slot2.storageID
			_i.posx = _slot2.posx
			_i.posy = _slot2.posy

			if _slot2.storageID == 0 then
				printGM("db", "FROM STORAGE " .. _slot1.storageID .. " TO NEARBY" )
				local _result = SQL_DELETE_FROM(_db_name, "uniqueID = " .. _item.uniqueID )
				_item = ItemToEntity(_item, self )
			elseif _slot2.storageID != 0 then
				printGM("db", "FROM STORAGE " .. _slot1.storageID .. " TO STORAGE " .._slot2.storageID )
				local _storage = SQL_SELECT("yrp_storages", "*", "uniqueID = " .. _i.storageID )
				if _storage != nil then
					_storage = _storage[1]
					local _stor = {}
					for y = 1, _storage.sizeh do
						_stor[y] = {}
						for x = 1, _storage.sizew do
							_stor[y][x] = {}
							_stor[y][x].value = ""
						end
					end

					if !IsRightInventoryType(_storage.type, _i.type ) then
						local _ent = _item.entity
						local _type = "failed"
						if ea(_ent ) then
							_type = _item.entity:GetNWString("eqtype", "world" )
						end
						printGM("note", "Item is not right inventory type | storage: " .. _storage.type .. " | item: " .. _type )
						return "notrighttype"
					end

					local _stor_items = SQL_SELECT(_db_name, "*" , "storageID = " .. _i.storageID )
					if _stor_items != nil and _stor_items != false then
						for i, item in pairs(_stor_items ) do
							AddItemToTable(_stor, item )
						end
					end

					if IsEnoughSpace(_stor, _i.sizew, _i.sizeh, _i.posx, _i.posy, _i.uniqueID ) then
						local _result = SQL_UPDATE(_db_name, "storageID = '" .. _i.storageID .. "', posx = '" .. _i.posx .. "', posy = '" .. _i.posy .. "'", "uniqueID = " .. _i.uniqueID )
					else
						printGM("db", "moveitem: FROM STORAGE TO STORAGE: Not Enough Space!" )
						return "e2"
					end
				end
			else
				printGM("error", "FROM STORAGE TO ERROR" )
				return false
			end
		else
			printGM("note", "[moveitem] item not available anymore" )
		end
	else
		printGM("error", "[moveitem] FROM UNKNOWN" )
		return false
	end

	--[[ WORKED ]]--
	if (IsRightInventoryType("weapon", _i.type ) or _slot1.storageID == 0 ) and InventoryTypeChanger(_stor2.type ) == "weapon" then
		self:ForceEquip(_i.ClassName )
	elseif IsRightInventoryType("weapon", _i.type ) and InventoryTypeChanger(_stor1.type ) == "weapon" then
		for i, wep in pairs(self:GetWeapons() ) do
			if _i.ClassName == wep:GetClass() then
				wep:Remove()
			end
		end
	end

	--[[ Worked: Move item ]]--
	if _slot1.storageID == 0 and _slot2.storageID == 0 then
		net.Start("moveitem_slot1" )
			net.WriteTable(_slot1 )
		net.Send(self )

		net.Start("moveitem_slot2" )
			net.WriteTable(_slot2 )
			net.WriteTable(_item )
		net.Send(self )
	else
		if _slot1.storageID != 0 then
			local _clients_slot1 = GetStorageClients(_slot1.storageID )
			for i, pl in pairs(player.GetAll() ) do
				if table.HasValue(_clients_slot1, pl:SteamID() ) then
					net.Start("moveitem_slot1" )
						net.WriteTable(_slot1 )
					net.Send(pl )
				end
			end
		else
			net.Start("moveitem_slot1" )
				net.WriteTable(_slot1 )
			net.Send(self )
		end

		if _slot2.storageID != 0 then
			if _type == "eqbp" then
				net.Start("moveitem_slot2" )
					net.WriteTable(_slot2 )
					net.WriteTable(_item )
				net.Send(self )
			else
				local _clients_slot2 = GetStorageClients(_slot2.storageID )
				for i, pl in pairs(player.GetAll() ) do
					if table.HasValue(_clients_slot2, pl:SteamID() ) then
						net.Start("moveitem_slot2" )
							net.WriteTable(_slot2 )
							net.WriteTable(_item )
						net.Send(pl )
					end
				end
			end
		else
			--
		end
	end

	self:UpdateBackpack()
end

util.AddNetworkString("moveitem" )
util.AddNetworkString("moveitem_slot1" )
util.AddNetworkString("moveitem_slot2" )
net.Receive("moveitem", function(len, ply )
	local _slot1 = net.ReadTable()
	local _slot2 = net.ReadTable()
	local _item = net.ReadTable()

	ply:MoveItem(_slot1, _slot2, _item )
end)

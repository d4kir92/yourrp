--Copyright (C) 2017-2019 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

-- DO NOT TOUCH THE DATABASE FILES! If you have errors, report them here:
-- https://discord.gg/sEgNZxg

local _db_name = "yrp_storages"

--[[ ITEM ]]--
SQL_ADD_COLUMN(_db_name, "name", "TEXT DEFAULT 'Unnamed Storage'")
SQL_ADD_COLUMN(_db_name, "sizew", "INT DEFAULT 2")
SQL_ADD_COLUMN(_db_name, "sizeh", "INT DEFAULT 2")
SQL_ADD_COLUMN(_db_name, "posx", "TEXT DEFAULT '0'")
SQL_ADD_COLUMN(_db_name, "posy", "TEXT DEFAULT '0'")
SQL_ADD_COLUMN(_db_name, "posz", "TEXT DEFAULT '0'")
SQL_ADD_COLUMN(_db_name, "angp", "TEXT DEFAULT '0'")
SQL_ADD_COLUMN(_db_name, "angy", "TEXT DEFAULT '0'")
SQL_ADD_COLUMN(_db_name, "angr", "TEXT DEFAULT '0'")
SQL_ADD_COLUMN(_db_name, "ClassName", "TEXT DEFAULT 'error'")
SQL_ADD_COLUMN(_db_name, "ParentID", "TEXT DEFAULT ' '")
SQL_ADD_COLUMN(_db_name, "map", "TEXT DEFAULT ' '")
SQL_ADD_COLUMN(_db_name, "type", "TEXT DEFAULT 'world'")

--db_drop_table(_db_name)

util.AddNetworkString("remove_storage")
function RemoveDBStorage(ply, uid)
	if ply:HasAccess() then
		for i, ent in pairs(ents.GetAll()) do
			if tostring(ent:GetNW2String("storage_uid")) == tostring(uid) then
				ent:Remove()
				SQL_DELETE_FROM(_db_name, "uniqueID = '" .. uid .. "'")
			end
		end
	end
end
net.Receive("remove_storage", function(len, ply)
	local uid = net.ReadString()
	RemoveDBStorage(ply, uid)
end)

function CreateEquipmentStorage(ply, typ, PID, w, h)
	local _r = SQL_INSERT_INTO(_db_name, "type, ParentID, sizew, sizeh", "'" .. typ .. "', '" .. PID .. "', " .. w .. ", " .. h .. ""	)
	local _uid = 0
	local _storages = SQL_SELECT(_db_name, "*", nil)
	for i, stor in pairs(_storages) do
		if tonumber(stor.uniqueID) > _uid then
			_uid = tonumber(stor.uniqueID)
		end
	end

	local _eq = SQL_UPDATE("yrp_characters", typ .. " = '" .. _uid .. "'", "uniqueID = '" .. ply:CharID() .. "'"	)

	return _uid
end

function SaveStorages(str)
	printGM("db", "SaveStorages(" .. string.upper(tostring(str)) .. ")")
	local _ents = ents.GetAll()
	for i, ent in pairs(_ents) do
		if ent:IsValid() and ent:GetNW2String("storage_uid", "") != "" and ent:IsWorldStorage() then
			local _pos = string.Explode(" ", tostring(ent:GetPos()))
			local _posx = _pos[1]
			local _posy = _pos[2]
			local _posz = _pos[3]
			local _ang = string.Explode(" ", tostring(ent:GetAngles()))
			local _angp = _ang[1]
			local _angy = _ang[2]
			local _angr = _ang[3]

			SQL_UPDATE(_db_name, "posx = '" .. _posx .. "', posy = '" .. _posy .. "', posz = '" .. _posz .. "', angp = '" .. _angp .. "', angy = '" .. _angy .. "', angr = '" .. _angr .. "'", "uniqueID = '" .. ent:GetNW2String("storage_uid") .. "'")
			local _all = SQL_SELECT(_db_name, "*", nil)

		end
	end
end

function LoadStorages()
	local _storages = SQL_SELECT(_db_name, "*", "ParentID = '' AND map = '" .. GetMapNameDB() .. "'")

	if _storages == nil or _storages == false then
		_storages = {}
	end

	for i, stor in pairs(_storages) do
		local _tmp = ents.Create(stor.ClassName)
		if ea(_tmp) then
			_tmp:SetNW2String("storage_uid", stor.uniqueID)
			_tmp:SetPos(Vector(stor.posx, stor.posy, stor.posz))
			_tmp:SetAngles(Angle(stor.angp, stor.angy, stor.angr))
			_tmp:Spawn()
			_tmp:DropToFloor()
			timer.Simple(0.01, function()
				if ea(_tmp) then
					if _tmp:GetPhysicsObject():IsValid() then
						_tmp:GetPhysicsObject():EnableMotion(false)
					end
				end
			end)
		end
	end
end

local Entity = FindMetaTable("Entity")

function Entity:InitBackpackStorage(w, h)
	self:SetNW2String("item_size_w", 1)
	self:SetNW2String("item_size_h", 1)

	self:InitStorage(w, h, "backpack")
	self:SetNW2Bool("isbackpack", true)
	self:SetNW2String("eqtype", "eqbp")
end

function Entity:InitStorage(w, h)
	local sizew = w
	local sizeh = h
	if sizew > ITEM_MAXW then
		sizew = ITEM_MAXW
	end
	timer.Simple(0.1, function()
		local _storage = nil
		local _uid = tonumber(self:GetNW2String("storage_uid", "0"))
		if _uid != 0 then
			--[[ FOUND STORAGE ]]--
			_storage = SQL_SELECT(_db_name, "*", "uniqueID = " .. _uid)
		else
			--[[ NEW STORAGE ]]--
			printGM("note", "NEW STORAGE(" .. tostring(self) .. ", " .. sizew .. ", " .. sizeh .. ")")
			local _pos = string.Explode(" ", tostring(self:GetPos()))
			local _posx = _pos[1]
			local _posy = _pos[2]
			local _posz = _pos[3]
			local _ang = string.Explode(" ", tostring(self:GetAngles()))
			local _angp = _ang[1]
			local _angy = _ang[2]
			local _angr = _ang[3]
			local _r = SQL_INSERT_INTO(_db_name, "map, sizew, sizeh, ClassName, posx, posy, posz, angp, angy, angr", "'" .. GetMapNameDB() .. "', " .. sizew .. ", " .. sizeh .. ", '" .. self:GetClass() .. "', '" .. _posx .. "', '" .. _posy .. "', '" .. _posz .. "', '" .. _angp .. "', '" .. _angy .. "', '" .. _angr .. "'"	)
			local _storages = SQL_SELECT(_db_name, "*", nil)
			for i, stor in pairs(_storages) do
				if tonumber(stor.uniqueID) > _uid then
					_uid = tonumber(stor.uniqueID)
				end
			end
			self:SetNW2String("storage_uid", _uid)
			_storage = SQL_SELECT(_db_name, "*", "uniqueID = " .. self:GetNW2String("storage_uid"))
		end
		if _storage != nil then
			_storage = _storage[1]
			self:SetNW2Bool("storagename", _storage.name)
			self:SetNW2Bool("hasinventory", true)
			return _storage
		end
	end)
end

util.AddNetworkString("openStorage")
function openStorage(ply, uid)
	local _storages = {}

	--[[ Add World Storage ]]--
	if uid != nil then
		local _result = SQL_SELECT(_db_name, "*", "uniqueID = " .. uid)
		if wk(_result) then
			_result = _result[1]
			table.insert(_storages, _result)
		end
	end

	net.Start("openStorage")
		net.WriteTable(_storages)
	net.Send(ply)
end
net.Receive("openStorage", function(len, ply)
	openStorage(ply)
end)

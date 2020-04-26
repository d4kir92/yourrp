--Copyright (C) 2017-2020 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

-- DO NOT TOUCH THE DATABASE FILES! If you have errors, report them here:
-- https://discord.gg/sEgNZxg

local DATABASE_NAME = "yrp_characters"

SQL_ADD_COLUMN(DATABASE_NAME, "SteamID", "TEXT DEFAULT 'UNKNOWN'")

SQL_ADD_COLUMN(DATABASE_NAME, "roleID", "INT DEFAULT 1")
SQL_ADD_COLUMN(DATABASE_NAME, "groupID", "INT DEFAULT 1")

SQL_ADD_COLUMN(DATABASE_NAME, "text_idstructure", "TEXT DEFAULT ''")
SQL_ADD_COLUMN(DATABASE_NAME, "text_idcardid", "TEXT DEFAULT ''")

SQL_ADD_COLUMN(DATABASE_NAME, "playermodelID", "INT DEFAULT 1")
SQL_ADD_COLUMN(DATABASE_NAME, "skin", "INT DEFAULT 1")

SQL_ADD_COLUMN(DATABASE_NAME, "string_birthday", "TEXT DEFAULT '01.01.2000'")
SQL_ADD_COLUMN(DATABASE_NAME, "int_bodyheight", "INT DEFAULT 180")
SQL_ADD_COLUMN(DATABASE_NAME, "int_weight", "INT DEFAULT 80")
SQL_ADD_COLUMN(DATABASE_NAME, "string_nationality", "TEXT DEFAULT ''")

--[[ LEVEL ]]--
SQL_ADD_COLUMN(DATABASE_NAME, "int_level", "INT DEFAULT 1")
SQL_ADD_COLUMN(DATABASE_NAME, "int_xp", "INT DEFAULT 0")

for i = 0, 19 do
	SQL_ADD_COLUMN(DATABASE_NAME, "bg" .. i, "INT DEFAULT 0")
end

SQL_ADD_COLUMN(DATABASE_NAME, "storage", "TEXT DEFAULT ' '")

SQL_ADD_COLUMN(DATABASE_NAME, "keynrs", "TEXT DEFAULT ' '")
SQL_ADD_COLUMN(DATABASE_NAME, "rpname", "TEXT DEFAULT 'ID_RPNAME'")
SQL_ADD_COLUMN(DATABASE_NAME, "rpdescription", "TEXT DEFAULT ' '")
SQL_ADD_COLUMN(DATABASE_NAME, "gender", "TEXT DEFAULT 'gendermale'")
SQL_ADD_COLUMN(DATABASE_NAME, "money", "TEXT DEFAULT '250'")
SQL_ADD_COLUMN(DATABASE_NAME, "moneybank", "TEXT DEFAULT '500'")
SQL_ADD_COLUMN(DATABASE_NAME, "position", "TEXT DEFAULT '0,0,0'")
SQL_ADD_COLUMN(DATABASE_NAME, "angle", "TEXT DEFAULT '0,0,0'")
SQL_ADD_COLUMN(DATABASE_NAME, "map", "TEXT DEFAULT 'gm_construct'")

SQL_ADD_COLUMN(DATABASE_NAME, "int_warnings", "INT DEFAULT 0")
SQL_ADD_COLUMN(DATABASE_NAME, "int_violations", "INT DEFAULT 0")
SQL_ADD_COLUMN(DATABASE_NAME, "int_arrests", "INT DEFAULT 0")

--[[ EQUIPMENT NEW ]]--
SQL_ADD_COLUMN(DATABASE_NAME, "int_storageID", "TEXT DEFAULT '0'")

--[[ EQUIPMENT OLD ]]--
SQL_ADD_COLUMN(DATABASE_NAME, "eqbag0", "TEXT DEFAULT ''")
SQL_ADD_COLUMN(DATABASE_NAME, "eqbag1", "TEXT DEFAULT ''")
SQL_ADD_COLUMN(DATABASE_NAME, "eqbag2", "TEXT DEFAULT ''")
SQL_ADD_COLUMN(DATABASE_NAME, "eqbag3", "TEXT DEFAULT ''")
SQL_ADD_COLUMN(DATABASE_NAME, "eqbag4", "TEXT DEFAULT ''")

SQL_ADD_COLUMN(DATABASE_NAME, "eqwpp1", "TEXT DEFAULT ' '")
SQL_ADD_COLUMN(DATABASE_NAME, "eqwpp2", "TEXT DEFAULT ' '")
SQL_ADD_COLUMN(DATABASE_NAME, "eqwps1", "TEXT DEFAULT ' '")
SQL_ADD_COLUMN(DATABASE_NAME, "eqwps2", "TEXT DEFAULT ' '")
SQL_ADD_COLUMN(DATABASE_NAME, "eqwpg", "TEXT DEFAULT ' '")

if SQL_SELECT(DATABASE_NAME, "*", "uniqueID = 1") == nil then
	local _result = SQL_INSERT_INTO(DATABASE_NAME, "uniqueID", "1")
end

--db_drop_table(DATABASE_NAME)
--db_is_empty(DATABASE_NAME)

local Player = FindMetaTable("Player")
function Player:CharacterLoadout()
	printGM("debug", "[CharacterLoadout] " .. self:YRPName())
	local chatab = self:GetChaTab()
	if wk(chatab) then
		self:SetDInt("int_xp", chatab.int_xp)
		self:SetDString("int_level", chatab.int_level)
		self:SetDString("charid", chatab.uniqueID)

		self:SetDInt("int_warnings", chatab.int_warnings)
		self:SetDInt("int_violations", chatab.int_violations)
		self:SetDInt("int_arrests", chatab.int_arrests)

		self:SetDString("string_birthday", SQL_STR_OUT(chatab.string_birthday))
		self:SetDInt("int_bodyheight", chatab.int_bodyheight)
		self:SetDInt("int_weight", chatab.int_weight)
		self:SetDString("string_nationality", SQL_STR_OUT(chatab.string_nationality))
		
		for i = 0, 4 do
			self:SetDString("eqbag" .. i, chatab["eqbag" .. i])
		end

		local levelsystem = SQL_SELECT("yrp_levelsystem", "*", nil)
		if wk(levelsystem) then
			levelsystem = levelsystem[1]
			self:SetDString("int_xp_for_levelup", levelsystem.int_xp_for_levelup)
			self:SetDString("float_multiplier", levelsystem.float_multiplier)
		end
	end
end

function Player:VisualEquipment(name, slot)
	if self:HasCharacterSelected() then
		local _charid = self:CharID()
		if wk(_charid) then
			local _uid = SQL_SELECT("yrp_characters", slot, "uniqueID = '" .. _charid .. "'")
			if wk(_uid) then
				_uid = _uid[1][slot]
				if wk(_uid) then
					local _item = SQL_SELECT("yrp_items", "*", "storageID = '" .. _uid .. "'")
					if wk(_item) then
						_item = _item[1]
						local _model = _item.WorldModel

						local _old = self:GetDEntity(name)
						if ea(_old) then
							_old:Remove()
						end
						self:SetDString(name, _model)
						local _visual = ents.Create("prop_dynamic")
						_visual:SetModel(_item.WorldModel)
						_visual:SetOwner(self)
						_visual:SetDBool("isviewmodel", true)
						_visual:Spawn()

						self:SetDEntity(name, _visual)
						self:SetDString(name .. "ClassName", _item.ClassName)

						local _maxs = _visual:OBBMaxs()
						local _mins = _visual:OBBMins()

						local _x = _maxs.x - _mins.x
						local _y = _maxs.y - _mins.y
						local _z = _maxs.z - _mins.z

						local corax = 0
						local coray = 0
						local coraz = 0
						if _z >= _x and _y >= _x then
							corax = 0
							coray = -90
							coraz = 90
							self:SetDString(name .. "thick", _x)
						elseif _x >= _z and _y >= _z then
							corax = 0
							coray = 0
							coraz = 0
							self:SetDString(name .. "thick", _z)
						elseif _x >= _y and _z >= _y then
							corax = 90
							coray = 90
							coraz = 90
							self:SetDString(name .. "thick", _y)
						end
						self:SetDString(name .. "corax", corax)
						self:SetDString(name .. "coray", coray)
						self:SetDString(name .. "coraz", coraz)
					else
						local _old = self:GetDEntity(name)
						if ea(_old) then
							_old:Remove()
							self:SetDEntity(name, NULL)
							self:SetDString(name .. "ClassName", "")
						end
					end
					return _item
				end
			end
		end
	end
end

function Player:UpdateBackpack()
	local _bp = self:VisualEquipment("backpack", "eqbp") --, "ValveBiped.Bip01_Spine4", 1.3, Vector(-16, -7, 3.4), Angle(0, -90 -12, -90))
	self:UpdateWeaponPrimary1()
	self:UpdateWeaponPrimary2()
	self:UpdateWeaponSecondary1()
	self:UpdateWeaponSecondary2()
	self:UpdateWeaponGadget()
	return _bp
end

local _site = 14
function Player:UpdateWeaponPrimary1()
	return self:VisualEquipment("weaponprimary1", "eqwpp1") --,"ValveBiped.Bip01_R_Clavicle", 1, Vector(0, -10, 7), Angle(0, 90 - _site, 90))
end

function Player:UpdateWeaponPrimary2()
	return self:VisualEquipment("weaponprimary2", "eqwpp2") --,"ValveBiped.Bip01_L_Clavicle", 1, Vector(0, -10, -7), Angle(0, 90 - _site, 90))
end

function Player:UpdateWeaponSecondary1()
	return self:VisualEquipment("weaponsecondary1", "eqwps1") --,"ValveBiped.Bip01_R_Thigh", 1, Vector(0, 0, -4), Angle(0, 0, 90))
end

function Player:UpdateWeaponSecondary2()
	return self:VisualEquipment("weaponsecondary2", "eqwps2") --,"ValveBiped.Bip01_L_Thigh", 1, Vector(0, 0, 4), Angle(0, 0, 90))
end

function Player:UpdateWeaponGadget()
	return self:VisualEquipment("weapongadget", "eqwpg") --,"ValveBiped.Bip01_L_Thigh", 1, Vector(0, -5, 0), Angle(0, 0, 90))
end

function Player:SetRPName(str)
	if isstring(str) then
		local oldname = self:Nick()
		local newname = SQL_STR_IN(str)
		SQL_UPDATE("yrp_characters", "rpname = '" .. newname .. "'", "uniqueID = " .. self:CharID())

		newname = SQL_STR_OUT(newname)
		self:SetDString("rpname", newname)

		printGM("note", oldname .. " changed name to " .. newname, true)
	end
end

util.AddNetworkString("update_slot_weapon_primary_1")
net.Receive("update_slot_weapon_primary_1", function(len, ply)
	if ea(ply) then
		local _charid = ply:CharID()
		local _uid = SQL_SELECT(DATABASE_NAME, "eqwpp1", "uniqueID = '" .. _charid .. "'")
		if _uid != nil then
			_uid = _uid[1].eqwpp1
			local _backpack_storage = SQL_SELECT("yrp_storages", "*", "uniqueID = '" .. _uid .. "'")
			if _backpack_storage == nil then
				_backpack_storage = CreateEquipmentStorage(ply, "eqwpp1", _charid, ITEM_MAXW, ITEM_MAXH)
				_backpack_storage = SQL_SELECT("yrp_storages", "*", "uniqueID = '" .. _backpack_storage .. "'")
			end
			_backpack_storage = _backpack_storage[1]
			net.Start("update_slot_weapon_primary_1")
				net.WriteTable(_backpack_storage)
			net.Send(ply)
		end
	end
end)

util.AddNetworkString("update_slot_weapon_primary_2")
net.Receive("update_slot_weapon_primary_2", function(len, ply)
	if ea(ply) then
		local _charid = ply:CharID()
		local _uid = SQL_SELECT(DATABASE_NAME, "eqwpp2", "uniqueID = '" .. _charid .. "'")
		if _uid != nil then
			_uid = _uid[1].eqwpp2
			local _backpack_storage = SQL_SELECT("yrp_storages", "*", "uniqueID = '" .. _uid .. "'")
			if _backpack_storage == nil then
				_backpack_storage = CreateEquipmentStorage(ply, "eqwpp2", _charid, ITEM_MAXW, ITEM_MAXH)
				_backpack_storage = SQL_SELECT("yrp_storages", "*", "uniqueID = '" .. _backpack_storage .. "'")
			end
			_backpack_storage = _backpack_storage[1]
			net.Start("update_slot_weapon_primary_2")
				net.WriteTable(_backpack_storage)
			net.Send(ply)
		end
	end
end)

util.AddNetworkString("update_slot_weapon_secondary_1")
net.Receive("update_slot_weapon_secondary_1", function(len, ply)
	if ea(ply) then
		local _charid = ply:CharID()
		local _uid = SQL_SELECT(DATABASE_NAME, "eqwps1", "uniqueID = '" .. _charid .. "'")
		if _uid != nil then
			_uid = _uid[1].eqwps1
			local _backpack_storage = SQL_SELECT("yrp_storages", "*", "uniqueID = '" .. _uid .. "'")
			if _backpack_storage == nil then
				_backpack_storage = CreateEquipmentStorage(ply, "eqwps1", _charid, 4, 2)
				_backpack_storage = SQL_SELECT("yrp_storages", "*", "uniqueID = '" .. _backpack_storage .. "'")
			end
			_backpack_storage = _backpack_storage[1]
			net.Start("update_slot_weapon_secondary_1")
				net.WriteTable(_backpack_storage)
			net.Send(ply)
		end
	end
end)

util.AddNetworkString("update_slot_weapon_secondary_2")
net.Receive("update_slot_weapon_secondary_2", function(len, ply)
	if ea(ply) then
		local _charid = ply:CharID()
		local _uid = SQL_SELECT(DATABASE_NAME, "eqwps2", "uniqueID = '" .. _charid .. "'")
		if _uid != nil then
			_uid = _uid[1].eqwps2
			local _backpack_storage = SQL_SELECT("yrp_storages", "*", "uniqueID = '" .. _uid .. "'")
			if _backpack_storage == nil then
				_backpack_storage = CreateEquipmentStorage(ply, "eqwps2", _charid, 4, 2)
				_backpack_storage = SQL_SELECT("yrp_storages", "*", "uniqueID = '" .. _backpack_storage .. "'")
			end
			_backpack_storage = _backpack_storage[1]
			net.Start("update_slot_weapon_secondary_2")
				net.WriteTable(_backpack_storage)
			net.Send(ply)
		end
	end
end)

util.AddNetworkString("update_slot_weapon_gadget")
net.Receive("update_slot_weapon_gadget", function(len, ply)
	if ea(ply) then
		local _charid = ply:CharID()
		local _uid = SQL_SELECT(DATABASE_NAME, "eqwpg", "uniqueID = '" .. _charid .. "'")
		if _uid != nil then
			_uid = _uid[1].eqwpg
			local _backpack_storage = SQL_SELECT("yrp_storages", "*", "uniqueID = '" .. _uid .. "'")
			if _backpack_storage == nil then
				_backpack_storage = CreateEquipmentStorage(ply, "eqwpg", _charid, 1, 1)
				_backpack_storage = SQL_SELECT("yrp_storages", "*", "uniqueID = '" .. _backpack_storage .. "'")
			end
			_backpack_storage = _backpack_storage[1]
			net.Start("update_slot_weapon_gadget")
				net.WriteTable(_backpack_storage)
			net.Send(ply)
		end
	end
end)

util.AddNetworkString("update_backpack")
net.Receive("update_backpack", function(len, ply)
	if ea(ply) then
		local _bp = ply:UpdateBackpack()

		if _bp != nil then
			local _uid = _bp.intern_storageID

			local _stor = SQL_SELECT("yrp_storages", "*", "uniqueID = '" .. _uid .. "'")
			if _stor != nil then
				_stor = _stor[1]
				net.Start("update_backpack")
					net.WriteBool(true)
					net.WriteTable(_stor)
				net.Send(ply)
				return true
			end
		end

		net.Start("update_backpack")
			net.WriteBool(false)
		net.Send(ply)
		return false
	end
end)

util.AddNetworkString("update_slot_backpack")
net.Receive("update_slot_backpack", function(len, ply)
	if ea(ply) then
		local _charid = ply:CharID()
		local _uid = SQL_SELECT(DATABASE_NAME, "eqbp", "uniqueID = '" .. _charid .. "'")
		if _uid != nil then
			_uid = _uid[1].eqbp
			local _backpack_storage = SQL_SELECT("yrp_storages", "*", "uniqueID = '" .. _uid .. "'")
			if _backpack_storage == nil then
				_backpack_storage = CreateEquipmentStorage(ply, "eqbp", _charid, 1, 1)
				_backpack_storage = SQL_SELECT("yrp_storages", "*", "uniqueID = '" .. _backpack_storage .. "'")
			end
			_backpack_storage = _backpack_storage[1]
			net.Start("update_slot_backpack")
				net.WriteTable(_backpack_storage)
			net.Send(ply)
		end
	end
end)

util.AddNetworkString("moneyreset")
net.Receive("moneyreset", function(len, ply)
	printGM("db", "<[MONEY RESET]>")
	SQL_UPDATE("yrp_characters", "money = '" .. "0" .. "'", nil)
	SQL_UPDATE("yrp_characters", "moneybank = '" .. "0" .. "'", nil)
	for i, pl in pairs(player.GetAll()) do
		pl:SetMoney(0)
		pl:SetMoneyBank(0)
	end
end)

util.AddNetworkString("change_rpname")
net.Receive("change_rpname", function(len, ply)
	local _new_rp_name = net.ReadString()
	ply:SetRPName(_new_rp_name)
end)

util.AddNetworkString("change_rpdescription")
net.Receive("change_rpdescription", function(len, ply)
	local _new_rp_description = net.ReadString()
	SQL_UPDATE("yrp_characters", "rpdescription = '" .. SQL_STR_IN(_new_rp_description) .. "'", "uniqueID = " .. ply:CharID())
	ply:SetDString("rpdescription", SQL_STR_OUT(_new_rp_description))
	for i, v in pairs(string.Explode("\n", _new_rp_description)) do
		ply:SetDString("rpdescription" .. i, SQL_STR_OUT(v))
	end
end)

util.AddNetworkString("change_birthday")
net.Receive("change_birthday", function(len, ply)
	local _new_birthday = net.ReadString()
	SQL_UPDATE("yrp_characters", "string_birthday = '" .. SQL_STR_IN(_new_birthday) .. "'", "uniqueID = " .. ply:CharID())
	ply:SetDString("string_birthday", SQL_STR_OUT(_new_birthday))
end)
util.AddNetworkString("change_bodyheight")
net.Receive("change_bodyheight", function(len, ply)
	local _new_bodyheight = net.ReadString()
	SQL_UPDATE("yrp_characters", "int_bodyheight = '" .. _new_bodyheight .. "'", "uniqueID = " .. ply:CharID())
	ply:SetDInt("int_bodyheight", SQL_STR_OUT(_new_bodyheight))
end)
util.AddNetworkString("change_weight")
net.Receive("change_weight", function(len, ply)
	local _new_weight = net.ReadString()
	SQL_UPDATE("yrp_characters", "int_weight = '" .. _new_weight .. "'", "uniqueID = " .. ply:CharID())
	ply:SetDInt("int_weight", SQL_STR_OUT(_new_weight))
end)
util.AddNetworkString("change_nationality")
net.Receive("change_nationality", function(len, ply)
	local _new_nationality = net.ReadString()
	SQL_UPDATE("yrp_characters", "string_nationality = '" .. SQL_STR_IN(_new_nationality) .. "'", "uniqueID = " .. ply:CharID())
	ply:SetDString("string_nationality", SQL_STR_OUT(_new_nationality))
end)

util.AddNetworkString("charGetGroups")
util.AddNetworkString("charGetRoles")
util.AddNetworkString("charGetRoleInfo")

util.AddNetworkString("yrp_get_characters")

util.AddNetworkString("DeleteCharacter")
util.AddNetworkString("CreateCharacter")

net.Receive("charGetGroups", function(len, ply)
	local tmpTable = SQL_SELECT("yrp_ply_groups", "*", nil)
	if tmpTable == nil then
		tmpTable = {}
	end
	net.Start("charGetGroups")
		net.WriteTable(tmpTable)
	net.Send(ply)
end)

net.Receive("charGetRoles", function(len, ply)
	local groupID = net.ReadString()
	local netTable = {}
	local tmpTable = SQL_SELECT("yrp_ply_roles", "*", "int_groupID = " .. tonumber(groupID))
	if wk(tmpTable) then
		local count = 1
		for k, v in pairs(tmpTable) do
			if canGetRole(ply, v.uniqueID) then
				netTable[count] = {}
				netTable[count] = v
				count = count + 1
			end
		end
	end
	net.Start("charGetRoles")
		net.WriteTable(netTable)
	net.Send(ply)
end)

net.Receive("charGetRoleInfo", function(len, ply)
	local roleID = net.ReadString()
	local tmpTable = SQL_SELECT("yrp_ply_roles", "*", "uniqueID = " .. tonumber(roleID))
	if tmpTable == nil then
		tmpTable = {}
	else
		local rpms = GetPlayermodelsOfRole(roleID)
		tmpTable[1].string_playermodels = rpms -- table.concat(tab,",")
	end

	net.Start("charGetRoleInfo")
		net.WriteTable(tmpTable)
	net.Send(ply)
end)

function GetPlayermodelsOfRole(ruid)
	local role = SQL_SELECT("yrp_ply_roles", "*", "uniqueID = '" .. tonumber(ruid) .. "'")
	if wk(role) then
		role = role[1]
		local rpms = string.Explode(",", role.string_playermodels)
		local tab = {}
		for i, id in pairs(rpms) do
			local tmppms = SQL_SELECT("yrp_playermodels", "*", "uniqueID = '" .. id .. "'")
			if wk(tmppms) then
				tmppms = tmppms[1]
				tmppms = string.Explode(",", tmppms.string_models)
				for x, pm in pairs(tmppms) do
					for y, xpm in pairs(string.Explode(",", SQL_STR_OUT(pm))) do
						table.insert(tab, SQL_STR_OUT(xpm))
					end
				end
			end
		end
		return table.concat(tab,",")
	else
		printGM("note", "role " .. ruid .. " has no playermodels")
		return ""
	end
end

function GetPMTableOfRole(ruid)
	local role = SQL_SELECT("yrp_ply_roles", "*", "uniqueID = '" .. tonumber(ruid) .. "'")
	if wk(role) then
		role = role[1]
		local rpms = string.Explode(",", role.string_playermodels)
		local tab = {}
		for i, id in pairs(rpms) do
			local tmppms = SQL_SELECT("yrp_playermodels", "*", "uniqueID = '" .. id .. "'")
			if wk(tmppms) then
				tmppms = tmppms[1]
				for x, pm in pairs(string.Explode(",", tmppms.string_models)) do
					for y, xpm in pairs(string.Explode(",", SQL_STR_OUT(pm))) do
						local entry = {}
						entry.float_size_min = tmppms.float_size_min
						entry.float_size_max = tmppms.float_size_max
						entry.string_model = SQL_STR_OUT(xpm)
						table.insert(tab, entry)
					end
				end
			end
		end
		return tab
	else
		printGM("note", "role " .. ruid .. " has no playermodels")
		return ""
	end
end

--[[ Server Send Characters to Client ]]--
function SendLoopCharacterList(ply, tab)
	if net.BytesLeft() == nil then
		net.Start("yrp_get_characters")
			net.WriteTable(tab)
		net.Send(ply)

		timer.Simple(2, function()
			ply:SetDBool("loadedchars", true)
		end)
	else
		timer.Simple(0.1, function()
			SendLoopCharacterList(ply, tab)
		end)
	end
end

function send_characters(ply)
	local netTable = {}

	local chars = {}

	local chaTab = SQL_SELECT("yrp_characters", "*", "SteamID = '" .. ply:SteamID() .. "'")

	local _charCount = 0
	if wk(chaTab) then
		for k, v in pairs(chaTab) do
			if v.roleID != nil and v.groupID != nil then
				_charCount = _charCount + 1
				netTable[_charCount] = {}
				v.rpname = SQL_STR_OUT(v.rpname)
				netTable[_charCount].char = v

				netTable[_charCount].role = {}
				netTable[_charCount].group = {}
				netTable[_charCount].group.string_name = "INVALID GROUP"

				netTable[_charCount].faction = {}
				netTable[_charCount].faction.string_name = "INVALID FACTION"
				netTable[_charCount].faction.string_icon = ""

				local tmp = SQL_SELECT("yrp_ply_roles", "*", "uniqueID = " .. tonumber(v.roleID))
				if worked(tmp, "charGetCharacters role") then
					tmp = tmp[1]
					netTable[_charCount].role = tmp
				else
					local tmpDefault = SQL_SELECT("yrp_ply_roles", "*", "uniqueID = " .. "1")
					if worked(tmpDefault, "charGetCharacters tmpDefault") then
						tmpDefault = tmpDefault[1]
						netTable[_charCount].role = tmpDefault
					end
				end

				netTable[_charCount].role.string_playermodels = GetPlayermodelsOfRole(v.roleID)

				local tmp2 = SQL_SELECT("yrp_ply_roles", "*", "uniqueID = '" .. tonumber(v.roleID) .. "'")
				if tmp2 != nil and tmp2 != false then
					tmp2 = tmp2[1]
					local tmp3 = SQL_SELECT("yrp_ply_groups", "*", "uniqueID = '" .. tonumber(tmp2.int_groupID) .. "'")
					if worked(tmp3, "charGetCharacters group") then
						tmp3 = tmp3[1]
						netTable[_charCount].group = tmp3
						netTable[_charCount].faction = GetFactionTable(tmp3.uniqueID)
					end
				end
			else
				YRP.msg("note", "[send_characters] roleid != nil or groupid != nil")
			end
		end
	else
		printGM("note", "[send_characters] chaTab failed! " .. tostring(chaTab))
	end

	local plytab = ply:GetPlyTab()

	if wk(plytab) then
		netTable.plytab = plytab
		netTable.chars = chars

		SendLoopCharacterList(ply, netTable)
	else
		printGM("note", "[send_characters] plytab failed! " .. tostring(plytab))
	end
end

--[[ Client ask for Characters ]]--
net.Receive("yrp_get_characters", function(len, ply)
	printGM("db", ply:YRPName() .. " ask for characters")
	send_characters(ply)
end)

net.Receive("DeleteCharacter", function(len, ply)
	local charID = net.ReadString()

	if wk(charID) then
		local result = SQL_DELETE_FROM("yrp_characters", "uniqueID = '" .. tonumber(charID) .. "'")
		if result == nil then
			printGM("db", "DeleteCharacter: success"	)
			ply:KillSilent()
			local steamid = ply:SteamID()
			if wk(steamid) then
				local _first_character = SQL_SELECT("yrp_characters", "*", "SteamID = '" .. steamid .. "'")
				if _first_character != nil then
					_first_character = _first_character[1]
					SQL_UPDATE("yrp_players", "CurrentCharacter = " .. tonumber(_first_character.uniqueID), "SteamID = '" .. steamid .. "'")
					SQL_SELECT("yrp_players", "*", nil)
				end
			else
				YRP.msg("error", "STEAMID FAILED => " .. tostring(steamid) .. " [" .. tostring(ply) .. "]")
			end
			ply:Spawn()
		else
			printGM("note", "DeleteCharacter: fail")
		end
		send_characters(ply)
	end
end)

function CreateCharacter(ply, tab)
	local role = SQL_SELECT("yrp_ply_roles", "*", "uniqueID = " .. tonumber(tab.roleID))
	if wk(role) then
		local steamid = ply:SteamID() or ply:UniqueID()
		local cols = "SteamID, rpname, gender, roleID, groupID, playermodelID, money, moneybank, map, skin, rpdescription, string_birthday, int_bodyheight, int_weight, string_nationality"
		for i = 0, 19 do
			cols = cols .. ", bg" .. i
		end
		local vals = "'" .. steamid .. "', "
		vals = vals .. "'" .. SQL_STR_IN(tab.rpname) .. "', "
		vals = vals .. "'" .. SQL_STR_IN(tab.gender) .. "', "
		vals = vals .. tonumber(role[1].uniqueID) .. ", "
		vals = vals .. tonumber(role[1].int_groupID) .. ", "
		vals = vals .. tonumber(tab.playermodelID) .. ", "
		vals = vals .. GetGlobalDString("text_characters_money_start", 0) .. ", "
		vals = vals .. 0 .. ", "
		vals = vals .. "'" .. SQL_STR_IN(GetMapNameDB()) .. "', "
		vals = vals .. tonumber(tab.skin) .. ", "
		vals = vals .. "'" .. SQL_STR_IN(tostring(tab.rpdescription)) .. "', "

		vals = vals .. "'" .. SQL_STR_IN(tostring(tab.birt)) .. "', "
		vals = vals .. "'" .. SQL_STR_IN(tostring(tab.bohe)) .. "', "
		vals = vals .. "'" .. SQL_STR_IN(tostring(tab.weig)) .. "', "
		vals = vals .. "'" .. SQL_STR_IN(tostring(tab.nati)) .. "'"

		for i = 0, 19 do
			vals = vals .. ", " .. tonumber(tab.bg[i])
		end
		local char = SQL_INSERT_INTO("yrp_characters", cols, vals)
		if char == nil then
			local chars = SQL_SELECT("yrp_characters", "*", nil)
			if worked(chars, "[CreateCharacter] chars") then
				local result = SQL_UPDATE("yrp_players", "CurrentCharacter = " .. tonumber(chars[#chars].uniqueID), "SteamID = '" .. ply:SteamID() .. "'")
				if result != nil then
					YRP.msg("error", "[CreateCharacter] failed @Update!")
				end
			else
				printGM("note", "[CreateCharacter] chars failed: " .. tostring(chars))
			end
		else
			YRP.msg("error", "[CreateCharacter] failed - char: " .. tostring(char) .. " " .. sql_show_last_error())
		end
		send_characters(ply)
	else
		printGM("note", "[CreateCharacter] role not found!")
	end
	CreateCharacterStorages()
end

net.Receive("CreateCharacter", function(len, ply)
	local tab = net.ReadTable()
	CreateCharacter(ply, tab)
end)

util.AddNetworkString("LogOut")
net.Receive("LogOut", function(len, ply)
	ply:KillSilent()
end)

util.AddNetworkString("EnterWorld")
net.Receive("EnterWorld", function(len, ply)
	local roltab = ply:GetRolTab()
	if wk(roltab) then
		updateRoleUses(roltab.uniqueID)
	end

	local char = net.ReadString()
	if char != ply:CharID() then
		if GetGlobalDBool("bool_removebuildingownercharswitch", false) then
			BuildingRemoveOwner(ply:SteamID())
		end
		hook.Run("yrp_switched_character", ply, ply:CharID(), char)
	end
	if wk(char) then
		SQL_UPDATE("yrp_players", "CurrentCharacter = '" .. char .. "'", "SteamID = '" .. ply:SteamID() .. "'")
		ply:Spawn()
	else
		printGM("gm", "No valid character selected (" .. tostring(char) .. ")")
	end
end)

function SendBodyGroups(ply)
	local charid = ply:CharID()
	if wk(charid) then
		local _result = SQL_SELECT("yrp_characters", "bg0, bg1, bg2, bg3, bg4, bg5, bg6, bg7, skin, playermodelID", "uniqueID = " .. tonumber(charid))
		if wk(_result) then
			_result = _result[1]
			local _role = ply:GetRolTab()
			if wk(_role) then
				_result.string_playermodels = GetPlayermodelsOfRole(_role.uniqueID)
				if _result.string_playermodels != "" then
					net.Start("get_menu_bodygroups")
						net.WriteTable(_result)
					net.Send(ply)
				else
					net.Start("get_menu_bodygroups")
						net.WriteTable({})
					net.Send(ply)
				end
			end
		else
			printGM("note", "get_menu_bodygroups failed!")
		end
	end
end

util.AddNetworkString("get_menu_bodygroups")
net.Receive("get_menu_bodygroups", function(len, ply)
	SendBodyGroups(ply)
end)

util.AddNetworkString("inv_bg_up")

net.Receive("inv_bg_up", function(len, ply)
	local _cur = net.ReadInt(16)
	local _id = net.ReadInt(16)
	ply:SetBodygroup(_id, _cur)
	local _charid = ply:CharID()
	SQL_UPDATE("yrp_characters", "bg" .. tonumber(_id) .. " = " .. tonumber(_cur), "uniqueID = " .. tonumber(_charid))
end)

util.AddNetworkString("inv_bg_do")

net.Receive("inv_bg_do", function(len, ply)
	local _cur = net.ReadInt(16)
	local _id = net.ReadInt(16)
	ply:SetBodygroup(_id, _cur)
	local _charid = ply:CharID()
	SQL_UPDATE("yrp_characters", "bg" .. tonumber(_id) .. " = " .. tonumber(_cur), "uniqueID = " .. tonumber(_charid))
end)

util.AddNetworkString("inv_skin_up")

net.Receive("inv_skin_up", function(len, ply)
	local _cur = net.ReadInt(16)
	ply:SetSkin(_cur)
	local _charid = ply:CharID()
	SQL_UPDATE("yrp_characters", "skin" .. " = " .. tonumber(_cur), "uniqueID = " .. tonumber(_charid))
end)

util.AddNetworkString("inv_skin_do")

net.Receive("inv_skin_do", function(len, ply)
	local _cur = net.ReadInt(16)
	ply:SetSkin(_cur)
	local _charid = ply:CharID()
	SQL_UPDATE("yrp_characters", "skin" .. " = " .. tonumber(_cur), "uniqueID = " .. tonumber(_charid))
end)

util.AddNetworkString("inv_pm_up")
net.Receive("inv_pm_up", function(len, ply)
	local _cur = net.ReadInt(16)
	local _pms = string.Explode(",", GetPlayermodelsOfRole(ply:GetRolTab().uniqueID))
	if wk(_pms) then
		ply:SetDString("string_playermodel", _pms[_cur])
		ply:SetModel(_pms[_cur])
		local _charid = ply:CharID()
		SQL_UPDATE("yrp_characters", "playermodelID" .. " = " .. tonumber(_cur), "uniqueID = " .. tonumber(_charid))
		ply:UpdateBackpack()
		SendBodyGroups(ply)
	end
end)

util.AddNetworkString("inv_pm_do")
net.Receive("inv_pm_do", function(len, ply)
	local _cur = net.ReadInt(16)
	local _pms = string.Explode(",", GetPlayermodelsOfRole(ply:GetRolTab().uniqueID))
	if _pms != nil then
		ply:SetDString("string_playermodel", _pms[_cur])
		ply:SetModel(_pms[_cur])
		local _charid = ply:CharID()
		SQL_UPDATE("yrp_characters", "playermodelID" .. " = " .. tonumber(_cur), "uniqueID = " .. tonumber(_charid))
		ply:UpdateBackpack()
		SendBodyGroups(ply)
	end
end)

util.AddNetworkString("warning_up")
net.Receive("warning_up", function(len, ply)
	local p = net.ReadEntity()
	local ptab = SQL_SELECT(DATABASE_NAME, "int_warnings", "uniqueID = '" .. p:CharID() .. "'")
	if wk(ptab) then
		local int_warnings = ptab[1].int_warnings
		int_warnings = int_warnings + 1
		int_warnings = math.Clamp(int_warnings, 0, 10)

		SQL_UPDATE(DATABASE_NAME, "int_warnings = '" .. int_warnings .. "'", "uniqueID = '" .. p:CharID() .. "'")

		p:SetDInt("int_warnings", int_warnings)
	end
end)

util.AddNetworkString("warning_dn")
net.Receive("warning_dn", function(len, ply)
	local p = net.ReadEntity()
	local ptab = SQL_SELECT(DATABASE_NAME, "int_warnings", "uniqueID = '" .. p:CharID() .. "'")
	if wk(ptab) then
		local int_warnings = ptab[1].int_warnings
		int_warnings = int_warnings - 1
		int_warnings = math.Clamp(int_warnings, 0, 10)

		SQL_UPDATE(DATABASE_NAME, "int_warnings = '" .. int_warnings .. "'", "uniqueID = '" .. p:CharID() .. "'")

		p:SetDInt("int_warnings", int_warnings)
	end
end)

util.AddNetworkString("violation_up")
net.Receive("violation_up", function(len, ply)
	local p = net.ReadEntity()
	local ptab = SQL_SELECT(DATABASE_NAME, "int_violations", "uniqueID = '" .. p:CharID() .. "'")
	if wk(ptab) then
		local int_violations = ptab[1].int_violations
		int_violations = int_violations + 1
		int_violations = math.Clamp(int_violations, 0, 10)

		SQL_UPDATE(DATABASE_NAME, "int_violations = '" .. int_violations .. "'", "uniqueID = '" .. p:CharID() .. "'")

		p:SetDInt("int_violations", int_violations)
	end
end)

util.AddNetworkString("violation_dn")
net.Receive("violation_dn", function(len, ply)
	local p = net.ReadEntity()
	local ptab = SQL_SELECT(DATABASE_NAME, "int_violations", "uniqueID = '" .. p:CharID() .. "'")
	if wk(ptab) then
		local int_violations = ptab[1].int_violations
		int_violations = int_violations - 1
		int_violations = math.Clamp(int_violations, 0, 10)

		SQL_UPDATE(DATABASE_NAME, "int_violations = '" .. int_violations .. "'", "uniqueID = '" .. p:CharID() .. "'")

		p:SetDInt("int_violations", int_violations)
	end
end)

util.AddNetworkString("set_idcardid")
net.Receive("set_idcardid", function(len, ply)
	local p = net.ReadEntity()
	local text_idcardid = net.ReadString()
	local ptab = SQL_SELECT(DATABASE_NAME, "text_idcardid", "uniqueID = '" .. p:CharID() .. "'")
	if wk(ptab) then
		SQL_UPDATE(DATABASE_NAME, "text_idcardid = '" .. text_idcardid .. "'", "uniqueID = '" .. p:CharID() .. "'")
		p:SetDString("idcardid", text_idcardid)
	end
end)

util.AddNetworkString("removearrests")
net.Receive("removearrests", function(len, ply)
	local p = net.ReadEntity()
	if wk(p:CharID()) then
		SQL_UPDATE(DATABASE_NAME, "int_arrests = '" .. 0 .. "'", "uniqueID = '" .. p:CharID() .. "'")
		p:SetDInt("int_arrests", 0)
	end
end)
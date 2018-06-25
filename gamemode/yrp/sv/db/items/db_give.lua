--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )
-- DO NOT TOUCH THE DATABASE FILES! If you have errors, report them here:
-- https://discord.gg/sEgNZxg
local Entity = FindMetaTable("Entity")

function Entity:SetWorldStorage(b)
	self:SetNWString("isaworldstorage", tobool(b))
end

local Player = FindMetaTable("Player")

if Player.LegacyGive == nil then
	Player.LegacyGive = Player.Give
end

function Player:GetEQ(slot)
	local _char_id = self:CharID()

	if _char_id ~= nil then
		local _slot_uid = SQL_SELECT("yrp_characters", slot, "uniqueID = '" .. _char_id .. "'")

		if wk(_slot_uid) then
			_slot_uid = _slot_uid[1][slot]
			local _item = SQL_SELECT("yrp_items", "*", "storageID = '" .. _slot_uid .. "'")

			if wk(_item) then
				_item = _item[1]

				return _item
			end
		end
	end

	return nil
end

function Player:EquipWeapons()
	local _char_id = self:CharID()

	if _char_id ~= nil then
		local _char = SQL_SELECT("yrp_characters", "*", "uniqueID = '" .. _char_id .. "'")

		if wk(_char) then
			_char = _char[1]
			local _wpp1 = self:GetEQ("eqwpp1")

			if wk(_wpp1) then
				self:ForceEquip(_wpp1.ClassName)
			end

			local _wpp2 = self:GetEQ("eqwpp2")

			if wk(_wpp2) then
				self:ForceEquip(_wpp2.ClassName)
			end

			local _wps1 = self:GetEQ("eqwps1")

			if wk(_wps1) then
				self:ForceEquip(_wps1.ClassName)
			end

			local _wps2 = self:GetEQ("eqwps2")

			if wk(_wps2) then
				self:ForceEquip(_wps2.ClassName)
			end

			local _wpg = self:GetEQ("eqwpg")

			if wk(_wpg) then
				self:ForceEquip(_wpg.ClassName)
			end

			self:UpdateBackpack()
		end
	end
end

function Player:EquipWeapon(slot, item)
	if self:CharID() ~= nil then
		local _slot = SQL_SELECT("yrp_characters", slot, "uniqueID = '" .. self:CharID() .. "'")

		if wk(_slot) then
			_slot = _slot[1][slot]
			_slot = SQL_SELECT("yrp_storages", "*", "uniqueID = '" .. _slot .. "'")

			if wk(_slot) then
				_slot = _slot[1]

				if tonumber(item.sizew) <= tonumber(_slot.sizew) and tonumber(item.sizeh) <= tonumber(_slot.sizeh) then
					local _wp = SQL_SELECT("yrp_items", "*", "storageID = '" .. _slot.uniqueID .. "'")

					if not wk(_wp) then
						item = CreateItem(item, _slot)
						net.Start("moveitem_slot2")
						net.WriteTable(_slot)
						net.WriteTable(item)
						net.Send(self)
						self:UpdateBackpack()
						self:ForceEquip(item.ClassName)

						return true
					else
						_wp = _wp[1]

						return false
					end
				end
			end
		end
	end

	return false
end

function Player:PutInWeaponSlot(item)
	printGM("db", "Player:PutInWeaponSlot( item )")
	local _wpp1 = self:EquipWeapon("eqwpp1", item)
	if _wpp1 then return true end
	local _wpp2 = self:EquipWeapon("eqwpp2", item)
	if _wpp2 then return true end
	local _wps1 = self:EquipWeapon("eqwps1", item)
	if _wps1 then return true end
	local _wps2 = self:EquipWeapon("eqwps2", item)
	if _wps2 then return true end
	local _wpg = self:EquipWeapon("eqwpg", item)
	if _wpg then return true end

	return false
end

function Player:PutInBackpack(item)
	printGM("db", "Player:PutInBackpack( item )")
	local _slot = SQL_SELECT("yrp_characters", "eqbp", "uniqueID = '" .. self:CharID() .. "'")

	if wk(_slot) then
		_slot = _slot[1]["eqbp"]
		_slot = SQL_SELECT("yrp_storages", "*", "uniqueID = '" .. _slot .. "'")

		if wk(_slot) then
			_slot = _slot[1]
			local _bp = SQL_SELECT("yrp_items", "*", "storageID = '" .. _slot.uniqueID .. "'")

			if wk(_bp) then
				_bp = _bp[1]
				_slot = SQL_SELECT("yrp_storages", "*", "uniqueID = '" .. _bp.intern_storageID .. "'")

				if wk(_slot) then
					_slot = _slot[1]
					local _items = SQL_SELECT("yrp_items", "*", "storageID = '" .. _slot.uniqueID .. "'")

					if _items ~= false then
						local _inv = {}

						for y = 1, _slot.sizeh do
							_inv[y] = {}

							for x = 1, _slot.sizew do
								_inv[y][x] = {}
								_inv[y][x].value = ""
							end
						end

						if _items ~= nil then
							for i, it in pairs(_items) do
								for _y = it.posy, it.posy + it.sizeh - 1 do
									for _x = it.posx, it.posx + it.sizew - 1 do
										_inv[_y][_x].value = it.uniqueID
									end
								end
							end
						end

						local _bool, _x, _y = FindPlace(_inv, item.sizew, item.sizeh)

						if _bool then
							item.posx = _x
							item.posy = _y
							item = CreateItem(item, _slot)
							net.Start("moveitem_slot2")
							net.WriteTable(_slot)
							net.WriteTable(item)
							net.Send(self)
							self:UpdateBackpack()
							self:ForceEquip(item.ClassName)

							return true
						else
							return false
						end
					end
				end
			end
		end
	end

	return false
end

function Player:RemoveWeapon(cname)
	for i, swep in pairs(self:GetWeapons()) do
		if swep:GetClass() == cname then
			swep:Remove()

			return true
		end
	end

	return false
end

function Player:RemoveSwep(cname, slot)
	local _eq = self:GetEQ(slot)

	if _eq ~= nil and cname == _eq.ClassName then
		SQL_DELETE_FROM("yrp_items", "uniqueID = '" .. _eq.uniqueID .. "'")
		return true
	end

	return false
end

function Player:RemoveVisual(cname)
	local _wpp1 = self:RemoveSwep(cname, "eqwpp1")
	if _wpp1 then return true end
	local _wpp2 = self:RemoveSwep(cname, "eqwpp2")
	if _wpp2 then return true end
	local _wps1 = self:RemoveSwep(cname, "eqwps1")
	if _wps1 then return true end
	local _wps2 = self:RemoveSwep(cname, "eqwps2")
	if _wps2 then return true end
	local _wpg = self:RemoveSwep(cname, "eqwpg")
	if _wpg then return true end

	return false
end

function Player:DropSWEP(cname)
	local _cname = cname
	local cont = true

	if cont then
		self:RemoveWeapon(_cname)
		self:RemoveVisual(_cname)
		local ent = ents.Create(_cname)

		if ent.WorldModel == "" then
			ent.WorldModel = "models/hunter/blocks/cube025x025x025.mdl"
		end

		ent:SetPos(self:GetPos() + Vector(0, 0, 56) + self:EyeAngles():Forward() * 16)
		ent:SetAngles(self:GetAngles())
		ent:SetNWBool("ispickupable", false)

		timer.Simple(1, function()
			ent:SetNWBool("ispickupable", true)
		end)

		ent:Spawn()

		if ent:GetPhysicsObject():IsValid() then
			ent:GetPhysicsObject():SetVelocity(self:EyeAngles():Forward() * 360)
		end
	end
end

function Player:DropSWEPSilence(cname)
	local _cname = cname
	self:RemoveWeapon(_cname)
	self:RemoveVisual(_cname)
end

function Player:DropBackpackStorage()
	if not rv then
		local _char_id = self:CharID()

		if _char_id ~= nil then
			local _slot = SQL_SELECT("yrp_characters", "eqbp", "uniqueID = '" .. _char_id .. "'")

			if wk(_slot) then
				_slot = _slot[1]["eqbp"]
				_slot = SQL_SELECT("yrp_storages", "*", "uniqueID = '" .. _slot .. "'")

				if wk(_slot) then
					_slot = _slot[1]
					local _bp = SQL_SELECT("yrp_items", "*", "storageID = '" .. _slot.uniqueID .. "'")

					if wk(_bp) then
						_bp = _bp[1]
						_slot = SQL_SELECT("yrp_storages", "*", "uniqueID = '" .. _bp.intern_storageID .. "'")

						if wk(_slot) then
							_slot = _slot[1]
							local _items = SQL_SELECT("yrp_items", "*", "storageID = '" .. _slot.uniqueID .. "'")

							if wk(_items) then
								for i, item in pairs(_items) do
									local _item = ents.Create(item.ClassName)
									if item == NULL then return NULL end
									_item:SetPos(self:GetPos())
									_item:Spawn()
									SQL_DELETE_FROM("yrp_items", "uniqueID = '" .. item.uniqueID .. "'")
								end
							end
						end
					end
				end
			end
		end
	end
end

util.AddNetworkString("yrp_message")

function Player:PutInInventory(cname, noammo)
	printGM("db", "Player:PutInInventory( " .. cname .. ", " .. tostring(noammo) .. " )")
	local ent = ents.Create(cname)
	if ea(ent) then
		ent:Spawn()
		--local sizew, sizeh = GetEntityItemSize( ent )
		local item = FormatEntityToItem(ent)
		item.posx = 1
		item.posy = 1
		ent:Remove()

		if item.entity:IsWeapon() then
			local _worked = self:PutInWeaponSlot(item)
			if _worked then return ent end
		end

		local _worked = self:PutInBackpack(item)
		if _worked then return ent end
		net.Start("yrp_message")
		net.WriteString("yourinventoryisfull")
		net.Send(self)
		self:DropSWEP(item.ClassName)

		return ent
	end
end

function Player:ForceEquip(cname, noammo)
	printGM("gm", "ForceEquip( " .. cname .. " )")
	self.canpickup = true
	local weapon = self:LegacyGive(cname, noammo)

	if wk(weapon) then
		weapon:SetNWBool("ispickupable", true)
	end

	return weapon
end

function Player:Give(cname, noammo)
	printGM("gm", "Give( " .. cname .. " )")
	local _noAmmo = noammo

	if _noAmmo == nil then
		_noAmmo = false
	end

	if self:GetNWBool("bool_inventory_system", false) then
		return self:PutInInventory(cname, noammo)
	else
		return self:ForceEquip(cname, noammo)
	end
end

if Player.LegacyGiveAmmo == nil then
	Player.LegacyGiveAmmo = Player.GiveAmmo
end

function Player:GiveAmmo(amount, atype, hidePopup)
	local _hide_popup = hidePopup

	if _hide_popup == nil then
		_hide_popup = false
	end

	if self:GetNWBool("bool_inventory_system", false) then
		self:LegacyGiveAmmo(amount, atype)
		--self:AddItemAmmo( amount, atype )
	else
		self:LegacyGiveAmmo(amount, atype)
	end
end

hook.Add("KeyPress", "yrp_keypress_use", function(ply, key)
	if (key == IN_USE) then
		local plytr = ply:GetEyeTrace()

		if plytr.Hit and IsValid(plytr.Entity) and plytr.Entity:IsWeapon() and ply:GetPos():Distance(plytr.Entity:GetPos()) < 80 then
			ply:Give(plytr.Entity:GetClass())
			plytr.Entity:Remove()
		end
	end
end)

if Player.LegacyStripWeapon == nil then
	Player.LegacyStripWeapon = Player.StripWeapon
end

function Player:ForceStripWeapon(weapon)
	printGM("gm", "ForceStripWeapon( " .. weapon .. " )")

	return self:LegacyStripWeapon(weapon)
end

function Player:RemoveFromInventory(cname)
	local _bp_slot = SQL_SELECT("yrp_characters", "eqbp", "uniqueID = '" .. self:CharID() .. "'")

	if wk(_bp_slot) then
		_bp_slot = _bp_slot[1]
		local _bp_stor = SQL_SELECT("yrp_storages", "*", "uniqueID = '" .. _bp_slot.eqbp .. "'")

		if wk(_bp_stor) then
			_bp_stor = _bp_stor[1]
			local _bp = SQL_SELECT("yrp_items", "*", "storageID = '" .. _bp_stor.uniqueID .. "'")

			if wk(_bp) then
				_bp = _bp[1]
				local _items = SQL_SELECT("yrp_items", "*", "storageID = '" .. _bp.intern_storageID .. "'")

				if wk(_items) then
					for i, item in pairs(_items) do
						if item.ClassName == cname then
							SQL_DELETE_FROM("yrp_items", "uniqueID = '" .. item.uniqueID .. "'")
						end
					end
				end
			end
		end
	end
end

function Player:RemoveWeaponFromInventory(cname)
	self:RemoveWeapon(cname)
	self:RemoveVisual(cname)

	if not _rem_wep then
		self:RemoveFromInventory(cname)
	end
end

function Player:StripWeapon(weapon)
	printGM("note", "StripWeapon( " .. tostring(weapon) .. " )")

	if self:GetNWBool("bool_inventory_system", false) then
		self:RemoveWeaponFromInventory(weapon)
		self:LegacyStripWeapon(weapon)
	else
		self:LegacyStripWeapon(weapon)
	end
end

if Player.LegacyStripWeapons == nil then
	Player.LegacyStripWeapons = Player.StripWeapons
end

function Player:StripWeapons()
	local _char_id = self:CharID()
	self:LegacyStripWeapons()
end

function GM:PlayerCanPickupWeapon(ply, wep)
	if not ply:GetNWBool("bool_inventory_system", false) then
		--[[ Inventory OFF ]]
		--
		return wep:GetNWBool("ispickupable", true)
	else
		--[[ Inventory ON ]]
		--
		if ply.canpickup == true then
			ply.canpickup = false

			return wep:GetNWBool("ispickupable", true)
		else
			return false
		end
	end

	return true
end

hook.Remove("PlayerCanPickupWeapon", "yrp_remove_pickup_hook")
util.AddNetworkString("drop_item")

net.Receive("drop_item", function(len, ply)
	local _weapon = ply:GetActiveWeapon()

	if _weapon ~= NULL and _weapon ~= nil and _weapon.notdropable == nil then
		local _wclass = _weapon:GetClass() or ""
		ply:DropSWEP(_wclass)
		ply:StripWeapon(_wclass)
	end
end)

util.AddNetworkString("dropswep")

net.Receive("dropswep", function(len, ply)
	local _enabled = PlayersCanDropWeapons()
	local _dropped = false

	if _enabled then
		local _weapon = ply:GetActiveWeapon()

		if _weapon ~= NULL and _weapon ~= nil and _weapon.notdropable == nil then
			local _wclass = _weapon:GetClass() or ""
			ply:DropSWEP(_wclass)
			_dropped = true
		end
	else
		printGM("note", ply:YRPName() .. " PlayersCanDropWeapons == FALSE")
	end

	net.Start("dropswep")
	net.WriteBool(_dropped)
	net.Send(ply)
end)

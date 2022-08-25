--Copyright (C) 2017-2022 D4KiR (https://www.gnu.org/licenses/gpl.txt)
-- DO NOT TOUCH THE DATABASE FILES! If you have errors, report them here:
-- https://discord.gg/sEgNZxg

-- #buymenu #shops

local DATABASE_NAME = "yrp_shop_items"
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "name", "TEXT DEFAULT 'UNNAMED'" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "description", "TEXT DEFAULT 'UNNAMED'" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "price", "TEXT DEFAULT '100'" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "int_level", "INT DEFAULT 1" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "categoryID", "INT DEFAULT -1" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "quantity", "INT DEFAULT -1" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "cooldown", "INT DEFAULT -1" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "licenseID", "INT DEFAULT -1" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "permanent", "INT DEFAULT 0" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "type", "TEXT DEFAULT 'weapons'" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "ClassName", "TEXT DEFAULT 'weapon_crowbar'" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "PrintName", "TEXT DEFAULT 'unnamed item'" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "WorldModel", "TEXT DEFAULT ''" )

util.AddNetworkString( "get_shop_items" )

function send_shop_items(ply, uid)
	local _s_items = YRP_SQL_SELECT(DATABASE_NAME, "*", "categoryID = " .. uid)
	local _nw = _s_items

	if _nw == nil then
		_nw = {}
	end

	net.Start( "get_shop_items" )
	net.WriteTable(_nw)
	net.Send(ply)
end

net.Receive( "get_shop_items", function(len, ply)
	local _catID = net.ReadString()
	send_shop_items(ply, _catID)
end)

util.AddNetworkString( "shop_item_add" )
net.Receive( "shop_item_add", function(len, ply)
	local _catID = net.ReadString()
	local _new = YRP_SQL_INSERT_INTO(DATABASE_NAME, "categoryID", _catID)
	YRP.msg( "db", "shop_item_add: " .. db_worked(_new) )
	send_shop_items(ply, _catID)
end)

util.AddNetworkString( "shop_item_rem" )
net.Receive( "shop_item_rem", function(len, ply)
	local _uid = net.ReadString()
	local _catID = net.ReadString()
	local _new = YRP_SQL_DELETE_FROM(DATABASE_NAME, "uniqueID = " .. _uid)
	YRP.msg( "db", "shop_item_rem: " .. db_worked(_new) )
	send_shop_items(ply, _catID)
end)

util.AddNetworkString( "shop_item_edit_name" )
net.Receive( "shop_item_edit_name", function(len, ply)
	local _uid = net.ReadString()
	local _new_name = net.ReadString()
	local _catID = net.ReadString()
	local _new = YRP_SQL_UPDATE(DATABASE_NAME, {["name"] = _new_name}, "uniqueID = " .. _uid)
	YRP.msg( "db", "shop_item_edit_name: " .. db_worked(_new) )
end)

util.AddNetworkString( "shop_item_edit_desc" )
net.Receive( "shop_item_edit_desc", function(len, ply)
	local _uid = net.ReadString()
	local _new_desc = net.ReadString()
	local _catID = net.ReadString()
	local _new = YRP_SQL_UPDATE(DATABASE_NAME, {["description"] = _new_desc}, "uniqueID = " .. _uid)
	YRP.msg( "db", "shop_item_edit_desc: " .. db_worked(_new) )
end)

util.AddNetworkString( "shop_item_edit_price" )
net.Receive( "shop_item_edit_price", function(len, ply)
	local _uid = net.ReadString()
	local _new_price = net.ReadString()
	local _catID = net.ReadString()
	local _new = YRP_SQL_UPDATE(DATABASE_NAME, {["price"] = _new_price}, "uniqueID = " .. _uid)
	YRP.msg( "db", "shop_item_edit_price: " .. db_worked(_new) )
end)

util.AddNetworkString( "shop_item_edit_level" )
net.Receive( "shop_item_edit_level", function(len, ply)
	local _uid = net.ReadString()
	local _new_level = net.ReadString()
	local _catID = net.ReadString()
	local _new = YRP_SQL_UPDATE(DATABASE_NAME, {["int_level"] = _new_level}, "uniqueID = " .. _uid)
	YRP.msg( "db", "shop_item_edit_level: " .. db_worked(_new) )
end)

util.AddNetworkString( "shop_item_edit_quan" )
net.Receive( "shop_item_edit_quan", function(len, ply)
	local _uid = net.ReadString()
	local _new_quan = net.ReadString()
	local _catID = net.ReadString()
	local _new = YRP_SQL_UPDATE(DATABASE_NAME, {["quantity"] = _new_quan}, "uniqueID = " .. _uid)
	YRP.msg( "db", "shop_item_edit_quan: " .. db_worked(_new) )
end)

util.AddNetworkString( "shop_item_edit_cool" )
net.Receive( "shop_item_edit_cool", function(len, ply)
	local _uid = net.ReadString()
	local _new_cool = net.ReadString()
	local _catID = net.ReadString()
	local _new = YRP_SQL_UPDATE(DATABASE_NAME, {["cooldown"] = _new_cool}, "uniqueID = " .. _uid)
	YRP.msg( "db", "shop_item_edit_cool: " .. db_worked(_new) )
end)

util.AddNetworkString( "shop_item_edit_lice" )
net.Receive( "shop_item_edit_lice", function(len, ply)
	local _uid = net.ReadString()
	local _new_lice = net.ReadString()
	local _catID = net.ReadString()
	local _new = YRP_SQL_UPDATE(DATABASE_NAME, {["licenseID"] = _new_lice}, "uniqueID = " .. _uid)
	YRP.msg( "db", "shop_item_edit_lice: " .. db_worked(_new) )
	local _test = YRP_SQL_SELECT(DATABASE_NAME, "licenseID", "uniqueID = " .. _uid)
end)

util.AddNetworkString( "shop_item_edit_perm" )
net.Receive( "shop_item_edit_perm", function(len, ply)
	local _uid = net.ReadString()
	local _new_perm = net.ReadString()
	local _catID = net.ReadString()
	local _new = YRP_SQL_UPDATE(DATABASE_NAME, {["permanent"] = _new_perm}, "uniqueID = " .. _uid)
	YRP.msg( "db", "shop_item_edit_perm: " .. db_worked(_new) )
end)

util.AddNetworkString( "shop_get_items_storage" )
net.Receive( "shop_get_items_storage", function(len, ply)
	local _uid = net.ReadString()
	local _cha_perm = YRP_SQL_SELECT( "yrp_characters", "storage", "uniqueID = '" .. ply:CharID() .. "'" )

	if _cha_perm ~= nil and _cha_perm ~= false then
		_cha_perm = _cha_perm[1].storage
		_cha_perm = string.Explode( ",", _cha_perm)
		local _nw = {}

		for i, item in pairs(_cha_perm) do
			local _item = YRP_SQL_SELECT(DATABASE_NAME, "*", "categoryID = '" .. _uid .. "' AND uniqueID = '" .. item .. "'" )

			if _item ~= nil and _item ~= false then
				table.insert(_nw, _item[1])
			end
		end

		net.Start( "shop_get_items_storage" )
		net.WriteTable(_nw)
		net.Send(ply)
	end
end)

util.AddNetworkString( "yrp_shop_get_items" )
net.Receive( "yrp_shop_get_items", function(len, ply)
	local _uid = net.ReadString()
	local _items = YRP_SQL_SELECT(DATABASE_NAME, "*", "categoryID = '" .. _uid .. "'" )
	local _nw = {}

	if _items ~= nil then
		_nw = _items
	end

	net.Start( "yrp_shop_get_items" )
		net.WriteString(_uid)
		net.WriteTable(_nw)
	net.Send(ply)
end)

util.AddNetworkString( "shop_item_edit_base" )
net.Receive( "shop_item_edit_base", function(len, ply)
	local _uid = net.ReadString()
	local _wm = net.ReadString()
	local _cn = net.ReadString()
	local _pn = net.ReadString()
	local _type = net.ReadString()

	local _new = YRP_SQL_UPDATE(DATABASE_NAME, {
		["WorldModel"] = _wm,
		["ClassName"] = _cn,
		["PrintName"] = _pn,
		["type"] = _type
	}, "uniqueID = " .. _uid)

	YRP.msg( "db", "shop_item_edit_base: " .. db_worked(_new) )
end)

function SpawnVehicle(item, pos, ang)
	YRP.msg( "gm", "SpawnVehicle( " .. tostring(item) .. ", " .. tostring(pos) .. ", " .. tostring( ang) .. " )" )
	local vehicles = get_all_vehicles()
	local vehicle = {}
	local _custom = ""

	for k, v in pairs( vehicles) do
		if v.ClassName == item.ClassName and v.PrintName == item.PrintName and v.WorldModel == item.WorldModel then
			_custom = v.Custom
			vehicle = v

			if v.Custom == "simfphys" then
				YRP.msg( "gm", "[SpawnVehicle] simfphys vehicle" )
				local spawnname = item.ClassName
				local _vehicle = list.Get( "simfphys_vehicles" )[spawnname]
				local car = simfphys.SpawnVehicleSimple( v.ClassName, pos, ang)
				car.Offset = vehicle.Offset or 0

				timer.Simple(0.2, function()
					if simfphys ~= nil and simfphys.RegisterEquipment ~= nil then
						YRP.msg( "gm", "[SpawnVehicle] -> simfphys armored vehilce" )
						simfphys.RegisterEquipment( car)
					end
				end)

				car.Custom = "simfphys"

				return car
			end

			break
		end
	end

	if vehicle.ClassName ~= nil then
		local car = ents.Create( vehicle.ClassName)
		if not car then return end
		car:SetModel( vehicle.WorldModel)

		if vehicle.Skin ~= "-1" then
			car:SetSkin( vehicle.Skin)
		end

		if vehicle.KeyValues then
			for k, v in pairs( vehicle.KeyValues) do
				car:SetKeyValue(k, v)
			end
		end

		car.ClassOverride = Class
		car.Offset = vehicle.Offset or 0
		--car:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		car.Custom = _custom

		return car
	else
		YRP.msg( "note", "[SpawnVehicle] vehicle not available anymore" )

		return NULL
	end
end

function YRPSpawnItem(ply, item, duid)
	ClassName = item.ClassName -- fix for WAC addons, dumb!

	if item.type == "weapons" then
		local wep = ply:Give(item.ClassName)
		if wk(wep) and wep != NULL then
			wep:SetYRPInt( "item_uniqueID", item.uniqueID)
			wep:SetYRPEntity( "yrp_owner", ply)
			return true
		else
			for i, ws in pairs( engine.GetAddons() ) do
				if ws.wsid == "167545348" then
					YRP.msg( "note", "[Spawn Item] [IMPORTANT] Addon: " .. ws.title .. " is installed, which is overriding the GIVE function" )
					return false
				end
			end
			YRP.msg( "note", "[Spawn Item] Class " .. item.ClassName .. " Give() FAILED ( already have it?)" )
			return false
		end
	end
	
	local hasstorage = false
	local TARGETPOS = nil
	local TARGETANG = Angle(0, 0, 0)

	local mins = Vector(10, 10, 10)
	local maxs = Vector(-10, -10, -10)

	local dist = 10

	local wm = ents.Create( "prop_physics" )
	if IsValid(wm) then
		wm:SetModel(item.WorldModel)

		mins = wm:OBBMins()
		maxs = wm:OBBMaxs()

		dist = math.max(maxs.x - mins.x, maxs.y - mins.y)

		dist = dist + 32
		dist = math.Clamp( dist, 32, 6000)

		wm:Remove()
	end

	local DEALER = YRP_SQL_SELECT( "yrp_dealers", "storagepoints", "uniqueID = '" .. duid .. "'" )
    if wk(DEALER) then
		DEALER = DEALER[1]
		local SPUID = DEALER.storagepoints
		local SP = YRP_SQL_SELECT( "yrp_" .. GetMapNameDB(), "*", "type = '" .. "Storagepoint" .. "' AND uniqueID = '" .. SPUID .. "'" )
		if wk(SP) then
			SP = SP[1]
			YRP.msg( "gm", "[Spawn Item] Item To Storagepoint" )

			local pos = string.Explode( ",", SP.position)
			TARGETPOS = Vector(pos[1], pos[2], pos[3])

			local ang = string.Explode( ",", SP.angle)
			TARGETANG = Angle( ang[1], ang[2], ang[3])

			hasstorage = true
		end
	end

	if TARGETPOS == nil then
		TARGETPOS = ply:GetPos()
		--YRP.msg( "gm", "[Spawn Item] Item To Player" )
	end

	TARGETPOS = TARGETPOS + Vector(0, 0, 50)

	local foundpos = false
	local ang = Angle(0, 0, 0)
	local tr = util.TraceHull( {
		start = TARGETPOS,
		endpos = TARGETPOS,
		mins = mins,
		maxs = maxs,
		mask = MASK_SHOT_HULL
	} )
	if !tr.Hit then
		foundpos = true
	else
		for i = 0, 315, 45 do
			ang = Angle(0, i, 0)
			local pos = TARGETPOS + ang:Forward() * dist

			tr = util.TraceHull( {
				start = pos,
				endpos = pos,
				mins = mins,
				maxs = maxs,
				mask = MASK_SHOT_HULL
			} )

			if !tr.Hit then
				TARGETPOS = pos
				foundpos = true
				break
			end
		end
	end

	if !foundpos then
		YRP.msg( "note", "[Spawn Item] NOT ENOUGH SPACE? cn: " .. item.ClassName .. " wm: " .. item.WorldModel .. " distance: " .. tostring( dist ) .. " hasstorage: " .. tostring( hasstorage ) )
		return false
	end

	local tr = util.TraceHull( {
		start = TARGETPOS + Vector(0, 0, 40),
		endpos = TARGETPOS - Vector(0, 0, 400),
		mins = mins,
		maxs = maxs,
		mask = MASK_SHOT_HULL
	} )

	if tr.Hit then
		local ent = nil

		local ENT = scripted_ents.GetStored(item.ClassName)
		if ENT != nil then
			if ENT.t != nil and ENT.t.SpawnFunction != nil then
				ent = ENT.t:SpawnFunction(ply, tr, item.ClassName)

				if ent then
					--ent:SetOwner(ply)
					ent:SetYRPEntity( "yrp_owner", ply)
					ent:Activate()

					ent:SetAngles(TARGETANG)
					if !hasstorage then
						ent:SetPos(ply:GetPos() + ply:GetForward() * 64 + ply:GetUp() * 64)
					end

					ent:SetYRPInt( "item_uniqueID", item.uniqueID )

					--YRP.msg( "gm", "[Spawn Item] WORKED #1" )

					return true, ent
				else
					return false, NULL
				end
			else
				ent = ents.Create(item.ClassName)
				if IsValid(ent) then
					ent:SetPos(tr.HitPos)

					--ent:SetOwner(ply)
					ent:SetYRPEntity( "yrp_owner", ply)

					ent:Spawn()
					ent:Activate()

					ent:SetAngles(TARGETANG)
					if !hasstorage then
						ent:SetPos(ply:GetPos() + ply:GetForward() * 64 + ply:GetUp() * 64)
					end
					
					ent:SetYRPInt( "item_uniqueID", item.uniqueID )

					--YRP.msg( "gm", "[Spawn Item] WORKED #2" )
					return true, ent
				else
					YRP.msg( "note", "[Spawn Item] Not valid #1: " .. item.ClassName)
					return false
				end
			end
		else
			local vehicle = list.Get( "simfphys_vehicles" )[ item.ClassName ]
			if vehicle then
				ent = simfphys.SpawnVehicle(nil, tr.HitPos + Vector(0, 0, 0), Angle(0, 0, 0), vehicle.Model, vehicle.Class, item.ClassName, vehicle, true)

				ent:SetYRPInt( "item_uniqueID", item.uniqueID)

				--YRP.msg( "gm", "[Spawn Item] WORKED #3" )

				--ent:SetOwner(ply)
				ent:SetYRPEntity( "yrp_owner", ply)

				ent:Activate()

				ent:SetAngles(TARGETANG)

				return true, ent
			else
				ent = ents.Create(item.ClassName)
				if IsValid(ent) then
					local veh = nil
					for i, v in pairs(list.Get( "Vehicles" ) ) do
						if v.Model == item.WorldModel then
							veh = v
						end
					end

					if veh != nil then
						if veh.KeyValues != nil then
							for i, v in pairs( veh.KeyValues) do
								ent:SetKeyValue(i, v)
							end
						end
					end

					ent:SetModel(item.WorldModel)
					ent:SetPos(tr.HitPos)
					
					ent:Spawn()
					ent:Activate()

					ent:SetAngles(TARGETANG)

					ent:SetYRPInt( "item_uniqueID", item.uniqueID)
			
					--YRP.msg( "gm", "[Spawn Item] WORKED #4" )

					--ent:SetOwner(ply)
					ent:SetYRPEntity( "yrp_owner", ply)

					return true, ent
				else
					YRP.msg( "note", "[Spawn Item] Not valid #2: " .. item.ClassName)
					return false
				end
			end
		end

		if ea(ent) and TARGETANG then
			ent:SetAngles(TARGETANG)
		end
	else
		YRP.msg( "note", "[Spawn Item] Not enough space for item, cn: " .. item.ClassName .. " distance: " .. tostring( dist ) .. " hasstorage: " .. tostring( hasstorage ) )
	end
	YRP.msg( "note", "[Spawn Item] FAILED! " .. item.ClassName)
	return false
end

util.AddNetworkString( "item_buy" )
net.Receive( "item_buy", function(len, ply)
	local _tab = net.ReadTable()
	local _dealer_uid = net.ReadString()
	local _item = YRP_SQL_SELECT(DATABASE_NAME, "*", "uniqueID = " .. _tab.uniqueID)

	if wk(_item) then
		_item = _item[1]
		_item.name = tostring(_item.name)

		if ply:GetYRPFloat( "buy_ts", 0.0) > CurTime() then
			YRP.msg( "note", "[item_buy] On Cooldown" )
			return
		end

		if ply:canAfford(tonumber(_item.price) ) then
			YRP.msg( "gm", ply:YRPName() .. " buyed " .. _item.name)

			timer.Simple( 0.3, function()
				YRPPlyUpdateStorage( ply )
			end )

			if _item.type == "licenses" then
				ply:AddLicense(_item.ClassName)
				ply:SetYRPInt( "licenseIDsVersion", ply:GetYRPInt( "licenseIDsVersion", 0 ) + 1 )
			elseif _item.type == "roles" then
				local rid = _item.ClassName
				YRPRemRolVals(ply)
				YRPRemGroVals(ply)
				YRPSetRole(ply, rid, true)
			else
				local _spawned, ent = YRPSpawnItem(ply, _item, _dealer_uid)

				if _spawned then
					if ea(ent) then
						ent:SetYRPInt( "item_uniqueID", _item.uniqueID)
						if _tab.color then
							ent:SetColor( StringToColor(_tab.color) )
						end
						if ent:IsVehicle() then
							AddVehicle(ent, ply, _item)
						end
					end

					ply:SetYRPFloat( "buy_ts", CurTime() + 2)
				else
					YRP.msg( "note", "Failed to spawn item from shop, spawned: " .. tostring(_spawned) )
					return false
				end
			end

			if tonumber(_item.permanent) == 1 then
				local _cha = ply:YRPGetCharacterTable()
				local _stor = string.Explode( ",", _cha.storage)

				for i, item in pairs(_stor) do
					if item == "" then
						table.RemoveByValue(_stor, "" )
					end
				end

				if not table.HasValue(_stor, _item.uniqueID) then
					table.insert(_stor, _item.uniqueID)
				end

				_stor = string.Implode( ",", _stor)
				local _result = YRP_SQL_UPDATE( "yrp_characters", {["storage"] = _stor}, "uniqueID = '" .. ply:CharID() .. "'" )
			end

			-- Remove money if everything works
			ply:addMoney(-tonumber(_item.price) )
		end
	end
end)

util.AddNetworkString( "item_spawn" )
net.Receive( "item_spawn", function(len, ply)
	local _tab = net.ReadTable()
	local _dealer_uid = net.ReadString()

	if wk(_tab) and wk(_dealer_uid) then
		local _item = YRP_SQL_SELECT(DATABASE_NAME, "*", "uniqueID = " .. _tab.uniqueID)

		if wk(_item) then
			_item = _item[1]

			if not IsEntityAlive(ply, _item.uniqueID) then
				local _spawned, ent = YRPSpawnItem(ply, _item, _dealer_uid)

				if _spawned then
					if ea(ent) then
						ent:SetYRPInt( "item_uniqueID", _item.uniqueID)
						if ent:IsVehicle() then
							AddVehicle(ent, ply, _item)
						end
					else
						YRP.msg( "note", "[item_spawn] Item not alive/valid." )
					end
				end
			end
		end
	end
end)

util.AddNetworkString( "item_despawn" )
net.Receive( "item_despawn", function(len, ply)
	local _tab = net.ReadTable()
	local _item = YRP_SQL_SELECT(DATABASE_NAME, "*", "uniqueID = " .. _tab.uniqueID)

	if _item ~= nil then
		_item = _item[1]
		local _alive, ent = IsEntityAlive(ply, _item.uniqueID)
		if _alive and ea(ent) then
			ent:Remove()
		end
	end
end)

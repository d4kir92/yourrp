--Copyright (C) 2017-2018 Arno Zura ( https://www.gnu.org/licenses/gpl.txt )

-- DO NOT TOUCH THE DATABASE FILES! If you have errors, report them here:
-- https://discord.gg/sEgNZxg

local _db_name = "yrp_shop_items"

SQL_ADD_COLUMN( _db_name, "name", "TEXT DEFAULT 'UNNAMED'" )
SQL_ADD_COLUMN( _db_name, "description", "TEXT DEFAULT 'UNNAMED'" )
SQL_ADD_COLUMN( _db_name, "price", "TEXT DEFAULT '100'" )
SQL_ADD_COLUMN( _db_name, "categoryID", "INT DEFAULT -1" )
SQL_ADD_COLUMN( _db_name, "quantity", "INT DEFAULT -1" )
SQL_ADD_COLUMN( _db_name, "cooldown", "INT DEFAULT -1" )
SQL_ADD_COLUMN( _db_name, "licenseID", "INT DEFAULT -1" )
SQL_ADD_COLUMN( _db_name, "permanent", "INT DEFAULT 0" )
SQL_ADD_COLUMN( _db_name, "type", "TEXT DEFAULT 'weapons'" )
SQL_ADD_COLUMN( _db_name, "ClassName", "TEXT DEFAULT 'weapon_crowbar'" )
SQL_ADD_COLUMN( _db_name, "PrintName", "TEXT DEFAULT 'unnamed item'" )
SQL_ADD_COLUMN( _db_name, "WorldModel", "TEXT DEFAULT ' '" )

--db_drop_table( _db_name )
--db_is_empty( _db_name )

util.AddNetworkString( "get_shop_items" )

function send_shop_items( ply, uid )
	local _s_items = SQL_SELECT( _db_name, "*", "categoryID = " .. uid )

	local _nw = _s_items
	if _nw == nil then
		_nw = {}
	end

	net.Start( "get_shop_items" )
		net.WriteTable( _nw )
	net.Send( ply )
end

net.Receive( "get_shop_items", function( len, ply )
	local _catID = net.ReadString()

	send_shop_items( ply, _catID )
end)

util.AddNetworkString( "shop_item_add" )

net.Receive( "shop_item_add", function( len, ply )
	local _catID = net.ReadString()
	local _new = SQL_INSERT_INTO( _db_name, "categoryID", _catID )
	printGM( "db", "shop_item_add: " .. db_worked( _new ) )

	send_shop_items( ply, _catID )
end)

util.AddNetworkString( "shop_item_rem" )

net.Receive( "shop_item_rem", function( len, ply )
	local _uid = net.ReadString()
	local _catID = net.ReadString()
	local _new = SQL_DELETE_FROM( _db_name, "uniqueID = " .. _uid )
	printGM( "db", "shop_item_rem: " .. db_worked( _new ) )

	send_shop_items( ply, _catID )
end)

util.AddNetworkString( "shop_item_edit_name" )

net.Receive( "shop_item_edit_name", function( len, ply )
	local _uid = net.ReadString()
	local _new_name = net.ReadString()
	local _catID = net.ReadString()
	local _new = SQL_UPDATE( _db_name, "name = '" .. SQL_STR_IN( _new_name ) .. "'", "uniqueID = " .. _uid )
	printGM( "db", "shop_item_edit_name: " .. db_worked( _new ) )
end)

util.AddNetworkString( "shop_item_edit_desc" )

net.Receive( "shop_item_edit_desc", function( len, ply )
	local _uid = net.ReadString()
	local _new_desc = net.ReadString()
	local _catID = net.ReadString()
	local _new = SQL_UPDATE( _db_name, "description = '" .. SQL_STR_IN( _new_desc ) .. "'", "uniqueID = " .. _uid )
	printGM( "db", "shop_item_edit_desc: " .. db_worked( _new ) )
end)

util.AddNetworkString( "shop_item_edit_price" )

net.Receive( "shop_item_edit_price", function( len, ply )
	local _uid = net.ReadString()
	local _new_price = net.ReadString()
	local _catID = net.ReadString()
	local _new = SQL_UPDATE( _db_name, "price = '" .. SQL_STR_IN( _new_price ) .. "'", "uniqueID = " .. _uid )
	printGM( "db", "shop_item_edit_price: " .. db_worked( _new ) )
end)

util.AddNetworkString( "shop_item_edit_quan" )

net.Receive( "shop_item_edit_quan", function( len, ply )
	local _uid = net.ReadString()
	local _new_quan = net.ReadString()
	local _catID = net.ReadString()
	local _new = SQL_UPDATE( _db_name, "quantity = '" .. _new_quan .. "'", "uniqueID = " .. _uid )
	printGM( "db", "shop_item_edit_quan: " .. db_worked( _new ) )
end)

util.AddNetworkString( "shop_item_edit_cool" )

net.Receive( "shop_item_edit_cool", function( len, ply )
	local _uid = net.ReadString()
	local _new_cool = net.ReadString()
	local _catID = net.ReadString()
	local _new = SQL_UPDATE( _db_name, "cooldown = '" .. SQL_STR_IN( _new_cool ) .. "'", "uniqueID = " .. _uid )
	printGM( "db", "shop_item_edit_cool: " .. db_worked( _new ) )
end)

util.AddNetworkString( "shop_item_edit_lice" )

net.Receive( "shop_item_edit_lice", function( len, ply )
	local _uid = net.ReadString()
	local _new_lice = net.ReadString()
	local _catID = net.ReadString()
	local _new = SQL_UPDATE( _db_name, "licenseID = '" .. _new_lice .. "'", "uniqueID = " .. _uid )
	printGM( "db", "shop_item_edit_lice: " .. db_worked( _new ) )
	local _test = SQL_SELECT( _db_name, "licenseID", "uniqueID = " .. _uid)

end)

util.AddNetworkString( "shop_item_edit_perm" )

net.Receive( "shop_item_edit_perm", function( len, ply )
	local _uid = net.ReadString()
	local _new_perm = net.ReadString()
	local _catID = net.ReadString()
	local _new = SQL_UPDATE( _db_name, "permanent = '" .. SQL_STR_IN( _new_perm ) .. "'", "uniqueID = " .. _uid )
	printGM( "db", "shop_item_edit_perm: " .. db_worked( _new ) )
end)

util.AddNetworkString( "shop_get_items_storage" )

net.Receive( "shop_get_items_storage", function( len, ply )
	local _uid = net.ReadString()
	local _cha_perm = SQL_SELECT( "yrp_characters", "storage", "uniqueID = '" .. ply:CharID() .. "'" )
	if _cha_perm != nil and _cha_perm != false then
		_cha_perm = _cha_perm[1].storage
		_cha_perm = string.Explode( ",", _cha_perm )

		local _nw = {}
		for i, item in pairs( _cha_perm ) do
			local _item = SQL_SELECT( _db_name, "*", "categoryID = '" .. _uid .. "' AND uniqueID = '" .. item .. "'" )
			if _item != nil and _item != false then
				table.insert( _nw, _item[1] )
			end
		end

		if _items != nil then
			_nw = _items
		end

		net.Start( "shop_get_items_storage" )
			net.WriteTable( _nw )
		net.Send( ply )
	end
end)

util.AddNetworkString( "shop_get_items" )

net.Receive( "shop_get_items", function( len, ply )
	local _uid = net.ReadString()
	local _items = SQL_SELECT( _db_name, "*", "categoryID = '" .. _uid .. "'")
	local _nw = {}
	if _items != nil then
		_nw = _items
	end

	net.Start( "shop_get_items" )
		net.WriteTable( _nw )
	net.Send( ply )
end)

util.AddNetworkString( "shop_item_edit_base" )

net.Receive( "shop_item_edit_base", function( len, ply )
	local _uid = net.ReadString()
	local _wm = net.ReadString()
	local _cn = net.ReadString()
	local _pn = net.ReadString()
	local _type = net.ReadString()

	local _new = SQL_UPDATE( _db_name, "WorldModel = '" .. _wm .. "', ClassName = '" .. _cn .. "', PrintName = '" .. _pn .. "', type = '" .. _type .. "'", "uniqueID = " .. _uid )
	printGM( "db", "shop_item_edit_base: " .. db_worked( _new ) )
end)

function SpawnVehicle( item, pos, ang )
	printGM( "gm", "SpawnVehicle( " .. tostring( item ) .. ", " .. tostring( pos ) .. ", " .. tostring( ang ) .. " )" )
	local vehicles = get_all_vehicles()
	local vehicle = {}
	local _custom = ""
	for k, v in pairs( vehicles ) do
		if v.ClassName == item.ClassName and v.PrintName == item.PrintName and v.WorldModel == item.WorldModel then
			_custom = v.Custom
			vehicle = v
			if v.Custom == "simfphys" then
				printGM( "gm", "[SpawnVehicle] simfphys vehicle" )
				local spawnname = item.ClassName
				local _vehicle = list.Get( "simfphys_vehicles" )[ spawnname ]

				local car = simfphys.SpawnVehicleSimple( v.ClassName, pos, ang )
				car.Offset = vehicle.Offset or 0

				timer.Simple( 0.2, function()
					if simfphys != nil then
						if simfphys.RegisterEquipment != nil then
							printGM( "gm", "[SpawnVehicle] -> simfphys armored vehilce" )
							simfphys.RegisterEquipment( car )
						end
					end
				end)
				car.Custom = "simfphys"
				return car
			end
			break
		end
	end
	if vehicle.ClassName != nil then
		local car = ents.Create( vehicle.ClassName )
		if not car then return end
		car:SetModel( vehicle.WorldModel )
		if	vehicle.Skin != "-1" then
			car:SetSkin( vehicle.Skin )
		end
		if vehicle.KeyValues then
			for k, v in pairs( vehicle.KeyValues ) do
				car:SetKeyValue( k, v )
			end
		end

		car.ClassOverride = Class
		car.Offset = vehicle.Offset or 0
		--car:SetCollisionGroup(COLLISION_GROUP_WEAPON)

		car.Custom = _custom

		return car
	else
		printGM( "note", "[SpawnVehicle] vehicle not available anymore" )
		return NULL
	end
end

util.AddNetworkString( "yrp_info2" )

function spawnItem( ply, item, duid )
	local _distSpace = 8
	local _distMax = 2000
	local _angle = Angle( 0, ply:EyeAngles().p, 0 )
	local ent = {}
	local _pos_end = ply:GetPos()
	if item.type == "vehicles" then
		local _sps = SQL_SELECT( "yrp_dealers", "storagepoints", "uniqueID = '" .. duid .. "'" )
		if _sps != nil and _sps != false then
			_sps = _sps[1].storagepoints
			local _storagepoint = SQL_SELECT( "yrp_" .. GetMapNameDB(), "*", "type = '" .. "Storagepoint" .. "' AND uniqueID = '" .. _sps .. "'" )
			if _storagepoint != nil and _storagepoint != false then
				_storagepoint = _storagepoint[1]
				local _ang = string.Explode( ",", _storagepoint.angle )
				_angle = Angle( 0, _ang[2], 0 )
				local _pos = string.Explode( ",", _storagepoint.position )
				_position = Vector( _pos[1], _pos[2], _pos[3] )
				_pos_end = _position
			end
		end

		ent = SpawnVehicle( item, _pos_end, _angle )

		if !ent:IsValid() then
			printGM( "note", "[spawnItem] Vehicle is not valid: Vehicle not exists anymore on server!" )
			return "ent isnt valid"
		end

		local newVehicle = SQL_INSERT_INTO( "yrp_vehicles", "ClassName, ownerCharID, item_id", "'" .. db_sql_str( item.ClassName ) .. "', '" .. ply:CharID() .. "', '" .. item.uniqueID .. "'" )
		ent:SetNWString( "item_uniqueID", item.uniqueID )
		ent:SetNWString( "ownerRPName", ply:RPName() )
		ent.yrpowner = ply
	elseif item.type != "weapons" then
		ent = ents.Create( item.ClassName )
		if ent == NULL then return end
		ent:SetNWString( "item_uniqueID", item.uniqueID )
		ent:SetNWString( "ownerRPName", ply:RPName() )
		ent:SetOwner( ply )
		ent:SetCreator( ply )
	end

	if item.type == "weapons" then
		ent = ply:Give( item.ClassName )
		ent:YRPSetOwner( ply )
		return true
	else
		ent:YRPSetOwner( ply )

		local _sps = SQL_SELECT( "yrp_dealers", "storagepoints", "uniqueID = '" .. duid .. "'" )
		if _sps != nil and _sps != false then
			_sps = _sps[1].storagepoints
			local _storagepoint = SQL_SELECT( "yrp_" .. GetMapNameDB(), "*", "type = '" .. "Storagepoint" .. "' AND uniqueID = '" .. _sps .. "'" )
			if _storagepoint != nil and _storagepoint != false then
				_storagepoint = _storagepoint[1]
				printGM( "gm", "[spawnItem] Item To Storagepoint" )

				--[[ Position ]]--
				local _pos = string.Explode( ",", _storagepoint.position )
				local _edit = Vector( 0, 0, math.abs( ent:OBBMins().z ) ) + Vector( 0, 0, 4 )

				local _height = Vector( 0, 0, 14 )
				if item.type == "vehicles" then
					if ent.Custom != nil then
						if string.lower( ent.Custom ) == "scars" then
							_height = Vector( 0, 0, 24 )
						end
					end
				end

				_pos = Vector( _pos[1], _pos[2], _pos[3] ) + _edit + _height

				_pos_end = _pos

				ent:SetPos( _pos_end )

				--[[ Angle ]]--
				if ent.Custom != "simfphys" then
					local _ang = string.Explode( ",", _storagepoint.angle )
					_ang = Angle( 0, _ang[2], 0 )
					ent:SetAngles( _ang )
				end

				local _mins = ent:OBBMins() + _edit
				local _maxs = ent:OBBMaxs() + _edit
				local tr = {
					start = _pos,
					endpos = _pos,
					mins = _mins,
					maxs = _maxs,
					filter = {ent, ent:GetChildren() }
				}
				local hullTrace = util.TraceHull( tr )
				if hullTrace.Hit then
					printGM( "note", "[spawnItem] NOT ENOUGH SPACE" )
					net.Start( "yrp_info2" )
						net.WriteString( "notenoughspace" )
						net.WriteString( "(" .. tostring( hullTrace.Entity ) .. ")" )
					net.Send( ply )
					ent:Remove()
					return false
				end
				if ent.Custom != "simfphys" then
					local tr = util.TraceHull( {
						start = _pos_end + Vector( 0, 0, 128 ),
						endpos = _pos_end - Vector( 0, 0, 128 ),
						maxs = maxs,
						mins = mins,
						filter = ent
					} )
					if ent.SpawnFunction != nil then
						ent:SpawnFunction( ply, tr, ent:GetClass() )
					else
						ent:Spawn()
					end
					ent:Activate()
					ent:SetPos( _pos_end )
				end
				return true
			end
		end

		printGM( "gm", "[spawnItem] Item To Player" )
		_angle = ply:EyeAngles()
		ent:SetPos( ply:GetPos() + Vector( 0, 0, math.abs( ent:OBBMins().z ) ) + Vector( 0, 0, 32 ) )
		for dist = 0, _distMax, _distSpace do
			for ang = 0, 360, 45 do
				if ang != 0 then
					_angle = _angle + Angle( 0, 45, 0 )
				end
				local tr = {}
				tr.start = ent:GetPos() + _angle:Forward() * dist
				tr.endpos = ent:GetPos() + _angle:Forward() * dist
				tr.filter = ent
				tr.mins = ent:OBBMins()*1.1 --1.1 because so that no one get stuck
				tr.maxs = ent:OBBMaxs()*1.1 --1.1 because so that no one get stuck
				tr.mask = MASK_SHOT_HULL

				local _result = util.TraceHull( tr )
				if !_result.Hit then
					_pos_end = ent:GetPos() + _angle:Forward() * dist
					ent:SetPos( _pos_end )
					if item.type == "vehicles" then
						--ent:SetVelocity( Vector( 0, 0, -500 ) )
					else
						printGM( "gm", "[spawnItem] Spawn Item" )
						local tr = util.TraceHull( {
							start = _pos_end + Vector( 0, 0, 128 ),
							endpos = _pos_end - Vector( 0, 0, 128 ),
							maxs = maxs,
							mins = mins,
							filter = ent
						} )
						if ent.SpawnFunction != nil then
							ent:SpawnFunction( ply, tr, ent:GetClass() )
						else
							ent:Spawn()
						end
						ent:Activate()
						ent:SetPos( _pos_end )
					end
					printGM( "gm", "[spawnItem] Enough Space" )
					return true
				end
			end
		end
		printGM( "note", "[spawnItem] Not Enough Space" )
		return false
	end
end

util.AddNetworkString( "item_buy" )

net.Receive( "item_buy", function( len, ply )
	local _tab = net.ReadTable()
	local _dealer_uid = net.ReadString()

	local _item = SQL_SELECT( _db_name, "*", "uniqueID = " .. _tab.uniqueID )
	if _item != nil then
		_item = _item[1]
		if ply:canAfford( tonumber( _item.price ) ) then
			printGM( "gm", ply:YRPName() .. " buyed " .. tostring( _item.name ) )

			if _item.type == "licenses" then
				ply:AddLicense( _item.ClassName )
				ply:addMoney( -tonumber( _item.price ) )
			else
				local _spawned = spawnItem( ply, _item, _dealer_uid )
				if _spawned then
					ply:addMoney( -tonumber( _item.price ) )
				else
					return false
				end
			end
			if tonumber( _item.permanent ) == 1 then
				local _cha = ply:GetChaTab()
				local _stor = string.Explode( ",", _cha.storage )
				for i, item in pairs( _stor ) do
					if item == "" then
						table.RemoveByValue( _stor, "" )
					end
				end
				if !table.HasValue( _stor, _item.uniqueID ) then
					table.insert( _stor, _item.uniqueID )
				end
				_stor = string.Implode( ",", _stor )
				local _result = SQL_UPDATE( "yrp_characters", "storage = '" .. _stor .. "'", "uniqueID = '" .. ply:CharID() .. "'" )
			end
		end
	end
end)

util.AddNetworkString( "item_spawn" )

net.Receive( "item_spawn", function( len, ply )
	local _tab = net.ReadTable()
	local _dealer_uid = net.ReadString()

	if wk( _tab ) and wk( _dealer_uid ) then
		local _item = SQL_SELECT( _db_name, "*", "uniqueID = " .. _tab.uniqueID )
		if _item != nil then
			_item = _item[1]
			if !IsEntityAlive( ply, _item.uniqueID ) then
				spawnItem( ply, _item, _dealer_uid )
			end
		end
	end
end)

util.AddNetworkString( "item_despawn" )

net.Receive( "item_despawn", function( len, ply )
	local _tab = net.ReadTable()

	local _item = SQL_SELECT( _db_name, "*", "uniqueID = " .. _tab.uniqueID )
	if _item != nil then
		_item = _item[1]
		local _alive, _ent = IsEntityAlive( ply, _item.uniqueID )
		if _alive then
			_ent:Remove()
		end
	end
end)

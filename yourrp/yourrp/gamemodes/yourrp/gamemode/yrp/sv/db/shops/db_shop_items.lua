--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
-- DO NOT TOUCH THE DATABASE FILES! If you have errors, report them here:
-- https://discord.gg/sEgNZxg
-- #buymenu #shops
local DATABASE_NAME = "yrp_shop_items"
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "name", "TEXT DEFAULT 'UNNAMED'")
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "description", "TEXT DEFAULT 'UNNAMED'")
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "price", "TEXT DEFAULT '100'")
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "int_level", "INT DEFAULT 1")
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "categoryID", "INT DEFAULT -1")
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "quantity", "INT DEFAULT -1")
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "cooldown", "INT DEFAULT -1")
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "licenseID", "INT DEFAULT -1")
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "permanent", "INT DEFAULT 0")
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "type", "TEXT DEFAULT 'weapons'")
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "ClassName", "TEXT DEFAULT 'weapon_crowbar'")
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "PrintName", "TEXT DEFAULT 'unnamed item'")
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "WorldModel", "TEXT DEFAULT ''")
util.AddNetworkString("nws_yrp_get_shop_items")
function send_shop_items(ply, uid)
	local _s_items = YRP_SQL_SELECT(DATABASE_NAME, "*", "categoryID = " .. uid)
	local _nw = _s_items
	if _nw == nil then
		_nw = {}
	end

	net.Start("nws_yrp_get_shop_items")
	net.WriteTable(_nw)
	net.Send(ply)
end

net.Receive(
	"nws_yrp_get_shop_items",
	function(len, ply)
		local _catID = net.ReadString()
		send_shop_items(ply, _catID)
	end
)

util.AddNetworkString("nws_yrp_shop_item_add")
net.Receive(
	"nws_yrp_shop_item_add",
	function(len, ply)
		local _catID = net.ReadString()
		local _new = YRP_SQL_INSERT_INTO(DATABASE_NAME, "categoryID", _catID)
		YRP.msg("db", "shop_item_add: " .. db_WORKED(_new))
		send_shop_items(ply, _catID)
	end
)

util.AddNetworkString("nws_yrp_shop_item_rem")
net.Receive(
	"nws_yrp_shop_item_rem",
	function(len, ply)
		local _uid = net.ReadString()
		local _catID = net.ReadString()
		local _new = YRP_SQL_DELETE_FROM(DATABASE_NAME, "uniqueID = " .. _uid)
		YRP.msg("db", "shop_item_rem: " .. db_WORKED(_new))
		send_shop_items(ply, _catID)
	end
)

util.AddNetworkString("nws_yrp_shop_item_edit_name")
net.Receive(
	"nws_yrp_shop_item_edit_name",
	function(len, ply)
		local _uid = net.ReadString()
		local _new_name = net.ReadString()
		local _catID = net.ReadString()
		local _new = YRP_SQL_UPDATE(
			DATABASE_NAME,
			{
				["name"] = _new_name
			}, "uniqueID = " .. _uid
		)

		YRP.msg("db", "shop_item_edit_name: " .. db_WORKED(_new))
	end
)

util.AddNetworkString("nws_yrp_shop_item_edit_desc")
net.Receive(
	"nws_yrp_shop_item_edit_desc",
	function(len, ply)
		local _uid = net.ReadString()
		local _new_desc = net.ReadString()
		local _catID = net.ReadString()
		local _new = YRP_SQL_UPDATE(
			DATABASE_NAME,
			{
				["description"] = _new_desc
			}, "uniqueID = " .. _uid
		)

		YRP.msg("db", "shop_item_edit_desc: " .. db_WORKED(_new))
	end
)

util.AddNetworkString("nws_yrp_shop_item_edit_price")
net.Receive(
	"nws_yrp_shop_item_edit_price",
	function(len, ply)
		local _uid = net.ReadString()
		local _new_price = net.ReadString()
		local _catID = net.ReadString()
		local _new = YRP_SQL_UPDATE(
			DATABASE_NAME,
			{
				["price"] = _new_price
			}, "uniqueID = " .. _uid
		)

		YRP.msg("db", "shop_item_edit_price: " .. db_WORKED(_new))
	end
)

util.AddNetworkString("nws_yrp_shop_item_edit_level")
net.Receive(
	"nws_yrp_shop_item_edit_level",
	function(len, ply)
		local _uid = net.ReadString()
		local _new_level = net.ReadString()
		local _catID = net.ReadString()
		local _new = YRP_SQL_UPDATE(
			DATABASE_NAME,
			{
				["int_level"] = _new_level
			}, "uniqueID = " .. _uid
		)

		YRP.msg("db", "shop_item_edit_level: " .. db_WORKED(_new))
	end
)

util.AddNetworkString("nws_yrp_shop_item_edit_quan")
net.Receive(
	"nws_yrp_shop_item_edit_quan",
	function(len, ply)
		local _uid = net.ReadString()
		local _new_quan = net.ReadString()
		local _catID = net.ReadString()
		local _new = YRP_SQL_UPDATE(
			DATABASE_NAME,
			{
				["quantity"] = _new_quan
			}, "uniqueID = " .. _uid
		)

		YRP.msg("db", "shop_item_edit_quan: " .. db_WORKED(_new))
	end
)

util.AddNetworkString("nws_yrp_shop_item_edit_cool")
net.Receive(
	"nws_yrp_shop_item_edit_cool",
	function(len, ply)
		local _uid = net.ReadString()
		local _new_cool = net.ReadString()
		local _catID = net.ReadString()
		local _new = YRP_SQL_UPDATE(
			DATABASE_NAME,
			{
				["cooldown"] = _new_cool
			}, "uniqueID = " .. _uid
		)

		YRP.msg("db", "shop_item_edit_cool: " .. db_WORKED(_new))
	end
)

util.AddNetworkString("nws_yrp_shop_item_edit_lice")
net.Receive(
	"nws_yrp_shop_item_edit_lice",
	function(len, ply)
		local _uid = net.ReadString()
		local _new_lice = net.ReadString()
		local _catID = net.ReadString()
		local _new = YRP_SQL_UPDATE(
			DATABASE_NAME,
			{
				["licenseID"] = _new_lice
			}, "uniqueID = " .. _uid
		)

		YRP.msg("db", "shop_item_edit_lice: " .. db_WORKED(_new))
		local _test = YRP_SQL_SELECT(DATABASE_NAME, "licenseID", "uniqueID = " .. _uid)
	end
)

util.AddNetworkString("nws_yrp_shop_item_edit_perm")
net.Receive(
	"nws_yrp_shop_item_edit_perm",
	function(len, ply)
		local _uid = net.ReadString()
		local _new_perm = net.ReadString()
		local _catID = net.ReadString()
		local _new = YRP_SQL_UPDATE(
			DATABASE_NAME,
			{
				["permanent"] = _new_perm
			}, "uniqueID = " .. _uid
		)

		YRP.msg("db", "shop_item_edit_perm: " .. db_WORKED(_new))
	end
)

util.AddNetworkString("nws_yrp_shop_get_items_storage")
net.Receive(
	"nws_yrp_shop_get_items_storage",
	function(len, ply)
		local _uid = net.ReadString()
		local _cha_perm = YRP_SQL_SELECT("yrp_characters", "storage", "uniqueID = '" .. ply:CharID() .. "'")
		if _cha_perm ~= nil and _cha_perm ~= false then
			_cha_perm = _cha_perm[1].storage
			_cha_perm = string.Explode(",", _cha_perm)
			local _nw = {}
			for i, item in pairs(_cha_perm) do
				local _item = YRP_SQL_SELECT(DATABASE_NAME, "*", "categoryID = '" .. _uid .. "' AND uniqueID = '" .. item .. "'")
				if _item ~= nil and _item ~= false then
					table.insert(_nw, _item[1])
				end
			end

			net.Start("nws_yrp_shop_get_items_storage")
			net.WriteTable(_nw)
			net.Send(ply)
		end
	end
)

util.AddNetworkString("nws_yrp_shop_get_items")
net.Receive(
	"nws_yrp_shop_get_items",
	function(len, ply)
		local _uid = net.ReadString()
		local _items = YRP_SQL_SELECT(DATABASE_NAME, "*", "categoryID = '" .. _uid .. "'")
		local _nw = {}
		if _items ~= nil then
			_nw = _items
		end

		for i, v in pairs(_nw) do
			if strEmpty(v.WorldModel) then
				local ent = ents.Create(v.ClassName)
				if YRPEntityAlive(ent) then
					local _, err = pcall(YRPEntSpawn, ent)
					if err then
						YRPMsg(err)
					end

					v.WorldModel = ent:GetModel()
					YRP_SQL_UPDATE(
						DATABASE_NAME,
						{
							["WorldModel"] = v.WorldModel
						}, "uniqueID = '" .. v.uniqueID .. "'"
					)

					ent:Remove()
				end
			end
		end

		net.Start("nws_yrp_shop_get_items")
		net.WriteString(_uid)
		net.WriteTable(_nw)
		net.Send(ply)
	end
)

util.AddNetworkString("nws_yrp_shop_item_edit_base")
net.Receive(
	"nws_yrp_shop_item_edit_base",
	function(len, ply)
		local _uid = net.ReadString()
		local _wm = net.ReadString()
		local _cn = net.ReadString()
		local _pn = net.ReadString()
		local _type = net.ReadString()
		local _new = YRP_SQL_UPDATE(
			DATABASE_NAME,
			{
				["WorldModel"] = _wm,
				["ClassName"] = _cn,
				["PrintName"] = _pn,
				["type"] = _type
			}, "uniqueID = " .. _uid
		)

		YRP.msg("db", "shop_item_edit_base: " .. db_WORKED(_new))
	end
)

function SpawnVehicle(item, pos, ang)
	YRP.msg("gm", "SpawnVehicle( " .. tostring(item) .. ", " .. tostring(pos) .. ", " .. tostring(ang) .. " )")
	local vehicles = get_all_vehicles()
	local vehicle = {}
	local _custom = ""
	for k, v in pairs(vehicles) do
		if v.ClassName == item.ClassName and v.PrintName == item.PrintName and v.WorldModel == item.WorldModel then
			_custom = v.Custom
			vehicle = v
			if v.Custom == "simfphys" then
				YRP.msg("gm", "[SpawnVehicle] simfphys vehicle")
				local spawnname = item.ClassName
				local _vehicle = list.Get("simfphys_vehicles")[spawnname]
				local car = simfphys.SpawnVehicleSimple(v.ClassName, pos, ang)
				car.Offset = vehicle.Offset or 0
				timer.Simple(
					0.2,
					function()
						if simfphys ~= nil and simfphys.RegisterEquipment ~= nil then
							YRP.msg("gm", "[SpawnVehicle] -> simfphys armored vehilce")
							simfphys.RegisterEquipment(car)
						end
					end
				)

				car.Custom = "simfphys"

				return car
			end

			break
		end
	end

	if vehicle.ClassName ~= nil then
		local car = ents.Create(vehicle.ClassName)
		if not car then return end
		car:SetModel(vehicle.WorldModel)
		if vehicle.Skin ~= "-1" then
			car:SetSkin(vehicle.Skin)
		end

		if vehicle.KeyValues then
			for k, v in pairs(vehicle.KeyValues) do
				car:SetKeyValue(k, v)
			end
		end

		car.ClassOverride = Class
		car.Offset = vehicle.Offset or 0
		--car:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		car.Custom = _custom

		return car
	else
		YRP.msg("note", "[SpawnVehicle] vehicle not available anymore")

		return NULL
	end
end

function YRPSpawnItem(ply, item, duid, count, itemColor)
	if item.ClassName == nil then return false end
	if item.type == nil then return false end
	ClassName = item.ClassName -- fix for WAC addons, dumb!
	if item.type == "weapons" then
		if count == 1 and item.ClassName then
			local wep = ply:Give(item.ClassName)
			if IsNotNilAndNotFalse(wep) and wep ~= NULL then
				wep:SetYRPInt("item_uniqueID", item.uniqueID)
				wep:SetYRPEntity("yrp_owner", ply)

				return true
			else
				for i, ws in pairs(engine.GetAddons()) do
					if ws.wsid == "167545348" then
						YRP.msg("note", "[Spawn Item] [IMPORTANT] Addon: " .. ws.title .. " is installed, which is overriding the GIVE function")

						return false
					end
				end
			end
		end

		local shipment = ents.Create("yrp_shipment")
		if shipment and item.ClassName then
			shipment:Spawn()
			tp_to(shipment, ply:GetPos())
			shipment:SetDisplayName(item.name)
			shipment:SetItemType(item.type)
			shipment:SetAmount(count)
			shipment:SetClassName(item.ClassName)

			return true
		end

		--[[for i = 1, count do
			local wmw = ents.Create( item.ClassName )
			if wmw then
				wmw:SetPos( ply:GetPos() + Vector( 0, 0, 42 ) + ply:GetForward() * 100 )
				wmw:Spawn()
				if itemColor then
					wmw:SetColor( StringToColor(itemColor) )
				end
			else
				return false
			end
		end]]
		YRP.msg("error", "[Spawn Item] #1 FAILED TO SPAWN: " .. item.ClassName)

		return false
	end

	local hasstorage = false
	local TARGETPOS = nil
	local TARGETANG = Angle(0, 0, 0)
	local mins = Vector(-10, -10, -10)
	local maxs = Vector(10, 10, 10)
	local dist = 10
	local wm = ents.Create("prop_physics")
	if IsValid(wm) then
		wm:SetModel(item.WorldModel)
		mins = wm:OBBMins()
		maxs = wm:OBBMaxs()
		dist = math.max(maxs.x - mins.x, maxs.y - mins.y)
		dist = dist + 32
		dist = math.Clamp(dist, 32, 6000)
		wm:Remove()
	end

	local DEALER = YRP_SQL_SELECT("yrp_dealers", "storagepoints", "uniqueID = '" .. duid .. "'")
	if IsNotNilAndNotFalse(DEALER) then
		DEALER = DEALER[1]
		local SPUID = DEALER.storagepoints
		local SP = YRP_SQL_SELECT("yrp_" .. GetMapNameDB(), "*", "type = '" .. "Storagepoint" .. "' AND uniqueID = '" .. SPUID .. "'")
		if IsNotNilAndNotFalse(SP) then
			SP = SP[1]
			YRP.msg("gm", "[Spawn Item] Item To Storagepoint")
			local pos = string.Explode(",", SP.position)
			TARGETPOS = Vector(pos[1], pos[2], pos[3])
			local ang = string.Explode(",", SP.angle)
			TARGETANG = Angle(ang[1], ang[2], ang[3])
			hasstorage = true
		end
	end

	if TARGETPOS == nil then
		TARGETPOS = ply:GetPos()
		YRP.msg("gm", "[Spawn Item] Item To Player")
	end

	local foundpos = false
	local ang = Angle(0, 0, 0)
	local tr = util.TraceHull(
		{
			start = TARGETPOS,
			endpos = TARGETPOS,
			mins = mins,
			maxs = maxs,
			mask = MASK_SHOT_HULL
		}
	)

	if not tr.Hit then
		foundpos = true
	end

	if not foundpos then
		for dis = 1, 10 do
			if not foundpos then
				for i = 0, 360 - 15, 15 do
					if not foundpos then
						for hei = 0, 6 do
							ang = Angle(0, i, 0)
							local pos = TARGETPOS + ang:Forward() * 100 * dis
							if hei > 0 then
								pos = pos + Vector(0, 0, hei / 5 * math.abs(maxs.z - mins.z))
							end

							tr = util.TraceHull(
								{
									start = pos,
									endpos = pos,
									mins = mins,
									maxs = maxs,
									mask = MASK_SHOT_HULL
								}
							)

							if not tr.Hit then
								TARGETPOS = pos
								foundpos = true
								break
							end
						end
					else
						break
					end
				end
			else
				break
			end
		end
	end

	if not foundpos then
		YRP.msg("note", "[Spawn Item] NOT ENOUGH SPACE? cn: " .. item.ClassName .. " wm: " .. item.WorldModel .. " distance: " .. tostring(dist) .. " hasstorage: " .. tostring(hasstorage))
		ply:PrintMessage(HUD_PRINTCENTER, "NOT ENOUGH SPACE TO SPAWN")

		return false
	end

	local tr2 = util.TraceHull(
		{
			start = TARGETPOS + Vector(0, 0, 80),
			endpos = TARGETPOS - Vector(0, 0, 400),
			mins = mins,
			maxs = maxs,
			mask = MASK_SHOT_HULL
		}
	)

	if tr2.Hit then
		local ent = nil
		local ENT = scripted_ents.GetStored(item.ClassName)
		if ENT ~= nil then
			ent = ents.Create(item.ClassName)
			if IsValid(ent) then
				if ent.SpawnFunction then
					ent:SpawnFunction(ply, tr2, item.ClassName)

					return true, ent
				else
					local _, err = pcall(YRPEntSpawn, ent)
					if err then
						YRPMsg(err)
					end
				end

				ent:SetPos(tr2.HitPos + Vector(0, 0, 25))
				--ent:SetOwner(ply)
				ent:SetYRPEntity("yrp_owner", ply)
				ent:SetAngles(TARGETANG)
				if not hasstorage then
					ent:SetPos(ply:GetPos() + ply:GetForward() * 64 + ply:GetUp() * 64)
				end

				ent:SetYRPInt("item_uniqueID", item.uniqueID)
				YRP.msg("gm", "[Spawn Item] WORKED #2")

				return true, ent
			else
				YRP.msg("note", "[Spawn Item] Not valid #1: " .. item.ClassName)

				return false
			end
		else
			local vehicle = nil
			if list.Get("simfphys_vehicles") and item.ClassName then
				vehicle = list.Get("simfphys_vehicles")[item.ClassName]
			end

			if vehicle and simfphys and simfphys.SpawnVehicle then
				ent = simfphys.SpawnVehicle(nil, tr2.HitPos + Vector(0, 0, 50), Angle(0, 0, 0), vehicle.Model, vehicle.Class, item.ClassName, vehicle, true)
				ent:SetYRPInt("item_uniqueID", item.uniqueID)
				YRP.msg("gm", "[Spawn Item] WORKED #3")
				--ent:SetOwner(ply)
				ent:SetYRPEntity("yrp_owner", ply)
				ent:Activate()
				ent:SetAngles(TARGETANG)

				return true, ent
			else
				ent = ents.Create(item.ClassName)
				if IsValid(ent) then
					local veh = nil
					for i, v in pairs(list.Get("Vehicles")) do
						if v.Model == item.WorldModel then
							veh = v
						end
					end

					if veh ~= nil and veh.KeyValues ~= nil then
						for i, v in pairs(veh.KeyValues) do
							ent:SetKeyValue(i, v)
						end
					end

					ent:SetModel(item.WorldModel)
					ent:SetPos(tr2.HitPos + Vector(0, 0, 50))
					local _, err = pcall(YRPEntSpawn, ent)
					if err then
						YRPMsg(err)
					end

					ent:Activate()
					ent:SetAngles(TARGETANG)
					ent:SetYRPInt("item_uniqueID", item.uniqueID)
					YRP.msg("gm", "[Spawn Item] WORKED #4")
					--ent:SetOwner(ply)
					ent:SetYRPEntity("yrp_owner", ply)

					return true, ent
				else
					YRP.msg("note", "[Spawn Item] Not valid #2: " .. item.ClassName)

					return false
				end
			end
		end

		if YRPEntityAlive(ent) and TARGETANG then
			ent:SetAngles(TARGETANG)
		end
	else
		YRP.msg("note", "[Spawn Item] Not enough space for item, cn: " .. item.ClassName .. " distance: " .. tostring(dist) .. " hasstorage: " .. tostring(hasstorage))
	end

	YRP.msg("note", "[Spawn Item] FAILED! " .. item.ClassName)

	return false
end

util.AddNetworkString("nws_yrp_item_buy")
net.Receive(
	"nws_yrp_item_buy",
	function(len, ply)
		local duid = net.ReadString()
		local itemId = net.ReadString()
		local count = tonumber(net.ReadString())
		local itemColor = net.ReadString()
		local _item = YRP_SQL_SELECT(DATABASE_NAME, "*", "uniqueID = " .. itemId)
		if IsNotNilAndNotFalse(_item) then
			_item = _item[1]
			_item.name = tostring(_item.name)
			_item.price = tonumber(_item.price)
			_item.cooldown = tonumber(_item.cooldown)
			local totalPrice = _item.price
			if count > 1 and _item.type == "weapons" then
				totalPrice = _item.price * count
			end

			if ply:GetYRPFloat("buy_ts" .. _item.uniqueID, 0.0) > CurTime() then
				YRP.msg("note", "[item_buy] On Cooldown")

				return
			end

			if ply:canAfford(totalPrice) then
				YRP.msg("gm", ply:YRPName() .. " buyed " .. _item.name .. " for " .. totalPrice)
				timer.Simple(
					0.3,
					function()
						YRPPlyUpdateStorage(ply)
					end
				)

				if _item.type == "licenses" then
					GiveLicense(ply, _item.ClassName)
					ply:SetYRPInt("licenseIDsVersion", ply:GetYRPInt("licenseIDsVersion", 0) + 1)
				elseif _item.type == "roles" then
					local rid = _item.ClassName
					YRPRemRolVals(ply)
					YRPRemGroVals(ply)
					YRPSetRole(ply, rid, true)
				else
					local _spawned, ent = YRPSpawnItem(ply, _item, duid, count, itemColor)
					if _spawned then
						if YRPEntityAlive(ent) then
							ent:SetYRPInt("item_uniqueID", _item.uniqueID)
							if itemColor then
								ent:SetColor(StringToColor(itemColor))
							end

							if ent:IsVehicle() then
								AddVehicle(ent, ply, _item)
							end
						end

						if _item.cooldown > 0 then
							ply:SetYRPFloat("buy_ts" .. _item.uniqueID, CurTime() + _item.cooldown)
						end
					else
						YRP.msg("note", "Failed to spawn item from shop, spawned: " .. tostring(_spawned))

						return false
					end
				end

				if tonumber(_item.permanent) == 1 then
					local _cha = ply:YRPGetCharacterTable()
					local _stor = string.Explode(",", _cha.storage)
					for i, item in pairs(_stor) do
						if item == "" then
							table.RemoveByValue(_stor, "")
						end
					end

					if not table.HasValue(_stor, _item.uniqueID) then
						table.insert(_stor, _item.uniqueID)
					end

					_stor = string.Implode(",", _stor)
					local _result = YRP_SQL_UPDATE(
						"yrp_characters",
						{
							["storage"] = _stor
						}, "uniqueID = '" .. ply:CharID() .. "'"
					)
				end

				-- Remove money if everything works
				ply:addMoney(-totalPrice)
			end
		end
	end
)

util.AddNetworkString("nws_yrp_item_spawn")
net.Receive(
	"nws_yrp_item_spawn",
	function(len, ply)
		local _tab = net.ReadTable()
		local duid = net.ReadString()
		if IsNotNilAndNotFalse(_tab) and IsNotNilAndNotFalse(duid) then
			local _item = YRP_SQL_SELECT(DATABASE_NAME, "*", "uniqueID = " .. _tab.uniqueID)
			if IsNotNilAndNotFalse(_item) then
				_item = _item[1]
				if not IsYRPEntityAlive(ply, _item.uniqueID) then
					local _spawned, ent = YRPSpawnItem(ply, _item, duid, 1)
					if _spawned then
						if YRPEntityAlive(ent) then
							ent:SetYRPInt("item_uniqueID", _item.uniqueID)
							if ent:IsVehicle() then
								AddVehicle(ent, ply, _item)
							end
						else
							YRP.msg("note", "[item_spawn] Item not alive/valid.")
						end
					end
				end
			end
		end
	end
)

util.AddNetworkString("nws_yrp_item_despawn")
net.Receive(
	"nws_yrp_item_despawn",
	function(len, ply)
		local _tab = net.ReadTable()
		local _item = YRP_SQL_SELECT(DATABASE_NAME, "*", "uniqueID = " .. _tab.uniqueID)
		if _item ~= nil then
			_item = _item[1]
			local _alive, ent = IsYRPEntityAlive(ply, _item.uniqueID)
			if _alive and YRPEntityAlive(ent) then
				ent:Remove()
			end
		end
	end
)
--Copyright (C) 2017-2020 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

-- DO NOT TOUCH THE DATABASE FILES! If you have errors, report them here:
-- https://discord.gg/sEgNZxg

util.AddNetworkString("removeVehicleOwner")

util.AddNetworkString("getVehicleInfo")

local DATABASE_NAME = "yrp_vehicles"
SQL_ADD_COLUMN(DATABASE_NAME, "keynr", "TEXT DEFAULT '-1'")
SQL_ADD_COLUMN(DATABASE_NAME, "price", "TEXT DEFAULT 100")
SQL_ADD_COLUMN(DATABASE_NAME, "ownerCharID", "TEXT DEFAULT ' '")
SQL_ADD_COLUMN(DATABASE_NAME, "ClassName", "TEXT DEFAULT ' '")
SQL_ADD_COLUMN(DATABASE_NAME, "item_id", "TEXT DEFAULT ' '")

--db_drop_table(DATABASE_NAME)
--db_is_empty(DATABASE_NAME)

function AddVehicle(veh, ply, item)
	local charid = ply:CharID()
	local cname = veh:GetClass()
	local iuid = item.uniqueID

	veh:SetDInt("ownerCharID", charid)

	SQL_INSERT_INTO(DATABASE_NAME, "ownerCharID, ClassName, item_id", "'" .. charid .. "', '" .. cname .. "', '" .. iuid .. "'")
end

function allowedToUseVehicle(id, ply)
	if ply:HasAccess() then
		return true
	else
		local _tmpVehicleTable = SQL_SELECT(DATABASE_NAME, "*", "item_id = '" .. id .. "'")
		if _tmpVehicleTable[1] != nil then
			if tostring(_tmpVehicleTable[1].ownerCharID) == ply:CharID() then
				return true
			end
		end
	end
	return false
end

net.Receive("getVehicleInfo", function(len, ply)
	local _vehicle = net.ReadEntity()

	local _vehicleID = net.ReadString()

	local _vehicleTab = SQL_SELECT(DATABASE_NAME, "*", "ownerCharID = '" .. _vehicle:GetDInt("ownerCharID", 0) .. "' AND item_id = " .. _vehicleID)

	if worked(_vehicleTab, "getVehicleInfo | No buyed vehicle! Dont work on spawnmenu vehicle") then
		local owner = ""
		for k, v in pairs(player.GetAll()) do
			if tostring(v:CharID()) == tostring(_vehicleTab[1].ownerCharID) then
				owner = v:RPName()
			end
		end

		if _vehicleTab != nil then
			if allowedToUseVehicle(_vehicleID, ply) then
				net.Start("getVehicleInfo")
					net.WriteBool(true)
					net.WriteEntity(_vehicle)
					net.WriteTable(_vehicleTab)
					net.WriteString(owner)
				net.Send(ply)
			else
				net.Start("getVehicleInfo")
					net.WriteBool(false)
				net.Send(ply)
			end
		end
	end
end)

function canVehicleLock(ply, tab)
	if tab.ownerCharID != "" then
		if tostring(ply:CharID()) == tostring(tab.ownerCharID) then
			return true
		end
		return false
	elseif tab.ownerCharID == "" then
		printGM("note", "canVehicleLock empty")
		return false
	else
		printGM("error", "canVehicleLock ELSE")
		return false
	end
end

function unlockVehicle(ply, ent, nr)
	local _tmpVehicleTable = SQL_SELECT(DATABASE_NAME, "*", "item_id = '" .. nr .. "'")
	if _tmpVehicleTable != nil then
		_tmpVehicleTable = _tmpVehicleTable[1]
		if canVehicleLock(ply, _tmpVehicleTable) then
			ent:Fire("Unlock")
			if ent.UnLock != nil then
				ent:UnLock()
			end
			return true
		end
	else
		return false
	end
end

function lockVehicle(ply, ent, nr)
	local _tmpVehicleTable = SQL_SELECT(DATABASE_NAME, "*", "item_id = '" .. nr .. "'")
	if _tmpVehicleTable != nil then
		_tmpVehicleTable = _tmpVehicleTable[1]
		if canVehicleLock(ply, _tmpVehicleTable) then
			ent:Fire("Lock")
			if ent.Lock != nil then
				ent:Lock()
			end
			return true
		end
	else
		return false
	end
end

net.Receive("removeVehicleOwner", function(len, ply)
	local _tmpVehicleID = net.ReadString()
	local _tmpTable = SQL_SELECT(DATABASE_NAME, "*", "item_id = '" .. _tmpVehicleID .. "'")

	local result = SQL_UPDATE(DATABASE_NAME, "ownerCharID = ' '", "item_id = '" .. _tmpVehicleID .. "'")

	for k, v in pairs(ents.GetAll()) do
		if tonumber(v:GetDString("item_uniqueID")) == tonumber(_tmpVehicleID) then
			v:SetDString("ownerRPName", "")
			v:SetOwner(NULL)
		end
	end
end)

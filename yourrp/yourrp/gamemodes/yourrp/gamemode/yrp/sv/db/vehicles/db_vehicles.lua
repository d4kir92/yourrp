--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
-- DO NOT TOUCH THE DATABASE FILES! If you have errors, report them here:
-- https://discord.gg/sEgNZxg
YRP:AddNetworkString("nws_yrp_removeVehicleOwner")
YRP:AddNetworkString("nws_yrp_getVehicleInfo")
local DATABASE_NAME = "yrp_vehicles"
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "keynr", "TEXT DEFAULT '-1'")
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "price", "TEXT DEFAULT 100")
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "ownerCharID", "TEXT DEFAULT ''")
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "ClassName", "TEXT DEFAULT ''")
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "item_id", "TEXT DEFAULT ''")
function AddVehicle(veh, ply, item)
	local charid = ply:CharID()
	local cname = veh:GetClass()
	local iuid = item.uniqueID
	veh:SetYRPInt("ownerCharID", tonumber(charid))
	YRP_SQL_INSERT_INTO(DATABASE_NAME, "ownerCharID, ClassName, item_id", "'" .. charid .. "', '" .. cname .. "', '" .. iuid .. "'")
end

function allowedToUseVehicle(id, ply)
	if ply:HasAccess("allowedToUseVehicle", true) then
		return true
	else
		local _tmpVehicleTable = YRP_SQL_SELECT(DATABASE_NAME, "*", "item_id = '" .. id .. "'")
		if _tmpVehicleTable[1] ~= nil and tostring(_tmpVehicleTable[1].ownerCharID) == ply:CharID() then return true end
	end

	return false
end

net.Receive(
	"nws_yrp_getVehicleInfo",
	function(len, ply)
		local _vehicle = net.ReadEntity()
		local _vehicleID = net.ReadString()
		local _vehicleTab = YRP_SQL_SELECT(DATABASE_NAME, "*", "ownerCharID = '" .. _vehicle:GetYRPInt("ownerCharID", 0) .. "' AND item_id = " .. _vehicleID)
		if YRPWORKED(_vehicleTab, "getVehicleInfo | No buyed vehicle! Dont work on spawnmenu vehicle") then
			local owner = ""
			for k, v in pairs(player.GetAll()) do
				if tostring(v:CharID()) == tostring(_vehicleTab[1].ownerCharID) then
					owner = v:RPName()
				end
			end

			if _vehicleTab ~= nil then
				if allowedToUseVehicle(_vehicleID, ply) then
					net.Start("nws_yrp_getVehicleInfo")
					net.WriteBool(true)
					net.WriteEntity(_vehicle)
					net.WriteTable(_vehicleTab)
					net.WriteString(owner)
					net.Send(ply)
				else
					net.Start("nws_yrp_getVehicleInfo")
					net.WriteBool(false)
					net.Send(ply)
				end
			end
		end
	end
)

function YRPUnlockVehicle(ply, ent, nr)
	if ply == ent:GetOwner() or ply == ent:GetRPOwner() then
		YRPFireUnlock(ent, ply)
		if ent.UnLock ~= nil then
			ent:UnLock()
		end

		return true
	end

	local _tmpVehicleTable = YRP_SQL_SELECT(DATABASE_NAME, "*", "item_id = '" .. nr .. "'")
	if _tmpVehicleTable ~= nil then
		_tmpVehicleTable = _tmpVehicleTable[1]
		if canVehicleLock(ply, ent) then
			YRPFireUnlock(ent, ply)
			if ent.UnLock ~= nil then
				ent:UnLock()
			end

			return true
		end
	else
		return false
	end
end

function YRPLockVehicle(ply, ent, nr)
	if ply == ent:GetOwner() or ply == ent:GetRPOwner() then
		YRPFireLock(ent, ply)
		if ent.Lock ~= nil then
			ent:Lock()
		end

		return true
	end

	local _tmpVehicleTable = YRP_SQL_SELECT(DATABASE_NAME, "*", "item_id = '" .. nr .. "'")
	if _tmpVehicleTable ~= nil then
		_tmpVehicleTable = _tmpVehicleTable[1]
		if canVehicleLock(ply, ent) then
			YRPFireLock(ent, ply)
			if ent.Lock ~= nil then
				ent:Lock()
			end

			return true
		end
	else
		return false
	end
end

net.Receive(
	"nws_yrp_removeVehicleOwner",
	function(len, ply)
		local _tmpVehicleID = tonumber(net.ReadString())
		local _tmpTable = YRP_SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '" .. _tmpVehicleID .. "'")
		if IsNotNilAndNotFalse(_tmpTable) then
			_tmpTable = _tmpTable[1]
			local item_uniqueID = tonumber(_tmpTable.item_id)
			for k, v in pairs(ents.GetAll()) do
				if v:GetYRPInt("item_uniqueID", 0) ~= 0 and item_uniqueID and v:GetYRPInt("item_uniqueID", 0) == item_uniqueID and ply:HasAccess("removeVehicleOwner") or ply == v:GetRPOwner() then
					YRP_SQL_UPDATE(
						DATABASE_NAME,
						{
							["ownerCharID"] = ""
						}, "uniqueID = '" .. _tmpVehicleID .. "'"
					)

					v:SetYRPInt("item_uniqueID", 0)
					v:SetYRPString("ownerRPName", "")
					v:SetYRPEntity("yrp_owner", NULL)
					v:SetOwner(NULL)
					v:Fire("Unlock")
				end
			end
		end
	end
)

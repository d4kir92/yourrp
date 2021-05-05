--Copyright (C) 2017-2021 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

-- DO NOT TOUCH THE DATABASE FILES! If you have errors, report them here:
-- https://discord.gg/sEgNZxg

local DATABASE_NAME = "yrp_" .. GetMapNameDB()

SQL_ADD_COLUMN(DATABASE_NAME, "position", "TEXT DEFAULT ' '")
SQL_ADD_COLUMN(DATABASE_NAME, "angle", "TEXT DEFAULT ' '")
SQL_ADD_COLUMN(DATABASE_NAME, "type", "TEXT DEFAULT ' '")
SQL_ADD_COLUMN(DATABASE_NAME, "linkID", "TEXT DEFAULT ' '")
SQL_ADD_COLUMN(DATABASE_NAME, "name", "TEXT DEFAULT ' '")
SQL_ADD_COLUMN(DATABASE_NAME, "int_respawntime", "TEXT DEFAULT '1'")
SQL_ADD_COLUMN(DATABASE_NAME, "int_amount", "TEXT DEFAULT '1'")
SQL_ADD_COLUMN(DATABASE_NAME, "string_classname", "TEXT DEFAULT 'npc_zombie'")

--db_drop_table(DATABASE_NAME)
--db_is_empty(DATABASE_NAME)

function teleportToPoint(ply, pos)
	--YRP.msg("note", "teleportToPoint " .. tostring(pos))
	tp_to(ply, Vector(pos[1], pos[2], pos[3]))
end

util.AddNetworkString("yrp_noti")

function teleportToSpawnpoint(ply)
	if ply.ignorespawnpoint == true then
		timer.Simple(0.5, function()
			if IsValid(ply) and ply.ignorespawnpoint then
				ply.ignorespawnpoint = false
			end
		end)
		return false
	else
		--YRP.msg("note", "teleportToSpawnpoint " .. ply:Nick())
		local rolTab = ply:GetRolTab()
		local groTab = ply:GetGroTab()
		local chaTab = ply:GetChaTab()

		if wk(chaTab) and wk(groTab) and wk(rolTab) then
			if SQL_STR_OUT(chaTab.map) == GetMapNameDB() then
				local _tmpRoleSpawnpoints = SQL_SELECT(DATABASE_NAME, "*", "type = 'RoleSpawnpoint' AND linkID = '" .. rolTab.uniqueID .. "'")
				local _tmpGroupSpawnpoints = SQL_SELECT(DATABASE_NAME, "*", "type = 'GroupSpawnpoint' AND linkID = '" .. groTab.uniqueID .. "'")
				if _tmpRoleSpawnpoints != nil then
					local _randomSpawnPoint = table.Random(_tmpRoleSpawnpoints)

					local _tmp = string.Explode(",", _randomSpawnPoint.position)
					local worked = tp_to(ply, Vector(_tmp[1], _tmp[2], _tmp[3]))
					if worked then
						YRP.msg("note", "[" .. ply:Nick() .. "] teleported to RoleSpawnpoint (" .. tostring(rolTab.string_name) .. ") " .. tostring(_randomSpawnPoint.position))
					end
					_tmp = string.Explode(",", _randomSpawnPoint.angle)
					if ply:IsPlayer() then
						ply:SetEyeAngles(Angle(_tmp[1], _tmp[2], _tmp[3]))
					end
					return true
				elseif _tmpGroupSpawnpoints != nil then
					local _randomSpawnPoint = table.Random(_tmpGroupSpawnpoints)
					
					local _tmp = string.Explode(",", _randomSpawnPoint.position)
					local worked = tp_to(ply, Vector(_tmp[1], _tmp[2], _tmp[3]))
					if worked then
						YRP.msg("note", "[" .. ply:Nick() .. "] teleported to GroupSpawnpoint (" .. tostring(groTab.string_name) .. ") " .. tostring(_randomSpawnPoint.position))
					end
					_tmp = string.Explode(",", _randomSpawnPoint.angle)
					if ply:IsPlayer() then
						ply:SetEyeAngles(Angle(_tmp[1], _tmp[2], _tmp[3]))
					end
					return true
				else
					local _has_ug = true
					local _ug = {}
					_ug.int_parentgroup = groTab.int_parentgroup

					while (_has_ug) do
						_ug = SQL_SELECT("yrp_ply_groups", "*", "uniqueID = '" .. _ug.int_parentgroup .. "'")

						if _ug != nil then
							_ug = _ug[1]
							local _gs = SQL_SELECT(DATABASE_NAME, "*", "linkID = " .. _ug.uniqueID)
							if _gs != nil then
								local _randomSpawnPoint = table.Random(_gs)
								local _tmp = string.Explode(",", _randomSpawnPoint.position)
								local worked = tp_to(ply, Vector(_tmp[1], _tmp[2], _tmp[3]))
								if worked then
									YRP.msg("note", "[" .. ply:Nick() .. "] teleported to PARENTGroupSpawnpoint (" .. tostring(_ug.string_name) .. ") " .. tostring(_randomSpawnPoint.position))
								end
								_tmp = string.Explode(",", _randomSpawnPoint.angle)
								if ply:IsPlayer() then
									ply:SetEyeAngles(Angle(_tmp[1], _tmp[2], _tmp[3]))
								end
								return true
							end
						else
							_has_ug = false
						end
					end
					local _str = "[" .. tostring(groTab.string_name) .. "]" .. " has NO role or group spawnpoint!"
					YRP.msg("note", _str)

					net.Start("yrp_noti")
						net.WriteString("nogroupspawn")
						net.WriteString(tostring(groTab.string_name))
					net.Broadcast()

					tp_to(ply, ply:GetPos())
					return false
				end
			end
		else
			return false
		end
	end
end

util.AddNetworkString("getMapList")
util.AddNetworkString("dbInsertIntoMap")
util.AddNetworkString("removeMapEntry")

net.Receive("removeMapEntry", function(len, ply)
	local _tmpUniqueID = net.ReadString()

	local _tmpMapTable = SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '" .. _tmpUniqueID .. "'")
	if _tmpMapTable != nil then
		_tmpMapTable = _tmpMapTable[1]
		if _tmpMapTable.type == "dealer" then
			dealer_rem(_tmpMapTable.linkID)
		end
	end
	SQL_DELETE_FROM(DATABASE_NAME, "uniqueID = " .. _tmpUniqueID)
end)

net.Receive("getMapList", function(len, ply)
	if ply:CanAccess("bool_map") then
		local _tmpMapTable = SQL_SELECT(DATABASE_NAME, "*", nil)
		if !wk(_tmpMapTable) then
			_tmpMapTable = {}
		end

		local _tmpDealerTable = SQL_SELECT("yrp_dealers", "*", "map = '" .. GetMapNameDB() .. "'")
		if !wk(_tmpDealerTable) then
			_tmpDealerTable = {}
		end

		net.Start("getMapList")
			net.WriteTable(_tmpMapTable)
			net.WriteTable(_tmpDealerTable)
		net.Send(ply)
	end
end)

util.AddNetworkString("getMapListGroups")
net.Receive("getMapListGroups", function(len, ply)
	local _tmpGroupTable = SQL_SELECT("yrp_ply_groups", "*", nil)
	for i, v in pairs(_tmpGroupTable) do
		net.Start("getMapListGroups")
			net.WriteString(table.Count(_tmpGroupTable))
			net.WriteString(i)
			net.WriteTable(v)
		net.Send(ply)
	end
end)

util.AddNetworkString("getMapListRoles")
net.Receive("getMapListRoles", function(len, ply)
	local _tmpRolesTable = SQL_SELECT("yrp_ply_roles", "*", nil)
	if wk(_tmpRolesTable) then
		for i, v in pairs(_tmpRolesTable) do
			net.Start("getMapListRoles")
				net.WriteString(table.Count(_tmpRolesTable))
				net.WriteString(i)
				net.WriteTable(v)
			net.Send(ply)
		end
	end
end)

net.Receive("dbInsertIntoMap", function(len, ply)
	local _tmpDBTable = net.ReadString()
	local _tmpDBCol = net.ReadString()
	local _tmpDBVal = net.ReadString()

	if sql.TableExists(_tmpDBTable) then
		SQL_INSERT_INTO(_tmpDBTable, _tmpDBCol, _tmpDBVal)
	else
		YRP.msg("error", "dbInsertInto: " .. _tmpDBTable .. " is not existing")
	end

	UpdateSpawnerNPCTable()
	UpdateSpawnerENTTable()
	UpdateJailpointTable()
	UpdateReleasepointTable()
	UpdateRadiationTable()
	UpdateSafezoneTable()
end)

util.AddNetworkString("dealer_settings")
net.Receive("dealer_settings", function(len, ply)
	local _storages = SQL_SELECT(DATABASE_NAME, "*", "type = 'Storagepoint'")
	if _storages == nil or _storages == false then
		_storages = {}
	end
	net.Start("dealer_settings")
		net.WriteTable(_storages)
	net.Send(ply)
end)

util.AddNetworkString("teleportto")
net.Receive("teleportto", function(len, ply)
	if ply:HasAccess() then
		local _uid = net.ReadString()
		local _entry = SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '" .. _uid .. "'")
		if _entry != nil then
			_entry = _entry[1]
			local pos = string.Explode(",", _entry.position)
			local ang = string.Explode(",", _entry.angle)
			ply:SetPos(Vector(pos[1], pos[2], pos[3]))
			ply:SetEyeAngles(Angle(ang[1], ang[2], ang[3]))
		end
	end
end)



util.AddNetworkString("update_map_name")
net.Receive("update_map_name", function(len, ply)
	local uid = net.ReadString()
	local i = net.ReadString()

	SQL_UPDATE(DATABASE_NAME, "name = '" .. i .. "'", "uniqueID = '" .. uid .. "'")
	UpdateJailpointTable()
end)

util.AddNetworkString("update_map_int_respawntime")
net.Receive("update_map_int_respawntime", function(len, ply)
	local uid = net.ReadString()
	local i = net.ReadString()

	SQL_UPDATE(DATABASE_NAME, "int_respawntime = '" .. i .. "'", "uniqueID = '" .. uid .. "'")
	UpdateSpawnerNPCTable()
	UpdateSpawnerENTTable()
end)

util.AddNetworkString("update_map_int_amount")
net.Receive("update_map_int_amount", function(len, ply)
	local uid = net.ReadString()
	local i = net.ReadString()

	SQL_UPDATE(DATABASE_NAME, "int_amount = '" .. i .. "'", "uniqueID = '" .. uid .. "'")
	UpdateSpawnerNPCTable()
	UpdateSpawnerENTTable()
end)

util.AddNetworkString("update_map_string_classname")
net.Receive("update_map_string_classname", function(len, ply)
	local uid = net.ReadString()
	local s = net.ReadString()

	SQL_UPDATE(DATABASE_NAME, "string_classname = '" .. s .. "'", "uniqueID = '" .. uid .. "'")
	UpdateSpawnerNPCTable()
	UpdateSpawnerENTTable()
end)

-- NEW MAP PAGE
util.AddNetworkString("getMapSite")
net.Receive("getMapSite", function(len, ply)
	if ply:CanAccess("bool_map") then
		net.Start("getMapSite")
		net.Send(ply)
	end
end)

util.AddNetworkString("getMapTab")
net.Receive("getMapTab", function(len, ply)
	if ply:CanAccess("bool_map") then
		local tab = net.ReadString()

		local grp = false
		local rol = false

		local dbTab = {}
		if tab == "jailpoints" then
			dbTab = SQL_SELECT(DATABASE_NAME, "*", "type = '" .. "jailpoint" .. "'")
		elseif tab == "releasepoints" then
			dbTab = SQL_SELECT(DATABASE_NAME, "*", "type = '" .. "releasepoint" .. "'")
		elseif tab == "groupspawnpoints" then
			dbTab = SQL_SELECT(DATABASE_NAME, "*", "type = '" .. "GroupSpawnpoint" .. "'")
			grp = true
			if wk(dbTab) then
				for i, v in pairs(dbTab) do
					local g = SQL_SELECT("yrp_ply_groups", "string_name", "uniqueID = '" .. v.linkID .. "'")
					if wk(g) then
						g = g[1]
						v.name = g.string_name
					end
				end
			end
		elseif tab == "rolespawnpoints" then
			dbTab = SQL_SELECT(DATABASE_NAME, "*", "type = '" .. "RoleSpawnpoint" .. "'")
			grp = true
			rol = true
			if wk(dbTab) then
				for i, v in pairs(dbTab) do
					local r = SQL_SELECT("yrp_ply_roles", "string_name", "uniqueID = '" .. v.linkID .. "'")
					if wk(r) then
						r = r[1]
						v.name = r.string_name
					end
				end
			end
		elseif tab == "dealers" then
			dbTab = SQL_SELECT(DATABASE_NAME, "*", "type = '" .. "dealer" .. "'")
		elseif tab == "storagepoints" then
			dbTab = SQL_SELECT(DATABASE_NAME, "*", "type = '" .. "Storagepoint" .. "'")
		elseif tab == "other" then
			dbTab = SQL_SELECT(DATABASE_NAME, "*", "NOT type = 'dealer' AND NOT type = 'Storagepoint' AND NOT type = 'RoleSpawnpoint' AND NOT type = 'GroupSpawnpoint' AND NOT type = 'jailpoint' AND NOT type = 'releasepoint'")
		end

		local dbGrp = {}
		local dbRol = {}
		if grp then
			dbGrp = SQL_SELECT("yrp_ply_groups", "uniqueID, string_name", nil)
		end
		if rol then
			dbRol = SQL_SELECT("yrp_ply_roles", "uniqueID, int_groupID, string_name", nil)
		end

		if !wk(dbTab) then
			dbTab = {}
		end

		net.Start("getMapTab")
			net.WriteString(tab)
			net.WriteTable(dbTab)
			net.WriteTable(dbGrp)
			net.WriteTable(dbRol)
		net.Send(ply)
	end
end)

local mapobjects = {}
function YRPUnRegisterObject(obj, uid)

end

function YRPRegisterObject(obj)
	table.insert(mapobjects, obj)

	if obj._suid == nil then
		local storage = CreateStorage(obj.bag_size)
		if wk(storage) then
			obj._suid = tonumber(storage.uniqueID)
		end

		local pos = obj:GetPos()
		pos = string.Replace(tostring(pos), " ", ",")
		local ang = obj:GetAngles()
		ang = string.Replace(tostring(ang), " ", ",")
		local suid = obj._suid
		local class = obj:GetClass()

		local cols = "position, angle, type, linkID, string_classname"
		local vals = ""
		vals = vals .. "'" .. pos .. "', "
		vals = vals .. "'" .. ang .. "', "
		vals = vals .. "'" .. "storage" .. "', "
		vals = vals .. "'" .. suid .. "', "
		vals = vals .. "'" .. class .. "'"

		SQL_INSERT_INTO(DATABASE_NAME, cols, vals)

		local last = {}
		last.table = DATABASE_NAME
		last.cols = {}
		last.cols[1] = "*"
		last.manual = "ORDER BY uniqueID DESC LIMIT 1"
		last = SQL.SELECT(last)
		if wk(last) then
			last = last[1]
		end
	end
end

function LoadWorldStorages()
	local storages = SQL_SELECT(DATABASE_NAME, "*", "type = '" .. "storage" .. "'")

	if wk(storages) then
		for i, v in pairs(storages) do
			v.linkID = v.linkID or 0
			v.linkID = tonumber(v.linkID)
			local found = false
			for j, ent in pairs(ents.GetAll()) do
				if ent._suid == v.linkID then
					found = true
				end
			end

			if !found then
				local stor = ents.Create(v.string_classname)

				local pos = string.Explode(",", v.position)
				stor:SetPos(Vector(pos[1], pos[2], pos[3]))

				local ang = string.Explode(",", v.angle)
				stor:SetAngles(Angle(ang[1], ang[2], ang[3]))

				stor:Spawn()

				stor:SetStorage(v.linkID)
				stor.uid = v.uniqueID
			end
		end
	end
end
timer.Simple(4, function()
	LoadWorldStorages()
end)

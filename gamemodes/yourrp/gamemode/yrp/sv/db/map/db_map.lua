--Copyright (C) 2017-2022 D4KiR (https://www.gnu.org/licenses/gpl.txt)

-- DO NOT TOUCH THE DATABASE FILES! If you have errors, report them here:
-- https://discord.gg/sEgNZxg

local DATABASE_NAME = "yrp_" .. GetMapNameDB()

YRP_SQL_ADD_COLUMN(DATABASE_NAME, "position", "TEXT DEFAULT ''" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "angle", "TEXT DEFAULT ''" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "type", "TEXT DEFAULT ''" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "linkID", "TEXT DEFAULT ''" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "name", "TEXT DEFAULT ''" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "color", "TEXT DEFAULT '255,255,255'" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "int_respawntime", "TEXT DEFAULT '1'" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "int_amount", "TEXT DEFAULT '1'" )
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "string_classname", "TEXT DEFAULT 'npc_zombie'" )

function teleportToPoint(ply, pos)
	--YRP.msg( "note", "teleportToPoint " .. tostring(pos) )
	tp_to(ply, Vector(pos[1], pos[2], pos[3]) )
end

util.AddNetworkString( "yrp_noti" )

function YRPTeleportToSpawnpoint(ply, from)
	if ply.ignorespawnpoint == true then
		timer.Simple(2.0, function()
			if IsValid(ply) and ply.ignorespawnpoint then
				ply.ignorespawnpoint = false
			end
		end)
		return false
	else
		local rolTab = ply:YRPGetRoleTable()
		local groTab = ply:YRPGetGroupTable()
		local chaTab = ply:YRPGetCharacterTable()

		if wk( chaTab) and wk(groTab) and wk(rolTab) then
			local _roleSpawnpoints = YRP_SQL_SELECT(DATABASE_NAME, "*", "type = 'RoleSpawnpoint' AND linkID = '" .. rolTab.uniqueID .. "'" )
			local _groupSpawnpoints = YRP_SQL_SELECT(DATABASE_NAME, "*", "type = 'GroupSpawnpoint' AND linkID = '" .. groTab.uniqueID .. "'" )
			if _roleSpawnpoints != nil then
				local _randomSpawnPoint = table.Random(_roleSpawnpoints)

				local _tmp = string.Explode( ",", _randomSpawnPoint.position)
				local worked = tp_to(ply, Vector(_tmp[1], _tmp[2], _tmp[3]) )
				if worked then
					YRP.msg( "note", "[" .. ply:Nick() .. "] teleported to RoleSpawnpoint" )
				else
					YRP.msg( "note", "[" .. ply:Nick() .. "] FAILED to teleport to RoleSpawnpoint" )
				end
				_tmp = string.Explode( ",", _randomSpawnPoint.angle)
				if ply:IsPlayer() then
					ply:SetEyeAngles(Angle(_tmp[1], _tmp[2], _tmp[3]) )
				end
				return true
			elseif _groupSpawnpoints != nil then
				local _randomSpawnPoint = table.Random(_groupSpawnpoints)
				
				local _tmp = string.Explode( ",", _randomSpawnPoint.position)
				local worked = tp_to(ply, Vector(_tmp[1], _tmp[2], _tmp[3]) )
				if worked then
					YRP.msg( "note", "[" .. ply:Nick() .. "] teleported to GroupSpawnpoint" )
				else
					YRP.msg( "note", "[" .. ply:Nick() .. "] FAILED to teleport to GroupSpawnpoint" )
				end
				_tmp = string.Explode( ",", _randomSpawnPoint.angle)
				if ply:IsPlayer() then
					ply:SetEyeAngles(Angle(_tmp[1], _tmp[2], _tmp[3]) )
				end
				return true
			else
				local _has_ug = true
				local _ug = {}
				_ug.int_parentgroup = groTab.int_parentgroup

				while (_has_ug) do
					_ug = YRP_SQL_SELECT( "yrp_ply_groups", "*", "uniqueID = '" .. _ug.int_parentgroup .. "'" )

					if _ug != nil then
						_ug = _ug[1]
						local _gs = YRP_SQL_SELECT(DATABASE_NAME, "*", "linkID = " .. _ug.uniqueID)
						if _gs != nil then
							local _randomSpawnPoint = table.Random(_gs)
							local _tmp = string.Explode( ",", _randomSpawnPoint.position)
							local worked = tp_to(ply, Vector(_tmp[1], _tmp[2], _tmp[3]) )
							if worked then
								YRP.msg( "note", "[" .. ply:Nick() .. "] teleported to PARENT - GroupSpawnpoint" )
							else
								YRP.msg( "note", "[" .. ply:Nick() .. "] FAILED to teleport to PARENT - GroupSpawnpoint" )
							end
							_tmp = string.Explode( ",", _randomSpawnPoint.angle)
							if ply:IsPlayer() then
								ply:SetEyeAngles(Angle(_tmp[1], _tmp[2], _tmp[3]) )
							end
							return true
						end
					else
						_has_ug = false
					end
				end
				local _str = "[" .. tostring(groTab.string_name) .. "]" .. " has NO role or group spawnpoint!"
				YRP.msg( "note", _str)

				net.Start( "yrp_noti" )
					net.WriteString( "nogroupspawn" )
					net.WriteString(tostring(groTab.string_name) )
				net.Broadcast()

				tp_to(ply, ply:GetPos() )
				return false
			end
		elseif ply:HasCharacterSelected() == true and ply:LoadedGamemode() == true and ply:GetYRPBool( "yrpspawnedwithcharacter", false) == true then
			YRP.msg( "error", "[YRPTeleportToSpawnpoint] FAILED! ROLE: " .. tostring(roltab) .. " GROUP: " .. tostring(groTab) .. " CHARACTER: " .. tostring( chaTab) .. " from: " .. tostring(from) )
			return false
		end
	end
	return false
end

util.AddNetworkString( "getMapList" )
util.AddNetworkString( "dbInsertIntoMap" )
util.AddNetworkString( "removeMapEntry" )

net.Receive( "removeMapEntry", function(len, ply)
	local _tmpUniqueID = net.ReadString()

	local _tmpMapTable = YRP_SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '" .. _tmpUniqueID .. "'" )
	if _tmpMapTable != nil then
		_tmpMapTable = _tmpMapTable[1]
		if _tmpMapTable.type == "dealer" then
			dealer_rem(_tmpMapTable.linkID)
		end
	end
	YRP_SQL_DELETE_FROM(DATABASE_NAME, "uniqueID = " .. _tmpUniqueID)
end)

net.Receive( "getMapList", function(len, ply)
	if ply:CanAccess( "bool_map" ) then
		local _tmpMapTable = YRP_SQL_SELECT(DATABASE_NAME, "*", nil)
		if !wk(_tmpMapTable) then
			_tmpMapTable = {}
		end

		local _tmpDealerTable = YRP_SQL_SELECT( "yrp_dealers", "*", "map = '" .. GetMapNameDB() .. "'" )
		if !wk(_tmpDealerTable) then
			_tmpDealerTable = {}
		end

		net.Start( "getMapList" )
			net.WriteTable(_tmpMapTable)
			net.WriteTable(_tmpDealerTable)
		net.Send(ply)
	end
end)

util.AddNetworkString( "getMapListGroups" )
net.Receive( "getMapListGroups", function(len, ply)
	local _tmpGroupTable = YRP_SQL_SELECT( "yrp_ply_groups", "*", nil)
	for i, v in pairs(_tmpGroupTable) do
		net.Start( "getMapListGroups" )
			net.WriteString(table.Count(_tmpGroupTable) )
			net.WriteString(i)
			net.WriteTable( v)
		net.Send(ply)
	end
end)

util.AddNetworkString( "getMapListRoles" )
net.Receive( "getMapListRoles", function(len, ply)
	local _tmpRolesTable = YRP_SQL_SELECT( "yrp_ply_roles", "*", nil)
	if wk(_tmpRolesTable) then
		for i, v in pairs(_tmpRolesTable) do
			net.Start( "getMapListRoles" )
				net.WriteString(table.Count(_tmpRolesTable) )
				net.WriteString(i)
				net.WriteTable( v)
			net.Send(ply)
		end
	end
end)

function YRPUpdateAllDBTables()
	UpdateSpawnerNPCTable()
	UpdateSpawnerENTTable()
	UpdateJailpointTable()
	UpdateReleasepointTable()
	UpdateRadiationTable()
	UpdateSafezoneTable()
	UpdateZoneTable()
end

net.Receive( "dbInsertIntoMap", function(len, ply)
	local _tmpDBTable = net.ReadString()
	local _tmpDBCol = net.ReadString()
	local _tmpDBVal = net.ReadString()

	if sql.TableExists(_tmpDBTable) then
		YRP_SQL_INSERT_INTO(_tmpDBTable, _tmpDBCol, _tmpDBVal)
	else
		YRP.msg( "error", "dbInsertInto: " .. _tmpDBTable .. " is not existing" )
	end

	YRPUpdateAllDBTables()
end)

util.AddNetworkString( "dealer_settings" )
net.Receive( "dealer_settings", function(len, ply)
	local _storages = YRP_SQL_SELECT(DATABASE_NAME, "*", "type = 'Storagepoint'" )
	if _storages == nil or _storages == false then
		_storages = {}
	end
	net.Start( "dealer_settings" )
		net.WriteTable(_storages)
	net.Send(ply)
end)

util.AddNetworkString( "teleportto" )
net.Receive( "teleportto", function(len, ply)
	if ply:HasAccess() then
		local _uid = net.ReadString()
		local _entry = YRP_SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '" .. _uid .. "'" )
		if _entry != nil then
			_entry = _entry[1]
			local pos = string.Explode( ",", _entry.position)
			local ang = string.Explode( ",", _entry.angle)
			ply:SetPos( Vector(pos[1], pos[2], pos[3]) )
			ply:SetEyeAngles(Angle( ang[1], ang[2], ang[3]) )
		end
	end
end)



util.AddNetworkString( "update_map_name" )
net.Receive( "update_map_name", function(len, ply)
	local uid = net.ReadString()
	local i = net.ReadString()

	YRP_SQL_UPDATE(DATABASE_NAME, {["name"] = i}, "uniqueID = '" .. uid .. "'" )
	YRPUpdateAllDBTables()
end)

util.AddNetworkString( "update_map_color" )
net.Receive( "update_map_color", function(len, ply)
	local uid = net.ReadString()
	local i = net.ReadString()

	YRP_SQL_UPDATE(DATABASE_NAME, {["color"] = i}, "uniqueID = '" .. uid .. "'" )
	YRPUpdateAllDBTables()
end)

util.AddNetworkString( "update_map_int_respawntime" )
net.Receive( "update_map_int_respawntime", function(len, ply)
	local uid = net.ReadString()
	local i = net.ReadString()

	YRP_SQL_UPDATE(DATABASE_NAME, {["int_respawntime"] = i}, "uniqueID = '" .. uid .. "'" )
	UpdateSpawnerNPCTable()
	UpdateSpawnerENTTable()
end)

util.AddNetworkString( "update_map_int_amount" )
net.Receive( "update_map_int_amount", function(len, ply)
	local uid = net.ReadString()
	local i = net.ReadString()

	YRP_SQL_UPDATE(DATABASE_NAME, {["int_amount"] = i}, "uniqueID = '" .. uid .. "'" )
	UpdateSpawnerNPCTable()
	UpdateSpawnerENTTable()
end)

util.AddNetworkString( "update_map_string_classname" )
net.Receive( "update_map_string_classname", function(len, ply)
	local uid = net.ReadString()
	local s = net.ReadString()

	YRP_SQL_UPDATE(DATABASE_NAME, {["string_classname"] = s}, "uniqueID = '" .. uid .. "'" )
	UpdateSpawnerNPCTable()
	UpdateSpawnerENTTable()
end)

-- NEW MAP PAGE
util.AddNetworkString( "getMapSite" )
net.Receive( "getMapSite", function(len, ply)
	if ply:CanAccess( "bool_map" ) then
		net.Start( "getMapSite" )
		net.Send(ply)
	end
end)

util.AddNetworkString( "getMapTab" )
net.Receive( "getMapTab", function(len, ply)
	if ply:CanAccess( "bool_map" ) then
		local tab = net.ReadString()

		local grp = false
		local rol = false

		local dbTab = {}
		if tab == "jailpoints" then
			dbTab = YRP_SQL_SELECT(DATABASE_NAME, "*", "type = '" .. "jailpoint" .. "'" )
		elseif tab == "releasepoints" then
			dbTab = YRP_SQL_SELECT(DATABASE_NAME, "*", "type = '" .. "releasepoint" .. "'" )
		elseif tab == "groupspawnpoints" then
			dbTab = YRP_SQL_SELECT(DATABASE_NAME, "*", "type = '" .. "GroupSpawnpoint" .. "'" )
			grp = true
			if wk( dbTab) then
				for i, v in pairs( dbTab) do
					local g = YRP_SQL_SELECT( "yrp_ply_groups", "string_name", "uniqueID = '" .. v.linkID .. "'" )
					if wk(g) then
						g = g[1]
						v.name = g.string_name
					end
				end
			end
		elseif tab == "rolespawnpoints" then
			dbTab = YRP_SQL_SELECT(DATABASE_NAME, "*", "type = '" .. "RoleSpawnpoint" .. "'" )
			grp = true
			rol = true
			if wk( dbTab) then
				for i, v in pairs( dbTab) do
					local r = YRP_SQL_SELECT( "yrp_ply_roles", "string_name", "uniqueID = '" .. v.linkID .. "'" )
					if wk(r) then
						r = r[1]
						v.name = r.string_name
					end
				end
			end
		elseif tab == "dealers" then
			dbTab = YRP_SQL_SELECT(DATABASE_NAME, "*", "type = '" .. "dealer" .. "'" )
		elseif tab == "storagepoints" then
			dbTab = YRP_SQL_SELECT(DATABASE_NAME, "*", "type = '" .. "Storagepoint" .. "'" )
		elseif tab == "other" then
			dbTab = YRP_SQL_SELECT(DATABASE_NAME, "*", "NOT type = 'dealer' AND NOT type = 'Storagepoint' AND NOT type = 'RoleSpawnpoint' AND NOT type = 'GroupSpawnpoint' AND NOT type = 'jailpoint' AND NOT type = 'releasepoint'" )
		end

		local dbGrp = {}
		local dbRol = {}
		if grp then
			dbGrp = YRP_SQL_SELECT( "yrp_ply_groups", "uniqueID, string_name", nil)
		end
		if rol then
			dbRol = YRP_SQL_SELECT( "yrp_ply_roles", "uniqueID, int_groupID, string_name", nil)
		end

		if !wk( dbTab) then
			dbTab = {}
		end

		net.Start( "getMapTab" )
			net.WriteString(tab)
			net.WriteTable( dbTab)
			net.WriteTable( dbGrp)
			net.WriteTable( dbRol)
		net.Send(ply)
	end
end)

local mapobjects = {}
function YRPUnRegisterObject(obj, uid)

end

function YRPRegisterObject(obj)
	if !IsValid(obj) then return end

	table.insert(mapobjects, obj)

	if obj._suid == nil then
		local storage = CreateStorage(obj.bag_size)
		if wk(storage) then
			obj._suid = tonumber(storage.uniqueID)
		end

		local pos = obj:GetPos()
		pos = string.Replace(tostring(pos), " ", "," )
		local ang = obj:GetAngles()
		ang = string.Replace(tostring( ang), " ", "," )
		local suid = obj._suid
		local class = obj:GetClass()

		local cols = "position, angle, type, linkID, string_classname"
		local vals = ""
		vals = vals .. "'" .. pos .. "', "
		vals = vals .. "'" .. ang .. "', "
		vals = vals .. "'" .. "storage" .. "', "
		vals = vals .. "'" .. suid .. "', "
		vals = vals .. "'" .. class .. "'"

		YRP_SQL_INSERT_INTO(DATABASE_NAME, cols, vals)

		local last = YRP_SQL_SELECT(DATABASE_NAME, "*", nil, "ORDER BY uniqueID DESC LIMIT 1" )
		if wk(last) then
			last = last[1]
		end
	end
end

function LoadWorldStorages()
	local storages = YRP_SQL_SELECT(DATABASE_NAME, "*", "type = '" .. "storage" .. "'" )

	if wk(storages) then
		for i, v in pairs(storages) do
			v.linkID = v.linkID or 0
			v.linkID = tonumber( v.linkID)
			local found = false
			for j, ent in pairs(ents.GetAll() ) do
				if ent._suid == v.linkID then
					found = true
				end
			end

			if !found then
				local stor = ents.Create( v.string_classname)

				local pos = string.Explode( ",", v.position)
				stor:SetPos( Vector(pos[1], pos[2], pos[3]) )

				local ang = string.Explode( ",", v.angle)
				stor:SetAngles(Angle( ang[1], ang[2], ang[3]) )

				stor:Spawn()

				stor:SetStorage( v.linkID)
				stor.uid = v.uniqueID
			end
		end
	end
end
timer.Simple(4, function()
	LoadWorldStorages()
end)

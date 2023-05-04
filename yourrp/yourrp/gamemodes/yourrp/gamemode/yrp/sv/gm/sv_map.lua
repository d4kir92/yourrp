--Copyright (C) 2017-2023 D4KiR (https://www.gnu.org/licenses/gpl.txt)
local _map_size = {}
_map_size.size = 9999999999
_map_size.sizeN = -_map_size.size
_map_size.sizeS = _map_size.size
_map_size.sizeW = _map_size.size
_map_size.sizeE = -_map_size.size
_map_size.sizeX = -_map_size.size
_map_size.sizeY = -_map_size.size
_map_size.sizeUp = -_map_size.size
_map_size.sizeFE = -_map_size.size
_map_size.spawnPointsH = -_map_size.size
_map_size.eventH = -_map_size.size
_map_size.error = 1
_map_size.facX = 1
_map_size.facY = 1
_map_size.error = 0
local skyCamera = nil
util.AddNetworkString("nws_yrp_askCoords")
util.AddNetworkString("nws_yrp_sendCoords")
util.AddNetworkString("nws_yrp_askCoordsMM")
util.AddNetworkString("nws_yrp_sendCoordsMM")

net.Receive("nws_yrp_askCoords", function(len, ply)
	if _map_size.sizeN == -9999999999 or _map_size.sizeS == 9999999999 or _map_size.sizeW == 9999999999 or _map_size.sizeE == -9999999999 then
		net.Start("nws_yrp_sendCoords")
		net.WriteBool(false)
		net.WriteTable(_map_size)
		net.Send(ply)
		YRPGetMapDoors()
	else
		net.Start("nws_yrp_sendCoords")
		net.WriteBool(true)
		net.WriteTable(_map_size)
		net.Send(ply)
	end
end)

net.Receive("nws_yrp_askCoordsMM", function(len, ply)
	if _map_size.sizeN == -9999999999 or _map_size.sizeS == 9999999999 or _map_size.sizeW == 9999999999 or _map_size.sizeE == -9999999999 then
		net.Start("nws_yrp_sendCoordsMM")
		net.WriteBool(false)
		net.WriteTable(_map_size)
		net.Send(ply)
		YRPGetMapDoors()
	else
		net.Start("nws_yrp_sendCoordsMM")
		net.WriteBool(true)
		net.WriteTable(_map_size)
		net.Send(ply)
	end
end)

function try_new_pos(dir, size, space, tmpX, tmpY, tmpZ)
	local _fails = 3
	local _tmpEnd = 0
	local _result = dir

	for i = dir, size, space do
		if util.IsInWorld(Vector(tmpX or i, tmpY or i, tmpZ or i)) and _tmpEnd < _fails then
			_result = i

			if _tmpEnd > 0 then
				_tmpEnd = 0
			end
		else
			_tmpEnd = _tmpEnd + 1
			if _tmpEnd >= _fails then break end
		end
	end

	return _result
end

function search_coords(ent)
	local _size = 1000000
	local _space = 8

	if ent:GetPos().z - 64 > _map_size.spawnPointsH then
		_map_size.spawnPointsH = ent:GetPos().z - 64
	end

	local testUp = try_new_pos(ent:GetPos().z, _size, _space, ent:GetPos().x, ent:GetPos().y, nil)

	if testUp > _map_size.sizeUp then
		_map_size.sizeUp = testUp
	end

	local testE = try_new_pos(ent:GetPos().x, _size, _space, nil, ent:GetPos().y, _map_size.sizeUp)

	if testE > _map_size.sizeE then
		_map_size.sizeE = testE
	end

	local testW = try_new_pos(ent:GetPos().x, -_size, -_space, nil, ent:GetPos().y, _map_size.sizeUp)

	if testW < _map_size.sizeW then
		_map_size.sizeW = testW
	end

	local testN = try_new_pos(ent:GetPos().y, _size, _space, ent:GetPos().x, nil, _map_size.sizeUp)

	if testN > _map_size.sizeN then
		_map_size.sizeN = testN
	end

	local testS = try_new_pos(ent:GetPos().y, -_size, -_space, ent:GetPos().x, nil, _map_size.sizeUp)

	if testS < _map_size.sizeS then
		_map_size.sizeS = testS
	end
end

local tries = 0

function get_coords()
	tries = tries + 1

	if skyCamera == nil then
		skyCamera = ents.FindByClass("sky_camera")
		skyCamera = skyCamera[1]
	end

	if _map_size.hasFog == nil then
		local tmpTable = ents.FindByClass("fog_controller")

		if tmpTable[1] ~= nil then
			_map_size.hasFog = true
		else
			_map_size.hasFog = false
		end
	end

	local _hasNoSpawnpoints = true

	for k, v in pairs(ents.GetAll()) do
		if YRPEntityAlive(v) and (v:GetClass() == "info_player_teamspawn" or v:GetClass() == "info_player_terrorist" or v:GetClass() == "info_player_counterterrorist") then
			_hasNoSpawnpoints = true
		end
	end

	for k, v in pairs(ents.GetAll()) do
		if _hasNoSpawnpoints then
			if v:GetClass() == "info_player_start" then
				search_coords(v)
			end
		else
			if v:GetClass() == "info_player_teamspawn" then
				search_coords(v)
			elseif v:GetClass() == "info_player_terrorist" then
				search_coords(v)
			elseif v:GetClass() == "info_player_counterterrorist" then
				search_coords(v)
			end
		end

		if v:GetClass() == "prop_door_rotating" then
			search_coords(v)
		end

		if v:GetClass() == "func_door" then
			search_coords(v)
		end

		if v:GetClass() == "func_door_rotating" then
			search_coords(v)
		end
	end

	--RoundDown
	_map_size.sizeN = math.Round(_map_size.sizeN)
	_map_size.sizeE = math.Round(_map_size.sizeE)
	_map_size.sizeS = math.Round(_map_size.sizeS)
	_map_size.sizeW = math.Round(_map_size.sizeW)
	_map_size.sizeUp = math.Round(_map_size.sizeUp)

	if _map_size.sizeUp - _map_size.spawnPointsH < 5000 then
		_map_size.eventH = _map_size.sizeUp
	else
		_map_size.eventH = _map_size.spawnPointsH + 5000
	end

	_map_size.eventH = _map_size.eventH - 256
	_map_size.sizeX = _map_size.sizeE + math.abs(_map_size.sizeW)
	_map_size.sizeY = _map_size.sizeN + math.abs(_map_size.sizeS)
	_map_size.sizeX = math.abs(_map_size.sizeX)
	_map_size.sizeY = math.abs(_map_size.sizeY)
	_map_size.sizeFE = _map_size.sizeX * _map_size.sizeY
	_map_size.midX = _map_size.sizeE - (_map_size.sizeX / 2)
	_map_size.midY = _map_size.sizeN - (_map_size.sizeY / 2)

	if _map_size.sizeX >= _map_size.sizeY then
		_map_size.facX = 1
		_map_size.facY = _map_size.sizeX / _map_size.sizeY --X: 30000 / 10000 = 3
	else
		_map_size.facX = _map_size.sizeY / _map_size.sizeX --Y: 30000 / 10000 = 3
		_map_size.facY = 1
	end

	--Ohne Problem durchcgelaufen
	_map_size.error = 0

	if (_map_size.sizeN == -9999999999 or _map_size.sizeS == 9999999999 or _map_size.sizeW == 9999999999 or _map_size.sizeE == -9999999999) and tries < 5 then
		timer.Simple(5, function()
			YRP.msg("note", "YRPGetMapDoors() retry")
			YRPGetMapDoors()
		end)
	end
end

function YRPGetMapDoors()
	get_coords()
end
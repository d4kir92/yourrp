--Copyright (C) 2017-2020 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

-- DO NOT TOUCH THE DATABASE FILES! If you have errors, report them here:
-- https://discord.gg/sEgNZxg

local HANDLER_STATUS = {}

function RemFromHandler_Status(ply)
	table.RemoveByValue(HANDLER_STATUS, ply)
	YRP.msg("gm", ply:YRPName() .. " disconnected from Status")
end

function AddToHandler_Status(ply)
	if !table.HasValue(HANDLER_STATUS, ply) then
		table.insert(HANDLER_STATUS, ply)
		YRP.msg("gm", ply:YRPName() .. " connected to Status")
	else
		YRP.msg("gm", ply:YRPName() .. " already connected to Status")
	end
end

util.AddNetworkString("Connect_Settings_Status")
net.Receive("Connect_Settings_Status", function(len, ply)
	if ply:CanAccess("bool_status") then
		AddToHandler_Status(ply)
		local _nw_yourrp = {}
		local _nw_roles = {}
		local _nw_groups = {}
		local _nw_map = {}
		_nw_map["jail"] = {}

		local _yourrp_content_found = false
		for i, addon in pairs(engine.GetAddons()) do
			if addon.wsid == "1189643820" then
				_yourrp_content_found = true
			end
		end
		if !_yourrp_content_found then
			_nw_yourrp["YourRP Content"] = {}
			_nw_yourrp["YourRP Content"]["LID_missingx"] = Color(255, 0, 0)
		end

		local _roles = SQL_SELECT("yrp_ply_roles", "*", nil)
		local _groups = SQL_SELECT("yrp_ply_groups", "*", nil)
		local _map = SQL_SELECT("yrp_" .. GetMapNameDB(), "*", nil)
		if wk(_roles) then
			for i, role in pairs(_roles) do
				if role.string_playermodels == "" or role.string_playermodels == " " then
					_nw_roles[role.string_name] = _nw_roles[role.string_name] or {}
					_nw_roles[role.string_name]["LID_hasnoplayermodel"] = Color(220, 220, 0)
				end
				if role.string_sweps == "" or role.string_sweps == " " then
					_nw_roles[role.string_name] = _nw_roles[role.string_name] or {}
					_nw_roles[role.string_name]["LID_hasnoswep"] = Color(220, 220, 0)
				end
			end
		end

		if _map == nil then
			_map = {}
		end
		if wk(_map) and wk(_groups) then
			for i, group in pairs(_groups) do
				local _has_no_spawnpoint = true
				for j, entry in pairs(_map) do
					if entry.type == "GroupSpawnpoint" and tonumber(entry.linkID) == tonumber(group.uniqueID) then
						_has_no_spawnpoint = false
					end
				end
				if _has_no_spawnpoint then
					_nw_groups[group.string_name] = _nw_groups[group.string_name] or {}
					_nw_groups[group.string_name]["LID_hasnogroupspawnpoint"] = Color(220, 220, 0)
				end
			end
			local _no_jailpoint = true
			local _no_releasepoint = true
			for i, entry in pairs(_map) do
				if entry.type == "jailpoint" then
					_no_jailpoint = false
				elseif entry.type == "releasepoint" then
					_no_releasepoint = false
				end
			end
			if _no_jailpoint then
				_nw_map["jail"]["LID_nojailpointfound"] = Color(220, 0, 0)
			end
			if _no_releasepoint then
				_nw_map["jail"]["LID_noreleasepointfound"] = Color(220, 0, 0)
			end
		end

		net.Start("Connect_Settings_Status")
			net.WriteTable(_nw_yourrp)
			net.WriteTable(_nw_roles)
			net.WriteTable(_nw_groups)
			net.WriteTable(_nw_map)
		net.Send(ply)
	end
end)

util.AddNetworkString("Disconnect_Settings_Status")
net.Receive("Disconnect_Settings_Status", function(len, ply)
	RemFromHandler_Status(ply)
end)

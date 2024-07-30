--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
-- DO NOT TOUCH THE DATABASE FILES! If you have errors, report them here:
-- https://discord.gg/sEgNZxg
local HANDLER_STATUS = {}
function RemFromHandler_Status(ply)
	table.RemoveByValue(HANDLER_STATUS, ply)
end

function AddToHandler_Status(ply)
	if not table.HasValue(HANDLER_STATUS, ply) then
		table.insert(HANDLER_STATUS, ply)
	end
end

YRP:AddNetworkString("nws_yrp_connect_Settings_Status")
net.Receive(
	"nws_yrp_connect_Settings_Status",
	function(len, ply)
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

			if not _yourrp_content_found then
				_nw_yourrp["YourRP Content"] = {}
				_nw_yourrp["YourRP Content"]["LID_missingx"] = Color(0, 255, 0)
			end

			if YRPCollectionID() == "0" then
				_nw_yourrp["Collection ID"] = {}
				_nw_yourrp["Collection ID"]["LID_thecollectionidismissing"] = Color(0, 255, 0)
			end

			if strEmpty(GetGlobalYRPString("text_server_name")) then
				_nw_yourrp["Hostname"] = {}
				_nw_yourrp["Hostname"]["Hostname is missing/empty"] = Color(255, 255, 0)
			end

			if strEmpty(GetGlobalYRPString("text_server_logo")) then
				_nw_yourrp["ServerLogo"] = {}
				_nw_yourrp["ServerLogo"]["Server Logo is missing/empty"] = Color(255, 255, 0)
			end

			if strEmpty(GetGlobalYRPString("text_character_background")) then
				_nw_yourrp["backgroundcharacter"] = {}
				_nw_yourrp["backgroundcharacter"]["Character Background is missing"] = Color(255, 255, 0)
			end

			local _roles = YRP_SQL_SELECT("yrp_ply_roles", "*", nil)
			local _groups = YRP_SQL_SELECT("yrp_ply_groups", "*", nil)
			local _map = YRP_SQL_SELECT("yrp_" .. GetMapNameDB(), "*", nil)
			if IsNotNilAndNotFalse(_roles) then
				for i, role in pairs(_roles) do
					if role.string_playermodels == "" or role.string_playermodels == " " then
						_nw_roles[role.string_name] = _nw_roles[role.string_name] or {}
						_nw_roles[role.string_name]["LID_hasnoplayermodel"] = Color(220, 220, 0)
					end
					--[[if role.string_sweps == "" or role.string_sweps == " " then
					_nw_roles[role.string_name] = _nw_roles[role.string_name] or {}
					_nw_roles[role.string_name]["LID_hasnoswep"] = Color(220, 220, 0)
				end]]
				end
			end

			if _map == nil then
				_map = {}
			end

			if IsNotNilAndNotFalse(_map) and IsNotNilAndNotFalse(_groups) then
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

			net.Start("nws_yrp_connect_Settings_Status")
			net.WriteTable(_nw_yourrp)
			net.WriteTable(_nw_roles)
			net.WriteTable(_nw_groups)
			net.WriteTable(_nw_map)
			net.Send(ply)
		end
	end
)

YRP:AddNetworkString("nws_yrp_disconnect_Settings_Status")
net.Receive(
	"nws_yrp_disconnect_Settings_Status",
	function(len, ply)
		RemFromHandler_Status(ply)
	end
)

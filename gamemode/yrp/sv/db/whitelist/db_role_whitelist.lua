--Copyright (C) 2017-2019 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

-- DO NOT TOUCH THE DATABASE FILES! If you have errors, report them here:
-- https://discord.gg/sEgNZxg

-- #WHITELISTDATABASE

local DATABASE_NAME = "yrp_role_whitelist"

SQL_ADD_COLUMN(DATABASE_NAME, "SteamID", "TEXT DEFAULT ''")
SQL_ADD_COLUMN(DATABASE_NAME, "name", "TEXT DEFAULT ''")
SQL_ADD_COLUMN(DATABASE_NAME, "nick", "TEXT DEFAULT ''")
SQL_ADD_COLUMN(DATABASE_NAME, "groupID", "INTEGER DEFAULT -1")
SQL_ADD_COLUMN(DATABASE_NAME, "roleID", "INTEGER DEFAULT -1")
SQL_ADD_COLUMN(DATABASE_NAME, "status", "TEXT DEFAULT ''")
SQL_ADD_COLUMN(DATABASE_NAME, "date", "TEXT DEFAULT '0000-00-00 00-00-00'")

--db_drop_table(DATABASE_NAME)
--db_is_empty(DATABASE_NAME)

util.AddNetworkString("getRoleWhitelist")
util.AddNetworkString("whitelistPlayer")
util.AddNetworkString("whitelistPlayerGroup")
util.AddNetworkString("whitelistPlayerAll")
util.AddNetworkString("whitelistPlayerRemove")
util.AddNetworkString("yrpInfoBox")

function sendRoleWhitelist(ply)
	local tabW = SQL_SELECT("yrp_role_whitelist", "*", nil)
	for i, v in pairs(tabW) do
		v.groupID = tonumber(v.groupID)
		v.roleID = tonumber(v.roleID)

		if v.groupID > 0 then
			local tabG = SQL_SELECT("yrp_ply_groups", "*", "uniqueID = '" .. v.groupID .. "'")
			if !wk(tabG) then
				SQL_DELETE_FROM(DATABASE_NAME, "uniqueID = '" .. v.uniqueID .. "'")
			end
		end
		if v.roleID > 0 then
			local tabR = SQL_SELECT("yrp_ply_roles", "*", "uniqueID = '" .. v.roleID .. "'")
			if !wk(tabR) then
				SQL_DELETE_FROM(DATABASE_NAME, "uniqueID = '" .. v.uniqueID .. "'")
			end
		end
	end

	if ply:CanAccess("bool_players") or ply:CanAccess("bool_whitelist") then
		local _tmpWhiteList = SQL_SELECT("yrp_role_whitelist", "*", nil)
		local _tmpRoleList = SQL_SELECT("yrp_ply_roles", "int_groupID, string_name, uniqueID", nil)
		local _tmpGroupList = SQL_SELECT("yrp_ply_groups", "string_name, uniqueID", nil)

		if !wk(_tmpWhiteList) then
			_tmpWhiteList = {}
		end

		if _tmpRoleList != nil and _tmpGroupList != nil then
			net.Start("getRoleWhitelist")
				net.WriteTable(_tmpWhiteList)
				net.WriteTable(_tmpRoleList)
				net.WriteTable(_tmpGroupList)
			net.Send(ply)
		else
			printGM("error", "group and role list broken")
		end
	end
end

net.Receive("whitelistPlayerRemove", function(len, ply)
	local _tmpUniqueID = net.ReadInt(16)
	SQL_DELETE_FROM("yrp_role_whitelist", "uniqueID = " .. _tmpUniqueID)
end)

net.Receive("whitelistPlayer", function(len, ply)
	if ply:HasAccess() then
		local _SteamID = net.ReadString()
		local _nick = ""
		local target = ply
		for k, v in pairs(player.GetAll()) do
			if v:SteamID() == _SteamID then
				_nick = v:Nick()
				target = v
			end
		end
		local _roleID = net.ReadInt(16)
		local _dbRole = SQL_SELECT("yrp_ply_roles", "*", "uniqueID = " .. _roleID)
		if wk(_dbRole) then
			local _groupID = _dbRole[1].int_groupID

			local dat = util.DateStamp()
			local status = "Manually by " .. ply:SteamName()
			local name = target:SteamName()
			SQL_INSERT_INTO("yrp_role_whitelist", "SteamID, nick, groupID, roleID, date, status, name", "'" .. _SteamID .. "', '" .. SQL_STR_IN(_nick) .. "', " .. _groupID .. ", " .. _roleID .. ", '" .. dat .. "', '" .. status .. "', '" .. name .. "'")
		else
			printGM("note", "whitelistPlayer FAILED! CALL DEVS")
		end
	end
	sendRoleWhitelist(ply)
end)

net.Receive("whitelistPlayerGroup", function(len, ply)
	if ply:HasAccess() then
		local _SteamID = net.ReadString()
		local _nick = ""
		for k, v in pairs(player.GetAll()) do
			if v:SteamID() == _SteamID then
				_nick = v:Nick()
				target = v
			end
		end
		local _groupID = net.ReadInt(16)
		local _dbRole = SQL_SELECT("yrp_ply_groups", "*", "uniqueID = " .. _groupID)

		local dat = util.DateStamp()
		local status = "Manually by " .. ply:SteamName()
		local name = target:SteamName()
		SQL_INSERT_INTO("yrp_role_whitelist", "SteamID, nick, groupID, date, status, name", "'" .. _SteamID .. "', '" .. SQL_STR_IN(_nick) .. "', " .. _groupID .. ", '" .. dat .. "', '" .. status .. "', '" .. name .. "'")
	end
	sendRoleWhitelist(ply)
end)

net.Receive("whitelistPlayerAll", function(len, ply)
	if ply:HasAccess() then
		local _SteamID = net.ReadString()
		local _nick = ""
		for k, v in pairs(player.GetAll()) do
			if v:SteamID() == _SteamID then
				_nick = v:Nick()
				target = v
			end
		end

		local dat = util.DateStamp()
		local status = "Manually by " .. ply:SteamName()
		local name = target:SteamName()
		SQL_INSERT_INTO("yrp_role_whitelist", "SteamID, nick, roleID, groupID, date, status, name", "'" .. _SteamID .. "', '" .. SQL_STR_IN(_nick) .. "', " .. "-1" .. ", " .. "-1" .. ", '" .. dat .. "', '" .. status .. "', '" .. name .. "'")
	end
	sendRoleWhitelist(ply)
end)

net.Receive("getRoleWhitelist", function(len, ply)
	sendRoleWhitelist(ply)
end)

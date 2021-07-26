--Copyright (C) 2017-2021 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

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
util.AddNetworkString("getRoleWhitelist_line")
util.AddNetworkString("whitelistPlayer")
util.AddNetworkString("whitelistPlayerGroup")
util.AddNetworkString("whitelistPlayerAll")
util.AddNetworkString("whitelistPlayerRemove")
util.AddNetworkString("yrpInfoBox")

util.AddNetworkString("getGroupsWhitelist")
net.Receive("getGroupsWhitelist", function(len, ply)
	local _tmpGroupList = SQL_SELECT("yrp_ply_groups", "string_name, uniqueID", nil)
	if wk(_tmpGroupList) then
		net.Start("getGroupsWhitelist")
			net.WriteTable(_tmpGroupList)
		net.Send(ply)
	end
end)

util.AddNetworkString("getRolesWhitelist")
net.Receive("getRolesWhitelist", function(len, ply)
	local _tmpRoleList = SQL_SELECT("yrp_ply_roles", "int_groupID, string_name, uniqueID", nil)
	if wk(_tmpRoleList) then
		net.Start("getRolesWhitelist")
			net.WriteTable(_tmpRoleList)
		net.Send(ply)
	end
end)

function sendRoleWhitelist(ply)
	local tabW = SQL_SELECT("yrp_role_whitelist", "*", nil)

	if !wk(tabW) then
		tabW = {}
	end

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

	if ply:CanAccess("bool_whitelist") then
		local _tmpWhiteList = SQL_SELECT("yrp_role_whitelist", "*", nil)

		if !wk(_tmpWhiteList) then
			_tmpWhiteList = {}
		end

		for i, line in pairs(_tmpWhiteList) do
			--timer.Simple(0.001 * i, function()
				net.Start("getRoleWhitelist_line")
					net.WriteString(i)
					net.WriteTable(line)
					net.WriteBool(i == #_tmpWhiteList)
				net.Send(ply)
			--end)
		end

		--[[
		net.Start("getRoleWhitelist")
			net.WriteTable(_tmpWhiteList)
		net.Send(ply)
		]]
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
		local roleID = net.ReadInt(16)
		local DBRole = SQL_SELECT("yrp_ply_roles", "*", "uniqueID = " .. roleID)
		if wk(DBRole) then
			DBRole = DBRole[1]
			local _groupID = DBRole.int_groupID

			local dat = util.DateStamp()
			local status = "Manually by " .. ply:SteamName()
			local name = target:SteamName()
			SQL_INSERT_INTO("yrp_role_whitelist", "SteamID, nick, groupID, roleID, date, status, name", "'" .. _SteamID .. "', '" .. SQL_STR_IN(_nick) .. "', " .. _groupID .. ", " .. roleID .. ", '" .. dat .. "', '" .. SQL_STR_IN(status) .. "', '" .. SQL_STR_IN(name) .. "'")
			SQL_INSERT_INTO("yrp_logs",	"string_timestamp, string_typ, string_source_steamid, string_target_steamid, string_value", "'" .. os.time() .. "' ,'LID_whitelist', '" .. ply:SteamID64() .. "', '" .. target:SteamID64() .. "', 'Role: " .. DBRole.string_name .. "'")
		else
			YRP.msg("note", "whitelistPlayer FAILED! CALL DEVS")
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
		local groupID = net.ReadInt(16)
		local DBGroup = SQL_SELECT("yrp_ply_groups", "*", "uniqueID = " .. groupID)
		if wk(DBGroup) then
			DBGroup = DBGroup[1]
		end
		local dat = util.DateStamp()
		local status = "Manually by " .. ply:SteamName()
		local name = target:SteamName()
		SQL_INSERT_INTO("yrp_role_whitelist", "SteamID, nick, groupID, date, status, name", "'" .. _SteamID .. "', '" .. SQL_STR_IN(_nick) .. "', " .. groupID .. ", '" .. dat .. "', '" .. status .. "', '" .. name .. "'")
		SQL_INSERT_INTO("yrp_logs",	"string_timestamp, string_typ, string_source_steamid, string_target_steamid, string_value", "'" .. os.time() .. "' ,'LID_whitelist', '" .. ply:SteamID64() .. "', '" .. target:SteamID64() .. "', 'Group: " .. DBGroup.string_name .. "'")
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
		SQL_INSERT_INTO("yrp_logs",	"string_timestamp, string_typ, string_source_steamid, string_target_steamid, string_value", "'" .. os.time() .. "' ,'LID_whitelist', '" .. ply:SteamID64() .. "', '" .. target:SteamID64() .. "', '" .. "ALL" .. "'")
	end
	sendRoleWhitelist(ply)
end)

net.Receive("getRoleWhitelist", function(len, ply)
	sendRoleWhitelist(ply)
end)



-- for itzonelightning
function WhitelistToRole(ply, rid)

	local _SteamID = ply:SteamID()
	local _nick = ply:Nick()
	local target = ply
	local roleID = rid

	local DBRole = SQL_SELECT("yrp_ply_roles", "*", "uniqueID = " .. roleID)
	if wk(DBRole) then
		DBRole = DBRole[1]
		local _groupID = DBRole.int_groupID

		local dat = util.DateStamp()
		local status = "WhitelistToRole by " .. ply:SteamName()
		local name = target:SteamName()
		SQL_INSERT_INTO("yrp_role_whitelist", "SteamID, nick, groupID, roleID, date, status, name", "'" .. _SteamID .. "', '" .. SQL_STR_IN(_nick) .. "', " .. _groupID .. ", " .. roleID .. ", '" .. dat .. "', '" .. SQL_STR_IN(status) .. "', '" .. SQL_STR_IN(name) .. "'")
		SQL_INSERT_INTO("yrp_logs",	"string_timestamp, string_typ, string_source_steamid, string_target_steamid, string_value", "'" .. os.time() .. "' ,'LID_whitelist', '" .. ply:SteamID64() .. "', '" .. target:SteamID64() .. "', 'Role: " .. DBRole.string_name .. "'")
	else
		YRP.msg("note", "WhitelistToRole FAILED! CALL DEVS")
	end
end


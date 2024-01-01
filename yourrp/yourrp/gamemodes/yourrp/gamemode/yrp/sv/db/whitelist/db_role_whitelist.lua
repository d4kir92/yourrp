--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
-- DO NOT TOUCH THE DATABASE FILES! If you have errors, report them here:
-- https://discord.gg/sEgNZxg
-- #WHITELISTDATABASE
local DATABASE_NAME = "yrp_role_whitelist"
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "SteamID", "TEXT DEFAULT ''")
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "name", "TEXT DEFAULT ''")
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "nick", "TEXT DEFAULT ''")
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "groupID", "INTEGER DEFAULT -1")
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "roleID", "INTEGER DEFAULT -1")
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "status", "TEXT DEFAULT ''")
YRP_SQL_ADD_COLUMN(DATABASE_NAME, "date", "TEXT DEFAULT '0000-00-00 00-00-00'")
util.AddNetworkString("nws_yrp_getRoleWhitelist")
util.AddNetworkString("nws_yrp_getRoleWhitelist_line")
util.AddNetworkString("nws_yrp_whitelistPlayer")
util.AddNetworkString("nws_yrp_whitelistPlayerGroup")
util.AddNetworkString("nws_yrp_whitelistPlayerAll")
util.AddNetworkString("nws_yrp_whitelistPlayerRemove")
util.AddNetworkString("nws_yrp_InfoBox")
util.AddNetworkString("nws_yrp_getGroupsWhitelist")
net.Receive(
	"nws_yrp_getGroupsWhitelist",
	function(len, ply)
		if not ply:GetYRPBool("bool_whitelist", false) then return end
		local _tmpGroupList = YRP_SQL_SELECT("yrp_ply_groups", "string_name, uniqueID", nil)
		if IsNotNilAndNotFalse(_tmpGroupList) then
			net.Start("nws_yrp_getGroupsWhitelist")
			net.WriteTable(_tmpGroupList)
			net.Send(ply)
		end
	end
)

util.AddNetworkString("nws_yrp_getRolesWhitelist")
net.Receive(
	"nws_yrp_getRolesWhitelist",
	function(len, ply)
		if not ply:GetYRPBool("bool_whitelist", false) then return end
		local _tmpRoleList = YRP_SQL_SELECT("yrp_ply_roles", "int_groupID, string_name, uniqueID", nil)
		if IsNotNilAndNotFalse(_tmpRoleList) then
			net.Start("nws_yrp_getRolesWhitelist")
			net.WriteTable(_tmpRoleList)
			net.Send(ply)
		end
	end
)

function sendRoleWhitelist(ply)
	local tabW = YRP_SQL_SELECT("yrp_role_whitelist", "*", nil)
	if not IsNotNilAndNotFalse(tabW) then
		tabW = {}
	end

	for i, v in pairs(tabW) do
		v.groupID = tonumber(v.groupID)
		v.roleID = tonumber(v.roleID)
		if v.groupID > 0 then
			local tabG = YRP_SQL_SELECT("yrp_ply_groups", "*", "uniqueID = '" .. v.groupID .. "'")
			if not IsNotNilAndNotFalse(tabG) then
				YRP_SQL_DELETE_FROM(DATABASE_NAME, "uniqueID = '" .. v.uniqueID .. "'")
			end
		end

		if v.roleID > 0 then
			local tabR = YRP_SQL_SELECT("yrp_ply_roles", "*", "uniqueID = '" .. v.roleID .. "'")
			if not IsNotNilAndNotFalse(tabR) then
				YRP_SQL_DELETE_FROM(DATABASE_NAME, "uniqueID = '" .. v.uniqueID .. "'")
			end
		end
	end

	if ply:CanAccess("bool_whitelist") then
		local _tmpWhiteList = YRP_SQL_SELECT("yrp_role_whitelist", "*", nil)
		if not IsNotNilAndNotFalse(_tmpWhiteList) then
			_tmpWhiteList = {}
		end

		if table.Count(_tmpWhiteList) < 1 then
			net.Start("nws_yrp_getRoleWhitelist_line")
			net.WriteString(1)
			net.WriteTable({})
			net.WriteBool(true)
			net.Send(ply)
		else
			for i, line in pairs(_tmpWhiteList) do
				net.Start("nws_yrp_getRoleWhitelist_line")
				net.WriteString(i)
				net.WriteTable(line)
				net.WriteBool(i == #_tmpWhiteList)
				net.Send(ply)
			end
		end
	end
end

net.Receive(
	"nws_yrp_whitelistPlayerRemove",
	function(len, ply)
		if not ply:GetYRPBool("bool_whitelist", false) then return end
		local _tmpUniqueID = net.ReadInt(16)
		YRP_SQL_DELETE_FROM("yrp_role_whitelist", "uniqueID = " .. _tmpUniqueID)
	end
)

net.Receive(
	"nws_yrp_whitelistPlayer",
	function(len, ply)
		if not ply:GetYRPBool("bool_whitelist", false) then return end
		if not IsValid(ply) then return end
		local _SteamID = net.ReadString()
		local _nick = ""
		local target = ply
		for k, v in pairs(player.GetAll()) do
			if v:YRPSteamID() == _SteamID then
				_nick = v:Nick()
				target = v
			end
		end

		local roleID = net.ReadInt(16)
		local DBRole = YRP_SQL_SELECT("yrp_ply_roles", "*", "uniqueID = " .. roleID)
		if IsNotNilAndNotFalse(DBRole) then
			DBRole = DBRole[1]
			local _groupID = DBRole.int_groupID
			local dat = util.DateStamp()
			local status = "Manually by " .. ply:SteamName()
			local name = target:SteamName()
			YRP_SQL_INSERT_INTO("yrp_role_whitelist", "SteamID, nick, groupID, roleID, date, status, name", "'" .. _SteamID .. "', " .. YRP_SQL_STR_IN(_nick) .. ", " .. _groupID .. ", " .. roleID .. ", '" .. dat .. "', '" .. status .. "', " .. YRP_SQL_STR_IN(name) .. "")
			YRP_SQL_INSERT_INTO("yrp_logs", "string_timestamp, string_typ, string_source_steamid, string_target_steamid, string_value", "'" .. os.time() .. "' ,'LID_whitelist', '" .. ply:SteamID() .. "', '" .. target:SteamID() .. "', 'Role: " .. DBRole.string_name .. "'")
		else
			YRP.msg("note", "whitelistPlayer FAILED! CALL DEVS")
		end

		sendRoleWhitelist(ply)
	end
)

net.Receive(
	"nws_yrp_whitelistPlayerGroup",
	function(len, ply)
		if not ply:GetYRPBool("bool_whitelist", false) then return end
		local _SteamID = net.ReadString()
		local _nick = ""
		local target = nil
		for k, v in pairs(player.GetAll()) do
			if v:YRPSteamID() == _SteamID then
				_nick = v:Nick()
				target = v
			end
		end

		local groupID = net.ReadInt(16)
		local DBGroup = YRP_SQL_SELECT("yrp_ply_groups", "*", "uniqueID = " .. groupID)
		if IsNotNilAndNotFalse(DBGroup) then
			DBGroup = DBGroup[1]
		end

		local dat = util.DateStamp()
		local status = "Manually by " .. ply:SteamName()
		local name = target:SteamName()
		YRP_SQL_INSERT_INTO("yrp_role_whitelist", "SteamID, nick, groupID, date, status, name", "'" .. _SteamID .. "', " .. YRP_SQL_STR_IN(_nick) .. ", " .. groupID .. ", '" .. dat .. "', '" .. status .. "', " .. YRP_SQL_STR_IN(name) .. "")
		YRP_SQL_INSERT_INTO("yrp_logs", "string_timestamp, string_typ, string_source_steamid, string_target_steamid, string_value", "'" .. os.time() .. "' ,'LID_whitelist', '" .. ply:SteamID() .. "', '" .. target:SteamID() .. "', 'Group: " .. DBGroup.string_name .. "'")
		sendRoleWhitelist(ply)
	end
)

net.Receive(
	"nws_yrp_whitelistPlayerAll",
	function(len, ply)
		if not ply:GetYRPBool("bool_whitelist", false) then return end
		local _SteamID = net.ReadString()
		local _nick = ""
		local target = nil
		for k, v in pairs(player.GetAll()) do
			if v:YRPSteamID() == _SteamID then
				_nick = v:Nick()
				target = v
			end
		end

		local dat = util.DateStamp()
		local status = "Manually by " .. ply:SteamName()
		local name = target:SteamName()
		YRP_SQL_INSERT_INTO("yrp_role_whitelist", "SteamID, nick, roleID, groupID, date, status, name", "'" .. _SteamID .. "', " .. YRP_SQL_STR_IN(_nick) .. ", " .. "-1" .. ", " .. "-1" .. ", '" .. dat .. "', '" .. status .. "', " .. YRP_SQL_STR_IN(name) .. "")
		YRP_SQL_INSERT_INTO("yrp_logs", "string_timestamp, string_typ, string_source_steamid, string_target_steamid, string_value", "'" .. os.time() .. "' ,'LID_whitelist', '" .. ply:SteamID() .. "', '" .. target:SteamID() .. "', '" .. "ALL" .. "'")
		sendRoleWhitelist(ply)
	end
)

net.Receive(
	"nws_yrp_getRoleWhitelist",
	function(len, ply)
		if not ply:GetYRPBool("bool_whitelist", false) then return end
		sendRoleWhitelist(ply)
	end
)

-- for itzonelightning
function WhitelistToRole(ply, rid)
	local _SteamID = ply:YRPSteamID()
	local _nick = ply:Nick()
	local target = ply
	local roleID = rid
	local DBRole = YRP_SQL_SELECT("yrp_ply_roles", "*", "uniqueID = " .. roleID)
	if IsNotNilAndNotFalse(DBRole) then
		DBRole = DBRole[1]
		local _groupID = DBRole.int_groupID
		local dat = util.DateStamp()
		local status = "WhitelistToRole by " .. ply:SteamName()
		local name = target:SteamName()
		YRP_SQL_INSERT_INTO("yrp_role_whitelist", "SteamID, nick, groupID, roleID, date, status, name", "'" .. _SteamID .. "', " .. YRP_SQL_STR_IN(_nick) .. ", " .. _groupID .. ", " .. roleID .. ", '" .. dat .. "', '" .. status .. "', " .. YRP_SQL_STR_IN(name) .. "")
		YRP_SQL_INSERT_INTO("yrp_logs", "string_timestamp, string_typ, string_source_steamid, string_target_steamid, string_value", "'" .. os.time() .. "' ,'LID_whitelist', '" .. ply:SteamID() .. "', '" .. target:SteamID() .. "', 'Role: " .. DBRole.string_name .. "'")
	else
		YRP.msg("note", "WhitelistToRole FAILED! CALL DEVS")
	end
end
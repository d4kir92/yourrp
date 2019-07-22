--Copyright (C) 2017-2019 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

-- DO NOT TOUCH THE DATABASE FILES! If you have errors, report them here:
-- https://discord.gg/sEgNZxg

local DATABASE_NAME = "yrp_lockdown"

--SQL_DROP_TABLE(DATABASE_NAME)

SQL_ADD_COLUMN(DATABASE_NAME, "string_lockdowntext", "TEXT DEFAULT 'LockdownText'")
SQL_ADD_COLUMN(DATABASE_NAME, "bool_lockdown", "INT DEFAULT '0'")

if SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '1'") == nil then
	SQL_INSERT_INTO(DATABASE_NAME, "string_lockdowntext", "'LockdownText'")
end

local Player = FindMetaTable("Player")
function Player:LockdownLoadout()
	--printGM("gm", self:SteamName() .. " UserGroupLoadout")
	local lockdown = SQL_SELECT(DATABASE_NAME, "*", "uniqueID = '1'")
	if wk(lockdown) then
		lockdown = lockdown[1]
		lockdown.bool_lockdown = tobool(lockdown.bool_lockdown)
		for i, pl in pairs(player.GetAll()) do
			pl:SetDBool("bool_lockdown", lockdown.bool_lockdown)
			pl:SetDBool("string_lockdowntext", SQL_STR_OUT(lockdown.string_lockdowntext))
		end
	else
		YRP.msg("note", "LockdownLoadout FAILED")
	end
end

util.AddNetworkString("set_lockdowntext")
net.Receive("set_lockdowntext", function(len, ply)
	local string_lockdowntext = net.ReadString()
	string_lockdowntext = SQL_STR_IN(string_lockdowntext)
	YRP.msg("db", "Changed lockdowntext to: " .. string_lockdowntext)
	SQL_UPDATE(DATABASE_NAME, "string_lockdowntext = '" .. string_lockdowntext .. "'", "uniqueID = '1'")

	for i, pl in pairs(player.GetAll()) do
		pl:LockdownLoadout()
	end
end)

util.AddNetworkString("set_lockdown")
net.Receive("set_lockdown", function(len, ply)
	local bool_lockdown = net.ReadBool()
	bool_lockdown = tonum(bool_lockdown)
	YRP.msg("db", "Changed bool_lockdown to: " .. tostring(bool_lockdown))
	SQL_UPDATE(DATABASE_NAME, "bool_lockdown = '" .. bool_lockdown .. "'", "uniqueID = '1'")

	for i, pl in pairs(player.GetAll()) do
		pl:LockdownLoadout()
	end
end)

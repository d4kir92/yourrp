--Copyright (C) 2017-2019 Arno Zura (https://www.gnu.org/licenses/gpl.txt)

-- DO NOT TOUCH THE DATABASE FILES! If you have errors, report them here:
-- https://discord.gg/sEgNZxg

util.AddNetworkString("get_sql_info")

local DATABASE_NAME = "yrp_sql"

function SQLITE_CHECK_IF_COLUMN_EXISTS(db_name, column_name)
	--printGM("db", "SQL_CHECK_IF_COLUMN_EXISTS(" .. tostring(db_name) .. ", " .. tostring(column_name) .. ")")
	local _result = sql.Query("SELECT " .. column_name .. " FROM " .. db_name)
	if _result == false then
		return false
	else
		return true
	end
end

function SQLITE_ADD_COLUMN(table_name, column_name, datatype)
	--printGM("db", "SQL_ADD_COLUMN(" .. tostring(table_name) .. ", " .. tostring(column_name) .. ", " .. tostring(datatype) .. ")")
	local _result = SQLITE_CHECK_IF_COLUMN_EXISTS(table_name, column_name)
	if !_result then
		local _q = "ALTER TABLE " .. table_name .. " ADD " .. column_name .. " " .. datatype .. ""
		local _r = sql.Query(_q)
		if _r != nil then
			printGM("error", "SQLITE_ADD_COLUMN failed! query: " .. tostring(_q) .. " result: " .. tostring(_result) .. " lastError: " .. sql_show_last_error())
		end
		return _r
	end
end

SQLITE_ADD_COLUMN(DATABASE_NAME, "string_mode", "TEXT DEFAULT '0'", true)
SQLITE_ADD_COLUMN(DATABASE_NAME, "int_mode", "INT DEFAULT '0'", true)
SQLITE_ADD_COLUMN(DATABASE_NAME, "string_host", "TEXT DEFAULT 'UNKNOWN HOST'", true)
SQLITE_ADD_COLUMN(DATABASE_NAME, "string_database", "TEXT DEFAULT 'UNKNOWN DATABASE'", true)
SQLITE_ADD_COLUMN(DATABASE_NAME, "string_username", "TEXT DEFAULT 'UNKNOWN USERNAME'", true)
SQLITE_ADD_COLUMN(DATABASE_NAME, "string_password", "TEXT DEFAULT 'ADMIN'", true)
SQLITE_ADD_COLUMN(DATABASE_NAME, "int_port", "INT DEFAULT '12345'", true)

SQLITE_ADD_COLUMN(DATABASE_NAME, "int_backup_create", "INT DEFAULT '1'", true)
SQLITE_ADD_COLUMN(DATABASE_NAME, "int_backup_delete", "INT DEFAULT '30'", true)

if sql.Query("SELECT * FROM yrp_sql") == nil then
	printGM("db", "Missing first entry, insert it now!")
	sql.Query("INSERT INTO yrp_sql DEFAULT VALUES")
end

local yrp_sql = {}

local _init_yrp_sql = sql.Query("SELECT * FROM " .. DATABASE_NAME)
if wk(_init_yrp_sql) then
	yrp_sql = _init_yrp_sql[1]
end

-- NEW
function BroadcastString(tab)
	if tab.handler != nil then
		for i, pl in pairs(tab.handler) do
			if pl != tab.ply or tab.force then
				net.Start(tab.netstr)
					net.WriteString(tab.uniqueID)
					net.WriteString(tab.value)
				net.Send(pl)
			end
		end
	end
end

function BroadcastInt(tab)
	for i, pl in pairs(tab.handler) do
		if pl != tab.ply or tab.force then
			net.Start(tab.netstr)
				net.WriteString(tab.uniqueID)
				net.WriteString(tab.value)
			net.Send(pl)
		end
	end
end

function BroadcastFloat(tab)
	for i, pl in pairs(tab.handler) do
		if pl != tab.ply or tab.force then
			net.Start(tab.netstr)
				net.WriteString(tab.uniqueID)
				net.WriteString(tab.value)
			net.Send(pl)
		end
	end
end

function UpdateValue(tab)
	tab.uniqueID = tab.uniqueID or 1
	sql.Query("UPDATE " .. tab.db .. " SET " .. tab.id .. " = '" .. tab.value .. "' WHERE uniqueID = '" .. tab.uniqueID .. "'")
end

function UpdateString(tab)
	printGM("db", tab.ply:YRPName() .. " updated string " .. tab.id .. " to: " .. tab.value)
	UpdateValue(tab)
end

function UpdateInt(tab)
	printGM("db", tab.ply:YRPName() .. " updated int " .. tab.id .. " to: " .. tab.value)
	UpdateValue(tab)
end

function UpdateFloat(tab)
	printGM("db", tab.ply:YRPName() .. " updated float " .. tab.id .. " to: " .. tab.value)
	UpdateValue(tab)
end

-- NEW
function DBUpdateValue(db_name, str, l_db, value)
	if l_db != nil then
		l_db[str] = value
	end
	sql.Query("UPDATE " .. db_name .. " SET " .. str .. " = '" .. value .. "' WHERE uniqueID = '1'")
end

function DBUpdateFloat(db_name, ply, netstr, str, l_db, value)
	printGM("db", ply:YRPName() .. " updated float " .. str .. " to: " .. tostring(value))
	DBUpdateValue(db_name, str, l_db, value)
end

function DBUpdateInt(db_name, ply, netstr, str, l_db, value)
	printGM("db", ply:YRPName() .. " updated int " .. str .. " to: " .. tostring(value))
	DBUpdateValue(db_name, str, l_db, value)
end

function DBUpdateString(db_name, ply, netstr, str, l_db, value)
	printGM("db", ply:YRPName() .. " updated string " .. str .. " to: " .. tostring(value))
	DBUpdateValue(db_name, str, l_db, value)
end

for str, val in pairs(yrp_sql) do
	if string.find(str, "int_") then
		util.AddNetworkString("update_" .. str)
		net.Receive("update_" .. str, function(len, ply)
			local i = net.ReadInt(32)
			DBUpdateInt(DATABASE_NAME, ply, "update_" .. str, str, yrp_sql, i)
		end)
	elseif string.find(str, "float_") then
		util.AddNetworkString("update_" .. str)
		net.Receive("update_" .. str, function(len, ply)
			local f = net.ReadFloat()
			DBUpdateFloat(DATABASE_NAME, ply, "update_" .. str, str, yrp_sql, f)
		end)
	elseif string.find(str, "string_") then
		util.AddNetworkString("update_" .. str)
		net.Receive("update_" .. str, function(len, ply)
			local s = net.ReadString()
			DBUpdateString(DATABASE_NAME, ply, "update_" .. str, str, yrp_sql, s)
		end)
	end
end

net.Receive("get_sql_info", function(len, ply)
	local _sql_info = sql.Query("SELECT * FROM " .. DATABASE_NAME)

	if _sql_info != nil and _sql_info != false then
		_sql_info = _sql_info[1]
		net.Start("get_sql_info")
			net.WriteTable(_sql_info)
		net.Send(ply)
	end
end)

util.AddNetworkString("change_to_sql_mode")
net.Receive("change_to_sql_mode", function(len, ply)
	local _mode = net.ReadInt(32)
	if ply:HasAccess() then
		DBUpdateInt(DATABASE_NAME, ply, "update_" .. "int_mode", "int_mode", yrp_sql, _mode)
		SetSQLMode(_mode)
		printGM("note", ply:YRPName() .. " changed sqlmode to " .. GetSQLModeName())
		timer.Simple(1, function()
			game.ConsoleCommand("changelevel " .. GetMapName() .. "\n")
		end)
	else
		printGM("note", ply:YRPName() .. " tried to use change_to_sql_mode")
	end
end)

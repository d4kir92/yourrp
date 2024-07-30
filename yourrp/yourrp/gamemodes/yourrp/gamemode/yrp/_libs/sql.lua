--Copyright (C) 2017-2024 D4KiR (https://www.gnu.org/licenses/gpl.txt)
local _type = type
function disk_full(error)
	if string.find(error, "database or disk is full", 1, true) then
		if SERVER then
			PrintMessage(HUD_PRINTCENTER, "database or disk is full, please make more space!")
			net.Start("nws_yrp_noti")
			net.WriteString("database_full_server")
			net.WriteString("")
			net.Broadcast()
		elseif CLIENT then
			local lply = LocalPlayer()
			notification.AddLegacy("[YourRP] Database or disk is full, please make more space!", NOTIFY_ERROR, 40)
			YRP:msg("error", GetSQLModeName() .. ": " .. tostring(lply:YRPSteamID()) .. " ( database or disk is full)")
		end
	end
end

function YRP_SQL_Show_Last_Error()
	--YRP:msg( "db", "YRP_SQL_Show_Last_Error()" )
	local _last_error = tostring(sql.LastError()) or ""
	MsgC(Color(0, 255, 0), "DATABASE HAS ERROR: " .. _last_error)
	if SERVER then
		PrintMessage(HUD_PRINTCENTER, "[YourRP|DATABASE] SERVER-DATABASE:")
		PrintMessage(HUD_PRINTCENTER, _last_error)
	elseif CLIENT then
		local lply = LocalPlayer()
		if YRPEntityAlive(lply) then
			lply:PrintMessage(HUD_PRINTTALK, "[YourRP|DATABASE] CLIENT-DATABASE:")
			lply:PrintMessage(HUD_PRINTTALK, _last_error)
		end
	end

	timer.Simple(
		3,
		function()
			disk_full(_last_error)
		end
	)

	return _last_error
end

function YRP_SQL_STR_IN(str, f, bNoQuotes)
	if str == nil and f then
		MsgC(Color(0, 255, 0), f)

		return str
	else
		str = string.Replace(str, "'", "§01§")

		return sql.SQLStr(tostring(str), bNoQuotes)
	end
end

function YRP_SQL_STR_OUT(str)
	local _res = str
	if _type(_res) == "string" then
		_res = string.Replace(_res, "§01§", "'")

		return _res
	else
		return ""
	end
end

function db_int(int)
	local _int = tonumber(int)
	if isnumber(_int) then
		return _int
	else
		YRP:msg("error", GetSQLModeName() .. ": " .. tostring(int) .. " is not a number! return -1")

		return -1
	end
end

local _show_db_if_not_empty = false
function db_is_empty(db_name)
	local _tmp = YRP_SQL_SELECT(db_name, "*", nil)
	if YRPWORKED(_tmp, db_name .. " is empty!") then
		if _show_db_if_not_empty then
			YRP:msg("db", "[db_is_empty] " .. db_name)
			printTab(_tmp, db_name)
		end

		return false
	else
		return true
	end
end

function db_WORKED(query)
	if query == nil then
		return "worked"
	else
		return "not worked"
	end
end

-- NEW SQL API
YRPSQL = YRPSQL or {}
YRPSQL.int_mode = 0
function GetSQLMode()
	return tonumber(YRPSQL.int_mode)
end

function GetSQLModeName()
	if GetSQLMode() == 0 then
		return "SQLITE"
	elseif GetSQLMode() == 1 then
		return "MYSQL"
	end

	return "!BROKEN!"
end

function SetSQLMode(sqlmode, force)
	YRPSQL.int_mode = tonumber(sqlmode)
	if force then
		YRP:msg("db", "Update SQLMODE to: " .. YRPSQL.int_mode)
		local _q = "UPDATE "
		_q = _q .. "yrp_sql"
		_q = _q .. " SET " .. "int_mode = " .. YRPSQL.int_mode
		_q = _q .. " WHERE uniqueID = 1"
		_q = _q .. ";"
		sql.Query(_q)
	end
end

function YRP_SQL_TABLE_EXISTS(db_table)
	-- YRP:msg( "db", "YRP_SQL_TABLE_EXISTS( " .. tostring( db_table) .. " )" )
	if GetSQLMode() == 0 then
		local _r = YRP_SQL_SELECT(db_table, "*", nil)
		if _r == nil or istable(_r) then
			return true
		else
			return false
		end
		--YRP:msg( "note", "Table [" .. tostring( db_table) .. "] not exists." )
	elseif GetSQLMode() == 1 then
		local _r = YRP_SQL_SELECT(db_table, "*", nil)
		if _r == nil or istable(_r) then
			return true
		else
			return false
		end
	end
	--YRP:msg( "note", "Table [" .. tostring( db_table) .. "] not exists." )
end

function YRP_SQL_QUERY(query)
	query = tostring(query)
	--YRP:msg( "db", "YRP_SQL_QUERY( " .. tostring(query) .. " )" )
	if not string.find(query, ";", 1, true) then
		YRP:msg("error", GetSQLModeName() .. ": " .. "Query has no ; [" .. query .. "]")

		return false
	end

	if GetSQLMode() == 0 then
		local _result = sql.Query(query)
		if _result == nil then
			return _result
		elseif _result == false then
			return _result
		else
			return _result
		end
	elseif GetSQLMode() == 1 then
		if YRPSQL.db ~= nil then
			local que = YRPSQL.db:query(query)
			que.onError = function(q, e)
				if string.find(e, "Unknown column", 1, true) == nil and string.find(e, "doesn't exist", 1, true) == nil then
					YRP:msg("error", GetSQLModeName() .. ": " .. "YRP_SQL_QUERY - ERROR: " .. tostring(e) .. " lastError: " .. YRP_SQL_Show_Last_Error() .. " query: " .. tostring(query))
					q:error()
				end
			end

			que:start()
			que:wait(true)
			local _test = que:getData()
			if istable(_test) then
				if #_test == 0 then return nil end --YRP:msg( "db", "YRP_SQL_QUERY TABLE EMPTY 1" )

				return _test
			elseif _test == nil then
				return false
			else --YRP:msg( "db", "YRP_SQL_QUERY TABLE EMPTY 2" )
				YRP:msg("db", "YRP_SQL_QUERY TABLE MISSING ( " .. tostring(_test) .. " )")

				return false
			end
		else
			YRP:msg("db", "CURRENTLY NOT CONNECTED TO MYSQL SERVER")
		end
	end
end

function YRP_SQL_DROP_TABLE(db_table)
	local _result = YRP_SQL_QUERY("DROP TABLE " .. db_table .. ";")
	if _result ~= nil then
		YRP:msg("error", GetSQLModeName() .. ": " .. "YRP_SQL_DROP_TABLE " .. tostring(db_table) .. " failed! (result: " .. tostring(_result) .. " )")
		YRP_SQL_Show_Last_Error()
	else
		YRP:msg("db", "DROPPED " .. tostring(db_table) .. " TABLE")
	end
end

function YRP_SQL_CREATE_TABLE(db_table)
	YRP:msg("db", "Create Table ( " .. tostring(db_table) .. " )")
	if GetSQLMode() == 0 then
		local _q = "CREATE TABLE "
		_q = _q .. db_table .. " ( "
		_q = _q .. "uniqueID		INTEGER				 PRIMARY KEY autoincrement"
		_q = _q .. " )"
		_q = _q .. ";"
		local _result = YRP_SQL_QUERY(_q)

		return _result
	elseif GetSQLMode() == 1 then
		if YRPSQL.schema then
			local _q = "CREATE TABLE "
			_q = _q .. YRPSQL.schema .. "." .. db_table .. " ( "
			_q = _q .. "uniqueID		INTEGER				 PRIMARY KEY AUTO_INCREMENT"
			_q = _q .. " )"
			_q = _q .. ";"

			return YRP_SQL_QUERY(_q)
		else
			YRP:msg("note", "[YRP_SQL_CREATE_TABLE] " .. GetSQLModeName() .. ": " .. "SCHEMA IS BROKEN")
		end

		return nil
	end
end

function YRP_SQL_SELECT(db_table, db_columns, db_where, db_extra)
	--YRP:msg( "db", "YRP_SQL_SELECT( " .. tostring( db_table) .. ", " .. tostring( db_columns) .. ", " .. tostring( db_where) .. " )" )
	if GetSQLMode() == 0 then
		local _q = "SELECT "
		_q = _q .. db_columns
		_q = _q .. " FROM " .. tostring(db_table)
		if db_where ~= nil then
			_q = _q .. " WHERE "
			_q = _q .. db_where
		end

		if db_extra then
			_q = _q .. " " .. db_extra
		end

		_q = _q .. ";"

		return YRP_SQL_QUERY(_q)
	elseif GetSQLMode() == 1 then
		if YRPSQL.schema then
			local _q = "SELECT "
			_q = _q .. db_columns
			_q = _q .. " FROM " .. YRPSQL.schema .. "." .. tostring(db_table)
			if db_where ~= nil then
				_q = _q .. " WHERE "
				_q = _q .. db_where
			end

			if db_extra then
				_q = _q .. " " .. db_extra
			end

			_q = _q .. ";"

			return YRP_SQL_QUERY(_q)
		else
			YRP:msg("note", "[YRP_SQL_SELECT] " .. GetSQLModeName() .. ": " .. "SCHEMA IS BROKEN")

			return false
		end
	end
end

function YRP_SQL_UPDATE(db_table, db_sets, db_where)
	if db_sets == nil then
		YRP:msg("error", "YRP_SQL_UPDATE-ERROR db_sets == nil: " .. tostring(db_table))

		return false
	end

	local c = 0
	if _type(db_sets) == "string" then
		YRP:msg("error", "[YRP_SQL_UPDATE] FAIL: db_table " .. db_table .. " db_sets " .. db_sets .. " db_where " .. db_where)

		return
	end

	local tmp = {}
	for i, v in pairs(db_sets) do
		c = c + 1
		tmp[c] = i .. " = " .. YRP_SQL_STR_IN(v)
	end

	local sets = table.concat(tmp, ", ")
	if strEmpty(sets) and db_sets then
		YRP:msg("error", "YRP_SQL_UPDATE-ERROR: " .. table.ToString(db_sets, "db_sets", false))

		return false
	end

	if GetSQLMode() == 0 then
		local _q = "UPDATE "
		_q = _q .. db_table
		_q = _q .. " SET " .. sets
		if db_where ~= nil then
			_q = _q .. " WHERE "
			_q = _q .. db_where
		end

		_q = _q .. ";"
		local ret = YRP_SQL_QUERY(_q)
		if ret ~= nil then
			YRP:msg("error", GetSQLModeName() .. ": " .. "YRP_SQL_UPDATE: has failed! query: " .. tostring(_q) .. " result: " .. tostring(ret) .. " lastError: " .. YRP_SQL_Show_Last_Error())
		end

		return ret
	elseif GetSQLMode() == 1 then
		if YRPSQL.schema then
			local _q = "UPDATE "
			_q = _q .. YRPSQL.schema .. "." .. db_table
			_q = _q .. " SET " .. sets
			if db_where ~= nil then
				_q = _q .. " WHERE "
				_q = _q .. db_where
			end

			_q = _q .. ";"

			return YRP_SQL_QUERY(_q)
		else
			YRP:msg("note", "[YRP_SQL_UPDATE] " .. GetSQLModeName() .. ": " .. "SCHEMA IS BROKEN")
		end
	end
end

function YRP_SQL_INSERT_INTO(db_table, db_columns, db_values)
	YRP:msg("debug", "YRP_SQL_INSERT_INTO( " .. tostring(db_table) .. " | " .. tostring(db_columns) .. " | " .. tostring(db_values) .. " )")
	if GetSQLMode() == 0 then
		if YRP_SQL_TABLE_EXISTS(db_table) then
			local _q = "INSERT INTO "
			_q = _q .. db_table
			_q = _q .. " ( "
			_q = _q .. db_columns
			_q = _q .. " ) VALUES ( "
			_q = _q .. db_values
			_q = _q .. " );"
			local _result = YRP_SQL_QUERY(_q)
			if _result ~= nil then
				YRP:msg("error", GetSQLModeName() .. ": " .. "YRP_SQL_INSERT_INTO: has failed! query: " .. tostring(_q) .. " result: " .. tostring(_result) .. " lastError: " .. YRP_SQL_Show_Last_Error())
			end

			return _result
		end
	elseif GetSQLMode() == 1 then
		if YRP_SQL_TABLE_EXISTS(db_table) then
			local _q = "INSERT INTO "
			_q = _q .. db_table
			_q = _q .. " ( "
			_q = _q .. db_columns
			_q = _q .. " ) VALUES ( "
			_q = _q .. db_values
			_q = _q .. " );"
			local _result = YRP_SQL_QUERY(_q)
			if _result ~= nil then
				YRP:msg("error", GetSQLModeName() .. ": " .. "YRP_SQL_INSERT_INTO: has failed! query: " .. tostring(_q) .. " result: " .. tostring(_result) .. " lastError: " .. YRP_SQL_Show_Last_Error())
			end

			return _result
		end
	end
end

function YRP_SQL_INSERT_INTO_DEFAULTVALUES(db_table)
	--YRP:msg( "db", "YRP_SQL_INSERT_INTO_DEFAULTVALUES( " .. tostring( db_table) .. " )" )
	if GetSQLMode() == 0 then
		if YRP_SQL_TABLE_EXISTS(db_table) then
			local _q = "INSERT INTO "
			_q = _q .. db_table
			_q = _q .. " DEFAULT VALUES;"
			local _result = YRP_SQL_QUERY(_q)
			if _result ~= nil then
				YRP:msg("error", GetSQLModeName() .. ": " .. "YRP_SQL_INSERT_INTO_DEFAULTVALUES failed! query: " .. tostring(_q) .. " result: " .. tostring(_result) .. " lastError: " .. YRP_SQL_Show_Last_Error())
			end

			return _result
		end
	elseif GetSQLMode() == 1 then
		if YRP_SQL_TABLE_EXISTS(db_table) then
			local _result = YRP_SQL_QUERY("INSERT INTO " .. db_table .. " VALUES();")
			if _result ~= nil then
				YRP:msg("error", GetSQLModeName() .. ": " .. "YRP_SQL_INSERT_INTO_DEFAULTVALUES failed! result: " .. tostring(_result) .. " lastError: " .. YRP_SQL_Show_Last_Error())
			end

			return _result
		end
	end
end

function YRP_SQL_DELETE_FROM(db_table, db_where)
	if GetSQLMode() == 0 then
		if YRP_SQL_TABLE_EXISTS(db_table) then
			local _q = "DELETE FROM "
			_q = _q .. db_table
			if db_where ~= nil then
				_q = _q .. " WHERE "
				_q = _q .. db_where
				_q = _q .. ";"
			end

			local _result = YRP_SQL_QUERY(_q)
			if _result ~= nil then
				YRP:msg("error", GetSQLModeName() .. ": " .. "YRP_SQL_DELETE_FROM: has failed! query: " .. tostring(_q) .. " result: " .. tostring(_result) .. " lastError: " .. YRP_SQL_Show_Last_Error())
			end
		end
	elseif GetSQLMode() == 1 then
		if YRP_SQL_TABLE_EXISTS(db_table) then
			local _q = "DELETE FROM "
			_q = _q .. db_table
			if db_where ~= nil then
				_q = _q .. " WHERE "
				_q = _q .. db_where
				_q = _q .. ";"
			end

			local _result = YRP_SQL_QUERY(_q)
			if _result ~= nil then
				YRP:msg("error", GetSQLModeName() .. ": " .. "YRP_SQL_DELETE_FROM: has failed! query: " .. tostring(_q) .. " result: " .. tostring(_result))
			end
		end
	end
end

function YRP_SQL_CHECK_IF_COLUMN_EXISTS(db_table, column_name)
	--YRP:msg( "db", "YRP_SQL_CHECK_IF_COLUMN_EXISTS( " .. tostring( db_table) .. ", " .. tostring( column_name) .. " )" )
	if GetSQLMode() == 0 then
		local _result = YRP_SQL_SELECT(db_table, column_name, nil)
		if _result == false then
			return false
		else
			return true
		end
	elseif GetSQLMode() == 1 then
		local _result = YRP_SQL_SELECT(db_table, column_name, nil)
		if _result == false then
			return false
		else
			return true
		end
	end
end

function YRP_SQL_HAS_COLUMN(db_table, column_name)
	if YRPSQL.schema then
		local _r = YRP_SQL_QUERY("SHOW COLUMNS FROM " .. YRPSQL.schema .. "." .. tostring(db_table) .. " LIKE '" .. column_name .. "';")

		return _r
	else
		YRP:msg("note", "[YRP_SQL_HAS_COLUMN] " .. GetSQLModeName() .. ": " .. "SCHEMA IS BROKEN")

		return false
	end
end

function YRP_SQL_ADD_COLUMN(db_table, column_name, datatype)
	if GetSQLMode() == 0 then
		local _q = "ALTER TABLE " .. db_table .. " ADD " .. column_name .. " " .. datatype .. ";"
		local _r = YRP_SQL_QUERY(_q)

		return _r
	elseif GetSQLMode() == 1 then
		if string.find(datatype, "TEXT", 1, true) then
			datatype = string.Replace(datatype, "TEXT", "VARCHAR(255)")
		end

		local _r = nil
		if not YRP_SQL_HAS_COLUMN(db_table, column_name) then
			if YRPSQL.schema then
				local _q = "ALTER TABLE " .. YRPSQL.schema .. "." .. tostring(db_table) .. " ADD " .. column_name .. " " .. datatype .. ";" -- FAST
				_r = YRP_SQL_QUERY(_q)
			else
				YRP:msg("note", "[YRP_SQL_ADD_COLUMN] #1 " .. GetSQLModeName() .. ": " .. "SCHEMA IS BROKEN")

				return false
			end
		else
			if YRPSQL.schema then
				local _q = "ALTER TABLE " .. YRPSQL.schema .. "." .. tostring(db_table) .. " CHANGE " .. column_name .. " " .. column_name .. " " .. datatype .. ";" -- SLOW
				_r = YRP_SQL_QUERY(_q)
			else
				YRP:msg("note", "[YRP_SQL_ADD_COLUMN] #2 " .. GetSQLModeName() .. ": " .. "SCHEMA IS BROKEN")

				return false
			end
		end

		return _r
	end
end

timer.Simple(
	0.0,
	function()
		if SERVER then
			function YRPCheckSQL()
				local _sql_settings = sql.Query("SELECT * FROM yrp_sql")
				if IsNotNilAndNotFalse(_sql_settings) then
					_sql_settings = _sql_settings[1]
					YRPSQL.schema = _sql_settings.string_database
					SetSQLMode(_sql_settings.int_mode)
				end

				if GetSQLMode() == 1 then
					YRP:msg("db", "Connect to MYSQL Database")
					-- MYSQL
					if file.Find("bin/gmsv_mysqloo_linux.dll", "LUA") == nil and file.Find("bin/gmsv_mysqloo_win32.dll", "LUA") == nil then
						MsgC(Color(0, 255, 0), "Module not found, download it via yourrp discord!\n")
						YRPSQL.mysql_worked = false
						SetSQLMode(0, true)

						return
					end

					if system.IsLinux() and (not file.Exists("bin/gmsv_mysqloo_linux.dll", "LUA") or not file.Exists("bin/gmsv_mysqloo_linux64.dll", "LUA")) then
						if not file.Exists("bin/gmsv_mysqloo_linux.dll", "LUA") then
							MsgC(Color(255, 0, 0), "MISSING FILE FOR MYSQL: lua/bin/gmsv_mysqloo_linux.dll", "\n")
						end

						if not file.Exists("bin/gmsv_mysqloo_linux64.dll", "LUA") then
							MsgC(Color(255, 0, 0), "MISSING FILE FOR MYSQL: lua/bin/gmsv_mysqloo_linux64.dll", "\n")
						end

						YRPSQL.outdated = true
					elseif system.IsWindows() and (not file.Exists("bin/gmsv_mysqloo_win32.dll", "LUA") or not file.Exists("bin/gmsv_mysqloo_win64.dll", "LUA")) then
						if not file.Exists("bin/gmsv_mysqloo_win32.dll", "LUA") then
							MsgC(Color(255, 0, 0), "MISSING FILE FOR MYSQL: lua/bin/gmsv_mysqloo_win32.dll", "\n")
						end

						if not file.Exists("bin/gmsv_mysqloo_win64.dll", "LUA") then
							MsgC(Color(255, 0, 0), "MISSING FILE FOR MYSQL: lua/bin/gmsv_mysqloo_win64.dll", "\n")
						end

						YRPSQL.outdated = true
					else
						MsgC(Color(0, 255, 0), "LOAD MODULE MYSQLOO!\n")
						require("mysqloo")
						if mysqloo.VERSION ~= "9" or not mysqloo.MINOR_VERSION or tonumber(mysqloo.MINOR_VERSION) < 1 then
							MsgC(Color(0, 255, 0), "You are using an outdated mysqloo version (9.7.6)\n")
							MsgC(Color(0, 255, 0), "Download the latest MYSQLOO 9 from here\n")
							MsgC(Color(86, 156, 214), "https://github.com/syl0r/MySQLOO/releases\n")
							YRPSQL.outdated = true
						end
					end

					if not YRPSQL.outdated then
						YRPSQL.mysql_worked = false
						timer.Simple(
							20,
							function()
								if not YRPSQL.mysql_worked then
									YRP:msg("note", "Took to long to connect to mysql server, switch back to sqlite")
									SetSQLMode(0, true)
								end
							end
						)

						YRP:msg("db", "Connection info:")
						YRP:msg("db", "Hostname: " .. _sql_settings.string_host)
						YRP:msg("db", "Username: " .. _sql_settings.string_username)
						YRP:msg("note", "Password: " .. _sql_settings.string_password .. " (DON'T SHOW THIS TO OTHERS)")
						YRP:msg("db", "Database/Schema: " .. _sql_settings.string_database)
						YRP:msg("db", "Port: " .. _sql_settings.int_port)
						YRP:msg("db", "Setup MYSQL Connection-Table")
						YRPSQL.db = mysqloo.connect(_sql_settings.string_host, _sql_settings.string_username, _sql_settings.string_password, _sql_settings.string_database, tonumber(_sql_settings.int_port))
						YRPSQL.db.onConnected = function()
							YRP:msg("note", ">>> CONNECTED! <<<")
							YRPSQL.mysql_worked = true
							SetSQLMode(1)
						end

						--YRP_SQL_QUERY( "SET @@global.sql_mode='MYSQL40'" )
						YRPSQL.db.onConnectionFailed = function(db, serr)
							YRP:msg("note", ">>> CONNECTION failed (propably wrong connection info or server offline), changing to SQLITE!")
							YRP:msg("error", "[MYSQL onConnectionFailed] " .. tostring(serr))
							SetSQLMode(0, true)
						end

						YRP:msg("db", ">>> Connect to MYSQL Server, if stuck => connection info is wrong or server offline! ( default mysql port: 3306)")
						YRPSQL.db:connect()
						YRPSQL.db:wait()
					end
				end
			end

			YRPCheckSQL()
		end

		YRP:msg("db", "Current SQL Mode: " .. GetSQLModeName())
	end
)

function YRPTryRepairDatabase()
	YRP:msg("db", "ERROR!!! >> retry Load Database in 10sec <<")
	YRP:msg("db", "ERROR!!! >> Your database is maybe broken! <<")
	if timer.Exists("retryLoadDatabase") then
		timer.Remove("retryLoadDatabase")
	end

	local integrity_check = sql.Query("pragma integrity_check;")
	YRP:msg("db", "Integrity_check: " .. tostring(integrity_check))
	local nodes = sql.Query("reindex nodes;")
	YRP:msg("db", "Nodes: " .. tostring(nodes))
	local pristine = sql.Query("reindex pristine;")
	YRP:msg("db", "Pristine: " .. tostring(pristine))
	timer.Create(
		"retryLoadDatabase",
		10,
		1,
		function()
			db_init_database()
			timer.Remove("retryLoadDatabase")
		end
	)
end

function YRP_SQL_INIT_DATABASE(db_name)
	--YRP:msg( "db", "YRP_SQL_INIT_DATABASE( " .. tostring( db_name) .. " )" )
	if GetSQLMode() == 0 then
		if not YRP_SQL_TABLE_EXISTS(db_name) then
			local _result = YRP_SQL_CREATE_TABLE(db_name)
			if not YRP_SQL_TABLE_EXISTS(db_name) then
				YRP:msg("error", GetSQLModeName() .. ": " .. "CREATE TABLE " .. tostring(db_name) .. " (table not exists) lastError: " .. YRP_SQL_Show_Last_Error())
				YRPTryRepairDatabase(db_name)
			end
		end
	elseif GetSQLMode() == 1 then
		if not YRP_SQL_TABLE_EXISTS(db_name) then
			local _result = YRP_SQL_CREATE_TABLE(db_name)
			if not YRP_SQL_TABLE_EXISTS(db_name) then
				YRP:msg("error", GetSQLModeName() .. ": " .. "CREATE TABLE " .. tostring(db_name) .. " fail")
				YRP_SQL_Show_Last_Error()
				YRPTryRepairDatabase(db_name)
			end
		end
	end
end
